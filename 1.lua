local runService                = game:GetService("RunService")
local replicatedStorage         = game:GetService("ReplicatedStorage")
local players                   = game:GetService("Players")
local localPlayer               = players.LocalPlayer
local camera                    = workspace.CurrentCamera

local screenSize                = camera.ViewportSize
local cameraFrustumHeightScale  = math.tan(math.deg(camera.FieldOfView / 2))
local cameraFrustumWidthScale   = cameraFrustumHeightScale * screenSize.x/screenSize.y

camera.Changed:Connect(function()
   task.wait()
   screenSize = camera.ViewportSize
   cameraFrustumHeightScale  = math.tan(math.rad(camera.FieldOfView / 2))
   cameraFrustumWidthScale   = cameraFrustumHeightScale * screenSize.x/screenSize.y
end)

local drawingPool               = {}
local maxNadePerPlayer          = 3

local char, netFuncs
local newgrenadeFunc, newgrenadeIdx

local Maid      = loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Maid.lua"))()
local imageUrl  = game:HttpGet("https://i.imgur.com/3HGuyVa.png") --thanks bbot

for i,v in next, getgc(true) do
   local t = type(v)
   if t == "table" then
       if rawget(v, "jump") then
           char = v
       end
   elseif t == "function" then
       local info = debug.getinfo(v)
       if info.name == "call" and info.source:find("network") then
           netFuncs = debug.getupvalue(v, 1)
           for i2,v2 in next, netFuncs do
               local const = debug.getconstants(v2)
               if table.find(const, "Indicator") and table.find(const, "Ticking") then
                   newgrenadeFunc, newgrenadeIdx = v2, i2
               end
           end
       end
   end
end

local function translateToScreenSpace(worldPos)
   local relativePos = camera.CFrame:PointToObjectSpace(worldPos)
   local depth = -relativePos.z
   local rX, rY = relativePos.x, relativePos.y
   local pX, pY = 0.5 + 0.5*rX/(cameraFrustumWidthScale*depth), 0.5 - 0.5*rY/(cameraFrustumHeightScale*depth)
   return Vector3.new(screenSize.x*pX, screenSize.y*pY, depth), depth > 0 and pX >= 0 and pX = 0 and pY <= 1
end


local function lerp(a, b, t)
   if t = 1 then
           return drawing.maid:DoCleaning()
       end

       if char.rootpart then
           local nadeTrans = 1
           local direction = endPos - char.rootpart.Position
           local distance = direction.Magnitude

           if distance > blastRadius then
               nadeTrans = 1 - map(distance, blastRadius, blastRadius + 40, 0, 1)
           end

           local objects = drawing.objects
           local mainSquareOutline = objects.mainSquareOutline
           local upperBorder = objects.upperBorder
           local nadeLogo = objects.nadeLogo
           local nadeTypeText = objects.nadeTypeText
           local damageText = objects.damageText
           local secondsRemainingText = objects.secondsRemainingText
           local timerOutline = objects.timerOutline
           local timerSquare = objects.timerSquare

           local pos, onScreen = translateToScreenSpace(endPos)


           local secondsRemaining = math.floor((1 - percentage)*data.blowuptime*10)/10
           local nadeDamage = "Safe"
           if not workspace:FindPartOnRayWithWhitelist(Ray.new(char.rootpart.Position, direction), {workspace.Map}, true) then
               if distance < r1 then
                   nadeDamage = distance < r0 and d0 or (distance = char.gethealth() then
                       nadeDamage = "LETHAL!"
                   else
                       nadeDamage = "-" .. tostring(math.floor(nadeDamage)) .. "HP"
                   end
               end
           end

           nadeTypeText.Text = fragName
           damageText.Text = nadeDamage
           secondsRemainingText.Text = tostring(secondsRemaining)

           timerSquare.Size = Vector2.new(40 * (1 - percentage), 2)
           timerSquare.Color = Color3.fromRGB(0, 255, 0):Lerp(Color3.fromRGB(255, 0, 0), percentage)

           local size = Vector2.new(nadeTypeText.TextBounds.x + damageText.TextBounds.x + secondsRemainingText.TextBounds.x, nadeTypeText.TextBounds.y + damageText.TextBounds.y + secondsRemainingText.TextBounds.y - 4)
           local ultimateSize = size + Vector2.new(nadeLogo.Size.x, 11)

           if not onScreen or math.floor(pos.x) >= ((screenSize.x - 10) - ultimateSize.x) or math.floor(pos.y) >= ((screenSize.y - 10) - ultimateSize.y) then
               local rX = cameraFrustumWidthScale * ((2*pos.x)/screenSize.x - 1) * pos.z
               local rY = cameraFrustumHeightScale * (1 - (2*pos.y)/(screenSize.y)) * pos.z

               --t0ny math begin
               local widthEdge, heightEdge = rX < 0 and 10 or ((screenSize.x - 10) - ultimateSize.x), -rY  0 and newY < ((screenSize.y - 10) - ultimateSize.y) then
                   pos = Vector2.new(widthEdge, newY)
               else
                   pos = Vector2.new((m - rX*heightEdge)/rY, heightEdge)
               end
               --t0ny math end
           end

           pos = Vector2.new(math.floor(pos.x), math.floor(pos.y))

           mainSquareOutline.Position = pos
           upperBorder.Position = mainSquareOutline.Position + Vector2.new(1, 1)

           mainSquareOutline.Size = ultimateSize
           upperBorder.Size = Vector2.new(mainSquareOutline.Size.x - 2, 2)

           nadeLogo.Position = mainSquareOutline.Position + Vector2.new(0, 4)

           local startingPos = nadeLogo.Position + Vector2.new(nadeLogo.Size.x + 1, 0)

           nadeTypeText.Position = startingPos
           damageText.Position = nadeTypeText.Position + Vector2.new(0, nadeTypeText.TextBounds.y - 2)
           secondsRemainingText.Position = damageText.Position + Vector2.new(0, damageText.TextBounds.y - 2)
           timerOutline.Position = secondsRemainingText.Position + Vector2.new(0, secondsRemainingText.TextBounds.y)
           timerSquare.Position = timerOutline.Position + Vector2.new(1, 1)


           timerOutline.Size = Vector2.new(42, 4)
           nadeLogo.Position = Vector2.new(startingPos.x - nadeLogo.Size.x, startingPos.y + math.floor((size.y - nadeLogo.Size.y + timerOutline.Size.y)/2))
           for i,v in next, objects do
               v.Visible = true
               v.Transparency = nadeTrans
           end
       else
           for i,v in next, drawing.objects do
               v.Visible = false
           end
       end
   end))

   drawing.maid:GiveTask(function()
       drawing.used = false
       for i,v in next, drawing.objects do
           v.Visible = false
       end
   end)

end