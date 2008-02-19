Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbYBSWos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbYBSWos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbYBSWoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:44:38 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:45664 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbYBSWof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:44:35 -0500
Date: Tue, 19 Feb 2008 23:44:18 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Recent driver in linux kernel 2.6.25-rc2
Message-ID: <20080219224418.GA20926@ics.muni.cz>
References: <20080219153910.GA4303@ics.muni.cz> <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 19 Feb 2008 23:44:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Feb 19, 2008 at 02:28:58PM -0800, Chatre, Reinette wrote:
> > as of pre 2.6.25 kernels, kismet monitoring tool does not work with
> > the message: # kismet
> > Launching kismet_server: //usr/bin/kismet_server
> > Suid priv-dropping disabled.  This may not be secure.
> > No specific sources given to be enabled, all will be enabled.
> > Non-RFMon VAPs will be destroyed on multi-vap interfaces (ie,
> > madwifi-ng) Enabling channel hopping.
> > Enabling channel splitting.
> > Source 0 (iwl4965): Enabling monitor mode for iwl4965 source
> > interface wlan0 channel 6...
> > FATAL: Failed to set channel 6 5:Input/output error
> 
> Please load the driver with debugging enabled (debug=0x43fff) and send
> us the log capturing during this kismet startup.

the log is attached.

-- 
Luká¹ Hejtmánek

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="iwl-debug.log"

[22269.555289] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23kds
[22269.555299] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[22269.555430] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[22269.555454] PCI: Setting latency timer of device 0000:03:00.0 to 64
[22269.555492] iwl4965: U iwl4965_pci_probe pci_resource_len = 0x00002000
[22269.555499] iwl4965: U iwl4965_pci_probe pci_resource_base = ffffc2000007c000
[22269.555505] iwl4965: U iwl4965_set_rxon_chain rx chain 280E
[22269.555509] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[22269.555527] iwl4965: U iwl4965_set_rxon_channel Staging channel set to 6 [2]
[22269.596955] iwl4965: U iwl4965_pci_probe MAC address: 00:13:e8:d3:41:e7
[22269.596972] iwl4965: U iwl4965_init_channel_map Initializing regulatory info from EEPROM
[22269.596977] iwl4965: U iwl4965_init_channel_map Parsing data for 56 channels.
[22269.597007] iwl4965: U iwl4965_init_channel_map Ch. 1 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597015] iwl4965: U iwl4965_init_channel_map Ch. 2 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597023] iwl4965: U iwl4965_init_channel_map Ch. 3 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597030] iwl4965: U iwl4965_init_channel_map Ch. 4 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597038] iwl4965: U iwl4965_init_channel_map Ch. 5 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597046] iwl4965: U iwl4965_init_channel_map Ch. 6 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597053] iwl4965: U iwl4965_init_channel_map Ch. 7 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597061] iwl4965: U iwl4965_init_channel_map Ch. 8 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597069] iwl4965: U iwl4965_init_channel_map Ch. 9 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597076] iwl4965: U iwl4965_init_channel_map Ch. 10 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597084] iwl4965: U iwl4965_init_channel_map Ch. 11 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[22269.597090] iwl4965: U iwl4965_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
[22269.597096] iwl4965: U iwl4965_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
[22269.597102] iwl4965: U iwl4965_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
[22269.597108] iwl4965: U iwl4965_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
[22269.597113] iwl4965: U iwl4965_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
[22269.597119] iwl4965: U iwl4965_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
[22269.597125] iwl4965: U iwl4965_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
[22269.597130] iwl4965: U iwl4965_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
[22269.597136] iwl4965: U iwl4965_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
[22269.597142] iwl4965: U iwl4965_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
[22269.597147] iwl4965: U iwl4965_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
[22269.597153] iwl4965: U iwl4965_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
[22269.597158] iwl4965: U iwl4965_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
[22269.597164] iwl4965: U iwl4965_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
[22269.597170] iwl4965: U iwl4965_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
[22269.597176] iwl4965: U iwl4965_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
[22269.597181] iwl4965: U iwl4965_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
[22269.597188] iwl4965: U iwl4965_init_channel_map Ch. 36 [5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[22269.597194] iwl4965: U iwl4965_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
[22269.597201] iwl4965: U iwl4965_init_channel_map Ch. 40 [5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[22269.597207] iwl4965: U iwl4965_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
[22269.597214] iwl4965: U iwl4965_init_channel_map Ch. 44 [5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[22269.597220] iwl4965: U iwl4965_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
[22269.597227] iwl4965: U iwl4965_init_channel_map Ch. 48 [5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[22269.597234] iwl4965: U iwl4965_init_channel_map Ch. 52 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[22269.597242] iwl4965: U iwl4965_init_channel_map Ch. 56 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[22269.597250] iwl4965: U iwl4965_init_channel_map Ch. 60 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[22269.597257] iwl4965: U iwl4965_init_channel_map Ch. 64 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[22269.597264] iwl4965: U iwl4965_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
[22269.597269] iwl4965: U iwl4965_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
[22269.597275] iwl4965: U iwl4965_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
[22269.597281] iwl4965: U iwl4965_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
[22269.597286] iwl4965: U iwl4965_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
[22269.597292] iwl4965: U iwl4965_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
[22269.597298] iwl4965: U iwl4965_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
[22269.597303] iwl4965: U iwl4965_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
[22269.597309] iwl4965: U iwl4965_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
[22269.597315] iwl4965: U iwl4965_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
[22269.597320] iwl4965: U iwl4965_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
[22269.597326] iwl4965: U iwl4965_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
[22269.597333] iwl4965: U iwl4965_init_channel_map Ch. 149 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597340] iwl4965: U iwl4965_init_channel_map Ch. 153 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597347] iwl4965: U iwl4965_init_channel_map Ch. 157 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597355] iwl4965: U iwl4965_init_channel_map Ch. 161 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597362] iwl4965: U iwl4965_init_channel_map Ch. 165 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597370] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 1 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597377] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 5 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597384] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 2 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597391] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 6 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597398] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 3 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597405] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 7 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597412] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 4 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597419] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 8 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597426] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 5 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597433] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 9 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597441] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 6 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597448] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 10 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597455] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 7 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597462] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 11 [2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[22269.597470] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 36 [5.2GHz] WIDE (0x21 13dBm): Ad-Hoc not supported
[22269.597477] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 40 [5.2GHz] WIDE (0x21 13dBm): Ad-Hoc not supported
[22269.597485] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 44 [5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[22269.597492] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 48 [5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[22269.597500] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 52 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[22269.597508] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 56 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[22269.597516] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 60 [5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[22269.597524] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 64 [5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[22269.597534] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 149 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597541] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 153 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597549] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 157 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597557] iwl4965: U iwl4965_set_fat_chan_info FAT Ch. 161 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[22269.597567] iwl4965: U iwl4965_init_geos Channel 12 [2.4GHz] is restricted -- skipping.
[22269.597573] iwl4965: U iwl4965_init_geos Channel 13 [2.4GHz] is restricted -- skipping.
[22269.597578] iwl4965: U iwl4965_init_geos Channel 14 [2.4GHz] is restricted -- skipping.
[22269.597584] iwl4965: U iwl4965_init_geos Channel 183 [5.2GHz] is restricted -- skipping.
[22269.597589] iwl4965: U iwl4965_init_geos Channel 184 [5.2GHz] is restricted -- skipping.
[22269.597595] iwl4965: U iwl4965_init_geos Channel 185 [5.2GHz] is restricted -- skipping.
[22269.597601] iwl4965: U iwl4965_init_geos Channel 187 [5.2GHz] is restricted -- skipping.
[22269.597606] iwl4965: U iwl4965_init_geos Channel 188 [5.2GHz] is restricted -- skipping.
[22269.597612] iwl4965: U iwl4965_init_geos Channel 189 [5.2GHz] is restricted -- skipping.
[22269.597617] iwl4965: U iwl4965_init_geos Channel 192 [5.2GHz] is restricted -- skipping.
[22269.597623] iwl4965: U iwl4965_init_geos Channel 196 [5.2GHz] is restricted -- skipping.
[22269.597629] iwl4965: U iwl4965_init_geos Channel 7 [5.2GHz] is restricted -- skipping.
[22269.597634] iwl4965: U iwl4965_init_geos Channel 8 [5.2GHz] is restricted -- skipping.
[22269.597639] iwl4965: U iwl4965_init_geos Channel 11 [5.2GHz] is restricted -- skipping.
[22269.597644] iwl4965: U iwl4965_init_geos Channel 12 [5.2GHz] is restricted -- skipping.
[22269.597649] iwl4965: U iwl4965_init_geos Channel 16 [5.2GHz] is restricted -- skipping.
[22269.597655] iwl4965: U iwl4965_init_geos Channel 34 [5.2GHz] is restricted -- skipping.
[22269.597660] iwl4965: U iwl4965_init_geos Channel 38 [5.2GHz] is restricted -- skipping.
[22269.597665] iwl4965: U iwl4965_init_geos Channel 42 [5.2GHz] is restricted -- skipping.
[22269.597671] iwl4965: U iwl4965_init_geos Channel 46 [5.2GHz] is restricted -- skipping.
[22269.597676] iwl4965: U iwl4965_init_geos Channel 100 [5.2GHz] is restricted -- skipping.
[22269.597682] iwl4965: U iwl4965_init_geos Channel 104 [5.2GHz] is restricted -- skipping.
[22269.597687] iwl4965: U iwl4965_init_geos Channel 108 [5.2GHz] is restricted -- skipping.
[22269.597692] iwl4965: U iwl4965_init_geos Channel 112 [5.2GHz] is restricted -- skipping.
[22269.597697] iwl4965: U iwl4965_init_geos Channel 116 [5.2GHz] is restricted -- skipping.
[22269.597702] iwl4965: U iwl4965_init_geos Channel 120 [5.2GHz] is restricted -- skipping.
[22269.597708] iwl4965: U iwl4965_init_geos Channel 124 [5.2GHz] is restricted -- skipping.
[22269.597713] iwl4965: U iwl4965_init_geos Channel 128 [5.2GHz] is restricted -- skipping.
[22269.597718] iwl4965: U iwl4965_init_geos Channel 132 [5.2GHz] is restricted -- skipping.
[22269.597724] iwl4965: U iwl4965_init_geos Channel 136 [5.2GHz] is restricted -- skipping.
[22269.597729] iwl4965: U iwl4965_init_geos Channel 140 [5.2GHz] is restricted -- skipping.
[22269.597734] iwl4965: U iwl4965_init_geos Channel 145 [5.2GHz] is restricted -- skipping.
[22269.597739] iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
[22269.600589] phy2: Selected rate control algorithm 'iwl-4965-rs'
[22285.989791] iwl4965: U iwl4965_mac_start enter
[22285.989838] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[23403.550151] iwl4965: U iwl4965_read_ucode Got firmware 'iwlwifi-4965-1.ucode' file (185764 bytes) from disk
[23403.550165] iwl4965: U iwl4965_read_ucode f/w package hdr ucode version = 0x42c0114
[23403.550170] iwl4965: U iwl4965_read_ucode f/w package hdr runtime inst size = 92720
[23403.550175] iwl4965: U iwl4965_read_ucode f/w package hdr runtime data size = 40960
[23403.550181] iwl4965: U iwl4965_read_ucode f/w package hdr init inst size = 10312
[23403.550185] iwl4965: U iwl4965_read_ucode f/w package hdr init data size = 40960
[23403.550190] iwl4965: U iwl4965_read_ucode f/w package hdr boot inst size = 788
[23403.550304] iwl4965: U iwl4965_read_ucode Copying (but not loading) uCode instr len 92720
[23403.550346] iwl4965: U iwl4965_read_ucode uCode instr buf vaddr = 0xffff810014440000, paddr = 0x14440000
[23403.550352] iwl4965: U iwl4965_read_ucode Copying (but not loading) uCode data len 40960
[23403.550388] iwl4965: U iwl4965_read_ucode Copying (but not loading) init instr len 10312
[23403.550397] iwl4965: U iwl4965_read_ucode Copying (but not loading) init data len 40960
[23403.550418] iwl4965: U iwl4965_read_ucode Copying (but not loading) boot instr len 788
[23403.550459] iwl4965: U iwl4965_power_init_handle Initialize power 
[23403.550474] iwl4965: U iwl4965_power_init_handle adjust power command flags
[23403.550557] iwl4965: U iwl4965_hw_nic_init HW Revision ID = 0x61
[23403.550645] iwl4965: U iwl4965_hw_card_show_info 4965ABGN HW Version 0.0.209
[23403.550651] iwl4965: U iwl4965_hw_card_show_info 4965ABGN PBA Number 4667005
[23403.552543] iwl4965: U iwl4965_load_bsm Begin load bsm
[23403.552936] iwl4965: U iwl4965_verify_bsm Begin verify bsm
[23403.553990] iwl4965: U iwl4965_verify_bsm BSM bootstrap uCode image OK
[23403.554027] iwl4965: U iwl4965_load_bsm BSM write complete, poll 1 iterations
[23403.554040] iwl4965: U __iwl4965_up iwl4965 is coming up
[23403.554044] iwl4965: U iwl4965_mac_start Start UP work done.
[23403.723401] iwl4965: I iwl4965_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
[23403.723401] iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
[23403.723401] iwl4965: I iwl4965_rx_reply_alive Initialization Alive received.
[23403.729241] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
[23403.729291] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
[23403.729812] iwl4965: U iwl4965_verify_ucode Initialize uCode is good in inst SRAM
[23403.729817] iwl4965: U iwl4965_get_temperature Running temperature calibration
[23403.729824] iwl4965: U iwl4965_get_temperature Calib values R[1-3]: 30 13848 -13734 R4: -2964
[23403.729830] iwl4965: U iwl4965_get_temperature Calibrated temperature: 314K, 41C
[23403.729835] iwl4965: U iwl4965_init_alive_start Initialization Alive received.
[23403.729860] iwl4965: U iwl4965_set_ucode_ptrs Runtime uCode pointers are set.
[23403.734045] iwl4965: I iwl4965_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
[23403.734051] iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
[23403.734056] iwl4965: I iwl4965_rx_reply_alive Runtime Alive received.
[23403.739233] iwl4965: U iwl4965_alive_start Runtime Alive received.
[23403.739243] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
[23403.739296] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
[23403.739342] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 92720
[23403.743900] iwl4965: U iwl4965_verify_ucode Runtime uCode is good in inst SRAM
[23403.744217] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 0 on AC 3
[23403.744223] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 1 on AC 2
[23403.744229] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 2 on AC 1
[23403.744235] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 3 on AC 0
[23403.744241] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 4 on AC 4
[23403.744246] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 5 on AC 5
[23403.744252] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 6 on AC 6
[23403.744265] iwl4965: U iwl4965_update_power_cmd Flags value = 0x00000000
[23403.744270] iwl4965: U iwl4965_update_power_cmd Tx timeout = 0
[23403.744274] iwl4965: U iwl4965_update_power_cmd Rx timeout = 0
[23403.744279] iwl4965: U iwl4965_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
[23403.744289] iwl4965: U iwl4965_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 40 bytes at 0[0]:4
[23403.744866] iwl4965: I iwl4965_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
[23403.744892] iwl4965: U iwl4965_set_rxon_chain rx chain 280E
[23403.744900] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
[23403.745478] iwl4965: I iwl4965_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
[23403.745503] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0402, 28 bytes at 2[2]:4
[23403.745514] iwl4965: U iwl4965_commit_rxon Sending RXON
[23403.745517] * without RXON_FILTER_ASSOC_MSK
[23403.745519] * channel = 1
[23403.745520] * bssid = 00:00:00:00:00:00
[23403.745527] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0403, 48 bytes at 3[3]:4
[23403.746090] iwl4965: I iwl4965_rx_handle r 5 i 4 No handler needed for SENSITIVITY_CMD, 0xa8
[22286.193626] iwl4965: I iwl4965_rx_handle r 6 i 5 No handler needed for REPLY_RXON, 0x10
[23403.747088] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0404, 28 bytes at 4[4]:4
[23403.747105] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0405, 140 bytes at 5[5]:4
[23403.747651] iwl4965: I iwl4965_rx_handle r 8 i 6 No handler needed for SENSITIVITY_CMD, 0xa8
[23403.747659] iwl4965: I iwl4965_rx_handle r 8 i 7 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[23403.747684] iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
[23403.747692] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0406, 72 bytes at 6[6]:4
[22286.195001] iwl4965: I iwl4965_rx_handle r = 9, i = 8, REPLY_ADD_STA, 0x18
[23403.748457] iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
[23403.748469] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0407, 92 bytes at 7[7]:4
[23403.748934] iwl4965: I iwl4965_rx_handle r = 11, i = 9, REPLY_4965_RX, 0xc3
[23403.748943] iwl4965: I iwl4965_handle_data_packet Dropping packet while interface is not open.
[23403.748950] iwl4965: I iwl4965_rx_handle r 11 i 10 No handler needed for REPLY_TX_LINK_QUALITY_CMD, 0x4e
[23403.748976] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_CT_KILL_CONFIG_CMD (#a4), seq: 0x0408, 16 bytes at 8[8]:4
[23403.748987] iwl4965: U iwl4965_mac_start leave
[23403.748993] iwl4965: U iwl4965_mac_add_interface enter: type 2
[23403.749603] iwl4965: I iwl4965_rx_handle r 12 i 11 No handler needed for REPLY_CT_KILL_CONFIG_CMD, 0xa4
[23403.749621] iwl4965: U iwl4965_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded
[23403.749625] iwl4965: U iwl4965_alive_start ALIVE processing complete.
[23403.749641] iwl4965: U iwl4965_mac_add_interface Set 00:13:e8:d3:41:e7
[23403.749647] iwl4965: U iwl4965_set_rxon_chain rx chain 280E
[23403.749658] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0409, 28 bytes at 9[9]:4
[23403.749667] iwl4965: U iwl4965_commit_rxon Sending RXON
[23403.749670] * without RXON_FILTER_ASSOC_MSK
[23403.749672] * channel = 1
[23403.749673] * bssid = 00:00:00:00:00:00
[23403.749680] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040A, 48 bytes at 10[10]:4
[22286.197638] iwl4965: I iwl4965_rx_handle r 14 i 12 No handler needed for SENSITIVITY_CMD, 0xa8
[22286.197647] iwl4965: I iwl4965_rx_handle r 14 i 13 No handler needed for REPLY_RXON, 0x10
[23403.751074] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040B, 28 bytes at 11[11]:4
[23403.751088] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040C, 140 bytes at 12[12]:4
[23403.751658] iwl4965: I iwl4965_rx_handle r 16 i 14 No handler needed for SENSITIVITY_CMD, 0xa8
[23403.751666] iwl4965: I iwl4965_rx_handle r 16 i 15 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[23403.751685] iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
[23403.751693] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040D, 72 bytes at 13[13]:4
[22286.198884] iwl4965: I iwl4965_rx_handle r = 17, i = 16, REPLY_ADD_STA, 0x18
[23403.752275] iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
[23403.752286] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x040E, 92 bytes at 14[14]:4
[23403.753532] iwl4965: I iwl4965_rx_handle r 18 i 17 No handler needed for REPLY_TX_LINK_QUALITY_CMD, 0x4e
[23403.753549] iwl4965: U iwl4965_mac_add_interface leave
[23403.753557] iwl4965: U iwl4965_mac_config_interface bssid: 00:00:00:00:00:00
[23403.753565] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040F, 28 bytes at 15[15]:4
[23403.753574] iwl4965: U iwl4965_commit_rxon Sending RXON
[23403.753576] * without RXON_FILTER_ASSOC_MSK
[23403.753578] * channel = 1
[23403.753580] * bssid = 00:00:00:00:00:00
[23403.753587] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0410, 48 bytes at 16[16]:4
[22286.200723] iwl4965: I iwl4965_rx_handle r 20 i 18 No handler needed for SENSITIVITY_CMD, 0xa8
[22286.200730] iwl4965: I iwl4965_rx_handle r 20 i 19 No handler needed for REPLY_RXON, 0x10
[23403.754162] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0411, 28 bytes at 17[17]:4
[23403.754176] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0412, 140 bytes at 18[18]:4
[23403.754741] iwl4965: I iwl4965_rx_handle r 22 i 20 No handler needed for SENSITIVITY_CMD, 0xa8
[23403.754748] iwl4965: I iwl4965_rx_handle r 22 i 21 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[23403.754768] iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
[23403.754776] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0413, 72 bytes at 19[19]:4
[23403.756217] iwl4965: I iwl4965_rx_handle r = 23, i = 22, REPLY_ADD_STA, 0x18
[23403.756232] iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
[23403.756241] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0414, 92 bytes at 20[20]:4
[22286.203677] iwl4965: I iwl4965_rx_handle r 24 i 23 No handler needed for REPLY_TX_LINK_QUALITY_CMD, 0x4e
[23403.757117] iwl4965: U iwl4965_mac_config_interface leave
[23403.759016] device wlan0 entered promiscuous mode
[23403.775901] iwl4965: U iwl4965_mac_remove_interface enter
[23403.775915] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0415, 28 bytes at 21[21]:4
[23403.775926] iwl4965: U iwl4965_commit_rxon Sending RXON
[23403.775928] * without RXON_FILTER_ASSOC_MSK
[23403.775930] * channel = 1
[23403.775932] * bssid = 00:00:00:00:00:00
[23403.775939] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0416, 48 bytes at 22[22]:4
[23403.786015] iwl4965: I iwl4965_rx_handle r 26 i 24 No handler needed for SENSITIVITY_CMD, 0xa8
[23403.786015] iwl4965: I iwl4965_rx_handle r 26 i 25 No handler needed for REPLY_RXON, 0x10
[23403.786015] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0417, 28 bytes at 23[23]:4
[23403.786015] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0418, 140 bytes at 24[24]:4
[22286.233234] iwl4965: I iwl4965_rx_handle r 28 i 26 No handler needed for SENSITIVITY_CMD, 0xa8
[22286.233234] iwl4965: I iwl4965_rx_handle r 28 i 27 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[22286.233234] iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
[22286.233234] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0419, 72 bytes at 25[25]:4
[23403.786015] iwl4965: I iwl4965_rx_handle r = 29, i = 28, REPLY_ADD_STA, 0x18
[22286.233348] iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
[22286.233348] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041A, 92 bytes at 26[26]:4
[22286.233427] iwl4965: I iwl4965_rx_handle r 30 i 29 No handler needed for REPLY_TX_LINK_QUALITY_CMD, 0x4e
[22286.233427] iwl4965: U iwl4965_mac_remove_interface leave
[22286.241967] iwl4965: U iwl4965_mac_stop enter
[22286.241977] iwl4965: U __iwl4965_down iwl4965 is going down
[22286.273583] iwl4965: U iwl4965_hw_nic_stop_master stop master
[22286.273610] iwl4965: U iwl4965_hw_nic_stop_master stop master
[22286.276783] iwl4965: U iwl4965_clear_free_frames 0 frames on pre-allocated heap on clear.
[22286.280327] iwl4965: U iwl4965_mac_stop leave
[22286.282286] iwl4965: U iwl4965_mac_start enter
[22286.282337] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[22286.282788] iwl4965: U iwl4965_power_init_handle Initialize power 
[22286.282804] iwl4965: U iwl4965_power_init_handle adjust power command flags
[22286.282883] iwl4965: U iwl4965_hw_nic_init HW Revision ID = 0x61
[22286.282961] iwl4965: U iwl4965_hw_card_show_info 4965ABGN HW Version 0.0.209
[22286.282967] iwl4965: U iwl4965_hw_card_show_info 4965ABGN PBA Number 4667005
[22286.284747] iwl4965: U iwl4965_load_bsm Begin load bsm
[22286.285140] iwl4965: U iwl4965_verify_bsm Begin verify bsm
[22286.286141] iwl4965: U iwl4965_verify_bsm BSM bootstrap uCode image OK
[22286.286176] iwl4965: U iwl4965_load_bsm BSM write complete, poll 1 iterations
[22286.286188] iwl4965: U __iwl4965_up iwl4965 is coming up
[22286.286192] iwl4965: U iwl4965_mac_start Start UP work done.
[23406.012165] iwl4965: I iwl4965_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
[23406.012165] iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
[23406.012165] iwl4965: I iwl4965_rx_reply_alive Initialization Alive received.
[23406.018849] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
[23406.018901] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
[23406.019422] iwl4965: U iwl4965_verify_ucode Initialize uCode is good in inst SRAM
[23406.019427] iwl4965: U iwl4965_get_temperature Running temperature calibration
[23406.019433] iwl4965: U iwl4965_get_temperature Calib values R[1-3]: 28 13856 -13756 R4: -3132
[23406.019439] iwl4965: U iwl4965_get_temperature Calibrated temperature: 317K, 44C
[23406.019443] iwl4965: U iwl4965_init_alive_start Initialization Alive received.
[23406.019467] iwl4965: U iwl4965_set_ucode_ptrs Runtime uCode pointers are set.
[23406.021101] iwl4965: I iwl4965_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
[23406.021109] iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
[23406.021114] iwl4965: I iwl4965_rx_reply_alive Runtime Alive received.
[23406.025514] iwl4965: U iwl4965_alive_start Runtime Alive received.
[23406.025525] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
[23406.025572] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
[23406.025617] iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 92720
[23406.030166] iwl4965: U iwl4965_verify_ucode Runtime uCode is good in inst SRAM
[23406.030480] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 0 on AC 3
[23406.030486] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 1 on AC 2
[23406.030491] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 2 on AC 1
[23406.030497] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 3 on AC 0
[23406.030502] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 4 on AC 4
[23406.030508] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 5 on AC 5
[23406.030513] iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 6 on AC 6
[23406.030525] iwl4965: U iwl4965_update_power_cmd Flags value = 0x00000000
[23406.030530] iwl4965: U iwl4965_update_power_cmd Tx timeout = 0
[23406.030534] iwl4965: U iwl4965_update_power_cmd Rx timeout = 0
[23406.030539] iwl4965: U iwl4965_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
[23406.030548] iwl4965: U iwl4965_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 40 bytes at 0[0]:4
[23406.031108] iwl4965: I iwl4965_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
[23406.031660] iwl4965: U iwl4965_set_rxon_chain rx chain 280E
[23406.031670] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
[23406.032220] iwl4965: I iwl4965_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
[23406.032247] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0402, 28 bytes at 2[2]:4
[23406.032258] iwl4965: U iwl4965_commit_rxon Sending RXON
[23406.032260] * without RXON_FILTER_ASSOC_MSK
[23406.032263] * channel = 1
[23406.032264] * bssid = 00:00:00:00:00:00
[23406.032272] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0403, 48 bytes at 3[3]:4
[22286.476126] iwl4965: I iwl4965_rx_handle r 5 i 4 No handler needed for SENSITIVITY_CMD, 0xa8
[23406.033810] iwl4965: I iwl4965_rx_handle r 6 i 5 No handler needed for REPLY_RXON, 0x10
[23406.033831] iwl4965: U iwl4965_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x0404, 28 bytes at 4[4]:4
[23406.033848] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0405, 140 bytes at 5[5]:4
[22286.477826] iwl4965: I iwl4965_rx_handle r 7 i 6 No handler needed for SENSITIVITY_CMD, 0xa8
[23406.035525] iwl4965: I iwl4965_rx_handle r 8 i 7 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[23406.035551] iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
[23406.035559] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0406, 72 bytes at 6[6]:4
[22286.480685] iwl4965: I iwl4965_rx_handle r = 9, i = 8, REPLY_ADD_STA, 0x18
[23406.037409] iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
[23406.037419] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0407, 92 bytes at 7[7]:4
[23406.042243] iwl4965: I iwl4965_rx_handle r 10 i 9 No handler needed for REPLY_TX_LINK_QUALITY_CMD, 0x4e
[23406.042243] iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_CT_KILL_CONFIG_CMD (#a4), seq: 0x0408, 16 bytes at 8[8]:4
[23406.042243] iwl4965: U iwl4965_mac_start leave
[22286.486179] iwl4965: I iwl4965_rx_handle r 11 i 10 No handler needed for REPLY_CT_KILL_CONFIG_CMD, 0xa4
[23406.042243] iwl4965: U iwl4965_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded
[23406.042243] iwl4965: U iwl4965_alive_start ALIVE processing complete.
[23406.042243] iwl4965: U iwl4965_mac_config enter to channel 6
[23406.042243] iwl4965: U iwl4965_mac_config leave - not ready
[23406.046410] iwl4965: U iwl4965_mac_config enter to channel 6
[23406.046417] iwl4965: U iwl4965_mac_config leave - not ready
[23406.125591] iwl4965: I iwl4965_rx_handle r = 12, i = 11, REPLY_4965_RX, 0xc3
[23406.415055] iwl4965: I iwl4965_rx_handle r = 13, i = 12, REPLY_4965_RX, 0xc3
[23406.517492] iwl4965: I iwl4965_rx_handle r = 14, i = 13, REPLY_4965_RX, 0xc3
[23406.635887] iwl4965: I iwl4965_rx_handle r = 15, i = 14, REPLY_4965_RX, 0xc3
[23406.746654] iwl4965: I iwl4965_rx_handle r = 16, i = 15, REPLY_4965_RX, 0xc3
[23407.064417] iwl4965: I iwl4965_rx_handle r = 17, i = 16, REPLY_4965_RX, 0xc3
[23407.612950] iwl4965: I iwl4965_rx_handle r = 18, i = 17, REPLY_4965_RX, 0xc3
[23408.602921] iwl4965: I iwl4965_rx_handle r = 19, i = 18, REPLY_4965_RX, 0xc3
[23408.877224] iwl4965: I iwl4965_rx_handle r = 20, i = 19, REPLY_4965_RX, 0xc3
[23409.723122] iwl4965: I iwl4965_rx_handle r = 21, i = 20, REPLY_4965_RX, 0xc3
[23410.249973] iwl4965: I iwl4965_rx_handle r = 22, i = 21, REPLY_4965_RX, 0xc3
[23410.587317] iwl4965: I iwl4965_rx_handle r = 23, i = 22, REPLY_4965_RX, 0xc3
[23410.802627] iwl4965: I iwl4965_rx_handle r = 24, i = 23, REPLY_4965_RX, 0xc3
[23411.847699] iwl4965: I iwl4965_rx_handle r = 25, i = 24, REPLY_4965_RX, 0xc3
[23411.943323] iwl4965: I iwl4965_rx_handle r = 26, i = 25, REPLY_4965_RX, 0xc3
[23412.371389] iwl4965: I iwl4965_rx_handle r = 27, i = 26, REPLY_4965_RX, 0xc3
[23412.571657] iwl4965: I iwl4965_rx_handle r = 28, i = 27, REPLY_4965_RX, 0xc3
[23413.005955] iwl4965: I iwl4965_rx_handle r = 29, i = 28, REPLY_4965_RX, 0xc3
[23413.435712] iwl4965: I iwl4965_rx_handle r = 30, i = 29, REPLY_4965_RX, 0xc3
[23413.854104] iwl4965: I iwl4965_rx_handle r = 31, i = 30, REPLY_4965_RX, 0xc3
[23414.281908] iwl4965: I iwl4965_rx_handle r = 32, i = 31, REPLY_4965_RX, 0xc3
[23414.496039] iwl4965: I iwl4965_rx_handle r = 33, i = 32, REPLY_4965_RX, 0xc3
[23415.377650] iwl4965: I iwl4965_rx_handle r = 34, i = 33, REPLY_4965_RX, 0xc3
[23415.473272] iwl4965: I iwl4965_rx_handle r = 35, i = 34, REPLY_4965_RX, 0xc3
[23415.694427] iwl4965: I iwl4965_rx_handle r = 36, i = 35, REPLY_4965_RX, 0xc3
[23416.125045] iwl4965: I iwl4965_rx_handle r = 37, i = 36, REPLY_4965_RX, 0xc3
[23416.240853] iwl4965: I iwl4965_rx_handle r = 38, i = 37, REPLY_4965_RX, 0xc3
[23416.767260] iwl4965: I iwl4965_rx_handle r = 39, i = 38, REPLY_4965_RX, 0xc3
[23416.992072] iwl4965: I iwl4965_rx_handle r = 40, i = 39, REPLY_4965_RX, 0xc3
[23417.214979] iwl4965: I iwl4965_rx_handle r = 41, i = 40, REPLY_4965_RX, 0xc3
[23417.309599] iwl4965: I iwl4965_rx_handle r = 42, i = 41, REPLY_4965_RX, 0xc3
[23417.418525] iwl4965: I iwl4965_rx_handle r = 43, i = 42, REPLY_4965_RX, 0xc3
[23417.523550] iwl4965: I iwl4965_rx_handle r = 44, i = 43, REPLY_4965_RX, 0xc3
[23417.842472] iwl4965: I iwl4965_rx_handle r = 45, i = 44, REPLY_4965_RX, 0xc3
[23418.058390] iwl4965: I iwl4965_rx_handle r = 46, i = 45, REPLY_4965_RX, 0xc3
[23418.270855] iwl4965: I iwl4965_rx_handle r = 47, i = 46, REPLY_4965_RX, 0xc3
[23418.498605] iwl4965: I iwl4965_rx_handle r = 48, i = 47, REPLY_4965_RX, 0xc3
[23419.028034] iwl4965: I iwl4965_rx_handle r = 49, i = 48, REPLY_4965_RX, 0xc3
[23419.125484] iwl4965: I iwl4965_rx_handle r = 50, i = 49, REPLY_4965_RX, 0xc3
[23419.565528] iwl4965: I iwl4965_rx_handle r = 51, i = 50, REPLY_4965_RX, 0xc3
[23420.003852] iwl4965: I iwl4965_rx_handle r = 52, i = 51, REPLY_4965_RX, 0xc3
[23420.412647] iwl4965: I iwl4965_rx_handle r = 53, i = 52, REPLY_4965_RX, 0xc3
[23421.034216] iwl4965: I iwl4965_rx_handle r = 54, i = 53, REPLY_4965_RX, 0xc3
[23421.126674] iwl4965: I iwl4965_rx_handle r = 55, i = 54, REPLY_4965_RX, 0xc3
[23421.333897] iwl4965: I iwl4965_rx_handle r = 56, i = 55, REPLY_4965_RX, 0xc3
[23421.659511] iwl4965: I iwl4965_rx_handle r = 57, i = 56, REPLY_4965_RX, 0xc3
[23421.977315] iwl4965: I iwl4965_rx_handle r = 58, i = 57, REPLY_4965_RX, 0xc3
[23422.535784] iwl4965: I iwl4965_rx_handle r = 59, i = 58, REPLY_4965_RX, 0xc3
[23423.145976] iwl4965: I iwl4965_rx_handle r = 60, i = 59, REPLY_4965_RX, 0xc3
[23423.550122] iwl4965: I iwl4965_rx_handle r = 61, i = 60, REPLY_4965_RX, 0xc3
[23423.757841] iwl4965: I iwl4965_rx_handle r = 62, i = 61, REPLY_4965_RX, 0xc3
[23424.279694] iwl4965: I iwl4965_rx_handle r = 63, i = 62, REPLY_4965_RX, 0xc3
[23424.390258] iwl4965: I iwl4965_rx_handle r = 64, i = 63, REPLY_4965_RX, 0xc3
[23424.499114] iwl4965: I iwl4965_rx_handle r = 65, i = 64, REPLY_4965_RX, 0xc3
[23425.092398] iwl4965: I iwl4965_rx_handle r = 66, i = 65, REPLY_4965_RX, 0xc3
[23425.295604] iwl4965: I iwl4965_rx_handle r = 67, i = 66, REPLY_4965_RX, 0xc3
[23425.391628] iwl4965: I iwl4965_rx_handle r = 68, i = 67, REPLY_4965_RX, 0xc3
[23425.493680] iwl4965: I iwl4965_rx_handle r = 69, i = 68, REPLY_4965_RX, 0xc3
[23425.817713] iwl4965: I iwl4965_rx_handle r = 70, i = 69, REPLY_4965_RX, 0xc3
[23425.898370] iwl4965: I iwl4965_rx_handle r = 71, i = 70, REPLY_4965_RX, 0xc3
[23426.016235] iwl4965: I iwl4965_rx_handle r = 72, i = 71, REPLY_4965_RX, 0xc3
[23426.302960] iwl4965: I iwl4965_rx_handle r = 73, i = 72, REPLY_4965_RX, 0xc3
[23426.421174] iwl4965: I iwl4965_rx_handle r = 74, i = 73, REPLY_4965_RX, 0xc3
[23426.522431] iwl4965: I iwl4965_rx_handle r = 75, i = 74, REPLY_4965_RX, 0xc3
[23426.635028] iwl4965: I iwl4965_rx_handle r = 76, i = 75, REPLY_4965_RX, 0xc3
[23426.835676] iwl4965: I iwl4965_rx_handle r = 77, i = 76, REPLY_4965_RX, 0xc3
[23427.149432] iwl4965: I iwl4965_rx_handle r = 78, i = 77, REPLY_4965_RX, 0xc3
[23427.235227] iwl4965: I iwl4965_rx_handle r = 79, i = 78, REPLY_4965_RX, 0xc3
[23427.354652] iwl4965: I iwl4965_rx_handle r = 80, i = 79, REPLY_4965_RX, 0xc3
[23427.458820] iwl4965: I iwl4965_rx_handle r = 81, i = 80, REPLY_4965_RX, 0xc3
[23428.062419] iwl4965: I iwl4965_rx_handle r = 82, i = 81, REPLY_4965_RX, 0xc3
[23428.500133] iwl4965: I iwl4965_rx_handle r = 83, i = 82, REPLY_4965_RX, 0xc3
[23428.600624] iwl4965: I iwl4965_rx_handle r = 84, i = 83, REPLY_4965_RX, 0xc3
[23429.111392] iwl4965: I iwl4965_rx_handle r = 85, i = 84, REPLY_4965_RX, 0xc3
[23429.448865] iwl4965: I iwl4965_rx_handle r = 86, i = 85, REPLY_4965_RX, 0xc3
[23429.550396] iwl4965: I iwl4965_rx_handle r = 87, i = 86, REPLY_4965_RX, 0xc3
[23429.655857] iwl4965: I iwl4965_rx_handle r = 88, i = 87, REPLY_4965_RX, 0xc3
[23429.763252] iwl4965: I iwl4965_rx_handle r = 89, i = 88, REPLY_4965_RX, 0xc3
[23429.874573] iwl4965: I iwl4965_rx_handle r = 90, i = 89, REPLY_4965_RX, 0xc3
[23430.301277] iwl4965: I iwl4965_rx_handle r = 91, i = 90, REPLY_4965_RX, 0xc3
[23430.417095] iwl4965: I iwl4965_rx_handle r = 92, i = 91, REPLY_4965_RX, 0xc3
[23430.956032] iwl4965: I iwl4965_rx_handle r = 93, i = 92, REPLY_4965_RX, 0xc3
[23431.169617] iwl4965: I iwl4965_rx_handle r = 94, i = 93, REPLY_4965_RX, 0xc3
[23431.250734] iwl4965: I iwl4965_rx_handle r = 95, i = 94, REPLY_4965_RX, 0xc3
[23431.354947] iwl4965: I iwl4965_rx_handle r = 96, i = 95, REPLY_4965_RX, 0xc3
[23431.465586] iwl4965: I iwl4965_rx_handle r = 97, i = 96, REPLY_4965_RX, 0xc3
[23431.568207] iwl4965: I iwl4965_rx_handle r = 98, i = 97, REPLY_4965_RX, 0xc3
[23432.399226] iwl4965: I iwl4965_rx_handle r = 99, i = 98, REPLY_4965_RX, 0xc3
[23432.615184] iwl4965: I iwl4965_rx_handle r = 100, i = 99, REPLY_4965_RX, 0xc3
[23432.839800] iwl4965: I iwl4965_rx_handle r = 101, i = 100, REPLY_4965_RX, 0xc3
[23433.063317] iwl4965: I iwl4965_rx_handle r = 102, i = 101, REPLY_4965_RX, 0xc3
[23433.247373] iwl4965: I iwl4965_rx_handle r = 103, i = 102, REPLY_4965_RX, 0xc3
[23433.463984] iwl4965: I iwl4965_rx_handle r = 104, i = 103, REPLY_4965_RX, 0xc3
[23433.582826] iwl4965: I iwl4965_rx_handle r = 105, i = 104, REPLY_4965_RX, 0xc3
[23433.803379] iwl4965: I iwl4965_rx_handle r = 106, i = 105, REPLY_4965_RX, 0xc3
[23434.207167] iwl4965: I iwl4965_rx_handle r = 107, i = 106, REPLY_4965_RX, 0xc3
[23434.826336] iwl4965: I iwl4965_rx_handle r = 108, i = 107, REPLY_4965_RX, 0xc3
[23435.035725] iwl4965: I iwl4965_rx_handle r = 109, i = 108, REPLY_4965_RX, 0xc3
[23435.123137] iwl4965: I iwl4965_rx_handle r = 110, i = 109, REPLY_4965_RX, 0xc3
[23435.329357] iwl4965: I iwl4965_rx_handle r = 111, i = 110, REPLY_4965_RX, 0xc3
[23435.634713] iwl4965: I iwl4965_rx_handle r = 112, i = 111, REPLY_4965_RX, 0xc3
[23436.082069] iwl4965: I iwl4965_rx_handle r = 113, i = 112, REPLY_4965_RX, 0xc3
[23436.411663] iwl4965: I iwl4965_rx_handle r = 114, i = 113, REPLY_4965_RX, 0xc3
[23436.505438] iwl4965: I iwl4965_rx_handle r = 115, i = 114, REPLY_4965_RX, 0xc3
[23436.634860] iwl4965: I iwl4965_rx_handle r = 116, i = 115, REPLY_4965_RX, 0xc3
[23436.756564] iwl4965: I iwl4965_rx_handle r = 117, i = 116, REPLY_4965_RX, 0xc3
[23436.841456] iwl4965: I iwl4965_rx_handle r = 118, i = 117, REPLY_4965_RX, 0xc3
[23437.050265] iwl4965: I iwl4965_rx_handle r = 119, i = 118, REPLY_4965_RX, 0xc3

--sdtB3X0nJg68CQEu--
