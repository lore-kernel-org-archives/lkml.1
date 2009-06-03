Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZFCLmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZFCLmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZFCLmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:42:09 -0400
Received: from mail-ew0-f162.google.com ([209.85.219.162]:34189 "EHLO
	mail-ew0-f162.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbZFCLmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:42:04 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 07:42:03 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oX9IBZ2wDbH6sFx63MKElTRIjdMFQPeiVhwp+313K80Y8TF7tWcm2jG1tYKoDbRJCM
         8c9ZzcfmVXo5G/2CAWS38ppsA5cpsVukFbP/UN9/j18A6FniAcUx20Binw8/bloEBvS6
         FAOftII6Ih3IutUG7JdUdTNddU0GkyszUmEto=
MIME-Version: 1.0
In-Reply-To: <4A25F688.9000407@gmail.com>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <4A25F688.9000407@gmail.com>
Date: Wed, 3 Jun 2009 13:35:04 +0200
Message-ID: <c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/3 Robert Hancock <hancockrwd@gmail.com>:
> Grozdan wrote:
>>
>> Hi,
>>
>> I gave today kernel 2.6.30rc7 a spin on my Athlon 64 system and it
>> seems there's yet again a problem with libata limiting IDE disks to
>> UDMA33 since it thinks that the cable is only 40 wires. My distro
>> kernel which is 2.6.27.21 does not have this problem and correctly
>> sets my disks to UDMA133. I googled around and it seems in the past
>> this was a known problem for some kernels. Any suggestions? :)
>>
>> Please cc me as I'm not subscribed to the list
>
> Full dmesg output from bootup would be useful.
>
> CCing linux-ide.
>

Hi

Sorry for the late reply. Here's the dmesg output of kernel 2.6.30-rc7-git4

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.30-rc7-git4-neutrino (geeko@buildhost) (gcc version
4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP PREEMPT
Wed Jun 3 13:07:40 CEST 2009
Command line: root=/dev/sda1 resume=/dev/sda3 splash=silent vga=0x317
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000006fee0000 (usable)
 BIOS-e820: 000000006fee0000 - 000000006fee3000 (ACPI NVS)
 BIOS-e820: 000000006fee3000 - 000000006fef0000 (ACPI data)
 BIOS-e820: 000000006fef0000 - 000000006ff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.3 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x6fee0 max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 base 0040000000 mask FFE0000000 write-back
  2 base 0060000000 mask FFF0000000 write-back
  3 base 006FF00000 mask FFFFF00000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-000000006fee0000
 0000000000 - 006fe00000 page 2M
 006fe00000 - 006fee0000 page 4k
kernel direct mapping tables up to 6fee0000 @ 10000-14000
RAMDISK: 3758e000 - 37fef163
ACPI: RSDP 00000000000f7ba0 00014 (v00 K8T890)
ACPI: RSDT 000000006fee3040 00030 (v01 K8T890 AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 000000006fee30c0 00074 (v01 K8T890 AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 000000006fee3180 079C5 (v01 K8T890 AWRDACPI 00001000 MSFT 0100000E)
ACPI: FACS 000000006fee0000 00040
ACPI: MCFG 000000006feeac80 0003C (v01 K8T890 AWRDACPI 42302E31 AWRD 00000000)
ACPI: APIC 000000006feeabc0 00066 (v01 K8T890 AWRDACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000006fee0000
Bootmem setup node 0 0000000000000000-000000006fee0000
  NODE_DATA [0000000000012000 - 0000000000045fff]
  bootmap [0000000000046000 -  0000000000053fdf] pages e
(7 early reservations) ==> bootmem [0000000000 - 006fee0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000513b38c]    TEXT DATA BSS ==> [0000200000 - 000513b38c]
  #3 [003758e000 - 0037fef163]          RAMDISK ==> [003758e000 - 0037fef163]
  #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #5 [000513c000 - 000513c13d]              BRK ==> [000513c000 - 000513c13d]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
found SMP MP-table at [ffff8800000f5aa0] f5aa0
 [ffffe20000000000-ffffe200019fffff] PMD ->
[ffff880005400000-ffff880006dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0006fee0
On node 0 totalpages: 458351
  DMA zone: 56 pages used for memmap
  DMA zone: 101 pages reserved
  DMA zone: 3826 pages, LIFO batch:0
  DMA32 zone: 6213 pages used for memmap
  DMA32 zone: 448155 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 0, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 1 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 48
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 70000000 (gap: 6ff00000:70100000)
NR_CPUS:4096 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 26 pages at ffff880005170000, static data 73760 bytes
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 451981
Policy zone: DMA32
Kernel command line: root=/dev/sda1 resume=/dev/sda3 splash=silent vga=0x317
bootsplash: silent mode.
Initializing CPU#0
NR_IRQS:4352
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2400.217 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
AGP bridge at 00:00:00
Aperture from AGP @ d0000000 old size 32 MB
Aperture from AGP @ d0000000 size 128 MB (APSIZE f20)
Node 0: aperture @ fed0000000 size 128 MB
Aperture beyond 4GB. Ignoring.
Memory: 1705648k/1833856k available (3489k kernel code, 452k absent,
127756k reserved, 3497k data, 908k init)
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4802.45 BogoMIPS (lpj=8000723)
kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All
Rights Reserved
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 006ff00000
SMP alternatives: switching to UP code
Freeing SMP alternatives: 23k freed
ACPI: Core revision 20090320
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: AMD Athlon(tm) 64 Processor 4000+ stepping 01
Brought up 1 CPUs
Total of 1 processors activated (4802.45 BogoMIPS).
CPU0 attaching NULL sched-domain.
net_namespace: 1888 bytes
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 0000000070000000 aka 1792M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [70000000, ff70ffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [70000000, fcffffffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Warning (dsobject-0502): Package List length (7) larger than
NumElements count (5), truncated
 [20090320]
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.1: PME# supported from D0 D3hot D3cold
pci 0000:00:03.1: PME# disabled
pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
pci 0000:00:03.2: PME# disabled
pci 0000:00:03.3: PME# supported from D0 D3hot D3cold
pci 0000:00:03.3: PME# disabled
pci 0000:00:07.0: reg 10 32bit mmio: [0xde010000-0xde01ffff]
pci 0000:00:07.0: reg 14 32bit mmio: [0xde000000-0xde00ffff]
pci 0000:00:08.0: reg 10 32bit mmio: [0xde024000-0xde0247ff]
pci 0000:00:08.0: reg 14 32bit mmio: [0xde020000-0xde023fff]
pci 0000:00:08.0: supports D1 D2
pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:08.0: PME# disabled
pci 0000:00:0c.0: reg 10 io port: [0xc000-0xc01f]
pci 0000:00:0c.0: supports D1 D2
pci 0000:00:0c.1: reg 10 io port: [0xc400-0xc407]
pci 0000:00:0c.1: supports D1 D2
pci 0000:00:0d.0: reg 10 io port: [0xc800-0xc807]
pci 0000:00:0d.0: reg 14 io port: [0xcc00-0xcc03]
pci 0000:00:0d.0: reg 18 io port: [0xd000-0xd007]
pci 0000:00:0d.0: reg 1c io port: [0xd400-0xd403]
pci 0000:00:0d.0: reg 20 io port: [0xd800-0xd80f]
pci 0000:00:0d.0: reg 30 32bit mmio: [0xdd000000-0xdd07ffff]
pci 0000:00:0d.0: supports D1 D2
pci 0000:00:0f.0: reg 20 io port: [0xdc00-0xdc0f]
pci 0000:00:10.0: reg 20 io port: [0xe000-0xe01f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20 io port: [0xe400-0xe41f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20 io port: [0xe800-0xe81f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.3: reg 20 io port: [0xec00-0xec1f]
pci 0000:00:10.3: supports D1 D2
pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.3: PME# disabled
pci 0000:00:10.4: reg 10 32bit mmio: [0xde025000-0xde0250ff]
pci 0000:00:10.4: supports D1 D2
pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.4: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:11.0: Enabled onboard AC97/MC97 devices
pci 0000:00:11.5: reg 10 io port: [0x00-0xff]
pci 0000:00:11.5: supports D1 D2
pci 0000:00:11.6: reg 10 io port: [0x00-0xff]
pci 0000:02:00.0: reg 10 32bit mmio: [0xd8000000-0xd8ffffff]
pci 0000:02:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
pci 0000:02:00.0: reg 1c 64bit mmio: [0xd9000000-0xd9ffffff]
pci 0000:02:00.0: reg 30 32bit mmio: [0xda000000-0xda01ffff]
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:02.0: bridge 32bit mmio: [0xd8000000-0xdaffffff]
pci 0000:00:02.0: bridge 32bit mmio pref: [0xc0000000-0xcfffffff]
pci 0000:00:03.0: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:00:03.1: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:05:00.0: reg 10 64bit mmio: [0xdc000000-0xdc003fff]
pci 0000:05:00.0: reg 18 io port: [0xb000-0xb0ff]
pci 0000:05:00.0: reg 30 32bit mmio: [0xdb000000-0xdb01ffff]
pci 0000:05:00.0: supports D1 D2
pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:03.2: bridge io port: [0xb000-0xbfff]
pci 0000:00:03.2: bridge 32bit mmio: [0xdb000000-0xdcffffff]
pci 0000:00:03.3: bridge 32bit mmio: [0x000000-0x0fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 11 12) *5
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 *10 11 12)
ACPI: PCI Interrupt Link [ALKA] (IRQs *20), disabled.
ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
ACPI: PCI Interrupt Link [ALKC] (IRQs *22), disabled.
ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
PCI: Using ACPI for IRQ routing
pci 0000:00:03.0: BAR 8: can't allocate resource
pci 0000:00:03.1: BAR 8: can't allocate resource
pci 0000:00:03.3: BAR 8: can't allocate resource
agpgart-amd64 0000:00:00.0: AGP bridge [1106/0238]
agpgart-amd64 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:02: io resource (0x10-0x1f) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x22-0x3f) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x44-0x5f) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x62-0x63) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x65-0x6f) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x74-0x7f) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x91-0x93) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0xa2-0xbf) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0xe0-0xef) overlaps 0000:00:11.5 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x10-0x1f) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x22-0x3f) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x44-0x5f) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x62-0x63) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x65-0x6f) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x74-0x7f) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0x91-0x93) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0xa2-0xbf) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp 00:02: io resource (0xe0-0xef) overlaps 0000:00:11.6 BAR 0
(0x0-0xff), disabling
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x4000-0x407f has been reserved
system 00:01: ioport range 0x5000-0x500f has been reserved
system 00:02: ioport range 0xb78-0xb7b has been reserved
system 00:02: ioport range 0xf78-0xf7b has been reserved
system 00:02: ioport range 0xa78-0xa7b has been reserved
system 00:02: ioport range 0xe78-0xe7b has been reserved
system 00:02: ioport range 0xbbc-0xbbf has been reserved
system 00:02: ioport range 0xfbc-0xfbf has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:08: iomem range 0xe0000000-0xefffffff has been reserved
system 00:09: iomem range 0xcec00-0xcffff has been reserved
system 00:09: iomem range 0xf0000-0xf7fff could not be reserved
system 00:09: iomem range 0xf8000-0xfbfff could not be reserved
system 00:09: iomem range 0xfc000-0xfffff could not be reserved
system 00:09: iomem range 0x6fef0000-0x6ffeffff could not be reserved
system 00:09: iomem range 0x6fee0000-0x6fefffff could not be reserved
system 00:09: iomem range 0xffff0000-0xffffffff has been reserved
system 00:09: iomem range 0x0-0x9ffff could not be reserved
system 00:09: iomem range 0x100000-0x6fedffff could not be reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:09: iomem range 0xfff80000-0xfffeffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
pci 0000:00:02.0:   IO window: disabled
pci 0000:00:02.0:   MEM window: 0xd8000000-0xdaffffff
pci 0000:00:02.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
pci 0000:00:03.0:   IO window: disabled
pci 0000:00:03.0:   MEM window: disabled
pci 0000:00:03.0:   PREFETCH window: disabled
pci 0000:00:03.1: PCI bridge, secondary bus 0000:04
pci 0000:00:03.1:   IO window: disabled
pci 0000:00:03.1:   MEM window: disabled
pci 0000:00:03.1:   PREFETCH window: disabled
pci 0000:00:03.2: PCI bridge, secondary bus 0000:05
pci 0000:00:03.2:   IO window: 0xb000-0xbfff
pci 0000:00:03.2:   MEM window: 0xdb000000-0xdcffffff
pci 0000:00:03.2:   PREFETCH window: disabled
pci 0000:00:03.3: PCI bridge, secondary bus 0000:06
pci 0000:00:03.3:   IO window: disabled
pci 0000:00:03.3:   MEM window: disabled
pci 0000:00:03.3:   PREFETCH window: disabled
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 31 (level, low) -> IRQ 31
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:03.1: PCI INT B -> GSI 35 (level, low) -> IRQ 35
pci 0000:00:03.1: setting latency timer to 64
pci 0000:00:03.2: PCI INT C -> GSI 39 (level, low) -> IRQ 39
pci 0000:00:03.2: setting latency timer to 64
pci 0000:00:03.3: PCI INT D -> GSI 43 (level, low) -> IRQ 43
pci 0000:00:03.3: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:02: resource 1 mem: [0xd8000000-0xdaffffff]
pci_bus 0000:02: resource 2 pref mem [0xc0000000-0xcfffffff]
pci_bus 0000:03: resource 1 mem: [0x0-0xfffff]
pci_bus 0000:04: resource 1 mem: [0x0-0xfffff]
pci_bus 0000:05: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:05: resource 1 mem: [0xdb000000-0xdcffffff]
pci_bus 0000:06: resource 1 mem: [0x0-0xfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 10628k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1244035689.673:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 838
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:02:00.0: Boot video device
pcieport-driver 0000:00:02.0: irq 48 for MSI/MSI-X
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: irq 49 for MSI/MSI-X
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.1: irq 50 for MSI/MSI-X
pcieport-driver 0000:00:03.1: setting latency timer to 64
pcieport-driver 0000:00:03.2: irq 51 for MSI/MSI-X
pcieport-driver 0000:00:03.2: setting latency timer to 64
pcieport-driver 0000:00:03.3: irq 52 for MSI/MSI-X
pcieport-driver 0000:00:03.3: setting latency timer to 64
aer 0000:00:02.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.1:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.2:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.3:pcie02: AER service couldn't init device: no _OSC support
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010980000, using
6144k, total 65536k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...
bootsplash: silentjpeg size 100719 bytes
bootsplash: ...found (1024x768, 38691 bytes, v3).
Console: switching to colour frame buffer device 124x44
fb0: VESA VGA frame buffer device
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Switched to high resolution mode on CPU 0
PNP: PS/2 appears to have AUX port disabled, if this is incorrect
please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
registered taskstats version 1
Freeing unused kernel memory: 908k freed
Write protecting the kernel read-only data: 5852k
processor ACPI_CPU:00: registered as cooling_device0
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (49 C)
fan PNP0C0B:00: registered as cooling_device1
ACPI: Fan [FAN] (on)
SCSI subsystem initialized
libata version 3.00 loaded.
pata_via 0000:00:0f.0: version 0.3.4
ACPI: PCI Interrupt Link [ALKA] disabled and referenced, BIOS bug
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
pata_via 0000:00:0f.0: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xdc00 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xdc08 irq 15
ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
ata1.00: 160086528 sectors, multi 16: LBA
ata1.01: ATA-5: ST340016A, 3.10, max UDMA/100
ata1.01: 78165360 sectors, multi 16: LBA
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.00: configured for UDMA/33
ata1.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     ATA      ST340016A        3.10 PQ: 0 ANSI: 5
ata2.00: ATAPI: TSSTcorpCD/DVDW TS-H552U, US08, max UDMA/33
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-H552U US08 PQ: 0 ANSI: 5
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
udevd version 128 started
sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda:<5>sd 0:0:1:0: [sdb] 78165360 512-byte hardware sectors: (40.0 GB/37.2 GiB)
 sda1 sda2 sda3 sda4
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1
sd 0:0:1:0: [sdb] Attached SCSI disk
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
uhci_hcd 0000:00:10.0: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e000
Warning! ehci_hcd should always be loaded before uhci_hcd and
ohci_hcd, not after
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30-rc7-git4-neutrino uhci_hcd
usb usb1: SerialNumber: 0000:00:10.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:10.4: PCI INT C -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:10.4: irq 21, io mem 0xde025000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30-rc7-git4-neutrino ehci_hcd
usb usb2: SerialNumber: 0000:00:10.4
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
uhci_hcd 0000:00:10.1: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e400
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30-rc7-git4-neutrino uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.2: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e800
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30-rc7-git4-neutrino uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.3: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 21, io base 0x0000ec00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.30-rc7-git4-neutrino uhci_hcd
usb usb5: SerialNumber: 0000:00:10.3
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: new low speed USB device using uhci_hcd and address 2
usb 1-1: New USB device found, idVendor=04b4, idProduct=0001
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB Mouse
usb 1-1: Manufacturer: Adomax
usb 1-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 1-2: new low speed USB device using uhci_hcd and address 3
usb 1-2: New USB device found, idVendor=046d, idProduct=c00e
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: USB-PS/2 Optical Mouse
usb 1-2: Manufacturer: Logitech
usb 1-2: configuration #1 chosen from 1 choice
input: Logitech USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:10.0/usb1/1-2/1-2:1.0/input/input1
generic-usb 0003:046D:C00E.0002: input,hidraw0: USB HID v1.10 Mouse
[Logitech USB-PS/2 Optical Mouse] on usb-0000:00:10.0-2/input0
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 128 started
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
scsi 1:0:0:0: Attached scsi generic sg2 type 5
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: PC Speaker as /devices/platform/pcspkr/input/input2
pata_cmd64x 0000:00:0d.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
scsi2 : pata_cmd64x
scsi3 : pata_cmd64x
ata3: PATA max UDMA/100 cmd 0xc800 ctl 0xcc00 bmdma 0xd800 irq 18
ata4: PATA max UDMA/100 cmd 0xd000 ctl 0xd400 bmdma 0xd808 irq 18
pata_cmd64x: active 10 recovery 10 setup 3.
pata_cmd64x: active 10 recovery 10 setup 3.
pata_cmd64x: active 10 recovery 10 setup 3.
pata_cmd64x: active 10 recovery 10 setup 3.
input: Adomax USB Mouse as
/devices/pci0000:00/0000:00:10.0/usb1/1-1/1-1:1.0/input/input3
cypress 0003:04B4:0001.0001: input,hidraw1: USB HID v1.00 Mouse
[Adomax USB Mouse] on usb-0000:00:10.0-1/input0
sky2 driver version 1.22
sky2 0000:05:00.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
sky2 0000:05:00.0: setting latency timer to 64
sky2 0000:05:00.0: PCI: Disallowing DAC for device
sky2 0000:05:00.0: Yukon-2 EC chip revision 2
sky2 0000:05:00.0: irq 53 for MSI/MSI-X
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
ACPI: Power Button [PWRB]
sky2 0000:05:00.0: No interrupt generated using MSI, switching to INTx mode.
sky2 eth0: addr 00:11:d8:a1:5b:0e
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
gameport: EMU10K1 is pci0000:00:0c.1/gameport0, io 0xc400, speed 1153kHz
ohci1394 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]
MMIO=[de024000-de0247ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Uniform Multi-Platform E-IDE driver
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram
EMU10K1_Audigy 0000:00:0c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
VIA 82xx Modem 0000:00:11.6: enabling device (0000 -> 0001)
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
VIA 82xx Modem 0000:00:11.6: PCI INT C -> Link[ALKC] -> GSI 22 (level,
low) -> IRQ 22
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d8000017f53d]
VIA 82xx Modem 0000:00:11.6: setting latency timer to 64
VIA 82xx Modem 0000:00:11.6: PCI INT C disabled
VIA 82xx Modem: probe of 0000:00:11.6 failed with error -13
VIA 82xx Audio 0000:00:11.5: enabling device (0000 -> 0001)
VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 22 (level,
low) -> IRQ 22
VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
Adding 1052248k swap on /dev/sda3.  Priority:-1 extents:1 across:1052248k
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, security attributes, realtime, large block/inode
numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sdb1
Ending clean XFS mount for filesystem: sdb1
fuse init (API version 7.11)
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 4000+ processors (1
cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x6
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
Marking TSC unstable due to cpufreq changes
Clocksource tsc unstable (delta = -220379918 ns)
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
sky2 eth0: enabling interface
NET: Registered protocol family 17
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control rx
