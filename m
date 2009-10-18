Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZJRBZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZJRBZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 21:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZJRBZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 21:25:50 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:53806 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZJRBZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 21:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ozfSLLI0h+uw/7wGWXwIvOoP02eHwy2U5lQrfesA/L77c5XzmQd52qmWBlVvKEcczt
         dX0PTrW58LyvpBiHr5QhUhkhV1ASYg/KauovCv4xJ5IgmFawCOxF3hzDXPRCqfQsK5yW
         pPpjb1gSY0GdvXomEvUvLxv+/aA3HKUro/+7o=
MIME-Version: 1.0
Date: Sat, 17 Oct 2009 18:25:53 -0700
Message-ID: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
Subject: nfs mount fail
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpk12-3214-189-144:~ # cat x
mount -t nfs 10.6.75.100:/data/shared/pxeboot /x

mpk12-3214-189-144:~ # sh x

[  278.734149] ------------[ cut here ]------------
[  278.739620] kernel BUG at mm/slub.c:2969!
[  278.743056] invalid opcode: 0000 [#1] SMP
[  278.750365] last sysfs file: /sys/devices/virtual/net/sit0/type
[  278.755898] CPU 0
[  278.758637] Modules linked in:
[  278.770030] Pid: 2594, comm: rpciod/0 Not tainted
2.6.32-rc5-tip-01483-ga166936-dirty #651
[  278.788458] RIP: 0010:[<ffffffff81174437>]  [<ffffffff81174437>]
kfree+0x96/0x14a
[  278.797545] RSP: 0018:ffff88087b9fdc50  EFLAGS: 00010246
[  278.810035] RAX: 0a00000000000000 RBX: 0000000000037803 RCX: ffff880854828018
[  278.815372] RDX: ffffea0000000000 RSI: 0000000000000378 RDI: ffff881800706475
[  278.832711] RBP: ffff88087b9fdc90 R08: ffff88084d37ce80 R09: 00000000e3115a3e
[  278.848764] R10: 00000000ffffe0be R11: 0000000000000000 R12: ffffea009c02da70
[  278.852385] R13: ffff881800706475 R14: ffff88084439d680 R15: 0000000000000001
[  278.872750] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[  278.889379] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  278.895226] CR2: 00007fcb2369c000 CR3: 0000000848df0000 CR4: 00000000000026f0
[  278.911157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  278.916692] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  278.934540] Process rpciod/0 (pid: 2594, threadinfo
ffff88087b9fc000, task ffff88087bdc2370)
[  278.950913] Stack:
[  278.952455]  ffff88087913e934 ffff88087747e048 00000000e3115a3e
0000000000037803
[  278.969335] <0> ffff880854828000 ffff88084d37ce80 ffff88084439d680
0000000000000001
[  278.976115] <0> ffff88087b9fdcc0 ffffffff81dae6d8 ffffffff81dbb5d5
00000000e3115a3e
[  278.995869] Call Trace:
[  278.997442]  [<ffffffff81dae6d8>] xs_set_port+0x73/0xa3
[  279.011219]  [<ffffffff81dbb5d5>] ? rpcb_dec_getport+0x0/0xc2
[  279.016461]  [<ffffffff81dbb4ac>] rpcb_getport_done+0x80/0xdb
[  279.030585]  [<ffffffff81db1cbf>] rpc_exit_task+0x3b/0x7f
[  279.033790]  [<ffffffff81db24a9>] __rpc_execute+0x97/0x251
[  279.051120]  [<ffffffff81db26e2>] rpc_async_schedule+0x28/0x3e
[  279.057205]  [<ffffffff810bbe9c>] worker_thread+0x1fa/0x317
[  279.071181]  [<ffffffff810bbe42>] ? worker_thread+0x1a0/0x317
[  279.075343]  [<ffffffff81db26ba>] ? rpc_async_schedule+0x0/0x3e
[  279.092033]  [<ffffffff810c26c8>] ? autoremove_wake_function+0x0/0x63
[  279.100028]  [<ffffffff810bbca2>] ? worker_thread+0x0/0x317
[  279.112094]  [<ffffffff810c2277>] kthread+0x9d/0xa5
[  279.116720]  [<ffffffff8104205a>] child_rip+0xa/0x20
[  279.133457]  [<ffffffff810419fc>] ? restore_args+0x0/0x30
[  279.137271]  [<ffffffff810c21da>] ? kthread+0x0/0xa5
[  279.149933]  [<ffffffff81042050>] ? child_rip+0x0/0x20
[  279.154086] Code: 00 00 00 00 00 ea ff ff 48 6b c0 68 4c 8d 24 10
66 41 83 3c 24 00 79 05 4d 8b 64 24 10 49 8b 04 24 84 c0 78 17 66 a9
00 c0 75 04 <0f> 0b eb fe 4c 89 e7 e8 87 b8 fc ff e9 80 00 00 00 48 8b
45 08
[  279.198800] RIP  [<ffffffff81174437>] kfree+0x96/0x14a
[  279.204063]  RSP <ffff88087b9fdc50>
[  279.210307] ---[ end trace 52f0b2ff8e4dec91 ]---

Message from syslogd@mpk12-3214-189-144 at Sat Oct 17 18:23:40 2009 ...
mpk12-3214-189-144 kernel: [  278.734149] ------------[ cut here ]------------

Message from syslogd@mpk12-3214-189-144 at Sat Oct 17 18:23:40 2009 ...
mpk12-3214-189-144 kernel: [  278.743056] invalid opcode: 0000 [#1] SMP

Message from syslogd@mpk12-3214-189-144 at Sat Oct 17 18:23:40 2009 ...
mpk12-3214-189-144 kernel: [  278.750365] last sysfs file:
/sys/devices/virtual/net/sit0/type

Message from syslogd@mpk12-3214-189-144 at Sat Oct 17 18:23:40 2009 ...
mpk12-3214-189-144 kernel: [  278.950913] Stack:

Message from syslogd@mpk12-3214-189-144 at Sat Oct 17 18:23:40 2009 ...
mpk12-3214-189-144 kernel: [  278.995869] Call Trace:

Message from syslogd@mpk12-3214-189-144 at Sat Oct 17 18:23:40 2009 ...
mpk12-3214-189-144 kernel: [  279.154086] Code: 00 00 00 00 00 ea ff
ff 48 6b c0 68 4c 8d 24 10 66 41 83 3c 24 00 79 05 4d 8b 64 24 10 49
8b 04 24 84 c0 78 17 66 a9 00 c0 75 04 <0f> 0b eb fe 4c 89 e7 e8 87 b8
fc ff e9 80 00 00 00 48 8b 45 08

mount.nfs: mount system call failed
