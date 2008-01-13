Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbYAMJtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbYAMJtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 04:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYAMJtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 04:49:45 -0500
Received: from rosi.naasa.net ([212.8.0.13]:40917 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYAMJti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 04:49:38 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Sun, 13 Jan 2008 10:49:31 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801130905.44855.jplatte@naasa.net> <400212488.11031@ustc.edu.cn>
In-Reply-To: <400212488.11031@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_t6diHaTv/zF2T12"
Message-Id: <200801131049.33111.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_t6diHaTv/zF2T12
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Am Sonntag, 13. Januar 2008 schrieb Fengguang Wu:
> On Sun, Jan 13, 2008 at 09:05:43AM +0100, Joerg Platte wrote:
> > Am Sonntag, 13. Januar 2008 schrieb Fengguang Wu:
> > > No idea yet :-/ I'm afraid I have to trouble you again - the bug just
> > > refused to appear in my system. I prepared a kernel module for you to
> > > gather more information:
> > >
> > > make && insmod ext2-writeback-debug.ko && sleep 1s && rmmod
> > > ext2-writeback-debug dmesg > ext2-writeback-debug.dmesg
> >
> > Unfortunately, I unable to compile the module:
> >
> > make -C /lib/modules/2.6.24-rc7-ext2/build SUBDIRS=/export/src modules
> > make[1]: Entering directory `/export/src/linux-2.6.24-rc7'
> >   CC [M]  /export/src/ext2-writeback-debug.o
> > /export/src/ext2-writeback-debug.c:89: error: variable ‘my_kprobe’ has
> > initializer but incomplete type
>
> Do you have CONFIG_KPROBES=y?

Now I have :)

Here is the result.

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605


--Boundary-00=_t6diHaTv/zF2T12
Content-Type: text/plain;
  charset="utf-8";
  name="ext2-writeback-debug.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ext2-writeback-debug.dmesg"

Linux version 2.6.24-rc7-ext2 (root@ibm) (gcc version 4.2.3 20080102 (prerelease) (Debian 4.2.2-5)) #1 PREEMPT Sun Jan 13 09:48:55 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005ff50000 (usable)
 BIOS-e820: 000000005ff50000 - 000000005ff67000 (ACPI data)
 BIOS-e820: 000000005ff67000 - 000000005ff79000 (ACPI NVS)
 BIOS-e820: 000000005ff80000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
639MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 393040) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   393040
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   393040
On node 0 totalpages: 393040
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 1278 pages used for memmap
  HighMem zone: 162386 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F6D70, 0024 (r2 IBM   )
ACPI: XSDT 5FF5A672, 004C (r1 IBM    TP-1R        3230  LTP        0)
ACPI: FACP 5FF5A700, 00F4 (r3 IBM    TP-1R        3230 IBM         1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 5FF5A8E7, C530 (r1 IBM    TP-1R        3230 MSFT  100000E)
ACPI: FACS 5FF78000, 0040
ACPI: SSDT 5FF5A8B4, 0033 (r1 IBM    TP-1R        3230 MSFT  100000E)
ACPI: ECDT 5FF66E17, 0052 (r1 IBM    TP-1R        3230 IBM         1)
ACPI: TCPA 5FF66E69, 0032 (r1 IBM    TP-1R        3230 PTL         1)
ACPI: BOOT 5FF66FD8, 0028 (r1 IBM    TP-1R        3230  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 70000000 (gap: 60000000:9f800000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000d2000
swsusp: Registered nosave memory region: 00000000000d2000 - 00000000000d4000
swsusp: Registered nosave memory region: 00000000000d4000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 389970
Kernel command line: root=LABEL=ROOT ro resume=LABEL=SWAP panic=10 usbcore.autosuspend=1 hpet=force 
Unknown boot option `usbcore.autosuspend=1': ignoring
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01c06000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0343000 soft=c0342000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1598.683 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1547564k/1572160k available (1494k kernel code, 23352k reserved, 597k data, 204k init, 654656k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc030c000 - 0xc033f000   ( 204 kB)
      .data : 0xc0275a5f - 0xc030aef0   ( 597 kB)
      .text : 0xc0100000 - 0xc0275a5f   (1494 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3199.89 BogoMIPS (lpj=5331036)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: a7e9f9bf 00000000 00000000 00000000 00000180 00000000 00000000 00000000
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: After all inits, caps: a7e9f9bf 00000000 00000000 00002040 00000180 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) M processor 1600MHz stepping 05
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0800)
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8d6, last bus=8
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
Force enabled HPET at base address 0xfed00000
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnpacpi: exceeded the max number of mem resources: 12
pnpacpi: exceeded the max number of mem resources: 12
pnpacpi: exceeded the max number of mem resources: 12
pnpacpi: exceeded the max number of mem resources: 12
pnpacpi: exceeded the max number of IO resources: 24 
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff could not be reserved
system 00:00: iomem range 0xcc000-0xcffff could not be reserved
system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0xdc000-0xdffff has been reserved
system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
system 00:00: iomem range 0xe8000-0xebfff could not be reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x162f has been reserved
system 00:02: ioport range 0x1632-0x167f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: 3000-3fff
  MEM window: c0100000-c01fffff
  PREFETCH window: e0000000-e7ffffff
PCI: Bus 3, cardbus bridge: 0000:02:00.0
  IO window: 00004000-000040ff
  IO window: 00004400-000044ff
  PREFETCH window: e8000000-ebffffff
  MEM window: c4000000-c7ffffff
PCI: Bus 7, cardbus bridge: 0000:02:00.1
  IO window: 00004800-000048ff
  IO window: 00004c00-00004cff
  PREFETCH window: ec000000-efffffff
  MEM window: c8000000-cbffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 4000-8fff
  MEM window: c0200000-cfffffff
  PREFETCH window: e8000000-efffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:00.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 6682k freed
Simple Boot Flag at 0x35 set to 0x1
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Using IPI Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 204k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=252.00 Mhz, System=200.00 MHz
radeonfb: PLL min 20000 max 35000
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
Non-DDC laptop panel detected
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type LCD found
radeonfb: Monitor 2 type no found
radeonfb: panel ID string: SXGA+ Single (85MHz)    
radeonfb: detected LVDS panel size from BIOS: 1400x1050
radeondb: BIOS provided dividers will be used
radeonfb: Dynamic Clock Power Management enabled
radeonfb: IBM Thinkpad T40p detected, enabling workaround
radeonfb (0000:01:00.0): ATI Radeon Lf 
Console: switching to colour frame buffer device 175x65
Non-volatile memory driver v1.2
thinkpad_acpi: ThinkPad ACPI Extras v0.17
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 1RETDRWW (3.23 ), EC 1RHT71WW-3.04
thinkpad_acpi: IBM ThinkPad T40p
input: ThinkPad Extra Buttons as /class/input/input1
NET: Registered protocol family 1
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU] (supports 8 throttling states)
Marking TSC unstable due to: TSC halts in idle.
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [THM0] (52 C)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
SCSI subsystem initialized
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
libata version 3.00 loaded.
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xc0000000
usb 1-1: new full speed USB device using uhci_hcd and address 2
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
usb 4-1: new high speed USB device using ehci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
hub 4-1:1.0: USB hub found
hub 4-1:1.0: 4 ports detected
e1000: 0000:02:01.0: e1000_validate_option: PHY Smart Power Down Enabled
e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:16:41:10:19:11
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ata_piix 0000:00:1f.1: version 2.12
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
usb 4-1.1: new high speed USB device using ehci_hcd and address 3
usb 4-1.1: configuration #1 chosen from 1 choice
ata1.00: ATA-7: SAMSUNG HM160JC, AP100-16, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
usb 4-1.4: new low speed USB device using ehci_hcd and address 4
usb 4-1.4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-1.4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ata2.00: ATAPI: UJDA745 DVD/CDRW, 1.06, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM160JC  AP10 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            MATSHITA UJDA745 DVD/CDRW 1.06 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<4>Driver 'sr' needs updating - please use bus_type methods
 sda1 sda2 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
Attempting manual resume
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Linux agpgart interface v0.102
agpgart: Detected an Intel 855PM Chipset.
agpgart: AGP aperture is 256M @ 0xd0000000
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
input: Video Bus as /class/input/input6
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
input: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver remote control as /class/input/input7
usbcore: registered new interface driver cinergyT2
input: PC Speaker as /class/input/input8
Yenta: CardBus bridge found at 0000:02:00.0 [1014:0512]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.0, mfunc 0x01d21022, devctl 0x64
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
NET: Registered protocol family 23
Yenta: CardBus bridge found at 0000:02:00.1 [1014:0512]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.1, mfunc 0x01d21022, devctl 0x64
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input9
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
nsc-ircc 00:0c: activated
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
IrDA: Registered device irda0
nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.5 to 64
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0xa00-0xaff: clean.
intel8x0_measure_ac97_clock: measured 53254 usecs
intel8x0: measured clock 206 rejected
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.6 to 64
Adding 1951856k swap on /dev/sda5.  Priority:-1 extents:1 across:1951856k
EXT3 FS on sda6, internal journal
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
IrCOMM protocol (Dag Brattli)
io scheduler anticipatory registered
io scheduler deadline registered
Ebtables v2.0 registered
Bridge firewalling registered
fuse init (API version 7.9)
EXT2-fs warning (device sda7): ext2_fill_super: mounting ext3 filesystem as ext2
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NTFS driver 2.1.29 [Flags: R/O MODULE].
NTFS volume version 3.1.
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input10
NET: Registered protocol family 15
padlock: VIA PadLock Hash Engine not detected.
padlock: VIA PadLock Hash Engine not detected.
padlock: VIA PadLock not detected.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
Clocksource tsc unstable (delta = -197922093 ns)
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
NET: Registered protocol family 17
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
vmmon: disagrees about version of symbol struct_module
vmnet: disagrees about version of symbol struct_module
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.28.0 20060524 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 2 usecs
register_jprobe(ext2_writepage) = 0
register_jprobe(requeue_io) = 0
register_kprobe(submit_bio) = 0
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	2	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	2	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	2	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	2	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	3	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	3	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	3	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	3	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	4	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	4	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	4	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	4	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	5	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	5	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	5	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	5	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	6	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	6	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	6	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	6	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	7	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	7	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	7	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	7	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	8	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	8	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	8	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	8	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	9	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	9	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	9	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	9	0	U____
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	10	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	10	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	10	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	10	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	11	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	11	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	11	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	11	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	12	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	12	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	12	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	12	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	13	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	13	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	13	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	13	0	U____
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c014007b>] devm_free_irq+0x4f/0x61
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c014007b>] devm_free_irq+0x4f/0x61
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c014007b>] devm_free_irq+0x4f/0x61
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c014007b>] devm_free_irq+0x4f/0x61
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e28d7>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f99e2d59>] journal_commit_transaction+0x467/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	14	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	14	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	14	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	14	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	15	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	15	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	15	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	15	0	U____
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<f99e1140>] __journal_file_buffer+0x8d/0x10d [jbd]
 [<c0272baf>] int3+0x27/0x2c
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e3083>] journal_commit_transaction+0x791/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
Pid: 2244, comm: kjournald Not tainted 2.6.24-rc7-ext2 #1
 [<fa00716b>] handler_pre+0x18/0x1b [ext2_writeback_debug]
 [<c02737f2>] kprobe_exceptions_notify+0x151/0x368
 [<c0274276>] notifier_call_chain+0x2a/0x52
 [<c02742c1>] __atomic_notifier_call_chain+0x23/0x41
 [<c02742f6>] atomic_notifier_call_chain+0x17/0x1a
 [<c012e29a>] notify_die+0x30/0x34
 [<c0272ca9>] do_int3+0x2f/0x6e
 [<c0272baf>] int3+0x27/0x2c
 [<c01acf12>] submit_bio+0x1/0xfb
 [<c017d77c>] submit_bh+0xb9/0xd4
 [<f99e3083>] journal_commit_transaction+0x791/0xcca [jbd]
 [<c01152a4>] update_curr+0x52/0xc8
 [<c011534d>] set_next_entity+0x11/0x38
 [<c02714a1>] schedule+0x2f9/0x33f
 [<f99e5cf0>] kjournald+0xbc/0x223 [jbd]
 [<c012a91b>] autoremove_wake_function+0x0/0x33
 [<f99e5c34>] kjournald+0x0/0x223 [jbd]
 [<c012a861>] kthread+0x36/0x5d
 [<c012a82b>] kthread+0x0/0x5d
 [<c010493b>] kernel_thread_helper+0x7/0x10
 =======================
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	16	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	16	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	16	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	16	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	17	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	17	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	17	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	17	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	18	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	18	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	18	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	18	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	19	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	19	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	19	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	19	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	20	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	20	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	20	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	20	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	21	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	21	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	21	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	21	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	22	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	22	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	22	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	22	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	23	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	23	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	23	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	23	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	24	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	24	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	24	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	24	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	25	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	25	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	25	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	25	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	26	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	26	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	26	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	26	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	27	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	27	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	27	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	27	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	28	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	28	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	28	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	28	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	29	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	29	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	29	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	29	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	30	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	30	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	30	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	30	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	31	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	31	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	31	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	31	0	U____
register_jprobe(ext2_writepage) = 0
register_jprobe(requeue_io) = 0
register_kprobe(submit_bio) = 0
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	32	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	32	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	32	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	32	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	33	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	33	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	33	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	33	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	34	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	34	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	34	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	34	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	35	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	35	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	35	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	35	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	36	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	36	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	36	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	36	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	37	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	37	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	37	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	37	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	38	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	38	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	38	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	38	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	39	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	39	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	39	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	39	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	40	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	40	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	40	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	40	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	41	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	41	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	41	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	41	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	42	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	42	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	42	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	42	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	43	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	43	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	43	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	43	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	44	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	44	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	44	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	44	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	45	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	45	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	45	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	45	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	46	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	46	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	46	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	46	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	47	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	47	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	47	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	47	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	48	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	48	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	48	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	48	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	49	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	49	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	49	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	49	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	50	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	50	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	50	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	50	0	U____
requeue_io:
inode 114019(sda7/.kde) count 2,2 size 0 pages 1
0	51	0	U____
requeue_io:
inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
0	51	0	U____
requeue_io:
inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
0	51	0	U____
requeue_io:
inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
0	51	0	U____

--Boundary-00=_t6diHaTv/zF2T12--
