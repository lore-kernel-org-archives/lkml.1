Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZD3Fgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZD3Fgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 01:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZD3Fgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 01:36:42 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40290 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZD3Fgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 01:36:41 -0400
Message-ID: <49F938E4.2030703@in.ibm.com>
Date: Thu, 30 Apr 2009 11:06:36 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com> <20090429113604.GE3398@wotan.suse.de> <49F87FAB.9050408@in.ibm.com> <20090430041146.GB23746@wotan.suse.de>
In-Reply-To: <20090430041146.GB23746@wotan.suse.de>
Content-Type: multipart/mixed;
 boundary="------------030203080606060008080305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030203080606060008080305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Nick Piggin wrote:
> Well kmalloc is failing. It should not be though, even if the
> current node is offline, it should be able to fall back to other
> nodes. Stephen's trace indicates the same thing.
>
> Could you try the following patch please, and capture the output
> it generates?
With this patch i don't get any extra information other that what is 
already reported.
Have attached the boot log captured using loglevel=8 mminit_loglevel=4 
options.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------030203080606060008080305
Content-Type: text/plain;
 name="slqb-trace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slqb-trace"

Using 007bb8f8 bytes for initrd buffer
Please wait, loading kernel...
Allocated 01100000 bytes for kernel @ 00d00000
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded 007bb8f8 @ 034d0000
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.30-rc3-next-20090429-slqb (root@llm62) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #4 SMP Thu Apr 30 10:52:00 IST 2009
Calling ibm,client-architecture... done
command line: root=/dev/sda5 sysrq=1 insmod=sym53c8xx insmod=ipr crashkernel=512M-:256M loglevel=8 mminit_loglevel=4 
memory layout at init:
  alloc_bottom : 0000000003c90000
  alloc_top    : 0000000008000000
  alloc_top_hi : 0000000008000000
  rmo_top      : 0000000008000000
  ram_top      : 0000000008000000
instantiating rtas at 0x00000000074e0000... done
boot cpu hw idx 0000000000000000
starting cpu hw idx 0000000000000002... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000003ca0000 -> 0x0000000003ca15d3
Device tree struct  0x0000000003cb0000 -> 0x0000000003cd0000
Calling quiesce...
returning from prom_init
Crash kernel location must be 0x2000000
Reserving 256MB of memory at 32MB for crashkernel (System RAM: 4096MB)
Phyp-dump disabled at boot time
Using pSeries machine description
Page orders: linear mapping = 16, virtual = 16, io = 12
Using 1TB segments
Found initrd at 0xc0000000034d0000:0xc000000003c8b8f8
console [udbg0] enabled
Partition configured for 4 cpus.
CPU maps initialized for 2 threads per core
 (thread shift is 1)
Starting Linux PPC64 #4 SMP Thu Apr 30 10:52:00 IST 2009
-----------------------------------------------------
ppc64_pft_size                = 0x1a
physicalMemorySize            = 0x100000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.30-rc3-next-20090429-slqb (root@llm62) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #4 SMP Thu Apr 30 10:52:00 IST 2009
[boot]0012 Setup Arch
mminit::memory_register Entering add_active_range(0, 0x0, 0x800) 0 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x800, 0xc00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xc00, 0x1000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x1000, 0x1400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x1400, 0x1800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x1800, 0x1c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x1c00, 0x2000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x2000, 0x2400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x2400, 0x2800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x2800, 0x2c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x2c00, 0x3000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x3000, 0x3400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x3400, 0x3800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x3800, 0x3c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x3c00, 0x4000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x4000, 0x4400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x4400, 0x4800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x4800, 0x4c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x4c00, 0x5000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x5000, 0x5400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x5400, 0x5800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x5800, 0x5c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x5c00, 0x6000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x6000, 0x6400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x6400, 0x6800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x6800, 0x6c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x6c00, 0x7000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x7000, 0x7400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x7400, 0x7800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x7800, 0x7c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x7c00, 0x8000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x8000, 0x8400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x8400, 0x8800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x8800, 0x8c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x8c00, 0x9000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x9000, 0x9400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x9400, 0x9800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x9800, 0x9c00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0x9c00, 0xa000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xa000, 0xa400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xa400, 0xa800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xa800, 0xac00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xac00, 0xb000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xb000, 0xb400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xb400, 0xb800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xb800, 0xbc00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xbc00, 0xc000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xc000, 0xc400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xc400, 0xc800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xc800, 0xcc00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xcc00, 0xd000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xd000, 0xd400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xd400, 0xd800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xd800, 0xdc00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xdc00, 0xe000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xe000, 0xe400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xe400, 0xe800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xe800, 0xec00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xec00, 0xf000) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xf000, 0xf400) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xf400, 0xf800) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xf800, 0xfc00) 1 entries of 256 used
mminit::memory_register Entering add_active_range(0, 0xfc00, 0x10000) 1 entries of 256 used
Node 0 Memory: 0x0-0x100000000
EEH: No capable adapters found
PPC64 nvram contains 15360 bytes
Using shared processor idle loop
Zone PFN ranges:
  DMA      0x00000000 -> 0x00010000
  Normal   0x00010000 -> 0x00010000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00010000
mminit::pageflags_layout_widths Section 20 Node 4 Zone 2 Flags 23
mminit::pageflags_layout_shifts Section 20 Node 4 Zone 2
mminit::pageflags_layout_offsets Section 44 Node 40 Zone 38
mminit::pageflags_layout_zoneid Zone ID: 38 -> 44
mminit::pageflags_layout_usage location: 64 -> 38 unused 38 -> 23 flags 23 -> 0
On node 0 totalpages: 65536
  DMA zone: 64 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 65472 pages, LIFO batch:1
mminit::memmap_init Initialising map node 0 zone 0 pfns 0 -> 65536
[boot]0015 Setup Done
mminit::zonelist general 0:DMA = 0:DMA 
mminit::zonelist thisnode 0:DMA = 0:DMA 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 65472
Policy zone: DMA
Kernel command line: root=/dev/sda5 sysrq=1 insmod=sym53c8xx insmod=ipr crashkernel=512M-:256M loglevel=8 mminit_loglevel=4 
Experimental hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
Experimental hierarchical RCU init done.
NR_IRQS:512
[boot]0020 XICS Init
[boot]0021 XICS Done
pic: no ISA interrupt controller
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 512.000000 MHz
time_init: processor frequency   = 4704.000000 MHz
clocksource: timebase mult[7d0000] shift[22] registered
clockevent: decrementer mult[8312] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
allocated 2621440 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
freeing bootmem node 0
Memory: 3882688k/4194304k available (8320k kernel code, 311616k reserved, 2048k data, 4285k bss, 448k init)
Calibrating delay loop... 1022.36 BogoMIPS (lpj=5111808)
Unable to handle kernel paging request for data at address 0x00000010
Faulting instruction address: 0xc0000000007d03ec
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 DEBUG_PAGEALLOC NUMA pSeries
Modules linked in:
NIP: c0000000007d03ec LR: c0000000007b0bbc CTR: 0000000000136f8c
REGS: c000000000a23bd0 TRAP: 0300   Not tainted  (2.6.30-rc3-next-20090429-slqb)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28000084  XER: 00000010
DAR: 0000000000000010, DSISR: 0000000040000000
TASK = c000000000955fc0[0] 'swapper' THREAD: c000000000a20000 CPU: 0
GPR00: 0000000000000001 c000000000a23e50 c000000000a17690 000000000000001f 
GPR04: 0000000000000000 ffffffffffffffff 0000000000783db6 800000000c9b2cc0 
GPR08: 0000000000000000 0000000000000010 0000000000000000 c00000000095b0f8 
GPR12: 0000000028000082 c000000000af2400 c0000000007f3200 c000000000705c32 
GPR16: 00000000014f3138 0000000000000000 c0000000007f3138 0000000002f1fc90 
GPR20: c0000000007f3150 c000000000725e2f 00000000007bb8f8 0000000002f1fc90 
GPR24: 0000000002f1fc90 c0000000007f31f0 0000000000d00000 c000000000b73b10 
GPR28: c0000000007f0440 c00000000095db00 c00000000098d5f0 0000000003c90000 
NIP [c0000000007d03ec] .pidmap_init+0x28/0x88
LR [c0000000007b0bbc] .start_kernel+0x458/0x51c
Call Trace:
[c000000000a23e50] [c000000000a23ee0] init_thread_union+0x3ee0/0x4000 (unreliable)
[c000000000a23ee0] [c0000000007b0bbc] .start_kernel+0x458/0x51c
[c000000000a23f90] [c0000000000083d8] .start_here_common+0x1c/0x44
Instruction dump:
ebc1fff0 4e800020 fbc1fff0 ebc2b1a8 39200010 7c0802a6 fba1ffe8 f8010010 
38000001 ebbe8008 f821ff71 f93d0010 <7d6048a8> 7d6b0378 7d6049ad 40c2fff4 
---[ end trace 31fd0ba7d8756001 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Call Trace:
[c000000000a23820] [c000000000011700] .show_stack+0x6c/0x16c (unreliable)
[c000000000a238d0] [c00000000056228c] .panic+0x80/0x1a8
[c000000000a23960] [c00000000008dfa4] .do_exit+0x98/0x73c
[c000000000a23a40] [c0000000000293f4] .die+0x280/0x284
[c000000000a23ae0] [c000000000032700] .bad_page_fault+0xb8/0xd4
[c000000000a23b60] [c000000000005798] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .pidmap_init+0x28/0x88
    LR = .start_kernel+0x458/0x51c
[c000000000a23e50] [c000000000a23ee0] init_thread_union+0x3ee0/0x4000 (unreliable)
[c000000000a23ee0] [c0000000007b0bbc] .start_kernel+0x458/0x51c
[c000000000a23f90] [c0000000000083d8] .start_here_common+0x1c/0x44
Rebooting in 180 seconds..


--------------030203080606060008080305--
