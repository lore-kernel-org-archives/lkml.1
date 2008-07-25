Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYGYN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYGYN0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYGYN0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:26:14 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3785 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYGYN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:26:13 -0400
Message-ID: <4889D471.2050301@xs4all.nl>
Date: Fri, 25 Jul 2008 15:26:09 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: What to do with `kswapd0: page allocation failure. ` ?
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Found a few of these logged. See below.
What are they? Harmfull? Bug?

Kind regards,
Udo

Jul 20 18:39:03 testboard kernel: kswapd0: page allocation failure.
order:2, mode:0x20
Jul 20 18:39:03 testboard kernel: Pid: 235, comm: kswapd0 Not tainted
2.6.25.6 #8
Jul 20 18:39:03 testboard kernel:
Jul 20 18:39:03 testboard kernel: Call Trace:
Jul 20 18:39:03 testboard kernel:  <IRQ>  [<ffffffff8027c91e>]
__alloc_pages+0x2de/0x3b0
Jul 20 18:39:03 testboard kernel:  [<ffffffff8029af27>]
cache_alloc_refill+0x307/0x5c0
Jul 20 18:39:03 testboard kernel:  [<ffffffff8029b2b3>] __kmalloc+0xd3/0xe0
Jul 20 18:39:03 testboard kernel:  [<ffffffff8047c2dd>]
__alloc_skb+0x6d/0x150
Jul 20 18:39:03 testboard kernel:  [<ffffffff803c2d78>]
nv_alloc_rx_optimized+0x158/0x1b0
Jul 20 18:39:03 testboard kernel:  [<ffffffff803c8b72>]
nv_napi_poll+0x242/0x890
Jul 20 18:39:03 testboard kernel:  [<ffffffff804801ef>]
net_rx_action+0x8f/0x160
Jul 20 18:39:03 testboard kernel:  [<ffffffff8023e4da>]
__do_softirq+0x5a/0xc0
Jul 20 18:39:03 testboard kernel:  [<ffffffff8020c75c>]
call_softirq+0x1c/0x30
Jul 20 18:39:03 testboard kernel:  [<ffffffff8020e6e5>] do_softirq+0x35/0x70
Jul 20 18:39:03 testboard kernel:  [<ffffffff8023e0a5>] irq_exit+0x45/0x50
Jul 20 18:39:03 testboard kernel:  [<ffffffff8020e98f>] do_IRQ+0x9f/0x130
Jul 20 18:39:03 testboard kernel:  [<ffffffff8020bab1>]
ret_from_intr+0x0/0xa
Jul 20 18:39:03 testboard kernel:  <EOI>  [<ffffffff8027bdbd>]
free_hot_cold_page+0x18d/0x290
Jul 20 18:39:03 testboard kernel:  [<ffffffff8027bf00>]
__pagevec_free+0x40/0x50
Jul 20 18:39:03 testboard kernel:  [<ffffffff8027ef80>]
__pagevec_release_nonlru+0x60/0x70
Jul 20 18:39:03 testboard kernel:  [<ffffffff8028114b>]
shrink_page_list+0x30b/0x6c0
Jul 20 18:39:03 testboard kernel:  [<ffffffff802805ba>]
isolate_lru_pages+0x19a/0x240
Jul 20 18:39:03 testboard kernel:  [<ffffffff8028169e>]
shrink_inactive_list+0x19e/0x4f0
Jul 20 18:39:03 testboard kernel:  [<ffffffff80281aa4>]
shrink_zone+0xb4/0x130
Jul 20 18:39:03 testboard kernel:  [<ffffffff80282258>] kswapd+0x568/0x5d0
Jul 20 18:39:03 testboard kernel:  [<ffffffff80280660>]
isolate_pages_global+0x0/0x40
Jul 20 18:39:03 testboard kernel:  [<ffffffff8024eb10>]
autoremove_wake_function+0x0/0x30
Jul 20 18:39:03 testboard kernel:  [<ffffffff80281cf0>] kswapd+0x0/0x5d0
Jul 20 18:39:03 testboard kernel:  [<ffffffff8024e777>] kthread+0x47/0x80
Jul 20 18:39:03 testboard kernel:  [<ffffffff80235249>]
schedule_tail+0x39/0x80
Jul 20 18:39:03 testboard kernel:  [<ffffffff8020c3e8>] child_rip+0xa/0x12
Jul 20 18:39:03 testboard kernel:  [<ffffffff8024e730>] kthread+0x0/0x80
Jul 20 18:39:03 testboard kernel:  [<ffffffff8020c3de>] child_rip+0x0/0x12
Jul 20 18:39:03 testboard kernel:
Jul 20 18:39:03 testboard kernel: Mem-info:
Jul 20 18:39:03 testboard kernel: DMA per-cpu:
Jul 20 18:39:03 testboard kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jul 20 18:39:03 testboard kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jul 20 18:39:03 testboard kernel: DMA32 per-cpu:
Jul 20 18:39:03 testboard kernel: CPU    0: hi:  186, btch:  31 usd: 155
Jul 20 18:39:03 testboard kernel: CPU    1: hi:  186, btch:  31 usd:  69
Jul 20 18:39:03 testboard kernel: Normal per-cpu:
Jul 20 18:39:03 testboard kernel: CPU    0: hi:  186, btch:  31 usd: 183
Jul 20 18:39:03 testboard kernel: CPU    1: hi:  186, btch:  31 usd: 171
Jul 20 18:39:03 testboard kernel: Active:434125 inactive:510998
dirty:29134 writeback:0 unstable:0
Jul 20 18:39:03 testboard kernel:  free:14760 slab:31823 mapped:40791
pagetables:12138 bounce:0
Jul 20 18:39:03 testboard kernel: DMA free:11052kB min:20kB low:24kB
high:28kB active:0kB inactive:0kB present:10608kB pages_scanned:0
all_unreclaimable? yes
Jul 20 18:39:03 testboard kernel: lowmem_reserve[]: 0 3511 4016 4016
Jul 20 18:39:03 testboard kernel: DMA32 free:46820kB min:7080kB
low:8848kB high:10620kB active:1404960kB inactive:1934108kB
present:3595424kB pages_scanned:0 all_unreclaimable? no
Jul 20 18:39:03 testboard kernel: lowmem_reserve[]: 0 0 505 505
Jul 20 18:39:03 testboard kernel: Normal free:1168kB min:1016kB
low:1268kB high:1524kB active:331540kB inactive:109884kB
present:517120kB pages_scanned:0 all_unreclaimable? no
Jul 20 18:39:03 testboard kernel: lowmem_reserve[]: 0 0 0 0
Jul 20 18:39:03 testboard kernel: DMA: 1*4kB 3*8kB 3*16kB 3*32kB 4*64kB
3*128kB 2*256kB 1*512kB 3*1024kB 1*2048kB 1*4096kB = 11052kB
Jul 20 18:39:03 testboard kernel: DMA32: 4100*4kB 3719*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 46808kB
Jul 20 18:39:03 testboard kernel: Normal: 174*4kB 46*8kB 5*16kB 0*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1208kB
Jul 20 18:39:03 testboard kernel: 553286 total pagecache pages
Jul 20 18:39:03 testboard kernel: Swap cache: add 260, delete 260, find
33/38
Jul 20 18:39:03 testboard kernel: Free swap  = 4144584kB
Jul 20 18:39:03 testboard kernel: Total swap = 4144736kB
Jul 20 18:39:03 testboard kernel: Free swap:       4144584kB
Jul 20 18:39:03 testboard kernel: 1179648 pages of RAM
Jul 20 18:39:03 testboard kernel: 167096 reserved pages
Jul 20 18:39:03 testboard kernel: 685887 pages shared
Jul 20 18:39:03 testboard kernel: 0 pages swap cached

