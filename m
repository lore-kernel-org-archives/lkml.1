Return-Path: <linux-kernel-owner+w=401wt.eu-S1030912AbXDVO1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030912AbXDVO1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030916AbXDVO1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:27:13 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:4291 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030907AbXDVO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y41PGGsQ//rOExkmypc6Mz+jI98Xmdgo1k2TDE2s3ZauWyh/p90T+POGo3CVeph508+nZuIaLVQx16avNL8HY8xWbSeF8St7SNJURRDluArrVXqKaeB3NzK1RerX8h2bUyGioFRdtW2HRMw/ojbT4sj7MqQ9bmnmEWO6KqNBPq4=
Message-ID: <8355959a0704220727x6624db8etf2fb890675557bf2@mail.gmail.com>
Date: Sun, 22 Apr 2007 19:57:08 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc7 - ACPI issues?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070421124614.1206dcfa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8355959a0704210703n35b0dc35wcad04e5723eaec7@mail.gmail.com>
	 <20070421124614.1206dcfa.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> (added linux-acpi)
>
> Are any other problems observeable due to this?

This issue I did observe with 2.6.20.7 & 2.6.21-rc7. Should I try anymore tests?

Anyway, here is the dmesg of 2.6.21-rc7:-

Linux version 2.6.21-rc7-Akula2 (root@Akula2) (gcc version 4.1.1
20070105 (Red Hat 4.1.1-51)) #1 PREEMPT Wed Apr 18 02:53:35 IST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fdf0000 end:
000000001fef0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fef0000 size: 0000000000008000 end:
000000001fef8000 type: 3
copy_e820_map() start: 000000001fef8000 size: 0000000000008000 end:
000000001ff00000 type: 4
copy_e820_map() start: 00000000fffc0000 size: 0000000000040000 end:
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001fef8000 (ACPI data)
 BIOS-e820: 000000001fef8000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
510MB LOWMEM available.
found SMP MP-table at 000fbb10
Entering add_active_range(0, 0, 130800) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   130800
early_node_map[1] active PFN ranges
    0:        0 ->   130800
On node 0 totalpages: 130800
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 989 pages used for memmap
  Normal zone: 125715 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000FA380, 0014 (r0 AMI   )
ACPI: RSDT 1FEF0000, 002C (r1 AMIINT AMIITN09       10 MSFT       97)
ACPI: FACP 1FEF0030, 0081 (r1 AMIINT AMIITN09       11 MSFT       97)
ACPI: DSDT 1FEF0120, 3147 (r1  INTEL  WHITNEY     1000 MSFT  100000D)
ACPI: FACS 1FEF8000, 0040
ACPI: APIC 1FEF00C0, 0054 (r1 AMIINT AMIITN09        9 MSFT       97)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:11 APIC version 17
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 20000000 (gap: 1ff00000:e00c0000)
Built 1 zonelists.  Total pages: 129779
Kernel command line: ro root=LABEL=/
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1202.765 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 513140k/523200k available (2297k kernel code, 9524k reserved,
739k data, 212k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfef0000   ( 510 MB)
      .init : 0xc03fa000 - 0xc042f000   ( 212 kB)
      .data : 0xc033e525 - 0xc03f7514   ( 739 kB)
      .text : 0xc0100000 - 0xc033e525   (2297 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 2406.23 BogoMIPS (lpj=1203118)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000
00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040
00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Pentium(R) III CPU             1200MHz stepping 01
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfdb81, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:01.0
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
0000:00:1f.1: cannot adjust BAR0 (not I/O)
0000:00:1f.1: cannot adjust BAR1 (not I/O)
0000:00:1f.1: cannot adjust BAR2 (not I/O)
0000:00:1f.1: cannot adjust BAR3 (not I/O)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.ICHB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 9) *11
ACPI Error (psargs-0355): [PRSE] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKE._PRS] (Node c147ff40), AE_NOT_FOUND
ACPI Exception (pci_link-0179): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI Error (psargs-0355): [PRSF] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKF._PRS] (Node c147fea0), AE_NOT_FOUND
ACPI Exception (pci_link-0179): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI Error (psargs-0355): [PRSG] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKG._PRS] (Node c147fe00), AE_NOT_FOUND
ACPI Exception (pci_link-0179): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI Error (psargs-0355): [PRSH] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKH._PRS] (Node c147975c), AE_NOT_FOUND
ACPI Exception (pci_link-0179): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Time: tsc clocksource has been installed.
PCI: Ignore bogus resource 6 [0:0] of 0000:00:01.0
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: efd00000-efdfffff
  PREFETCH window: e7b00000-e7bfffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1484k freed
audit: initializing netlink socket (disabled)
audit(1177270662.133:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: Processor [CPU1] (supports 8 throttling states)
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel i810 E Chipset.
agpgart: AGP aperture is 64M @ 0xe8000000
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH2: IDE controller at PCI slot 0000:00:1f.1
ICH2: chipset revision 5
ICH2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xff08-0xff0f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: ST310212A, ATA DISK drive
hdb: SONY CD-RW CRX320E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 212k freed
input: AT Translated Set 2 keyboard as /class/input/input3
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 16, io base 0x0000dd80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:01:04.0[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:01:04.0: OHCI Host Controller
ohci_hcd 0000:01:04.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:01:04.0: irq 17, io mem 0xefdfd000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:01:04.1[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:01:04.1: OHCI Host Controller
ohci_hcd 0000:01:04.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:01:04.1: irq 18, io mem 0xefdfe000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:01:04.3[A] -> GSI 16 (level, low) -> IRQ 19
ehci_hcd 0000:01:04.3: EHCI Host Controller
ehci_hcd 0000:01:04.3: new USB bus registered, assigned bus number 4
ehci_hcd 0000:01:04.3: debug port 1
ehci_hcd 0000:01:04.3: irq 19, io mem 0xefdffe00
ehci_hcd 0000:01:04.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
hda: max request size: 128KiB
hda: 20005650 sectors (10242 MB) w/512KiB Cache, CHS=19846/16/63, UDMA(66)
hda: cache flushes not supported
 hda: hda1 hda2 hda3
SCSI subsystem initialized
libata version 2.20 loaded.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 3-1: new low speed USB device using ohci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
input: Microsoft Basic Optical Mouse as /class/input/input4
input: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:01:04.1-1
usb 3-2: new full speed USB device using ohci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1177270668.133:2): selinux=0 auid=4294967295
hdb: ATAPI 40X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 17 (level, low) -> IRQ 17
eth0: VIA Rhine III at 0xefdfff00, 00:15:e9:48:b1:a4, IRQ 17.
eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 0021.
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
iTCO_wdt: No card detected
input: PC Speaker as /class/input/input5
intel_rng: FWH not detected
i810_smbus 0000:00:01.0: i810/i815 i2c device found.
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 50936 usecs
intel8x0: clocking to 48000
lp0: using parport0 (interrupt-driven).
EXT3 FS on hda3, internal journal
fuse init (API version 7.8)
Adding 265032k swap on /dev/hda2.  Priority:-1 extents:1 across:265032k
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4087 buckets, 32696 max)
eth0: link up, 10Mbps, half-duplex, lpa 0x0021
audit(1177250889.564:3): audit_pid=1692 old=0 by auid=4294967295


~Akula2
