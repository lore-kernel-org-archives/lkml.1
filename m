Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbXFRPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbXFRPPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763764AbXFRPPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:15:24 -0400
Received: from lug.demon.co.uk ([83.104.159.110]:54473 "EHLO
	mango.david-web.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755196AbXFRPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:15:23 -0400
From: David Johnson <dj@david-web.co.uk>
Reply-To: linux-kernel@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Sound plays at half speed; intel8x0 clock issue
Date: Mon, 18 Jun 2007 16:15:13 +0100
User-Agent: KMail/1.9.5
References: <200706181337.43868.dj@david-web.co.uk> <20070618145622.GA28145@saeurebad.de>
In-Reply-To: <20070618145622.GA28145@saeurebad.de>
Cc: Johannes Weiner <hannes-kernel@saeurebad.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CGqdGPQsHQcc4hh"
Message-Id: <200706181615.14140.dj@david-web.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CGqdGPQsHQcc4hh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 18 June 2007 15:56, Johannes Weiner wrote:
>
> Perhaps you might want to try the acpi_use_timer_override bootflag?
>

I'm afraid that doesn't make any difference. I attach the new dmesg with that 
flag set, in case it's helpful.

Thanks,
David.

-- 
David Johnson
www.david-web.co.uk

--Boundary-00=_CGqdGPQsHQcc4hh
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg2"

Linux version 2.6.21.5 (root@fdj) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Fri Jun 15 22:45:06 BST 2007
Command line: root=/dev/sda1 ro acpi_use_timer_override=1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.2 present.
ACPI: RSDP 000F8000, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF3180, 4D75 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: SSDT 3FFF8000, 0118 (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: MCFG 3FFF8180, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FFF7F40, 0072 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Scanning NUMA topology in Northbridge 24
Number of nodes 1
Node 0 MemBase 0000000000000000 Limit 000000003fff0000
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
NUMA: Using 63 for the hash shift.
Using node hash shift of 63
Bootmem setup node 0 0000000000000000-000000003fff0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      157
    0:      256 ->   262128
On node 0 totalpages: 262029
  DMA zone: 56 pages used for memmap
  DMA zone: 1021 pages reserved
  DMA zone: 2920 pages, LIFO batch:0
  DMA32 zone: 3527 pages used for memmap
  DMA32 zone: 254505 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009d000 - 000000000009e000
Nosave address range: 000000000009e000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000f0000
Nosave address range: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
SMP: Allowing 2 CPUs, 1 hotplug CPUs
PERCPU: Allocating 36800 bytes of per cpu data
Built 1 zonelists.  Total pages: 257425
Kernel command line: root=/dev/sda1 ro acpi_use_timer_override=1
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2412.405 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ 7be0000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1023048k/1048512k available (2094k kernel code, 25068k reserved, 997k data, 300k init)
Calibrating delay using timer specific routine.. 4826.12 BogoMIPS (lpj=2413062)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12564624
Detected 12.564 MHz APIC timer.
Brought up 1 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
Boot video device is 0000:05:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0A08
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0401
pnp: ACPI device : hid PNP0F13
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 14 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:00' and the driver 'system'
pnp: 00:00: ioport range 0x4000-0x407f has been reserved
pnp: 00:00: ioport range 0x4080-0x40ff has been reserved
pnp: 00:00: ioport range 0x4400-0x447f has been reserved
pnp: 00:00: ioport range 0x4480-0x44ff has been reserved
pnp: 00:00: ioport range 0x4800-0x487f has been reserved
pnp: 00:00: ioport range 0x4880-0x48ff has been reserved
pnp: match found with the PnP device '00:02' and the driver 'system'
pnp: match found with the PnP device '00:0c' and the driver 'system'
pnp: 00:0c: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: match found with the PnP device '00:0d' and the driver 'system'
pnp: 00:0d: iomem range 0xd1800-0xd3fff has been reserved
pnp: 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0d: iomem range 0xfc000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:09.0
  IO window: c000-cfff
  MEM window: fde00000-fdefffff
  PREFETCH window: fdf00000-fdffffff
PCI: Bridge: 0000:00:0b.0
  IO window: b000-bfff
  MEM window: fdd00000-fddfffff
  PREFETCH window: fdc00000-fdcfffff
PCI: Bridge: 0000:00:0c.0
  IO window: a000-afff
  MEM window: fdb00000-fdbfffff
  PREFETCH window: fda00000-fdafffff
PCI: Bridge: 0000:00:0d.0
  IO window: 9000-9fff
  MEM window: fd900000-fd9fffff
  PREFETCH window: fd800000-fd8fffff
PCI: Bridge: 0000:00:0e.0
  IO window: 8000-8fff
  MEM window: fd700000-fd7fffff
  PREFETCH window: d8000000-dfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4947k freed
audit: initializing netlink socket (disabled)
audit(1182178994.485:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:07' and the driver 'serial'
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: match found with the PnP device '00:08' and the driver 'serial'
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:0b' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 300k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Fan [FAN] (on)
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI: Thermal Zone [THRM] (36 C)
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0xfe02f000
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ieee1394: Initialized config rom entry `ip1394'
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
usb 2-5: new high speed USB device using ehci_hcd and address 2
usb 2-5: configuration #1 chosen from 1 choice
hub 2-5:1.0: USB hub found
hub 2-5:1.0: 4 ports detected
eth0: forcedeth.c: subsystem: 0105b:0ca2 bound to 0000:00:0a.0
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:0b.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[fdeff000-fdeff7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
pata_amd 0000:00:06.0: version 0.2.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001e000 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001e008 irq 15
scsi0 : pata_amd
ata1.00: ATA-7: WDC WD2500JB-00REA0, 20.00K20, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
scsi1 : pata_amd
ata2.00: ATAPI, max UDMA/66
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500JB-00R 20.0 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            ATAPI    DVD A  DH20A1P   6X14 PQ: 0 ANSI: 5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00016c200008b67b]
eth1394: eth0: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x4d00
input: PC Speaker as /class/input/input1
pnp: the driver 'parport_pc' has been registered
pnp: match found with the PnP device '00:09' and the driver 'parport_pc'
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 51319 usecs
intel8x0: measured clock 29150 rejected
intel8x0: clocking to 48000
input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
EXT3 FS on sda1, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
JFS: nTxBlock = 8033, nTxLock = 64268
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[fglrx] Maximum main memory to use for locked dma buffers: 922 MBytes.
[fglrx] module loaded - fglrx 8.37.6 [May 25 2007] on minor 0
eth1: no IPv6 routers present
ACPI: PCI interrupt for device 0000:00:04.0 disabled
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI interrupt for device 0000:00:04.0 disabled
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI interrupt for device 0000:00:04.0 disabled
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI interrupt for device 0000:00:04.0 disabled
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI interrupt for device 0000:00:04.0 disabled
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI interrupt for device 0000:00:04.0 disabled

--Boundary-00=_CGqdGPQsHQcc4hh--
