Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbZL0NkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbZL0NkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZL0NkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:40:17 -0500
Received: from doppler.zen.co.uk ([212.23.3.27]:51313 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZL0NkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:40:16 -0500
Date: Sun, 27 Dec 2009 13:40:10 +0000
From: Grant Wilson <grant.wilson@zen.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc2: BUG: unable to handle kernel paging request at
 00000000000013d8, IP=radeon_fence_signaled+0x16/0xc0
Message-ID: <20091227134010.1f30210e@worthy.swandive.local>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.71.45.175]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit the following running 2.6.33-rc2.  Config available at http://swandive.no-ip.com/linux/config

[  255.807852] BUG: unable to handle kernel paging request at 00000000000013d8
[  255.807860] IP: [<ffffffff8135e656>] radeon_fence_signaled+0x16/0xc0
[  255.807868] PGD 1bcb59067 PUD 1b6c89067 PMD 0
[  255.807876] Oops: 0000 [#1] PREEMPT SMP
[  255.807881] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:08/ATK0110:00/hwmon/hwmon0/fan1_input
[  255.807884] CPU 5
[  255.807889] Pid: 2805, comm: X Not tainted 2.6.33-rc2 #2 Rampage II Extreme/System Product Name
[  255.807891] RIP: 0010:[<ffffffff8135e656>]  [<ffffffff8135e656>] radeon_fence_signaled+0x16/0xc0
[  255.807895] RSP: 0018:ffff8801b6f33b78  EFLAGS: 00010286
[  255.807897] RAX: 0000000100400004 RBX: ffff8801b6faa380 RCX: 0000000000000006
[  255.807899] RDX: 0000000000000006 RSI: ffff8801b8f98740 RDI: 0000000000000000
[  255.807902] RBP: ffff8801b6f33b98 R08: 0000000000000000 R09: 0000000000000001
[  255.807904] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8801bf308000
[  255.807906] R13: ffff8801b6f33be8 R14: ffff8801bf308be0 R15: 00000000000007bb
[  255.807908] FS:  00007f6d95c97700(0000) GS:ffff88002e400000(0000) knlGS:0000000000000000
[  255.807910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  255.807912] CR2: 00000000000013d8 CR3: 00000001bae72000 CR4: 00000000000006e0
[  255.807916] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  255.807918] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  255.807921] Process X (pid: 2805, threadinfo ffff8801b6f32000, task ffff8801b8f98000)
[  255.807923] Stack:
[  255.807924]  ffff8801bf308000 ffff8801b6faa380 ffff8801b6faa380 ffff8801bf308000
[  255.807932] <0> ffff8801b6f33c48 ffffffff8135e900 ffff8801b8f98000 ffff8801b8f98000
[  255.807940] <0> ffff8801b6f33c00 00ffffff815fbeb5 ffff8801000007cc 00ff8801bf308d80
[  255.807948] Call Trace:
[  255.807951]  [<ffffffff8135e900>] radeon_fence_wait+0x200/0x3c0
[  255.807956]  [<ffffffff81083e80>] ? autoremove_wake_function+0x0/0x40
[  255.807960]  [<ffffffff8136f5cf>] radeon_ib_get+0xaf/0x210
[  255.807964]  [<ffffffff8137046f>] radeon_cs_ioctl+0x8f/0x1c0
[  255.807968]  [<ffffffff8131b893>] drm_ioctl+0x1c3/0x490
[  255.807972]  [<ffffffff81098a17>] ? __lock_acquire+0x4f7/0xb30
[  255.807975]  [<ffffffff813703e0>] ? radeon_cs_ioctl+0x0/0x1c0
[  255.807979]  [<ffffffff8108a41d>] ? sched_clock_cpu+0xcd/0x110
[  255.807982]  [<ffffffff810946ea>] ? get_lock_stats+0x2a/0x60
[  255.807985]  [<ffffffff8109472e>] ? put_lock_stats+0xe/0x30
[  255.807988]  [<ffffffff81094803>] ? lock_release_holdtime+0xb3/0x160
[  255.807992]  [<ffffffff81106318>] vfs_ioctl+0x38/0xd0
[  255.807995]  [<ffffffff811064ea>] do_vfs_ioctl+0x8a/0x5b0
[  255.807999]  [<ffffffff8127a7f9>] ? __up_read+0x99/0xc0
[  255.808002]  [<ffffffff81088ac6>] ? up_read+0x26/0x30
[  255.808006]  [<ffffffff81028bba>] ? sysret_check+0x2e/0x69
[  255.808009]  [<ffffffff81106a5a>] sys_ioctl+0x4a/0x80
[  255.808012]  [<ffffffff81028b82>] system_call_fastpath+0x16/0x1b
[  255.808014] Code: 08 48 8d 7f 08 e8 cb 93 f1 ff 48 89 d8 48 83 c4 08 5b c9 c3 90 55 48 89 e5 48 83 ec 20 48 89 5d f0 4c 89 65 f8 48 89 fb 48 8b 3f <80> bf d8 13 00 00 00 75 61 48 85 db 74 5c 48 81 c7 30 0c 00 00
[  255.808088] RIP  [<ffffffff8135e656>] radeon_fence_signaled+0x16/0xc0
[  255.808092]  RSP <ffff8801b6f33b78>
[  255.808094] CR2: 00000000000013d8

Cheers,
Grant
-- 
Running Linux 2.6.33-rc2 on x86_64
