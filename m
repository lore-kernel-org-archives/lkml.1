Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZLXMNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZLXMNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZLXMNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:13:46 -0500
Received: from mailget.neusoft.com ([210.83.25.69]:54186 "EHLO
	mailgate.neusoft.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZLXMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:13:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5841"; a="5749369"
Date: Thu, 24 Dec 2009 20:15:44 +0800 (CST)
From: fengxiangjun <fengxiangjun@neusoft.com>
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
In-reply-to: <alpine.LNX.2.00.0912241557170.1682@darkstar.example.net>
X-X-Sender: fengxj@darkstar.example.net
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Message-id: <alpine.LNX.2.00.0912242010350.1691@darkstar.example.net>
MIME-version: 1.0
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
 <4B30134C.1050609@gmail.com>
 <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
 <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com>
 <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net>
 <4B31DB17.4050509@kernel.org>
 <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
 <4B331957.7030906@kernel.org>
 <alpine.LNX.2.00.0912241535340.1682@darkstar.example.net>
 <4B331D93.2010000@kernel.org>
 <alpine.LNX.2.00.0912241557170.1682@darkstar.example.net>
Content-Transfer-Encoding: 7bit
Content-Type: TEXT/PLAIN; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Hmmm.... can you please try netconsole?  Netconsole usually doesn't
> > introduce much delay and should be able to extract the log without
> > affecting timings.
> > 
> > Thanks.
> > 
> > -- 
> > tejun
> > 

Here is it, and I hope it help. And merry xmas, ;)

Linux version 2.6.32.2 (root@darkstar) (gcc version 4.4.2 (GCC) ) #3 SMP Thu Dec 24 19:21:27 CST 2009
Command line: BOOT_IMAGE=problem ro root=803 netconsole=1111@10.1.4.8/eth0,2222@10.1.4.183/00:16:35:77:8d:f9
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000df7b1d00 (usable)
 BIOS-e820: 00000000df7b1d00 - 00000000df7b3d00 (ACPI NVS)
 BIOS-e820: 00000000df7b3d00 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed40000 (reserved)
 BIOS-e820: 00000000fed45000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
DMI 2.4 present.
last_pfn = 0x120000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xdf7b1 max_arch_pfn = 0x400000000
init_memory_mapping: 0000000000000000-00000000df7b1000
init_memory_mapping: 0000000100000000-0000000120000000
ACPI: RSDP 00000000000e7610 00014 (v00 COMPAQ)
ACPI: RSDT 00000000df7c3d40 00040 (v01 HPQOEM SLIC-BPC 20070413      00000000)
ACPI: FACP 00000000df7c3de8 00074 (v01 COMPAQ BROADH2O 00000001      00000000)
ACPI: DSDT 00000000df7c4143 094FE (v01 COMPAQ DSDT_PRJ 00000001 MSFT 0100000E)
ACPI: FACS 00000000df7c3d00 00040
ACPI: APIC 00000000df7c3e5c 00068 (v01 COMPAQ BROADH2O 00000001      00000000)
ACPI: ASF! 00000000df7c3ec4 00063 (v32 COMPAQ BROADH2O 00000001      00000000)
ACPI: MCFG 00000000df7c3f27 0003C (v01 COMPAQ BROADH2O 00000001      00000000)
ACPI: TCPA 00000000df7c3f63 00032 (v01 COMPAQ BROADH2O 00000001      00000000)
ACPI: SLIC 00000000df7c3f95 00176 (v01 HPQOEM SLIC-BPC 00000001      00000000)
ACPI: HPET 00000000df7c410b 00038 (v01 COMPAQ BROADH2O 00000001      00000000)
(7 early reservations) ==> bootmem [0000000000 - 0120000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 000159032c]    TEXT DATA BSS ==> [0001000000 - 000159032c]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0001591000 - 00015910f3]              BRK ==> [0001591000 - 00015910f3]
  #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #6 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00120000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000df7b1
    0: 0x00100000 -> 0x00120000
ACPI: PM-Timer IO Port: 0xf808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at e0000000 (gap: e0000000:14000000)
NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff880028200000 s70616 r8192 d23592 u1048576
pcpu-alloc: s70616 r8192 d23592 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030120
Kernel command line: BOOT_IMAGE=problem ro root=803 netconsole=1111@10.1.4.8/eth0,2222@10.1.4.183/00:16:35:77:8d:f9
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 4046908k/4718592k available (3209k kernel code, 533184k absent, 137620k reserved, 1762k data, 376k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:320
Console: colour VGA+ 80x25
console [tty0] enabled
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 2394.202 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.40 BogoMIPS (lpj=23942020)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20090903
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4788.12 BogoMIPS (lpj=23940639)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
CPU1: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (9576.53 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f4000000 segment 0 buses 0 - 63
PCI: MCFG area at f4000000 reserved in E820
PCI: Using MMCONFIG at f4000000 - f7ffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88011f8132e0), AE_ALREADY_EXISTS
ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
ACPI Warning for \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20090903/nspredef-336)
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region f800-f87f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region fa00-fa3f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0400 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0480 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0cb0 (mask 000f)
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.5: PME# supported from D3hot
pci 0000:00:1f.5: PME# disabled
pci 0000:3f:00.0: PME# supported from D3hot D3cold
pci 0000:3f:00.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
ACPI Error (dsfield-0143): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88011f8132e0), AE_ALREADY_EXISTS
ACPI Warning for \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20090903/nspredef-336)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0d: io resource (0xf800-0xf81f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf820-0xf83f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf840-0xf85f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf860-0xf87f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0d: ioport range 0x400-0x41f has been reserved
system 00:0d: ioport range 0x420-0x43f has been reserved
system 00:0d: ioport range 0x440-0x45f has been reserved
system 00:0d: ioport range 0x460-0x47f has been reserved
system 00:0d: ioport range 0x480-0x48f has been reserved
system 00:0d: ioport range 0xcb0-0xcbf has been reserved
system 00:0d: ioport range 0xfa00-0xfa3f has been reserved
system 00:0d: ioport range 0xfc00-0xfc7f has been reserved
system 00:0d: ioport range 0xfc80-0xfcff has been reserved
system 00:0d: ioport range 0xfe00-0xfe7f has been reserved
system 00:0d: ioport range 0xfe80-0xfeff has been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0x100000-0xdfffffff could not be reserved
system 00:0e: iomem range 0xe4000-0xfffff could not be reserved
system 00:0e: iomem range 0xfec01000-0xfecfffff has been reserved
system 00:0e: iomem range 0xfed00400-0xfed3ffff has been reserved
system 00:0e: iomem range 0xfed40000-0xffffffff could not be reserved
system 00:0e: iomem range 0xf4000000-0xf7ffffff has been reserved
system 00:0e: iomem range 0xcdc00-0xe3fff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:20
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xf0000000-0xf01fffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000f0200000-0x000000f03fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:3f
pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
pci 0000:00:1c.1:   MEM window: 0xf0600000-0xf08fffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f0900000-0x000000f0afffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: disabled
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
fuse init (API version 7.13)
msgmni has been set to 7905
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PBTN]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: SSDT 00000000df7ce602 00320 (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
Generic RTC Driver v1.07
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965Q Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
loop: module loaded
ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x11c0 irq 14
ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x11c8 irq 15
ata_piix 0000:00:1f.5: PCI INT B -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x1218 ctl 0x1230 bmdma 0x11e0 irq 18
ata4: SATA max UDMA/133 cmd 0x1220 ctl 0x1234 bmdma 0x11e8 irq 18
tg3.c:v3.102 (September 1, 2009)
tg3 0000:3f:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
eth0: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:1b:78:b7:76:d8
eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: local port 1111
netconsole: local IP 10.1.4.8
netconsole: interface eth0
netconsole: remote port 2222
netconsole: remote IP 10.1.4.183
netconsole: remote ethernet address 00:16:35:77:8d:f9
netconsole: device eth0 not up yet, forcing it
ata2.00: XXX debounce start, SStatus=0
ata1.00: XXX debounce start, SStatus=0
ata3: XXX debounce start, SStatus=0
ata4: XXX debounce start, SStatus=0
ata1.00: XXX debounce done, SStatus=0, DET stable for 520 msecs
ata2.00: XXX debounce done, SStatus=0, DET stable for 520 msecs
ata3: XXX debounce done, SStatus=0, DET stable for 520 msecs
ata4: XXX debounce done, SStatus=0, DET stable for 530 msecs
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata1.01: XXX debounce start, SStatus=4
ata2.01: XXX debounce start, SStatus=4
ata2.01: XXX debounce done, SStatus=4, DET stable for 520 msecs
ata1.01: XXX debounce done, SStatus=4, DET stable for 530 msecs
ata2.00: SATA link down (SStatus 4 SControl 300)
ata2.01: SATA link down (SStatus 4 SControl 300)
ata1.00: SATA link down (SStatus 0 SControl 301)
ata1.01: SATA link down (SStatus 4 SControl 300)
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
console [netcon0] enabled
netconsole: network logging started
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xf0504000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf0504400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001100
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001120
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001140
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001160
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.21.
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
ALSA device list:
  #0: HDA Intel at 0xf0500000 irq 21
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
VFS: Cannot open root device "803" or unknown-block(8,3)
Please append a correct "root=" boot option; here are the available partitions:
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,3)
Pid: 1, comm: swapper Not tainted 2.6.32.2 #3
Call Trace:
 [<ffffffff8131d0b3>] panic+0x75/0x11c
 [<ffffffff814eff0d>] mount_block_root+0x257/0x275
 [<ffffffff814eff81>] mount_root+0x56/0x5a
 [<ffffffff814f00b9>] prepare_namespace+0x134/0x161
 [<ffffffff814ef675>] kernel_init+0x192/0x1a2
 [<ffffffff81029a7a>] child_rip+0xa/0x20
 [<ffffffff814ef4e3>] ? kernel_init+0x0/0x1a2
 [<ffffffff81029a70>] ? child_rip+0x0/0x20
---------------------------------------------------------------------------------------------------
Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s) 
is intended only for the use of the intended recipient and may be confidential and/or privileged of 
Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is 
not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying 
is strictly prohibited, and may be unlawful.If you have received this communication in error,please 
immediately notify the sender by return e-mail, and delete the original message and all copies from 
your system. Thank you. 
---------------------------------------------------------------------------------------------------

