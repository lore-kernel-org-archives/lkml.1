Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbXESQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbXESQmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXESQmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:42:09 -0400
Received: from mx34.mail.ru ([194.67.23.200]:15423 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755669AbXESQmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:42:04 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.22-rc2: regression: STD fails with pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x160 [usbcore]() returns -16
Date: Sat, 19 May 2007 20:41:56 +0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0705191058570.8729-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705191058570.8729-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1234224.mW8oUJD0hs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705192041.57504.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1234224.mW8oUJD0hs
Content-Type: multipart/mixed;
  boundary="Boundary-01=_VjyTGfO4Gxfsn25"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_VjyTGfO4Gxfsn25
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 19 May 2007, Alan Stern wrote:
> On Sat, 19 May 2007, Andrey Borzenkov wrote:
> > This works just fine up to and including 2.6.21.
> >
> > unfortunatelt dmesg got truncated; if required I can rebuild with larger
> > buffer; the part around suspend is
> >
> > swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> > swsusp: Basic memory bitmaps created
> > Stopping tasks ... done.
> > Shrinking memory... done (14553 pages freed)
> > Freed 58212 kbytes in 0.30 seconds (194.04 MB/s)
> > Suspending console(s)
> > sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > pnp: Device 00:09 disabled.
> > ACPI: PCI interrupt for device 0000:00:0a.0 disabled
> > Trying to free already-free IRQ 11
> > ACPI: PCI interrupt for device 0000:00:06.0 disabled
> > ACPI: Unable to derive IRQ for device 0000:00:04.0
> > pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x160 [usbcore]() returns
> > -16 suspend_device(): pci_device_suspend+0x0/0x70() returns -16
> > Could not suspend device 0000:00:02.0: error -16
>
> Please turn on CONFIG_USB_DEBUG and post the resulting dmesg log.
>

Attached.=20

--Boundary-01=_VjyTGfO4Gxfsn25
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dmesg"

Linux version 2.6.22-rc2-cfs-v13-1avb (bor@cooker) (gcc version 4.1.2 20070=
302 (prerelease) (4.1.2-1mdv2007.1)) #6 Sat May 19 20:25:58 MSD 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
 BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
 BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
 BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
 BIOS-e820: 000000001ef70000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
495MB LOWMEM available.
Entering add_active_range(0, 0, 126816) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   126816
early_node_map[1] active PFN ranges
    0:        0 ->   126816
On node 0 totalpages: 126816
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 958 pages used for memmap
  Normal zone: 121762 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM  4010000)
ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT  100000A)
ACPI: FACS 000EEE00, 0040
ACPI: PM-Timer IO Port: 0xee08
Allocating PCI resources starting at 30000000 (gap: 20000000:dff80000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 00000000000ee000
swsusp: Registered nosave memory region: 00000000000ee000 - 00000000000ef000
swsusp: Registered nosave memory region: 00000000000ef000 - 0000000000100000
Built 1 zonelists.  Total pages: 125826
Kernel command line: BOOT_IMAGE=3D2.6.22-rc2-cfs-v13-1avb root=3DLABEL=3D/ =
resume=3D/dev/sda1 vga=3D791
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (013e8000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 747.771 MHz processor.
Console: colour dummy device 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
=2E.. MAX_LOCKDEP_SUBCLASSES:    8
=2E.. MAX_LOCK_DEPTH:          30
=2E.. MAX_LOCKDEP_KEYS:        2048
=2E.. CLASSHASH_SIZE:           1024
=2E.. MAX_LOCKDEP_ENTRIES:     8192
=2E.. MAX_LOCKDEP_CHAINS:      16384
=2E.. CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1200 bytes
=2D-----------------------
| Locking API testsuite:
=2D------------------------------------------------------------------------=
=2D--
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
=2D------------------------------------------------------
Good, all 218 testcases passed! |
=2D--------------------------------
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 495880k/507264k available (1828k kernel code, 10812k reserved, 847k=
 data, 200k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xdf800000 - 0xfffb5000   ( 519 MB)
    lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
      .init : 0xc03a0000 - 0xc03d2000   ( 200 kB)
      .data : 0xc02c91da - 0xc039ce54   ( 847 kB)
      .text : 0xc0100000 - 0xc02c91da   (1828 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1497.68 BogoMIPS (lpj=3D24=
95493)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 0000=
0000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00=
000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium III (Coppermine) stepping 0a
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0a00)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
PCI quirk: region ef00-ef1f claimed by ali7101 SMB
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
ACPI: Power Resource [PFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xeffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x1ef5ffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: f7f00000-fdffffff
  PREFETCH window: 48000000-480fffff
PCI: Bus 2, cardbus bridge: 0000:00:10.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 34000000-37ffffff
PCI: Bus 6, cardbus bridge: 0000:00:11.0
  IO window: 00001800-000018ff
  IO window: 00001c00-00001cff
  PREFETCH window: 38000000-3bffffff
  MEM window: 3c000000-3fffffff
PCI: Bus 10, cardbus bridge: 0000:00:11.1
  IO window: 00002000-000020ff
  IO window: 00002400-000024ff
  PREFETCH window: 40000000-43ffffff
  MEM window: 44000000-47ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11 (level, low) -=
> IRQ 11
PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 (level, low) -=
> IRQ 11
PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11 (level, low) -=
> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 7, 720896 bytes)
TCP bind hash table entries: 16384 (order: 7, 720896 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
=46reeing initrd memory: 1171k freed
audit: initializing netlink socket (disabled)
audit(1179592394.226:1): initialized
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Activating ISA DMA hang workarounds.
Boot video device is 0000:01:00.0
vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, using 3072k, total=
 16384k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
vesafb: protected mode interface info at c000:775e
vesafb: pmi: set display start =3D c00c777f, set palette =3D c00c77e2
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Switched to high resolution mode on CPU 0
Real Time Clock Driver v1.12ac
RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
NET: Registered protocol family 1
Using IPI Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
=46reeing unused kernel memory: 200k freed
Write protecting the kernel text: 1832k
Write protecting the kernel read-only data: 670k
SCSI subsystem initialized
input: AT Translated Set 2 keyboard as /class/input/input0
libata version 2.20 loaded.
ACPI: Unable to derive IRQ for device 0000:00:04.0
ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
scsi0 : pata_ali
scsi1 : pata_ali
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001eff0 irq =
14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001eff8 irq =
15
ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors =3D 39070080
ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
ata1.00: 39070080 sectors, multi 0: LBA=20
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors =3D 39070080
ata1.00: configured for UDMA/33
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0 DA3O PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 1313 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: Using r5 hash to sort names
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected ALi M1644 chipset
agpgart: AGP aperture is 64M @ 0xf0000000
Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
Yenta: ISA IRQ mask 0x0000, PCI irq 11
Socket status: 30000059
Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000007
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11 (level, low) -=
> IRQ 11
ohci_hcd 0000:00:02.0: OHCI Host Controller
/home/bor/src/linux-git/drivers/usb/core/inode.c: creating file 'devices'
/home/bor/src/linux-git/drivers/usb/core/inode.c: creating file '001'
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
NET: Registered protocol family 23
ohci_hcd 0000:00:02.0: enabling initreset quirk
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.0: control 0x083 HCFS=3Doperational CBSR=3D3
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=3D0
ohci_hcd 0000:00:02.0: intrstatus 0x00000044 RHSC SF
ohci_hcd 0000:00:02.0: intrenable 0x8000000a MIE RD WDH
ohci_hcd 0000:00:02.0: hcca frame #0003
ohci_hcd 0000:00:02.0: roothub.a 01000203 POTPGT=3D1 NPS NDP=3D3(3)
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=3D0000 DR=3D0000
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc2-cfs-v13-1avb ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: global over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: no over-current condition exists
hub 1-0:1.0: trying to enable port power on non-switchable hub
Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip, pr=
e-configuring device.
Activated ALi 1533 ISA bridge port 0x02e8.
Activated ALi 1533 ISA bridge port 0x02f8.
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
/home/bor/src/linux-git/drivers/usb/core/inode.c: creating file '001'
Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
pnp: Device 00:0a activated.
smsc_ircc_present(), addr 0x02e8 - no device found!
pnp: Device 00:0a disabled.
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000087
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11 (level, low) -=
> IRQ 11
pccard: PCMCIA card inserted into slot 0
e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr 00:00:39:D7:14:A1
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11 (level, low) -=
> IRQ 11
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcbfff 0xe0000-0xfff=
ff
cs: memory probe 0x60000000-0x60ffffff: clean.
cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia: registering new device pcmcia0.0
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere Systems, http:=
//www.agere.com
*** Modified for kernel 2.6 by Andrey Borzenkov <arvidjaar@mail.ru> $Revisi=
on: 39 $
*** Station Mode (STA) Support: YES
*** Access Point Mode (AP) Support: YES
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
eth1: Wireless, io_addr 0x100, irq 11, mac_address 00:02:2D:26:95:6C
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
Toshiba System Managment Mode driver v1.11 26/9/2001
Non-volatile memory driver v1.2
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ACPI: AC Adapter [ADP1] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
ACPI: Battery Slot [BAT2] (battery absent)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
ACPI: Transitioning device [FAN] to D3
ACPI: Transitioning device [FAN] to D3
ACPI: Fan [FAN] (off)
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Thermal Zone [THRM] (59 C)
toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redha=
t.com
Clocksource tsc unstable (delta =3D -208426762 ns)
loop: module loaded
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1 across:500432k
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
IrCOMM protocol (Dag Brattli)
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
PPP generic driver version 2.4.2
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
NET: Registered protocol family 17
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
Stopping tasks ... done.
Shrinking memory...  =08-=08\=08done (14217 pages freed)
=46reed 56868 kbytes in 0.29 seconds (196.09 MB/s)
Suspending console(s)
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
sd 0:0:0:0: [sda] Synchronizing SCSI cache
pnp: Device 00:09 disabled.
ACPI: PCI interrupt for device 0000:00:0a.0 disabled
Trying to free already-free IRQ 11
ohci_hcd 0000:00:02.0: wakeup root hub
ACPI: PCI interrupt for device 0000:00:06.0 disabled
ACPI: Unable to derive IRQ for device 0000:00:04.0
pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x230 [usbcore]() returns -16
suspend_device(): pci_device_suspend+0x0/0x70() returns -16
Could not suspend device 0000:00:02.0: error -16
PM: Writing back config space on device 0000:00:04.0 at offset 1 (was 29000=
01, writing 2900005)
ACPI: Unable to derive IRQ for device 0000:00:04.0
ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11 (level, low) -=
> IRQ 11
ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors =3D 39070080
ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors =3D 39070080
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
PM: Writing back config space on device 0000:00:0a.0 at offset f (was 38080=
100, writing 3808010b)
PM: Writing back config space on device 0000:00:0a.0 at offset 6 (was 0, wr=
iting f7d00000)
PM: Writing back config space on device 0000:00:0a.0 at offset 5 (was 1, wr=
iting eb41)
PM: Writing back config space on device 0000:00:0a.0 at offset 4 (was 0, wr=
iting f7efd000)
PM: Writing back config space on device 0000:00:0a.0 at offset 3 (was 0, wr=
iting 4008)
PM: Writing back config space on device 0000:00:0a.0 at offset 1 (was 29000=
00, writing 2900007)
ata2.00: configured for UDMA/33
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
pnp: Failed to activate device 00:05.
pnp: Failed to activate device 00:06.
pnp: Device 00:09 activated.
sd 0:0:0:0: [sda] Starting disk
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
done.
swsusp: Basic memory bitmaps freed
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input5
ACPI: Lid Switch [LID]
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
eth1: PRI 31 variant 2 version 9.48
eth1: NIC 5 variant 2 version 1.02
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: hub_suspend
ohci_hcd 0000:00:02.0: suspend root hub
usb usb1: usb auto-suspend
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
ohci_hcd 0000:00:02.0: wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: auto-stop root hub
ohci_hcd 0000:00:02.0: auto-wakeup root hub

--Boundary-01=_VjyTGfO4Gxfsn25--

--nextPart1234224.mW8oUJD0hs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGTyjVR6LMutpd94wRAonsAKCVvFUZPXyx1MIRDOjdng3N8Msz5wCgmhgC
1CVfKeGDZWIFjsqblvwMgPY=
=cvlf
-----END PGP SIGNATURE-----

--nextPart1234224.mW8oUJD0hs--
