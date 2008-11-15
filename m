Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYKOJwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYKOJwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 04:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYKOJwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 04:52:16 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1795 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYKOJwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 04:52:14 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Nov 2008 04:52:14 EST
Message-ID: <491E9972.9000909@xs4all.nl>
Date: Sat, 15 Nov 2008 10:42:10 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG after installing Phenom
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just replaced my Athlon X2 2350-BE with a Phenom 9550.
This is on a Gigabyte m56s-s3 board with the latest F4G bios.
During the boot I noticed the BUg below.
What could be the cause, how can I provide the right info?

Kind regards,
Udo

(...)
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
 disk 3, o:1, dev:sdd2
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
ACPI: Power Button (CM) [PWRB]
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000013
IP: [<ffffffff802a4bc6>] sys_close+0x56/0x120
PGD 0
Oops: 0000 [1] PREEMPT SMP
CPU 2
Modules linked in: snd parport sg snd_page_alloc i2c_nforce2 button
ohci_hcd ehci_hcd
Pid: 1035, comm: udevd Not tainted 2.6.27.6 #8
RIP: 0010:[<ffffffff802a4bc6>]  [<ffffffff802a4bc6>] sys_close+0x56/0x120
RSP: 0018:ffff88011e901f58  EFLAGS: 00010286
RAX: 0000000000000004 RBX: ffff88011e8183c0 RCX: ffff88011e8183d0
RDX: ffff88011e818478 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000004 R08: 0000000000000004 R09: 00007fa15b347a00
R10: 00007fa15b99d810 R11: 0000000000000246 R12: ffff88011e818440
R13: ffff88011f8e2e00 R14: 00007fff639d2db0 R15: 00007fff639d2bb0
FS:  00007fa15b99d780(0000) GS:ffff88011f86d6c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000013 CR3: 000000011e4d0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 1035, threadinfo ffff88011e900000, task
ffff88011f2be690)
Stack:  0000000000000000 00007fa15b99d698 0000000000000000 00007fff639d0fa0
 0000000000000004 ffffffff8020b9db 0000000000000246 00007fa15b99d810
 00007fa15b347a00 0000000000000004 0000000000000003 00007fa15b0b6520
Call Trace:
 [<ffffffff8020b9db>] ? system_call_fastpath+0x16/0x1b


Code: 8d a3 80 00 00 00 4c 89 e7 e8 37 14 28 00 48 8b 4b 08 39 29 0f 86
ab 00 00 00 89 e8 48 8d 14 c5 00 00 00 00 48 03 51 08 4c 8b 2a <4d> 85
ed 0f 84 91 00 00 00 48 c7 02 00 00 00 00 48 8b 71 10 48
RIP  [<ffffffff802a4bc6>] sys_close+0x56/0x120
 RSP <ffff88011e901f58>
CR2: 0000000000000013
---[ end trace de5577b47323c3eb ]---
note: udevd[1035] exited with preempt_count 1
BUG: scheduling while atomic: udevd/1035/0x10000002
Modules linked in: snd parport sg snd_page_alloc i2c_nforce2 button
ohci_hcd ehci_hcd
Pid: 1035, comm: udevd Tainted: G      D   2.6.27.6 #8

Call Trace:
 [<ffffffff80524340>] thread_return+0x11f/0x63f
 [<ffffffff802587bf>] __atomic_notifier_call_chain+0x4f/0x70
 [<ffffffff805264f0>] _spin_unlock+0x10/0x30
 [<ffffffff803b1c4c>] vt_console_print+0x28c/0x390
 [<ffffffff80371b60>] vgacon_cursor+0x0/0x270
 [<ffffffff80239d27>] __cond_resched+0x17/0x40
 [<ffffffff80524965>] _cond_resched+0x35/0x50
 [<ffffffff8028e093>] unmap_vmas+0x803/0x9a0
 [<ffffffff80292b0d>] exit_mmap+0x9d/0x150
 [<ffffffff8023aa25>] mmput+0x25/0xc0
 [<ffffffff8023ec2e>] exit_mm+0xfe/0x140
 [<ffffffff805263f1>] _spin_unlock_irq+0x11/0x40
 [<ffffffff80240876>] do_exit+0x186/0x930
 [<ffffffff8020d0cc>] oops_end+0x8c/0x90
 [<ffffffff802260bc>] do_page_fault+0x24c/0x9e0
 [<ffffffff8028ecc8>] handle_mm_fault+0x1d8/0x830
 [<ffffffff802a9dff>] chrdev_open+0x13f/0x240
 [<ffffffff805261cf>] _spin_lock_irqsave+0x1f/0x50
 [<ffffffff8035af31>] __up_read+0x21/0xb0
 [<ffffffff80526432>] _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff802261b4>] do_page_fault+0x344/0x9e0
 [<ffffffff802b3e2b>] do_filp_open+0x21b/0x9a0
 [<ffffffff80526889>] error_exit+0x0/0x51
 [<ffffffff802a4bc6>] sys_close+0x56/0x120
 [<ffffffff802a4ba9>] sys_close+0x39/0x120
 [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b

IT8716 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
(cut)
