Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbXIMHaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbXIMHaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXIMHaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:30:05 -0400
Received: from 82-168-173-188-static.dsl.ip.tiscali.nl ([82.168.173.188]:37621
	"EHLO engine.bazuin.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXIMHaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:30:02 -0400
From: "L.P.H. van Belle" <belle@bazuin.nl>
To: <linux-kernel@vger.kernel.org>
Subject: FW: Kernel message: swapper: page allocation failure. order:1, mode:0x20
Date: Thu, 13 Sep 2007 09:29:59 +0200
Organization: Bazuin en Partners Gerechtsdeurwaarders
Message-ID: <00c201c7f5d7$e3e0c200$c9f9a8c0@rotterdam.bazuin.nl>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Thread-Index: Acf10vgA11HX0qe/S6mWDwD3Jz+/rAABNkpg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
 
I dont know where i should report kernel bugs, 
 
There for i'll emailed to the list.
 
Im running a Dell PE2900 , 2 x quad core Pentium Xeon E5345 CPU. 
The error below occurs during backup. This includes network backups a total
of 80 Gb.
I'm using Bru Server for backupping my servers. ( 5 nodes ) 
 
The server keeps running, even with the error below.
I included the lsmod output. 
 
Running kernel version is. 2.6.22-4  
( debian kernel: 2.6.22-2-686-bigmem )
 
 
Thanx in advance, and keep the good work all.
 
If someone needs more info, please email me at 
belle@bazuin.nl
 
 
 
 
/snap
Sep 13 02:56:52 ms249-lin-005 -- MARK --
Sep 13 03:06:23 ms249-lin-005 kernel: swapper: page allocation failure.
order:1, mode:0x20
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c01542cc>]
__alloc_pages+0x283/0x294
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c016a47d>]
cache_alloc_refill+0x27e/0x48d
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c016a6ee>] __kmalloc+0x62/0x79
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0249370>] __alloc_skb+0x49/0xf7
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0277827>] tcp_collapse+0x140/0x321
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0277b6a>]
tcp_prune_queue+0x162/0x23a
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0277def>]
tcp_data_queue+0x1ad/0xa4f
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0279db2>]
tcp_rcv_established+0x713/0x7d5
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c02657d8>]
ip_route_input+0x3a/0xc73
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c027ec98>] tcp_v4_do_rcv+0x2b/0x326
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0280fff>] tcp_v4_rcv+0x843/0x8cc
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c02687bb>]
ip_local_deliver+0x189/0x232
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c016a25a>]
cache_alloc_refill+0x5b/0x48d
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c02685f9>] ip_rcv+0x484/0x4bd
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c024d2c1>]
netif_receive_skb+0x2b5/0x316
Sep 13 03:06:23 ms249-lin-005 kernel:  [<f893a5c1>] bnx2_poll+0x723/0x8e8
[bnx2]
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c01382d7>] getnstimeofday+0x30/0xb9
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c01366b9>]
enqueue_hrtimer+0xde/0xe8
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0136ddb>] hrtimer_start+0xe8/0xf2
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c024f0c6>] net_rx_action+0x9a/0x1a3
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c01281e9>] __do_softirq+0x66/0xd3
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c012829b>] do_softirq+0x45/0x53
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c01284ff>] irq_exit+0x38/0x6b
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0106383>] do_IRQ+0x5a/0x6f
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0104773>]
common_interrupt+0x23/0x28
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0102241>]
mwait_idle_with_hints+0x3b/0x3f
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c0102245>] mwait_idle+0x0/0x13
Sep 13 03:06:23 ms249-lin-005 kernel:  [<c01023ab>] cpu_idle+0xab/0xcc
Sep 13 03:06:23 ms249-lin-005 kernel:  =======================
Sep 13 03:06:23 ms249-lin-005 kernel: Mem-info:
Sep 13 03:06:23 ms249-lin-005 kernel: DMA per-cpu:
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    0: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    1: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    2: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    3: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    4: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    5: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    6: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    7: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: Normal per-cpu:
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    0: Hot: hi:  186, btch:  31
usd:   5   Cold: hi:   62, btch:  15 usd:  59
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    1: Hot: hi:  186, btch:  31
usd:  24   Cold: hi:   62, btch:  15 usd:   6
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    2: Hot: hi:  186, btch:  31
usd:  21   Cold: hi:   62, btch:  15 usd:  54
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    3: Hot: hi:  186, btch:  31
usd: 165   Cold: hi:   62, btch:  15 usd:   0
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    4: Hot: hi:  186, btch:  31
usd: 130   Cold: hi:   62, btch:  15 usd:  55
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    5: Hot: hi:  186, btch:  31
usd:  47   Cold: hi:   62, btch:  15 usd:   9
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    6: Hot: hi:  186, btch:  31
usd:  69   Cold: hi:   62, btch:  15 usd:  47
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    7: Hot: hi:  186, btch:  31
usd:  17   Cold: hi:   62, btch:  15 usd:   3
Sep 13 03:06:23 ms249-lin-005 kernel: HighMem per-cpu:
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    0: Hot: hi:  186, btch:  31
usd: 169   Cold: hi:   62, btch:  15 usd:  10
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    1: Hot: hi:  186, btch:  31
usd: 171   Cold: hi:   62, btch:  15 usd:   7
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    2: Hot: hi:  186, btch:  31
usd: 180   Cold: hi:   62, btch:  15 usd:  14
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    3: Hot: hi:  186, btch:  31
usd: 175   Cold: hi:   62, btch:  15 usd:  14
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    4: Hot: hi:  186, btch:  31
usd: 162   Cold: hi:   62, btch:  15 usd:   1
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    5: Hot: hi:  186, btch:  31
usd: 165   Cold: hi:   62, btch:  15 usd:   3
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    6: Hot: hi:  186, btch:  31
usd:  26   Cold: hi:   62, btch:  15 usd:  14
Sep 13 03:06:23 ms249-lin-005 kernel: CPU    7: Hot: hi:  186, btch:  31
usd: 156   Cold: hi:   62, btch:  15 usd:   8
Sep 13 03:06:23 ms249-lin-005 kernel: Active:1387070 inactive:44288
dirty:126 writeback:0 unstable:0
Sep 13 03:06:23 ms249-lin-005 kernel:  free:508028 slab:28305 mapped:8346
pagetables:448 bounce:0
Sep 13 03:06:23 ms249-lin-005 kernel: DMA free:3500kB min:68kB low:84kB
high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0
all_unreclaimable? yes
Sep 13 03:06:23 ms249-lin-005 kernel: lowmem_reserve[]: 0 873 8874
Sep 13 03:06:23 ms249-lin-005 kernel: Normal free:5100kB min:3744kB
low:4680kB high:5616kB active:121560kB inactive:175336kB present:894080kB
pages_scanned:0 all_unreclaimable? no
Sep 13 03:06:23 ms249-lin-005 kernel: lowmem_reserve[]: 0 0 64008
Sep 13 03:06:23 ms249-lin-005 kernel: HighMem free:2023512kB min:512kB
low:9096kB high:17684kB active:5426720kB inactive:1816kB present:8193024kB
pages_scanned:0 all_unreclaimable? no
Sep 13 03:06:23 ms249-lin-005 kernel: lowmem_reserve[]: 0 0 0
Sep 13 03:06:23 ms249-lin-005 kernel: DMA: 27*4kB 0*8kB 0*16kB 0*32kB 1*64kB
0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3500kB
Sep 13 03:06:23 ms249-lin-005 kernel: Normal: 1096*4kB 47*8kB 0*16kB 0*32kB
1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 5464kB
Sep 13 03:06:23 ms249-lin-005 kernel: HighMem: 31*4kB 356*8kB 600*16kB
775*32kB 191*64kB 32*128kB 4*256kB 3*512kB 2*1024kB 2*2048kB 479*4096kB =
2024380kB
Sep 13 03:06:23 ms249-lin-005 kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Sep 13 03:06:23 ms249-lin-005 kernel: Free swap  = 19535000kB
Sep 13 03:06:23 ms249-lin-005 kernel: Total swap = 19535000kB
Sep 13 03:06:23 ms249-lin-005 kernel: Free swap:       19535000kB
Sep 13 03:06:23 ms249-lin-005 kernel: 2293760 pages of RAM
Sep 13 03:06:23 ms249-lin-005 kernel: 2064384 pages of HIGHMEM
Sep 13 03:06:23 ms249-lin-005 kernel: 215691 reserved pages
Sep 13 03:06:23 ms249-lin-005 kernel: 112498 pages shared
Sep 13 03:06:23 ms249-lin-005 kernel: 0 pages swap cached
Sep 13 03:06:23 ms249-lin-005 kernel: 134 pages dirty
Sep 13 03:06:23 ms249-lin-005 kernel: 0 pages writeback
Sep 13 03:06:23 ms249-lin-005 kernel: 8346 pages mapped
Sep 13 03:06:23 ms249-lin-005 kernel: 28273 pages slab
Sep 13 03:06:23 ms249-lin-005 kernel: 448 pages pagetables
Sep 13 03:06:24 ms249-lin-005 kernel: swapper: page allocation failure.
order:1, mode:0x20
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c01542cc>]
__alloc_pages+0x283/0x294
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c016a47d>]
cache_alloc_refill+0x27e/0x48d
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c016a6ee>] __kmalloc+0x62/0x79
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0249370>] __alloc_skb+0x49/0xf7
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0277827>] tcp_collapse+0x140/0x321
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0277b6a>]
tcp_prune_queue+0x162/0x23a
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0277def>]
tcp_data_queue+0x1ad/0xa4f
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0279db2>]
tcp_rcv_established+0x713/0x7d5
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c02657d8>]
ip_route_input+0x3a/0xc73
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c027ec98>] tcp_v4_do_rcv+0x2b/0x326
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c013007b>]
sys_getpriority+0x7c/0x174
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0280fff>] tcp_v4_rcv+0x843/0x8cc
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c02687bb>]
ip_local_deliver+0x189/0x232
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c016a25a>]
cache_alloc_refill+0x5b/0x48d
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c02685f9>] ip_rcv+0x484/0x4bd
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c024d2c1>]
netif_receive_skb+0x2b5/0x316
Sep 13 03:06:24 ms249-lin-005 kernel:  [<f893a5c1>] bnx2_poll+0x723/0x8e8
[bnx2]
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c01c48f9>]
elv_queue_empty+0x1d/0x1e
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c01c7edf>] blk_run_queue+0x1f/0x63
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c012b992>]
get_next_timer_interrupt+0x143/0x1ab
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c024f0c6>] net_rx_action+0x9a/0x1a3
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c01281e9>] __do_softirq+0x66/0xd3
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c012829b>] do_softirq+0x45/0x53
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c01284ff>] irq_exit+0x38/0x6b
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0106383>] do_IRQ+0x5a/0x6f
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0104773>]
common_interrupt+0x23/0x28
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0102241>]
mwait_idle_with_hints+0x3b/0x3f
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c0102245>] mwait_idle+0x0/0x13
Sep 13 03:06:24 ms249-lin-005 kernel:  [<c01023ab>] cpu_idle+0xab/0xcc
Sep 13 03:06:24 ms249-lin-005 kernel:  =======================
Sep 13 03:06:24 ms249-lin-005 kernel: Mem-info:
Sep 13 03:06:24 ms249-lin-005 kernel: DMA per-cpu:
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    0: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    1: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    2: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    3: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    4: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    5: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    6: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    7: Hot: hi:    0, btch:   1
usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: Normal per-cpu:
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    0: Hot: hi:  186, btch:  31
usd:   5   Cold: hi:   62, btch:  15 usd:  59
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    1: Hot: hi:  186, btch:  31
usd:  24   Cold: hi:   62, btch:  15 usd:   6
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    2: Hot: hi:  186, btch:  31
usd:  21   Cold: hi:   62, btch:  15 usd:  54
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    3: Hot: hi:  186, btch:  31
usd: 165   Cold: hi:   62, btch:  15 usd:   0
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    4: Hot: hi:  186, btch:  31
usd: 162   Cold: hi:   62, btch:  15 usd:  59
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    5: Hot: hi:  186, btch:  31
usd: 167   Cold: hi:   62, btch:  15 usd:   9
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    6: Hot: hi:  186, btch:  31
usd:  69   Cold: hi:   62, btch:  15 usd:  47
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    7: Hot: hi:  186, btch:  31
usd:  17   Cold: hi:   62, btch:  15 usd:   3
Sep 13 03:06:24 ms249-lin-005 kernel: HighMem per-cpu:
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    0: Hot: hi:  186, btch:  31
usd: 169   Cold: hi:   62, btch:  15 usd:  10
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    1: Hot: hi:  186, btch:  31
usd: 171   Cold: hi:   62, btch:  15 usd:   7
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    2: Hot: hi:  186, btch:  31
usd: 180   Cold: hi:   62, btch:  15 usd:  14
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    3: Hot: hi:  186, btch:  31
usd: 175   Cold: hi:   62, btch:  15 usd:  14
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    4: Hot: hi:  186, btch:  31
usd: 177   Cold: hi:   62, btch:  15 usd:   1
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    5: Hot: hi:  186, btch:  31
usd: 158   Cold: hi:   62, btch:  15 usd:   3
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    6: Hot: hi:  186, btch:  31
usd:   8   Cold: hi:   62, btch:  15 usd:  14
Sep 13 03:06:24 ms249-lin-005 kernel: CPU    7: Hot: hi:  186, btch:  31
usd: 166   Cold: hi:   62, btch:  15 usd:   8
Sep 13 03:06:24 ms249-lin-005 kernel: Active:1367945 inactive:43116
dirty:134 writeback:0 unstable:0
Sep 13 03:06:24 ms249-lin-005 kernel:  free:528025 slab:28509 mapped:8346
pagetables:448 bounce:0
Sep 13 03:06:24 ms249-lin-005 kernel: DMA free:3492kB min:68kB low:84kB
high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0
all_unreclaimable? yes
Sep 13 03:06:24 ms249-lin-005 kernel: lowmem_reserve[]: 0 873 8874
Sep 13 03:06:24 ms249-lin-005 kernel: Normal free:13244kB min:3744kB
low:4680kB high:5616kB active:116592kB inactive:170648kB present:894080kB
pages_scanned:14 all_unreclaimable? no
Sep 13 03:06:24 ms249-lin-005 kernel: lowmem_reserve[]: 0 0 64008
Sep 13 03:06:24 ms249-lin-005 kernel: HighMem free:2095496kB min:512kB
low:9096kB high:17684kB active:5355004kB inactive:1816kB present:8193024kB
pages_scanned:0 all_unreclaimable? no
Sep 13 03:06:24 ms249-lin-005 kernel: lowmem_reserve[]: 0 0 0
Sep 13 03:06:24 ms249-lin-005 kernel: DMA: 33*4kB 0*8kB 0*16kB 1*32kB 0*64kB
0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3492kB
Sep 13 03:06:24 ms249-lin-005 kernel: Normal: 3090*4kB 23*8kB 4*16kB 1*32kB
1*64kB 2*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 13472kB
Sep 13 03:06:24 ms249-lin-005 kernel: HighMem: 2211*4kB 1401*8kB 1166*16kB
1065*32kB 335*64kB 95*128kB 38*256kB 7*512kB 5*1024kB 3*2048kB 480*4096kB =
2097044kB
Sep 13 03:06:24 ms249-lin-005 kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Sep 13 03:06:24 ms249-lin-005 kernel: Free swap  = 19535000kB
Sep 13 03:06:24 ms249-lin-005 kernel: Total swap = 19535000kB
Sep 13 03:06:24 ms249-lin-005 kernel: Free swap:       19535000kB
Sep 13 03:06:24 ms249-lin-005 kernel: 2293760 pages of RAM
Sep 13 03:06:24 ms249-lin-005 kernel: 2064384 pages of HIGHMEM
Sep 13 03:06:24 ms249-lin-005 kernel: 215691 reserved pages
Sep 13 03:06:24 ms249-lin-005 kernel: 109843 pages shared
Sep 13 03:06:24 ms249-lin-005 kernel: 0 pages swap cached
Sep 13 03:06:24 ms249-lin-005 kernel: 134 pages dirty
Sep 13 03:06:24 ms249-lin-005 kernel: 0 pages writeback
Sep 13 03:06:24 ms249-lin-005 kernel: 8346 pages mapped
Sep 13 03:06:24 ms249-lin-005 kernel: 28377 pages slab
Sep 13 03:06:24 ms249-lin-005 kernel: 448 pages pagetables

 
 
 
LSMOD output.
Module                  Size  Used by
nfs                   223180  0 
nfsd                  203568  17 
exportfs                6240  1 nfsd
lockd                  59016  3 nfs,nfsd
nfs_acl                 4288  2 nfs,nfsd
sunrpc                155740  13 nfs,nfsd,lockd,nfs_acl
button                  8720  0 
ipmi_poweroff          10156  0 
ipmi_devintf            9704  2 
ipmi_si                39532  2 
ipmi_msghandler        35224  3 ipmi_poweroff,ipmi_devintf,ipmi_si
dm_snapshot            17188  0 
dm_mirror              20884  0 
dm_mod                 53324  2 dm_snapshot,dm_mirror
loop                   16648  0 
sg                     33244  0 
sr_mod                 16868  0 
st                     35964  0 
psmouse                35720  0 
serio_raw               7332  0 
pcspkr                  3904  0 
floppy                 55620  0 
rtc                    13528  0 
shpchp                 31828  0 
pci_hotplug            29856  1 shpchp
tsdev                   8288  0 
joydev                  9920  0 
evdev                   9984  0 
ext3                  121672  10 
jbd                    55976  1 ext3
mbcache                 8932  1 ext3
usb_storage            77216  0 
ide_cd                 37280  0 
cdrom                  33536  2 sr_mod,ide_cd
ata_generic             8868  0 
libata                110164  1 ata_generic
usbhid                 24320  0 
hid                    24448  1 usbhid
sd_mod                 20672  14 
piix                   10276  0 [permanent]
aic79xx               251160  0 
ehci_hcd               31820  0 
generic                 5572  0 [permanent]
megaraid_sas           28528  13 
scsi_transport_spi     23584  1 aic79xx
ide_core              116040  4 usb_storage,ide_cd,piix,generic
uhci_hcd               23472  0 
bnx2                  143444  0 
usbcore               124360  5 usb_storage,usbhid,ehci_hcd,uhci_hcd
scsi_mod              134508  9
sg,sr_mod,st,usb_storage,libata,sd_mod,aic79xx,megaraid_sas,scsi_transport_s
pi
thermal                14888  0 
processor              31944  1 thermal
fan                     5636  0 


