Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYCLSII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYCLSII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYCLSH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:07:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33555 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYCLSHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:07:54 -0400
Subject: Re: 2.6.25-rc5-mm1 - x86_64 boot problem ?
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 10:10:50 -0800
Message-Id: <1205345451.23611.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 01:14 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> 

I am having trouble booting rc5-mm1 on my x86_64. (ppc64 boots & works
fine). Seems to be a networking issues (hangs on boot). Here are the 
messages on the console (not really useful to me).

On a good kernel (rc5), the next set of messages would be ..

IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 13864 for ipc namespace ffffffff806903a0
..

Sorry for not being really useful here. But would like to
know if its a known issue ? Or should I start bisecting ?

Thanks,
Badari

Linux version 2.6.25-rc5-mm1 (root@elm3b29) (gcc version 4.1.0 (SUSE Linux)) #1 SMP Wed Mar 12 12:27:14 PDT 2008
Command line: root=/dev/hda2 vga=0x314  crashkernel=64M@16M selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showopts
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfef0000 (usable)
 BIOS-e820: 00000000dfef0000 - 00000000dfeff000 (ACPI data)
 BIOS-e820: 00000000dfeff000 - 00000000dff00000 (ACPI NVS)
 BIOS-e820: 00000000dff00000 - 00000000e0000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001e0000000 (usable)
end_pfn_map = 1966080
DMI 2.3 present.
ACPI: RSDP 000F6970, 0024 (r2 PTLTD )
ACPI: XSDT DFEFC625, 003C (r1 PTLTD      XSDT    6040000  LTP        0)
ACPI: FACP DFEFED02, 00F4 (r3 AMD    HAMMER    6040000 PTEC    F4240)
ACPI: DSDT DFEFC661, 262D (r1 AMD-K8  AMDACPI  6040000 MSFT  100000D)
ACPI: FACS DFEFFFC0, 0040
ACPI: SRAT DFEFEDF6, 0160 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: APIC DFEFEF56, 00AA (r1 PTLTD      APIC    6040000  LTP        0)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: PXM 2 -> APIC 2 -> Node 2
SRAT: PXM 3 -> APIC 3 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-e0000000
SRAT: Node 0 PXM 0 0-180000000
SRAT: PXM 1 (100000000-1a0000000) overlaps with PXM 0 (0-180000000)
SRAT: SRAT not used.
Scanning NUMA topology in Northbridge 24
Number of nodes 4
Node 0 MemBase 0000000000000000 Limit 0000000180000000
Node 1 MemBase 0000000180000000 Limit 00000001a0000000
Node 2 MemBase 00000001a0000000 Limit 00000001c0000000
Node 3 MemBase 00000001c0000000 Limit 00000001e0000000
Using node hash shift of 29
Bootmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000000011000 - 0000000000015fff]
  bootmap [0000000000016000 -  0000000000045fff] pages 30
Bootmem setup node 1 0000000180000000-00000001a0000000
  NODE_DATA [0000000180000000 - 0000000180004fff]
  bootmap [0000000180005000 -  0000000180008fff] pages 4
Bootmem setup node 2 00000001a0000000-00000001c0000000
  NODE_DATA [00000001a0000000 - 00000001a0004fff]
  bootmap [00000001a0005000 -  00000001a0008fff] pages 4
Bootmem setup node 3 00000001c0000000-00000001e0000000
  NODE_DATA [00000001c0000000 - 00000001c0004fff]
  bootmap [00000001c0005000 -  00000001c0008fff] pages 4
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] TRAMPOLINE
early res: 2 [200000-82936f] TEXT DATA BSS
early res: 3 [9f000-fffff] BIOS reserved
early res: 4 [8000-10fff] PGTABLE
Reserving 64MB of memory at 16MB for crashkernel (System RAM: 7680MB)
[ffffe20005b00000-ffffe20005bfffff] potential offnode page_structs
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1966080
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0:        0 ->      159
    0:      256 ->   917232
    0:   917248 ->   917504
    0:  1048576 ->  1572864
    1:  1572864 ->  1703936
    2:  1703936 ->  1835008
    3:  1835008 ->  1966080
ACPI: PM-Timer IO Port: 0x8008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfa3e0000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xfa3e0000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xfa3e1000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xfa3e1000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xfa3e2000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xfa3e2000, GSI 32-35
ACPI: IOAPIC (id[0x08] address[0xfa3e4000] gsi_base[36])
IOAPIC[4]: apic_id 8, address 0xfa3e4000, GSI 36-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 40896 bytes of per cpu data
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 1806327
Policy zone: Normal
Kernel command line: root=/dev/hda2 vga=0x314  crashkernel=64M@16M selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showopts
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1398.170 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
console [ttyS0] enabled
Checking aperture...
Node 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 10000000
Memory: 7098644k/7864320k available (3428k kernel code, 240936k reserved, 1472k data, 316k init)
Calibrating delay using timer specific routine.. 2799.22 BogoMIPS (lpj=5598441)
Security Framework initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
ACPI: Core revision 20070126
Using local APIC timer interrupts.
Detected 12.483 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 2796.41 BogoMIPS (lpj=5592825)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 1
Opteron MP w/ 1MB stepping 00
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 2796.42 BogoMIPS (lpj=5592842)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 2
Opteron MP w/ 1MB stepping 00
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 2796.42 BogoMIPS (lpj=5592844)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 3
Opteron MP w/ 1MB stepping 00
Brought up 4 CPUs
net_namespace: 1016 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Root Bridge [PCI1] (0000:08)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 *5 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 10000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:05: ioport range 0x1100-0x117f has been reserved
system 00:05: ioport range 0x1180-0x11ff has been reserved
system 00:05: ioport range 0xb78-0xb7b has been reserved
system 00:05: ioport range 0x190-0x193 has been reserved
system 00:06: iomem range 0xe0000-0xfffff could not be reserved
system 00:06: iomem range 0xc0000-0xc87ff has been reserved
system 00:06: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:06: iomem range 0xffc00000-0xfff7ffff has been reserved
system 00:06: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:06: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:06: iomem range 0xfe000000-0xfe000fff has been reserved
system 00:06: iomem range 0xfe001000-0xfe001fff has been reserved
system 00:06: iomem range 0xfe002000-0xfe003fff has been reserved
system 00:06: iomem range 0xfe004000-0xfe004fff has been reserved
PCI: Bridge: 0000:00:06.0
Time: acpi_pm clocksource has been installed.
  IO window: 2000-2fff
  MEM window: 0xfa000000-0xfa0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:09:01.0
  IO window: disabled.
  MEM window: 0xfa400000-0xfaffffff
  PREFETCH window: 0x00000000fc000000-0x00000000fdffffff
PCI: Bridge: 0000:08:01.0
  IO window: disabled.
  MEM window: 0xfa400000-0xfaffffff
  PREFETCH window: 0x00000000fc000000-0x00000000fdffffff
PCI: Bridge: 0000:08:02.0
  IO window: 3000-3fff
  MEM window: 0xfb000000-0xfb0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:08:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:08:04.0
  IO window: 4000-4fff
  MEM window: 0xfb100000-0xfb1fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:08:04.0[A] -> GSI 36 (level, low) -> IRQ 36
NET: Registered protocol family 2



