Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbYCSTuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbYCSTuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbYCSTda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:33:30 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:51637 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYCSTdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:33:24 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Wed, 19 Mar 2008 14:55:14 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803191108.18577.volker.armin.hemmann@tu-clausthal.de> <47E0FC47.8040902@gmail.com>
In-Reply-To: <47E0FC47.8040902@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CtR4HzXL7d4wEL4"
Message-Id: <200803191455.14380.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CtR4HzXL7d4wEL4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch, 19. M=E4rz 2008, Tejun Heo wrote:
> Volker Armin Hemmann wrote:
> > On Mittwoch, 19. M=E4rz 2008, Tejun Heo wrote:
> >> x UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200
> >>
> >>> irq 315
> >>> [   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port
> >>> 0xf9dfc280 irq 315
> >>> [   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >>> [   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max
> >>> UDMA/133 [   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
> >>> [   38.598405] ata1.00: configured for UDMA/133
> >>> [   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >>> [   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
> >>> [   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
> >>> 0/32) [   39.086268] ata2.00: configured for UDMA/133
> >>
> >> So, just to confirm.  With the updated patch, you don't see any proble=
m,
> >> right?
> >
> > Correct. With the updated patch I don't see problems in 'non-raid' mode.
> > AHCI mode still has problems without nosmi. But that is an entirely
> > different problem, right?
>
> Yeap, can you please post the result of "lspci -nn"?

with AHCI+nosmi, 2.6.24.3:
lspci -nn
00:00.0 RAM memory [0500]: nVidia Corporation MCP65 Memory Controller=20
[10de:0444] (rev a1)
00:01.0 ISA bridge [0601]: nVidia Corporation MCP65 LPC Bridge [10de:0441]=
=20
(rev a2)
00:01.1 SMBus [0c05]: nVidia Corporation MCP65 SMBus [10de:0446] (rev a1)
00:01.2 RAM memory [0500]: nVidia Corporation MCP65 Memory Controller=20
[10de:0445] (rev a1)
00:02.0 USB Controller [0c03]: nVidia Corporation MCP65 USB Controller=20
[10de:0454] (rev a1)
00:02.1 USB Controller [0c03]: nVidia Corporation MCP65 USB Controller=20
[10de:0455] (rev a1)
00:08.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI bridge [10de:0449]=
=20
(rev a1)
00:09.0 IDE interface [0101]: nVidia Corporation MCP65 IDE [10de:0448] (rev=
=20
a1)
00:0a.0 SATA controller [0106]: nVidia Corporation MCP65 AHCI Controller=20
[10de:044d] (rev a1)
00:0b.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:045b] (r=
ev=20
a1)
00:0c.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI Express bridge=20
[10de:045a] (rev a1)
00:0d.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI Express bridge=20
[10de:0458] (rev a1)
00:0e.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI Express bridge=20
[10de:0459] (rev a1)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on]=20
HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on]=20
Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on]=20
DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on]=20
Miscellaneous Control [1022:1103]
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.=20
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 01)
02:08.0 SCSI storage controller [0100]: Adaptec AHA-2944UW / AIC-7884U=20
[9004:8478] (rev 01)
02:09.0 Multimedia audio controller [0401]: Creative Labs SB0400 Audigy2 Va=
lue=20
[1102:0008]
04:00.0 VGA compatible controller [0300]: nVidia Corporation Unknown device=
=20
[10de:0402] (rev a1)

I booted into systemrescuecd (which is the easiest way to get the error and=
 be=20
able to safe the stuff) - lspci is of course identical, but /proc/interrupt=
s=20
is not.

2.6.24.3:
cat /proc/interrupts
           CPU0       CPU1
  0:         57          1   IO-APIC-edge      timer
  1:          1        544   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:          0          1   IO-APIC-fasteoi   acpi
 12:          0          3   IO-APIC-edge      i8042
 17:         22      21598   IO-APIC-fasteoi   nvidia
 18:          0          0   IO-APIC-fasteoi   EMU10K1
 19:          5       1132   IO-APIC-fasteoi   eth0
 22:         30      21627   IO-APIC-fasteoi   ehci_hcd:usb1
 23:         29      23078   IO-APIC-fasteoi   ahci
NMI:          0          0   Non-maskable interrupts
LOC:      41299      60204   Local timer interrupts
RES:      14872      22506   Rescheduling interrupts
CAL:       1783        173   function call interrupts
TLB:       2668       2406   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

systemrescuecd's rescue64 kernel:
           CPU0       CPU1      =20
  0:        148          1   IO-APIC-edge      timer
  1:          0        946   IO-APIC-edge      i8042
  8:          0         25   IO-APIC-edge      rtc
  9:          0          1   IO-APIC-fasteoi   acpi
 12:          0          4   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
 18:          0         16   IO-APIC-fasteoi   aic7xxx
 21:          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 22:          2       8158   IO-APIC-fasteoi   ehci_hcd:usb1
1274:          0          0   PCI-MSI-edge      ahci
1275:          0        453   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:      16082      18972   Local timer interrupts
RES:       7042       6008   Rescheduling interrupts
CAL:         48         45   function call interrupts
TLB:       1836       1843   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          6

dmesg of this is attached.

Gl=FCck Auf,
Volker

--Boundary-00=_CtR4HzXL7d4wEL4
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg_rescue64"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_rescue64"

Linux version 2.6.24.02-fd13-amd64 (root@gentoo64) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #1 SMP Mon Feb 18 20:54:15 UTC 2008
Command line: initrd=initram.igz video=ofonly vga=0 BOOT_IMAGE=rescue64 setkmap=de
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
 BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
 BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
 BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851888) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
end_pfn_map = 1245184
DMI present.
ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       97)
ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 20051117)
ACPI: FACS CFFC0000, 0040
ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       97)
ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       97)
ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       97)
ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       97)
ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         1)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851888) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
No mptable found.
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1245184
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   851888
    0:  1048576 ->  1245184
On node 0 totalpages: 1048399
  DMA zone: 56 pages used for memmap
  DMA zone: 2588 pages reserved
  DMA zone: 1355 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833512 pages, LIFO batch:31
  Normal zone: 2688 pages used for memmap
  Normal zone: 193920 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x2008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 38072 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1028787
Kernel command line: initrd=initram.igz video=ofonly vga=0 BOOT_IMAGE=rescue64 setkmap=de
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
hpet clockevent registered
TSC calibrated against HPET
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 3013.888 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
CPU 0: aperture @ 8000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 8000000
Memory: 4036864k/4980736k available (5710k kernel code, 156184k reserved, 3445k data, 272k init)
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 6032.11 BogoMIPS (lpj=3016058)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12557875
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 6027.45 BogoMIPS (lpj=3013726)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
Brought up 2 CPUs
sizeof(vma)=168 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=224 bytes
sizeof(task_struct)=2176 bytes
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
khelper used greatest stack depth: 6808 bytes left
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
khelper used greatest stack depth: 6536 bytes left
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
Error attaching device data
Error attaching device data
Error attaching device data
Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:08.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
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
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:05: ioport range 0x800-0x80f has been reserved
system 00:05: ioport range 0x2000-0x207f has been reserved
system 00:05: ioport range 0x2080-0x20ff has been reserved
system 00:05: ioport range 0x2400-0x247f has been reserved
system 00:05: ioport range 0x2480-0x24ff has been reserved
system 00:05: ioport range 0x2800-0x287f has been reserved
system 00:05: ioport range 0x2880-0x28ff has been reserved
system 00:05: ioport range 0x2c00-0x2c7f has been reserved
system 00:05: ioport range 0x2c80-0x2cff has been reserved
system 00:05: iomem range 0x0-0x0 could not be reserved
system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0a: ioport range 0x290-0x29f has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xcffff has been reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
PCI: Bridge: 0000:00:08.0
  IO window: d000-dfff
  MEM window: f9f00000-f9ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: c000-cfff
  MEM window: f9e00000-f9efffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: e000-efff
  MEM window: fa000000-febfffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5461k freed
audit: initializing netlink socket (disabled)
audit(1205937134.550:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Loading Reiser4. See www.namesys.com for a description of Reiser4.
squashfs: version 3.3 (2007/10/31) Phillip Lougher
squashfs: LZMA suppport for slax.org by jro
NTFS driver 2.1.29 [Flags: R/O].
fuse init (API version 7.9)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:04:00.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
loop: AES key scrubbing enabled
loop: loaded (max 8 devices)
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.14)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 1.1.18
ixgbe: Copyright (c) 1999-2007 Intel Corporation.
Intel(R) PRO/10GbE Network Driver - version 1.0.126-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Atheros(R) L2 Ethernet Driver - version 2.0.4
Copyright (c) 2007 Atheros Corporation.
tehuti: Tehuti Networks(R) Network Driver, 7.29.3
tehuti: Options: hw_csum 
pcnet32.c:v1.34-NAPI 14.Aug.2007 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
Silan SC92031 PCI Fast Ethernet Adapter driver 2.0c
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:01:00.0 to 64
eth0: RTL8168b/8111b at 0xffffc20000028000, 00:19:66:47:f3:cb, XID 38000000 IRQ 1275
myri10ge: Version 1.3.2-1.287
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
input: Macintosh mouse button emulation as /class/input/input0
Loading iSCSI transport class v2.0-724.
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [LNKA] -> GSI 18 (level, low) -> IRQ 18
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2944 Ultra SCSI adapter>
        aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs

Adaptec aacraid driver 1.1-5[2449]-ms
PCI: Unable to reserve mem region #2:1000@f9fff000 for device 0000:02:08.0
aic7xxx: <Adaptec AHA-2944 Ultra SCSI host adapter> at PCI 2/8/0
aic7xxx: I/O ports already in use, ignoring.
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
QLogic Fibre Channel HBA Driver
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.2
Copyright(c) 2004-2007 Emulex.  All rights reserved.
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
RocketRAID 3xxx SATA Controller driver v1.2 (070830)
stex: Promise SuperTrak EX Driver version: 3.6.0000.1
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:0a.0: version 3.0
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 1274
ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 1274
ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 1274
ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 1274
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 00(40)
scsi_scan_0 used greatest stack depth: 6296 bytes left
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
pata_amd 0000:00:09.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:09.0 to 64
scsi5 : pata_amd
scsi6 : pata_amd
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata6: port disabled. ignoring.
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
Fusion MPT FC Host driver 3.04.06
Fusion MPT SAS Host driver 3.04.06
Fusion MPT misc device (ioctl) driver 3.04.06
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
Fusion MPT LAN driver 3.04.06
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 21, io mem 0xf9dff000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
USB Universal Host Controller Interface driver v3.0
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
usb 1-3: new high speed USB device using ehci_hcd and address 2
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 4 ports detected
usb 1-3.1: new low speed USB device using ehci_hcd and address 3
usb 1-3.1: configuration #1 chosen from 1 choice
usb 1-3.4: new high speed USB device using ehci_hcd and address 4
usb 1-3.4: configuration #1 chosen from 1 choice
scsi7 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
input: Logitech USB Receiver as /class/input/input3
input,hiddev96: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
registered taskstats version 1
Freeing unused kernel memory: 272k freed
Write protecting the kernel read-only data: 2320k
mount used greatest stack depth: 6112 bytes left
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
xor: automatically using best checksumming function: generic_sse
   generic_sse:  9264.000 MB/sec
xor: using function: generic_sse (9264.000 MB/sec)
async_tx: api initialized (sync-only)
raid6: int64x1   2746 MB/s
raid6: int64x2   3542 MB/s
raid6: int64x4   3410 MB/s
raid6: int64x8   2457 MB/s
raid6: sse2x1    4222 MB/s
raid6: sse2x2    5554 MB/s
raid6: sse2x4    5664 MB/s
raid6: using algorithm sse2x4 (5664 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: raid10 personality registered for level 10
JFS: nTxBlock = 8192, nTxLock = 65536
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
usb-storage: device scan complete
scsi 7:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.19 PQ: 0 ANSI: 0
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 7:0:0:0: Attached scsi CD-ROM sr0
sr 7:0:0:0: Attached scsi generic sg0 type 5
mount used greatest stack depth: 4408 bytes left
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
mount used greatest stack depth: 4376 bytes left
input: PC Speaker as /class/input/input4
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input6
ACPI: Power Button (CM) [PWRB]
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
r8169: eth0: link up
r8169: eth0: link up
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19  Wed Sep 12 14:08:38 PDT 2007
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
usb 1-3.2: new high speed USB device using ehci_hcd and address 5
usb 1-3.2: configuration #1 chosen from 1 choice
scsi8 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 8:0:0:0: Direct-Access     Generic  IC1210        CF 1.9C PQ: 0 ANSI: 0 CCS
scsi 8:0:0:1: Direct-Access     Generic  IC1210        MS 1.9C PQ: 0 ANSI: 0 CCS
scsi 8:0:0:2: Direct-Access     Generic  IC1210    MMC/SD 1.9C PQ: 0 ANSI: 0 CCS
scsi 8:0:0:3: Direct-Access     Generic  IC1210        SM 1.9C PQ: 0 ANSI: 0 CCS
sd 8:0:0:0: [sda] Attached SCSI removable disk
sd 8:0:0:0: Attached scsi generic sg1 type 0
sd 8:0:0:1: [sdb] Attached SCSI removable disk
sd 8:0:0:1: Attached scsi generic sg2 type 0
sd 8:0:0:2: [sdc] 122624 512-byte hardware sectors (63 MB)
sd 8:0:0:2: [sdc] Write Protect is off
sd 8:0:0:2: [sdc] Mode Sense: 4b 00 00 08
sd 8:0:0:2: [sdc] Assuming drive cache: write through
sd 8:0:0:2: [sdc] 122624 512-byte hardware sectors (63 MB)
sd 8:0:0:2: [sdc] Write Protect is off
sd 8:0:0:2: [sdc] Mode Sense: 4b 00 00 08
sd 8:0:0:2: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 8:0:0:2: [sdc] Attached SCSI removable disk
sd 8:0:0:2: Attached scsi generic sg3 type 0
sd 8:0:0:3: [sdd] Attached SCSI removable disk
sd 8:0:0:3: Attached scsi generic sg4 type 0

--Boundary-00=_CtR4HzXL7d4wEL4--
