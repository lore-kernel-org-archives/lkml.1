Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYHRKP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYHRKP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYHRKPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:15:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:34723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYHRKPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:15:48 -0400
Message-ID: <e700089d0808180315s4851ed0fqea6b64c83eb570f@mail.gmail.com>
Date: Mon, 18 Aug 2008 06:15:45 -0400
From: "Yousaf Jindal" <yousaf.jindal@pi.edu.pk>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1ba2fa240808180112l284086f4x64168d994743398@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
	 <e700089d0808160326k337cec2dm65271b38812a4263@mail.gmail.com>
	 <1ba2fa240808180112l284086f4x64168d994743398@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 4:12 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>
> Please try attached patch (not sure it will help tough)
> I also will need output of
>  >cat /sys/class/net/wlan0/devices/version
>
>
> Thanks
> Tomas

$ cat /sys/class/net/wlan0/device/version
fw not loaded
EEPROM version: 0x11e


The START_ALIVE issue persists after I applied your patch.

A kernel log with the latest iwlwifi kernel (including the commits you
and Mr Abbas added a few hours ago):


[    8.708462] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
Linux, 1.3.27kds
[    8.708686] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    8.708919] ieee80211 phy0: U iwl4965_pci_probe *** LOAD DRIVER ***
[    8.709140] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.709367] iwlagn 0000:03:00.0: setting latency timer to 64
[    8.709384] ieee80211 phy0: U iwl4965_pci_probe pci_resource_len = 0x00002000
[    8.709568] ieee80211 phy0: U iwl4965_pci_probe pci_resource_base =
ffffc20000664000
[    8.709796] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[    8.710007] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x20000000) = 0x27800200
[    8.710232] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x00800000) = 0x27800200
[    8.710481] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000240,
0xFFFF0000) = 0xFFFF0500
[    8.710704] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00080000) = 0x00080000
[    8.710927] ieee80211 phy0: U __iwl_set_bit set_bit(0x0000020C,
0x00880300) = 0x00880300
[    8.711151] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000024,
0x00000004) = 0x080003D4
[    8.721318] ieee80211 phy0: U __iwl_poll_bit poll_bit(0x00000024,
0x00000001, 0x00000001) - - drivers/net/wireless/iwlwifi/iwl-5000.c
112
[    8.721524] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 118
[    8.721799] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 131
[    8.722006] ieee80211 phy0: U __iwl_read32
read_direct32(0x00000030) - drivers/net/wireless/iwlwifi/iwl-eeprom.c
213
[    8.722216] ieee80211 phy0: U __iwl_read32
read_direct32(0x00000030) - drivers/net/wireless/iwlwifi/iwl-eeprom.c
147
[    8.722425] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00200000) = 0x00280000
[    8.722629] ieee80211 phy0: U __iwl_poll_bit poll_bit(0x00000000,
0x00200000, 0x00200000) - - drivers/net/wireless/iwlwifi/iwl-eeprom.c
176
[    8.722834] ieee80211 phy0: U iwlcore_eeprom_acquire_semaphore
Acquired semaphore after 1 tries.
[    8.745315] ieee80211 phy0: U __iwl_clear_bit clear_bit(0x00000000,
0x00200000) = 0x00080000
[    8.745516] ieee80211 phy0: U iwl4965_pci_probe MAC address:
00:16:ea:65:05:b8
[    8.745715] ieee80211 phy0: U iwl_set_rxon_chain rx chain 2806
[    8.745898] ieee80211 phy0: U iwl_reset_qos set QoS to default
[    8.746081] ieee80211 phy0: U iwl_init_channel_map Initializing
regulatory info from EEPROM
[    8.746283] ieee80211 phy0: U iwl_init_channel_map Parsing data for
56 channels.
[    8.746483] ieee80211 phy0: U iwl_init_channel_map Ch. 1 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.746686] ieee80211 phy0: U iwl_init_channel_map Ch. 2 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.746890] ieee80211 phy0: U iwl_init_channel_map Ch. 3 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.747093] ieee80211 phy0: U iwl_init_channel_map Ch. 4 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.747297] ieee80211 phy0: U iwl_init_channel_map Ch. 5 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.747501] ieee80211 phy0: U iwl_init_channel_map Ch. 6 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.747705] ieee80211 phy0: U iwl_init_channel_map Ch. 7 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.747908] ieee80211 phy0: U iwl_init_channel_map Ch. 8 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.748112] ieee80211 phy0: U iwl_init_channel_map Ch. 9 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.748315] ieee80211 phy0: U iwl_init_channel_map Ch. 10 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.748519] ieee80211 phy0: U iwl_init_channel_map Ch. 11 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.748722] ieee80211 phy0: U iwl_init_channel_map Ch. 12 [2.4GHz]
VALID WIDE (0x61 15dBm): Ad-Hoc not supported
[    8.748925] ieee80211 phy0: U iwl_init_channel_map Ch. 13 [2.4GHz]
VALID WIDE (0x61 15dBm): Ad-Hoc not supported
[    8.749127] ieee80211 phy0: U iwl_init_channel_map Ch. 14 Flags 0
[2.4GHz] - No traffic
[    8.749333] ieee80211 phy0: U iwl_init_channel_map Ch. 183 Flags 0
[5.2GHz] - No traffic
[    8.749531] ieee80211 phy0: U iwl_init_channel_map Ch. 184 Flags 0
[5.2GHz] - No traffic
[    8.749730] ieee80211 phy0: U iwl_init_channel_map Ch. 185 Flags 0
[5.2GHz] - No traffic
[    8.761670] ieee80211 phy0: U iwl_init_channel_map Ch. 187 Flags 0
[5.2GHz] - No traffic
[    8.761869] ieee80211 phy0: U iwl_init_channel_map Ch. 188 Flags 0
[5.2GHz] - No traffic
[    8.762068] ieee80211 phy0: U iwl_init_channel_map Ch. 189 Flags 0
[5.2GHz] - No traffic
[    8.762281] ieee80211 phy0: U iwl_init_channel_map Ch. 192 Flags 0
[5.2GHz] - No traffic
[    8.762480] ieee80211 phy0: U iwl_init_channel_map Ch. 196 Flags 0
[5.2GHz] - No traffic
[    8.762679] ieee80211 phy0: U iwl_init_channel_map Ch. 7 Flags 0
[5.2GHz] - No traffic
[    8.762877] ieee80211 phy0: U iwl_init_channel_map Ch. 8 Flags 0
[5.2GHz] - No traffic
[    8.763075] ieee80211 phy0: U iwl_init_channel_map Ch. 11 Flags 0
[5.2GHz] - No traffic
[    8.763274] ieee80211 phy0: U iwl_init_channel_map Ch. 12 Flags 0
[5.2GHz] - No traffic
[    8.763473] ieee80211 phy0: U iwl_init_channel_map Ch. 16 Flags 0
[5.2GHz] - No traffic
[    8.763672] ieee80211 phy0: U iwl_init_channel_map Ch. 34 Flags 0
[5.2GHz] - No traffic
[    8.763871] ieee80211 phy0: U iwl_init_channel_map Ch. 36 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    8.764073] ieee80211 phy0: U iwl_init_channel_map Ch. 38 Flags 0
[5.2GHz] - No traffic
[    8.764273] ieee80211 phy0: U iwl_init_channel_map Ch. 40 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    8.764475] ieee80211 phy0: U iwl_init_channel_map Ch. 42 Flags 0
[5.2GHz] - No traffic
[    8.764674] ieee80211 phy0: U iwl_init_channel_map Ch. 44 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    8.764877] ieee80211 phy0: U iwl_init_channel_map Ch. 46 Flags 0
[5.2GHz] - No traffic
[    8.765077] ieee80211 phy0: U iwl_init_channel_map Ch. 48 [5.2GHz]
VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    8.765286] ieee80211 phy0: U iwl_init_channel_map Ch. 52 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.765490] ieee80211 phy0: U iwl_init_channel_map Ch. 56 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.765694] ieee80211 phy0: U iwl_init_channel_map Ch. 60 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.765897] ieee80211 phy0: U iwl_init_channel_map Ch. 64 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.766101] ieee80211 phy0: U iwl_init_channel_map Ch. 100 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.766308] ieee80211 phy0: U iwl_init_channel_map Ch. 104 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.766511] ieee80211 phy0: U iwl_init_channel_map Ch. 108 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.766714] ieee80211 phy0: U iwl_init_channel_map Ch. 112 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.766918] ieee80211 phy0: U iwl_init_channel_map Ch. 116 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.767121] ieee80211 phy0: U iwl_init_channel_map Ch. 120 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.767325] ieee80211 phy0: U iwl_init_channel_map Ch. 124 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.767528] ieee80211 phy0: U iwl_init_channel_map Ch. 128 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.767732] ieee80211 phy0: U iwl_init_channel_map Ch. 132 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.767935] ieee80211 phy0: U iwl_init_channel_map Ch. 136 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.768139] ieee80211 phy0: U iwl_init_channel_map Ch. 140 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.768342] ieee80211 phy0: U iwl_init_channel_map Ch. 145 Flags 0
[5.2GHz] - No traffic
[    8.768541] ieee80211 phy0: U iwl_init_channel_map Ch. 149 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    8.768744] ieee80211 phy0: U iwl_init_channel_map Ch. 153 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    8.768948] ieee80211 phy0: U iwl_init_channel_map Ch. 157 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    8.769151] ieee80211 phy0: U iwl_init_channel_map Ch. 161 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    8.769360] ieee80211 phy0: U iwl_init_channel_map Ch. 165 [5.2GHz]
VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[    8.769563] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 1
[2.4GHz] IBSS ACTIVE WIDE (0x6f 10dBm): Ad-Hoc supported
[    8.769766] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 5
[2.4GHz] IBSS ACTIVE WIDE (0x6f 10dBm): Ad-Hoc supported
[    8.769970] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 2
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.770174] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 6
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.770378] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 3
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.770581] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 7
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.770784] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 4
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.770987] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 8
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.771191] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 5
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.771394] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 9
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.771597] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 6
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.771801] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 10
[2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[    8.772005] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 7
[2.4GHz] IBSS ACTIVE WIDE (0x6f 13dBm): Ad-Hoc supported
[    8.772208] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 11
[2.4GHz] IBSS ACTIVE WIDE (0x6f 13dBm): Ad-Hoc supported
[    8.772412] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 36
[5.2GHz] WIDE DFS (0xe1 14dBm): Ad-Hoc not supported
[    8.772614] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 40
[5.2GHz] WIDE DFS (0xe1 14dBm): Ad-Hoc not supported
[    8.772817] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 44
[5.2GHz] WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    8.773020] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 48
[5.2GHz] WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[    8.773229] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 52
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.773432] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 56
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.773636] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 60
[5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[    8.773838] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 64
[5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[    8.774041] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 100
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.774269] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 104
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.774472] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 108
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.774675] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 112
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.774879] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 116
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.775082] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 120
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.775285] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 124
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.775489] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 128
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.775692] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 132
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.775895] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 136
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    8.776259] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 149
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    8.776461] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 153
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    8.776664] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 157
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    8.776867] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 161
[5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[    8.777070] ieee80211 phy0: U iwlcore_init_geos Channel 1
Freq=2412[2.4GHz] valid flag=0x20
[    8.777276] ieee80211 phy0: U iwlcore_init_geos Channel 2
Freq=2417[2.4GHz] valid flag=0x20
[    8.777476] ieee80211 phy0: U iwlcore_init_geos Channel 3
Freq=2422[2.4GHz] valid flag=0x20
[    8.777676] ieee80211 phy0: U iwlcore_init_geos Channel 4
Freq=2427[2.4GHz] valid flag=0x20
[    8.777875] ieee80211 phy0: U iwlcore_init_geos Channel 5
Freq=2432[2.4GHz] valid flag=0x0
[    8.778075] ieee80211 phy0: U iwlcore_init_geos Channel 6
Freq=2437[2.4GHz] valid flag=0x0
[    8.778279] ieee80211 phy0: U iwlcore_init_geos Channel 7
Freq=2442[2.4GHz] valid flag=0x0
[    8.778478] ieee80211 phy0: U iwlcore_init_geos Channel 8
Freq=2447[2.4GHz] valid flag=0x10
[    8.778678] ieee80211 phy0: U iwlcore_init_geos Channel 9
Freq=2452[2.4GHz] valid flag=0x10
[    8.778877] ieee80211 phy0: U iwlcore_init_geos Channel 10
Freq=2457[2.4GHz] valid flag=0x10
[    8.779076] ieee80211 phy0: U iwlcore_init_geos Channel 11
Freq=2462[2.4GHz] valid flag=0x10
[    8.779277] ieee80211 phy0: U iwlcore_init_geos Channel 12
Freq=2467[2.4GHz] valid flag=0x36
[    8.779476] ieee80211 phy0: U iwlcore_init_geos Channel 13
Freq=2472[2.4GHz] valid flag=0x36
[    8.779676] ieee80211 phy0: U iwlcore_init_geos Channel 36
Freq=5180[5.2GHz] valid flag=0x26
[    8.779875] ieee80211 phy0: U iwlcore_init_geos Channel 40
Freq=5200[5.2GHz] valid flag=0x16
[    8.792018] ieee80211 phy0: U iwlcore_init_geos Channel 44
Freq=5220[5.2GHz] valid flag=0x26
[    8.792218] ieee80211 phy0: U iwlcore_init_geos Channel 48
Freq=5240[5.2GHz] valid flag=0x16
[    8.792418] ieee80211 phy0: U iwlcore_init_geos Channel 52
Freq=5260[5.2GHz] valid flag=0x2E
[    8.792617] ieee80211 phy0: U iwlcore_init_geos Channel 56
Freq=5280[5.2GHz] valid flag=0x1E
[    8.792817] ieee80211 phy0: U iwlcore_init_geos Channel 60
Freq=5300[5.2GHz] valid flag=0x2E
[    8.793016] ieee80211 phy0: U iwlcore_init_geos Channel 64
Freq=5320[5.2GHz] valid flag=0x1E
[    8.793222] ieee80211 phy0: U iwlcore_init_geos Channel 100
Freq=5500[5.2GHz] valid flag=0x2E
[    8.793422] ieee80211 phy0: U iwlcore_init_geos Channel 104
Freq=5520[5.2GHz] valid flag=0x1E
[    8.793622] ieee80211 phy0: U iwlcore_init_geos Channel 108
Freq=5540[5.2GHz] valid flag=0x2E
[    8.793821] ieee80211 phy0: U iwlcore_init_geos Channel 112
Freq=5560[5.2GHz] valid flag=0x1E
[    8.794021] ieee80211 phy0: U iwlcore_init_geos Channel 116
Freq=5580[5.2GHz] valid flag=0x2E
[    8.794224] ieee80211 phy0: U iwlcore_init_geos Channel 120
Freq=5600[5.2GHz] valid flag=0x1E
[    8.794424] ieee80211 phy0: U iwlcore_init_geos Channel 124
Freq=5620[5.2GHz] valid flag=0x2E
[    8.794623] ieee80211 phy0: U iwlcore_init_geos Channel 128
Freq=5640[5.2GHz] valid flag=0x1E
[    8.794823] ieee80211 phy0: U iwlcore_init_geos Channel 132
Freq=5660[5.2GHz] valid flag=0x2E
[    8.795023] ieee80211 phy0: U iwlcore_init_geos Channel 136
Freq=5680[5.2GHz] valid flag=0x1E
[    8.795223] ieee80211 phy0: U iwlcore_init_geos Channel 140
Freq=5700[5.2GHz] valid flag=0x3E
[    8.795422] ieee80211 phy0: U iwlcore_init_geos Channel 149
Freq=5745[5.2GHz] valid flag=0x26
[    8.795622] ieee80211 phy0: U iwlcore_init_geos Channel 153
Freq=5765[5.2GHz] valid flag=0x16
[    8.795822] ieee80211 phy0: U iwlcore_init_geos Channel 157
Freq=5785[5.2GHz] valid flag=0x26
[    8.796022] ieee80211 phy0: U iwlcore_init_geos Channel 161
Freq=5805[5.2GHz] valid flag=0x16
[    8.796221] ieee80211 phy0: U iwlcore_init_geos Channel 165
Freq=5825[5.2GHz] valid flag=0x36
[    8.796420] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    8.796605] ieee80211 phy0: U __iwl_write32 write32(0x0000000C,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1510
[    8.796808] ieee80211 phy0: U __iwl_write32 write32(0x00000008,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 1514
[    8.797012] ieee80211 phy0: U __iwl_write32 write32(0x00000010,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 1515
[    8.797215] ieee80211 phy0: U iwl4965_disable_interrupts Disabled interrupts
[    8.797891] iwlagn 0000:03:00.0: PCI INT A disabled
[    8.805013] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    8.885000] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    8.885225] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.921952] ieee80211 phy0: U iwl_rfkill_init Initializing RFKILL.
[    8.922155] ieee80211 phy0: U iwl_rfkill_init RFKILL initialization complete.
[    8.922353] ieee80211 phy0: U iwl_power_init_handle Initialize power
[    8.922545] ieee80211 phy0: U iwl_power_init_handle adjust power
command flags
[    8.923108] hda_codec: Unknown model for ALC662, trying auto-probe
from BIOS...
[   11.233487] EXT3 FS on sda2, internal journal
[   11.813104] loop: module loaded
[   13.622787] r8169: eth0: link up
[   13.620732] r8169: eth0: link up
[   17.070753] pnp: the driver 'parport_pc' has been registered
[   17.069571] lp: driver loaded but no devices found
[   17.107236] ppdev: user-space parallel port driver
[   17.681223] NET: Registered protocol family 10
[   17.681746] lo: Disabled Privacy Extensions
[   18.168025] warning: `avahi-daemon' uses 32-bit capabilities
(legacy support in use)
[   19.825017] Bluetooth: L2CAP ver 2.10
[   19.825202] Bluetooth: L2CAP socket layer initialized
[   19.881093] Bluetooth: RFCOMM socket layer initialized
[   19.881290] Bluetooth: RFCOMM TTY layer initialized
[   19.881473] Bluetooth: RFCOMM ver 1.10
[   20.213511] ieee80211 phy0: U iwl4965_mac_start enter
[   20.213711] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   20.213968] iwlagn 0000:03:00.0: restoring config space at offset
0x1 (was 0x100002, writing 0x100006)
[   20.214122] firmware: requesting iwlwifi-5000-1.ucode
[   20.368395] ieee80211 phy0: U iwl4965_read_ucode Got firmware
'iwlwifi-5000-1.ucode' file (345008 bytes) from disk
[   20.368606] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
ucode version = 0x5040110
[   20.368816] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
runtime inst size = 128504
[   20.369062] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
runtime data size = 49152
[   20.369299] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
init inst size = 118176
[   20.369546] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
init data size = 49152
[   20.369777] ieee80211 phy0: U iwl4965_read_ucode f/w package hdr
boot inst size = 0
[   20.370083] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) uCode instr len 128504
[   20.370389] ieee80211 phy0: U iwl4965_read_ucode uCode instr buf
vaddr = 0xffff88013d4e0000, paddr = 0x3d4e0000
[   20.370635] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) uCode data len 49152
[   20.370887] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) init instr len 118176
[   20.371147] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) init data len 49152
[   20.371384] ieee80211 phy0: U iwl4965_read_ucode Copying (but not
loading) boot instr len 0
[   20.371657] ieee80211 phy0: U __iwl_read32
read_direct32(0x00000024) - drivers/net/wireless/iwlwifi/iwl-agn.c
2234
[   20.371865] ieee80211 phy0: U __iwl_write32 write32(0x00000008,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 2246
[   20.372163] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x20000000) = 0x27800200
[   20.372408] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000100,
0x00800000) = 0x27800200
[   20.372653] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000240,
0xFFFF0000) = 0xFFFF0000
[   20.372902] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00080000) = 0x00080000
[   20.373150] ieee80211 phy0: U __iwl_set_bit set_bit(0x0000020C,
0x00880300) = 0x00880300
[   20.373391] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000024,
0x00000004) = 0x080403C5
[   20.373641] ieee80211 phy0: U __iwl_poll_bit poll_bit(0x00000024,
0x00000001, 0x00000001) - - drivers/net/wireless/iwlwifi/iwl-5000.c
112
[   20.373888] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 118
[   20.374160] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 131
[   20.374370] ieee80211 phy0: U __iwl_write32 write32(0x00000004,
0x00000010) - drivers/net/wireless/iwlwifi/iwl-core.c 236
[   20.374672] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-agn.c 1270
[   20.374892] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-agn.c 1289
[   20.375189] ieee80211 phy0: U __iwl_set_bit set_bit(0x0000003C,
0x00000002) = 0x00080046
[   20.375437] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00000003) = 0x00080003
[   20.375730] ieee80211 phy0: U __iwl_set_bit set_bit(0x00000000,
0x00000300) = 0x00080303
[   20.375975] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 244
[   20.376227] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 248
[   20.376688] ieee80211 phy0: U __iwl_write32 write32(0x00001BC8,
0x000000F8) - drivers/net/wireless/iwlwifi/iwl-rx.c 159
[   20.376893] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-rx.c 382
[   20.377177] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-rx.c 420
[   20.377436] ieee80211 phy0: U __iwl_write32 write32(0x00001BC8,
0x000000F8) - drivers/net/wireless/iwlwifi/iwl-rx.c 159
[   20.377683] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 500
[   20.377938] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 509
[   20.378188] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-core.c 188
[   20.378470] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-core.c 194
[   20.378723] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.378937] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.379188] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.379399] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.379640] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.379851] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.380092] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.380301] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.380520] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.380731] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.380971] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.381182] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.381429] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.381639] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.381880] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.382091] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.382335] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.382547] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.382788] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.382999] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.383241] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.383451] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.383691] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.383902] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.384142] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.384353] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.384594] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.384805] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.385046] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.385257] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.385505] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.385716] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.385955] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.392274] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.396379] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.396595] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.396937] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.397227] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.397564] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-tx.c 381
[   20.397897] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-tx.c 396
[   20.400321] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000002) - drivers/net/wireless/iwlwifi/iwl-agn.c 2261
[   20.400596] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000004) - drivers/net/wireless/iwlwifi/iwl-agn.c 2263
[   20.400908] ieee80211 phy0: U __iwl_write32 write32(0x00000008,
0xFFFFFFFF) - drivers/net/wireless/iwlwifi/iwl-agn.c 2266
[   20.401202] ieee80211 phy0: U iwl4965_enable_interrupts Enabling interrupts
[   20.401465] ieee80211 phy0: U __iwl_write32 write32(0x0000000C,
0xAA00008B) - drivers/net/wireless/iwlwifi/iwl-agn.c 1494
[   20.401771] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000002) - drivers/net/wireless/iwlwifi/iwl-agn.c 2270
[   20.402033] ieee80211 phy0: U __iwl_write32 write32(0x0000005C,
0x00000002) - drivers/net/wireless/iwlwifi/iwl-agn.c 2271
[   20.402351] ieee80211 phy0: U iwl5000_load_ucode Init ucode found.
Loading init ucode...
[   20.402659] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 564
[   20.402977] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 601
[   20.403261] ieee80211 phy0: U iwl5000_load_given_ucode INST uCode
section being loaded...
[   20.413225] ieee80211 phy0: I __iwl_read32
read_direct32(0x0000000C) - drivers/net/wireless/iwlwifi/iwl-agn.c
1752
[   20.413225] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1753
[   20.413225] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1756
[   20.413225] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1757
[   20.413225] ieee80211 phy0: I iwl4965_isr ISR inta 0x08000000,
enabled 0xaa00008b, fh 0x00000001
[   20.413225] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1590
[   20.413225] ieee80211 phy0: I __iwl_write32 write32(0x00000008,
0x08000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1591
[   20.413225] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1596
[   20.413225] ieee80211 phy0: I __iwl_write32 write32(0x00000010,
0x00000001) - drivers/net/wireless/iwlwifi/iwl-agn.c 1597
[   20.413225] ieee80211 phy0: I iwl4965_irq_tasklet Tx interrupt
[   20.413225] ieee80211 phy0: I iwl4965_enable_interrupts Enabling interrupts
[   20.413225] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0xAA00008B) - drivers/net/wireless/iwlwifi/iwl-agn.c 1494
[   20.407254] ieee80211 phy0: U __iwl_grab_nic_access grabbing nic
access - drivers/net/wireless/iwlwifi/iwl-5000.c 564
[   20.407547] ieee80211 phy0: U __iwl_release_nic_access releasing
nic access - drivers/net/wireless/iwlwifi/iwl-5000.c 601
[   20.407829] ieee80211 phy0: U iwl5000_load_given_ucode DATA uCode
section being loaded...
[   20.413768] ieee80211 phy0: I __iwl_read32
read_direct32(0x0000000C) - drivers/net/wireless/iwlwifi/iwl-agn.c
1752
[   20.413976] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1753
[   20.414181] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1756
[   20.414413] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1757
[   20.414624] ieee80211 phy0: I iwl4965_isr ISR inta 0x08000000,
enabled 0xaa00008b, fh 0x00000001
[   20.414830] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000008) - drivers/net/wireless/iwlwifi/iwl-agn.c
1590
[   20.415037] ieee80211 phy0: I __iwl_write32 write32(0x00000008,
0x08000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1591
[   20.415240] ieee80211 phy0: I __iwl_read32
read_direct32(0x00000010) - drivers/net/wireless/iwlwifi/iwl-agn.c
1596
[   20.415447] ieee80211 phy0: I __iwl_write32 write32(0x00000010,
0x00000001) - drivers/net/wireless/iwlwifi/iwl-agn.c 1597
[   20.415651] ieee80211 phy0: I iwl4965_irq_tasklet Tx interrupt
[   20.415837] ieee80211 phy0: I iwl4965_enable_interrupts Enabling interrupts
[   20.410723] ieee80211 phy0: U iwl5000_load_ucode Init ucode load complete.
[   20.410726] ieee80211 phy0: U __iwl_write32 write32(0x00000020,
0x00000000) - drivers/net/wireless/iwlwifi/iwl-agn.c 1815
[   20.410731] ieee80211 phy0: U __iwl4965_up iwlagn is coming up
[   20.410733] ieee80211 phy0: U iwl4965_mac_start Start UP work done.
[   20.416778] ieee80211 phy0: I __iwl_write32 write32(0x0000000C,
0xAA00008B) - drivers/net/wireless/iwlwifi/iwl-agn.c 1494
[   24.412435] iwlagn: START_ALIVE timeout after 4000ms.
[   24.412567] iwlagn 0000:03:00.0: PCI INT A disabled
[   24.412569] ieee80211 phy0: U iwl4965_mac_start leave - failed


-- 
Yousaf Jindal
Director of Technology
Pakistani Institute
