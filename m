Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbXF3RrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbXF3RrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXF3RrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 13:47:03 -0400
Received: from proxy02.veka.com ([195.145.55.2]:41195 "EHLO proxy02.veka.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbXF3Rq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 13:46:59 -0400
From: Frank Fiene <ffiene@veka.com>
Organization: VEKA AG
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel doesn't recognize complete memory
Date: Sat, 30 Jun 2007 19:46:46 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, tytso@thunk.org
References: <fa.8WY71RLqV3Tqf8TkTOMOg/ub4Cs@ifi.uio.no> <46859340.7020206@shaw.ca>
In-Reply-To: <46859340.7020206@shaw.ca>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GcphGzEW+0rgn8a"
Message-Id: <200706301946.46918.ffiene@veka.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_GcphGzEW+0rgn8a
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Samstag, 30. Juni 2007, Robert Hancock wrote:
> Frank Fiene wrote:
> > Lenovo Z61p, Intel Core2 Duo T7200
> >
> > I have 4GB RAM installed and BIOS recognize 4GB RAM.
> > Linux kernel (Ubuntu-7.04, 32bit-PAE and 64bit, openSUSE-10.2
> > 32bit-PAE and 64bit) tells me: only 3GB of RAM are installed.
> >
> > Any other user with a 4GB Thinkpad? tytso?
> >
> > What can i do? Please help!
> >
> > Regards
> > Frank
>
> Please post your bootup dmesg output. If your chipset doesn't support
> memory remapping above 4GB or the BIOS doesn't enable it, you won't
> be able to use all 4GB of memory.

Here is me dmesg output, fist 400 lines.

Regards
Frank

--Boundary-00=_GcphGzEW+0rgn8a
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.18.8-0.3-bigsmp (geeko@buildhost) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #1 SMP Tue Apr 17 08:42:35 UTC 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
 BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI data)
 BIOS-e820: 00000000bfedf000 - 00000000bff00000 (ACPI NVS)
 BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
2174MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f67e0
NX (Execute Disable) protection: active
On node 0 totalpages: 786128
  DMA zone: 4096 pages, LIFO batch:0
  Normal zone: 225280 pages, LIFO batch:31
  HighMem zone: 556752 pages, LIFO batch:31
DMI present.
Using APIC driver default
ACPI: RSDP (v002 LENOVO                                ) @ 0x000f67a0
ACPI: XSDT (v001 LENOVO TP-7F    0x00002180  LTP 0x00000000) @ 0xbfed1c26
ACPI: FADT (v003 LENOVO TP-7F    0x00002180 LNVO 0x00000001) @ 0xbfed1d00
ACPI: SSDT (v001 LENOVO TP-7F    0x00002180 MSFT 0x0100000e) @ 0xbfed1eb4
ACPI: ECDT (v001 LENOVO TP-7F    0x00002180 LNVO 0x00000001) @ 0xbfedebc1
ACPI: TCPA (v002 LENOVO TP-7F    0x00002180 LNVO 0x00000001) @ 0xbfedec13
ACPI: MADT (v001 LENOVO TP-7F    0x00002180 LNVO 0x00000001) @ 0xbfedec45
ACPI: MCFG (v001 LENOVO TP-7F    0x00002180 LNVO 0x00000001) @ 0xbfedecad
ACPI: HPET (v001 LENOVO TP-7F    0x00002180 LNVO 0x00000001) @ 0xbfedece9
ACPI: SLIC (v001 LENOVO TP-7F    0x00002180  LTP 0x00000000) @ 0xbfedee62
ACPI: BOOT (v001 LENOVO TP-7F    0x00002180  LTP 0x00000001) @ 0xbfedefd8
ACPI: SSDT (v001 LENOVO TP-7F    0x00002180 INTL 0x20050513) @ 0xbfef2686
ACPI: SSDT (v001 LENOVO TP-7F    0x00002180 INTL 0x20050513) @ 0xbfef28e5
ACPI: SSDT (v001 LENOVO TP-7F    0x00002180 INTL 0x20050513) @ 0xbfef298b
ACPI: SSDT (v001 LENOVO TP-7F    0x00002180 INTL 0x20050513) @ 0xbfef2e82
ACPI: DSDT (v001 LENOVO TP-7F    0x00002180 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
Detected 1995.077 MHz processor.
Built 1 zonelists.  Total pages: 786128
Kernel command line: root=/dev/sda2 vga=0x375 resume=/dev/sda1 splash=silent elevator=deadline PROFILE=haltern
bootsplash: silent mode.
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3110924k/3144512k available (1703k kernel code, 32200k reserved, 1103k data, 200k init, 2227008k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000 (virtual 0xf8800000), IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Using HPET for base-timer
Calibrating delay using timer specific routine.. 3994.38 BogoMIPS (lpj=7988774)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
CPU: After vendor identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00000940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
checking if image is initramfs... it is
Freeing initrd memory: 3266k freed
ACPI: Core revision 20060707
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.09 BogoMIPS (lpj=7980196)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
CPU: After vendor identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00000940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
Total of 2 processors activated (7984.48 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 2 CPUs: 
CPU#0 had -154 usecs TSC skew, fixed it up.
CPU#1 had 154 usecs TSC skew, fixed it up.
Brought up 2 CPUs
migration_cost=36
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Found ECDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: Embedded Controller [EC] (gpe 28) interrupt mode.
ACPI: Power Resource [PUBS] (on)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: ee000000-ee0fffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: ee100000-ee1fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-4fff
  MEM window: ec000000-edffffff
  PREFETCH window: e4000000-e40fffff
PCI: Bridge: 0000:00:1c.2
  IO window: 5000-6fff
  MEM window: e8000000-e9ffffff
  PREFETCH window: e4100000-e41fffff
PCI: Bridge: 0000:00:1c.3
  IO window: 7000-8fff
  MEM window: ea000000-ebffffff
  PREFETCH window: e4200000-e42fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 00009000-000090ff
  IO window: 00009400-000094ff
  PREFETCH window: e0000000-e1ffffff
  MEM window: e6000000-e7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-cfff
  MEM window: e4300000-e7ffffff
  PREFETCH window: e0000000-e3ffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 177
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 185
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 193
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 201
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 169
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x35 set to 0x1
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1183129582.972:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, using 15000k, total 16384k
vesafb: mode is 1600x1200x16, linelength=3200, pages=3
vesafb: protected mode interface info at c000:afd4
vesafb: pmi: set display start = c00cb05c, set palette = c00cb118
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...<6> silentjpeg size 112064 bytes,<6>...found (1600x1200, 62428 bytes, v3).
Console: switching to colour frame buffer device 196x71
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
NET: Registered protocol family 1
Using IPI No-Shortcut mode
ACPI: (supports S0 S3 S4 S5)
Freeing unused kernel memory: 200k freed
Time: tsc clocksource has been installed.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SCSI subsystem initialized
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu0Ist] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu0Cst] [20060707]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu1Ist] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu1Cst] [20060707]
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (34 C)
ACPI: Thermal Zone [THM1] (39 C)
Time: hpet clocksource has been installed.
ICH7: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 169
ICH7: chipset revision 2
ICH7: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1880-0x1887, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input2
hda: HL-DT-ST DVDRAM GMA-4082N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
libata version 2.00 loaded.
ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xF883A500 ctl 0x0 bmdma 0x0 irq 66
ata2: SATA max UDMA/133 cmd 0xF883A580 ctl 0x0 bmdma 0x0 irq 66
ata3: SATA max UDMA/133 cmd 0xF883A600 ctl 0x0 bmdma 0x0 irq 66
ata4: SATA max UDMA/133 cmd 0xF883A680 ctl 0x0 bmdma 0x0 irq 66
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/100, 195371568 sectors: LBA48 
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/100
scsi1 : ahci
ata2: SATA link down (SStatus 0 SControl 0)
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 0)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 0)
  Vendor: ATA       Model: ST910021AS        Rev: 4.06
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
sd 0:0:0:0: Attached scsi generic sg0 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input3
lp: driver loaded but no devices found
usbcore: registered new driver usbfs
usbcore: registered new driver hub
usbcore: registered new driver snd-usb-audio
intel_rng: FWH not detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 169, io base 0x00001800
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.18.8-0.3-bigsmp uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Linux agpgart interface v0.101 (c) Dave Jones
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 74
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 74, io base 0x00001820
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.18.8-0.3-bigsmp uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 82
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 82, io base 0x00001840
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.18.8-0.3-bigsmp uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 90
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ieee1394: Initialized config rom entry `ip1394'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 90, io mem 0xee404000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: EHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.18.8-0.3-bigsmp ehci_hcd
usb usb4: SerialNumber: 0000:00:1d.7
NET: Registered protocol family 23
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found

--Boundary-00=_GcphGzEW+0rgn8a--
