Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZG1VEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZG1VEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZG1VEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:04:39 -0400
Received: from 216-235-106-HCC-115.hcc.net ([216.235.106.115]:45800 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbZG1VEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:04:38 -0400
Message-ID: <4A6F67E3.60201@howardsilvan.com>
Date: Tue, 28 Jul 2009 14:04:35 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Fwd: how to debug: BUG: soft lockup - CPU#3 stuck for 61s!]
Content-Type: multipart/mixed;
 boundary="------------000808050801080105030704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000808050801080105030704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I installed Fedora 11 and I'm getting the same thing there, too (kernel
2.6.29.6-213.fc11.x86_64).

What can I do to help fix this?

Jul 28 03:44:08 fangorn kernel: BUG: soft lockup - CPU#2 stuck for 61s!
[md2_raid1:107]
Jul 28 03:44:08 fangorn kernel: Modules linked in: ipv6 cpufreq_ondemand
powernow_k8 freq_table dm_multipath i2c_nforce2 forcedeth i2c_core
pata_amd pcspkr serio_raw ata_generic pata_acpi sata_nv raid1 [last
unloaded: scsi_wait_scan]
Jul 28 03:44:08 fangorn kernel: CPU 2:
Jul 28 03:44:08 fangorn kernel: Modules linked in: ipv6 cpufreq_ondemand
powernow_k8 freq_table dm_multipath i2c_nforce2 forcedeth i2c_core
pata_amd pcspkr serio_raw ata_generic pata_acpi sata_nv raid1 [last
unloaded: scsi_wait_scan]
Jul 28 03:44:08 fangorn kernel: Pid: 107, comm: md2_raid1 Not tainted
2.6.29.6-213.fc11.x86_64 #1 empty
Jul 28 03:44:08 fangorn kernel: RIP: 0010:[<ffffffff811b72dd>]
[<ffffffff811b72dd>] memcmp+0xc/0x22
Jul 28 03:44:08 fangorn kernel: RSP: 0018:ffff8801253c7d80  EFLAGS: 00000206
Jul 28 03:44:08 fangorn kernel: RAX: 0000000000000000 RBX:
ffff8801253c7d80 RCX: 0000000000000000
Jul 28 03:44:08 fangorn kernel: RDX: 0000000000000fc0 RSI:
ffff8801071b6040 RDI: ffff8801041b9040
Jul 28 03:44:08 fangorn kernel: RBP: ffffffff8101211e R08:
ffff880123867c38 R09: 0000000000000003
Jul 28 03:44:08 fangorn kernel: R10: ffff880107184780 R11:
ffff880125133180 R12: ffffffff811b3a58
Jul 28 03:44:08 fangorn kernel: R13: ffff8800a68c7000 R14:
ffff8801253c6000 R15: 0000000000000001
Jul 28 03:44:08 fangorn kernel: FS:  00007f39c0fbc6f0(0000)
GS:ffff880126a74580(0000) knlGS:0000000000000000
Jul 28 03:44:08 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jul 28 03:44:08 fangorn kernel: CR2: 0000003644c03088 CR3:
00000001218f4000 CR4: 00000000000006e0
Jul 28 03:44:08 fangorn kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jul 28 03:44:08 fangorn kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jul 28 03:44:08 fangorn kernel: Call Trace:
Jul 28 03:44:08 fangorn kernel: [<ffffffffa0001c16>] ?
raid1d+0x2d8/0xe59 [raid1]
Jul 28 03:44:08 fangorn kernel: [<ffffffff81011f67>] ? restore_args+0x0/0x30
Jul 28 03:44:08 fangorn kernel: [<ffffffff813aa59a>] ?
schedule_timeout+0x27/0xb5
Jul 28 03:44:08 fangorn kernel: [<ffffffff81029f7f>] ?
default_spin_lock_flags+0x9/0xe
Jul 28 03:44:08 fangorn kernel: [<ffffffff812d65ae>] ? md_thread+0xf1/0x10f
Jul 28 03:44:08 fangorn kernel: [<ffffffff8105c8d7>] ?
autoremove_wake_function+0x0/0x39
Jul 28 03:44:08 fangorn kernel: [<ffffffff812d64bd>] ? md_thread+0x0/0x10f
Jul 28 03:44:08 fangorn kernel: [<ffffffff8105c541>] ? kthread+0x4d/0x78
Jul 28 03:44:08 fangorn kernel: [<ffffffff8101264a>] ? child_rip+0xa/0x20
Jul 28 03:44:08 fangorn kernel: [<ffffffff81011f67>] ? restore_args+0x0/0x30
Jul 28 03:44:08 fangorn kernel: [<ffffffff8105c4f4>] ? kthread+0x0/0x78
Jul 28 03:44:08 fangorn kernel: [<ffffffff81012640>] ? child_rip+0x0/0x20

-------- Original Message --------
Subject: 	how to debug: BUG: soft lockup - CPU#3 stuck for 61s!
Date: 	Sat, 25 Jul 2009 18:11:52 -0700
From: 	Lee Howard <faxguy@howardsilvan.com>
To: 	linux-kernel@vger.kernel.org



Anywhere from once every two weeks to two times daily I have to
power-cycle a system due to a CPU getting this "soft lockup".  It
happens both with and without "noapic".

Please see the attached syslog information that appears when it occurs.

How do I debug, and how can I assist whoever is able to fix this?

(I'm not subscribed to the list, so please CC me on replies.)

Thanks,

Lee.





--------------000808050801080105030704
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



--------------000808050801080105030704--
