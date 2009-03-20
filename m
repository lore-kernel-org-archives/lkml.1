Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZCTQks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZCTQks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZCTQkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:40:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:45241 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbZCTQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=CJB25vYITjT63MvLHI7MAlVpjhqFwqLQEjC6Y082UyX9NdNLknjZIsX0JORNZUWK22
         HpXM0aJckEetLNOP2SBB+qf+/xbc9YFlq0+Vgyf7qU90PcserBDgbFS4W6QusuiM5saW
         jHbCphKxHU4dxx0Cbu242JBbSsJcIHeLGAXoI=
From: Andrey Batyiev <batyiev@gmail.com>
To: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Problem on connecting on iwl3945 wifi card
Date: Fri, 20 Mar 2009 18:43:05 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.28.7; KDE/4.2.1; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903201843.06190.batyiev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm using 2.6.28.7 and driver requests iwlwifi-3945-1.ucode firmware. I'm trying 
to connect by my wifi card and get the following in syslog:

Mar 20 18:10:30 localhost kernel: [ 1531.002769] wlan0: Selected IBSS BSSID 
00:ed:3f:ed:94:00 based on configured SSID
Mar 20 18:10:30 localhost kernel: [ 1531.008142] ------------[ cut here 
]------------
Mar 20 18:10:30 localhost kernel: [ 1531.008147] WARNING: at 
net/mac80211/main.c:159 ieee80211_if_config+0x24/0x128()
Mar 20 18:10:30 localhost kernel: [ 1531.008150] Modules linked in: nls_utf8 
nls_cp866 vfat fat bridge stp llc bnep sco rfcomm l2cap btusb bluetooth i915 
drm coretemp hwmon snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss tun acpi_cpufreq fuse r8169 rtc_cmos rtc_core 
rtc_lib firewire_ohci firewire_core crc_itu_t iwl3945 sdhci_pci ohci1394 sdhci 
ieee1394 snd_hda_intel iTCO_wdt mmc_core iTCO_vendor_support i2c_i801 snd_pcm 
snd_timer snd_page_alloc snd_hwdep snd video soundcore uhci_hcd output thermal 
processor dcdbas wmi battery ac button
Mar 20 18:10:30 localhost kernel: [ 1531.008218] Pid: 1540, comm: iwl3945/0 
Not tainted 2.6.28.7 #1
Mar 20 18:10:30 localhost kernel: [ 1531.008221] Call Trace:
Mar 20 18:10:30 localhost kernel: [ 1531.008229]  [<c011ea07>] 
warn_on_slowpath+0x40/0x59
Mar 20 18:10:30 localhost kernel: [ 1531.008236]  [<c012dceb>] 
finish_wait+0x27/0x48
Mar 20 18:10:30 localhost kernel: [ 1531.008251]  [<f86e60aa>] 
iwl3945_send_cmd_sync+0x604/0xc3c [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008257]  [<c012dbf0>] 
autoremove_wake_function+0x0/0x2d
Mar 20 18:10:30 localhost kernel: [ 1531.008269]  [<f86e6899>] 
iwl3945_send_cmd_pdu+0x2d/0x34 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008283]  [<f86ed68e>] 
iwl3945_init_hw_rate_table+0xd9/0xe1 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008295]  [<f86e735f>] 
iwl3945_commit_rxon+0x428/0x483 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008301]  [<c040ca42>] 
ieee80211_if_config+0x24/0x128
Mar 20 18:10:30 localhost kernel: [ 1531.008313]  [<f86e979d>] 
iwl3945_mac_reset_tsf+0xdd/0xf9 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008318]  [<c0412bd8>] 
ieee80211_sta_join_ibss+0x63/0x36d
Mar 20 18:10:30 localhost kernel: [ 1531.008325]  [<c01fa674>] 
scnprintf+0x1f/0x2b
Mar 20 18:10:30 localhost kernel: [ 1531.008330]  [<c0413016>] 
ieee80211_sta_find_ibss+0x134/0x391
Mar 20 18:10:30 localhost kernel: [ 1531.008335]  [<c0102c82>] 
need_resched+0x1f/0x21
Mar 20 18:10:30 localhost kernel: [ 1531.008340]  [<c0407b6c>] 
wireless_send_event+0x274/0x28c
Mar 20 18:10:30 localhost kernel: [ 1531.008345]  [<c0415e2a>] 
ieee80211_mlme_notify_scan_completed+0x41/0x9b
Mar 20 18:10:30 localhost kernel: [ 1531.008350]  [<c0410ed6>] 
ieee80211_scan_completed+0x2a6/0x2b5
Mar 20 18:10:30 localhost kernel: [ 1531.008356]  [<c0440eb7>] 
schedule+0x5a1/0x5f6
Mar 20 18:10:30 localhost kernel: [ 1531.008368]  [<f86e8d1d>] 
iwl3945_bg_scan_completed+0x0/0x54 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008380]  [<f86e8d57>] 
iwl3945_bg_scan_completed+0x3a/0x54 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008385]  [<c012b0ac>] 
run_workqueue+0x6e/0xf3
Mar 20 18:10:30 localhost kernel: [ 1531.008390]  [<c012b81c>] 
worker_thread+0x0/0xbd
Mar 20 18:10:30 localhost kernel: [ 1531.008395]  [<c012b8cf>] 
worker_thread+0xb3/0xbd
Mar 20 18:10:30 localhost kernel: [ 1531.008399]  [<c012dbf0>] 
autoremove_wake_function+0x0/0x2d
Mar 20 18:10:30 localhost kernel: [ 1531.008404]  [<c012db2e>] 
kthread+0x38/0x5e
Mar 20 18:10:30 localhost kernel: [ 1531.008409]  [<c012daf6>] 
kthread+0x0/0x5e
Mar 20 18:10:30 localhost kernel: [ 1531.008414]  [<c0103aa7>] 
kernel_thread_helper+0x7/0x10
Mar 20 18:10:30 localhost kernel: [ 1531.008417] ---[ end trace 
699f9f94ee9081eb ]---
Mar 20 18:10:30 localhost kernel: [ 1531.008425] ------------[ cut here 
]------------
Mar 20 18:10:30 localhost kernel: [ 1531.008428] WARNING: at 
net/mac80211/main.c:159 ieee80211_if_config+0x24/0x128()
Mar 20 18:10:30 localhost kernel: [ 1531.008431] Modules linked in: nls_utf8 
nls_cp866 vfat fat bridge stp llc bnep sco rfcomm l2cap btusb bluetooth i915 
drm coretemp hwmon snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss tun acpi_cpufreq fuse r8169 rtc_cmos rtc_core 
rtc_lib firewire_ohci firewire_core crc_itu_t iwl3945 sdhci_pci ohci1394 sdhci 
ieee1394 snd_hda_intel iTCO_wdt mmc_core iTCO_vendor_support i2c_i801 snd_pcm 
snd_timer snd_page_alloc snd_hwdep snd video soundcore uhci_hcd output thermal 
processor dcdbas wmi battery ac button
Mar 20 18:10:30 localhost kernel: [ 1531.008491] Pid: 1540, comm: iwl3945/0 
Tainted: G        W  2.6.28.7 #1
Mar 20 18:10:30 localhost kernel: [ 1531.008493] Call Trace:
Mar 20 18:10:30 localhost kernel: [ 1531.008498]  [<c011ea07>] 
warn_on_slowpath+0x40/0x59
Mar 20 18:10:30 localhost kernel: [ 1531.008504]  [<c012dceb>] 
finish_wait+0x27/0x48
Mar 20 18:10:30 localhost kernel: [ 1531.008516]  [<f86e60aa>] 
iwl3945_send_cmd_sync+0x604/0xc3c [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008522]  [<c012dbf0>] 
autoremove_wake_function+0x0/0x2d
Mar 20 18:10:30 localhost kernel: [ 1531.008533]  [<f86e6899>] 
iwl3945_send_cmd_pdu+0x2d/0x34 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008546]  [<f86ed68e>] 
iwl3945_init_hw_rate_table+0xd9/0xe1 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008553]  [<c03bbf58>] 
dev_alloc_skb+0x11/0x25
Mar 20 18:10:30 localhost kernel: [ 1531.008558]  [<c040ca42>] 
ieee80211_if_config+0x24/0x128
Mar 20 18:10:30 localhost kernel: [ 1531.008562]  [<c03bbc7b>] 
__alloc_skb+0x4d/0xf9
Mar 20 18:10:30 localhost kernel: [ 1531.008567]  [<c0412dd9>] 
ieee80211_sta_join_ibss+0x264/0x36d
Mar 20 18:10:30 localhost kernel: [ 1531.008572]  [<c0413016>] 
ieee80211_sta_find_ibss+0x134/0x391
Mar 20 18:10:30 localhost kernel: [ 1531.008577]  [<c0102c82>] 
need_resched+0x1f/0x21
Mar 20 18:10:30 localhost kernel: [ 1531.008582]  [<c0407b6c>] 
wireless_send_event+0x274/0x28c
Mar 20 18:10:30 localhost kernel: [ 1531.008587]  [<c0415e2a>] 
ieee80211_mlme_notify_scan_completed+0x41/0x9b
Mar 20 18:10:30 localhost kernel: [ 1531.008592]  [<c0410ed6>] 
ieee80211_scan_completed+0x2a6/0x2b5
Mar 20 18:10:30 localhost kernel: [ 1531.008597]  [<c0440eb7>] 
schedule+0x5a1/0x5f6
Mar 20 18:10:30 localhost kernel: [ 1531.008609]  [<f86e8d1d>] 
iwl3945_bg_scan_completed+0x0/0x54 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008621]  [<f86e8d57>] 
iwl3945_bg_scan_completed+0x3a/0x54 [iwl3945]
Mar 20 18:10:30 localhost kernel: [ 1531.008626]  [<c012b0ac>] 
run_workqueue+0x6e/0xf3
Mar 20 18:10:30 localhost kernel: [ 1531.008630]  [<c012b81c>] 
worker_thread+0x0/0xbd
Mar 20 18:10:30 localhost kernel: [ 1531.008635]  [<c012b8cf>] 
worker_thread+0xb3/0xbd
Mar 20 18:10:30 localhost kernel: [ 1531.008640]  [<c012dbf0>] 
autoremove_wake_function+0x0/0x2d
Mar 20 18:10:30 localhost kernel: [ 1531.008645]  [<c012db2e>] 
kthread+0x38/0x5e
Mar 20 18:10:30 localhost kernel: [ 1531.008649]  [<c012daf6>] 
kthread+0x0/0x5e
Mar 20 18:10:30 localhost kernel: [ 1531.008654]  [<c0103aa7>] 
kernel_thread_helper+0x7/0x10
Mar 20 18:10:30 localhost kernel: [ 1531.008657] ---[ end trace 
699f9f94ee9081eb ]---

Thanks,
   Andrey
