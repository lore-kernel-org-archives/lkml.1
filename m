Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966360Ab0B0LyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 06:54:05 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:50003 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966055Ab0B0LyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 06:54:01 -0500
Message-ID: <4B8907CD.2090604@wpkg.org>
Date: Sat, 27 Feb 2010 12:53:49 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [2.6.33] KMS radeon oops
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like 2.6.33 doesn't like my radeon card after all:

[  567.176339] BUG: unable to handle kernel paging request at 00007fffa555cf00
[  567.176342] IP: [<00007fffa555cf00>] 0x7fffa555cf00
[  567.176347] PGD 23c383067 PUD 0 
[  567.176349] Oops: 0010 [#1] SMP 
[  567.176351] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[  567.176353] CPU 1 
[  567.176355] Pid: 13169, comm: X Not tainted 2.6.33-desktop-1mnb #1 DX58SO/        
[  567.176357] RIP: 0010:[<00007fffa555cf00>]  [<00007fffa555cf00>] 0x7fffa555cf00
[  567.176360] RSP: 0018:ffff880218d05dc0  EFLAGS: 00010086
[  567.176361] RAX: ffff88020c339e28 RBX: ffffffff816606f0 RCX: 0000000000000000
[  567.176362] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88020c339e28
[  567.176364] RBP: ffff880218d05e08 R08: 0000000000000000 R09: 0000000000000246
[  567.176365] R10: 0000000000000000 R11: 0000000000003246 R12: 0000000000000000
[  567.176367] R13: ffffffff81660708 R14: 0000000000000000 R15: 0000000000000000
[  567.176369] FS:  00007f7d75353700(0000) GS:ffff880008c20000(0000) knlGS:0000000000000000
[  567.176370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  567.176372] CR2: 00007fffa555cf00 CR3: 0000000232050000 CR4: 00000000000006e0
[  567.176373] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  567.176375] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  567.176376] Process X (pid: 13169, threadinfo ffff880218d04000, task ffff880234bd4350)
[  567.176378] Stack:
[  567.176378]  ffffffff81041599 0000000200000000 0000000300000000 0000000000000003
[  567.176381] <0> ffffffff81660700 0000000000000086 0000000000000003 0000000000000000
[  567.176383] <0> 0000000000000000 ffff880218d05e48 ffffffff810488a8 0000000018d05e78
[  567.176386] Call Trace:
[  567.176391]  [<ffffffff81041599>] ? __wake_up_common+0x59/0x90
[  567.176394]  [<ffffffff810488a8>] __wake_up+0x48/0x70
[  567.176397]  [<ffffffff812996e0>] __vga_put+0x80/0xe0
[  567.176399]  [<ffffffff81299c3d>] vga_put+0x7d/0xa0
[  567.176401]  [<ffffffff8129a6e5>] vga_arb_write+0x3e5/0x510
[  567.176404]  [<ffffffff811286a8>] vfs_write+0xb8/0x1a0
[  567.176406]  [<ffffffff811290e1>] sys_write+0x51/0x90
[  567.176410]  [<ffffffff813b965e>] ? do_device_not_available+0xe/0x10
[  567.176413]  [<ffffffff8100a042>] system_call_fastpath+0x16/0x1b
[  567.176415] Code:  Bad RIP value.
[  567.176416] RIP  [<00007fffa555cf00>] 0x7fffa555cf00
[  567.176418]  RSP <ffff880218d05dc0>
[  567.176419] CR2: 00007fffa555cf00
[  567.176421] ---[ end trace 82f996cc864ef16f ]---



-- 
Tomasz Chmielewski
http://wpkg.org
