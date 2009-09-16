Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbZIPJgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbZIPJgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZIPJgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:36:16 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35272 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZIPJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZXKQNT6zXcszx+l+Ik7BughRb8wkI39zh1EpeCaWd+nt2nTx/bzCHWdWTNV4dHPmHT
         dsXJs1x/W9N+psogpAuQwzAWyFreUmPuZR+ULMJ6QPMjV44gwTBJK1iBHyjkwxPTusJt
         d478vQ5cTZ+m5vyhGKhMkpQ+FYcRENHisdGKM=
MIME-Version: 1.0
Date: Wed, 16 Sep 2009 11:36:12 +0200
Message-ID: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
Subject: WARNING: at net/mac80211/scan.c:267 ieee80211_scan_completed+0x299/0x2b0 
	[mac80211]()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       ilw@linux.intel.com, yi.zhu@intel.com, reinette.chatre@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device: 08:00.0 Network controller: Intel Corporation PRO/Wireless
3945ABG [Golan] Network Connection (rev 02)
Last known good: 2.6.31
Bad: 26.31-git4
I use wicd to connect to wireless network.

Steps to reproduce:
1. Connect to the wireless network (WPA2), it takes long time (longer
than in 2.6.31)
2. Connect to another wireless network:
3. Connect fails with error:

[  163.208063] ------------[ cut here ]------------
[  163.208114] WARNING: at net/mac80211/scan.c:267
ieee80211_scan_completed+0x299/0x2b0 [mac80211]()
[  163.208122] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
[  163.208127] Modules linked in: i915 drm i2c_algo_bit i2c_core sco
bnep rfcomm l2cap crc16 xt_tcpudp xt_limit xt_state iptable_filter
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
aes_i586 aes_generic cbc dm_crypt dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod hp_wmi fuse sbp2 loop snd_hda_codec_si3054
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
snd_mixer_oss arc4 btusb bluetooth ecb snd_pcm snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi iwl3945 snd_seq_midi_event
iwlcore pcmcia snd_seq firmware_class snd_timer b44 snd_seq_device
yenta_socket mac80211 uhci_hcd ssb rsrc_nonstatic ohci1394 intel_agp
video led_class snd ehci_hcd pcmcia_core mii agpgart backlight
soundcore rtc_cmos snd_page_alloc cfg80211 ieee1394 psmouse usbcore
rtc_core serio_raw sg output rfkill ac fan battery rtc_lib button
evdev
[  163.208301] Pid: 3597, comm: wpa_supplicant Not tainted 2.6.31-git4
#1
[  163.208305] Call Trace:
[  163.208316]  [<c03dd315>] ? printk+0x1d/0x20
[  163.208333]  [<f8485a69>] ? ieee80211_scan_completed+0x299/0x2b0
[mac80211]
[  163.208341]  [<c013b001>] warn_slowpath_common+0x71/0xc0
[  163.208358]  [<f8485a69>] ? ieee80211_scan_completed+0x299/0x2b0
[mac80211]
[  163.208364]  [<c013b06a>] warn_slowpath_null+0x1a/0x20
[  163.208382]  [<f8485a69>] ieee80211_scan_completed+0x299/0x2b0
[mac80211]
[  163.208398]  [<f8485ac9>] ieee80211_scan_cancel+0x49/0x80
[mac80211]
[  163.208416]  [<f848dd87>] ieee80211_stop+0x587/0x590 [mac80211]
[  163.208422]  [<c03dfb62>] ? _spin_unlock_bh+0x12/0x20
[  163.208431]  [<c0369ecb>] dev_close+0x6b/0xc0
[  163.208436]  [<c03dfb62>] ? _spin_unlock_bh+0x12/0x20
[  163.208441]  [<c036782f>] ? dev_set_rx_mode+0x2f/0x40
[  163.208446]  [<c0369766>] dev_change_flags+0x86/0x1a0
[  163.208453]  [<c03acf0a>] devinet_ioctl+0x66a/0x680
[  163.208458]  [<c036ac35>] ? dev_ioctl+0x295/0x550
[  163.208464]  [<c03adfb2>] inet_ioctl+0xa2/0xd0
[  163.208471]  [<c0358798>] sock_ioctl+0x68/0x270
[  163.208476]  [<c0358730>] ? sock_ioctl+0x0/0x270
[  163.208483]  [<c01dd24d>] vfs_ioctl+0x2d/0xa0
[  163.208488]  [<c01dd412>] do_vfs_ioctl+0x72/0x5f0
[  163.208494]  [<c035a24b>] ? sys_send+0x3b/0x40
[  163.208500]  [<c035acb8>] ? sys_socketcall+0x1d8/0x2b0
[  163.208505]  [<c01dda12>] sys_ioctl+0x82/0x90
[  163.208511]  [<c0102f04>] sysenter_do_call+0x12/0x22
[  163.208515] ---[ end trace 4a480a90c21becfb ]---
[  163.232845] ------------[ cut here ]------------
[  163.232908] WARNING: at net/wireless/core.c:613
wdev_cleanup_work+0xbb/0xe0 [cfg80211]()
[  163.232915] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
[  163.232921] Modules linked in: i915 drm i2c_algo_bit i2c_core sco
bnep rfcomm l2cap crc16 xt_tcpudp xt_limit xt_state iptable_filter
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
aes_i586 aes_generic cbc dm_crypt dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod hp_wmi fuse sbp2 loop snd_hda_codec_si3054
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
snd_mixer_oss arc4 btusb bluetooth ecb snd_pcm snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi iwl3945 snd_seq_midi_event
iwlcore pcmcia snd_seq firmware_class snd_timer b44 snd_seq_device
yenta_socket mac80211 uhci_hcd ssb rsrc_nonstatic ohci1394 intel_agp
video led_class snd ehci_hcd pcmcia_core mii agpgart backlight
soundcore rtc_cmos snd_page_alloc cfg80211 ieee1394 psmouse usbcore
rtc_core serio_raw sg output rfkill ac fan battery rtc_lib button
evdev
[  163.233095] Pid: 9, comm: events/0 Tainted: G        W  2.6.31-git4 #1
[  163.233102] Call Trace:
[  163.233117]  [<c03dd315>] ? printk+0x1d/0x20
[  163.233150]  [<f85c255b>] ? wdev_cleanup_work+0xbb/0xe0 [cfg80211]
[  163.233162]  [<c013b001>] warn_slowpath_common+0x71/0xc0
[  163.233195]  [<f85c255b>] ? wdev_cleanup_work+0xbb/0xe0 [cfg80211]
[  163.233205]  [<c013b06a>] warn_slowpath_null+0x1a/0x20
[  163.233237]  [<f85c255b>] wdev_cleanup_work+0xbb/0xe0 [cfg80211]
[  163.233249]  [<c015235f>] ? prepare_to_wait+0x3f/0x70
[  163.233259]  [<c014dabe>] worker_thread+0x12e/0x1f0
[  163.233267]  [<c0136870>] ? default_wake_function+0x10/0x20
[  163.233301]  [<f85c24a0>] ? wdev_cleanup_work+0x0/0xe0 [cfg80211]
[  163.233311]  [<c0152110>] ? autoremove_wake_function+0x0/0x50
[  163.233320]  [<c014d990>] ? worker_thread+0x0/0x1f0
[  163.233329]  [<c0151db4>] kthread+0x74/0x80
[  163.233338]  [<c0151d40>] ? kthread+0x0/0x80
[  163.233348]  [<c0103a4f>] kernel_thread_helper+0x7/0x10
[  163.233355] ---[ end trace 4a480a90c21becfc ]---

Config:
http://unixy.pl/maciek/download/kernel/2.6.31-git4/config-2.6.31-git4
Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.31-git4/dmesg-2.6.31-git4.txt

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
