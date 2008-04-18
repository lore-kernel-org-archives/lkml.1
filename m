Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYDRVo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYDRVo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYDRVoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:44:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:30544 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYDRVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=EwGeaJF/3UtMhWiMrjK1kbgGHoPcCCp8hIDvzX8vruqxbqJUg33AHtYmrf+Xb4LWGryjaDYGC76ULSd0A8BJR6JH0/25p09GFeh+mPllYG8+M9Vp7P85KqilDwVoVQn5TrSsL4VfAn6asA87Gt2V2Z4Q0aw/JyR2MrAozLFnnEc=
Date: Sat, 19 Apr 2008 02:39:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-$SHA1: WARNING: at arch/x86/kernel/genapic_64.c:86
	read_apic_id+0x78/0x80()
Message-ID: <20080418223945.GA4801@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x78/0x80()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-2cca775baecbfede2fec20c99add709232311fe7 #3

Call Trace:
 [<ffffffff8023150f>] warn_on_slowpath+0x5f/0x80
 [<ffffffff80299e9e>] ? open_namei+0x4e/0x6b0
 [<ffffffff804594e5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
 [<ffffffff804594c2>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff8021ed28>] read_apic_id+0x78/0x80
 [<ffffffff805e7332>] verify_local_APIC+0xb2/0x1a0
 [<ffffffff805e6193>] native_smp_prepare_cpus+0x1a3/0x390
 [<ffffffff805e0713>] kernel_init+0x53/0x340
 [<ffffffff80459536>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff80458a92>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
 [<ffffffff8020c4b8>] child_rip+0xa/0x12
 [<ffffffff8020bba3>] ? restore_args+0x0/0x30
 [<ffffffff805e06c0>] ? kernel_init+0x0/0x340
 [<ffffffff8020c4ae>] ? child_rip+0x0/0x12



Linux version 2.6.25-2cca775baecbfede2fec20c99add709232311fe7 (ad@martell) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #3 SMP PREEMPT Sat Apr 19 02:22:20 MSD 2008
Command line: root=/dev/sda2 netconsole=@192.168.0.1/eth0,9353@192.168.0.42/00:1b:38:af:22:49 ignore_loglevel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
debug: ignoring loglevel setting.
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
max_pfn_mapped = 1572864
x86: PAT support disabled.
init_memory_mapping
DMI 2.4 present.
ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
ACPI: XSDT 7FF90100, 0054 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   2000707 MSFT       97)
ACPI: DSDT 7FF905C0, 8FA9 (r1  A0637 A0637000        0 INTL 20060113)
ACPI: FACS 7FF9E000, 0040
ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   2000707 MSFT       97)
ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   2000707 MSFT       97)
ACPI: SLIC 7FF90440, 0176 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   2000707 MSFT       97)
ACPI: HPET 7FF99570, 0038 (r1 MSTEST OEMHPET   2000707 MSFT       97)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] TRAMPOLINE
early res: 2 [200000-a05247] TEXT DATA BSS
early res: 3 [9fc00-fffff] BIOS reserved
early res: 4 [8000-dfff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
 [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
 [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
 [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
 [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
 [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
 [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
 [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
 [ffffe20004400000-ffffe200045fffff] PMD ->ffff810009a00000 on node 0
 [ffffe20004600000-ffffe200047fffff] PMD ->ffff810009e00000 on node 0
 [ffffe20004800000-ffffe200049fffff] PMD ->ffff81000a200000 on node 0
 [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff81000a600000 on node 0
 [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff81000aa00000 on node 0
 [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff81000ae00000 on node 0
 [ffffe20005000000-ffffe200051fffff] PMD ->ffff81000b200000 on node 0
 [ffffe20005200000-ffffe200053fffff] PMD ->ffff81000b600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1572864
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524176
    0:  1048576 ->  1572864
On node 0 totalpages: 1048367
  DMA zone: 56 pages used for memmap
  DMA zone: 2160 pages reserved
  DMA zone: 1783 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505800 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
PERCPU: Allocating 32836 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1024703
Kernel command line: root=/dev/sda2 netconsole=@192.168.0.1/eth0,9353@192.168.0.42/00:1b:38:af:22:49 ignore_loglevel
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PIT
time.c: Detected 2135.102 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 2688 bytes
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0xbe63000 - 0xfe63000
Memory: 4025684k/6291456k available (2416k kernel code, 167056k reserved, 1427k data, 232k init)
CPA: page pool initialized 64 of 64 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 4273.59 BogoMIPS (lpj=2136799)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
debug: unmapping init memory ffffffff805db000..ffffffff805e0000
ACPI: Core revision 20070126
------------[ cut here ]------------
WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x78/0x80()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-2cca775baecbfede2fec20c99add709232311fe7 #3

Call Trace:
 [<ffffffff8023150f>] warn_on_slowpath+0x5f/0x80
 [<ffffffff80299e9e>] ? open_namei+0x4e/0x6b0
 [<ffffffff804594e5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
 [<ffffffff804594c2>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff8021ed28>] read_apic_id+0x78/0x80
 [<ffffffff805e7332>] verify_local_APIC+0xb2/0x1a0
 [<ffffffff805e6193>] native_smp_prepare_cpus+0x1a3/0x390
 [<ffffffff805e0713>] kernel_init+0x53/0x340
 [<ffffffff80459536>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff80458a92>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
 [<ffffffff8020c4b8>] child_rip+0xa/0x12
 [<ffffffff8020bba3>] ? restore_args+0x0/0x30
 [<ffffffff805e06c0>] ? kernel_init+0x0/0x340
 [<ffffffff8020c4ae>] ? child_rip+0x0/0x12

---[ end trace ca143223eefdc828 ]---
------------[ cut here ]------------
WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x78/0x80()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-2cca775baecbfede2fec20c99add709232311fe7 #3

Call Trace:
 [<ffffffff8023150f>] warn_on_slowpath+0x5f/0x80
 [<ffffffff80299e9e>] ? open_namei+0x4e/0x6b0
 [<ffffffff804594e5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
 [<ffffffff804594c2>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff8021ed28>] read_apic_id+0x78/0x80
 [<ffffffff805e7364>] verify_local_APIC+0xe4/0x1a0
 [<ffffffff805e6193>] native_smp_prepare_cpus+0x1a3/0x390
 [<ffffffff805e0713>] kernel_init+0x53/0x340
 [<ffffffff80459536>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff80458a92>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
 [<ffffffff8020c4b8>] child_rip+0xa/0x12
 [<ffffffff8020bba3>] ? restore_args+0x0/0x30
 [<ffffffff805e06c0>] ? kernel_init+0x0/0x340
 [<ffffffff8020c4ae>] ? child_rip+0x0/0x12

---[ end trace ca143223eefdc828 ]---
CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 16680472
Detected 16.680 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000

