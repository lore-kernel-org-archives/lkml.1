Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXAZLb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXAZLb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbXAZLb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:31:27 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:47115 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933200AbXAZLb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:31:26 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: LKML <linux-kernel@vger.kernel.org>
Subject: ipw2200 problem with 2.6.20-rc6
Date: Fri, 26 Jan 2007 13:31:21 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261331.22054.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently saw this in dmesg after the wireless network suddenly stopped 
working and after some time it worked again:

ipw2200/0: page allocation failure. order:0, mode:0x20
 [<c0140996>] __alloc_pages+0x27b/0x28c
 [<c015397a>] cache_alloc_refill+0x292/0x46f
 [<c0153b9c>] __kmalloc+0x45/0x51
 [<c02d47c5>] __alloc_skb+0x47/0x102
 [<e05c5153>] ipw_rx_queue_replenish+0x52/0xf0 [ipw2200]
 [<c032c69b>] __sched_text_start+0x4c3/0x560
 [<e05c520f>] ipw_bg_rx_queue_replenish+0x1e/0x27 [ipw2200]
 [<c01226b0>] run_workqueue+0x8f/0x14b
 [<e05c51f1>] ipw_bg_rx_queue_replenish+0x0/0x27 [ipw2200]
 [<c0122c6d>] worker_thread+0x108/0x132
 [<c0111efa>] default_wake_function+0x0/0xc
 [<c0122b65>] worker_thread+0x0/0x132
 [<c0125198>] kthread+0xa0/0xc8
 [<c01250f8>] kthread+0x0/0xc8
 [<c0103003>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   
0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  
56
Active:96632 inactive:5235 dirty:3532 writeback:4 unstable:0 free:730 
slab:7772 mapped:23842 pagetables:958
DMA free:1968kB min:88kB low:108kB high:132kB active:10068kB inactive:0kB 
present:16256kB pages_scanned:247 all_unreclaimable? no
lowmem_reserve[]: 0 483 483
Normal free:952kB min:2764kB low:3452kB high:4144kB active:376460kB 
inactive:20940kB present:494668kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 0*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 
0*2048kB 0*4096kB = 1968kB
Normal: 0*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 
0*2048kB 0*4096kB = 952kB
Swap cache: add 57, delete 57, find 0/0, race 0+0
Free swap  = 614164kB
Total swap = 614392kB
Free swap:       614164kB
128736 pages of RAM
0 pages of HIGHMEM
2010 reserved pages
127625 pages shared
0 pages swap cached
3532 pages dirty
4 pages writeback
23842 pages mapped
7772 pages slab
958 pages pagetables
eth2: Can not allocate SKB buffers.

Regards,
ismail
