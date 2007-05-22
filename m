Return-Path: <linux-kernel-owner+w=401wt.eu-S934525AbXEVWjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525AbXEVWjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761411AbXEVWj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:39:28 -0400
Received: from waste.org ([66.93.16.53]:36692 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761287AbXEVWj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:39:27 -0400
Date: Tue, 22 May 2007 17:38:28 -0500
From: Matt Mackall <mpm@selenic.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: lguest broken in 2.6.22-rc1-mm1
Message-ID: <20070522223828.GV11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

$ lguest 1024m vmlinux --tunnet=192.168.19.1 --block=rootfs root=/dev/lgba
[    0.000000] Reserving virtual address space above 0xffc00000
[    0.000000] Linux version 2.6.22-rc1-mm1 (mpm@cinder) (gcc
version 4.1.3 20070429 (prerelease) (Debian 4.1.2-6)) #125 PREEMPT Tue
May 22 16:50:02 CDT 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  LGUEST: 0000000000000000 - 0000000040000000 (usable)
[    0.000000] 132MB HIGHMEM available.
[    0.000000] 892MB LOWMEM available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   228352
[    0.000000]   HighMem    228352 ->   262144
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262144
[    0.000000] DMI not present or invalid.
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:c0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 260096
[    0.000000] Kernel command line: root=/dev/lgba slub_debug
init=/sbin/init 
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c05c2000 soft=c05c1000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Console: colour dummy device 80x25
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.000000] ... MAX_LOCK_DEPTH:          30
[    0.000000] ... MAX_LOCKDEP_KEYS:        2048
[    0.000000] ... CLASSHASH_SIZE:           1024
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000000] ... CHAINHASH_SIZE:          8192
[    0.000000]  memory used by lock dependency info: 992 kB
[    0.000000]  per task-struct memory footprint: 1200 bytes
[    0.000000] Dentry cache hash table entries: 131072 (order: 7,
524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Memory: 1031316k/1048576k available (2838k kernel code,
17064k reserved, 1817k data, 188k init, 135168k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffbea000 - 0xffbff000   (  84 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7c00000   ( 892 MB)
[    0.000000]       .init : 0xc058d000 - 0xc05bc000   ( 188 kB)
[    0.000000]       .data : 0xc03c587f - 0xc058bdb0   (1817 kB)
[    0.000000]       .text : 0xc0100000 - 0xc03c587f   (2838 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[    0.104000] Mount-cache hash table entries: 512
[    0.112000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.112000] CPU: L2 cache: 2048K
[    0.112000] Compat vDSO mapped to ffbfe000.
[    0.112000] CPU: Intel(R) Pentium(R) M processor 1.70GHz stepping
06
[    0.120007] divide error: 0000 [#1]
[    0.120007] PREEMPT 
[    0.120007] Modules linked in:
[    0.120007] CPU:    0
[    0.120007] EIP:    0061:[<c01090f3>]    Not tainted VLI
[    0.120007] EFLAGS: 00010246   (2.6.22-rc1-mm1 #125)
[    0.120007] EIP is at resync_sc_freq+0x4b/0x56
[    0.120007] eax: 3d090000   ebx: c05529e0   ecx: 0000002a   edx:
00000000
[    0.120007] esi: 00000000   edi: c1c03f6c   ebp: c1c03f40   esp:
c1c03f38
[    0.120007] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0069
[    0.120007] Process swapper (pid: 1, ti=c1c03000 task=c1c214d0
task.ti=c1c03000)
[    0.120007] Stack: 00000000 00000000 c1c03f50 c01091a9 00000000
00000000 c1c03f70 c058fb56 
[    0.120007]        00000010 00000000 00000000 00000000 00000000
00000000 c1c03fe0 c058d6c4 
[    0.120007]        c1c214d0 c0103f24 00000000 c1c03fa4 c0132ab9
c1c03fac c01169ee 00000000 
[    0.120007] Call Trace:
[    0.120007]  [<c01091a9>] call_r_s_f+0x2b/0x2d
[    0.120007]  [<c058fb56>] init_sched_clock+0x43/0x77
[    0.120007]  [<c058d6c4>] kernel_init+0xbc/0x23e
[    0.120007]  [<c010420f>] kernel_thread_helper+0x7/0x10
[    0.120007]  ============

-- 
Mathematics is the supreme nostalgia of our time.

