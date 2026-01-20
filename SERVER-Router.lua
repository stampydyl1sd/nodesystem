-----------------------------------------------------------------------------------------------------------**++/\

-- rbx.lua Framework [2021] - [2026]
-- Written by Dylan - Written with a Mechanical Keyboard and a pinch of magic.

-- NOTE: Please do not touch anything in this script UNLESS you know what it does!
--		 If you are stuck or a bug occurs, please contact stampydyl1 on Discord :D

-- SERVER - Router ||| This script holds all functions of getting the main CNS system to communicate with the Client in order to keep things in check and secure.
--					   Everything has been made to be fully optimised / best it can be :D

-----------------------------------------------------------------------------------------------------------**++/\

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Routes = require(ReplicatedStorage["CNS - CLIENT"]:WaitForChild("_RoutesModule"))
local RouteRender = ReplicatedStorage["CNS - CLIENT"]:WaitForChild("RouteRender")
local RequestRoute = ReplicatedStorage["CNS - CLIENT"]:WaitForChild("RequestRoute")

-----------------------------------------------------------------------------------------------------------**++/\

local function numericIndex(name: string)
	return tonumber(name:match("%d+")) or math.huge
end

-----------------------------------------------------------------------------------------------------------**++/\

local function getRoutePositions(routeFolder: Instance)
	local pts = {}
	for _, inst in ipairs(routeFolder:GetChildren()) do
		if inst:IsA("BasePart") then
			table.insert(pts, inst)
		end
	end

	table.sort(pts, function(a, b)
		return numericIndex(a.Name) < numericIndex(b.Name)
	end)

	local positions = table.create(#pts)
	for i, p in ipairs(pts) do
		positions[i] = p.Position
	end
	return positions
end

-----------------------------------------------------------------------------------------------------------**++/\

RequestRoute.OnServerEvent:Connect(function(player, routeId)
	print("Received request: ", routeId)
	
	if typeof(routeId) ~= "string" then return warn("CNS | Route ID must be a string!") end
	if not Routes:IsValid(routeId) then return warn("CNS | Route not in system: ", routeId) end
	
	local routeDef = Routes:Get(routeId)
	local splineFolder = workspace.RoadSplines:WaitForChild(routeDef.SplineFolder)
	local positions = getRoutePositions(splineFolder)
	
	RouteRender:FireClient(player, routeDef.Name, positions)
	print("Sent route: ", routeDef)	
end)

-----------------------------------------------------------------------------------------------------------**++/\
