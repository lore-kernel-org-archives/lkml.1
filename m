Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZJ0JuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZJ0JuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZJ0JuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:50:24 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:35899
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbZJ0JuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 05:50:23 -0400
Date: Tue, 27 Oct 2009 10:50:15 +0100
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091027095014.GA22215@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I noticed that I get page alloc errors on one of my machines.
It is an old server I use as a fileserver with 512MB RAM. Before
2.6.3[12] I did not see this problem at all. 
This only seems to happens when I use mutt on this machine.
I know that it means I am running out of memory here, but I am wondering
why I did not see this before....


mutt: page allocation failure. order:1, mode:0x20
Pid: 21746, comm: mutt Not tainted 2.6.32-rc5 #2
Call Trace:
 [<c11981ef>] ? printk+0x18/0x21
 [<c1050945>] __alloc_pages_nodemask+0x417/0x4d8
 [<c1069edc>] cache_alloc_refill+0x250/0x496
 [<c106a1c6>] __kmalloc+0xa4/0xa8
 [<c110ddef>] tty_buffer_request_room+0x88/0x11d
 [<c110dfb8>] tty_insert_flip_string+0x27/0x93
 [<c110e8d9>] pty_write+0x24/0x4a
 [<c110a24f>] n_tty_write+0x163/0x3ab
 [<c1020960>] ? default_wake_function+0x0/0xd
 [<c1107f3c>] tty_write+0x129/0x1c2
 [<c110a0ec>] ? n_tty_write+0x0/0x3ab
 [<c106cfe0>] vfs_write+0x8e/0x142
 [<c1107e13>] ? tty_write+0x0/0x1c2
 [<c106d13d>] sys_write+0x3d/0x6b
 [<c1002bb5>] syscall_call+0x7/0xb
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  52
active_anon:17616 inactive_anon:20870 isolated_anon:0
 active_file:27963 inactive_file:43021 isolated_file:0
 unevictable:0 dirty:284 writeback:0 unstable:0 buffer:5599
 free:1401 slab_reclaimable:2966 slab_unreclaimable:3731
 mapped:4083 shmem:88 pagetables:515 bounce:0
DMA free:2196kB min:84kB low:104kB high:124kB active_anon:1496kB inactive_anon:2340kB active_file:3212kB inactive_file:5884kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:40kB writeback:0kB mapped:648kB shmem:0kB slab_reclaimable:244kB slab_unreclaimable:244kB kernel_stack:176kB pagetables:64kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 491 491
Normal free:3408kB min:2792kB low:3488kB high:4188kB active_anon:68968kB inactive_anon:81140kB active_file:108640kB inactive_file:166200kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:503616kB mlocked:0kB dirty:1096kB writeback:0kB mapped:15684kB shmem:352kB slab_reclaimable:11620kB slab_unreclaimable:14680kB kernel_stack:1688kB pagetables:1996kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 549*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2196kB
Normal: 754*4kB 35*8kB 7*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3408kB
73515 total pagecache pages
2437 pages in swap cache
Swap cache stats: add 22864, delete 20427, find 290544/291230
Free swap  = 456788kB
Total swap = 524280kB
130976 pages RAM
1952 pages reserved
52425 pages shared
86057 pages non-shared

Please put me on CC since I am not subscribed to the list.

Kind regards,
Michael
