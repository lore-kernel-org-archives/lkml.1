Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYAWWl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYAWWl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYAWWk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:40:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:36030 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752355AbYAWWk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:40:58 -0500
X-Authenticated: #759291
X-Provags-ID: V01U2FsdGVkX1+4HOAat8a4rDJcemlU7IUIk9GTSKhKq9rbujr+Go
	9JYNRN+VrvdJFD
From: Matthias Wolle <Matthias.Wolle@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LowFree/LowMem problem
Date: Wed, 23 Jan 2008 23:40:54 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200801210632.42497.Matthias.Wolle@gmx.de> <20080123140639.828566dd.akpm@linux-foundation.org>
In-Reply-To: <20080123140639.828566dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801232340.54258.Matthias.Wolle@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008 23:06 Andrew Morton wrote:
> Can you please send the full dmesg output from one such oom-killing event?

Jan 17 23:31:58 franklin72 kernel: sshd invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Jan 17 23:31:58 franklin72 kernel: cat invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Jan 17 23:31:58 franklin72 kernel:  [<c014af39>] out_of_memory+0x69/0x1a4
Jan 17 23:31:58 franklin72 kernel:  [<c014c588>] __alloc_pages+0x20a/0x291
Jan 17 23:31:58 franklin72 kernel:  [<c0153618>] __pte_alloc+0x11/0x94
Jan 17 23:31:58 franklin72 kernel:  [<c015439e>] handle_mm_fault+0xa7/0x7bd
Jan 17 23:31:58 franklin72 kernel:  [<c0119aa2>] do_page_fault+0x0/0x751
Jan 17 23:31:58 franklin72 kernel:  [<c0119d56>] do_page_fault+0x2b4/0x751
Jan 17 23:31:58 franklin72 kernel:  [<c0157442>] mmap_region+0x32f/0x3eb
Jan 17 23:31:58 franklin72 kernel:  [<c0119aa2>] do_page_fault+0x0/0x751
Jan 17 23:31:58 franklin72 kernel:  [<c02e03d2>] error_code+0x72/0x78
Jan 17 23:31:58 franklin72 kernel:  [<c01e3091>] clear_user+0x27/0x32
Jan 17 23:31:58 franklin72 kernel:  [<c0188691>] padzero+0x16/0x24
Jan 17 23:31:58 franklin72 kernel:  [<c0189082>] load_elf_binary+0x7d4/0x142b
Jan 17 23:31:58 franklin72 kernel:  [<c0154d07>] get_user_pages+0x253/0x2be
Jan 17 23:31:58 franklin72 kernel:  [<c015190e>] page_address+0x78/0x98
Jan 17 23:31:58 franklin72 kernel:  [<c0151a66>] kmap_high+0x1a/0x171
Jan 17 23:31:58 franklin72 kernel:  [<c015190e>] page_address+0x78/0x98
Jan 17 23:31:58 franklin72 kernel:  [<c016656e>] copy_strings+0x169/0x173
Jan 17 23:31:58 franklin72 kernel:  [<c0166623>] search_binary_handler+0x84/0x19c
Jan 17 23:31:58 franklin72 kernel:  [<c0167905>] do_execve+0x13b/0x1a4
Jan 17 23:31:58 franklin72 kernel:  [<c01026b8>] sys_execve+0x2f/0x7b
Jan 17 23:31:58 franklin72 kernel:  [<c0103d0e>] sysenter_past_esp+0x5f/0x85
Jan 17 23:31:58 franklin72 kernel:  [<c02e0000>] __down_interruptible+0xba/0x10c
Jan 17 23:31:58 franklin72 kernel:  =======================
Jan 17 23:31:58 franklin72 kernel: Mem-info:
Jan 17 23:31:58 franklin72 kernel: DMA per-cpu:
Jan 17 23:31:58 franklin72 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Jan 17 23:31:58 franklin72 kernel: Normal per-cpu:
Jan 17 23:31:58 franklin72 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  49
Jan 17 23:31:58 franklin72 kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  53
Jan 17 23:31:58 franklin72 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:   4
Jan 17 23:31:58 franklin72 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 174   Cold: hi:   62, btch:  15 usd:  10
Jan 17 23:31:58 franklin72 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:   9
Jan 17 23:31:58 franklin72 kernel: CPU    5: Hot: hi:  186, btch:  31 usd: 161   Cold: hi:   62, btch:  15 usd:   7
Jan 17 23:31:58 franklin72 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  12
Jan 17 23:31:58 franklin72 kernel: CPU    7: Hot: hi:  186, btch:  31 usd: 178   Cold: hi:   62, btch:  15 usd:   3
Jan 17 23:31:58 franklin72 kernel: HighMem per-cpu:
Jan 17 23:31:58 franklin72 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  41   Cold: hi:   62, btch:  15 usd:   8
Jan 17 23:31:58 franklin72 kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 182   Cold: hi:   62, btch:  15 usd:  10
Jan 17 23:31:58 franklin72 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:   7
Jan 17 23:31:58 franklin72 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:   4
Jan 17 23:31:58 franklin72 kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  19   Cold: hi:   62, btch:  15 usd:   1
Jan 17 23:31:58 franklin72 kernel: CPU    5: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:  13
Jan 17 23:31:58 franklin72 kernel: CPU    6: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:   0
Jan 17 23:31:58 franklin72 kernel: CPU    7: Hot: hi:  186, btch:  31 usd: 182   Cold: hi:   62, btch:  15 usd:   3
Jan 17 23:31:58 franklin72 kernel: Active:490332 inactive:764 dirty:0 writeback:0 unstable:0
Jan 17 23:31:58 franklin72 kernel:  free:3472003 slab:2279 mapped:858 pagetables:1152 bounce:0
Jan 17 23:31:58 franklin72 kernel: DMA free:3560kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:21 all_unreclaimable? yes
Jan 17 23:31:58 franklin72 kernel: lowmem_reserve[]: 0 873 17002 17002
Jan 17 23:31:58 franklin72 kernel: Normal free:3688kB min:3744kB low:4680kB high:5616kB active:92kB inactive:0kB present:894080kB pages_scanned:224 all_unreclaimable? yes
Jan 17 23:31:58 franklin72 kernel: lowmem_reserve[]: 0 0 129032 129032
Jan 17 23:31:58 franklin72 kernel: HighMem free:13880764kB min:512kB low:17820kB high:35128kB active:1961232kB inactive:3064kB present:16516096kB pages_scanned:0 all_unreclaimable? no
Jan 17 23:31:58 franklin72 kernel: lowmem_reserve[]: 0 0 0 0
Jan 17 23:31:58 franklin72 kernel: DMA: 2*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3560kB
Jan 17 23:31:58 franklin72 kernel: Normal: 1*4kB 6*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 4100kB
Jan 17 23:31:58 franklin72 kernel: HighMem: 641*4kB 375*8kB 197*16kB 77*32kB 68*64kB 55*128kB 36*256kB 23*512kB 23*1024kB 9*2048kB 3368*4096kB = 13880876kB
Jan 17 23:31:58 franklin72 kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Jan 17 23:31:58 franklin72 kernel: Free swap  = 15623204kB
Jan 17 23:31:58 franklin72 kernel: Total swap = 15623204kB
Jan 17 23:31:58 franklin72 kernel: Free swap:       15623204kB
Jan 17 23:31:58 franklin72 kernel: 4390911 pages of RAM
Jan 17 23:31:58 franklin72 kernel: 4161535 pages of HIGHMEM
Jan 17 23:31:58 franklin72 kernel: 232469 reserved pages
Jan 17 23:31:58 franklin72 kernel: 4302 pages shared
Jan 17 23:31:58 franklin72 kernel: 0 pages swap cached
Jan 17 23:31:58 franklin72 kernel: 0 pages dirty
Jan 17 23:31:58 franklin72 kernel: 0 pages writeback
Jan 17 23:31:58 franklin72 kernel: 858 pages mapped
Jan 17 23:31:58 franklin72 kernel: 2281 pages slab
Jan 17 23:31:58 franklin72 kernel: 1138 pages pagetables
Jan 17 23:31:58 franklin72 kernel: Out of memory: kill process 3177 (bash) score 15352 or a child
Jan 17 23:31:58 franklin72 kernel: Killed process 3286 (memtest)

At this time no program run  except some standard services (sshd, ntpd, syslogd ...) and the test script.

Kind regards
Matthias
