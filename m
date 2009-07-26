Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZGZBTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZGZBTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 21:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZGZBTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 21:19:50 -0400
Received: from 216-235-106-HCC-115.hcc.net ([216.235.106.115]:37772 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZGZBTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 21:19:49 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2009 21:19:49 EDT
Message-ID: <4A6BAD58.4010100@howardsilvan.com>
Date: Sat, 25 Jul 2009 18:11:52 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to debug: BUG: soft lockup - CPU#3 stuck for 61s!
Content-Type: multipart/mixed;
 boundary="------------010502090308050006030305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010502090308050006030305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Anywhere from once every two weeks to two times daily I have to 
power-cycle a system due to a CPU getting this "soft lockup".  It 
happens both with and without "noapic".

Please see the attached syslog information that appears when it occurs.

How do I debug, and how can I assist whoever is able to fix this?

(I'm not subscribed to the list, so please CC me on replies.)

Thanks,

Lee.


--------------010502090308050006030305
Content-Type: text/plain;
 name="softlockup.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="softlockup.txt"

Jul 25 17:18:44 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [events/3:18]
Jul 25 17:18:44 fangorn kernel: Modules linked in: ipv6 dm_multipath uinput cfi_cmdset_0002 cfi_util jedec_probe cfi_probe gen_probe ck804xrom mtd i2c_nforce2 chipreg i2c_core forcedeth map_funcs pcspkr pata_amd ata_generic pata_acpi sata_nv raid456 async_xor async_memcpy async_tx xor raid1 [last unloaded: scsi_wait_scan]
Jul 25 17:18:44 fangorn kernel: CPU 3:
Jul 25 17:18:44 fangorn kernel: Modules linked in: ipv6 dm_multipath uinput cfi_cmdset_0002 cfi_util jedec_probe cfi_probe gen_probe ck804xrom mtd i2c_nforce2 chipreg i2c_core forcedeth map_funcs pcspkr pata_amd ata_generic pata_acpi sata_nv raid456 async_xor async_memcpy async_tx xor raid1 [last unloaded: scsi_wait_scan]
Jul 25 17:18:44 fangorn kernel: Pid: 18, comm: events/3 Not tainted 2.6.27.25-170.2.72.fc10.x86_64 #1 empty
Jul 25 17:18:44 fangorn kernel: RIP: 0010:[<ffffffff810625e0>]  [<ffffffff810625e0>] smp_call_function_mask+0x174/0x1dd
Jul 25 17:18:44 fangorn kernel: RSP: 0018:ffff880127b77d40  EFLAGS: 00000202
Jul 25 17:18:44 fangorn kernel: RAX: ffff880127b77df0 RBX: ffff880127b77e20 RCX: 00000000000000fc
Jul 25 17:18:44 fangorn kernel: RDX: ffffffff816e4500 RSI: 00000000000008fc RDI: 0000000000000286
Jul 25 17:18:44 fangorn kernel: RBP: 0000000000000003 R08: ffff880127b76000 R09: ffff880123489180
Jul 25 17:18:44 fangorn kernel: R10: ffffffff816e4500 R11: 000000602a422408 R12: ffff88002805b5a0
Jul 25 17:18:44 fangorn kernel: R13: ffff8800a697b000 R14: ffff880127b76000 R15: ffffffff816e1990
Jul 25 17:18:44 fangorn kernel: FS:  00007f19aeb31950(0000) GS:ffff880127a79080(0000) knlGS:0000000000000000
Jul 25 17:18:44 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Jul 25 17:18:44 fangorn kernel: CR2: 00000000004226c0 CR3: 000000011fc94000 CR4: 00000000000006e0
Jul 25 17:18:44 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 25 17:18:44 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 25 17:18:44 fangorn kernel:
Jul 25 17:18:44 fangorn kernel: Call Trace:
Jul 25 17:18:44 fangorn kernel: [<ffffffff8101b6e8>] ? mcheck_check_cpu+0x0/0x2b
Jul 25 17:18:44 fangorn kernel: [<ffffffff8100e717>] ? __switch_to+0xb9/0x3e0
Jul 25 17:18:44 fangorn kernel: [<ffffffff8103414e>] ? pick_next_task_fair+0x9d/0xac
Jul 25 17:18:44 fangorn kernel: [<ffffffff8103e378>] ? finish_task_switch+0x31/0xc9
Jul 25 17:18:44 fangorn kernel: [<ffffffff8101b6e8>] ? mcheck_check_cpu+0x0/0x2b
Jul 25 17:18:44 fangorn kernel: [<ffffffff8101b084>] ? mcheck_timer+0x0/0x7f
Jul 25 17:18:44 fangorn kernel: [<ffffffff81062664>] ? smp_call_function+0x1b/0x1d
Jul 25 17:18:44 fangorn kernel: [<ffffffff81046673>] ? on_each_cpu+0x18/0x46
Jul 25 17:18:44 fangorn kernel: [<ffffffff8109c407>] ? vmstat_update+0x0/0x32
Jul 25 17:18:44 fangorn kernel: [<ffffffff8101b0a0>] ? mcheck_timer+0x1c/0x7f
Jul 25 17:18:44 fangorn kernel: [<ffffffff81051c2d>] ? run_workqueue+0xa3/0x146
Jul 25 17:18:44 fangorn kernel: [<ffffffff81051dc5>] ? worker_thread+0xf5/0x109
Jul 25 17:18:44 fangorn kernel: [<ffffffff810554e5>] ? autoremove_wake_function+0x0/0x38
Jul 25 17:18:44 fangorn kernel: [<ffffffff81051cd0>] ? worker_thread+0x0/0x109
Jul 25 17:18:44 fangorn kernel: [<ffffffff8105519f>] ? kthread+0x49/0x76
Jul 25 17:18:44 fangorn kernel: [<ffffffff81011719>] ? child_rip+0xa/0x11
Jul 25 17:18:44 fangorn kernel: [<ffffffff81010a37>] ? restore_args+0x0/0x30
Jul 25 17:18:44 fangorn kernel: [<ffffffff81055156>] ? kthread+0x0/0x76
Jul 25 17:18:44 fangorn kernel: [<ffffffff8101170f>] ? child_rip+0x0/0x11
Jul 25 17:18:44 fangorn kernel:

--------------010502090308050006030305--
