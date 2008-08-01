Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbYHAUzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbYHAUzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbYHAUzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:55:42 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:49562 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759933AbYHAUzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:55:41 -0400
Message-ID: <48937891.2040606@opengridcomputing.com>
Date: Fri, 01 Aug 2008 15:56:49 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG on booting 2.6.27-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody seen this?

Its on x86_64, FC7 distro quad core cpu.  I have 2 similar systems, and 
one boots up ok but the other hits this on -rc1 right off the bat.




Starting udev: ------------[ cut here ]------------
kernel BUG at kernel/stop_machine.c:151!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in: dm_snapshot dm_zero dm_mirror dm_log dm_mod 
pata_jmicron ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd 
mbcache [last unloaded: scsi_wait_scan]
Pid: 960, comm: modprobe Not tainted 2.6.27-rc1 #7
RIP: 0010:[<ffffffff8105be33>]  [<ffffffff8105be33>] 
__stop_machine+0x134/0x1ea
RSP: 0018:ffff88012e5dbd68  EFLAGS: 00010286
RAX: 00000000fffffff3 RBX: ffff88012b9b1d40 RCX: 0000000000000206
RDX: 000000000000100f RSI: 0000000000000246 RDI: ffffffff81380cb0
RBP: ffff88012dbd5e00 R08: 0000000000000000 R09: ffffffff813cfb28
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88012dbd5e00 R14: 0000000000000000 R15: 00007ff1dab40010
FS:  00007ff1daba26f0(0000) GS:ffffffff813d0b00(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ff1dab7b00f CR3: 000000012e4a8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 960, threadinfo ffff88012e5da000, task 
ffff88012d8c2490)
Stack:  ffffffff8105bcfc 0000000000000000 0000000000000000 0000000000000000
 ffffffff810517f7 ffffffffa00cc000 0000000000000000 ffffffff8101d469
 0000000000000063 ffffffff812501ce 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8105bcfc>] ? chill+0x0/0x3
 [<ffffffff810517f7>] ? __link_module+0x0/0x1f
 [<ffffffff8101d469>] ? module_finalize+0xa0/0x121
 [<ffffffff812501ce>] ? mutex_lock+0xd/0x1e
 [<ffffffff810517f7>] ? __link_module+0x0/0x1f
 [<ffffffff8105bf0a>] ? stop_machine+0x21/0x30
 [<ffffffff81052dd2>] ? load_module+0x11a0/0x1624
 [<ffffffff81196f5c>] ? bus_register+0x0/0x224
 [<ffffffff810f670f>] ? selinux_capable+0x87/0x90
 [<ffffffff810532a3>] ? sys_init_module+0x4d/0x1a7
 [<ffffffff8100bdbb>] ? system_call_fastpath+0x16/0x1b


Code: 00 83 cd ff e9 a0 00 00 00 48 89 c7 44 89 e6 e8 d8 95 fe ff 48 8b 
7d 00 48 8d 54 24 40 be 01 00 00 00 e8 c7 39 fd ff 85 c0 74 04 <0f> 0b 
eb fe 44 89 e7 48 c7 c6 98 0d 3d 81 e8 3a ea 0b 00 83 f8
RIP  [<ffffffff8105be33>] __stop_machine+0x134/0x1ea
 RSP <ffff88012e5dbd68>
---[ end trace 47a6f3d3cb718199 ]---

