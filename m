Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZDNK2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZDNK2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZDNK23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:28:29 -0400
Received: from galaxy-old.riz.pl ([195.94.202.2]:51832 "HELO vhost.riz.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751305AbZDNK22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:28:28 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 06:28:27 EDT
Date: Tue, 14 Apr 2009 12:21:43 +0200 (CEST)
From: Bart <mmx@riz.pl>
X-X-Sender: evil@galaxy.riz.pl
To: linux-kernel@vger.kernel.org
Subject: Oops 2.6.29.1 
Message-ID: <Pine.LNX.4.64.0904141202160.28844@galaxy.riz.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It happened 3 times. Every time after running amtapetype.
It seems that amtapetype is stressing the system enought to make it crash.
It does not happen every time. I do not know if it is related to scsi or 
something else so I am posting here.


[  413.780777] BUG: unable to handle kernel NULL pointer dereference at 0000000000000cd0
[  413.784750] IP: [<ffffffff8029b719>] free_block+0x70/0x116
[  413.784750] PGD 12e446067 PUD 13c867067 PMD 0
[  413.784750] Oops: 0002 [#1] SMP
[  413.784750] last sysfs file: /sys/class/vc/vcs1/dev
[  413.784750] CPU 3
[  413.784750] Modules linked in: aes_x86_64 aes_generic xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_mangle iptable_filter ip_tables x_tables
[  413.784750] Pid: 15, comm: events/3 Not tainted 2.6.29.1-64 #1 MP Server
[  413.784750] RIP: 0010:[<ffffffff8029b719>]  [<ffffffff8029b719>] free_block+0x70/0x116
[  413.784750] RSP: 0000:ffff88013f953e10  EFLAGS: 00010082
[  413.784750] RAX: 0000000000000cd0 RBX: ffff88013f971980 RCX: ffff88013f0551c0
[  413.784750] RDX: ffffe200040696e0 RSI: ffff88013cd4aac0 RDI: ffff88013cd02000
[  413.784750] RBP: ffff88013cd02000 R08: 0000000000000000 R09: ffff880028101940
[  413.784750] R10: ffff88013f9e7960 R11: ffffffff807edb00 R12: 0000000000000000
[  413.784750] R13: 0000000000000000 R14: 0000000000000002 R15: ffff88013f9ce618
[  413.784750] FS:  0000000000000000(0000) GS:ffff88013f8ffbc0(0000) knlGS:0000000000000000
[  413.784750] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  413.784750] CR2: 0000000000000cd0 CR3: 000000012e5dd000 CR4: 00000000000006e0
[  413.784750] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  413.784750] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  413.784750] Process events/3 (pid: 15, threadinfo ffff88013f952000, task ffff88013f94ac30)
[  413.784750] Stack:
[  413.784750]  ffff88013f9e7960 ffff88013f9ce618 0000000000000002 ffff88013f9ce600
[  413.784750]  ffff88013f0551c0 0000000000000000 ffff88013f971980 ffffffff8029b84a
[  413.784750]  ffffffff807edb00 ffff88013f0551c0 ffff88013f971980 ffff8800280501a0
[  413.784750] Call Trace:
[  413.784750]  [<ffffffff8029b84a>] ? drain_array+0x8b/0xbd
[  413.784750]  [<ffffffff8029b952>] ? cache_reap+0x4d/0x104
[  413.784750]  [<ffffffff8029b905>] ? cache_reap+0x0/0x104
[  413.784750]  [<ffffffff8025bb33>] ? run_workqueue+0x78/0x103
[  413.784750]  [<ffffffff8025c49a>] ? worker_thread+0xd9/0xe8
[  413.784750]  [<ffffffff8025ee58>] ? autoremove_wake_function+0x0/0x2e
[  413.784750]  [<ffffffff8025c3c1>] ? worker_thread+0x0/0xe8
[  413.784750]  [<ffffffff8025c3c1>] ? worker_thread+0x0/0xe8
[  413.784750]  [<ffffffff8025ed3b>] ? kthread+0x47/0x74
[  413.784750]  [<ffffffff80225afa>] ? child_rip+0xa/0x20
[  413.784750]  [<ffffffff8025ecf4>] ? kthread+0x0/0x74
[  413.784750]  [<ffffffff80225af0>] ? child_rip+0x0/0x20
[  413.784750] Code: d0 f6 40 01 40 74 04 48 8b 40 10 80 38 00 78 04 0f 0b eb fe 48 8b 70 30 4a 8b 8c eb 68 01 00 00 48 8b 16 48 8b 46 08 48 89 42 08 <48> 89 10 89 e8 48 c7 06 00 01 10 00 48 c7 46 08 00 02 20 00 2b
[  413.784750] RIP  [<ffffffff8029b719>] free_block+0x70/0x116
[  413.784750]  RSP <ffff88013f953e10>
[  413.784750] CR2: 0000000000000cd0
[  413.784750] ---[ end trace 669fa0dc298e2541 ]---


