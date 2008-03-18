Return-Path: <linux-kernel-owner+w=401wt.eu-S965266AbYCSVCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266AbYCSVCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760537AbYCSTxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:53:07 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:46790 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760530AbYCSTxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:01 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org> <20080318001831.575D093C911@tippex.mynet.homeunix.org> <200803181403.37969.bzolnier@gmail.com> <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Tue, 18 Mar 2008 08:41:25 -0700."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 18 Mar 2008 17:30:03 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080318163004.018332DC044@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JbekG-0004d7-8W.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JbekG-0004d7-8W abeabaea1686cf26c1b0a2c324687fca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Seems we got something here. For all I can tell, it's working!

I had to hand apply the last hunk of your patch, and the other patches are there as 
well. Can you respin it vs. -rc6 and I'll try on a clean tree?

/A



Mar 18 17:23:12 tippex smartd[5922]: Home page is http://smartmontools.sourceforge.net/
Mar 18 17:23:12 tippex smartd[5922]: Opened configuration file /etc/smartd.conf
Mar 18 17:23:13 tippex smartd[5922]: Configuration file /etc/smartd.conf parsed.
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, opened
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 18 17:23:13 tippex hda: tf: feat 0x00 nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00 dev 0x00 cmd 0xec
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, found in smartd database.
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xd8 nsect 0x00 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xda nsect 0x00 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xd0 nsect 0x01 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xd1 nsect 0x01 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 18 17:23:13 tippex hda: tf: feat 0x00 nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00 dev 0x00 cmd 0xec
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, can't monitor Current Pending Sector count - no Attribute 197
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, can't monitor Offline Uncorrectable Sector count  - no Attribute 198
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, can't monitor Temperature, ignoring -W Directive
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, appears to lack SMART Self-Test log; disabling -l selftest (override with -T permissive Directive)
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, appears to lack SMART Error log; disabling -l error (override with -T permissive Directive)
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, is SMART capable. Adding to "monitor" list.
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, opened
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, found in smartd database.
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xd8 nsect 0x00 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xd2 nsect 0xf1 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, enabled SMART Attribute Autosave.
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xda nsect 0x00 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xd0 nsect 0x01 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xd1 nsect 0x01 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:13 tippex hda: tf: feat 0xdb nsect 0xf8 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex ide_error(msg=task_in_intr, stat=81)
Mar 18 17:23:13 tippex ------------[ cut here ]------------
Mar 18 17:23:13 tippex WARNING: at /usr/src/linux-2.6.25/drivers/ide/ide-io.c:548 ide_error+0x47/0x100()
Mar 18 17:23:13 tippex Modules linked in: rtc rt2500pci rt2x00pci pcspkr i2c_piix4 rt2x00lib input_polldev eeprom_93cx6 i2c_core uhci_hcd intel_agp agpgart
Mar 18 17:23:13 tippex Pid: 3798, comm: syslog-ng Not tainted 2.6.25-rc5 #11
Mar 18 17:23:13 tippex [<c011c584>] warn_on_slowpath+0x54/0x70
Mar 18 17:23:13 tippex [<c011cef8>] ? release_console_sem+0x1c8/0x1f0
Mar 18 17:23:13 tippex [<c040d0cc>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar 18 17:23:13 tippex [<c011cf08>] ? release_console_sem+0x1d8/0x1f0
Mar 18 17:23:13 tippex [<c011d2ae>] ? vprintk+0x1ce/0x3d0
Mar 18 17:23:13 tippex [<c01160c0>] ? default_wake_function+0x0/0x10
Mar 18 17:23:13 tippex [<c01385da>] ? __lock_acquire+0xba/0x700
Mar 18 17:23:13 tippex [<c011d4cb>] ? printk+0x1b/0x20
Mar 18 17:23:13 tippex [<c0284777>] ide_error+0x47/0x100
Mar 18 17:23:13 tippex [<c02889b3>] task_error+0x73/0xb0
Mar 18 17:23:13 tippex [<c0289591>] task_in_intr+0xf1/0x110
Mar 18 17:23:13 tippex [<c0284543>] ide_intr+0x93/0x200
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, can't monitor Current Pending Sector count - no Attribute 197
Mar 18 17:23:13 tippex [<c0137dcd>] ? put_lock_stats+0xd/0x30
Mar 18 17:23:13 tippex [<c0137e4d>] ? lock_release_holdtime+0x5d/0x80
Mar 18 17:23:13 tippex [<c02894a0>] ? task_in_intr+0x0/0x110
Mar 18 17:23:13 tippex [<c0143408>] handle_IRQ_event+0x28/0x60
Mar 18 17:23:13 tippex [<c0144b9b>] handle_level_irq+0x6b/0xe0
Mar 18 17:23:13 tippex [<c01056f2>] do_IRQ+0x42/0x80
Mar 18 17:23:13 tippex [<c0103963>] common_interrupt+0x23/0x28
Mar 18 17:23:13 tippex [<c013981f>] ? lock_acquired+0xff/0x190
Mar 18 17:23:13 tippex [<c040c91c>] _spin_lock+0x5c/0x70
Mar 18 17:23:13 tippex [<c038a1e4>] ? unix_accept+0xa4/0xf0
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, can't monitor Offline Uncorrectable Sector count  - no Attribute 198
Mar 18 17:23:13 tippex [<c038a1e4>] unix_accept+0xa4/0xf0
Mar 18 17:23:13 tippex [<c031e9e3>] sys_accept+0xd3/0x1c0
Mar 18 17:23:13 tippex [<c019635e>] ? dnotify_parent+0x6e/0x80
Mar 18 17:23:13 tippex [<c040cfd7>] ? _spin_unlock+0x27/0x50
Mar 18 17:23:13 tippex [<c031eb91>] sys_socketcall+0xc1/0x260
Mar 18 17:23:13 tippex [<c0231535>] ? copy_to_user+0x35/0x50
Mar 18 17:23:13 tippex [<c0102f3a>] ? sysenter_past_esp+0x6b/0x91
Mar 18 17:23:13 tippex [<c0102f2e>] sysenter_past_esp+0x5f/0x91
Mar 18 17:23:13 tippex =======================
Mar 18 17:23:13 tippex ---[ end trace beb8e12f45c08448 ]---
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, can't monitor Temperature, ignoring -W Directive
Mar 18 17:23:13 tippex hda: task_in_intr: status=0x51 { DriveReady SeekComplete Error }
Mar 18 17:23:13 tippex hda: task_in_intr: error=0x04 { DriveStatusError }
Mar 18 17:23:13 tippex ide: failed opcode was: 0xb0
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, SMART Automatic Offline Testing unsupported...
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 18 17:23:13 tippex hdb: tf: feat 0x00 nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00 dev 0x00 cmd 0xec
Mar 18 17:23:13 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:13 tippex hdb: tf: feat 0x00 nsect 0x10 lbal 0x17 lbam 0x8d lbah 0xad dev 0x00 cmd 0x35
Mar 18 17:23:13 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:13 tippex hdb: tf: feat 0x00 nsect 0x28 lbal 0x57 lbam 0x3a lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:13 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, enable SMART Automatic Offline Testing failed.
Mar 18 17:23:13 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x7f lbam 0x3a lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:13 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, appears to lack SMART Self-Test log; disabling -l selftest (override with -T permissive Directive)
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:13 tippex hdb: tf: feat 0xd8 nsect 0x00 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, appears to lack SMART Error log; disabling -l error (override with -T permissive Directive)
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hda, is SMART capable. Adding to "monitor" list.
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hdb, opened
Mar 18 17:23:13 tippex smartd[5922]: Device: /dev/hdb, found in smartd database.
Mar 18 17:23:13 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:13 tippex hdb: tf: feat 0xd2 nsect 0xf1 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:13 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:14 tippex hdb: tf: feat 0xda nsect 0x00 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex smartd[5922]: Device: /dev/hdb, enabled SMART Attribute Autosave.
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdb: tf: feat 0xd0 nsect 0x01 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdb: tf: feat 0xd1 nsect 0x01 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdb: tf: feat 0xdb nsect 0xf8 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdb: tf: feat 0xd5 nsect 0x01 lbal 0x06 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex smartd[5922]: Device: /dev/hdb, enabled SMART Automatic Offline Testing.
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdb: tf: feat 0xd5 nsect 0x01 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 18 17:23:14 tippex hdd: tf: feat 0x00 nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00 dev 0x00 cmd 0xec
Mar 18 17:23:14 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex smartd[5922]: Device: /dev/hdb, is SMART capable. Adding to "monitor" list.
Mar 18 17:23:14 tippex smartd[5922]: Device: /dev/hdd, opened
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:14 tippex hdd: tf: feat 0xd8 nsect 0x00 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex smartd[5922]: Device: /dev/hdd, found in smartd database.
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdd: tf: feat 0xd2 nsect 0xf1 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 17:23:14 tippex hdd: tf: feat 0xda nsect 0x00 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex smartd[5922]: Device: /dev/hdd, enabled SMART Attribute Autosave.
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdd: tf: feat 0xd0 nsect 0x01 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdd: tf: feat 0xd1 nsect 0x01 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:14 tippex hdd: tf: feat 0xdb nsect 0xf8 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:14 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:15 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:15 tippex hdd: tf: feat 0xd5 nsect 0x01 lbal 0x06 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:15 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:15 tippex smartd[5922]: Device: /dev/hdd, enabled SMART Automatic Offline Testing.
Mar 18 17:23:15 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 17:23:15 tippex hdd: tf: feat 0xd5 nsect 0x01 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 17:23:15 tippex hdd: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:15 tippex smartd[5922]: Device: /dev/hdd, is SMART capable. Adding to "monitor" list.
Mar 18 17:23:15 tippex smartd[5922]: Device: /dev/sda, No such device, open() failed
Mar 18 17:23:15 tippex smartd[5922]: Unable to register ATA device /dev/sda at line 59 of file /etc/smartd.conf
Mar 18 17:23:15 tippex smartd[5922]: Unable to register device /dev/sda (no Directive -d removable). Exiting.
Mar 18 17:23:18 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:18 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x1f lbam 0x8d lbah 0xad dev 0x00 cmd 0x35
Mar 18 17:23:18 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:18 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:18 tippex hdb: tf: feat 0x00 nsect 0x10 lbal 0x2f lbam 0x8d lbah 0xad dev 0x00 cmd 0x35
Mar 18 17:23:18 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:18 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:18 tippex hdb: tf: feat 0x00 nsect 0x30 lbal 0x87 lbam 0x3a lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:18 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:18 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:18 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0xb7 lbam 0x3a lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:18 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:21 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:21 tippex hdb: tf: feat 0x00 nsect 0x10 lbal 0x37 lbam 0x8d lbah 0xad dev 0x00 cmd 0x35
Mar 18 17:23:21 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:26 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:26 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x87 lbam 0xc0 lbah 0x52 dev 0x00 cmd 0x35
Mar 18 17:23:26 tippex hdb: hob: nsect 0x00 lbal 0x0b lbam 0x00 lbah 0x00
Mar 18 17:23:26 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:26 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x3f lbam 0x8d lbah 0xad dev 0x00 cmd 0x35
Mar 18 17:23:26 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:26 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:26 tippex hdb: tf: feat 0x00 nsect 0x48 lbal 0xbf lbam 0x3a lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:26 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:26 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:26 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x07 lbam 0x3b lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:26 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x4f lbam 0x00 lbah 0x10 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x03 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0xaf lbam 0x01 lbah 0xa4 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x3f lbam 0x00 lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x10 lbal 0x67 lbam 0x00 lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x3f lbam 0x00 lbah 0xac dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x5f lbam 0xf0 lbah 0xac dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x3f lbam 0x00 lbah 0x50 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x0b lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x97 lbam 0x00 lbah 0x50 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x0b lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x3f lbam 0x8d lbah 0xad dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x08 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x10 lbal 0x0f lbam 0x3b lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 17:23:31 tippex do_rw_taskfile(task->data_phase=64, tf->command=53
Mar 18 17:23:31 tippex hdb: tf: feat 0x00 nsect 0x08 lbal 0x1f lbam 0x3b lbah 0x00 dev 0x00 cmd 0x35
Mar 18 17:23:31 tippex hdb: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00





