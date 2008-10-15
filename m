Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYJOUUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYJOUUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYJOUUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:20:03 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35373 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYJOUUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=V0gPQNDcY2/VBkrvGaXGRr61hpq9C6cnXzlz4zJ0aNfgMZ0AlEIE3sDQwD7sirQoSL
         G37HCVi8PL2L24Q3NQbej1BcRCGtvkjSbRmKPg6LoMUlqpx4ALmeJEsoNFkXueXVzd2T
         zjysftfVGgubauoOvxVI0AD6Ct6ZsIeuphvX0=
Message-ID: <dd18b0c30810151319y133e536dm8650f6477cfb9755@mail.gmail.com>
Date: Wed, 15 Oct 2008 13:19:59 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x24/0x75()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With watching a movie I noticed this:

[  364.330884] ------------[ cut here ]------------
[  364.330889] WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x24/0x75()
[  364.330893] Modules linked in: usb_storage hidp binfmt_misc btusb
bnep sco rfcomm l2cap bluetooth cpufreq_powersave cpufreq_ondemand
cpufreq_performance cpufreq_conservative fan battery container
ipmi_watchdog ipmi_msghandler isight_firmware uinput
ieee80211_crypt_tkip ieee80211 ieee80211_crypt arpt_mangle
arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables
coretemp eeprom acpi_cpufreq joydev applesmc sbp2 firewire_ohci
firewire_core uvcvideo appletouch snd_hda_intel ohci1394 snd_pcm
snd_timer pata_acpi ehci_hcd uhci_hcd ath9k ieee1394 sky2
snd_page_alloc snd_hwdep video ac thermal button processor evdev
[  364.331049] Pid: 4676, comm: umount Not tainted 2.6.27-04108-g8acd3a6 #38
[  364.331053] Call Trace:
[  364.331063]  [<c03a8773>] ? printk+0xf/0x14
[  364.331071]  [<c01255c8>] warn_on_slowpath+0x41/0x65
[  364.331079]  [<c011b335>] ? __dequeue_entity+0x73/0x7b
[  364.331087]  [<c0101d66>] ? __switch_to+0xce/0x14f
[  364.331095]  [<c0223e35>] ? _raw_spin_unlock+0x74/0x78
[  364.331101]  [<c0223b6f>] ? _raw_spin_trylock+0xf/0x30
[  364.331108]  [<c012219d>] ? finish_task_switch+0x32/0x81
[  364.331115]  [<c03aabfa>] ? __reacquire_kernel_lock+0x25/0x2d
[  364.331122]  [<c03a911a>] ? schedule+0x730/0x760
[  364.331128]  [<c0223e8c>] ? _raw_spin_lock+0x53/0xf7
[  364.331135]  [<c0193726>] mark_buffer_dirty+0x24/0x75
[  364.331142]  [<c01c3c26>] journal_update_superblock+0x62/0xaa
[  364.331148]  [<c01c3f78>] journal_destroy+0x148/0x18d
[  364.331156]  [<c01359bb>] ? autoremove_wake_function+0x0/0x33
[  364.331164]  [<c01b9acf>] ext3_put_super+0x24/0x178
[  364.331172]  [<c0179e5e>] generic_shutdown_super+0x52/0xd3
[  364.331179]  [<c0179eee>] kill_block_super+0xf/0x20
[  364.331186]  [<c0179f8f>] deactivate_super+0x3f/0x51
[  364.331193]  [<c0189bf6>] mntput_no_expire+0xc3/0xee
[  364.331200]  [<c018a0d5>] sys_umount+0x297/0x2bc
[  364.331206]  [<c0103187>] sysenter_do_call+0x12/0x2f
[  364.331213]  [<c03a0000>] ? quirk_svwks_csb5ide+0x16/0x4e
[  364.331217] ---[ end trace 049fdb857767a774 ]---

At the time I still was configuring the plug-ins
for the media player; so maybe this was the
initial cause. In any case better to report
than not at all.
 ohh and another thing, I owe a thanks to
all of you guys working hard on these kernels,
I finally have a tainted free system : )
regards;

-- 
Justin P. Mattock
