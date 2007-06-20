Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbXFTJVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbXFTJVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbXFTJVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:21:01 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41009 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbXFTJU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:20:58 -0400
Date: Wed, 20 Jun 2007 12:20:54 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: NMI received for unknown reason 30
Message-ID: <Pine.SOC.4.64.0706201127230.3776@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just received this on IBM Thinkpad R32 (Pentium 4M 1.6, I845). Unknown 
reason 20 was also seen. 2.6.22-rc5 gives the NMI-s and I have not seen 
them before. However, it does not happen every time. I tested Debian 
2.6.21-1 and selfcompiled 2.6.22-rc2 and neither gave NMI messages - but 
since it's not 100% reproducible I'm not sure whether these kernels are 
fully OK or not.

Performance CPU governor is in use, acpi-cpufreq driver.

Uhhuh. NMI received for unknown reason 30 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue


           CPU0       
  0:    3651238    XT-PIC-XT        timer
  1:        202    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  4:      71518    XT-PIC-XT        eth0
  5:          0    XT-PIC-XT        uhci_hcd:usb2
  6:          5    XT-PIC-XT        floppy
  7:          2    XT-PIC-XT        parport0
  8:          1    XT-PIC-XT        rtc
  9:         15    XT-PIC-XT        acpi, uhci_hcd:usb3
 10:       3518    XT-PIC-XT        yenta, Intel 82801CA-ICH3, Intel 82801CA-ICH3 Modem
 11:    4251035    XT-PIC-XT        uhci_hcd:usb1, radeon@pci:0000:01:00.0
 12:        165    XT-PIC-XT        i8042
 14:      50341    XT-PIC-XT        libata
 15:          0    XT-PIC-XT        libata
NMI:          1 
LOC:     280967 
ERR:          0
MIS:          0

Linux version 2.6.22-rc5 (mroos@okaapi) (gcc version 4.1.3 20070601 (prerelease) (Debian 4.1.2-12)) #1 SMP PREEMPT Tue Jun 19 14:01:49 EEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ff70000 (usable)
 BIOS-e820: 000000001ff70000 - 000000001ff7e000 (ACPI data)
 BIOS-e820: 000000001ff7e000 - 000000001ff80000 (ACPI NVS)
 BIOS-e820: 000000001ff80000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Entering add_active_range(0, 0, 130928) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   130928
  HighMem    130928 ->   130928
early_node_map[1] active PFN ranges
    0:        0 ->   130928
On node 0 totalpages: 130928
  DMA zone: 44 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4052 pages, LIFO batch:0
  Normal zone: 1362 pages used for memmap
  Normal zone: 125470 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F7120, 0024 (r2 IBM   )
ACPI: XSDT 1FF7745F, 004C (r1 IBM    TP-1M        2160  LTP        0)
ACPI: FACP 1FF774AB, 0081 (r1 IBM    TP-1M        2160 IBM         1)
ACPI: DSDT 1FF77592, 69C2 (r1 IBM    TP-1M        2160 MSFT  100000D)
ACPI: FACS 1FF7F000, 0040
ACPI: SSDT 1FF7755F, 0033 (r1 IBM    TP-1M        2160 MSFT  100000D)
ACPI: ECDT 1FF7DF54, 0052 (r1 IBM    TP-1M        2160 IBM         1)
ACPI: TCPA 1FF7DFA6, 0032 (r1 IBM    TP-1M        2160 PTL         1)
ACPI: BOOT 1FF7DFD8, 0028 (r1 IBM    TP-1M        2160  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 30000000 (gap: 20000000:df800000)
Built 1 zonelists.  Total pages: 129522
Kernel command line: root=/dev/sda1 ro resume=/dev/sda5 lapic reboot=bios 
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c039b000 soft=c0393000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1599.939 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 508640k/523712k available (1712k kernel code, 14456k reserved, 650k data, 236k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdff70000   ( 511 MB)
      .init : 0xc0353000 - 0xc038e000   ( 236 kB)
      .data : 0xc02ac042 - 0xc034ea04   ( 650 kB)
      .text : 0xc0100000 - 0xc02ac042   (1712 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3203.45 BogoMIPS (lpj=6406912)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00000400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Hyper-Threading is disabled
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00000400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 10k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0e30)
CPU0: Intel Mobile Intel(R) Pentium(R) 4 - M CPU 1.60GHz stepping 07
SMP motherboard not detected.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd91e, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 7 9 10 11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 3000-3fff
  MEM window: d0100000-d01fffff
  PREFETCH window: e8000000-efffffff
PCI: Bus 3, cardbus bridge: 0000:02:09.0
  IO window: 00004000-000040ff
  IO window: 00004400-000044ff
  PREFETCH window: f0000000-f3ffffff
  MEM window: d4000000-d7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 4000-8fff
  MEM window: d0200000-dfffffff
  PREFETCH window: f0000000-f7ffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 6, 458752 bytes)
TCP bind hash table entries: 16384 (order: 6, 393216 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 5392k freed
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
audit(1182257085.668:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
pnp: Unable to assign resources to device 00:0a.
serial: probe of 00:0a failed with error -16
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
Using IPI No-Shortcut mode
Freeing unused kernel memory: 236k freed
Write protecting the kernel text: 1716k
Write protecting the kernel read-only data: 454k
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU] (supports 8 throttling states)
ACPI: Invalid passive threshold
ACPI: Thermal Zone [THM0] (59 C)
ACPI: Thermal Zone [THM1] (50 C)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 5, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 9, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ata_piix 0000:00:1f.1: version 2.11
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011860 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011868 irq 15
Floppy drive(s): fd0 is 1.44M
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: ATA-5: IBM-DJSA-220, JS4IAC1A, max UDMA/66
ata1.00: 39070080 sectors, multi 16: LBA 
FDC 0 is a National Semiconductor PC87306
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: configured for UDMA/66
ata2: port disabled. ignoring.
scsi 0:0:0:0: Direct-Access     ATA      IBM-DJSA-220     JS4I PQ: 0 ANSI: 5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 4
PCI: setting IRQ 4 as level-triggered
ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [LNKE] -> GSI 4 (level, low) -> IRQ 4
e100: eth0: e100_probe: addr 0xd0200000, irq 4, MAC addr 00:00:E2:86:B2:11
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
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input1
input: PC Speaker as /class/input/input2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 845G Chipset.
agpgart: AGP aperture is 64M @ 0xe0000000
intel_rng: FWH not detected
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH3-M TCO device (Version=1, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Real Time Clock Driver v1.12ac
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Yenta: CardBus bridge found at 0000:02:09.0 [1014:0521]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:09.0, mfunc 0x01011c02, devctl 0x64
Yenta: ISA IRQ mask 0x0088, PCI irq 10
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xd0200000 - 0xdfffffff
pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf7ffffff
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.5 to 64
irda_init()
NET: Registered protocol family 23
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
nsc_ircc_pnp_probe() : From PnP, found firbase 0x2E8 ; irq 3 ; dma 3.
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
IrDA: Registered device irda0
nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
intel8x0_measure_ac97_clock: measured 54931 usecs
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.6 to 64
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
Adding 369484k swap on /dev/disk/by-label/okaapi-swap.  Priority:-1 extents:1 across:369484k
EXT3 FS on sda1, internal journal
Clocksource tsc unstable (delta = -476451239 ns)
ide0: I/O resource 0x3F6-0x3F6 not free.
ide0: ports already in use, skipping probe
ide1: I/O resource 0x376-0x376 not free.
ide1: ports already in use, skipping probe
thinkpad_acpi: ThinkPad ACPI Extras v0.14
thinkpad_acpi: http://ibm-acpi.sf.net/
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
pcmcia: Detected deprecated PCMCIA ioctl usage from process: discover.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Battery Slot [BAT1] (battery absent)
ACPI: AC Adapter [AC] (on-line)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
IBM machine detected. Enabling interrupts during APM calls.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
eth0: no IPv6 routers present
Non-volatile memory driver v1.2
input: /usr/sbin/thinkpad-keys as /class/input/input6
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
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[drm] Initialized radeon 1.27.0 20060524 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 2x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 2x mode
[drm] Setting GART location based on new memory map
[drm] writeback test succeeded in 2 usecs
Uhhuh. NMI received for unknown reason 30 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue


-- 
Meelis Roos (mroos@linux.ee)
