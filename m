Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZGMLxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZGMLxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZGMLxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:53:07 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:48931 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755496AbZGMLxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:53:06 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 07:53:05 EDT
X-Sender-Authentication: net64
Date: Mon, 13 Jul 2009 13:46:21 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: What to do with this message (2.6.30.1) ?
Message-Id: <20090713134621.124aa18e.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

first day of using 2.6.30.1 on a box that mostly accepts rsync connections 
revealed this message. This is in fact not the only one of this type. Quite
a lot from other processes follow. What can I do to prevent that? Is that
a kind of a bug? 
I did not experience that on a box with the same job using tg3 instead of
e1000e.

Jul 13 01:10:57 backup kernel: swapper: page allocation failure. order:0, mode:0x20
Jul 13 01:10:57 backup kernel: Pid: 0, comm: swapper Not tainted 2.6.30.1 #3
Jul 13 01:10:57 backup kernel: Call Trace:
Jul 13 01:10:57 backup kernel:  <IRQ>  [<ffffffff80269182>] ? __alloc_pages_internal+0x3df/0x3ff
Jul 13 01:10:57 backup kernel:  [<ffffffff802876cf>] ? cache_alloc_refill+0x25e/0x4a0
Jul 13 01:10:57 backup kernel:  [<ffffffff803eb067>] ? sock_def_readable+0x10/0x62
Jul 13 01:10:57 backup kernel:  [<ffffffff8028798a>] ? __kmalloc+0x79/0xa1
Jul 13 01:10:57 backup kernel:  [<ffffffff803ef98a>] ? __alloc_skb+0x5c/0x12a
Jul 13 01:10:57 backup kernel:  [<ffffffff803f0558>] ? __netdev_alloc_skb+0x15/0x2f
Jul 13 01:10:57 backup kernel:  [<ffffffffa000cda0>] ? e1000_alloc_rx_buffers+0x8c/0x248 [e1000e]
Jul 13 01:10:57 backup kernel:  [<ffffffffa000d262>] ? e1000_clean_rx_irq+0x2a2/0x2db [e1000e]
Jul 13 01:10:57 backup kernel:  [<ffffffffa000e8dc>] ? e1000_clean+0x70/0x219 [e1000e]
Jul 13 01:10:57 backup kernel:  [<ffffffff803f3adf>] ? net_rx_action+0x69/0x11f
Jul 13 01:10:58 backup kernel:  [<ffffffff802373eb>] ? __do_softirq+0x66/0xf7
Jul 13 01:10:58 backup kernel:  [<ffffffff8020bebc>] ? call_softirq+0x1c/0x28
Jul 13 01:10:58 backup kernel:  [<ffffffff8020d680>] ? do_softirq+0x2c/0x68
Jul 13 01:10:58 backup kernel:  [<ffffffff8020cf62>] ? do_IRQ+0xa9/0xbf
Jul 13 01:10:58 backup kernel:  [<ffffffff8020b793>] ? ret_from_intr+0x0/0xa
Jul 13 01:10:58 backup kernel:  <EOI>  [<ffffffff802116d8>] ? mwait_idle+0x6e/0x73
Jul 13 01:10:58 backup kernel:  [<ffffffff802116d8>] ? mwait_idle+0x6e/0x73
Jul 13 01:10:58 backup kernel:  [<ffffffff8020a1cb>] ? cpu_idle+0x40/0x7c
Jul 13 01:10:58 backup kernel:  [<ffffffff805a7bb0>] ? start_kernel+0x31e/0x32a
Jul 13 01:10:58 backup kernel:  [<ffffffff805a737e>] ? x86_64_start_kernel+0xe5/0xeb
Jul 13 01:10:58 backup kernel: DMA per-cpu:
Jul 13 01:10:58 backup kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jul 13 01:10:58 backup kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jul 13 01:10:58 backup kernel: CPU    2: hi:    0, btch:   1 usd:   0
Jul 13 01:10:58 backup kernel: CPU    3: hi:    0, btch:   1 usd:   0
Jul 13 01:10:58 backup kernel: DMA32 per-cpu:
Jul 13 01:10:58 backup kernel: CPU    0: hi:  186, btch:  31 usd: 130
Jul 13 01:10:58 backup kernel: CPU    1: hi:  186, btch:  31 usd:  90
Jul 13 01:10:59 backup kernel: CPU    2: hi:  186, btch:  31 usd: 142
Jul 13 01:10:59 backup kernel: CPU    3: hi:  186, btch:  31 usd: 177
Jul 13 01:10:59 backup kernel: Normal per-cpu:
Jul 13 01:10:59 backup kernel: CPU    0: hi:  186, btch:  31 usd:  76
Jul 13 01:10:59 backup kernel: CPU    1: hi:  186, btch:  31 usd: 160
Jul 13 01:10:59 backup kernel: CPU    2: hi:  186, btch:  31 usd: 170
Jul 13 01:10:59 backup kernel: CPU    3: hi:  186, btch:  31 usd: 165
Jul 13 01:10:59 backup kernel: Active_anon:117688 active_file:169003 inactive_anon:22048
Jul 13 01:10:59 backup kernel:  inactive_file:1425813 unevictable:0 dirty:337125 writeback:4493 unstable:0
Jul 13 01:10:59 backup kernel:  free:8260 slab:297474 mapped:1475 pagetables:1685 bounce:0
Jul 13 01:11:00 backup kernel: DMA free:11712kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:10756kB pages_scanned:0 all_unreclaimable? yes
Jul 13 01:11:00 backup kernel: lowmem_reserve[]: 0 3767 8059 8059
Jul 13 01:11:00 backup kernel: DMA32 free:19060kB min:5364kB low:6704kB high:8044kB active_anon:180632kB inactive_anon:38496kB active_file:318456kB inactive_file:2581460kB unevictable:0kB present:3857440kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:00 backup kernel: lowmem_reserve[]: 0 0 4292 4292
Jul 13 01:11:00 backup kernel: Normal free:2268kB min:6112kB low:7640kB high:9168kB active_anon:290120kB inactive_anon:49696kB active_file:357556kB inactive_file:3121792kB unevictable:0kB present:4395520kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:00 backup kernel: lowmem_reserve[]: 0 0 0 0
Jul 13 01:11:00 backup kernel: DMA: 6*4kB 3*8kB 3*16kB 3*32kB 4*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB = 11712kB
Jul 13 01:11:00 backup kernel: DMA32: 2720*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 19040kB
Jul 13 01:11:00 backup kernel: Normal: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2236kB
Jul 13 01:11:00 backup kernel: 1594864 total pagecache pages
Jul 13 01:11:00 backup kernel: 9 pages in swap cache
Jul 13 01:11:00 backup kernel: Swap cache stats: add 1047, delete 1038, find 0/0
Jul 13 01:11:00 backup kernel: Free swap  = 2100300kB
Jul 13 01:11:00 backup kernel: Total swap = 2104488kB


-- 
Regards,
Stephan

