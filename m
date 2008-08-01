Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYHASQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYHASQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYHASQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:16:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYHASP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:15:59 -0400
Date: Fri, 1 Aug 2008 14:15:32 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: Only three cores found on quad-core machine.
Message-ID: <20080801181532.GC6304@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just installed .27rc1 on a fairly recent quad-core machine.
The first thing that seemed out of the ordinary was only 3 penguins
showing up in the framebuffer.  Closer examination after it had
booted revealed the backtrace-o-rama that is below.

	Dave

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27-0.205.rc1.git2.fc10.x86_64 (mockbuild@x86-5) (gcc version 4.3.1 20080728 (Red Hat 4.3.1-5) (GCC) ) #1 SMP Thu Jul 31 16:00:33 EDT 2008
Command line: ro root=UUID=25f6cef8-c140-4900-b663-651ec0232b6a vga=791
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ee48000 (usable)
 BIOS-e820: 000000007ee48000 - 000000007eeb2000 (ACPI NVS)
 BIOS-e820: 000000007eeb2000 - 000000007fd86000 (usable)
 BIOS-e820: 000000007fd86000 - 000000007fd8e000 (reserved)
 BIOS-e820: 000000007fd8e000 - 000000007fe2c000 (usable)
 BIOS-e820: 000000007fe2c000 - 000000007fe30000 (reserved)
 BIOS-e820: 000000007fe30000 - 000000007feab000 (usable)
 BIOS-e820: 000000007feab000 - 000000007feae000 (ACPI data)
 BIOS-e820: 000000007feae000 - 000000007fef2000 (ACPI NVS)
 BIOS-e820: 000000007fef2000 - 000000007feff000 (ACPI data)
 BIOS-e820: 000000007feff000 - 000000007ff00000 (usable)
 BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
last_pfn = 0x7ff00 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007ff00000 page 4k
kernel direct mapping tables up to 7ff00000 @ 8000-c000
last_map_addr: 7ff00000 end: 7ff00000
RAMDISK: 37cba000 - 37fef7fb
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 7FEFD038, 004C (r1 INTEL  D975XBX2      95B       1000013)
ACPI: FACP 7FEFC000, 0074 (r1 INTEL  D975XBX2      95B MSFT  1000013)
ACPI: DSDT 7FEF8000, 3E66 (r1 INTEL  D975XBX2      95B MSFT  1000013)
ACPI: FACS 7FEAE000, 0040
ACPI: APIC 7FEF7000, 0078 (r1 INTEL  D975XBX2      95B MSFT  1000013)
ACPI: WDDT 7FEF6000, 0040 (r1 INTEL  D975XBX2      95B MSFT  1000013)
ACPI: MCFG 7FEF5000, 003C (r1 INTEL  D975XBX2      95B MSFT  1000013)
ACPI: ASF! 7FEF4000, 00A6 (r32 INTEL  D975XBX2      95B MSFT  1000013)
ACPI: SSDT 7FEF3000, 01BC (r1 INTEL     CpuPm      95B MSFT  1000013)
ACPI: SSDT 7FEF2000, 01B7 (r1 INTEL   Cpu0Ist      95B MSFT  1000013)
ACPI: SSDT 7FEAD000, 01B7 (r1 INTEL   Cpu1Ist      95B MSFT  1000013)
ACPI: SSDT 7FEAC000, 01B7 (r1 INTEL   Cpu2Ist      95B MSFT  1000013)
ACPI: SSDT 7FEAB000, 01B7 (r1 INTEL   Cpu3Ist      95B MSFT  1000013)
No NUMA configuration found
Faking a node at 0000000000000000-000000007ff00000
Bootmem setup node 0 0000000000000000-000000007ff00000
  NODE_DATA [000000000000a000 - 000000000001efff]
  bootmap [000000000001f000 -  000000000002efdf] pages 10
(6 early reservations) ==> bootmem [0000000000 - 007ff00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000ed8688]    TEXT DATA BSS ==> [0000200000 - 0000ed8688]
  #3 [0037cba000 - 0037fef7fb]          RAMDISK ==> [0037cba000 - 0037fef7fb]
  #4 [0000098c00 - 0000100000]    BIOS reserved ==> [0000098c00 - 0000100000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000fe200] 000fe200
 [ffffe20000000000-ffffe20002ffffff] PMD -> [ffff880001200000-ffff8800041fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000000 -> 0x0000008f
    0: 0x00000100 -> 0x0007ee48
    0: 0x0007eeb2 -> 0x0007fd86
    0: 0x0007fd8e -> 0x0007fe2c
    0: 0x0007fe30 -> 0x0007feab
    0: 0x0007feff -> 0x0007ff00
On node 0 totalpages: 523717
  DMA zone: 489 pages, LIFO batch:0
  DMA32 zone: 507548 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000008f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000007ee48000 - 000000007eeb2000
PM: Registered nosave memory: 000000007fd86000 - 000000007fd8e000
PM: Registered nosave memory: 000000007fe2c000 - 000000007fe30000
PM: Registered nosave memory: 000000007feab000 - 000000007feae000
PM: Registered nosave memory: 000000007feae000 - 000000007fef2000
PM: Registered nosave memory: 000000007fef2000 - 000000007feff000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ff00000)
PERCPU: Allocating 450624 bytes of per cpu data
NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 508037
Policy zone: DMA32
Kernel command line: ro root=UUID=25f6cef8-c140-4900-b663-651ec0232b6a vga=791
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Detected 2666.761 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1840 kB
 per task-struct memory footprint: 3456 bytes
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2027164k/2096128k available (3151k kernel code, 67704k reserved, 1811k data, 1596k init)
CPA: page pool initialized 32 of 32 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. <6>5333.52 BogoMIPS (lpj=2666761)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
Using local APIC timer interrupts.
APIC timer calibration result 16667241
Detected 16.667 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. <6>5333.52 BogoMIPS (lpj=2666761)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
lockdep: fixing up alternatives.
Booting processor 2/1 ip 6000
Initializing CPU#2
Stuck ??
Inquiring remote APIC #1...
... APIC #1 ID: failed
... APIC #1 VERSION: failed
... APIC #1 SPIV: failed
migration/2 used greatest stack depth: 7224 bytes left
lockdep: fixing up alternatives.
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. <6>5333.57 BogoMIPS (lpj=2666785)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 3 CPUs
Total of 3 processors activated (16000.61 BogoMIPS).
sizeof(vma)=176 bytes
sizeof(page)=96 bytes
sizeof(inode)=1088 bytes
sizeof(dentry)=256 bytes
sizeof(ext3inode)=1488 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=9544 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1,3 level CPU
  groups: 0 1,3
  domain 1: span 0-1,3 level NODE
   groups: 0-1,3
CPU1 attaching sched-domain:
 domain 0: span 1,3 level MC
  groups: 1 3
  domain 1: span 0-1,3 level CPU
   groups: 1,3 0
   domain 2: span 0-1,3 level NODE
    groups: 0-1,3
CPU3 attaching sched-domain:
 domain 0: span 1,3 level MC
  groups: 3 1
  domain 1: span 0-1,3 level CPU
   groups: 1,3 0
   domain 2: span 0-1,3 level NODE
    groups: 0-1,3
khelper used greatest stack depth: 5728 bytes left
net_namespace: 1680 bytes
Booting paravirtualized kernel on bare hardware
Time: 13:32:13  Date: 07/31/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
khelper used greatest stack depth: 5016 bytes left
general protection fault: 0000 [1] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff81094d61>]  [<ffffffff81094d61>] ftrace_record_ip+0x214/0x22b
RSP: 0018:ffff88007f04fe08  EFLAGS: 00010292
RAX: ffffffff816b26c0 RBX: 000000000000010d RCX: 000000000000020f
RDX: ffff880001027f80 RSI: 0000000000000000 RDI: 0000000000000292
RBP: ffff88007f04fe38 R08: 0000000000000075 R09: ffff88007fbd2090
R10: 0000000000000046 R11: ffffffff81b68de8 R12: 00000040812fba2b
R13: 000a81a000000002 R14: ffffffff81b68de8 R15: 0000000000000292
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffff88007f04fe78 0000002649d25248 00000040fffb6cbf 000a81a000000002
 000000000051621c 0000000000000002 ffff88007f04fe98 ffffffff81010164
 00000000fffb8093 0000000049d25248 ffff88007f050000 000000231a06706a
Call Trace:
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e


Code: 48 89 70 08 c7 05 4c 58 ad 00 01 00 00 00 4c 89 fe 48 c7 c7 70 d5 48 81 e8 4c 78 27 00 48 8b 15 6e 29 46 00 48 c7 c0 c0 26 6b 81 <4a> 8b 14 ea 48 03 42 08 ff 08 41 5b 5b 41 5c 41 5d 41 5e 41 5f 
RIP  [<ffffffff81094d61>] ftrace_record_ip+0x214/0x22b
 RSP <ffff88007f04fe08>
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [2] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D   2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04f9f8  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405781 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04fa28 R08: 0000000000000002 R09: ffffffff8130c5e4
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000296
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405781 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04fb08 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000002726 0000000000000001
Call Trace:
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010000>] ? sys_rt_sigreturn+0x2a0/0x3d0
 [<ffffffff811c8716>] ? get_random_bytes+0x20/0x22
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8101277e>] die+0x62/0x6b
 [<ffffffff8130df44>] do_general_protection+0x123/0x12c
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff81094d53>] ? ftrace_record_ip+0x206/0x22b
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04f9f8>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D  )
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D   2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:
 [<ffffffff81043bc8>] warn_on_slowpath+0x65/0x98
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c0dd>] smp_call_function_mask+0x47/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81168385>] ? sprintf+0x68/0x6a
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff8116807b>] ? vsnprintf+0x31b/0x5bd
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8107018d>] ? get_symbol_pos+0x9/0xe4
 [<ffffffff810707b6>] ? kallsyms_lookup+0x5e/0x125
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010000>] ? sys_rt_sigreturn+0x2a0/0x3d0
 [<ffffffff811c8716>] ? get_random_bytes+0x20/0x22
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8101277e>] die+0x62/0x6b
 [<ffffffff8130df44>] do_general_protection+0x123/0x12c
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff81094d53>] ? ftrace_record_ip+0x206/0x22b
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [3] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04f2c8  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405781 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04f2f8 R08: 0000000000000002 R09: ffffffff8130c5e4
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000096
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405781 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04f3d8 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000b9b8 0000000000000001
Call Trace:
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81168385>] ? sprintf+0x68/0x6a
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff8116807b>] ? vsnprintf+0x31b/0x5bd
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8107018d>] ? get_symbol_pos+0x9/0xe4
 [<ffffffff810707b6>] ? kallsyms_lookup+0x5e/0x125
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010000>] ? sys_rt_sigreturn+0x2a0/0x3d0
 [<ffffffff811c8716>] ? get_random_bytes+0x20/0x22
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8101277e>] die+0x62/0x6b
 [<ffffffff8130df44>] do_general_protection+0x123/0x12c
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff81094d53>] ? ftrace_record_ip+0x206/0x22b
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04f2c8>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:
 [<ffffffff81043bc8>] warn_on_slowpath+0x65/0x98
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c0dd>] smp_call_function_mask+0x47/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81309b5a>] ? printk+0x6c/0x72
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810437e4>] ? init_oops_id+0x9/0x28
 [<ffffffff81043826>] ? print_oops_end_marker+0x23/0x25
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81168385>] ? sprintf+0x68/0x6a
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff8116807b>] ? vsnprintf+0x31b/0x5bd
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8107018d>] ? get_symbol_pos+0x9/0xe4
 [<ffffffff810707b6>] ? kallsyms_lookup+0x5e/0x125
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010000>] ? sys_rt_sigreturn+0x2a0/0x3d0
 [<ffffffff811c8716>] ? get_random_bytes+0x20/0x22
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8101277e>] die+0x62/0x6b
 [<ffffffff8130df44>] do_general_protection+0x123/0x12c
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff81094d53>] ? ftrace_record_ip+0x206/0x22b
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [4] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04eb98  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405781 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04ebc8 R08: 0000000000000002 R09: ffffffff8130c5e4
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000096
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405781 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04eca8 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000c2c1 0000000000000001
Call Trace:
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81309b5a>] ? printk+0x6c/0x72
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810437e4>] ? init_oops_id+0x9/0x28
 [<ffffffff81043826>] ? print_oops_end_marker+0x23/0x25
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81168385>] ? sprintf+0x68/0x6a
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff8116807b>] ? vsnprintf+0x31b/0x5bd
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8107018d>] ? get_symbol_pos+0x9/0xe4
 [<ffffffff810707b6>] ? kallsyms_lookup+0x5e/0x125
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010000>] ? sys_rt_sigreturn+0x2a0/0x3d0
 [<ffffffff811c8716>] ? get_random_bytes+0x20/0x22
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8101277e>] die+0x62/0x6b
 [<ffffffff8130df44>] do_general_protection+0x123/0x12c
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff81094d53>] ? ftrace_record_ip+0x206/0x22b
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04eb98>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:
 [<ffffffff81043bc8>] warn_on_slowpath+0x65/0x98
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c0dd>] smp_call_function_mask+0x47/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81309b5a>] ? printk+0x6c/0x72
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810437e4>] ? init_oops_id+0x9/0x28
 [<ffffffff81043826>] ? print_oops_end_marker+0x23/0x25
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81309b5a>] ? printk+0x6c/0x72
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810437e4>] ? init_oops_id+0x9/0x28
 [<ffffffff81043826>] ? print_oops_end_marker+0x23/0x25
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81168385>] ? sprintf+0x68/0x6a
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff8116807b>] ? vsnprintf+0x31b/0x5bd
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8107018d>] ? get_symbol_pos+0x9/0xe4
 [<ffffffff810707b6>] ? kallsyms_lookup+0x5e/0x125
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010000>] ? sys_rt_sigreturn+0x2a0/0x3d0
 [<ffffffff811c8716>] ? get_random_bytes+0x20/0x22
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8101277e>] die+0x62/0x6b
 [<ffffffff8130df44>] do_general_protection+0x123/0x12c
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff81094d53>] ? ftrace_record_ip+0x206/0x22b
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [5] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04e468  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405781 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04e498 R08: 0000000000000002 R09: ffffffff8130c5e4
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000096
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405781 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04e578 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000002322 0000000000000001
Call Trace:
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81309b5a>] ? printk+0x6c/0x72
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810437e4>] ? init_oops_id+0x9/0x28
 [<ffffffff81043826>] ? print_oops_end_marker+0x23/0x25
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81309b5a>] ? printk+0x6c/0x72
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810437e4>] ? init_oops_id+0x9/0x28
 [<ffffffff81043826>] ? print_oops_end_marker+0x23/0x25
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81168385>] ? sprintf+0x68/0x6a
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff8130615b>] ? start_secondary+0xc0/0x16e
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81070907>] ? sprint_symbol+0x8a/0x96
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff8116807b>] ? vsnprintf+0x31b/0x5bd
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8107018d>] ? get_symbol_pos+0x9/0xe4
 [<ffffffff810707b6>] ? kallsyms_lookup+0x5e/0x125
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8106c157>] ? smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81064b1b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810c8d7e>] ? kmem_cache_alloc+0x4a/0xcb
 [<ffffffff810c8d6c>] ? kmem_cache_alloc+0x38/0xcb
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c157>] smp_call_function_mask+0xc1/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010000>] ? sys_rt_sigreturn+0x2a0/0x3d0
 [<ffffffff811c8716>] ? get_random_bytes+0x20/0x22
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8101277e>] die+0x62/0x6b
 [<ffffffff8130df44>] do_general_protection+0x123/0x12c
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff81094d61>] ? ftrace_record_ip+0x214/0x22b
 [<ffffffff81094d53>] ? ftrace_record_ip+0x206/0x22b
 [<ffffffff81010164>] mcount_call+0x5/0x31
 [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
 [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
 [<ffffffff8130615b>] start_secondary+0xc0/0x16e


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04e468>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [6] SMP DEBUG_PAGEALLOC
ACPI: EC: Look up EC in DSDT
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04dd38  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04dd68 R08: 0000000000000002 R09: ffffffff8130c5e4
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000096
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04de48 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000dcdb 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04dd38>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [7] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04d608  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04d638 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000096
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04d718 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000005e5d 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04d608>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [8] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04ced8  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04cf08 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04cfe8 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000dedd 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04ced8>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [9] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04c7a8  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04c7d8 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000096
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04c8b8 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000005e5d 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04c7a8>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [10] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04c078  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04c0a8 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04c188 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000dedd 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04c078>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [11] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04b948  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04b978 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04ba58 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000005e5d 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04b948>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [12] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04b218  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04b248 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04b328 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000dedd 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04b218>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [13] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04aae8  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04ab18 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04abf8 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000005e5d 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04aae8>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [14] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f04a3b8  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f04a3e8 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f04a4c8 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000dedd 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f04a3b8>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [15] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f049c88  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f049cb8 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f049d98 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000005e5d 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f049c88>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [16] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f049558  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f049588 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000096
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f049668 ffffffff8106c157
 0000000000000000 000000000000000b 000000000000dedd 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f049558>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
PGD 0 
Oops: 0000 [17] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810c8d7e>]  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
RSP: 0018:ffff88007f048e28  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffffffff81405760 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0101010101010101 RDI: ffffffff81064b1b
RBP: ffff88007f048e58 R08: 0000000000000002 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000040 R12: 0000000000000092
R13: ffffffff814efaa8 R14: ffffffff8106c157 R15: 0000000000000020
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  ffffffff8101ff41 ffffffff81405760 0000000000000003 0000000000000000
 0000000000000000 ffffffff8101ff41 ffff88007f048f38 ffffffff8106c157
 0000000000000000 000000000000000b 0000000000005e5d 0000000000000001
Call Trace:


Code: f7 9c 58 66 0f 1f 44 00 00 49 89 c4 fa 0f 1f 80 00 00 00 00 e8 a2 bd f9 ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 18 11 00 00 <8b> 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 48 8b 04 c3 
RIP  [<ffffffff810c8d7e>] kmem_cache_alloc+0x4a/0xcb
 RSP <ffff88007f048e28>
CR2: 0000000000000018
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:

---[ end trace 4eaa2a86a8e2da22 ]---
double fault: 0000 [18] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff81167d7a>]  [<ffffffff81167d7a>] vsnprintf+0x1a/0x5bd
RSP: 0018:ffff88007f047fb8  EFLAGS: 00010096
RAX: ffff88007f050000 RBX: ffff88007f0481e8 RCX: ffff88007f0481e8
RDX: ffffffff81403215 RSI: 0000000000000400 RDI: ffffffff817399b0
RBP: ffff88007f048108 R08: 0000000000000002 R09: ffffffff8104456d
R10: ffffffff810c8d8d R11: ffff88007f048098 R12: 0000000000000018
R13: ffffffff81403215 R14: ffffffff81403215 R15: ffff88007f048648
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff88007f047fa8 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack: <1>BUG: unable to handle kernel paging request at ffff88007f047fb8
IP: [<ffffffff810124a9>] show_stack_log_lvl+0xae/0xfb
PGD 202063 PUD 8067 PMD 7fb72163 PTE 800000007f047160
Oops: 0000 [19] SMP DEBUG_PAGEALLOC
CPU 2 
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
RIP: 0010:[<ffffffff810124a9>]  [<ffffffff810124a9>] show_stack_log_lvl+0xae/0xfb
RSP: 0018:ffff88007f05de28  EFLAGS: 00010046
RAX: ffff88007f821898 RBX: ffff88007f047fb8 RCX: ffff88007f048108
RDX: ffff880001027f80 RSI: ffff88007f05df58 RDI: 0000000000000000
RBP: ffff88007f05de78 R08: ffffffff8140d037 R09: ffffffff8130c5e4
R10: 0000000000000001 R11: 0000003000000008 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88007f05bfc0 R15: ffff88007f057fc0
FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff88007f047fb8 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
Stack:  0000000000000046 ffffffff8140d037 ffff88007f048108 ffff88007f05df58
 ffff88007f047fb8 ffff88007f050000 0000000000000ac0 ffff88007f05df58
 0000000000000040 ffff88007f047fb8 ffff88007f05deb8 ffffffff810125ac
Call Trace:
 <#DF>  [<ffffffff810125ac>] show_registers+0xb6/0x226
 [<ffffffff8130dc13>] __die+0xa7/0x11c
 [<ffffffff81012763>] die+0x47/0x6b
 [<ffffffff81012f6f>] do_double_fault+0x68/0x6a
 [<ffffffff81011b00>] double_fault+0xa0/0xd0
 [<ffffffff810c8d8d>] ? kmem_cache_alloc+0x59/0xcb
 [<ffffffff8104456d>] ? vprintk+0x194/0x39b
 [<ffffffff81167d7a>] ? vsnprintf+0x1a/0x5bd
 <<EOE>> 

Code: 8b 5b f8 e8 68 76 2f 00 eb 08 f7 c3 ff 1f 00 00 74 3f 45 85 e4 74 14 41 f6 c4 03 75 0e 48 c7 c7 4a 0c 44 81 31 c0 e8 45 76 2f 00 <48> 8b 33 48 c7 c7 32 bc 3f 81 31 c0 48 83 c3 08 41 ff c4 e8 2d 
RIP  [<ffffffff810124a9>] show_stack_log_lvl+0xae/0xfb
 RSP <ffff88007f05de28>
CR2: ffff88007f047fb8
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:290 smp_call_function_mask+0x47/0x181() (Tainted: G      D W)
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-0.205.rc1.git2.fc10.x86_64 #1

Call Trace:
 <#DF>  [<ffffffff81043bc8>] warn_on_slowpath+0x65/0x98
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8101ff41>] ? stop_this_cpu+0x0/0x33
 [<ffffffff8106c0dd>] smp_call_function_mask+0x47/0x181
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810764a5>] ? crash_kexec+0x10/0xe5
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8106c237>] smp_call_function+0x20/0x22
 [<ffffffff8101ff9b>] native_smp_send_stop+0x27/0x6f
 [<ffffffff81309a3f>] panic+0xb4/0x163
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8105c843>] ? __blocking_notifier_call_chain+0x16/0x6f
 [<ffffffff8105c8b0>] ? blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81046e3d>] do_exit+0x7e/0x900
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8130d779>] oops_begin+0x0/0x91
 [<ffffffff8130f980>] do_page_fault+0x9da/0xace
 [<ffffffff811682cb>] ? vsnprintf+0x56b/0x5bd
 [<ffffffff81167cfc>] ? string+0x3d/0xa1
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116811f>] ? vsnprintf+0x3bf/0x5bd
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff81010164>] ? mcount_call+0x5/0x31
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8116c6e0>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffff8130c626>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff81167d7a>] ? vsnprintf+0x1a/0x5bd
 [<ffffffff8130cdaa>] error_exit+0x0/0xc8
 [<ffffffff8130c5e4>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff810124a9>] ? show_stack_log_lvl+0xae/0xfb
 [<ffffffff81012411>] ? show_stack_log_lvl+0x16/0xfb
 [<ffffffff810125ac>] show_registers+0xb6/0x226
 [<ffffffff8130dc13>] __die+0xa7/0x11c
 [<ffffffff81012763>] die+0x47/0x6b
 [<ffffffff81012f6f>] do_double_fault+0x68/0x6a
 [<ffffffff81011b00>] double_fault+0xa0/0xd0
 [<ffffffff810c8d8d>] ? kmem_cache_alloc+0x59/0xcb
 [<ffffffff8104456d>] ? vprintk+0x194/0x39b
 [<ffffffff81167d7a>] ? vsnprintf+0x1a/0x5bd
 <<EOE>> 
---[ end trace 4eaa2a86a8e2da22 ]---
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard resources
PCI: Not using MMCONFIG.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
pci 0000:01:00.1: supports D1
pci 0000:01:00.1: supports D2
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:01.0. It can be enabled forcedly with 'pcie_aspm=force'
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D0 D1 D2
pci 0000:02:00.0: PME# disabled
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.0. It can be enabled forcedly with 'pcie_aspm=force'
pci 0000:03:00.0: supports D1
pci 0000:03:00.0: PME# supported from D0 D1 D3hot
pci 0000:03:00.0: PME# disabled
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.4. It can be enabled forcedly with 'pcie_aspm=force'
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.5. It can be enabled forcedly with 'pcie_aspm=force'
pci 0000:05:04.0: supports D1
pci 0000:05:04.0: supports D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
tracer: 1286 pages allocated for 65536 entries of 80 bytes
   actual entries 65586
ACPI: RTC can wake from S4
system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed9ffff has been reserved
system 00:01: iomem range 0xc0000-0xdffff has been reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x4000-0x4fff
pci 0000:00:01.0:   MEM window: 0x90400000-0x904fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000080000000-0x0000008fffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0x90300000-0x903fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: 0x3000-0x3fff
pci 0000:00:1c.4:   MEM window: 0x90200000-0x902fffff
pci 0000:00:1c.4:   PREFETCH window: 0x00000090600000-0x000000906fffff
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.5:   IO window: 0x2000-0x2fff
pci 0000:00:1c.5:   MEM window: 0x90100000-0x901fffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
pci 0000:00:1e.0:   MEM window: 0x90000000-0x900fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000090700000-0x000000907fffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
debug: unmapping init memory ffff880037cba000..ffff880037ff0000
audit: initializing netlink socket (disabled)
type=2000 audit(1217511133.750:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3959
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f10
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2010
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2010
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2010
pci 0000:00:1d.3: Performing full reset
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie02: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pci_express 0000:00:1c.5:pcie00: allocate port service
pci_express 0000:00:1c.5:pcie02: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0x80000000, mapped to 0xffffc20000c00000, using 3072k, total 16384k
vesafb: mode is 1024x768x16, linelength=2048, pages=9
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button (CM) [SLPB]
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:02: registered as cooling_device1
processor ACPI0007:03: registered as cooling_device2
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 0
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input2
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 0:193:535
bdi 1:13: hash matches
debug: unmapping init memory ffffffff81529000..ffffffff816b8000
Write protecting the kernel read-only data: 1420k
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x90504400
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-0.205.rc1.git2.fc10.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
modprobe used greatest stack depth: 3760 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00005080
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-0.205.rc1.git2.fc10.x86_64 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00005060
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-0.205.rc1.git2.fc10.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005040
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-0.205.rc1.git2.fc10.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: supports USB remote wakeup
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00005020
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-0.205.rc1.git2.fc10.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl RAID mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
ata3: SATA max UDMA/133 abar m1024@0x90504000 port 0x90504200 irq 19
ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata1.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
usb usb4: suspend_rh (auto-stop)
usb usb5: suspend_rh (auto-stop)
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata2.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.04, max UDMA/66
ata4.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 321672960 512-byte hardware sectors (164697 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 321672960 512-byte hardware sectors (164697 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 3:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.04 PQ: 0 ANSI: 5
scsi 3:0:0:0: Attached scsi generic sg2 type 5
ahci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:03:00.0: controller can't do NCQ, turning off CAP_NCQ
ahci 0000:03:00.0: MV_AHCI HACK: port_map 1f -> f
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 5 ports 3 Gbps 0xf impl SATA mode
ahci 0000:03:00.0: flags: 64bit stag pmp slum part 
ahci 0000:03:00.0: setting latency timer to 64
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
scsi8 : ahci
ata5: SATA max UDMA/133 abar m1024@0x90200000 port 0x90200100 irq 16
ata6: SATA max UDMA/133 abar m1024@0x90200000 port 0x90200180 irq 16
ata7: SATA max UDMA/133 abar m1024@0x90200000 port 0x90200200 irq 16
ata8: SATA max UDMA/133 abar m1024@0x90200000 port 0x90200280 irq 16
ata9: DUMMY
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
modprobe used greatest stack depth: 2448 bytes left
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
type=1404 audit(1217511142.571:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 8192 avtab hash slots, 165739 rules.
SELinux: 8192 avtab hash slots, 165739 rules.
SELinux:  8 users, 13 roles, 2421 types, 118 bools, 1 sens, 1024 cats
SELinux:  73 classes, 165739 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1217511143.248:3): policy loaded auid=4294967295 ses=4294967295
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
EDAC MC: Ver: 2.1.0 Jul 31 2008
EDAC i82975x: ECC disabled on both channels.
pata_acpi 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pata_acpi 0000:00:1f.1: setting latency timer to 64
pata_acpi 0000:00:1f.1: PCI INT A disabled
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi9 : ata_piix
scsi10 : ata_piix
ata10: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x50b0 irq 14
ata11: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x50b8 irq 15
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
Linux Tulip driver version 1.1.15 (Feb 27, 2007)
ata11: port disabled. ignoring.
e1000e 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000e 0000:04:00.0: setting latency timer to 64
input: PC Speaker as /devices/platform/pcspkr/input/input5
eth0: (PCI Express:2.5GB/s:Width x1) 00:19:d1:2a:19:8d
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
tulip 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
tulip0:  MII transceiver #1 config 3000 status 7809 advertising 01e1.
eth1: Lite-On 82c168 PNIC rev 32 at MMIO 0x90014800, 00:a0:cc:d2:3a:92, IRQ 18.
firewire_ohci 0000:05:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
firewire_ohci: Added fw-ohci device 0000:05:04.0, OHCI version 1.10
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ath5k_pci 0000:05:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ath5k_pci 0000:05:00.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF2112A 2GHz radio found (0x46)
firewire_core: created device fw0: GUID 0090270001bda345, S400
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
ALSA sound/pci/hda/hda_intel.c:2073: chipset global capabilities = 0x4401
ALSA sound/pci/hda/hda_intel.c:754: codec_mask = 0x4
ALSA sound/pci/hda/patch_sigmatel.c:3844: hda_codec: Unknown model forSTAC927x, using BIOS defaults
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 0a bios pin config 0221401f
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 0b bios pin config 02a19040
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 0c bios pin config 0181302e
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 0d bios pin config 01114010
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 0e bios pin config 01a19020
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 0f bios pin config 01111012
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 10 bios pin config 01117011
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 11 bios pin config 400000fb
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 12 bios pin config 500000fe
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 13 bios pin config 50a001f0
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 14 bios pin config 50a001f0
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 21 bios pin config 01452150
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 22 bios pin config 400000fc
ALSA sound/pci/hda/patch_sigmatel.c:1818: hda_codec: pin nid 23 bios pin config 00000000
ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=3 (0xd/0xf/0x10/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0xe, fmic=0xb, line=0xc, fline=0x0, cd=0x0, aux=0x0
ALSA sound/pci/hda/patch_sigmatel.c:2254: stac92xx_add_dyn_out_pins: total dac count=5
ALSA sound/pci/hda/patch_sigmatel.c:2376: dac_nids=4 (0x2/0x5/0x4/0x3/0x0)
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave External Speaker Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker2 Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave External Speaker Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker2 Playback Switch, skipped
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:2031608k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
firmware: requesting intel-ucode/06-0f-07
firmware: requesting intel-ucode/06-0f-07
firmware: requesting intel-ucode/06-0f-07
microcode: CPU0 updated from revision 0x60 to 0x68, date = 09162007 
microcode: CPU1 updated from revision 0x60 to 0x68, date = 09162007 
microcode: CPU3 updated from revision 0x60 to 0x68, date = 09162007 
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
usb usb5: usb auto-resume
usb usb5: wakeup_rh
hub 5-0:1.0: hub_resume
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: usb auto-resume
usb usb4: wakeup_rh
hub 4-0:1.0: hub_resume
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: usb auto-resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_resume
usb usb2: usb auto-resume
usb usb2: wakeup_rh
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 2-0:1.0: hub_resume
usb usb1: usb auto-resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 1-0:1.0: hub_resume
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
usb usb5: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:01:00.0: setting latency timer to 64
[drm] Initialized radeon 1.29.0 20080528 on minor 0
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): wlan0: link is not ready
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 4
[drm] writeback test succeeded in 1 usecs
eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth1: no IPv6 routers present
eth0: no IPv6 routers present
[drm] Num pipes: 4
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 4
[drm] writeback test succeeded in 1 usecs
[drm] Num pipes: 4

-- 
http://www.codemonkey.org.uk
