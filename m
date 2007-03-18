Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXCRRv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXCRRv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 13:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbXCRRv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 13:51:59 -0400
Received: from www17.your-server.de ([213.133.104.17]:1460 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbXCRRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 13:51:54 -0400
Message-ID: <45FD7C88.1020002@m3y3r.de>
Date: Sun, 18 Mar 2007 18:53:12 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in pci_restore_msi_state
References: <45FBE22A.8030304@m3y3r.de>
In-Reply-To: <45FBE22A.8030304@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer schrieb:
> Hello everybody.
>
> I get this bug after suspending to disk twice:
>
> http://m3y3r.de/bilder/Bug-pci_restore_msi_state.png
>
> This happens with current git head cd05a1f818073a623455a58e756c5b419fc98db9.
>
>
>
>
>   
More info, search for "entry= NULL":
Linux version 2.6.21-rc4 (thomas@hotzenplotz) (gcc version 4.1.2 (Gentoo
4.1.2)) #252 SMP Sun Mar 18 18:22:48 CET 2007
EFI: EFI v16360.9876 by Apple
 ACPI=0x3fefd000 <6> ACPI 2.0=0x3fefd014 <6> SMBIOS=0x3feba000
126MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 261817) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261817
early_node_map[1] active PFN ranges
    0:        0 ->   261817
On node 0 totalpages: 261817
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 253 pages used for memmap
  HighMem zone: 32188 pages, LIFO batch:7
DMI 2.4 present.
ACPI: RSDP 3FEFD014, 0024 (r2 APPLE )
ACPI: XSDT 3FEFD120, 0074 (r1 APPLE   Apple00       55       1000013)
ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       55 Loki       5F)
ACPI: DSDT 3FEF0000, 48C0 (r1 APPLE  MacBookP    10001 INTL 20050309)
ACPI: FACS 3FEBB000, 0040
ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ASF! 3FEF7000, 009C (r32 APPLE   Apple00        1 Loki       5F)
ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: SSDT 3FEB6000, 064F (r1 APPLE   SataPri     1000 INTL 20050309)
ACPI: SSDT 3FEB5000, 069C (r1 APPLE   SataSec     1000 INTL 20050309)
ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
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
Allocating PCI resources starting at 10100000 (gap: 10000000:00400000)
Built 1 zonelists.  Total pages: 259772
Kernel command line: BOOT_IMAGE=atapi0:\EFI\gentoo\bzImage  video=imacfb
root=/dev/sda2 pci_multithread_probe=0 resume=/dev/sda10
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c038c000 soft=c038a000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Oops: efitime: can't read time status: 0x80000007
Detected 1831.031 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1032304k/1047268k available (1705k kernel code, 12028k reserved,
654k data, 196k init, 127372k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0354000 - 0xc0385000   ( 196 kB)
      .data : 0xc02aa5b7 - 0xc034e134   ( 654 kB)
      .text : 0xc0100000 - 0xc02aa5b7   (1705 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 3666.66 BogoMIPS
(lpj=6108263)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000
0000c1a9 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9
00000000 00000000
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c038d000 soft=c038b000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3663.38 BogoMIPS
(lpj=6103016)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000
0000c1a9 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9
00000000 00000000
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Total of 2 processors activated (7329.04 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=45
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:ACPI0007:01
PM: Adding info for acpi:device:00
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:APP0002:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:video:00
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:device:1e
PM: Adding info for acpi:device:1f
PM: Adding info for acpi:device:20
PM: Adding info for acpi:device:21
PM: Adding info for acpi:device:22
PM: Adding info for acpi:device:23
PM: Adding info for acpi:device:24
PM: Adding info for acpi:device:25
PM: Adding info for acpi:device:26
PM: Adding info for acpi:device:27
PM: Adding info for acpi:device:28
PM: Adding info for acpi:device:29
PM: Adding info for acpi:device:2a
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:APP0001:00
PM: Adding info for acpi:ACPI0008:00
PM: Adding info for acpi:APP0003:00
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:IFX0101:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:INT0800:00
PM: Adding info for acpi:PNP0103:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:device:2b
PM: Adding info for acpi:device:2c
PM: Adding info for acpi:device:2d
PM: Adding info for acpi:device:2e
PM: Adding info for acpi:device:2f
PM: Adding info for acpi:device:30
PM: Adding info for acpi:device:31
PM: Adding info for acpi:device:32
PM: Adding info for acpi:device:33
PM: Adding info for acpi:device:34
PM: Adding info for acpi:device:35
PM: Adding info for acpi:device:36
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:thermal:00
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:07.0
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.1
PM: Adding info for pci:0000:00:1c.2
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.3
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:02:00.0
PM: Adding info for pci:0000:03:00.0
PM: Adding info for pci:0000:0c:03.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
pnp: PnP ACPI: found 10 devices
SCSI subsystem initialized
libata version 2.20 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
pnp: 00:01: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
pnp: 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
pnp: 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:oldmem
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
PCI: Bridge: 0000:00:01.0
  IO window: 3000-3fff
  MEM window: 90300000-903fffff
  PREFETCH window: 80000000-87ffffff
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: 90200000-902fffff
  PREFETCH window: 3ff00000-3fffffff
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: 90100000-901fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: 1000-1fff
  MEM window: 8c100000-900fffff
  PREFETCH window: 88000000-8bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 8c000000-8c0fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Enabling device 0000:00:1c.2 (0000 -> 0003)
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
pci_enable_msi: irq= 16
pci_enable_msi: msi_enabled= 0
Allocate Port Service[0000:00:01.0:pcie00]
PM: Adding info for pci_express:0000:00:01.0:pcie00
Allocate Port Service[0000:00:01.0:pcie03]
PM: Adding info for pci_express:0000:00:01.0:pcie03
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
pci_enable_msi: irq= 17
pci_enable_msi: msi_enabled= 0
Allocate Port Service[0000:00:1c.0:pcie00]
PM: Adding info for pci_express:0000:00:1c.0:pcie00
Allocate Port Service[0000:00:1c.0:pcie02]
PM: Adding info for pci_express:0000:00:1c.0:pcie02
Allocate Port Service[0000:00:1c.0:pcie03]
PM: Adding info for pci_express:0000:00:1c.0:pcie03
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
pci_enable_msi: irq= 16
pci_enable_msi: msi_enabled= 0
Allocate Port Service[0000:00:1c.1:pcie00]
PM: Adding info for pci_express:0000:00:1c.1:pcie00
Allocate Port Service[0000:00:1c.1:pcie02]
PM: Adding info for pci_express:0000:00:1c.1:pcie02
Allocate Port Service[0000:00:1c.1:pcie03]
PM: Adding info for pci_express:0000:00:1c.1:pcie03
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
pci_enable_msi: irq= 18
pci_enable_msi: msi_enabled= 0
Allocate Port Service[0000:00:1c.2:pcie00]
PM: Adding info for pci_express:0000:00:1c.2:pcie00
Allocate Port Service[0000:00:1c.2:pcie02]
PM: Adding info for pci_express:0000:00:1c.2:pcie02
Allocate Port Service[0000:00:1c.2:pcie03]
PM: Adding info for pci_express:0000:00:1c.2:pcie03
PM: Adding info for platform:vesafb.0
imacfb: MacBookPro1,1 detected - set system to 0
PM: Adding info for platform:imacfb.0
imacfb: framebuffer at 0x80010000, mapped to 0xf8900000, using 10350k,
total 16384k
imacfb: mode is 1440x900x32, linelength=5888, pages=1
imacfb: scrolling: redraw
imacfb: Truecolor: size=8:8:8:8, shift=24:16:8:0
PM: Adding info for No Bus:fb0
PM: Adding info for No Bus:vtcon1
Console: switching to colour frame buffer device 180x56
fb0: IMAC VGA frame buffer device
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:ptyp0
PM: Adding info for No Bus:ptyp1
PM: Adding info for No Bus:ptyp2
PM: Adding info for No Bus:ptyp3
PM: Adding info for No Bus:ptyp4
PM: Adding info for No Bus:ptyp5
PM: Adding info for No Bus:ptyp6
PM: Adding info for No Bus:ptyp7
PM: Adding info for No Bus:ptyp8
PM: Adding info for No Bus:ptyp9
PM: Adding info for No Bus:ptypa
PM: Adding info for No Bus:ptypb
PM: Adding info for No Bus:ptypc
PM: Adding info for No Bus:ptypd
PM: Adding info for No Bus:ptype
PM: Adding info for No Bus:ptypf
PM: Adding info for No Bus:ptyq0
PM: Adding info for No Bus:ptyq1
PM: Adding info for No Bus:ptyq2
PM: Adding info for No Bus:ptyq3
PM: Adding info for No Bus:ptyq4
PM: Adding info for No Bus:ptyq5
PM: Adding info for No Bus:ptyq6
PM: Adding info for No Bus:ptyq7
PM: Adding info for No Bus:ptyq8
PM: Adding info for No Bus:ptyq9
PM: Adding info for No Bus:ptyqa
PM: Adding info for No Bus:ptyqb
PM: Adding info for No Bus:ptyqc
PM: Adding info for No Bus:ptyqd
PM: Adding info for No Bus:ptyqe
PM: Adding info for No Bus:ptyqf
PM: Adding info for No Bus:ptyr0
PM: Adding info for No Bus:ptyr1
PM: Adding info for No Bus:ptyr2
PM: Adding info for No Bus:ptyr3
PM: Adding info for No Bus:ptyr4
PM: Adding info for No Bus:ptyr5
PM: Adding info for No Bus:ptyr6
PM: Adding info for No Bus:ptyr7
PM: Adding info for No Bus:ptyr8
PM: Adding info for No Bus:ptyr9
PM: Adding info for No Bus:ptyra
PM: Adding info for No Bus:ptyrb
PM: Adding info for No Bus:ptyrc
PM: Adding info for No Bus:ptyrd
PM: Adding info for No Bus:ptyre
PM: Adding info for No Bus:ptyrf
PM: Adding info for No Bus:ptys0
PM: Adding info for No Bus:ptys1
PM: Adding info for No Bus:ptys2
PM: Adding info for No Bus:ptys3
PM: Adding info for No Bus:ptys4
PM: Adding info for No Bus:ptys5
PM: Adding info for No Bus:ptys6
PM: Adding info for No Bus:ptys7
PM: Adding info for No Bus:ptys8
PM: Adding info for No Bus:ptys9
PM: Adding info for No Bus:ptysa
PM: Adding info for No Bus:ptysb
PM: Adding info for No Bus:ptysc
PM: Adding info for No Bus:ptysd
PM: Adding info for No Bus:ptyse
PM: Adding info for No Bus:ptysf
PM: Adding info for No Bus:ptyt0
PM: Adding info for No Bus:ptyt1
PM: Adding info for No Bus:ptyt2
PM: Adding info for No Bus:ptyt3
PM: Adding info for No Bus:ptyt4
PM: Adding info for No Bus:ptyt5
PM: Adding info for No Bus:ptyt6
PM: Adding info for No Bus:ptyt7
PM: Adding info for No Bus:ptyt8
PM: Adding info for No Bus:ptyt9
PM: Adding info for No Bus:ptyta
PM: Adding info for No Bus:ptytb
PM: Adding info for No Bus:ptytc
PM: Adding info for No Bus:ptytd
PM: Adding info for No Bus:ptyte
PM: Adding info for No Bus:ptytf
PM: Adding info for No Bus:ptyu0
PM: Adding info for No Bus:ptyu1
PM: Adding info for No Bus:ptyu2
PM: Adding info for No Bus:ptyu3
PM: Adding info for No Bus:ptyu4
PM: Adding info for No Bus:ptyu5
PM: Adding info for No Bus:ptyu6
PM: Adding info for No Bus:ptyu7
PM: Adding info for No Bus:ptyu8
PM: Adding info for No Bus:ptyu9
PM: Adding info for No Bus:ptyua
PM: Adding info for No Bus:ptyub
PM: Adding info for No Bus:ptyuc
PM: Adding info for No Bus:ptyud
PM: Adding info for No Bus:ptyue
PM: Adding info for No Bus:ptyuf
PM: Adding info for No Bus:ptyv0
PM: Adding info for No Bus:ptyv1
PM: Adding info for No Bus:ptyv2
PM: Adding info for No Bus:ptyv3
PM: Adding info for No Bus:ptyv4
PM: Adding info for No Bus:ptyv5
PM: Adding info for No Bus:ptyv6
PM: Adding info for No Bus:ptyv7
PM: Adding info for No Bus:ptyv8
PM: Adding info for No Bus:ptyv9
PM: Adding info for No Bus:ptyva
PM: Adding info for No Bus:ptyvb
PM: Adding info for No Bus:ptyvc
PM: Adding info for No Bus:ptyvd
PM: Adding info for No Bus:ptyve
PM: Adding info for No Bus:ptyvf
PM: Adding info for No Bus:ptyw0
PM: Adding info for No Bus:ptyw1
PM: Adding info for No Bus:ptyw2
PM: Adding info for No Bus:ptyw3
PM: Adding info for No Bus:ptyw4
PM: Adding info for No Bus:ptyw5
PM: Adding info for No Bus:ptyw6
PM: Adding info for No Bus:ptyw7
PM: Adding info for No Bus:ptyw8
PM: Adding info for No Bus:ptyw9
PM: Adding info for No Bus:ptywa
PM: Adding info for No Bus:ptywb
PM: Adding info for No Bus:ptywc
PM: Adding info for No Bus:ptywd
PM: Adding info for No Bus:ptywe
PM: Adding info for No Bus:ptywf
PM: Adding info for No Bus:ptyx0
PM: Adding info for No Bus:ptyx1
PM: Adding info for No Bus:ptyx2
PM: Adding info for No Bus:ptyx3
PM: Adding info for No Bus:ptyx4
PM: Adding info for No Bus:ptyx5
PM: Adding info for No Bus:ptyx6
PM: Adding info for No Bus:ptyx7
PM: Adding info for No Bus:ptyx8
PM: Adding info for No Bus:ptyx9
PM: Adding info for No Bus:ptyxa
PM: Adding info for No Bus:ptyxb
PM: Adding info for No Bus:ptyxc
PM: Adding info for No Bus:ptyxd
PM: Adding info for No Bus:ptyxe
PM: Adding info for No Bus:ptyxf
PM: Adding info for No Bus:ptyy0
PM: Adding info for No Bus:ptyy1
PM: Adding info for No Bus:ptyy2
PM: Adding info for No Bus:ptyy3
PM: Adding info for No Bus:ptyy4
PM: Adding info for No Bus:ptyy5
PM: Adding info for No Bus:ptyy6
PM: Adding info for No Bus:ptyy7
PM: Adding info for No Bus:ptyy8
PM: Adding info for No Bus:ptyy9
PM: Adding info for No Bus:ptyya
PM: Adding info for No Bus:ptyyb
PM: Adding info for No Bus:ptyyc
PM: Adding info for No Bus:ptyyd
PM: Adding info for No Bus:ptyye
PM: Adding info for No Bus:ptyyf
PM: Adding info for No Bus:ptyz0
PM: Adding info for No Bus:ptyz1
PM: Adding info for No Bus:ptyz2
PM: Adding info for No Bus:ptyz3
PM: Adding info for No Bus:ptyz4
PM: Adding info for No Bus:ptyz5
PM: Adding info for No Bus:ptyz6
PM: Adding info for No Bus:ptyz7
PM: Adding info for No Bus:ptyz8
PM: Adding info for No Bus:ptyz9
PM: Adding info for No Bus:ptyza
PM: Adding info for No Bus:ptyzb
PM: Adding info for No Bus:ptyzc
PM: Adding info for No Bus:ptyzd
PM: Adding info for No Bus:ptyze
PM: Adding info for No Bus:ptyzf
PM: Adding info for No Bus:ptya0
PM: Adding info for No Bus:ptya1
PM: Adding info for No Bus:ptya2
PM: Adding info for No Bus:ptya3
PM: Adding info for No Bus:ptya4
PM: Adding info for No Bus:ptya5
PM: Adding info for No Bus:ptya6
PM: Adding info for No Bus:ptya7
PM: Adding info for No Bus:ptya8
PM: Adding info for No Bus:ptya9
PM: Adding info for No Bus:ptyaa
PM: Adding info for No Bus:ptyab
PM: Adding info for No Bus:ptyac
PM: Adding info for No Bus:ptyad
PM: Adding info for No Bus:ptyae
PM: Adding info for No Bus:ptyaf
PM: Adding info for No Bus:ptyb0
PM: Adding info for No Bus:ptyb1
PM: Adding info for No Bus:ptyb2
PM: Adding info for No Bus:ptyb3
PM: Adding info for No Bus:ptyb4
PM: Adding info for No Bus:ptyb5
PM: Adding info for No Bus:ptyb6
PM: Adding info for No Bus:ptyb7
PM: Adding info for No Bus:ptyb8
PM: Adding info for No Bus:ptyb9
PM: Adding info for No Bus:ptyba
PM: Adding info for No Bus:ptybb
PM: Adding info for No Bus:ptybc
PM: Adding info for No Bus:ptybd
PM: Adding info for No Bus:ptybe
PM: Adding info for No Bus:ptybf
PM: Adding info for No Bus:ptyc0
PM: Adding info for No Bus:ptyc1
PM: Adding info for No Bus:ptyc2
PM: Adding info for No Bus:ptyc3
PM: Adding info for No Bus:ptyc4
PM: Adding info for No Bus:ptyc5
PM: Adding info for No Bus:ptyc6
PM: Adding info for No Bus:ptyc7
PM: Adding info for No Bus:ptyc8
PM: Adding info for No Bus:ptyc9
PM: Adding info for No Bus:ptyca
PM: Adding info for No Bus:ptycb
PM: Adding info for No Bus:ptycc
PM: Adding info for No Bus:ptycd
PM: Adding info for No Bus:ptyce
PM: Adding info for No Bus:ptycf
PM: Adding info for No Bus:ptyd0
PM: Adding info for No Bus:ptyd1
PM: Adding info for No Bus:ptyd2
PM: Adding info for No Bus:ptyd3
PM: Adding info for No Bus:ptyd4
PM: Adding info for No Bus:ptyd5
PM: Adding info for No Bus:ptyd6
PM: Adding info for No Bus:ptyd7
PM: Adding info for No Bus:ptyd8
PM: Adding info for No Bus:ptyd9
PM: Adding info for No Bus:ptyda
PM: Adding info for No Bus:ptydb
PM: Adding info for No Bus:ptydc
PM: Adding info for No Bus:ptydd
PM: Adding info for No Bus:ptyde
PM: Adding info for No Bus:ptydf
PM: Adding info for No Bus:ptye0
PM: Adding info for No Bus:ptye1
PM: Adding info for No Bus:ptye2
PM: Adding info for No Bus:ptye3
PM: Adding info for No Bus:ptye4
PM: Adding info for No Bus:ptye5
PM: Adding info for No Bus:ptye6
PM: Adding info for No Bus:ptye7
PM: Adding info for No Bus:ptye8
PM: Adding info for No Bus:ptye9
PM: Adding info for No Bus:ptyea
PM: Adding info for No Bus:ptyeb
PM: Adding info for No Bus:ptyec
PM: Adding info for No Bus:ptyed
PM: Adding info for No Bus:ptyee
PM: Adding info for No Bus:ptyef
PM: Adding info for No Bus:ttyp0
PM: Adding info for No Bus:ttyp1
PM: Adding info for No Bus:ttyp2
PM: Adding info for No Bus:ttyp3
PM: Adding info for No Bus:ttyp4
PM: Adding info for No Bus:ttyp5
PM: Adding info for No Bus:ttyp6
PM: Adding info for No Bus:ttyp7
PM: Adding info for No Bus:ttyp8
PM: Adding info for No Bus:ttyp9
PM: Adding info for No Bus:ttypa
PM: Adding info for No Bus:ttypb
PM: Adding info for No Bus:ttypc
PM: Adding info for No Bus:ttypd
PM: Adding info for No Bus:ttype
PM: Adding info for No Bus:ttypf
PM: Adding info for No Bus:ttyq0
PM: Adding info for No Bus:ttyq1
PM: Adding info for No Bus:ttyq2
PM: Adding info for No Bus:ttyq3
PM: Adding info for No Bus:ttyq4
PM: Adding info for No Bus:ttyq5
PM: Adding info for No Bus:ttyq6
PM: Adding info for No Bus:ttyq7
PM: Adding info for No Bus:ttyq8
PM: Adding info for No Bus:ttyq9
PM: Adding info for No Bus:ttyqa
PM: Adding info for No Bus:ttyqb
PM: Adding info for No Bus:ttyqc
PM: Adding info for No Bus:ttyqd
PM: Adding info for No Bus:ttyqe
PM: Adding info for No Bus:ttyqf
PM: Adding info for No Bus:ttyr0
PM: Adding info for No Bus:ttyr1
PM: Adding info for No Bus:ttyr2
PM: Adding info for No Bus:ttyr3
PM: Adding info for No Bus:ttyr4
PM: Adding info for No Bus:ttyr5
PM: Adding info for No Bus:ttyr6
PM: Adding info for No Bus:ttyr7
PM: Adding info for No Bus:ttyr8
PM: Adding info for No Bus:ttyr9
PM: Adding info for No Bus:ttyra
PM: Adding info for No Bus:ttyrb
PM: Adding info for No Bus:ttyrc
PM: Adding info for No Bus:ttyrd
PM: Adding info for No Bus:ttyre
PM: Adding info for No Bus:ttyrf
PM: Adding info for No Bus:ttys0
PM: Adding info for No Bus:ttys1
PM: Adding info for No Bus:ttys2
PM: Adding info for No Bus:ttys3
PM: Adding info for No Bus:ttys4
PM: Adding info for No Bus:ttys5
PM: Adding info for No Bus:ttys6
PM: Adding info for No Bus:ttys7
PM: Adding info for No Bus:ttys8
PM: Adding info for No Bus:ttys9
PM: Adding info for No Bus:ttysa
PM: Adding info for No Bus:ttysb
PM: Adding info for No Bus:ttysc
PM: Adding info for No Bus:ttysd
PM: Adding info for No Bus:ttyse
PM: Adding info for No Bus:ttysf
PM: Adding info for No Bus:ttyt0
PM: Adding info for No Bus:ttyt1
PM: Adding info for No Bus:ttyt2
PM: Adding info for No Bus:ttyt3
PM: Adding info for No Bus:ttyt4
PM: Adding info for No Bus:ttyt5
PM: Adding info for No Bus:ttyt6
PM: Adding info for No Bus:ttyt7
PM: Adding info for No Bus:ttyt8
PM: Adding info for No Bus:ttyt9
PM: Adding info for No Bus:ttyta
PM: Adding info for No Bus:ttytb
PM: Adding info for No Bus:ttytc
PM: Adding info for No Bus:ttytd
PM: Adding info for No Bus:ttyte
PM: Adding info for No Bus:ttytf
PM: Adding info for No Bus:ttyu0
PM: Adding info for No Bus:ttyu1
PM: Adding info for No Bus:ttyu2
PM: Adding info for No Bus:ttyu3
PM: Adding info for No Bus:ttyu4
PM: Adding info for No Bus:ttyu5
PM: Adding info for No Bus:ttyu6
PM: Adding info for No Bus:ttyu7
PM: Adding info for No Bus:ttyu8
PM: Adding info for No Bus:ttyu9
PM: Adding info for No Bus:ttyua
PM: Adding info for No Bus:ttyub
PM: Adding info for No Bus:ttyuc
PM: Adding info for No Bus:ttyud
PM: Adding info for No Bus:ttyue
PM: Adding info for No Bus:ttyuf
PM: Adding info for No Bus:ttyv0
PM: Adding info for No Bus:ttyv1
PM: Adding info for No Bus:ttyv2
PM: Adding info for No Bus:ttyv3
PM: Adding info for No Bus:ttyv4
PM: Adding info for No Bus:ttyv5
PM: Adding info for No Bus:ttyv6
PM: Adding info for No Bus:ttyv7
PM: Adding info for No Bus:ttyv8
PM: Adding info for No Bus:ttyv9
PM: Adding info for No Bus:ttyva
PM: Adding info for No Bus:ttyvb
PM: Adding info for No Bus:ttyvc
PM: Adding info for No Bus:ttyvd
PM: Adding info for No Bus:ttyve
PM: Adding info for No Bus:ttyvf
PM: Adding info for No Bus:ttyw0
PM: Adding info for No Bus:ttyw1
PM: Adding info for No Bus:ttyw2
PM: Adding info for No Bus:ttyw3
PM: Adding info for No Bus:ttyw4
PM: Adding info for No Bus:ttyw5
PM: Adding info for No Bus:ttyw6
PM: Adding info for No Bus:ttyw7
PM: Adding info for No Bus:ttyw8
PM: Adding info for No Bus:ttyw9
PM: Adding info for No Bus:ttywa
PM: Adding info for No Bus:ttywb
PM: Adding info for No Bus:ttywc
PM: Adding info for No Bus:ttywd
PM: Adding info for No Bus:ttywe
PM: Adding info for No Bus:ttywf
PM: Adding info for No Bus:ttyx0
PM: Adding info for No Bus:ttyx1
PM: Adding info for No Bus:ttyx2
PM: Adding info for No Bus:ttyx3
PM: Adding info for No Bus:ttyx4
PM: Adding info for No Bus:ttyx5
PM: Adding info for No Bus:ttyx6
PM: Adding info for No Bus:ttyx7
PM: Adding info for No Bus:ttyx8
PM: Adding info for No Bus:ttyx9
PM: Adding info for No Bus:ttyxa
PM: Adding info for No Bus:ttyxb
PM: Adding info for No Bus:ttyxc
PM: Adding info for No Bus:ttyxd
PM: Adding info for No Bus:ttyxe
PM: Adding info for No Bus:ttyxf
PM: Adding info for No Bus:ttyy0
PM: Adding info for No Bus:ttyy1
PM: Adding info for No Bus:ttyy2
PM: Adding info for No Bus:ttyy3
PM: Adding info for No Bus:ttyy4
PM: Adding info for No Bus:ttyy5
PM: Adding info for No Bus:ttyy6
PM: Adding info for No Bus:ttyy7
PM: Adding info for No Bus:ttyy8
PM: Adding info for No Bus:ttyy9
PM: Adding info for No Bus:ttyya
PM: Adding info for No Bus:ttyyb
PM: Adding info for No Bus:ttyyc
PM: Adding info for No Bus:ttyyd
PM: Adding info for No Bus:ttyye
PM: Adding info for No Bus:ttyyf
PM: Adding info for No Bus:ttyz0
PM: Adding info for No Bus:ttyz1
PM: Adding info for No Bus:ttyz2
PM: Adding info for No Bus:ttyz3
PM: Adding info for No Bus:ttyz4
PM: Adding info for No Bus:ttyz5
PM: Adding info for No Bus:ttyz6
PM: Adding info for No Bus:ttyz7
PM: Adding info for No Bus:ttyz8
PM: Adding info for No Bus:ttyz9
PM: Adding info for No Bus:ttyza
PM: Adding info for No Bus:ttyzb
PM: Adding info for No Bus:ttyzc
PM: Adding info for No Bus:ttyzd
PM: Adding info for No Bus:ttyze
PM: Adding info for No Bus:ttyzf
PM: Adding info for No Bus:ttya0
PM: Adding info for No Bus:ttya1
PM: Adding info for No Bus:ttya2
PM: Adding info for No Bus:ttya3
PM: Adding info for No Bus:ttya4
PM: Adding info for No Bus:ttya5
PM: Adding info for No Bus:ttya6
PM: Adding info for No Bus:ttya7
PM: Adding info for No Bus:ttya8
PM: Adding info for No Bus:ttya9
PM: Adding info for No Bus:ttyaa
PM: Adding info for No Bus:ttyab
PM: Adding info for No Bus:ttyac
PM: Adding info for No Bus:ttyad
PM: Adding info for No Bus:ttyae
PM: Adding info for No Bus:ttyaf
PM: Adding info for No Bus:ttyb0
PM: Adding info for No Bus:ttyb1
PM: Adding info for No Bus:ttyb2
PM: Adding info for No Bus:ttyb3
PM: Adding info for No Bus:ttyb4
PM: Adding info for No Bus:ttyb5
PM: Adding info for No Bus:ttyb6
PM: Adding info for No Bus:ttyb7
PM: Adding info for No Bus:ttyb8
PM: Adding info for No Bus:ttyb9
PM: Adding info for No Bus:ttyba
PM: Adding info for No Bus:ttybb
PM: Adding info for No Bus:ttybc
PM: Adding info for No Bus:ttybd
PM: Adding info for No Bus:ttybe
PM: Adding info for No Bus:ttybf
PM: Adding info for No Bus:ttyc0
PM: Adding info for No Bus:ttyc1
PM: Adding info for No Bus:ttyc2
PM: Adding info for No Bus:ttyc3
PM: Adding info for No Bus:ttyc4
PM: Adding info for No Bus:ttyc5
PM: Adding info for No Bus:ttyc6
PM: Adding info for No Bus:ttyc7
PM: Adding info for No Bus:ttyc8
PM: Adding info for No Bus:ttyc9
PM: Adding info for No Bus:ttyca
PM: Adding info for No Bus:ttycb
PM: Adding info for No Bus:ttycc
PM: Adding info for No Bus:ttycd
PM: Adding info for No Bus:ttyce
PM: Adding info for No Bus:ttycf
PM: Adding info for No Bus:ttyd0
PM: Adding info for No Bus:ttyd1
PM: Adding info for No Bus:ttyd2
PM: Adding info for No Bus:ttyd3
PM: Adding info for No Bus:ttyd4
PM: Adding info for No Bus:ttyd5
PM: Adding info for No Bus:ttyd6
PM: Adding info for No Bus:ttyd7
PM: Adding info for No Bus:ttyd8
PM: Adding info for No Bus:ttyd9
PM: Adding info for No Bus:ttyda
PM: Adding info for No Bus:ttydb
PM: Adding info for No Bus:ttydc
PM: Adding info for No Bus:ttydd
PM: Adding info for No Bus:ttyde
PM: Adding info for No Bus:ttydf
PM: Adding info for No Bus:ttye0
PM: Adding info for No Bus:ttye1
PM: Adding info for No Bus:ttye2
PM: Adding info for No Bus:ttye3
PM: Adding info for No Bus:ttye4
PM: Adding info for No Bus:ttye5
PM: Adding info for No Bus:ttye6
PM: Adding info for No Bus:ttye7
PM: Adding info for No Bus:ttye8
PM: Adding info for No Bus:ttye9
PM: Adding info for No Bus:ttyea
PM: Adding info for No Bus:ttyeb
PM: Adding info for No Bus:ttyec
PM: Adding info for No Bus:ttyed
PM: Adding info for No Bus:ttyee
PM: Adding info for No Bus:ttyef
PM: Adding info for No Bus:hpet
hpet_resources: 0xfed00000 is busy
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.13 addr 0x90200000 irq 16 Yukon-EC (0xb6) rev 2
pci_enable_msi: irq= 16
pci_enable_msi: msi_enabled= 0
PM: Adding info for No Bus:eth0
sky2 eth0: addr 00:16:cb:8c:b2:65
PM: Adding info for No Bus:lo
netconsole: not configured, aborting
input: Macintosh mouse button emulation as /class/input/input0
ahci 0000:00:1f.2: version 2.1
PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
pci_enable_msi: irq= 19
pci_enable_msi: msi_enabled= 0
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x4 impl
SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pio slum part
ata1: SATA max UDMA/133 cmd 0xf8822100 ctl 0x00000000 bmdma 0x00000000
irq 218
ata2: SATA max UDMA/133 cmd 0xf8822180 ctl 0x00000000 bmdma 0x00000000
irq 218
ata3: SATA max UDMA/133 cmd 0xf8822200 ctl 0x00000000 bmdma 0x00000000
irq 218
ata4: SATA max UDMA/133 cmd 0xf8822280 ctl 0x00000000 bmdma 0x00000000
irq 218
scsi0 : ahci
PM: Adding info for No Bus:host0
ata1: SATA link down (SStatus 0 SControl 0)
scsi1 : ahci
PM: Adding info for No Bus:host1
ata2: SATA link down (SStatus 0 SControl 0)
scsi2 : ahci
PM: Adding info for No Bus:host2
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: ST98823AS, 7.01, max UDMA/133
ata3.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
scsi3 : ahci
PM: Adding info for No Bus:host3
ata4: SATA link down (SStatus 0 SControl 0)
PM: Adding info for No Bus:target2:0:0
scsi 2:0:0:0: Direct-Access     ATA      ST98823AS        7.01 PQ: 0 ANSI: 5
PM: Adding info for scsi:2:0:0:0
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda10
sd 2:0:0:0: Attached scsi disk sda
ata_piix 0000:00:1f.1: version 2.10ac1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata5: PATA max UDMA/133 cmd 0x000140e8 ctl 0x000140fe bmdma 0x000140c0
irq 18
ata6: PATA max UDMA/133 cmd 0x000140e0 ctl 0x000140fa bmdma 0x000140c8
irq 18
scsi4 : ata_piix
PM: Adding info for No Bus:host4
ata5.00: ATAPI, max UDMA/66
ata5.00: configured for UDMA/66
scsi5 : ata_piix
PM: Adding info for No Bus:host5
ATA: abnormal status 0x7F on port 0x000140e7
PM: Adding info for No Bus:target4:0:0
scsi 4:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857   HAE4 PQ: 0 ANSI: 5
PM: Adding info for scsi:4:0:0:0
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
PM: Adding info for No Bus:device-mapper
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
EFI Variables Facility v0.08 2004-May-17
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
swsusp: Resume From Partition /dev/sda10
PM: Checking swsusp image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 196k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
sd 2:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: Attached scsi generic sg1 type 5
PM: Adding info for No Bus:timer
PCI: Enabling device 0000:00:1b.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1b.0 to 64
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
PM: Adding info for platform:iTCO_wdt
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x0460)
PM: Adding info for No Bus:watchdog
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
tpm_inf_pnp 00:03: Found TPM with ID IFX0101
tpm_inf_pnp 00:03: TPM found: config base 0x4e, io base 0x4700, chip
version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635
TT 1.2)
PM: Adding info for No Bus:tpm0
ieee1394: Initialized config rom entry `ip1394'
PM: Adding info for No Bus:card0
PM: Adding info for No Bus:pcmC0D1p
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for No Bus:controlC0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 21, io base 0x000040a0
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004080
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004060
PM: Adding info for usb:usb3
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004040
PM: Adding info for usb:usb4
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-2: new full speed USB device using uhci_hcd and address 2
PM: Adding info for No Bus:usbdev4.1_ep81
PM: Adding info for No Bus:usbdev4.1
ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
PM: Adding info for ieee1394:fw-host0
PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0x90405400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
PM: Adding info for usb:usb5
PM: Adding info for No Bus:usbdev5.1_ep00
usb usb5: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19] 
MMIO=[8c000000-8c0007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
PM: Adding info for No Bus:usbdev5.1_ep81
PM: Adding info for No Bus:usbdev5.1
PCI: Enabling device 0000:00:1f.3 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
PM: Adding info for No Bus:i2c-0
usb 1-2: device not accepting address 2, error -71
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda2, internal journal
PM: Adding info for i2c:0-0050
PM: Adding info for i2c:0-0052
ACPI: SSDT 3FEB3C90, 022A (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
ACPI: SSDT 3FEB2C10, 02C3 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3FEB3F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
ACPI: SSDT 3FEB2F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
Time: hpet clocksource has been installed.
PM: Adding info for No Bus:cpu0
PM: Adding info for No Bus:cpu1
PM: Adding info for No Bus:msr0
PM: Adding info for No Bus:msr1
ACPI: AC Adapter [ADP1] (on-line)
usb 5-4: new high speed USB device using ehci_hcd and address 3
PM: Adding info for ieee1394:0016cbfffe4c8a54
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0016cbfffe4c8a54]
PM: Adding info for ieee1394:0016cbfffe4c8a54-0
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input4
ACPI: Sleep Button (CM) [SLPB]
PM: Adding info for No Bus:eth1
eth1394: eth1: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
PM: Adding info for usb:5-4
PM: Adding info for No Bus:usbdev5.3_ep00
usb 5-4: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-4:1.0
PM: Adding info for No Bus:usbdev5.3
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
loop: loaded (max 8 devices)
PM: Adding info for No Bus:pktcdvd
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
PM: Adding info for No Bus:tun
Generic RTC Driver v1.07
PM: Adding info for No Bus:rtc
PM: Adding info for No Bus:dummy0
usbcore: registered new interface driver appletouch
Clocksource tsc unstable (delta = -64676598 ns)
usb 1-2: new full speed USB device using uhci_hcd and address 4
PM: Adding info for usb:1-2
PM: Adding info for No Bus:usbdev1.4_ep00
usb 1-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-2:1.0
PM: Adding info for No Bus:usbdev1.4_ep83
PM: Adding info for usb:1-2:1.1
appletouch Geyser 3 inited.
input: appletouch as /class/input/input5
PM: Adding info for No Bus:usbdev1.4_ep81
PM: Adding info for usb:1-2:1.2
PM: Adding info for No Bus:usbdev1.4_ep84
PM: Adding info for No Bus:usbdev1.4
usb 3-2: new full speed USB device using uhci_hcd and address 2
PM: Adding info for usb:3-2
PM: Adding info for No Bus:usbdev3.2_ep00
usb 3-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2:1.0
PM: Adding info for No Bus:usbdev3.2_ep83
PM: Adding info for No Bus:usbdev3.2
usb 4-1: new full speed USB device using uhci_hcd and address 2
PM: Adding info for usb:4-1
PM: Adding info for No Bus:usbdev4.2_ep00
usb 4-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-1:1.0
PM: Adding info for No Bus:usbdev4.2_ep81
PM: Adding info for usb:4-1:1.1
PM: Adding info for No Bus:usbdev4.2_ep82
PM: Adding info for No Bus:usbdev4.2
input: Apple Computer Apple Internal Keyboard / Trackpad as
/class/input/input6
input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
input: Apple Computer Apple Internal Keyboard / Trackpad as
/class/input/input7
input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
input: HID 05ac:1000 as /class/input/input8
input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
input: HID 05ac:1000 as /class/input/input9
input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1978844k swap on /dev/sda10.  Priority:-1 extents:1 across:1978844k
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Removing info for No Bus:vcs8
PM: Removing info for No Bus:vcsa8
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
PM: Removing info for No Bus:vcs9
PM: Removing info for No Bus:vcsa9
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Removing info for No Bus:vcs10
PM: Removing info for No Bus:vcsa10
PM: Adding info for No Bus:vcs11
PM: Adding info for No Bus:vcsa11
PM: Removing info for No Bus:vcs11
PM: Removing info for No Bus:vcsa11
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Adding info for No Bus:seq
sky2 eth0: enabling interface
sky2 eth0: ram buffer 48K
pktcdvd: writer pktcdvd0 mapped to sr0
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
Stopping tasks ... done.
Shrinking memory...  -done (0 pages freed)
Freed 0 kbytes in 0.02 seconds (0.00 MB/s)
usbhid 4-1:1.1: freeze
usbhid 4-1:1.0: freeze
usb 4-1: freeze
usb 3-2:1.0: freeze
usb 3-2: freeze
usbhid 1-2:1.2: freeze
appletouch 1-2:1.1: freeze
usbhid 1-2:1.0: freeze
usb 1-2: freeze
usb 5-4:1.0: freeze
usb 5-4: freeze
eeprom 0-0052: freeze
eeprom 0-0050: freeze
hub 5-0:1.0: freeze
usb usb5: freeze
hub 4-0:1.0: freeze
usb usb4: freeze
hub 3-0:1.0: freeze
usb usb3: freeze
hub 2-0:1.0: freeze
usb usb2: freeze
hub 1-0:1.0: freeze
usb usb1: freeze
iTCO_wdt iTCO_wdt: freeze
sr 4:0:0:0: freeze
sd 2:0:0:0: freeze
imacfb imacfb.0: freeze
platform vesafb.0: freeze
pci_express 0000:00:1c.2:pcie03: freeze
pci_express 0000:00:1c.2:pcie02: freeze
pci_express 0000:00:1c.2:pcie00: freeze
pci_express 0000:00:1c.1:pcie03: freeze
pci_express 0000:00:1c.1:pcie02: freeze
pci_express 0000:00:1c.1:pcie00: freeze
pci_express 0000:00:1c.0:pcie03: freeze
pci_express 0000:00:1c.0:pcie02: freeze
pci_express 0000:00:1c.0:pcie00: freeze
pci_express 0000:00:01.0:pcie03: freeze
pci_express 0000:00:01.0:pcie00: freeze
platform pcspkr: freeze
pnp 00:09: freeze
system 00:08: freeze
pnp 00:07: freeze
system 00:06: freeze
pnp 00:05: freeze
pnp 00:04: freeze
tpm_inf_pnp 00:03: freeze
pnp 00:02: freeze
system 00:01: freeze
pnp 00:00: freeze
ohci1394 0000:0c:03.0: freeze
pci 0000:03:00.0: freeze
sky2 0000:02:00.0: freeze
sky2 eth0: disabling interface
pci 0000:01:00.0: freeze
i801_smbus 0000:00:1f.3: freeze
ahci 0000:00:1f.2: freeze
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
ata_piix 0000:00:1f.1: freeze
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
pci 0000:00:1f.0: freeze
pci 0000:00:1e.0: freeze
ehci_hcd 0000:00:1d.7: freeze
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
uhci_hcd 0000:00:1d.3: freeze
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
uhci_hcd 0000:00:1d.2: freeze
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
uhci_hcd 0000:00:1d.1: freeze
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
uhci_hcd 0000:00:1d.0: freeze
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
pcieport-driver 0000:00:1c.2: freeze
pcieport-driver 0000:00:1c.1: freeze
pcieport-driver 0000:00:1c.0: freeze
HDA Intel 0000:00:1b.0: freeze
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
pci 0000:00:07.0: freeze
pcieport-driver 0000:00:01.0: freeze
pci 0000:00:00.0: freeze
acpi thermal:00: freeze
battery PNP0C0A:00: freeze
acpi device:36: freeze
acpi device:35: freeze
acpi device:34: freeze
acpi device:33: freeze
acpi device:32: freeze
acpi device:31: freeze
acpi device:30: freeze
acpi device:2f: freeze
acpi device:2e: freeze
acpi device:2d: freeze
acpi device:2c: freeze
acpi device:2b: freeze
acpi PNP0100:00: freeze
acpi PNP0B00:00: freeze
acpi PNP0C02:01: freeze
acpi PNP0C04:00: freeze
acpi PNP0000:00: freeze
acpi PNP0103:00: freeze
acpi INT0800:00: freeze
acpi PNP0200:00: freeze
acpi IFX0101:00: freeze
ec PNP0C09:00: freeze
acpi APP0003:00: freeze
acpi ACPI0008:00: freeze
acpi APP0001:00: freeze
pci_link PNP0C0F:07: freeze
pci_link PNP0C0F:06: freeze
pci_link PNP0C0F:05: freeze
pci_link PNP0C0F:04: freeze
pci_link PNP0C0F:03: freeze
pci_link PNP0C0F:02: freeze
pci_link PNP0C0F:01: freeze
pci_link PNP0C0F:00: freeze
acpi device:2a: freeze
acpi device:29: freeze
acpi device:28: freeze
acpi device:27: freeze
acpi device:26: freeze
acpi device:25: freeze
acpi device:24: freeze
acpi device:23: freeze
acpi device:22: freeze
acpi device:21: freeze
acpi device:20: freeze
acpi device:1f: freeze
acpi device:1e: freeze
acpi device:1d: freeze
acpi device:1c: freeze
acpi device:1b: freeze
acpi device:1a: freeze
acpi device:19: freeze
acpi device:18: freeze
acpi device:17: freeze
acpi device:16: freeze
acpi device:15: freeze
acpi device:14: freeze
acpi device:13: freeze
acpi device:12: freeze
acpi device:11: freeze
acpi device:10: freeze
acpi device:0f: freeze
acpi device:0e: freeze
acpi device:0d: freeze
acpi device:0c: freeze
acpi device:0b: freeze
acpi device:0a: freeze
acpi device:09: freeze
acpi device:08: freeze
acpi device:07: freeze
acpi device:06: freeze
acpi device:05: freeze
acpi device:04: freeze
acpi device:03: freeze
acpi device:02: freeze
video video:00: freeze
acpi device:01: freeze
acpi PNP0C02:00: freeze
pci_root PNP0A08:00: freeze
button PNP0C0E:00: freeze
button PNP0C0C:00: freeze
acpi APP0002:00: freeze
button PNP0C0D:00: freeze
ac ACPI0003:00: freeze
acpi device:00: freeze
processor ACPI0007:01: freeze
processor ACPI0007:00: freeze
button button_power:00: freeze
acpi acpi_system:00: freeze
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
PM: Removing info for No Bus:cpu1
PM: Removing info for No Bus:msr1
CPU1 is down
PM: snapshotting memory.
iTCO_wdt iTCO_wdt: LATE freeze
imacfb imacfb.0: LATE freeze
platform vesafb.0: LATE freeze
platform pcspkr: LATE freeze
ohci1394 0000:0c:03.0: LATE freeze
pci 0000:03:00.0: LATE freeze
sky2 0000:02:00.0: LATE freeze
pci 0000:01:00.0: LATE freeze
i801_smbus 0000:00:1f.3: LATE freeze
pci 0000:00:1f.0: LATE freeze
pci 0000:00:1e.0: LATE freeze
pcieport-driver 0000:00:1c.2: LATE freeze
pcieport-driver 0000:00:1c.1: LATE freeze
pcieport-driver 0000:00:1c.0: LATE freeze
HDA Intel 0000:00:1b.0: LATE freeze
pci 0000:00:07.0: LATE freeze
pcieport-driver 0000:00:01.0: LATE freeze
pci 0000:00:00.0: LATE freeze
swsusp: critical section:
swsusp: Need to copy 70934 pages
swsusp: Normal pages needed: 70825 + 1024 + 24, available pages: 190171
pci 0000:00:00.0: EARLY resume
pcieport-driver 0000:00:01.0: EARLY resume
pci 0000:00:07.0: EARLY resume
HDA Intel 0000:00:1b.0: EARLY resume
pcieport-driver 0000:00:1c.0: EARLY resume
pcieport-driver 0000:00:1c.1: EARLY resume
pcieport-driver 0000:00:1c.2: EARLY resume
uhci_hcd 0000:00:1d.0: EARLY resume
uhci_hcd 0000:00:1d.1: EARLY resume
uhci_hcd 0000:00:1d.2: EARLY resume
uhci_hcd 0000:00:1d.3: EARLY resume
ehci_hcd 0000:00:1d.7: EARLY resume
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1f.0: EARLY resume
ata_piix 0000:00:1f.1: EARLY resume
ahci 0000:00:1f.2: EARLY resume
i801_smbus 0000:00:1f.3: EARLY resume
pci 0000:01:00.0: EARLY resume
sky2 0000:02:00.0: EARLY resume
pci 0000:03:00.0: EARLY resume
ohci1394 0000:0c:03.0: EARLY resume
platform pcspkr: EARLY resume
platform vesafb.0: EARLY resume
imacfb imacfb.0: EARLY resume
iTCO_wdt iTCO_wdt: EARLY resume
PM: Image restored successfully.
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c038d000 soft=c038b000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3663.71 BogoMIPS
(lpj=6103541)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000
0000c1a9 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9
00000000 00000000
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Switched to high resolution mode on CPU 1
PM: Adding info for No Bus:cpu1
PM: Adding info for No Bus:msr1
CPU1 is up
acpi acpi_system:00: resuming
button button_power:00: resuming
processor ACPI0007:00: resuming
processor ACPI0007:01: resuming
acpi device:00: resuming
ac ACPI0003:00: resuming
button PNP0C0D:00: resuming
acpi APP0002:00: resuming
button PNP0C0C:00: resuming
button PNP0C0E:00: resuming
pci_root PNP0A08:00: resuming
acpi PNP0C02:00: resuming
acpi device:01: resuming
video video:00: resuming
acpi device:02: resuming
acpi device:03: resuming
acpi device:04: resuming
acpi device:05: resuming
acpi device:06: resuming
acpi device:07: resuming
acpi device:08: resuming
acpi device:09: resuming
acpi device:0a: resuming
acpi device:0b: resuming
acpi device:0c: resuming
acpi device:0d: resuming
acpi device:0e: resuming
acpi device:0f: resuming
acpi device:10: resuming
acpi device:11: resuming
acpi device:12: resuming
acpi device:13: resuming
acpi device:14: resuming
acpi device:15: resuming
acpi device:16: resuming
acpi device:17: resuming
acpi device:18: resuming
acpi device:19: resuming
acpi device:1a: resuming
acpi device:1b: resuming
acpi device:1c: resuming
acpi device:1d: resuming
acpi device:1e: resuming
acpi device:1f: resuming
acpi device:20: resuming
acpi device:21: resuming
acpi device:22: resuming
acpi device:23: resuming
acpi device:24: resuming
acpi device:25: resuming
acpi device:26: resuming
acpi device:27: resuming
acpi device:28: resuming
acpi device:29: resuming
acpi device:2a: resuming
pci_link PNP0C0F:00: resuming
pci_link PNP0C0F:01: resuming
pci_link PNP0C0F:02: resuming
pci_link PNP0C0F:03: resuming
pci_link PNP0C0F:04: resuming
pci_link PNP0C0F:05: resuming
pci_link PNP0C0F:06: resuming
pci_link PNP0C0F:07: resuming
acpi APP0001:00: resuming
acpi ACPI0008:00: resuming
acpi APP0003:00: resuming
ec PNP0C09:00: resuming
acpi IFX0101:00: resuming
acpi PNP0200:00: resuming
acpi INT0800:00: resuming
acpi PNP0103:00: resuming
acpi PNP0000:00: resuming
acpi PNP0C04:00: resuming
acpi PNP0C02:01: resuming
acpi PNP0B00:00: resuming
acpi PNP0100:00: resuming
acpi device:2b: resuming
acpi device:2c: resuming
acpi device:2d: resuming
acpi device:2e: resuming
acpi device:2f: resuming
acpi device:30: resuming
acpi device:31: resuming
acpi device:32: resuming
acpi device:33: resuming
acpi device:34: resuming
acpi device:35: resuming
acpi device:36: resuming
battery PNP0C0A:00: resuming
acpi thermal:00: resuming
pci 0000:00:00.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
pcieport-driver 0000:00:01.0: resuming
__pci_restore_msi_state: irq= 223
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba33c0
PCI: Setting latency timer of device 0000:00:01.0 to 64
pci 0000:00:07.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
HDA Intel 0000:00:1b.0: resuming
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was
100000, writing 100002)
__pci_restore_msi_state: irq= 20
__pci_restore_msi_state: msi_enabled= 0
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1b.0 to 64
pcieport-driver 0000:00:1c.0: resuming
__pci_restore_msi_state: irq= 222
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba33a0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pcieport-driver 0000:00:1c.1: resuming
__pci_restore_msi_state: irq= 221
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba3380
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pcieport-driver 0000:00:1c.2: resuming
__pci_restore_msi_state: irq= 220
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba3360
PCI: Setting latency timer of device 0000:00:1c.2 to 64
uhci_hcd 0000:00:1d.0: resuming
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
__pci_restore_msi_state: irq= 21
__pci_restore_msi_state: msi_enabled= 0
usb usb1: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: resuming
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
__pci_restore_msi_state: irq= 19
__pci_restore_msi_state: msi_enabled= 0
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: resuming
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
__pci_restore_msi_state: irq= 18
__pci_restore_msi_state: msi_enabled= 0
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: resuming
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
__pci_restore_msi_state: irq= 16
__pci_restore_msi_state: msi_enabled= 0
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: resuming
PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
__pci_restore_msi_state: irq= 21
__pci_restore_msi_state: msi_enabled= 0
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
pci 0000:00:1e.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
PCI: Setting latency timer of device 0000:00:1e.0 to 64
pci 0000:00:1f.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
ata_piix 0000:00:1f.1: resuming
PM: Writing back config space on device 0000:00:1f.1 at offset 1 (was
2800001, writing 2800005)
__pci_restore_msi_state: irq= 18
__pci_restore_msi_state: msi_enabled= 0
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ahci 0000:00:1f.2: resuming
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was
2b00403, writing 2b00407)
__pci_restore_msi_state: irq= 218
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba35c0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
i801_smbus 0000:00:1f.3: resuming
PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was
2800000, writing 2800001)
__pci_restore_msi_state: irq= 19
__pci_restore_msi_state: msi_enabled= 0
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
pci 0000:01:00.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
sky2 0000:02:00.0: resuming
ATA: abnormal status 0x7F on port 0x000140e7
PM: Writing back config space on device 0000:02:00.0 at offset 1 (was
100000, writing 100407)
__pci_restore_msi_state: irq= 219
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba3340
sky2 eth0: enabling interface
sky2 eth0: ram buffer 48K
pci 0000:03:00.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
ohci1394 0000:0c:03.0: resuming
__pci_restore_msi_state: irq= 19
__pci_restore_msi_state: msi_enabled= 0
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19] 
MMIO=[8c000000-8c0007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
ata1: SATA link down (SStatus 0 SControl 0)
ata2: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
pnp 00:00: resuming
system 00:01: resuming
pnp 00:02: resuming
tpm_inf_pnp 00:03: resuming
pnp: Failed to activate device 00:03.
pnp 00:04: resuming
pnp 00:05: resuming
system 00:06: resuming
pnp 00:07: resuming
system 00:08: resuming
pnp 00:09: resuming
platform pcspkr: resuming
pci_express 0000:00:01.0:pcie00: resuming
pci_express 0000:00:01.0:pcie03: resuming
pci_express 0000:00:1c.0:pcie00: resuming
pci_express 0000:00:1c.0:pcie02: resuming
pci_express 0000:00:1c.0:pcie03: resuming
pci_express 0000:00:1c.1:pcie00: resuming
pci_express 0000:00:1c.1:pcie02: resuming
pci_express 0000:00:1c.1:pcie03: resuming
pci_express 0000:00:1c.2:pcie00: resuming
pci_express 0000:00:1c.2:pcie02: resuming
pci_express 0000:00:1c.2:pcie03: resuming
platform vesafb.0: resuming
imacfb imacfb.0: resuming
sd 2:0:0:0: resuming
sr 4:0:0:0: resuming
iTCO_wdt iTCO_wdt: resuming
usb usb1: resuming
hub 1-0:1.0: resuming
usb usb2: resuming
hub 2-0:1.0: resuming
usb usb3: resuming
hub 3-0:1.0: resuming
usb usb4: resuming
hub 4-0:1.0: resuming
usb usb5: resuming
hub 5-0:1.0: resuming
eeprom 0-0050: resuming
eeprom 0-0052: resuming
usb 5-4: resuming
 usbdev5.3_ep00: PM: resume from 0, parent 5-4 still 1
usb 5-4:1.0: PM: resume from 1, parent 5-4 still 1
usb 5-4:1.0: resuming
 usbdev5.3: PM: resume from 0, parent 5-4 still 1
usb 1-2: resuming
 usbdev1.4_ep00: PM: resume from 0, parent 1-2 still 1
usbhid 1-2:1.0: PM: resume from 1, parent 1-2 still 1
usbhid 1-2:1.0: resuming
 usbdev1.4_ep83: PM: resume from 0, parent 1-2:1.0 still 1
appletouch 1-2:1.1: PM: resume from 1, parent 1-2 still 1
appletouch 1-2:1.1: resuming
 usbdev1.4_ep81: PM: resume from 0, parent 1-2:1.1 still 1
usbhid 1-2:1.2: PM: resume from 1, parent 1-2 still 1
usbhid 1-2:1.2: resuming
 usbdev1.4_ep84: PM: resume from 0, parent 1-2:1.2 still 1
 usbdev1.4: PM: resume from 0, parent 1-2 still 1
usb 3-2: resuming
 usbdev3.2_ep00: PM: resume from 0, parent 3-2 still 1
usb 3-2:1.0: PM: resume from 1, parent 3-2 still 1
usb 3-2:1.0: resuming
 usbdev3.2_ep83: PM: resume from 0, parent 3-2:1.0 still 1
 usbdev3.2: PM: resume from 0, parent 3-2 still 1
usb 4-1: resuming
 usbdev4.2_ep00: PM: resume from 0, parent 4-1 still 1
usbhid 4-1:1.0: PM: resume from 1, parent 4-1 still 1
usbhid 4-1:1.0: resuming
 usbdev4.2_ep81: PM: resume from 0, parent 4-1:1.0 still 1
usbhid 4-1:1.1: PM: resume from 1, parent 4-1 still 1
usbhid 4-1:1.1: resuming
 usbdev4.2_ep82: PM: resume from 0, parent 4-1:1.1 still 1
 usbdev4.2: PM: resume from 0, parent 4-1 still 1
Restarting tasks ... <6>usb 1-2: USB disconnect, address 4
PM: Removing info for No Bus:usbdev1.4_ep83
PM: Removing info for usb:1-2:1.0
PM: Removing info for No Bus:usbdev1.4_ep81
input: appletouch disconnected
PM: Removing info for usb:1-2:1.1
PM: Removing info for No Bus:usbdev1.4_ep84
PM: Removing info for usb:1-2:1.2
PM: Removing info for No Bus:usbdev1.4
PM: Removing info for No Bus:usbdev1.4_ep00
PM: Removing info for usb:1-2
done.
usb 3-2: USB disconnect, address 2
PM: Removing info for No Bus:usbdev3.2_ep83
PM: Removing info for usb:3-2:1.0
PM: Removing info for No Bus:usbdev3.2
PM: Removing info for No Bus:usbdev3.2_ep00
PM: Removing info for usb:3-2
usb 4-1: USB disconnect, address 2
PM: Removing info for No Bus:usbdev4.2_ep81
PM: Removing info for usb:4-1:1.0
PM: Removing info for No Bus:usbdev4.2_ep82
PM: Removing info for usb:4-1:1.1
PM: Removing info for No Bus:usbdev4.2
PM: Removing info for No Bus:usbdev4.2_ep00
PM: Removing info for usb:4-1
ata5.00: configured for UDMA/66
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: configured for UDMA/133
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
usb 5-4: USB disconnect, address 3
PM: Removing info for usb:5-4:1.0
PM: Removing info for No Bus:usbdev5.3
PM: Removing info for No Bus:usbdev5.3_ep00
PM: Removing info for usb:5-4
usb 5-4: new high speed USB device using ehci_hcd and address 7
PM: Adding info for usb:5-4
PM: Adding info for No Bus:usbdev5.7_ep00
usb 5-4: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-4:1.0
PM: Adding info for No Bus:usbdev5.7
usb 1-2: new full speed USB device using uhci_hcd and address 5
PM: Adding info for usb:1-2
PM: Adding info for No Bus:usbdev1.5_ep00
usb 1-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-2:1.0
input: Apple Computer Apple Internal Keyboard / Trackpad as
/class/input/input10
input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
PM: Adding info for No Bus:usbdev1.5_ep83
PM: Adding info for usb:1-2:1.1
appletouch Geyser 3 inited.
input: appletouch as /class/input/input11
appletouch: incomplete data package (first byte: 2, length: 4).
PM: Adding info for No Bus:usbdev1.5_ep81
PM: Adding info for usb:1-2:1.2
input: Apple Computer Apple Internal Keyboard / Trackpad as
/class/input/input12
input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
PM: Adding info for No Bus:usbdev1.5_ep84
PM: Adding info for No Bus:usbdev1.5
usb 3-2: new full speed USB device using uhci_hcd and address 3
PM: Adding info for usb:3-2
PM: Adding info for No Bus:usbdev3.3_ep00
usb 3-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2:1.0
PM: Adding info for No Bus:usbdev3.3_ep83
PM: Adding info for No Bus:usbdev3.3
usb 4-1: new full speed USB device using uhci_hcd and address 3
PM: Adding info for usb:4-1
PM: Adding info for No Bus:usbdev4.3_ep00
usb 4-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-1:1.0
input: HID 05ac:1000 as /class/input/input13
input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
PM: Adding info for No Bus:usbdev4.3_ep81
PM: Adding info for usb:4-1:1.1
input: HID 05ac:1000 as /class/input/input14
input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
PM: Adding info for No Bus:usbdev4.3_ep82
PM: Adding info for No Bus:usbdev4.3
Stopping tasks ... done.
Shrinking memory...  -done (0 pages freed)
Freed 0 kbytes in 0.02 seconds (0.00 MB/s)
usbhid 4-1:1.1: freeze
usbhid 4-1:1.0: freeze
usb 4-1: freeze
usb 3-2:1.0: freeze
usb 3-2: freeze
usbhid 1-2:1.2: freeze
appletouch 1-2:1.1: freeze
usbhid 1-2:1.0: freeze
usb 1-2: freeze
usb 5-4:1.0: freeze
usb 5-4: freeze
eeprom 0-0052: freeze
eeprom 0-0050: freeze
hub 5-0:1.0: freeze
usb usb5: freeze
hub 4-0:1.0: freeze
usb usb4: freeze
hub 3-0:1.0: freeze
usb usb3: freeze
hub 2-0:1.0: freeze
usb usb2: freeze
hub 1-0:1.0: freeze
usb usb1: freeze
iTCO_wdt iTCO_wdt: freeze
sr 4:0:0:0: freeze
sd 2:0:0:0: freeze
imacfb imacfb.0: freeze
platform vesafb.0: freeze
pci_express 0000:00:1c.2:pcie03: freeze
pci_express 0000:00:1c.2:pcie02: freeze
pci_express 0000:00:1c.2:pcie00: freeze
pci_express 0000:00:1c.1:pcie03: freeze
pci_express 0000:00:1c.1:pcie02: freeze
pci_express 0000:00:1c.1:pcie00: freeze
pci_express 0000:00:1c.0:pcie03: freeze
pci_express 0000:00:1c.0:pcie02: freeze
pci_express 0000:00:1c.0:pcie00: freeze
pci_express 0000:00:01.0:pcie03: freeze
pci_express 0000:00:01.0:pcie00: freeze
platform pcspkr: freeze
pnp 00:09: freeze
system 00:08: freeze
pnp 00:07: freeze
system 00:06: freeze
pnp 00:05: freeze
pnp 00:04: freeze
tpm_inf_pnp 00:03: freeze
pnp 00:02: freeze
system 00:01: freeze
pnp 00:00: freeze
ohci1394 0000:0c:03.0: freeze
pci 0000:03:00.0: freeze
sky2 0000:02:00.0: freeze
sky2 eth0: disabling interface
pci 0000:01:00.0: freeze
i801_smbus 0000:00:1f.3: freeze
ahci 0000:00:1f.2: freeze
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
ata_piix 0000:00:1f.1: freeze
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
pci 0000:00:1f.0: freeze
pci 0000:00:1e.0: freeze
ehci_hcd 0000:00:1d.7: freeze
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
uhci_hcd 0000:00:1d.3: freeze
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
uhci_hcd 0000:00:1d.2: freeze
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
uhci_hcd 0000:00:1d.1: freeze
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
uhci_hcd 0000:00:1d.0: freeze
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
pcieport-driver 0000:00:1c.2: freeze
pcieport-driver 0000:00:1c.1: freeze
pcieport-driver 0000:00:1c.0: freeze
HDA Intel 0000:00:1b.0: freeze
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
pci 0000:00:07.0: freeze
pcieport-driver 0000:00:01.0: freeze
pci 0000:00:00.0: freeze
acpi thermal:00: freeze
battery PNP0C0A:00: freeze
acpi device:36: freeze
acpi device:35: freeze
acpi device:34: freeze
acpi device:33: freeze
acpi device:32: freeze
acpi device:31: freeze
acpi device:30: freeze
acpi device:2f: freeze
acpi device:2e: freeze
acpi device:2d: freeze
acpi device:2c: freeze
acpi device:2b: freeze
acpi PNP0100:00: freeze
acpi PNP0B00:00: freeze
acpi PNP0C02:01: freeze
acpi PNP0C04:00: freeze
acpi PNP0000:00: freeze
acpi PNP0103:00: freeze
acpi INT0800:00: freeze
acpi PNP0200:00: freeze
acpi IFX0101:00: freeze
ec PNP0C09:00: freeze
acpi APP0003:00: freeze
acpi ACPI0008:00: freeze
acpi APP0001:00: freeze
pci_link PNP0C0F:07: freeze
pci_link PNP0C0F:06: freeze
pci_link PNP0C0F:05: freeze
pci_link PNP0C0F:04: freeze
pci_link PNP0C0F:03: freeze
pci_link PNP0C0F:02: freeze
pci_link PNP0C0F:01: freeze
pci_link PNP0C0F:00: freeze
acpi device:2a: freeze
acpi device:29: freeze
acpi device:28: freeze
acpi device:27: freeze
acpi device:26: freeze
acpi device:25: freeze
acpi device:24: freeze
acpi device:23: freeze
acpi device:22: freeze
acpi device:21: freeze
acpi device:20: freeze
acpi device:1f: freeze
acpi device:1e: freeze
acpi device:1d: freeze
acpi device:1c: freeze
acpi device:1b: freeze
acpi device:1a: freeze
acpi device:19: freeze
acpi device:18: freeze
acpi device:17: freeze
acpi device:16: freeze
acpi device:15: freeze
acpi device:14: freeze
acpi device:13: freeze
acpi device:12: freeze
acpi device:11: freeze
acpi device:10: freeze
acpi device:0f: freeze
acpi device:0e: freeze
acpi device:0d: freeze
acpi device:0c: freeze
acpi device:0b: freeze
acpi device:0a: freeze
acpi device:09: freeze
acpi device:08: freeze
acpi device:07: freeze
acpi device:06: freeze
acpi device:05: freeze
acpi device:04: freeze
acpi device:03: freeze
acpi device:02: freeze
video video:00: freeze
acpi device:01: freeze
acpi PNP0C02:00: freeze
pci_root PNP0A08:00: freeze
button PNP0C0E:00: freeze
button PNP0C0C:00: freeze
acpi APP0002:00: freeze
button PNP0C0D:00: freeze
ac ACPI0003:00: freeze
acpi device:00: freeze
processor ACPI0007:01: freeze
processor ACPI0007:00: freeze
button button_power:00: freeze
acpi acpi_system:00: freeze
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
PM: Removing info for No Bus:cpu1
PM: Removing info for No Bus:msr1
CPU1 is down
PM: snapshotting memory.
iTCO_wdt iTCO_wdt: LATE freeze
imacfb imacfb.0: LATE freeze
platform vesafb.0: LATE freeze
platform pcspkr: LATE freeze
ohci1394 0000:0c:03.0: LATE freeze
pci 0000:03:00.0: LATE freeze
sky2 0000:02:00.0: LATE freeze
pci 0000:01:00.0: LATE freeze
i801_smbus 0000:00:1f.3: LATE freeze
pci 0000:00:1f.0: LATE freeze
pci 0000:00:1e.0: LATE freeze
pcieport-driver 0000:00:1c.2: LATE freeze
pcieport-driver 0000:00:1c.1: LATE freeze
pcieport-driver 0000:00:1c.0: LATE freeze
HDA Intel 0000:00:1b.0: LATE freeze
pci 0000:00:07.0: LATE freeze
pcieport-driver 0000:00:01.0: LATE freeze
pci 0000:00:00.0: LATE freeze
swsusp: critical section:
swsusp: Need to copy 72509 pages
swsusp: Normal pages needed: 72365 + 1024 + 24, available pages: 188555
pci 0000:00:00.0: EARLY resume
pcieport-driver 0000:00:01.0: EARLY resume
pci 0000:00:07.0: EARLY resume
HDA Intel 0000:00:1b.0: EARLY resume
pcieport-driver 0000:00:1c.0: EARLY resume
pcieport-driver 0000:00:1c.1: EARLY resume
pcieport-driver 0000:00:1c.2: EARLY resume
uhci_hcd 0000:00:1d.0: EARLY resume
uhci_hcd 0000:00:1d.1: EARLY resume
uhci_hcd 0000:00:1d.2: EARLY resume
uhci_hcd 0000:00:1d.3: EARLY resume
ehci_hcd 0000:00:1d.7: EARLY resume
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1f.0: EARLY resume
ata_piix 0000:00:1f.1: EARLY resume
ahci 0000:00:1f.2: EARLY resume
i801_smbus 0000:00:1f.3: EARLY resume
pci 0000:01:00.0: EARLY resume
sky2 0000:02:00.0: EARLY resume
pci 0000:03:00.0: EARLY resume
ohci1394 0000:0c:03.0: EARLY resume
platform pcspkr: EARLY resume
platform vesafb.0: EARLY resume
imacfb imacfb.0: EARLY resume
iTCO_wdt iTCO_wdt: EARLY resume
PM: Image restored successfully.
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c038d000 soft=c038b000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3663.67 BogoMIPS
(lpj=6103482)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000
0000c1a9 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9
00000000 00000000
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Switched to high resolution mode on CPU 1
PM: Adding info for No Bus:cpu1
PM: Adding info for No Bus:msr1
CPU1 is up
acpi acpi_system:00: resuming
button button_power:00: resuming
processor ACPI0007:00: resuming
processor ACPI0007:01: resuming
acpi device:00: resuming
ac ACPI0003:00: resuming
button PNP0C0D:00: resuming
acpi APP0002:00: resuming
button PNP0C0C:00: resuming
button PNP0C0E:00: resuming
pci_root PNP0A08:00: resuming
acpi PNP0C02:00: resuming
acpi device:01: resuming
video video:00: resuming
acpi device:02: resuming
acpi device:03: resuming
acpi device:04: resuming
acpi device:05: resuming
acpi device:06: resuming
acpi device:07: resuming
acpi device:08: resuming
acpi device:09: resuming
acpi device:0a: resuming
acpi device:0b: resuming
acpi device:0c: resuming
acpi device:0d: resuming
acpi device:0e: resuming
acpi device:0f: resuming
acpi device:10: resuming
acpi device:11: resuming
acpi device:12: resuming
acpi device:13: resuming
acpi device:14: resuming
acpi device:15: resuming
acpi device:16: resuming
acpi device:17: resuming
acpi device:18: resuming
acpi device:19: resuming
acpi device:1a: resuming
acpi device:1b: resuming
acpi device:1c: resuming
acpi device:1d: resuming
acpi device:1e: resuming
acpi device:1f: resuming
acpi device:20: resuming
acpi device:21: resuming
acpi device:22: resuming
acpi device:23: resuming
acpi device:24: resuming
acpi device:25: resuming
acpi device:26: resuming
acpi device:27: resuming
acpi device:28: resuming
acpi device:29: resuming
acpi device:2a: resuming
pci_link PNP0C0F:00: resuming
pci_link PNP0C0F:01: resuming
pci_link PNP0C0F:02: resuming
pci_link PNP0C0F:03: resuming
pci_link PNP0C0F:04: resuming
pci_link PNP0C0F:05: resuming
pci_link PNP0C0F:06: resuming
pci_link PNP0C0F:07: resuming
acpi APP0001:00: resuming
acpi ACPI0008:00: resuming
acpi APP0003:00: resuming
ec PNP0C09:00: resuming
acpi IFX0101:00: resuming
acpi PNP0200:00: resuming
acpi INT0800:00: resuming
acpi PNP0103:00: resuming
acpi PNP0000:00: resuming
acpi PNP0C04:00: resuming
acpi PNP0C02:01: resuming
acpi PNP0B00:00: resuming
acpi PNP0100:00: resuming
acpi device:2b: resuming
acpi device:2c: resuming
acpi device:2d: resuming
acpi device:2e: resuming
acpi device:2f: resuming
acpi device:30: resuming
acpi device:31: resuming
acpi device:32: resuming
acpi device:33: resuming
acpi device:34: resuming
acpi device:35: resuming
acpi device:36: resuming
battery PNP0C0A:00: resuming
acpi thermal:00: resuming
pci 0000:00:00.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
pcieport-driver 0000:00:01.0: resuming
__pci_restore_msi_state: irq= 223
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba33c0
PCI: Setting latency timer of device 0000:00:01.0 to 64
pci 0000:00:07.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
HDA Intel 0000:00:1b.0: resuming
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was
100000, writing 100002)
__pci_restore_msi_state: irq= 20
__pci_restore_msi_state: msi_enabled= 0
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1b.0 to 64
pcieport-driver 0000:00:1c.0: resuming
__pci_restore_msi_state: irq= 222
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba33a0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pcieport-driver 0000:00:1c.1: resuming
__pci_restore_msi_state: irq= 221
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba3380
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pcieport-driver 0000:00:1c.2: resuming
__pci_restore_msi_state: irq= 220
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba3360
PCI: Setting latency timer of device 0000:00:1c.2 to 64
uhci_hcd 0000:00:1d.0: resuming
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
__pci_restore_msi_state: irq= 21
__pci_restore_msi_state: msi_enabled= 0
usb usb1: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: resuming
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
__pci_restore_msi_state: irq= 19
__pci_restore_msi_state: msi_enabled= 0
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: resuming
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
__pci_restore_msi_state: irq= 18
__pci_restore_msi_state: msi_enabled= 0
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: resuming
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
__pci_restore_msi_state: irq= 16
__pci_restore_msi_state: msi_enabled= 0
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: resuming
PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
__pci_restore_msi_state: irq= 21
__pci_restore_msi_state: msi_enabled= 0
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
pci 0000:00:1e.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
PCI: Setting latency timer of device 0000:00:1e.0 to 64
pci 0000:00:1f.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
ata_piix 0000:00:1f.1: resuming
PM: Writing back config space on device 0000:00:1f.1 at offset 1 (was
2800001, writing 2800005)
__pci_restore_msi_state: irq= 18
__pci_restore_msi_state: msi_enabled= 0
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ahci 0000:00:1f.2: resuming
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was
2b00403, writing 2b00407)
__pci_restore_msi_state: irq= 19
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= NULL after get_irq_msi
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
i801_smbus 0000:00:1f.3: resuming
PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was
2800000, writing 2800001)
__pci_restore_msi_state: irq= 19
__pci_restore_msi_state: msi_enabled= 0
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
pci 0000:01:00.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
sky2 0000:02:00.0: resuming
ATA: abnormal status 0x7F on port 0x000140e7
PM: Writing back config space on device 0000:02:00.0 at offset 1 (was
100000, writing 100407)
__pci_restore_msi_state: irq= 219
__pci_restore_msi_state: msi_enabled= 1
__pci_restore_msi_state: entry= c1ba3340
sky2 eth0: enabling interface
sky2 eth0: ram buffer 48K
pci 0000:03:00.0: resuming
__pci_restore_msi_state: irq= 0
__pci_restore_msi_state: msi_enabled= 0
ohci1394 0000:0c:03.0: resuming
__pci_restore_msi_state: irq= 19
__pci_restore_msi_state: msi_enabled= 0
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19] 
MMIO=[8c000000-8c0007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
ata1: SATA link down (SStatus 0 SControl 0)
ata2: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
pnp 00:00: resuming
system 00:01: resuming
pnp 00:02: resuming
tpm_inf_pnp 00:03: resuming
pnp: Failed to activate device 00:03.
pnp 00:04: resuming
pnp 00:05: resuming
system 00:06: resuming
pnp 00:07: resuming
system 00:08: resuming
pnp 00:09: resuming
platform pcspkr: resuming
pci_express 0000:00:01.0:pcie00: resuming
pci_express 0000:00:01.0:pcie03: resuming
pci_express 0000:00:1c.0:pcie00: resuming
pci_express 0000:00:1c.0:pcie02: resuming
pci_express 0000:00:1c.0:pcie03: resuming
pci_express 0000:00:1c.1:pcie00: resuming
pci_express 0000:00:1c.1:pcie02: resuming
pci_express 0000:00:1c.1:pcie03: resuming
pci_express 0000:00:1c.2:pcie00: resuming
pci_express 0000:00:1c.2:pcie02: resuming
pci_express 0000:00:1c.2:pcie03: resuming
platform vesafb.0: resuming
imacfb imacfb.0: resuming
sd 2:0:0:0: resuming
sr 4:0:0:0: resuming
iTCO_wdt iTCO_wdt: resuming
usb usb1: resuming
hub 1-0:1.0: resuming
usb usb2: resuming
hub 2-0:1.0: resuming
usb usb3: resuming
hub 3-0:1.0: resuming
usb usb4: resuming
hub 4-0:1.0: resuming
usb usb5: resuming
hub 5-0:1.0: resuming
eeprom 0-0050: resuming
eeprom 0-0052: resuming
usb 5-4: resuming
 usbdev5.7_ep00: PM: resume from 0, parent 5-4 still 1
usb 5-4:1.0: PM: resume from 1, parent 5-4 still 1
usb 5-4:1.0: resuming
 usbdev5.7: PM: resume from 0, parent 5-4 still 1
usb 1-2: resuming
 usbdev1.5_ep00: PM: resume from 0, parent 1-2 still 1
usbhid 1-2:1.0: PM: resume from 1, parent 1-2 still 1
usbhid 1-2:1.0: resuming
 usbdev1.5_ep83: PM: resume from 0, parent 1-2:1.0 still 1
appletouch 1-2:1.1: PM: resume from 1, parent 1-2 still 1
appletouch 1-2:1.1: resuming
 usbdev1.5_ep81: PM: resume from 0, parent 1-2:1.1 still 1
usbhid 1-2:1.2: PM: resume from 1, parent 1-2 still 1
usbhid 1-2:1.2: resuming
 usbdev1.5_ep84: PM: resume from 0, parent 1-2:1.2 still 1
 usbdev1.5: PM: resume from 0, parent 1-2 still 1
usb 3-2: resuming
 usbdev3.3_ep00: PM: resume from 0, parent 3-2 still 1
usb 3-2:1.0: PM: resume from 1, parent 3-2 still 1
usb 3-2:1.0: resuming
 usbdev3.3_ep83: PM: resume from 0, parent 3-2:1.0 still 1
 usbdev3.3: PM: resume from 0, parent 3-2 still 1
usb 4-1: resuming
 usbdev4.3_ep00: PM: resume from 0, parent 4-1 still 1
usbhid 4-1:1.0: PM: resume from 1, parent 4-1 still 1
usbhid 4-1:1.0: resuming
 usbdev4.3_ep81: PM: resume from 0, parent 4-1:1.0 still 1
usbhid 4-1:1.1: PM: resume from 1, parent 4-1 still 1
usbhid 4-1:1.1: resuming
 usbdev4.3_ep82: PM: resume from 0, parent 4-1:1.1 still 1
 usbdev4.3: PM: resume from 0, parent 4-1 still 1
Restarting tasks ... <6>usb 1-2: USB disconnect, address 5
PM: Removing info for No Bus:usbdev1.5_ep83
PM: Removing info for usb:1-2:1.0
PM: Removing info for No Bus:usbdev1.5_ep81
input: appletouch disconnected
PM: Removing info for usb:1-2:1.1
PM: Removing info for No Bus:usbdev1.5_ep84
PM: Removing info for usb:1-2:1.2
PM: Removing info for No Bus:usbdev1.5
PM: Removing info for No Bus:usbdev1.5_ep00
PM: Removing info for usb:1-2
done.
usb 3-2: USB disconnect, address 3
PM: Removing info for No Bus:usbdev3.3_ep83
PM: Removing info for usb:3-2:1.0
PM: Removing info for No Bus:usbdev3.3
PM: Removing info for No Bus:usbdev3.3_ep00
PM: Removing info for usb:3-2
usb 4-1: USB disconnect, address 3
PM: Removing info for No Bus:usbdev4.3_ep81
PM: Removing info for usb:4-1:1.0
PM: Removing info for No Bus:usbdev4.3_ep82
PM: Removing info for usb:4-1:1.1
PM: Removing info for No Bus:usbdev4.3
PM: Removing info for No Bus:usbdev4.3_ep00
PM: Removing info for usb:4-1
ata5.00: configured for UDMA/66
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: configured for UDMA/133
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
usb 5-4: USB disconnect, address 7
PM: Removing info for usb:5-4:1.0
PM: Removing info for No Bus:usbdev5.7
PM: Removing info for No Bus:usbdev5.7_ep00
PM: Removing info for usb:5-4
usb 5-4: new high speed USB device using ehci_hcd and address 11
PM: Adding info for usb:5-4
PM: Adding info for No Bus:usbdev5.11_ep00
usb 5-4: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-4:1.0
PM: Adding info for No Bus:usbdev5.11
usb 1-2: new full speed USB device using uhci_hcd and address 6
PM: Adding info for usb:1-2
PM: Adding info for No Bus:usbdev1.6_ep00
usb 1-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-2:1.0
input: Apple Computer Apple Internal Keyboard / Trackpad as
/class/input/input15
input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
PM: Adding info for No Bus:usbdev1.6_ep83
PM: Adding info for usb:1-2:1.1
appletouch Geyser 3 inited.
input: appletouch as /class/input/input16
appletouch: incomplete data package (first byte: 2, length: 4).
PM: Adding info for No Bus:usbdev1.6_ep81
PM: Adding info for usb:1-2:1.2
input: Apple Computer Apple Internal Keyboard / Trackpad as
/class/input/input17
input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
PM: Adding info for No Bus:usbdev1.6_ep84
PM: Adding info for No Bus:usbdev1.6
usb 3-2: new full speed USB device using uhci_hcd and address 4
PM: Adding info for usb:3-2
PM: Adding info for No Bus:usbdev3.4_ep00
usb 3-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2:1.0
PM: Adding info for No Bus:usbdev3.4_ep83
PM: Adding info for No Bus:usbdev3.4
usb 4-1: new full speed USB device using uhci_hcd and address 4
PM: Adding info for usb:4-1
PM: Adding info for No Bus:usbdev4.4_ep00
usb 4-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-1:1.0
input: HID 05ac:1000 as /class/input/input18
input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
PM: Adding info for No Bus:usbdev4.4_ep81
PM: Adding info for usb:4-1:1.1
input: HID 05ac:1000 as /class/input/input19
input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
PM: Adding info for No Bus:usbdev4.4_ep82
PM: Adding info for No Bus:usbdev4.4

