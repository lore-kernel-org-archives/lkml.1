Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZGXTGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZGXTGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZGXTGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:06:09 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:45433 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbZGXTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:06:07 -0400
X-Greylist: delayed 1814 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 15:06:07 EDT
Message-ID: <4A69FF8E.7090004@opengridcomputing.com>
Date: Fri, 24 Jul 2009 13:38:06 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc4 error 'ide-atapi: cmd 0x3 timed out'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

I see this timeout continually while running 2.6.31-rc4, hw x64_64, 
distro rh5.1.

Anybody else see this?


--------------

ide-atapi: cmd 0x3 timed out
hda: irq timeout: status=0xd0 { Busy }
hda: possibly failed opcode: 0xa0
INFO: task hald-addon-stor:3665 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
hald-addon-st D ffffffff8102c092     0  3665   3638 0x00000080
 ffffffff81411020 0000000000000082 0000000000000000 0000000800000008
 0000000000000000 ffff88019bbf61c0 ffff88019bbf6550 00000000fffd9368
 ffff88019d54ab70 ffff88019e924000 ffff88019d54a800 ffff88019d50af00
Call Trace:
 [<ffffffff812d326d>] ? schedule_timeout+0x23/0x161
 [<ffffffff810458d7>] ? del_timer+0x4e/0x57
 [<ffffffff812d30c3>] ? wait_for_common+0xac/0xf9
 [<ffffffff81033441>] ? default_wake_function+0x0/0x9
 [<ffffffff81143fae>] ? __generic_unplug_device+0x12/0x2c
 [<ffffffff8114b0f8>] ? blk_execute_rq+0x98/0xb8
 [<ffffffff8114b2ba>] ? blk_recount_segments+0x17/0x27
 [<ffffffff810d55eb>] ? bio_phys_segments+0xf/0x14
 [<ffffffff8114258b>] ? blk_rq_bio_prep+0x29/0xab
 [<ffffffffa019a813>] ? ide_cd_queue_pc+0x14e/0x170 [ide_cd_mod]
 [<ffffffff811445d7>] ? get_request_wait+0x21/0x145
 [<ffffffff81143316>] ? __freed_request+0x2f/0xfa
 [<ffffffffa019a904>] ? cdrom_read_capacity+0x58/0xd7 [ide_cd_mod]
 [<ffffffffa019ab5a>] ? ide_cd_read_toc+0xf3/0x3fa [ide_cd_mod]
 [<ffffffffa019b453>] ? idecd_revalidate_disk+0x17/0x1e [ide_cd_mod]
 [<ffffffff810d63d1>] ? flush_disk+0xd/0x7b
 [<ffffffffa0184076>] ? media_changed+0x44/0x74 [cdrom]
 [<ffffffff810d6484>] ? check_disk_change+0x45/0x52
 [<ffffffffa0187188>] ? cdrom_open+0x926/0x9ab [cdrom]
 [<ffffffff810458d7>] ? del_timer+0x4e/0x57
 [<ffffffff812d30e2>] ? wait_for_common+0xcb/0xf9
 [<ffffffff81033441>] ? default_wake_function+0x0/0x9
 [<ffffffff81143fae>] ? __generic_unplug_device+0x12/0x2c
 [<ffffffff8114b0f8>] ? blk_execute_rq+0x98/0xb8
 [<ffffffff810c3d26>] ? __d_lookup+0xb7/0xf7
 [<ffffffff81155e0d>] ? kobject_get+0x12/0x17
 [<ffffffff8114cb3d>] ? get_disk+0x47/0x62
 [<ffffffff8114cb64>] ? exact_lock+0xc/0x14
 [<ffffffff81155e0d>] ? kobject_get+0x12/0x17
 [<ffffffff811d68a6>] ? get_device+0x14/0x1b
 [<ffffffffa019a46d>] ? idecd_open+0x64/0x92 [ide_cd_mod]
 [<ffffffff810d6f30>] ? __blkdev_get+0x95/0x32a
 [<ffffffff810d71cc>] ? blkdev_open+0x0/0x9a
 [<ffffffff810d7234>] ? blkdev_open+0x68/0x9a
 [<ffffffff810b360e>] ? __dentry_open+0x13b/0x247
 [<ffffffff810bfa51>] ? do_filp_open+0x4ff/0x910
 [<ffffffff810517d7>] ? hrtimer_cancel+0xc/0x16
 [<ffffffff812d3bb5>] ? do_nanosleep+0x62/0x9a
 [<ffffffff8105199c>] ? hrtimer_nanosleep+0x86/0xf1
 [<ffffffff810c7328>] ? alloc_fd+0x69/0x10c
 [<ffffffff810b3402>] ? do_sys_open+0x55/0xfb
 [<ffffffff8100b92b>] ? system_call_fastpath+0x16/0x1b

