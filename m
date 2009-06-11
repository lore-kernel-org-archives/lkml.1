Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZFKCnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZFKCnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZFKCna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:43:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:22336 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZFKCn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zt0J/zp2obgfczrc7KmyqL9ZkgZFuvGc6DG1X+v3AOvGRAHaxOb+9aAVGtRwUl0RYf
         6O6QxH9WaRKrYHCMGq2fjB6mZdXpDcCmWewygCn4suerCrXta+7IePGHvLfmJfxxzBTN
         mmD3cHtbNA2nXk4c+odZndO3Cg+3Q6zRVghh8=
MIME-Version: 1.0
In-Reply-To: <86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com>
References: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com>
	 <86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com>
Date: Wed, 10 Jun 2009 20:43:30 -0600
Message-ID: <9b1675090906101943x10dff40ak32341383a516ae7c@mail.gmail.com>
Subject: Re: Macbook 4G only see 3G
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My dmesg is below.  Unfortunately, I will not be able to help with
testing for a bit now.  I just got my memory today, and it's either
bad, there's something wrong with the Macbook, or the memory doesn't
work with the Macbook as Kingston claims it does.  So, I have to send
it in for RMA I guess.

On Wed, Jun 10, 2009 at 6:54 PM, Yinghai Lu<yhlu.kernel@gmail.com> wrote:
> On Wed, Jun 10, 2009 at 5:47 PM, Trenton D.
> Adams<trenton.d.adams@gmail.com> wrote:
>> Hi Guys,
>>
>> Has anyone been doing any development in the area of enabling 4G for
>> any PC that doesn't have an option in the BIOS?  The Mac OS X sees the
>> full 4G, but Linux does not.
>>
>> tdamac ~ # uname -a
>> Linux tdamac 2.6.30-rc7-dirty #3 SMP Fri Jun 5 21:24:29 MDT 2009
>> x86_64 Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux
>
> boot log?

dmtdamac ~ # dmesg
Linux version 2.6.30-rc7-dirty (root@tdamac) (gcc version 4.3.2
(Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #3 SMP Fri Jun 5 21:24:29 MDT
2009
Command line: root=/dev/ram0 init=/linuxrc real_root=/dev/s/sys dolvm
hung_task_show_state=1
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000be08c000 (usable)
 BIOS-e820: 00000000be08c000 - 00000000be28d000 (ACPI NVS)
 BIOS-e820: 00000000be28d000 - 00000000beebe000 (ACPI data)
 BIOS-e820: 00000000beebe000 - 00000000beeef000 (ACPI NVS)
 BIOS-e820: 00000000beeef000 - 00000000bef00000 (ACPI data)
 BIOS-e820: 00000000bef00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0xbe08c max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0FFE00000 mask FFFE00000 write-protect
  1 base 000000000 mask F80000000 write-back
  2 base 080000000 mask FC0000000 write-back
  3 base 0BF000000 mask FFF000000 uncachable
  4 base 000000000 mask F80000000 write-back
  5 base 080000000 mask FC0000000 write-back
  6 base 0BEF00000 mask FFFF00000 uncachable
  7 disabled
init_memory_mapping: 0000000000000000-00000000be08c000
 0000000000 - 00be000000 page 2M
 00be000000 - 00be08c000 page 4k
kernel direct mapping tables up to be08c000 @ 8000-d000
RAMDISK: 37e3c000 - 37fefe4c
ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
ACPI: XSDT 00000000beefd1c0 00074 (v01 APPLE   Apple00 000000A5      01000013)
ACPI: FACP 00000000beefb000 000F4 (v03 APPLE   Apple00 000000A5 Loki 0000005F)
ACPI: DSDT 00000000beef0000 041E4 (v01 APPLE   MacBook 00020001 INTL 20050309)
ACPI: FACS 00000000beec0000 00040
ACPI: HPET 00000000beefa000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: APIC 00000000beef9000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: MCFG 00000000beef8000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ASF! 00000000beef7000 000A0 (v32 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SBST 00000000beef6000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ECDT 00000000beef5000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 00000000beeef000 004DC (v01 APPLE     CpuPm 00003000 INTL 20050309)
ACPI: SSDT 00000000beebd000 0064F (v01 SataRe  SataPri 00001000 INTL 20050309)
ACPI: SSDT 00000000beebc000 0069C (v01 SataRe  SataSec 00001000 INTL 20050309)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 00be08c000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000ae537c]    TEXT DATA BSS ==> [0000200000 - 0000ae537c]
  #3 [0037e3c000 - 0037fefe4c]          RAMDISK ==> [0037e3c000 - 0037fefe4c]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000ae6000 - 0000ae6265]              BRK ==> [0000ae6000 - 0000ae6265]
  #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
 [ffffe20000000000-ffffe200029fffff] PMD ->
[ffff880001200000-ffff880003bfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000be08c
On node 0 totalpages: 778283
  DMA zone: 56 pages used for memmap
  DMA zone: 2379 pages reserved
  DMA zone: 1564 pages, LIFO batch:0
  DMA32 zone: 10586 pages used for memmap
  DMA32 zone: 763698 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages at ffff88000101c000, static data 73312 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 765262
Kernel command line: root=/dev/ram0 init=/linuxrc real_root=/dev/s/sys
dolvm hung_task_show_state=1
Initializing CPU#0
NR_IRQS:1280
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration failed
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 2161.246 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 3051960k/3113520k available (4667k kernel code, 388k absent,
60544k reserved, 2750k data, 416k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4322.49 BogoMIPS (lpj=8644984)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20090320
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4322.45 BogoMIPS (lpj=8644902)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (8644.94 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net_namespace: 1784 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in E820
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xd0380000-0xd03fffff]
pci 0000:00:02.0: reg 14 io port: [0x20e0-0x20e7]
pci 0000:00:02.0: reg 18 32bit mmio: [0xc0000000-0xcfffffff]
pci 0000:00:02.0: reg 1c 32bit mmio: [0xd0400000-0xd043ffff]
pci 0000:00:02.1: reg 10 32bit mmio: [0xd0300000-0xd037ffff]
pci 0000:00:07.0: reg 10 32bit mmio: [0xd0444000-0xd0444fff]
pci 0000:00:1b.0: reg 10 64bit mmio: [0xd0440000-0xd0443fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x2080-0x209f]
pci 0000:00:1d.1: reg 20 io port: [0x2060-0x207f]
pci 0000:00:1d.2: reg 20 io port: [0x2040-0x205f]
pci 0000:00:1d.3: reg 20 io port: [0x2020-0x203f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xd0445400-0xd04457ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
pci 0000:00:1f.1: reg 10 io port: [0x20d8-0x20df]
pci 0000:00:1f.1: reg 14 io port: [0x20f4-0x20f7]
pci 0000:00:1f.1: reg 18 io port: [0x20d0-0x20d7]
pci 0000:00:1f.1: reg 1c io port: [0x20f0-0x20f3]
pci 0000:00:1f.1: reg 20 io port: [0x20b0-0x20bf]
pci 0000:00:1f.2: reg 10 io port: [0x20c8-0x20cf]
pci 0000:00:1f.2: reg 14 io port: [0x20ec-0x20ef]
pci 0000:00:1f.2: reg 18 io port: [0x20c0-0x20c7]
pci 0000:00:1f.2: reg 1c io port: [0x20e8-0x20eb]
pci 0000:00:1f.2: reg 20 io port: [0x20a0-0x20af]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xd0445000-0xd04453ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
pci 0000:01:00.0: reg 10 64bit mmio: [0xd0200000-0xd0203fff]
pci 0000:01:00.0: reg 18 io port: [0x1000-0x10ff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:00:1c.0: bridge io port: [0x1000-0x1fff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xd0200000-0xd02fffff]
pci 0000:02:00.0: reg 10 64bit mmio: [0xd0100000-0xd010ffff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: PME# supported from D0 D1 D3hot
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0xd0100000-0xd01fffff]
pci 0000:03:03.0: reg 10 32bit mmio: [0xd0000000-0xd0000fff]
pci 0000:03:03.0: supports D1 D2
pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:03:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xd0000000-0xd00fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:07: io resource (0x1640-0x164f) overlaps 0000:00:1c.0 BAR 7
(0x1000-0x1fff), disabling
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:07: ioport range 0x680-0x6ef has been reserved
system 00:07: ioport range 0x800-0x80f has been reserved
system 00:07: ioport range 0x810-0x817 has been reserved
system 00:07: ioport range 0x400-0x47f has been reserved
system 00:07: ioport range 0x500-0x53f has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
pci 0000:00:1c.0:   MEM window: 0xd0200000-0xd02fffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000d0500000-0x000000d05fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xd0100000-0xd01fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xd0000000-0xd00fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x1000-0x1fff]
pci_bus 0000:01: resource 1 mem: [0xd0200000-0xd02fffff]
pci_bus 0000:01: resource 2 pref mem [0xd0500000-0xd05fffff]
pci_bus 0000:02: resource 1 mem: [0xd0100000-0xd01fffff]
pci_bus 0000:03: resource 1 mem: [0xd0000000-0xd00fffff]
pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 1743k freed
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 5965
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
ACPI: AC Adapter [ADP1] (on-line)
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID0]
input: Power Button as /class/input/input2
ACPI: Power Button [PWRB]
input: Sleep Button as /class/input/input3
ACPI: Sleep Button [SLPB]
ACPI: SSDT 00000000beeb8c10 002AE (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
ACPI: SSDT 00000000beeb8910 002A0 (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switched to high resolution mode on CPU 0
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 00000000beeb8f10 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
Switched to high resolution mode on CPU 1
ACPI: SSDT 00000000beeb7f10 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Real Time Clock Driver v1.12b
intel_rng: FWH not detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 16124K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
intelfb: Framebuffer driver for Intel(R)
830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM
chipsets
intelfb: Version 0.9.6
intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
intelfb: 00:02.0: Intel(R) 945GM, aperture size 256MB, stolen memory 16124kB
intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
intelfb: Video mode must be programmed at boot time.
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
ACPI: Battery Slot [BAT0] (battery present)
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
3ware Storage Controller device driver for Linux v1.26.02.002.
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x20b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x20b8 irq 15
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x20c8 ctl 0x20ec bmdma 0x20a0 irq 19
ata4: SATA max UDMA/133 cmd 0x20c0 ctl 0x20e8 bmdma 0x20a8 irq 19
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
sky2 driver version 1.22
sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sky2 0000:01:00.0: setting latency timer to 64
sky2 0000:01:00.0: Yukon-2 EC chip revision 2
sky2 0000:01:00.0: irq 24 for MSI/MSI-X
sky2 eth0: addr 00:19:e3:43:1c:a3
console [netcon0] enabled
netconsole: network logging started
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
ohci1394 0000:03:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata1.00: ATAPI: HL-DT-ST DVDRW  GSA-S10N, BP08, max UDMA/33
ata1.00: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRW  GSA-S10N  BP08 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr 0:0:0:0: Attached scsi generic sg0 type 5
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]
MMIO=[d0000000-d00007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
ieee1394: raw1394: /dev/raw1394 device initialized
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xd0445400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 21, io base 0x00002080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
Linux video capture interface: v2.00
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
oprofile: using NMI interrupt.
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
xt_time: kernel timezone is -0000
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
registered taskstats version 1
ata3.01: ATA-8: ST9320421AS, SD13, max UDMA/133
ata3.01: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.01: configured for UDMA/133
scsi 2:0:1:0: Direct-Access     ATA      ST9320421AS      SD13 PQ: 0 ANSI: 5
sd 2:0:1:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda:<5>sd 2:0:1:0: Attached scsi generic sg1 type 0
 sda1 sda2 sda3 sda4
sd 2:0:1:0: [sda] Attached SCSI disk
Clocksource tsc unstable (delta = -162594439 ns)
Freeing unused kernel memory: 416k freed
usb 1-3: new high speed USB device using ehci_hcd and address 3
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 2 ports detected
usb 1-4: new high speed USB device using ehci_hcd and address 4
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
usb 1-4: configuration #1 chosen from 1 choice
raid6: int64x1   1938 MB/s
raid6: int64x2   2420 MB/s
raid6: int64x4   1862 MB/s
raid6: int64x8   1530 MB/s
raid6: sse2x1    3383 MB/s
raid6: sse2x2    4138 MB/s
raid6: sse2x4    6514 MB/s
raid6: using algorithm sse2x4 (6514 MB/s)
async_tx: api initialized (sync-only)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  7688.000 MB/sec
xor: using function: generic_sse (7688.000 MB/sec)
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001cb3fffe8ab416]
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
usb 2-2: new full speed USB device using uhci_hcd and address 2
md: raid10 personality registered for level 10
usb 2-2: configuration #1 chosen from 1 choice
input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input4
apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard [Apple
Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input0
input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input5
apple 0003:05AC:021A.0002: input: USB HID v1.11 Device [Apple Computer
Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
generic-usb 0003:05AC:8240.0003: claimed by neither input, hiddev nor hidraw
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
input: HID 05ac:1000 as /class/input/input6
generic-usb 0003:05AC:1000.0004: input: USB HID v1.11 Keyboard [HID
05ac:1000] on usb-0000:00:1d.3-1/input0
input: HID 05ac:1000 as /class/input/input7
generic-usb 0003:05AC:1000.0005: input: USB HID v1.11 Mouse [HID
05ac:1000] on usb-0000:00:1d.3-1/input1
usb 1-3.1: new high speed USB device using ehci_hcd and address 7
usb 1-3.1: configuration #1 chosen from 1 choice
hub 1-3.1:1.0: USB hub found
hub 1-3.1:1.0: 4 ports detected
usb 1-3.1.1: new high speed USB device using ehci_hcd and address 8
usb 1-3.1.1: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 8
usb-storage: waiting for device to settle before scanning
usb 1-3.1.2: new high speed USB device using ehci_hcd and address 9
usb 1-3.1.2: configuration #1 chosen from 1 choice
hub 1-3.1.2:1.0: USB hub found
hub 1-3.1.2:1.0: 3 ports detected
usb 1-3.1.2.1: new low speed USB device using ehci_hcd and address 10
usb 1-3.1.2.1: configuration #1 chosen from 1 choice
input: No brand KVM as /class/input/input8
generic-usb 0003:10D5:5552.0006: input: USB HID v1.10 Keyboard [No
brand KVM] on usb-0000:00:1d.7-3.1.2.1/input0
input: No brand KVM as /class/input/input9
generic-usb 0003:10D5:5552.0007: input: USB HID v1.10 Mouse [No brand
KVM] on usb-0000:00:1d.7-3.1.2.1/input1
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
scsi 4:0:0:0: Direct-Access     Generic  Flash HS-CF      4.44 PQ: 0 ANSI: 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
sd 4:0:0:0: [sdb] Attached SCSI removable disk
applesmc: Apple MacBook (v2) detected:
applesmc:  - Model with accelerometer
applesmc:  - Model without light sensors and backlight
applesmc:  - Model with 10 temperature sensors
udev: renamed network interface eth0 to eth1
applesmc: device successfully initialized (0xe0, 0x00).
applesmc: device successfully initialized.
applesmc: 1 fans found.
input: applesmc as /class/input/input10
applesmc: driver successfully loaded.
input: PC Speaker as /class/input/input11
appletouch: Geyser mode initialized.
input: appletouch as /class/input/input12
usbcore: registered new interface driver appletouch
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath9k 0000:02:00.0: setting latency timer to 64
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81:
mem=0xffffc20004740000, irq=17
hda_codec: STAC922x, Apple subsys_id=106b2200
input: HDA Intel Line In at Ext Left Jack as /class/input/input13
input: HDA Intel Mic at Ext Left Jack as /class/input/input14
input: HDA Intel HP Out at Ext Left Jack as /class/input/input15
EXT3 FS on dm-2, internal journal
fuse init (API version 7.11)
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
ext3_orphan_cleanup: deleting unreferenced inode 14
ext3_orphan_cleanup: deleting unreferenced inode 98327
ext3_orphan_cleanup: deleting unreferenced inode 98326
ext3_orphan_cleanup: deleting unreferenced inode 98325
ext3_orphan_cleanup: deleting unreferenced inode 98324
ext3_orphan_cleanup: deleting unreferenced inode 98323
ext3_orphan_cleanup: deleting unreferenced inode 98322
ext3_orphan_cleanup: deleting unreferenced inode 98321
ext3_orphan_cleanup: deleting unreferenced inode 98320
ext3_orphan_cleanup: deleting unreferenced inode 98319
ext3_orphan_cleanup: deleting unreferenced inode 98318
ext3_orphan_cleanup: deleting unreferenced inode 98317
ext3_orphan_cleanup: deleting unreferenced inode 98316
ext3_orphan_cleanup: deleting unreferenced inode 98315
ext3_orphan_cleanup: deleting unreferenced inode 98314
ext3_orphan_cleanup: deleting unreferenced inode 98313
ext3_orphan_cleanup: deleting unreferenced inode 98312
ext3_orphan_cleanup: deleting unreferenced inode 98311
ext3_orphan_cleanup: deleting unreferenced inode 98310
EXT3-fs: dm-3: 19 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
Adding 1048568k swap on /dev/mapper/s-swap.  Priority:-1 extents:1
across:1048568k
sky2 eth1: enabling interface
ADDRCONF(NETDEV_UP): eth1: link is not ready
sky2 eth1: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
eth1: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
REISERFS (device dm-4): found reiserfs format "3.6" with standard journal
REISERFS (device dm-4): using ordered data mode
REISERFS (device dm-4): journal params: device dm-4, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-4): checking transaction log (dm-4)
REISERFS (device dm-4): replayed 253 transactions in 6 seconds
REISERFS (device dm-4): Using r5 hash to sort names
