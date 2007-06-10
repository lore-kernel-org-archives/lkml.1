Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbXFJDBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbXFJDBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 23:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXFJDBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 23:01:23 -0400
Received: from web52606.mail.re2.yahoo.com ([206.190.48.209]:27373 "HELO
	web52606.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753455AbXFJDBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 23:01:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=p4UmRBGY7MWSX4deu1mBl+oeQRgVlychXnAxQjFJ0D+Nsr7qIGJEhZfvn4yo8EUs1DMM7Tu6VCKYLK70rL6LrZDp7a4TUU17hdscyVS/5Aa8z/NGQHml6y/87skvpnzm8m71eCOg7FoISx4VaeZUZqNzc/1IRIRNfJW9HTD9Mh8=;
X-YMail-OSG: 1IWF_zMVM1kQquCikAMNshfFyo1_cwqVthypY8bH4OhXVWVY7CTYA9hXtCGHObcEygOc8Et3kkF4siweFYUfDbZuYrnx7SMt4077zf0U.ed_q5dKojOf8GB1OdGfTyRlASDOzjoJOdNhhbE-
Date: Sun, 10 Jun 2007 12:35:34 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: AMD690G - Asus M2A-VM - HPET support?
To: lkml <linux-kernel@vger.kernel.org>
Cc: andi@firstfloor.org, vojtech@suse.cz
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1876563292-1181442934=:31004"
Content-Transfer-Encoding: 8bit
Message-ID: <933515.31004.qm@web52606.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1876563292-1181442934=:31004
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Asus M2A-VM board with the most recent BIOS update
AM2 5600
x86-64 kernel

With newer kernels (like 2.6.22-rc4), kernel hangs solid during bootup: no
oops, bug or panic etc. With nohpet kernel parameter, it boots fine.

(I referred to the following threads:
http://marc.info/?l=linux-kernel&w=2&r=1&s=SB600+HPET&q=b ; there was no
conclusion I could understand.)

Interestingly with older 2.6.20.x, like the one on Kubuntu 7.04, though hpet
doesn't appear to be working - it reports hpet resource being busy, it doesn't
hang at least.

The complete dmesg of the 2.6.22-rc4 (latest hg snapshot at 57858:a9502f591925
from http://www.kernel.org/hg/linux-2.6) booted with nohpet is attached.

Curiously, both the BIOS settings & the board's manual imply it's a working
feature with the other non-Linux OS :-), not that I verified.

Who can I buy a few pints to get hpet going on this board? (if at all it's
going to work)

Of course, patches, suggestions welcome. More info on request.

Thanks



      
_________________________________________________________________________________              

How would you spend $50,000 to create a more sustainable environment in Australia? Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html



--0-1876563292-1181442934=:31004
Content-Type: text/plain; name="2.6.22-rc4-hg.txt"
Content-Description: 2256096228-2.6.22-rc4-hg.txt
Content-Disposition: inline; filename="2.6.22-rc4-hg.txt"

Linux version 2.6.22-rc4 (hari@localhost) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #11 SMP Sat Jun 9 15:15:26 EST 2007
Command line: ro root=LABEL=/ nohpet rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
 BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
 BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
 BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1179648) 2 entries of 3200 used
end_pfn_map = 1179648
DMI 2.4 present.
ACPI: RSDP 000F8100, 0024 (r2 ATI   )
ACPI: XSDT DFEE3100, 004C (r1 ATI    ASUSACPI 42302E31 AWRD        0)
ACPI: FACP DFEE8400, 00F4 (r3 ATI    ASUSACPI 42302E31 AWRD        0)
ACPI: DSDT DFEE3280, 511E (r1 ATI    ASUSACPI     1000 MSFT  3000000)
ACPI: FACS DFEE0000, 0040
ACPI: SSDT DFEE8600, 02CC (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET DFEE8940, 0038 (r1 ATI    ASUSACPI 42302E31 AWRD       98)
ACPI: MCFG DFEE89C0, 003C (r1 ATI    ASUSACPI 42302E31 AWRD        0)
ACPI: APIC DFEE8540, 0068 (r1 ATI    ASUSACPI 42302E31 AWRD        0)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-0000000120000000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1179648) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000120000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1179648
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   917216
    0:  1048576 ->  1179648
On node 0 totalpages: 1048191
  DMA zone: 56 pages used for memmap
  DMA zone: 1942 pages reserved
  DMA zone: 2001 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 898840 pages, LIFO batch:31
  Normal zone: 1792 pages used for memmap
  Normal zone: 129280 pages, LIFO batch:31
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8200 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
PERCPU: Allocating 33608 bytes of per cpu data
Built 1 zonelists.  Total pages: 1030121
Kernel command line: ro root=LABEL=/ nohpet rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2800.020 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
Checking aperture...
CPU 0: aperture @ 4000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 4058532k/4718592k available (1999k kernel code, 134232k reserved, 1168k data, 292k init)
SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, Processors=2, Nodes=1
Calibrating delay using timer specific routine.. 5604.57 BogoMIPS (lpj=11209149)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 22k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12500096
Detected 12.500 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5600.22 BogoMIPS (lpj=11200459)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ stepping 03
Brought up 2 CPUs
migration_cost=264
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 1 of device 0000:00:14.0
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
pnp: 00:01: ioport range 0x4100-0x411f has been reserved
pnp: 00:01: ioport range 0x228-0x22f has been reserved
pnp: 00:01: ioport range 0x40b-0x40b has been reserved
pnp: 00:01: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:01: ioport range 0xc00-0xc01 has been reserved
pnp: 00:01: ioport range 0xc14-0xc14 has been reserved
pnp: 00:01: ioport range 0xc50-0xc52 has been reserved
pnp: 00:01: ioport range 0xc6c-0xc6d has been reserved
pnp: 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0b: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:0b: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0b: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:02.0
  IO window: d000-dfff
  MEM window: fdc00000-fdcfffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:07.0
  IO window: e000-efff
  MEM window: fdb00000-fdbfffff
  PREFETCH window: fdf00000-fdffffff
PCI: Bridge: 0000:00:14.4
  IO window: c000-cfff
  MEM window: fde00000-fdefffff
  PREFETCH window: fdd00000-fddfffff
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:07.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 13, 33554432 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3091k freed
Initializing RT-Tester: OK
audit: initializing netlink socket (disabled)
audit(1181441239.152:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie03]
PCI: Setting latency timer of device 0000:00:07.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:07.0:pcie00]
Allocate Port Service[0000:00:07.0:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Real Time Clock Driver v1.12ac
hpet_acpi_add: no address or irqs in _CRS
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing enabled
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
Freeing unused kernel memory: 292k freed
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: new low speed USB device using ohci_hcd and address 2
ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 2-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input0
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:13.1-1
drivers/hid/usbhid/hid-core.c: Fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as /class/input/input1
input,hiddev96: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-1
ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb 2-1: USB disconnect, address 2
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 10 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
ahci 0000:00:12.0: version 2.2
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
usb 2-1: new low speed USB device using ohci_hcd and address 3
usb 2-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:13.1-1
drivers/hid/usbhid/hid-core.c: Fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as /class/input/input3
input,hiddev96: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-1
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq ilck pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20000636100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata2: SATA max UDMA/133 cmd 0xffffc20000636180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata3: SATA max UDMA/133 cmd 0xffffc20000636200 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata4: SATA max UDMA/133 cmd 0xffffc20000636280 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata1.00: ATA-7: ST3250620NS, 3.AEG, max UDMA/133
ata1.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI, max UDMA/66
ata2.00: configured for UDMA/66
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata3.00: ATA-7: ST3250620NS, 3.AEG, max UDMA/133
ata3.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata3.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3250620NS      3.AE PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            ASUS     DRW-1814BLT      1.04 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      ST3250620NS      3.AE PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 2:0:0:0: [sdb] Attached SCSI disk
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1181441247.084:2): enforcing=1 old_enforcing=0 auid=4294967295
security:  3 users, 6 roles, 1817 types, 79 bools, 1 sens, 1024 cats
security:  60 classes, 67748 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sdb3, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
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
audit(1181441247.228:3): policy loaded auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
sd 2:0:0:0: Attached scsi generic sg2 type 0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:04 failed with error -16
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: RTL8168b/8111b at 0xffffc2000067a000, 00:1a:92:6f:e9:d5, IRQ 19
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
SELinux: initialized (dev kvmfs, type kvmfs), uses genfs_contexts
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
loop: module loaded
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (40 C)
md: md0 stopped.
md: bind<sdb1>
md: bind<sda2>
md: raid0 personality registered for level 0
md0: setting max_sectors to 512, segment boundary to 131071
raid0: looking at sda2
raid0:   comparing sda2(122881024) with sda2(122881024)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sdb1
raid0:   comparing sdb1(122881024) with sda2(122881024)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 245762048 blocks.
raid0 : conf->hash_spacing is 245762048 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.
EXT3 FS on sdb3, internal journal
kjournald starting.  Commit interval 30 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
kjournald starting.  Commit interval 30 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev dm-0, type ext3), uses xattr
kjournald starting.  Commit interval 30 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev dm-1, type ext3), uses xattr
kjournald starting.  Commit interval 30 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev dm-2, type ext3), uses xattr
kjournald starting.  Commit interval 30 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev dm-3, type ext3), uses xattr
kjournald starting.  Commit interval 30 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev dm-4, type ext3), uses xattr
kjournald starting.  Commit interval 30 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev dm-5, type ext3), uses xattr
kjournald starting.  Commit interval 30 seconds
EXT3 FS on dm-6, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SELinux: initialized (dev dm-6, type ext3), uses xattr
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.27.0 20060524 on minor 0
Adding 1052248k swap on /dev/sdb2.  Priority:-1 extents:1 across:1052248k
Adding 1052248k swap on /dev/sda3.  Priority:-2 extents:1 across:1052248k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
NET: Registered protocol family 17
r8169: eth0: link up
r8169: eth0: link up
audit(1181441284.732:4): audit_pid=1849 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
it87: Found IT8716F chip at 0x228, revision 1
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
Bridge firewalling registered
powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ processors (version 2.00.00)
powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs
hda-intel: Invalid position buffer, using LPIB read method instead.

--0-1876563292-1181442934=:31004--
