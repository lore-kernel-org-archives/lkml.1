Return-Path: <linux-kernel-owner+w=401wt.eu-S935126AbXHHOkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935126AbXHHOkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759941AbXHHOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:40:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:25105 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761066AbXHHOkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=pv6o9WOIBLxKUDhsziplWwDiOnayhAWQ8VJE0Le8W29B1VqhA7nYIjhOwK2FFGuEzYx4K1ex2Co2BPne+5DoXa66UQ1DWHkibtm0sSNB0To3gCnQbl5b+trsDAQwZovdwK7Sx6AR20M4KVjghNdgSqRLxZPpn1lx0ztJwOPE0xA=
Subject: MCFG bug on hp nx6310, possible regression
From: Michael Sedkowski <sedmich@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       akpm-linux <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: multipart/mixed; boundary="=-JyzAw4D7Uw/uHu5zcfac"
Date: Wed, 08 Aug 2007 16:40:07 +0200
Message-Id: <1186584007.11831.9.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JyzAw4D7Uw/uHu5zcfac
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

During every boot on any standard kernel version I get this messsage:
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.

This was fixed on 2.6.23-rc1-mm2, however the bug still exists on
2.6.23-rc2 so it is a possible regression.

Regards,
Michael

--=-JyzAw4D7Uw/uHu5zcfac
Content-Disposition: attachment; filename=dmesg
Content-Type: text/plain; name=dmesg; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.23-rc2 (root@nx6310) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Wed Aug 8 10:49:05 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005f7d0000 (usable)
 BIOS-e820: 000000005f7d0000 - 000000005f7e5600 (reserved)
 BIOS-e820: 000000005f7e5600 - 000000005f7f8000 (ACPI NVS)
 BIOS-e820: 000000005f7f8000 - 000000005f800000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9b000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
631MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 391120) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   391120
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   391120
On node 0 totalpages: 391120
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 1263 pages used for memmap
  HighMem zone: 160481 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.4 present.
ACPI: RSDP 000F7C30, 0024 (r2 HP    )
ACPI: XSDT 5F7E57C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 5F7E5684, 00F4 (r4 HP     30AA            3 HP          1)
ACPI: DSDT 5F7E5AC0, FBEB (r1 HP       nc6340    10000 MSFT  100000E)
ACPI: FACS 5F7F7E80, 0040
ACPI: SLIC 5F7E5838, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET 5F7E59B0, 0038 (r1 HP     30AA            1 HP          1)
ACPI: APIC 5F7E59E8, 0068 (r1 HP     30AA            1 HP          1)
ACPI: MCFG 5F7E5A50, 003C (r1 HP     30AA            1 HP          1)
ACPI: TCPA 5F7E5A8C, 0032 (r2 HP     30AA            1 HP          1)
ACPI: SSDT 5F7F56AB, 0326 (r1 HP       HPQSAT        1 MSFT  100000E)
ACPI: SSDT 5F7F6226, 025F (r1 HP      Cpu0Tst     3000 INTL 20050624)
ACPI: SSDT 5F7F6485, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20050624)
ACPI: SSDT 5F7F652B, 04D7 (r1 HP        CpuPm     3000 INTL 20050624)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
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
Allocating PCI resources starting at 60000000 (gap: 5f800000:9f400000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 388065
Kernel command line: root=/dev/sda1 ro quiet vga=0x318 selinux=1 enforcing=1 
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1596.223 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1543948k/1564480k available (1877k kernel code, 19284k reserved, 777k data, 196k init, 646976k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc039e000 - 0xc03cf000   ( 196 kB)
      .data : 0xc02d551e - 0xc0397b04   ( 777 kB)
      .text : 0xc0100000 - 0xc02d551e   (1877 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 3196.02 BogoMIPS (lpj=5324832)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in enforcing mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c189 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c189 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel Genuine Intel(R) CPU           T2050  @ 1.60GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3193.08 BogoMIPS (lpj=5320136)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c189 00000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c189 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Genuine Intel(R) CPU           T2050  @ 1.60GHz stepping 08
Total of 2 processors activated (6389.10 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xf0322, last bus=32
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62<6>ACPI: PCI Root Bridge [C002] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1100-113f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03) (try 'pci=assign-busses')
Please report the result to <bk@suse.de> to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.C002._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C096._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C102._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C115._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C118._PRT]
ACPI: PCI Interrupt Link [C10E] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C10F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C110] (IRQs *10 11)
ACPI: PCI Interrupt Link [C111] (IRQs *10 11)
ACPI: PCI Interrupt Link [C12A] (IRQs *10 11)
ACPI: PCI Interrupt Link [C12B] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C12C] (IRQs 10 11) *0, disabled.
ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [C21A] (on)
ACPI: Power Resource [C222] (off)
ACPI: Power Resource [C321] (off)
ACPI: Power Resource [C322] (off)
ACPI: Power Resource [C323] (off)
ACPI: Power Resource [C324] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x5f7fffff could not be reserved
pnp: 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:0a: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:0a: ioport range 0x1000-0x107f has been reserved
pnp: 00:0a: ioport range 0x1100-0x113f has been reserved
pnp: 00:0a: ioport range 0x1200-0x121f has been reserved
pnp: 00:0a: iomem range 0xf8000000-0xfbffffff has been reserved
pnp: 00:0a: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:0a: iomem range 0xfed20000-0xfed3ffff could not be reserved
pnp: 00:0a: iomem range 0xfed45000-0xfed8ffff could not be reserved
pnp: 00:0b: iomem range 0xfeda0000-0xfedbffff could not be reserved
pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: e8000000-e80fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-5fff
  MEM window: e4000000-e7ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: 2000-3fff
  MEM window: e0000000-e3ffffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 00007000-000070ff
  IO window: 00007400-000074ff
  PREFETCH window: 60000000-63ffffff
  MEM window: 64000000-67ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 7000-7fff
  MEM window: e8100000-e83fffff
  PREFETCH window: 60000000-63ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 17
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2969k freed
audit: initializing netlink socket (disabled)
audit(1186567788.846:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, using 6144k, total 7872k
vesafb: mode is 1024x768x32, linelength=4096, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
ACPI: SSDT 5F7F5A99, 023D (r1 HP      Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 5F7F5D5B, 04CB (r1 HP      Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 5F7F59D1, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 5F7F5CD6, 0085 (r1 HP      Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU1] (supports 8 throttling states)
Marking TSC unstable due to: possible TSC halt in C2.
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [TZ0] (50 C)
ACPI: Thermal Zone [TZ1] (48 C)
ACPI: Thermal Zone [TZ2] (46 C)
ACPI: Thermal Zone [TZ3] (29 C)
ACPI: Thermal Zone [TZ4] (39 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH7: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
ICH7: chipset revision 1
ICH7: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x60a0-0x60a7, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
hda: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8846100 ctl 0x00000000 bmdma 0x00000000 irq 220
ata2: SATA max UDMA/133 cmd 0xf8846180 ctl 0x00000000 bmdma 0x00000000 irq 220
ata3: SATA max UDMA/133 cmd 0xf8846200 ctl 0x00000000 bmdma 0x00000000 irq 220
ata4: SATA max UDMA/133 cmd 0xf8846280 ctl 0x00000000 bmdma 0x00000000 irq 220
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST98823AS, 7.24, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      ST98823AS        7.24 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:C217,PNP0f13:C218] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
Freeing unused kernel memory: 196k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
ACPI: Transitioning device [C325] to D3
ACPI: Transitioning device [C325] to D3
ACPI: Fan [C325] (off)
ACPI: Transitioning device [C326] to D3
ACPI: Transitioning device [C326] to D3
ACPI: Fan [C326] (off)
ACPI: Transitioning device [C327] to D3
ACPI: Transitioning device [C327] to D3
ACPI: Fan [C327] (off)
ACPI: Fan [C328] (on)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006020
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe8584000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
b44.c:v1.01 (Jun 16, 2006)
ACPI: PCI Interrupt 0000:02:0e.0[A] -> GSI 16 (level, low) -> IRQ 16
eth0: Broadcom 4400 10/100BaseT Ethernet 00:17:08:31:6c:93
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 17, io base 0x00006060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 18, io base 0x00006080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:02:06.1[B] -> GSI 19 (level, low) -> IRQ 18
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[e8101000-e81017ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
usb 3-2: new low speed USB device using uhci_hcd and address 2
Attempting manual resume
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
usb 3-2: configuration #1 chosen from 1 choice
swsusp: Basic memory bitmaps freed
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input2
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.1-2
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.1/input/input3
input,hiddev96: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.1-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
security:  3 users, 7 roles, 915 types, 27 bools, 1 sens, 1024 cats
security:  60 classes, 14920 rules
security:  class memprotect not defined in policy
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), not configured for labeling
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1186567795.043:2): policy loaded auid=4294967295
audit(1186567795.966:3): avc:  denied  { getattr } for  pid=1469 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
audit(1186567796.010:4): avc:  denied  { getattr } for  pid=1480 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567797.396:5): avc:  denied  { relabelfrom } for  pid=1531 comm="udevd" name="pci-0000:00:1f.1-ide-0:0" dev=tmpfs ino=2283 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.453:6): avc:  denied  { relabelfrom } for  pid=1552 comm="udevd" name="ata-ST98823AS-5PK2G9N4" dev=tmpfs ino=1452 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.530:7): avc:  denied  { relabelfrom } for  pid=1552 comm="udevd" name="scsi-S_5PK2G9N4" dev=tmpfs ino=1453 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.530:8): avc:  denied  { relabelfrom } for  pid=1552 comm="udevd" name="pci-0000:00:1f.2-scsi-0:0:0:0" dev=tmpfs ino=1455 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.533:9): avc:  denied  { relabelfrom } for  pid=1531 comm="udevd" name="cdrom" dev=tmpfs ino=2284 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.533:10): avc:  denied  { relabelfrom } for  pid=1531 comm="udevd" name="cdrw" dev=tmpfs ino=2285 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.533:11): avc:  denied  { relabelfrom } for  pid=1531 comm="udevd" name="dvd" dev=tmpfs ino=2286 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.533:12): avc:  denied  { relabelfrom } for  pid=1531 comm="udevd" name="dvdrw" dev=tmpfs ino=2287 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.550:13): avc:  denied  { relabelfrom } for  pid=1748 comm="udevd" name="ata-ST98823AS-5PK2G9N4-part5" dev=tmpfs ino=2319 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.550:14): avc:  denied  { relabelfrom } for  pid=1748 comm="udevd" name="scsi-S_5PK2G9N4-part5" dev=tmpfs ino=2320 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.560:15): avc:  denied  { relabelfrom } for  pid=1748 comm="udevd" name="pci-0000:00:1f.2-scsi-0:0:0:0-part5" dev=tmpfs ino=2321 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.583:16): avc:  denied  { relabelfrom } for  pid=1745 comm="udevd" name="ata-ST98823AS-5PK2G9N4-part2" dev=tmpfs ino=1735 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.583:17): avc:  denied  { relabelfrom } for  pid=1745 comm="udevd" name="scsi-S_5PK2G9N4-part2" dev=tmpfs ino=1736 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.583:18): avc:  denied  { relabelfrom } for  pid=1745 comm="udevd" name="pci-0000:00:1f.2-scsi-0:0:0:0-part2" dev=tmpfs ino=1737 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.766:19): avc:  denied  { relabelfrom } for  pid=1742 comm="udevd" name="ata-ST98823AS-5PK2G9N4-part1" dev=tmpfs ino=2336 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.766:20): avc:  denied  { relabelfrom } for  pid=1742 comm="udevd" name="scsi-S_5PK2G9N4-part1" dev=tmpfs ino=2337 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.766:21): avc:  denied  { relabelfrom } for  pid=1742 comm="udevd" name="pci-0000:00:1f.2-scsi-0:0:0:0-part1" dev=tmpfs ino=2338 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.770:22): avc:  denied  { relabelfrom } for  pid=1742 comm="udevd" name="8de60653-2985-4ee7-92be-b6b961b2ee37" dev=tmpfs ino=2339 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.947:23): avc:  denied  { relabelfrom } for  pid=1750 comm="udevd" name="ata-ST98823AS-5PK2G9N4-part6" dev=tmpfs ino=2302 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.947:24): avc:  denied  { relabelfrom } for  pid=1750 comm="udevd" name="scsi-S_5PK2G9N4-part6" dev=tmpfs ino=2305 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.947:25): avc:  denied  { relabelfrom } for  pid=1750 comm="udevd" name="pci-0000:00:1f.2-scsi-0:0:0:0-part6" dev=tmpfs ino=2308 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567797.947:26): avc:  denied  { relabelfrom } for  pid=1750 comm="udevd" name="b996a5bc-640d-454d-a8f1-e770f613a7b5" dev=tmpfs ino=2312 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567798.204:27): avc:  denied  { relabelfrom } for  pid=1930 comm="udevd" name="usb-Logitech_USB_Receiver-mouse" dev=tmpfs ino=3110 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
audit(1186567798.204:28): avc:  denied  { relabelfrom } for  pid=1930 comm="udevd" name="pci-0000:00:1d.1-usb-0:2:1.0-mouse" dev=tmpfs ino=3112 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=lnk_file
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
input: Power Button (FF) as /devices/virtual/input/input4
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/virtual/input/input5
ACPI: Sleep Button (CM) [C23F]
input: Lid Switch as /devices/virtual/input/input6
ACPI: Lid Switch [C238]
ACPI: AC Adapter [C1BA] (on-line)
ACPI: Battery Slot [C1BC] (battery present)
ACPI: Battery Slot [C1BB] (battery absent)
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Yenta: CardBus bridge found at 0000:02:06.0 [103c:30aa]
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:06.0, mfunc 0x01a61b22, devctl 0x64
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.2.2d
ipw3945: Copyright(c) 2003-2006 Intel Corporation
Yenta: ISA IRQ mask 0x0cf8, PCI irq 17
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge I/O window: 0x7000 - 0x7fff
pcmcia: parent PCI bridge Memory window: 0xe8100000 - 0xe83fffff
pcmcia: parent PCI bridge Memory window: 0x60000000 - 0x63ffffff
ACPI: PCI Interrupt 0000:08:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:08:00.0 to 64
ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
audit(1186567798.853:29): avc:  denied  { execute_no_trans } for  pid=2192 comm="sh" path="/lib/alsa/modprobe-post-install" dev=sda1 ino=799890 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:object_r:lib_t:s0 tclass=file
audit(1186567798.876:30): avc:  denied  { getattr } for  pid=2205 comm="mkdir" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567799.030:31): avc:  denied  { getattr } for  pid=2206 comm="alsa-utils" path="/var/lib/alsa/asound.state" dev=sda1 ino=425956 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:var_lib_t:s0 tclass=file
audit(1186567799.080:32): avc:  denied  { getattr } for  pid=2222 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
audit(1186567799.083:33): avc:  denied  { getattr } for  pid=2226 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567799.193:34): avc:  denied  { getattr } for  pid=2216 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.196:35): avc:  denied  { getattr } for  pid=2233 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.196:36): avc:  denied  { getattr } for  pid=2236 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.200:37): avc:  denied  { getattr } for  pid=2239 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.200:38): avc:  denied  { getattr } for  pid=2242 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.203:39): avc:  denied  { getattr } for  pid=2245 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.203:40): avc:  denied  { getattr } for  pid=2248 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.206:41): avc:  denied  { getattr } for  pid=2251 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.210:42): avc:  denied  { getattr } for  pid=2254 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.210:43): avc:  denied  { getattr } for  pid=2257 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.213:44): avc:  denied  { getattr } for  pid=2260 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.216:45): avc:  denied  { getattr } for  pid=2265 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.216:46): avc:  denied  { getattr } for  pid=2268 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.220:47): avc:  denied  { getattr } for  pid=2271 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.223:48): avc:  denied  { getattr } for  pid=2274 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.223:49): avc:  denied  { getattr } for  pid=2277 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.226:50): avc:  denied  { getattr } for  pid=2280 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.226:51): avc:  denied  { getattr } for  pid=2283 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.230:52): avc:  denied  { getattr } for  pid=2286 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.233:53): avc:  denied  { getattr } for  pid=2289 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.233:54): avc:  denied  { getattr } for  pid=2292 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.236:55): avc:  denied  { getattr } for  pid=2295 comm="amixer" path="/usr/share/alsa/alsa.conf" dev=sda1 ino=749381 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:usr_t:s0 tclass=file
audit(1186567799.236:56): avc:  denied  { getattr } for  pid=2206 comm="alsa-utils" path="/var/lib/alsa/asound.state" dev=sda1 ino=425956 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:var_lib_t:s0 tclass=file
Adding 497972k swap on /dev/sda5.  Priority:-1 extents:1 across:497972k
audit(1186567799.903:57): avc:  denied  { getattr } for  pid=2386 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567799.976:58): avc:  denied  { getattr } for  pid=2388 comm="fsck" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:fsadm_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567800.044:59): avc:  denied  { getattr } for  pid=2389 comm="fsck.ext3" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:fsadm_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567800.330:60): avc:  denied  { getattr } for  pid=2394 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
EXT3 FS on sda1, internal journal
audit(1186567800.386:61): avc:  denied  { getattr } for  pid=2399 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.052:62): avc:  denied  { getattr } for  pid=2418 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.055:63): avc:  denied  { getattr } for  pid=2421 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.058:64): avc:  denied  { getattr } for  pid=2425 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.062:65): avc:  denied  { getattr } for  pid=2428 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.065:66): avc:  denied  { getattr } for  pid=2431 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.068:67): avc:  denied  { getattr } for  pid=2434 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.072:68): avc:  denied  { getattr } for  pid=2437 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.082:69): avc:  denied  { getattr } for  pid=2450 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
loop: module loaded
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
audit(1186567801.552:70): avc:  denied  { getattr } for  pid=2566 comm="fsck" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:fsadm_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567801.555:71): avc:  denied  { getattr } for  pid=2567 comm="fsck.ext3" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:fsadm_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
audit(1186567905.828:72): avc:  denied  { getattr } for  pid=2856 comm="mount" name="/" dev=selinuxfs ino=1 scontext=system_u:system_r:mount_t:s0 tcontext=system_u:object_r:security_t:s0 tclass=filesystem
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda6, type ext3), uses xattr
ipw3945: Radio Frequency Kill Switch is On:
Kill switch must be turned off for wireless networking to work.
audit(1186567911.328:73): avc:  denied  { append } for  pid=1904 comm="ifup" name="ifstate" dev=sda1 ino=244450 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:etc_runtime_t:s0 tclass=file
audit(1186567912.178:74): avc:  denied  { search } for  pid=3186 comm="rpc.statd" name="sbin" dev=sda1 ino=260609 scontext=system_u:system_r:rpcd_t:s0 tcontext=system_u:object_r:bin_t:s0 tclass=dir
audit(1186567912.322:75): avc:  denied  { search } for  pid=3185 comm="rpc.statd" scontext=system_u:system_r:rpcd_t:s0 tcontext=system_u:object_r:sysctl_fs_t:s0 tclass=dir
audit(1186567914.425:76): avc:  denied  { use } for  pid=3504 comm="vbetool" path="/dev/console" dev=tmpfs ino=337 scontext=system_u:system_r:vbetool_t:s0 tcontext=system_u:system_r:init_t:s0 tclass=fd
audit(1186567914.425:77): avc:  denied  { write } for  pid=3504 comm="vbetool" path="/var/lib/acpi-support/vbestate" dev=sda1 ino=426769 scontext=system_u:system_r:vbetool_t:s0 tcontext=system_u:object_r:var_lib_t:s0 tclass=file
audit(1186567914.587:78): avc:  denied  { read } for  pid=3517 comm="syslogd" name="xconsole" dev=tmpfs ino=9687 scontext=system_u:system_r:syslogd_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=fifo_file
audit(1186567914.865:79): audit_pid=3539 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
vboxdrv: Trying to deactivate NMI watchdog permanently...
vboxdrv: Successfully done.
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.
VirtualBox[9168]: segfault at b3d71770 eip b3d71770 esp b3afe18c error 4
VBoxSVC[9083]: segfault at 1ba540c3 eip b7c70050 esp b547e0b0 error 4

--=-JyzAw4D7Uw/uHu5zcfac
Content-Disposition: attachment; filename=dmidecode
Content-Type: text/plain; name=dmidecode; charset=UTF-8
Content-Transfer-Encoding: 7bit

# dmidecode 2.9
SMBIOS 2.4 present.
23 structures occupying 1029 bytes.
Table at 0x000F38EB.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Hewlett-Packard
	Version: 68YDU Ver. F.0D
	Release Date: 04/17/2007
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		3.5"/720 KB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		Smart battery is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 15.13
	Firmware Revision: 88.18

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Hewlett-Packard
	Product Name:                                 
	Version: F.0D
	Serial Number:                                 
	UUID: Not Settable
	Wake-up Type: Power Switch
	SKU Number:                 
	Family: 103C_5336AN

Handle 0x0040, DMI type 126, 4 bytes
Inactive

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: Hewlett-Packard
	Product Name: 30AA
	Version: KBC Version 58.12
	Serial Number: Not Specified

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: Hewlett-Packard
	Type: Notebook
	Lock: Not Present
	Version: Not Specified
	Serial Number:                                 
	Asset Tag: CNU63515Y3
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: External Interface Enabled

Handle 0x0041, DMI type 126, 10 bytes
Inactive

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U10
	Type: Central Processor
	Family: Pentium M
	Manufacturer: Intel(R)
	ID: E8 06 00 00 FF FB E9 BF
	Signature: Type 0, Family 6, Model 14, Stepping 8
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Genuine Intel(R) CPU           T2050  @ 1.60GHz
	Voltage: 1.1 V
	External Clock: 133 MHz
	Max Speed: 1600 MHz
	Current Speed: 1600 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: External
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0007, DMI type 9, 13 bytes
System Slot Information
	Designation: PC CARD-Slot 0
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Short
	ID: Adapter 0, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		PME signal is supported

Handle 0x0008, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description: 8

Handle 0x0009, DMI type 11, 5 bytes
OEM Strings
	String 1: www.hp.com
	String 2: ABS 70/71 79 7A 7B 7C

Handle 0x000A, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: No Error
	Number Of Devices: 2

Handle 0x000B, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM #1
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 7F7F7F7F7F510000
	Serial Number: 03016A14
	Asset Tag: Not Specified
	Part Number: 64T64020HDL3SB    

Handle 0x000C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM #2
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 7F7F7F2500000000
	Serial Number: 00000000
	Asset Tag: Not Specified
	Part Number: KSCD48F-A8KB5     

Handle 0x000D, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0005FFFFFFF
	Range Size: 1536 MB
	Physical Array Handle: 0x000A
	Partition Width: 0

Handle 0x000E, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x000B
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: 1

Handle 0x000F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00020000000
	Ending Address: 0x0005FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x000C
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: 2

Handle 0x0010, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0085, DMI type 133, 34 bytes
OEM-specific Type
	Header and Data:
		85 22 85 00 01 A0 0F 2B 0F 2B 0F 05 00 25 00 1D
		00 F0 30 00 00 30 2A 02 E0 40 00 00 4C 10 4F 10
		55 10
	Strings:
		11952 08/03/2006
		HP                

Handle 0x0086, DMI type 126, 34 bytes
Inactive

Handle 0x0011, DMI type 144, 26 bytes
OEM-specific Type
	Header and Data:
		90 1A 11 00 5B 00 65 00 DE 00 5D 00 0C 00 13 00
		00 00 0C 00 19 00 43 01 00 00

Handle 0x0012, DMI type 127, 4 bytes
End Of Table


--=-JyzAw4D7Uw/uHu5zcfac--

