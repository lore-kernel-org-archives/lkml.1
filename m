Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbXJYOMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbXJYOMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbXJYOL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:11:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:57071 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759946AbXJYOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hzrWJuT2ZwHNdH7MxvsGg1MqU+oAKacenHTGbVdKcl317YzTb4Vt2AJBlUL/K1ZMYWz386esBxr76/kwN8jE4SUY/UEgOmlbO0jkUvRbVUt01jZzawKPUgFY3V786Ogp7+lnIiaAM2XBDTijcMHhHjJzjSnkATt2c7Iwj8kALCU=
Message-ID: <2ed59cbb0710250711p52bd8ae7k54b45fe11ed2c0d8@mail.gmail.com>
Date: Thu, 25 Oct 2007 10:11:46 -0400
From: "Zurk Tech" <zurktech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
In-Reply-To: <47200EB1.1080500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2ed59cbb0710242002r7ff3ab89k2b22582fc1de9d2c@mail.gmail.com>
	 <47200EB1.1080500@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry forgot putty cuts it off - full log.


=~=~=~=~=~=~=~=~=~=~=~= PuTTY log 2007.10.25 10:08:10 =~=~=~=~=~=~=~=~=~=~=~=
dmesg
Linux version 2.6.23.1 (root@unix) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #3 SMP Fri Oct 26 02:03:04 EDT 2007
Command line: root=/dev/md1 ro
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000c7ff0000 (usable)
 BIOS-e820: 00000000c7ff0000 - 00000000c7ffe000 (ACPI data)
 BIOS-e820: 00000000c7ffe000 - 00000000c8000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 819184) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2326528) 2 entries of 3200 used
end_pfn_map = 2326528
DMI 2.3 present.
ACPI: RSDP 000F9200, 0024 (r2 ACPIAM)
ACPI: XSDT C7FF0100, 004C (r1 A M I  OEMXSDT   8000729 MSFT       97)
ACPI: FACP C7FF0290, 00F4 (r3 A M I  OEMFACP   8000729 MSFT       97)
ACPI: DSDT C7FF0470, 3B36 (r1  0AAAA 0AAAA000        0 INTL  2002026)
ACPI: FACS C7FFE000, 0040
ACPI: OEMB C7FFE040, 0056 (r1 A M I  AMI_OEM   8000729 MSFT       97)
ACPI: SRAT C7FF3FB0, 00E8 (r1 AMD    HAMMER          1 AMD         1)
ACPI: HPET C7FF40A0, 0038 (r1 A M I  OEMHPET   8000729 MSFT       97)
ACPI: SSDT C7FF40E0, 0A30 (r1 A M I  POWERNOW        1 AMD         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-c8000000
Entering add_active_range(0, 0, 159) 1 entries of 3200 used
Entering add_active_range(0, 256, 819184) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-238000000
Entering add_active_range(0, 0, 159) 2 entries of 3200 used
Entering add_active_range(0, 256, 819184) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 2326528) 2 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000238000000
No mptable found.
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2326528
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   819184
    0:  1048576 ->  2326528
On node 0 totalpages: 2097039
  DMA zone: 56 pages used for memmap
  DMA zone: 14 pages reserved
  DMA zone: 3929 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 800808 pages, LIFO batch:31
  Normal zone: 17472 pages used for memmap
  Normal zone: 1260480 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x508
ACPI: HPET id: 0x0 base: 0xfed00000
Allocating PCI resources starting at cc000000 (gap: c8000000:36c00000)
SMP: Allowing 0 CPUs, 0 hotplug CPUs
PERCPU: Allocating 23592 bytes of per cpu data
Built 1 zonelists in Zone order.  Total pages: 2065217
Policy zone: Normal
Kernel command line: root=/dev/md1 ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 1895.330 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 4000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 8177452k/9306112k available (10324k kernel code, 210704k
reserved, 5411k data, 596k init)
Calibrating delay using timer specific routine.. 3793.58 BogoMIPS (lpj=7587171)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
Freeing SMP alternatives: 77k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0ea0)
weird, boot CPU (#0) not listed by the BIOS.
SMP motherboard not detected.
Using local APIC timer interrupts.
result 12469277
Detected 12.469 MHz APIC timer.
SMP disabled
Brought up 1 CPUs
xor: automatically using best checksumming function: generic_sse
   generic_sse:  7419.000 MB/sec
xor: using function: generic_sse (7419.000 MB/sec)
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR28._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR32._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR3C._PRT]
ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 *9 11 12 14 15)
ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 *11 12 14 15)
ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 *7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 *5 6 7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  CA,
should be BF [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0A03
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0700
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
Generic PHY: Registered new driver
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
Time: tsc clocksource has been installed.
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: match found with the PnP device '00:09' and the driver 'system'
pnp: 00:09: ioport range 0x580-0x58f has been reserved
pnp: 00:09: ioport range 0x590-0x593 has been reserved
pnp: 00:09: ioport range 0x700-0x703 has been reserved
pnp: 00:09: ioport range 0xca0-0xcaf has been reserved
pnp: 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:09: iomem range 0xfec01000-0xfec01fff could not be reserved
pnp: 00:09: iomem range 0xfec02000-0xfec02fff could not be reserved
pnp: 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: match found with the PnP device '00:0a' and the driver 'system'
pnp: 00:0a: ioport range 0x600-0x61f has been reserved
pnp: 00:0a: ioport range 0x520-0x53f has been reserved
pnp: 00:0a: ioport range 0x540-0x54f has been reserved
pnp: 00:0a: ioport range 0x640-0x65f has been reserved
pnp: match found with the PnP device '00:0b' and the driver 'system'
pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
pnp: match found with the PnP device '00:0c' and the driver 'system'
pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0c: iomem range 0x0-0x0 could not be reserved
pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0c: iomem range 0x100000-0xc7ffffff could not be reserved
PCI: Bridge: 0000:01:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:01.0
  IO window: a000-bfff
  MEM window: ff400000-ff4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: ff500000-ff5fffff
  PREFETCH window: cfe00000-cfefffff
PCI: Bridge: 0000:00:08.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
microcode: CPU0 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
audit: initializing netlink socket (disabled)
audit(1193378689.052:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.28 [Flags: R/W].
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
QNX4 filesystem 0.2.3 registered.
fuse init (API version 7.8)
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with ACLs, security attributes, realtime, large block/inode
numbers, no debug enabled
SGI XFS Quota Management subsystem
BeFS version: 0.9.3
OCFS2 1.3.3
OCFS2 Node Manager 1.3.3
OCFS2 DLM 1.3.3
OCFS2 DLMFS 1.3.3
OCFS2 User DLM kernel interface loaded
async_tx: api initialized (async)
io scheduler noop registered
io scheduler cfq registered (default)
PCI: Firmware left 0000:00:04.0 e100 interrupts enabled, disabling
PCI: Found enabled HT MSI Mapping on 0000:00:08.0
PCI: Found enabled HT MSI Mapping on 0000:00:09.0
PCI: Found enabled HT MSI Mapping on 0000:00:0a.0
PCI: Found enabled HT MSI Mapping on 0000:00:0b.0
Boot video device is 0000:00:0c.0
PCI: MSI quirk detected. MSI deactivated.
ACPI: PCI Interrupt Link [LN01] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LN01] -> GSI 11 (level,
low) -> IRQ 11
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=60) Memory=200.00 Mhz, System=200.00 MHz
radeonfb: PLL min 12000 max 35000
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type CRT found
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 80x30
radeonfb (0000:00:0c.0): ATI Radeon Q^
tridentfb: Trident framebuffer 0.7.8-NEWAPI initializing
hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
vga16fb: initializing
vga16fb: mapped to 0xffff8100000a0000
fb1: VGA16 VGA frame buffer device
fb2: Virtual frame buffer device, using 1024K of video memory
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input1
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device
is not present [20070126]
RocketPort device driver module, version 2.09, 12-June-2003
No rocketport ports found; unloading driver.
Cyclades driver 2.5 (built Oct 25 2007 04:27:48)
DIGI epca driver version 1.3.0.1-LK2.6 loaded.
sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
sx: derived from work (c) D.Gorodchanin 1994-1996.
sx: DTR/RTS pin is RTS when CRTSCTS is on.
sx0: specialix IO8+ Board at 0x100 not found.
sx1: specialix IO8+ Board at 0x180 not found.
sx2: specialix IO8+ Board at 0x250 not found.
sx3: specialix IO8+ Board at 0x260 not found.
sx: No specialix IO8+ boards detected.
MOXA Intellio family driver version 5.1k
Tty devices major number = 172
MOXA Smartio/Industio family driver version 1.8
Computone IntelliPort Plus multiport driver version 1.2.14
SyncLink serial driver $Revision: 4.38 $
SyncLink serial driver $Revision: 4.38 $, tty major#253
SyncLink MultiPort driver $Revision: 4.38 $
SyncLink MultiPort driver $Revision: 4.38 $, tty major#252
SyncLink GT $Revision: 4.50 $
SyncLink GT $Revision: 4.50 $, tty major#251
SyncLink GT no devices found
HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
N_HDLC line discipline registered.
r3964: Philips r3964 Driver $Revision: 1.10 $
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
platform pc8736x_gpio.0: no device found
nsc_gpio initializing
telclk_interrup = 0xf non-mcpbl0010 hw.
smapi::smapi_init, ERROR invalid usSmapiID
mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not
available on this machine
mwave: mwavedd::mwave_init: Error: Failed to initialize board data
mwave: mwavedd::mwave_init: Error: Failed to initialize
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.28.0 20060524 on minor 0
ipmi message handler version 39.1
ipmi device interface
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address
0xca8, slave address 0x20, irq 0
ipmi_si: Interface detection failed
ipmi_si: Unable to find any System Interface(s)
IPMI Watchdog: driver initialized
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin
is 60 seconds).
Hangcheck: Using get_cycles().
intelfb: Framebuffer driver for Intel(R)
830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
intelfb: Version 0.9.4
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:05' and the driver 'serial'
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: match found with the PnP device '00:06' and the driver 'serial'
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
loop: module loaded
nbd: registered device at major 43
usbcore: registered new interface driver ub
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Intel(R) PRO/10GbE Network Driver - version 1.0.126-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target
module parameters must be specified, otherwise bonding will not detect
link failures! see bonding.txt for details.
pcnet32.c:v1.33 27.Jun.2006 tsbogend@alpha.franken.de
eepro100.c:v1.09j-t 9/29/99 Donald Becker
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V.
Savochkin <saw@saw.sw.com.sg> and others
ACPI: PCI Interrupt Link [LN00] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LN00] -> GSI 9 (level,
low) -> IRQ 9
eth0: 0000:00:04.0, 00:E0:81:47:C6:C9, IRQ 9.
  Board assembly 567812-052, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0xd0a6c714).
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
tg3.c:v3.81 (September 5, 2007)
ACPI: PCI Interrupt Link [LN10] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
ACPI: PCI Interrupt 0000:04:04.0[A] -> Link [LN10] -> GSI 7 (level,
low) -> IRQ 7
eth1: Tigon3 [partno(BCM95780) rev 8003 PHY(5780)]
(PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:47:c7:22
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76144000] dma_mask[40-bit]
ACPI: PCI Interrupt Link [LN11] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:04:04.1[B] -> Link [LN11] -> GSI 5 (level,
low) -> IRQ 5
eth2: Tigon3 [partno(BCM95780) rev 8003 PHY(5780)]
(PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:47:c7:23
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth2: dma_rwctrl[76144000] dma_mask[40-bit]
Marvell 88E1101: Registered new driver
Marvell 88E1112: Registered new driver
Marvell 88E1111: Registered new driver
Marvell 88E1145: Registered new driver
Davicom DM9161E: Registered new driver
Davicom DM9161A: Registered new driver
Davicom DM9131: Registered new driver
Cicada Cis8204: Registered new driver
Cicada Cis8201: Registered new driver
LXT970: Registered new driver
LXT971: Registered new driver
QS6612: Registered new driver
SMSC LAN83C185: Registered new driver
Vitesse VSC8244: Registered new driver
Fixed PHY: Registered new driver
pnp: the driver 'sb1000' has been registered
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller
(davem@redhat.com)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
myri10ge: Version 1.3.2-1.269
ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson
<johns393@maroon.tc.umn.edu>
HDLC support module revision 1.21
Cronyx Ltd, Synchronous PPP and CISCO HDLC (c) 1994
Linux port (c) 1998 Building Number Three Ltd & Jan "Yenya" Kasprzak.
X.25 async: version 0.00 ALPHA (dynamic channels, max=256).
DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
Cyclom 2X Support Module v0.6 (c) 1998-2003 Arnaldo Carvalho de Melo
<acme@conectiva.com.br>
CYCLOM 2X(tm) Sync Card Driver v0.11 (c) 1998-2003 Arnaldo Carvalho de
Melo <acme@conectiva.com.br>
LAPB Ethernet driver version 0.02
arcnet loaded.
arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
arcnet: raw mode (`r') encapsulation support loaded.
arcnet: COM90xx chipset support
S3: No ARCnet cards found.
arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
E-mail me if you actually test this driver, please!
 arc%d: No autoprobe for IO mapped cards; you must specify the base address!
arcnet: RIM I (entirely mem-mapped) support
E-mail me if you actually test the RIM I driver, please!
 arc%d: Given: node 00h, shmem 0h, irq 0
 arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
arcnet: COM20020 PCI support
usbcore: registered new interface driver catc
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
usbcore: registered new interface driver kaweth
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
drivers/net/usb/rtl8150.c: rtl8150 based usb-ethernet driver v0.6.2 (2004/08/27)
usbcore: registered new interface driver rtl8150
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver gl620a
usbcore: registered new interface driver net1080
usbcore: registered new interface driver plusb
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
netconsole: not configured, aborting
Madge ATM Ambassador driver version 1.2.4
Madge ATM Horizon [Ultra] driver version 1.2.1
fore200e: FORE Systems 200E-series ATM driver - version 0.3e
idt77252_init: at ffffffff811c0a88
adummy: version 1.0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks HT1000: IDE controller at PCI slot 0000:00:02.1
SvrWks HT1000: chipset revision 0
SvrWks HT1000: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:pio, hdb:DMA
Probing IDE interface ide0...
hdb: DV-28E-R, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdb: ATAPI 24X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
Adaptec aacraid driver 1.1-5[2449]-ms
scsi: <fdomain> Detection failed (no card)
QLogic Fibre Channel HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.2
Copyright(c) 2004-2007 Emulex.  All rights reserved.
DC390: clustering now enabled by default. If you get problems load
with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
RocketRAID 3xxx SATA Controller driver v1.0 (060426)
st: Version 20070203, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
SCSI Media Changer driver v0.25
scsi0 : scsi_debug, version 1.81 [20070104], dev_size_mb=8, opts=0x0
scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
sata_svw 0000:01:0e.0: version 2.3
ACPI: PCI Interrupt Link [LNSA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:01:0e.0[A] -> Link [LNSA] -> GSI 11 (level,
low) -> IRQ 11
sd 0:0:0:0: [sda] 16384 512-byte hardware sectors (8 MB)
scsi1 : sata_svw
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
scsi2 : sata_svw
scsi3 : sata_svw
scsi4 : sata_svw
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
ata1: SATA max UDMA/133 cmd 0xffffc20002d38000 ctl 0xffffc20002d38020
bmdma 0xffffc20002d38030 irq 11
ata2: SATA max UDMA/133 cmd 0xffffc20002d38100 ctl 0xffffc20002d38120
bmdma 0xffffc20002d38130 irq 11
ata3: SATA max UDMA/133 cmd 0xffffc20002d38200 ctl 0xffffc20002d38220
bmdma 0xffffc20002d38230 irq 11
ata4: SATA max UDMA/133 cmd 0xffffc20002d38300 ctl 0xffffc20002d38320
bmdma 0xffffc20002d38330 irq 11
sd 0:0:0:0: [sda] 16384 512-byte hardware sectors (8 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
 sda: unknown partition table
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01, max UDMA/133
ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01, max UDMA/133
ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 4 SControl 300)
ata4: SATA link down (SStatus 4 SControl 300)
scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: sdc1 sdc2 sdc3
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.05
Fusion MPT FC Host driver 3.04.05
Fusion MPT SAS Host driver 3.04.05
Fusion MPT misc device (ioctl) driver 3.04.05
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
Fusion MPT LAN driver 3.04.05
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
NOTE: The dv1394 driver is unsupported and may be removed in a future
Linux release. Use raw1394 instead.
aoe: AoE v32 initialised.
ACPI: PCI Interrupt Link [LNUS] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:03.2[A] -> Link [LNUS] -> GSI 10 (level,
low) -> IRQ 10
ehci_hcd 0000:00:03.2: EHCI Host Controller
ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6eb000
ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNUS] -> GSI 10 (level,
low) -> IRQ 10
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6e9000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNUS] -> GSI 10 (level,
low) -> IRQ 10
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6ea000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
sl811: driver sl811-hcd, 19 May 2005
usbcore: registered new interface driver cdc_acm
drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver
for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver mdc800
drivers/usb/image/mdc800.c: v0.7.5 (30/10/2000):USB Driver for Mustek
MDC800 Digital Camera
usbcore: registered new interface driver microtekX6
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for airprime
usbcore: registered new interface driver airprime
drivers/usb/serial/usb-serial.c: USB Serial support registered for ark3116
usbcore: registered new interface driver ark3116
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Belkin / Peracom / GoHubs USB Serial Adapter
usbcore: registered new interface driver belkin
drivers/usb/serial/belkin_sa.c: USB Belkin Serial converter driver v1.2
drivers/usb/serial/usb-serial.c: USB Serial support registered for cp2101
usbcore: registered new interface driver cp2101
drivers/usb/serial/cp2101.c: Silicon Labs CP2101/CP2102 RS232 serial
adaptor driver v0.07
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Reiner SCT Cyberjack USB card reader
usbcore: registered new interface driver cyberjack
drivers/usb/serial/cyberjack.c: v1.01 Matthias Bruestle
drivers/usb/serial/cyberjack.c: REINER SCT cyberJack pinpad/e-com USB
Chipcard Reader Driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for
DeLorme Earthmate USB
drivers/usb/serial/usb-serial.c: USB Serial support registered for
HID->COM RS232 Adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Nokia CA-42 V2 Adapter
usbcore: registered new interface driver cypress
drivers/usb/serial/cypress_m8.c: Cypress USB to Serial Driver v1.09
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Digi 2 port USB adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Digi 4 port USB adapter
usbcore: registered new interface driver digi_acceleport
drivers/usb/serial/digi_acceleport.c: v1.80.1.2:Digi AccelePort
USB-2/USB-4 Serial Converter driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Edgeport 2 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Edgeport 4 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Edgeport 8 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for EPiC device
usbcore: registered new interface driver io_edgeport
drivers/usb/serial/io_edgeport.c: Edgeport USB Serial Driver v2.7
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Edgeport TI 1 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Edgeport TI 2 port adapter
usbcore: registered new interface driver io_ti
drivers/usb/serial/io_ti.c: Edgeport USB Serial Driver v0.7mode043006
drivers/usb/serial/usb-serial.c: USB Serial support registered for empeg
usbcore: registered new interface driver empeg
drivers/usb/serial/empeg.c: v1.2:USB Empeg Mark I/II Driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for
FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for funsoft
usbcore: registered new interface driver funsoft
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Garmin GPS usb/tty
usbcore: registered new interface driver garmin_gps
drivers/usb/serial/garmin_gps.c: garmin gps driver v0.31
drivers/usb/serial/usb-serial.c: USB Serial support registered for hp4X
usbcore: registered new interface driver hp4X
drivers/usb/serial/hp4x.c: HP4x (48/49) Generic Serial driver v1.00
drivers/usb/serial/usb-serial.c: USB Serial support registered for PocketPC PDA
drivers/usb/serial/ipaq.c: USB PocketPC PDA driver v0.5
usbcore: registered new interface driver ipaq
drivers/usb/serial/usb-serial.c: USB Serial support registered for
IPWireless converter
usbcore: registered new interface driver ipwtty
drivers/usb/serial/ipw.c: IPWireless tty driver v0.3
drivers/usb/serial/usb-serial.c: USB Serial support registered for IR Dongle
usbcore: registered new interface driver ir-usb
drivers/usb/serial/ir-usb.c: USB IR Dongle driver v0.4
drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Keyspan PDA - (prerenumeration)
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Xircom / Entregra PGS - (prerenumeration)
usbcore: registered new interface driver keyspan_pda
drivers/usb/serial/keyspan_pda.c: USB Keyspan PDA Converter driver v1.1
drivers/usb/serial/usb-serial.c: USB Serial support registered for
KL5KUSB105D / PalmConnect
usbcore: registered new interface driver kl5kusb105d
drivers/usb/serial/kl5kusb105.c: KLSI KL5KUSB105 chipset USB->Serial
Converter driver v0.3a
drivers/usb/serial/usb-serial.c: USB Serial support registered for
KOBIL USB smart card terminal
usbcore: registered new interface driver kobil
drivers/usb/serial/kobil_sct.c: 21/05/2004 KOBIL Systems GmbH -
http://www.kobil.com
drivers/usb/serial/kobil_sct.c: KOBIL USB Smart Card Terminal Driver
(experimental)
drivers/usb/serial/usb-serial.c: USB Serial support registered for MCT U232
usbcore: registered new interface driver mct_u232
drivers/usb/serial/mct_u232.c: Magic Control Technology USB-RS232
converter driver z2.1
drivers/usb/serial/usb-serial.c: USB Serial support registered for navman
usbcore: registered new interface driver navman
drivers/usb/serial/usb-serial.c: USB Serial support registered for
ZyXEL - omni.net lcd plus usb
usbcore: registered new interface driver omninet
drivers/usb/serial/omninet.c: v1.1:USB ZyXEL omni.net LCD PLUS Driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for GSM
modem (1-port)
usbcore: registered new interface driver option
drivers/usb/serial/option.c: USB Driver for GSM modems: v0.7.1
drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
drivers/usb/serial/safe_serial.c: v0.0b sl@lineo.com, tbr@lineo.com
drivers/usb/serial/safe_serial.c: USB Safe Encapsulated Serial
drivers/usb/serial/safe_serial.c: vendor: 0 product: 0 safe: 1 padded: 0

drivers/usb/serial/usb-serial.c: USB Serial support registered for safe_serial
usbcore: registered new interface driver safe_serial
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Sierra USB modem (1 port)
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Sierra USB modem (3 port)
usbcore: registered new interface driver sierra
drivers/usb/serial/sierra.c: USB Driver for Sierra Wireless USB modems: v.1.2.5b
drivers/usb/serial/usb-serial.c: USB Serial support registered for TI
USB 3410 1 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for TI
USB 5052 2 port adapter
usbcore: registered new interface driver ti_usb_3410_5052
drivers/usb/serial/ti_usb_3410_5052.c: TI USB 3410/5052 Serial Driver v0.9
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Handspring Visor / Palm OS
drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 3.5
drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 5.0
usbcore: registered new interface driver visor
drivers/usb/serial/visor.c: USB HandSpring Visor / Palm OS driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Connect Tech - WhiteHEAT - (prerenumeration)
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Connect Tech - WhiteHEAT
usbcore: registered new interface driver whiteheat
drivers/usb/serial/whiteheat.c: USB ConnectTech WhiteHEAT driver v2.0
usbcore: registered new interface driver appledisplay
usbcore: registered new interface driver auerswald
usbcore: registered new interface driver cypress_cy7c63
usbcore: registered new interface driver cytherm
drivers/usb/misc/cytherm.c: v1.0:Cypress USB Thermometer driver
drivers/usb/misc/idmouse.c: Siemens ID Mouse FingerTIP Sensor Driver 0.6
usbcore: registered new interface driver idmouse
usbcore: registered new interface driver usblcd
usbcore: registered new interface driver ldusb
usbcore: registered new interface driver usbled
usbcore: registered new interface driver legousbtower
drivers/usb/misc/legousbtower.c: LEGO USB Tower Driver v0.96
usbcore: registered new interface driver rio500
drivers/usb/misc/rio500.c: v1.1:USB Rio 500 driver
usbcore: registered new interface driver usbtest
usbcore: registered new interface driver sisusb
sisusb: Driver version 0.0.8
sisusb: Copyright (C) 2005 Thomas Winischhofer
usbcore: registered new interface driver cxacru
usbcore: registered new interface driver speedtch
[ueagle-atm] driver ueagle 1.4 loaded
usbcore: registered new interface driver ueagle-atm
drivers/usb/atm/xusbatm.c: malformed module parameters
pnp: the driver 'i8042 kbd' has been registered
pnp: the driver 'i8042 aux' has been registered
pnp: the driver 'i8042 kbd' has been unregistered
pnp: the driver 'i8042 aux' has been unregistered
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
pnp: the driver 'ns558' has been registered
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver iforce
mk712: device not present
input: PC Speaker as /class/input/input3
max6902 spi driver
i2c /dev entries driver
i2c-parport-light: adapter type unspecified
piix4_smbus 0000:00:02.0: Found 0000:00:02.0 device
i2c-adapter i2c-4: Unsupported chip (man_id=0x5C, chip_id=0x68).
i2c-adapter i2c-4: detect fail: address match, 0x2e
hwmon-vid: Unknown VRM version of your x86 CPU
 : Not supporting VRM 0.0
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
i2c-adapter i2c-4: lm85: Detected SMSC chip
i2c-adapter i2c-4: lm85: Unrecognized version/stepping 0x68 Defaulting
to Generic LM85.
hwmon-vid: Unknown VRM version of your x86 CPU
pc87360: PC8736x not detected, module not inserted.
usbcore: registered new interface driver pcwd_usb
pcwd_usb: Berkshire USB-PC Watchdog driver v1.02 (21 Jan 2007)
WDT driver for Acquire single board computer initialising.
acquirewdt: I/O address 0x0043 already in use
acquirewdt: probe of acquirewdt failed with error -5
WDT driver for Advantech single board computer initialising.
advantechwdt: initialized. timeout=60 sec (nowayout=0)
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: ALi M7101 PMU not present - WDT not set
sc520_wdt: cannot register miscdev on minor=130 (err=-16)
eurwdt: IRQ 10 is not free.
ib700wdt: WDT driver for IB700 single board computer initialising.
ib700wdt: START method I/O 443 is not available.
ib700wdt: probe of ib700wdt failed with error -5
WDT driver for Wafer 5823 single board computer initialising.
Wafer 5823 WDT: I/O address 0x0443 already in use
sc1200wdt: build 20020303
pnp: the driver 'scl200wdt' has been registered
sc1200wdt: io parameter must be specified
pnp: the driver 'scl200wdt' has been unregistered
sbc60xxwdt: I/O address 0x0443 already in use
sbc8360: failed to register misc device
cpu5wdt: misc_register failed
WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
w83627hf/thf/hg WDT: cannot register miscdev on minor=130 (err=-16)
w83877f_wdt: I/O address 0x0443 already in use
W83977F WDT: W83977F WDT driver, v1.00
W83977F WDT: cannot register miscdev on minor=130 (err=-16)
machzwd: MachZ ZF-Logic Watchdog driver initializing.
machzwd: no ZF-Logic found
epx_c3: cannot register miscdev on minor=130 (err=-16)
SoftDog: cannot register miscdev on minor=130 (err=-16)
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int64x1   1815 MB/s
raid6: int64x2   2190 MB/s
raid6: int64x4   2329 MB/s
raid6: int64x8   1340 MB/s
raid6: sse2x1    2596 MB/s
raid6: sse2x2    4337 MB/s
raid6: sse2x4    5404 MB/s
raid6: using algorithm sse2x4 (5404 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: faulty personality registered for level -5
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: multipath emc: version 0.0.3 loaded
oprofile: using NMI interrupt.
NET: Registered protocol family 26
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.2
u32 classifier
    Performance counters on
    input device check on
    Actions configured
Netfilter messages via NETLINK v0.30.
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
IPVS: Registered protocols (TCP, UDP, AH, ESP)
IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
IPVS: ipvs loaded.
IPVS: [rr] scheduler registered.
IPVS: [wrr] scheduler registered.
IPVS: [lc] scheduler registered.
IPVS: [wlc] scheduler registered.
IPVS: [lblc] scheduler registered.
IPVS: [lblcr] scheduler registered.
IPVS: [dh] scheduler registered.
IPVS: [sh] scheduler registered.
IPVS: [sed] scheduler registered.
IPVS: [nq] scheduler registered.
IPVS: ftp: loaded support on port[0] = 21
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP veno registered
TCP scalable registered
TCP lp registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
NET: Registered protocol family 15
Bridge firewalling registered
Ebtables v2.0 registered
NET: Registered protocol family 4
NET: Registered protocol family 5
NET: Registered protocol family 9
X.25 for Linux. Version 0.2 for Linux 2.1.15
lec.c: Oct 25 2007 04:38:30 initialized
mpc.c: Oct 25 2007 04:38:27 initialized
NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
DECnet: Routing cache hash table of 1024 buckets, 16Kbytes
NET: Registered protocol family 12
NET: Registered protocol family 19
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
CCID: Registered CCID 3 (ccid3)
CCID: Registered CCID 2 (ccid2)
SCTP: Hash tables configured (established 65536 bind 65536)
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
TIPC: Activated (version 1.6.2 compiled Oct 25 2007 04:41:37)
NET: Registered protocol family 30
TIPC: Started in single node mode
IO APIC resources could be not be allocated.
powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 2347
processors (1 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0x3 did 0x0 (1900 MHz)
powernow-k8:    1 : fid 0x1 did 0x0 (1700 MHz)
powernow-k8:    2 : fid 0xc did 0x1 (1400 MHz)
powernow-k8:    3 : fid 0x8 did 0x1 (1200 MHz)
powernow-k8:    4 : fid 0x4 did 0x1 (1000 MHz)
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md: sdc1 has different UUID to sdc2
md:  adding sdb2 ...
md: sdb1 has different UUID to sdc2
md: created md1
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdc1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1>
md: bind<sdc1>
md: running: <sdc1><sdb1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 596k freed
Adding 19342252k swap on /dev/sdb3.  Priority:-1 extents:1 across:19342252k
eth0: freeing mc frame.
eth0: freeing mc frame.
eth0: freeing mc frame.
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_UP): eth2: link is not ready
eth0: freeing mc frame.
eth0: freeing mc frame.
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth0: no IPv6 routers present
eth2: no IPv6 routers present
eth1: no IPv6 routers present
