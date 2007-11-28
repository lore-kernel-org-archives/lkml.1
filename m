Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbXK1R7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbXK1R7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbXK1R7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:59:13 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:38834 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXK1R7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:59:11 -0500
Date: Wed, 28 Nov 2007 19:59:07 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: ata4294967295: failed to start port (errno=-19)
Message-ID: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got the message about ata4294967295 - looks like an uninitialzed 
variable or negative wrapraound. This is PIIX4 class ide on 440BX based 
laptop (Thinkpad X20). Everything seems to work fine though, there is 
only one PATA HDD attached and it works fine.

This message comes from 2.6.24-rc3 + todays git, version 
a531a141089714efe39eca89593524fdf05104f2. I did grep the logs and found 
that it first appeared in 2.6.24-rc1 (+ some git mayve) on Nov 3. 
I used 2.6.23 before that and it did not show this message.

Full dmesg:

Linux version 2.6.24-rc3 (mroos@tulp) (gcc version 4.2.3 20071123 (prerelease) (Debian 4.2.2-4)) #1 Wed Nov 28 10:24:37 EET 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dd000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000013ff0000 (usable)
 BIOS-e820: 0000000013ff0000 - 0000000013ffec00 (ACPI data)
 BIOS-e820: 0000000013ffec00 - 0000000014000000 (ACPI NVS)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
319MB LOWMEM available.
Entering add_active_range(0, 0, 81904) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    81904
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    81904
On node 0 totalpages: 81904
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 607 pages used for memmap
  Normal zone: 77201 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F6EC0, 0014 (r0 PTLTD )
ACPI: RSDT 13FF5C49, 002C (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 13FFEB65, 0074 (r1 IBM    TP-X21    6040000             0)
ACPI: DSDT 13FF5C75, 8EF0 (r1 IBM    TP-X21    6040000 MSFT  100000C)
ACPI: FACS 13FFF000, 0040
ACPI: BOOT 13FFEBD9, 0027 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 20000000 (gap: 14000000:ebf80000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000dd000
swsusp: Registered nosave memory region: 00000000000dd000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81265
Kernel command line: root=/dev/sda1 ro resume=/dev/sda2 
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01283000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0385000 soft=c0384000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 597.424 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 316420k/327616k available (1746k kernel code, 10624k reserved, 629k data, 180k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xd4800000 - 0xfffb3000   ( 695 MB)
    lowmem  : 0xc0000000 - 0xd3ff0000   ( 319 MB)
      .init : 0xc0354000 - 0xc0381000   ( 180 kB)
      .data : 0xc02b4b18 - 0xc0352244   ( 629 kB)
      .text : 0xc0100000 - 0xc02b4b18   (1746 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 1195.55 BogoMIPS (lpj=5977766)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium III (Coppermine) stepping 03
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0e20)
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd94f, last bus=7
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-103f claimed by PIIX4 ACPI
PCI quirk: region 1040-104f claimed by PIIX4 SMB
PIIX4 devres I PIO at 03f0-03f7
PIIX4 devres J PIO at 002e-002f
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 9 11) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs *9 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 9 11) *5
ACPI: Power Resource [PSIO] (on)
ACPI: Power Resource [PSER] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff could not be reserved
system 00:02: ioport range 0x1000-0x103f has been reserved
system 00:02: ioport range 0x1040-0x104f has been reserved
system 00:02: ioport range 0xfe00-0xfe0f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: f4100000-f5ffffff
  PREFETCH window: disabled.
PCI: Bus 2, cardbus bridge: 0000:00:08.0
  IO window: 00001400-000014ff
  IO window: 00001c00-00001cff
  PREFETCH window: 20000000-23ffffff
  MEM window: 24000000-27ffffff
PCI: Bus 6, cardbus bridge: 0000:00:08.1
  IO window: 00003000-000030ff
  IO window: 00003400-000034ff
  PREFETCH window: 28000000-2bffffff
  MEM window: 2c000000-2fffffff
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:08.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Unpacking initramfs...<7>Switched to high resolution mode on CPU 0
 done
Freeing initrd memory: 4775k freed
Simple Boot Flag at 0x35 set to 0x1
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
Boot video device is 0000:01:00.0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial 00:0b: activated
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.1[A] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
console [netcon0] enabled
netconsole: network logging started
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 180k freed
Write protecting the kernel text: 1748k
Write protecting the kernel read-only data: 466k
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU] (supports 8 throttling states)
Marking TSC unstable due to: TSC halts in idle.
ACPI: Thermal Zone [THM0] (52 C)
Time: acpi_pm clocksource has been installed.
SCSI subsystem initialized
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
e100: eth0: e100_probe: addr 0xf4010000, irq 9, MAC addr 00:90:27:96:b1:d0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00001820
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
libata version 3.00 loaded.
ata4294967295: failed to start port (errno=-19)
ata_piix 0000:00:07.1: version 2.12
Floppy drive(s): fd0 is 1.44M
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1800 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1808 irq 15
ata1.00: ATA-5: IC25N020ATCS04-0, CA2OA71A, max UDMA/100
ata1.00: 39070080 sectors, multi 16: LBA 
ata1.00: configured for UDMA/33
Clocksource tsc unstable (delta = -235750971 ns)
scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATCS04-0 CA2O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
floppy0: no floppy controllers found
Attempting manual resume
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input1
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Yenta: CardBus bridge found at 0000:00:08.0 [1014:0185]
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000006
Yenta: CardBus bridge found at 0000:00:08.1 [1014:0185]
Floppy drive(s): fd0 is 1.44M
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000006
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input2
parport_pc 00:0c: activated
parport_pc 00:0c: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
input: Video Bus as /class/input/input6
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
floppy0: no floppy controllers found
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery absent)
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
gameport: CS4281 Gameport is pci0000:00:0b.0/gameport0, speed 2294kHz
EXT3 FS on sda1, internal journal
Non-volatile memory driver v1.2
thinkpad_acpi: ThinkPad ACPI Extras v0.17
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS IZET9BWW (2.23 ), EC unknown
thinkpad_acpi: acpi_bus_get_device(bay) failed: -19
thinkpad_acpi: disabling subdriver bay
input: ThinkPad Extra Buttons as /class/input/input7
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
input: /usr/sbin/thinkpad-keys as /class/input/input8
eth0: no IPv6 routers present
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8

-- 
Meelis Roos (mroos@linux.ee)
