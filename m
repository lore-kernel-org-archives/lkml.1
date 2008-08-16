Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYHPK0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYHPK0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHPK0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:26:25 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:65027 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYHPK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:26:23 -0400
Message-ID: <e700089d0808160326k337cec2dm65271b38812a4263@mail.gmail.com>
Date: Sat, 16 Aug 2008 06:26:20 -0400
From: "Yousaf Jindal" <yousaf.jindal@pi.edu.pk>
To: tomas.winkler@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
In-Reply-To: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 4:07 PM, Yousaf Jindal <yousaf.jindal@pi.edu.pk> wrote:
>> On 00:11 Thu 14 Aug     , Tomas Winkler wrote:
>>> Intel would like to announce Linux support  for Wifi Link 5000 and
>>> 5100 Series Adapters under iwlwifi driver (iwlagn.ko)
>>>
>> ...
>>> The best known working driver can be located in iwl500 branch of
>>> iwlwifi-2.6.git
>>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git iwl5000
>
>
>
> I am using the iwl500 branch from the above git repository and I am
> also receiving the timeout error. This is on a Wifi Link 5100 on an
> Asus M50VM laptop.
>
> $ dmesg|grep iw
>
>
> -- Yousaf
>
> --
> Yousaf Jindal
> Director of Technology
> Pakistani Institute
>

Here is a kernel log with full debugging output enabled for the iwl drivers:

[    8.881684] asus-laptop:   M50Vm model detected
[    8.901015] acpi device:1e: registered as cooling_device2
[    8.901307] input: Video Bus as /class/input/input7
[    8.902500] Registered led device: asus::mail
[    8.902689] Registered led device: asus::touchpad
[    8.964753] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    9.030505] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
Linux, 1.3.27kds
[    9.030709] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.030944] ieee80211 phy0: U iwl4965_pci_probe *** LOAD DRIVER ***
[    9.031165] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.031378] iwlagn 0000:03:00.0: setting latency timer to 64
[    9.031403] ieee80211 phy0: U iwl4965_pci_probe pci_resource_len = 0x00002000
[    9.031588] ieee80211 phy0: U iwl4965_pci_probe pci_resource_base =
ffffc2000065c000
[    9.031821] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[    9.032029] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x20000000) = 0x27800200
[    9.032252] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x00800000) = 0x27800200
[    9.032508] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000240,
0xFFFF0000) = 0xFFFF0500
[    9.032736] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00080000) = 0x00080000
[    9.032972] ieee80211 phy0: U __iwl_set_bit set_bit(0x0000020C,
0x00880300) = 0x00880300
[    9.033215] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000024,
0x00000004) = 0x080003D4
[    9.043384] ieee80211 phy0: U __iwl_poll_bit poll_bit(0x00000024,
0x00000001, 0x00000001) - - drivers/net/wireless/iwlwifi/iwl-5000.c
112
[    9.043590] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 118
[    9.043868] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 131
[    9.044076] ieee80211 phy0: U __iwl_read32
read_direct32(0x00000030) - drivers/net/wireless/iwlwifi/iwl-eeprom.c
213
[    9.044286] ieee80211 phy0: U __iwl_read32
read_direct32(0x00000030) - drivers/net/wireless/iwlwifi/iwl-eeprom.c
147
[    9.044496] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00200000) = 0x00280000
[    9.044702] ieee80211 phy0: U __iwl_poll_bit poll_bit(0x00000000,
0x00200000, 0x00200000) - - drivers/net/wireless/iwlwifi/iwl-eeprom.c
176
[    9.044913] ieee80211 phy0: U iwlcore_eeprom_acquire_semaphore
Acquired semaphore after 1 tries.
[    9.067496] ieee80211 phy0: U __iwl_clear_bit clear_bit(0x00000000,
0x00200000) = 0x00080000
[    9.067700] ieee80211 phy0: U iwl4965_pci_probe MAC address:
00:16:ea:65:05:b8
[    9.067900] ieee80211 phy0: U iwl_set_rxon_chain rx chain 2806
[    9.068082] ieee80211 phy0: U iwl_reset_qos set QoS to default
[    9.068267] ieee80211 phy0: U iwl_init_channel_map Initializing
regulatory info from EEPROM
[    9.068467] ieee80211 phy0: U iwl_init_channel_map Parsing data for
56 channels.
[    9.068668] ieee80211 phy0: U iwl_init_channel_map Ch. 1 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.068874] ieee80211 phy0: U iwl_init_channel_map Ch. 2 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.069085] ieee80211 phy0: U iwl_init_channel_map Ch. 3 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.069289] ieee80211 phy0: U iwl_init_channel_map Ch. 4 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.069492] ieee80211 phy0: U iwl_init_channel_map Ch. 5 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.069696] ieee80211 phy0: U iwl_init_channel_map Ch. 6 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.069899] ieee80211 phy0: U iwl_init_channel_map Ch. 7 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.070181] ieee80211 phy0: U iwl_init_channel_map Ch. 8 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.070385] ieee80211 phy0: U iwl_init_channel_map Ch. 9 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.070588] ieee80211 phy0: U iwl_init_channel_map Ch. 10 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.070792] ieee80211 phy0: U iwl_init_channel_map Ch. 11 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.070998] ieee80211 phy0: U iwl_init_channel_map Ch. 12 [2.4GHz]
VALID WIDE (0x61 15dBm): Ad-Hoc not supported
[    9.071200] ieee80211 phy0: U iwl_init_channel_map Ch. 13 [2.4GHz]
VALID WIDE (0x61 15dBm): Ad-Hoc not supported
[    9.071403] ieee80211 phy0: U iwl_init_channel_map Ch. 14 Flags 0
[2.4GHz] - No traffic
[    9.071601] ieee80211 phy0: U iwl_init_channel_map Ch. 183 Flags 0
[5.2GHz] - No traffic
[    9.071800] ieee80211 phy0: U iwl_init_channel_map Ch. 184 Flags 0
[5.2GHz] - No traffic
[    9.072001] ieee80211 phy0: U iwl_init_channel_map Ch. 185 Flags 0
[5.2GHz] - No traffic
[    9.072201] ieee80211 phy0: U iwl_init_channel_map Ch. 187 Flags 0
[5.2GHz] - No traffic
[    9.082868] ieee80211 phy0: U iwl_init_channel_map Ch. 188 Flags 0
[5.2GHz] - No traffic
[    9.098864] ieee80211 phy0: U iwl_init_channel_map Ch. 189 Flags 0
[5.2GHz] - No traffic
[    9.099063] ieee80211 phy0: U iwl_init_channel_map Ch. 192 Flags 0
[5.2GHz] - No traffic
[    9.099262] ieee80211 phy0: U iwl_init_channel_map Ch. 196 Flags 0
[5.2GHz] - No traffic
[    9.099461] ieee80211 phy0: U iwl_init_channel_map Ch. 7 Flags 0
[5.2GHz] - No traffic
[    9.099660] ieee80211 phy0: U iwl_init_channel_map Ch. 8 Flags 0
[5.2GHz] - No traffic
[    9.099858] ieee80211 phy0: U iwl_init_channel_map Ch. 11 Flags 0
[5.2GHz] - No traffic
[    9.100059] ieee80211 phy0: U iwl_init_channel_map Ch. 12 Flags 0
[5.2GHz] - No traffic
[    9.100258] ieee80211 phy0: U iwl_init_channel_map Ch. 16 Flags 0
[5.2GHz] - No traffic
[    9.100457] ieee80211 phy0: U iwl_init_channel_map Ch. 34 Flags 0
[5.2GHz] - No traffic
[    9.100656] ieee80211 phy0: U iwl_init_channel_map Ch. 36 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    9.100861] ieee80211 phy0: U iwl_init_channel_map Ch. 38 Flags 0
[5.2GHz] - No traffic
[    9.101060] ieee80211 phy0: U iwl_init_channel_map Ch. 40 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    9.101265] ieee80211 phy0: U iwl_init_channel_map Ch. 42 Flags 0
[5.2GHz] - No traffic
[    9.101465] ieee80211 phy0: U iwl_init_channel_map Ch. 44 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    9.101670] ieee80211 phy0: U iwl_init_channel_map Ch. 46 Flags 0
[5.2GHz] - No traffic
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 48 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 52 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 56 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 60 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 64 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 100 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 104 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 108 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 112 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 116 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 120 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 124 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 128 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 132 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 136 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 140 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 145 Flags 0
[5.2GHz] - No traffic
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 149 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 153 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 157 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 161 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_init_channel_map Ch. 165 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    9.101871] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 1
[2.4GHz] IBSS ACTIVE WIDE (0x6f 10dBm): Ad-Hoc supported
[    9.101871] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 5
[2.4GHz] IBSS ACTIVE WIDE (0x6f 10dBm): Ad-Hoc supported
[    9.101871] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 2
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.102085] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 6
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.102288] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 3
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.102492] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 7
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.102697] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 4
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.102900] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 8
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.103103] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 5
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.103306] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 9
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.103510] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 6
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.103717] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 10
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    9.103920] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 7
[2.4GHz] IBSS ACTIVE WIDE (0x6f 13dBm): Ad-Hoc supported
[    9.104033] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 11
[2.4GHz] IBSS ACTIVE WIDE (0x6f 13dBm): Ad-Hoc supported
[    9.104033] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 36
[5.2GHz] WIDE DFS (0xe1 14dBm): Ad-Hoc not supported
[    9.104033] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 40
[5.2GHz] WIDE DFS (0xe1 14dBm): Ad-Hoc not supported
[    9.104033] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 44
[5.2GHz] WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    9.104036] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 48
[5.2GHz] WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    9.104128] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 52
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.104128] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 56
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.104128] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 60
[5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[    9.104128] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 64
[5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[    9.104337] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 100
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.104541] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 104
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.104744] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 108
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.104948] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 112
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.105153] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 116
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.105357] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 120
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.105560] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 124
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.105764] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 128
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.105968] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 132
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.106174] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 136
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    9.106544] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 149
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    9.106749] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 153
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    9.106955] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 157
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    9.107160] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 161
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    9.107370] ieee80211 phy0: U iwlcore_init_geos Channel 1
Freq=2412[2.4GHz] valid flag=0x20
[    9.107583] ieee80211 phy0: U iwlcore_init_geos Channel 2
Freq=2417[2.4GHz] valid flag=0x20
[    9.107782] ieee80211 phy0: U iwlcore_init_geos Channel 3
Freq=2422[2.4GHz] valid flag=0x20
[    9.107985] ieee80211 phy0: U iwlcore_init_geos Channel 4
Freq=2427[2.4GHz] valid flag=0x20
[    9.108192] ieee80211 phy0: U iwlcore_init_geos Channel 5
Freq=2432[2.4GHz] valid flag=0x0
[    9.108392] ieee80211 phy0: U iwlcore_init_geos Channel 6
Freq=2437[2.4GHz] valid flag=0x0
[    9.108591] ieee80211 phy0: U iwlcore_init_geos Channel 7
Freq=2442[2.4GHz] valid flag=0x0
[    9.108791] ieee80211 phy0: U iwlcore_init_geos Channel 8
Freq=2447[2.4GHz] valid flag=0x10
[    9.108991] ieee80211 phy0: U iwlcore_init_geos Channel 9
Freq=2452[2.4GHz] valid flag=0x10
[    9.109192] ieee80211 phy0: U iwlcore_init_geos Channel 10
Freq=2457[2.4GHz] valid flag=0x10
[    9.109392] ieee80211 phy0: U iwlcore_init_geos Channel 11
Freq=2462[2.4GHz] valid flag=0x10
[    9.109591] ieee80211 phy0: U iwlcore_init_geos Channel 12
Freq=2467[2.4GHz] valid flag=0x36
[    9.109791] ieee80211 phy0: U iwlcore_init_geos Channel 13
Freq=2472[2.4GHz] valid flag=0x36
[    9.109993] ieee80211 phy0: U iwlcore_init_geos Channel 36
Freq=5180[5.2GHz] valid flag=0x26
[    9.110194] ieee80211 phy0: U iwlcore_init_geos Channel 40
Freq=5200[5.2GHz] valid flag=0x16
[    9.110394] ieee80211 phy0: U iwlcore_init_geos Channel 44
Freq=5220[5.2GHz] valid flag=0x26
[    9.124490] ieee80211 phy0: U iwlcore_init_geos Channel 48
Freq=5240[5.2GHz] valid flag=0x16
[    9.124690] ieee80211 phy0: U iwlcore_init_geos Channel 52
Freq=5260[5.2GHz] valid flag=0x2E
[    9.124889] ieee80211 phy0: U iwlcore_init_geos Channel 56
Freq=5280[5.2GHz] valid flag=0x1E
[    9.125089] ieee80211 phy0: U iwlcore_init_geos Channel 60
Freq=5300[5.2GHz] valid flag=0x2E
[    9.125288] ieee80211 phy0: U iwlcore_init_geos Channel 64
Freq=5320[5.2GHz] valid flag=0x1E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 100
Freq=5500[5.2GHz] valid flag=0x2E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 104
Freq=5520[5.2GHz] valid flag=0x1E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 108
Freq=5540[5.2GHz] valid flag=0x2E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 112
Freq=5560[5.2GHz] valid flag=0x1E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 116
Freq=5580[5.2GHz] valid flag=0x2E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 120
Freq=5600[5.2GHz] valid flag=0x1E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 124
Freq=5620[5.2GHz] valid flag=0x2E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 128
Freq=5640[5.2GHz] valid flag=0x1E
[    9.125311] ieee80211 phy0: U iwlcore_init_geos Channel 132
Freq=5660[5.2GHz] valid flag=0x2E
[    9.125314] ieee80211 phy0: U iwlcore_init_geos Channel 136
Freq=5680[5.2GHz] valid flag=0x1E
[    9.125515] ieee80211 phy0: U iwlcore_init_geos Channel 140
Freq=5700[5.2GHz] valid flag=0x3E
[    9.125715] ieee80211 phy0: U iwlcore_init_geos Channel 149
Freq=5745[5.2GHz] valid flag=0x26
[    9.125920] ieee80211 phy0: U iwlcore_init_geos Channel 153
Freq=5765[5.2GHz] valid flag=0x16
[    9.126123] ieee80211 phy0: U iwlcore_init_geos Channel 157
Freq=5785[5.2GHz] valid flag=0x26
[    9.126344] ieee80211 phy0: U iwlcore_init_geos Channel 161
Freq=5805[5.2GHz] valid flag=0x16
[    9.126544] ieee80211 phy0: U iwlcore_init_geos Channel 165
Freq=5825[5.2GHz] valid flag=0x36
[    9.126743] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    9.126928] ieee80211 phy0: U __iwl_write32 write32(0x0000000C,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1511
[    9.127131] ieee80211 phy0: U __iwl_write32 write32(0x00000008,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 1515
[    9.127335] ieee80211 phy0: U __iwl_write32 write32(0x00000010,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 1516
[    9.127538] ieee80211 phy0: U iwl4965_disable_interrupts Disabled interrupts
[    9.128536] iwlagn 0000:03:00.0: PCI INT A disabled
[    9.128965] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.201198] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    9.201443] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.235420] ieee80211 phy0: U iwl_rfkill_init Initializing RFKILL.
[    9.235628] ieee80211 phy0: U iwl_rfkill_init RFKILL initialization complete.
[    9.235841] ieee80211 phy0: U iwl_power_init_handle Initialize power
[    9.236031] ieee80211 phy0: U iwl_power_init_handle adjust power
command flags
[    9.233802] hda_codec: Unknown model for ALC662, trying auto-probe
from BIOS...
[   10.925499] EXT3 FS on sda2, internal journal
[   11.445609] loop: module loaded
[   12.904663] r8169: eth0: link down
[   16.274090] pnp: the driver 'parport_pc' has been registered
[   16.294503] lp: driver loaded but no devices found
[   16.326502] ppdev: user-space parallel port driver
[   16.921526] NET: Registered protocol family 10
[   16.922076] lo: Disabled Privacy Extensions
[   16.922614] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.408019] warning: `avahi-daemon' uses 32-bit capabilities
(legacy support in use)
[   19.102741] Bluetooth: L2CAP ver 2.10
[   19.102928] Bluetooth: L2CAP socket layer initialized
[   19.159165] Bluetooth: RFCOMM socket layer initialized
[   19.159378] Bluetooth: RFCOMM TTY layer initialized
[   19.159568] Bluetooth: RFCOMM ver 1.10
[   19.541239] ieee80211 phy0: U iwl4965_mac_start enter
[   19.541436] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   19.541781] iwlagn 0000:03:00.0: restoring config space at offset
0x1 (was 0x100002, writing 0x100006)
[   19.541974] firmware: requesting iwlwifi-5000-1.ucode
[   19.686248] ieee80211 phy0: U iwl4965_read_ucode Got firmware
'iwlwifi-5000-1.ucode' file (345008 bytes) from disk
[   19.686458] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
ucode version = 0x5040110
[   19.686691] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
runtime inst size = 128504
[   19.686990] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
runtime data size = 49152
[   19.687297] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
init inst size = 118176
[   19.687533] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
init data size = 49152
[   19.687771] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
boot inst size = 0
[   19.688090] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) uCode instr len 128504
[   19.688362] ieee80211 phy0: U iwl4965_read_ucode uCode instr buf
vaddr = 0xffff88013e500000, paddr = 0x3e500000
[   19.688607] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) uCode data len 49152
[   19.688859] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) init instr len 118176
[   19.689114] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) init data len 49152
[   19.689361] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) boot instr len 0
[   19.689634] ieee80211 phy0: U __iwl_read32
read_direct32(0x00000024) - drivers/net/wireless/iwlwifi/iwl-agn.c
2235
[   19.689848] ieee80211 phy0: U __iwl_write32 write32(0x00000008,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 2247
[   19.690144] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x20000000) = 0x27800200
[   19.690391] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x00800000) = 0x27800200
[   19.690641] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000240,
0xFFFF0000) = 0xFFFF0000
[   19.690911] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00080000) = 0x00080000
[   19.691159] ieee80211 phy0: U __iwl_set_bit set_bit(0x0000020C,
0x00880300) = 0x00880300
[   19.691411] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000024,
0x00000004) = 0x080403C5
[   19.691660] ieee80211 phy0: U __iwl_poll_bit poll_bit(0x00000024,
0x00000001, 0x00000001) - - drivers/net/wireless/iwlwifi/iwl-5000.c
112
[   19.691915] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 118
[   19.692190] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 131
[   19.692399] ieee80211 phy0: U __iwl_write32 write32(0x00000004,
0x00000010) - drivers/net/wireless/iwlwifi/iwl-core.c 236
[   19.692702] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-agn.c 1271
[   19.692981] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-agn.c 1290
[   19.693239] ieee80211 phy0: U __iwl_set_bit set_bit(0x0000003C,
0x00000002) = 0x00080046
[   19.693477] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00000003) = 0x00080003
[   19.693725] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00000300) = 0x00080303
[   19.693968] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 244
[   19.694221] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 248
[   19.694813] ieee80211 phy0: U __iwl_write32 write32(0x00001BC8,
0x000000F8) - drivers/net/wireless/iwlwifi/iwl-rx.c 159
[   19.695037] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-rx.c 382
[   19.695324] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-rx.c 420
[   19.695541] ieee80211 phy0: U __iwl_write32 write32(0x00001BC8,
0x000000F8) - drivers/net/wireless/iwlwifi/iwl-rx.c 159
[   19.695838] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 500
[   19.696094] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 509
[   19.696345] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-core.c 188
[   19.696600] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-core.c 194
[   19.696886] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.697098] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.697426] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.697636] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.697977] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.698188] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.698513] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.698725] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.699042] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.699260] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.699585] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.699796] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.700134] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.700345] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.700670] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.700881] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.701237] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.701449] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.701795] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.702006] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.702331] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.702542] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.702913] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.703125] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.703458] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.703668] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.704000] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.704212] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.704551] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.704793] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.705112] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.705324] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.705657] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.720006] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.720354] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.720567] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.720917] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.721131] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.721457] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   19.721670] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   19.721971] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000002) - drivers/net/wireless/iwlwifi/iwl-agn.c 2262
[   19.722218] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000004) - drivers/net/wireless/iwlwifi/iwl-agn.c 2264
[   19.722471] ieee80211 phy0: U __iwl_write32 write32(0x00000008,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 2267
[   19.722709] ieee80211 phy0: U iwl4965_enable_interrupts Enabling interrupts
[   19.722952] ieee80211 phy0: U __iwl_write32 write32(0x0000000C,
0xAA00008B) - drivers/net/wireless/iwlwifi/iwl-agn.c 1495
[   19.723183] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000002) - drivers/net/wireless/iwlwifi/iwl-agn.c 2271
[   19.723423] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000002) - drivers/net/wireless/iwlwifi/iwl-agn.c 2272
[   19.723676] ieee80211 phy0: U iwl5000_load_ucode Init ucode found.
Loading init ucode...
[   19.723910] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 564
[   19.724160] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 601
[   19.724411] ieee80211 phy0: U iwl5000_load_given_ucode INST uCode
section being loaded...
[   19.723452] ieee80211 phy0: I __iwl_read32
read_direct32(0x0000000C) - drivers/net/wireless/iwlwifi/iwl-agn.c
1753
[   19.723662] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1754
[   19.723866] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1757
[   19.724073] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1758
[   19.724298] ieee80211 phy0: I iwl4965_isr ISR inta 0x08000000,
enabled 0xaa00008b, fh 0x00000001
[   19.724500] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1591
[   19.724706] ieee80211 phy0: I __iwl_write32 write32(0x00000008,
0x08000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1592
[   19.724910] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1597
[   19.725117] ieee80211 phy0: I __iwl_write32 write32(0x00000010,
0x00000001) - drivers/net/wireless/iwlwifi/iwl-agn.c 1598
[   19.725320] ieee80211 phy0: I iwl4965_irq_tasklet Tx interrupt
[   19.725505] ieee80211 phy0: I iwl4965_enable_interrupts Enabling interrupts
[   19.725696] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0xAA00008B) - drivers/net/wireless/iwlwifi/iwl-agn.c 1495
[   19.728437] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 564
[   19.728722] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 601
[   19.729005] ieee80211 phy0: U iwl5000_load_given_ucode DATA uCode
section being loaded...
[   19.729819] ieee80211 phy0: I __iwl_read32
read_direct32(0x0000000C) - drivers/net/wireless/iwlwifi/iwl-agn.c
1753
[   19.730044] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1754
[   19.730248] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1757
[   19.730454] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1758
[   19.730663] ieee80211 phy0: I iwl4965_isr ISR inta 0x08000000,
enabled 0xaa00008b, fh 0x00000001
[   19.730886] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1591
[   19.731094] ieee80211 phy0: I __iwl_write32 write32(0x00000008,
0x08000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1592
[   19.731297] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1597
[   19.731504] ieee80211 phy0: I __iwl_write32 write32(0x00000010,
0x00000001) - drivers/net/wireless/iwlwifi/iwl-agn.c 1598
[   19.731706] ieee80211 phy0: I iwl4965_irq_tasklet Tx interrupt
[   19.731893] ieee80211 phy0: I iwl4965_enable_interrupts Enabling interrupts
[   19.732078] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0xAA00008B) - drivers/net/wireless/iwlwifi/iwl-agn.c 1495
[   19.729832] ieee80211 phy0: U iwl5000_load_ucode Init ucode load complete.
[   19.730041] ieee80211 phy0: U __iwl_write32 write32(0x00000020,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1816
[   19.730274] ieee80211 phy0: U __iwl4965_up iwlagn is coming up
[   19.730492] ieee80211 phy0: U iwl4965_mac_start Start UP work done.
[   23.727121] iwlagn: START_ALIVE timeout after 4000ms.
[   23.727262] iwlagn 0000:03:00.0: PCI INT A disabled
[   23.727264] ieee80211 phy0: U iwl4965_mac_start leave - failed

-- 
Yousaf Jindal
Director of Technology
Pakistani Institute
