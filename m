Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbZLHQWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbZLHQWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 11:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZLHQWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 11:22:31 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:38337 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbZLHQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 11:22:30 -0500
Message-ID: <4B1E7DA4.8090801@wpkg.org>
Date: Tue, 08 Dec 2009 17:24:04 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20091009)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.32: WARNING: at fs/notify/inotify/inotify_user.c:398 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this warning when updating packages on a system using ext4 fs as / and btrfs as /home.

Not sure exactly how it happened, or how to reproduce it.


------------[ cut here ]------------
WARNING: at fs/notify/inotify/inotify_user.c:398 inotify_remove_from_idr+0x81/0x90()
Hardware name: SCENIC EDITION
Modules linked in: loop af_packet 8021q garp stp ipv6 snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd sr_mod soundcore tulip shpchp snd_page_alloc sg pci_hotplug binfmt_misc btrfs zlib_deflate crc32c libcrc32c cpufreq_ondemand cpufreq_conservative cpufreq_powersave p4_clockmod freq_table speedstep_lib usbhid hid fuse pcspkr floppy ppdev parport_pc parport container ehci_hcd ohci_hcd evdev thermal processor button usbcore ide_generic ata_generic ide_pci_generic pata_acpi sis5513 ide_gd_mod ide_core pata_sis libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16
Pid: 1978, comm: kded4 Not tainted 2.6.32-1mdv #1
Call Trace:
 [<c01450f2>] warn_slowpath_common+0x72/0xa0
 [<c0230d41>] ? inotify_remove_from_idr+0x81/0x90
 [<c0230d41>] ? inotify_remove_from_idr+0x81/0x90
 [<c014513a>] warn_slowpath_null+0x1a/0x20
 [<c0230d41>] inotify_remove_from_idr+0x81/0x90
 [<c023127c>] inotify_ignored_and_remove_idr+0x8c/0xb0
 [<c023007d>] inotify_freeing_mark+0xd/0x10
 [<c022ead1>] fsnotify_destroy_mark_by_entry+0x101/0x140
 [<c0230c5c>] sys_inotify_rm_watch+0x5c/0xa0
 [<c0103ca3>] sysenter_do_call+0x12/0x28
---[ end trace 7fe07e3e7e72d52d ]---


-- 
Tomasz Chmielewski
http://wpkg.org
