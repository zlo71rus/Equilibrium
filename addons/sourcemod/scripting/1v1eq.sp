#pragma semicolon 1
 
#include <sourcemod>
#include <sdktools>
#include <colors>

new const String:SI_Names[][] =
{
	"Unknown",
	"Smoker",
	"Boomer",
	"Hunter",
	"Spitter",
	"Jockey",
	"Charger",
	"Witch",
	"Tank",
	"Not SI"
};

new Handle:hCvarDmgThreshold;
//add blade to contributors for eq
public Plugin:myinfo =
{
	name = "1v1 EQ",
	author = "Blade + Confogl Team, Tabun, Visor",
	description = "A plugin designed to support 1v1.",
	version = "0.1",
	url = "https://github.com/Attano/Equilibrium"
};

public OnPluginStart()
{      
	hCvarDmgThreshold = CreateConVar("sm_1v1_dmgthreshold", "24", "Amount of damage done (at once) before SI suicides.", FCVAR_PLUGIN, true, 1.0);

	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Post);
}
 
public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientAndInGame(attacker))
		return;

	new damage = GetEventInt(event, "dmg_health");
	new zombie_class = GetZombieClass(attacker);

	if (GetClientTeam(attacker) == 3 && zombie_class != 8 && damage >= GetConVarInt(hCvarDmgThreshold))
	{
		new remaining_health = GetClientHealth(attacker);
		CPrintToChatAll("[{olive}EQ 1v1{default}] {red}%N{default}({green}%s{default}) had {olive}%d{default} health remaining!", attacker, SI_Names[zombie_class], remaining_health);

		ForcePlayerSuicide(attacker);    

		if (remaining_health == 1)
		{
			CPrintToChat(victim, "You don't have to be mad...");
		}
	}
}

stock GetZombieClass(client) return GetEntProp(client, Prop_Send, "m_zombieClass");

stock bool:IsClientAndInGame(index)
{
	if (index > 0 && index < MaxClients)
	{
		return IsClientInGame(index);
	}
	return false;
}