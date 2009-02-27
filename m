Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZB0Rol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZB0Rol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZB0Ro2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:44:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:32453 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbZB0RoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:44:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QER/cIfqFPs5VAkw0LUW1aWNqHGcEDVmzC6JzSdZ9WXP3J0XKC85PwBq0q9W2S6PHo
         JeFqO2/jk6kcWm0tQlnUpcFrrrc62/a1jzqozeeBzUa/rNNJi+CKD1laQM5+oYF7cCKQ
         cupqYYr2qkCB8US4qkbWS/s6hKsxypsRWevwQ=
MIME-Version: 1.0
Date: Fri, 27 Feb 2009 09:44:21 -0800
Message-ID: <3aa654a40902270944h3edeadf4pc9fb7587b76d7e9e@mail.gmail.com>
Subject: DRDY ata message > 2.6.24.7-rt14, not before.
From: Avuton Olrich <avuton@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've had a problem since 2.6.24.7-rt14 that has kept me from updating.
I'm not sure when it started, that's to say this could have begun in
2.6.26 and I wouldn't know for sure, as I don't upgrade often on this
computer. As far as I know, I can't bisect this problem as it refuses
to allow me to unmount my large filesystem and I would like to prevent
any problems as far as that goes. I'd like to make as few boots into
this kernel as possible, and I need to know what is necessary to debug
this problem or is this just a symptom of hardware going bad?
If it's a symptom of hardware going bad, I guess this wasn't checked
for in the 2.6.24.7-rt14 kernel? BTW- 2.6.24.7-rt14 kernel has been up
50 days at a time, with no instability, only coming down for upgrade
attempts or moves.

Thanks! Help! ;)

http://avuton.googlepages.com/linux-2.6.24.7-rt14.config
http://avuton.googlepages.com/linux-2.6.29-rc6-rt3.config

before dmesg:
Linux version 2.6.24.7-rt14 (root@shapeshifter) (gcc version 4.3.3
(Gentoo 4.3.3 p1.0, pie-10.1.5) ) #18 SMP PREEMPT RT Fri Feb 27
09:20:44 PST 2009
Command line: root=/dev/sdf3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000beff0000 (usable)
 BIOS-e820: 00000000beff0000 - 00000000beff3000 (ACPI NVS)
 BIOS-e820: 00000000beff3000 - 00000000bf000000 (ACPI data)
 BIOS-e820: 00000000bf000000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f2000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 782320) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F6BC0, 0014 (r0 GBT   )
ACPI: RSDT BEFF3000, 0030 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP BEFF3040, 0074 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT BEFF30C0, 4D2C (r1 GBT    AWRDACPI     1000 MSFT  100000C)
ACPI: FACS BEFF0000, 0040
ACPI: MCFG BEFF7E80, 003C (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: APIC BEFF7E00, 0072 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 782320) 1 entries of 256 used
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   782320
On node 0 totalpages: 782223
  DMA zone: 56 pages used for memmap
  DMA zone: 1866 pages reserved
  DMA zone: 2077 pages, LIFO batch:0
  DMA32 zone: 10639 pages used for memmap
  DMA32 zone: 767585 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 31768 bytes of per cpu data
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 769662
Kernel command line: root=/dev/sdf3
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2210.053 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
CPU 0: aperture @ a20000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 3071152k/3129280k available (4694k kernel code, 57108k
reserved, 1897k data, 248k init)
Calibrating delay using timer specific routine.. 4424.99 BogoMIPS (lpj=7371185)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12557140
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4421.33 BogoMIPS (lpj=7366943)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
net_namespace: 144 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using MMCONFIG at f0000000 - ffffffff
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1080-0x10ff has been reserved
system 00:01: ioport range 0x1400-0x147f has been reserved
system 00:01: ioport range 0x1480-0x14ff has been reserved
system 00:01: ioport range 0x1800-0x187f has been reserved
system 00:01: ioport range 0x1880-0x18ff has been reserved
system 00:01: ioport range 0x2000-0x207f has been reserved
system 00:01: ioport range 0x2080-0x20ff has been reserved
system 00:01: iomem range 0xfefe0000-0xfefe01ff has been reserved
system 00:01: iomem range 0xbf000000-0xbfffffff could not be reserved
system 00:01: iomem range 0xf0000000-0xf1ffffff could not be reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x290-0x29f has been reserved
system 00:08: iomem range 0xd3000-0xd3fff has been reserved
system 00:08: iomem range 0xf0000-0xf7fff could not be reserved
system 00:08: iomem range 0xf8000-0xfbfff could not be reserved
system 00:08: iomem range 0xfc000-0xfffff could not be reserved
system 00:08: iomem range 0xbeff0000-0xbeffffff could not be reserved
system 00:08: iomem range 0xffff0000-0xffffffff has been reserved
system 00:08: iomem range 0x0-0x9ffff could not be reserved
system 00:08: iomem range 0x100000-0xbefeffff could not be reserved
system 00:08: iomem range 0xbf000000-0xbfffffff could not be reserved
system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:03.0
  IO window: 9000-afff
  MEM window: f7000000-f8ffffff
  PREFETCH window: c4000000-c40fffff
PCI: Bridge: 0000:00:10.0
  IO window: 8000-8fff
  MEM window: f3000000-f4ffffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
krcupreemptd setsched 0
  prio = 98
RCU Preempt markers registered
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.9)
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:00:05.0
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie03]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
loop: module loaded
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [APCH] -> GSI 23 (level,
low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x3f1 @ 7, addr 00:14:85:35:ce:4d
forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC1] -> GSI 16 (level,
low) -> IRQ 16
eth1: RTL8110s at 0xffffc20000014000, 00:40:f4:a6:5c:ea, XID 04000000 IRQ 16
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:02:00.0: version 3.0
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC5] -> GSI 16 (level,
low) -> IRQ 16
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part
PCI: Setting latency timer of device 0000:02:00.0 to 64
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 abar m8192@0xf8000000 port 0xf8000100 irq 16
ata2: SATA max UDMA/133 abar m8192@0xf8000000 port 0xf8000180 irq 16
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01, max UDMA/133
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: unknown partition table
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
sata_nv 0000:00:0e.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [APSI] -> GSI 22 (level,
low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd400 irq 22
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd408 irq 22
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: Maxtor 3H500F0, HA431BV0, max UDMA/133
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: Maxtor 3H500F0, HA431BV0, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 3H500F0   HA43 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: unknown partition table
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 3H500F0   HA43 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: unknown partition table
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APSJ] -> GSI 21 (level,
low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0f.0 to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc000 irq 21
ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc008 irq 21
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDMA/133
ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/133
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-7: Maxtor 6H500F0, HA431DD0, max UDMA/133
ata6.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 4:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdd: unknown partition table
sd 4:0:0:0: [sdd] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg3 type 0
scsi 5:0:0:0: Direct-Access     ATA      Maxtor 6H500F0   HA43 PQ: 0 ANSI: 5
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sde: unknown partition table
sd 5:0:0:0: [sde] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg4 type 0
pata_amd 0000:00:0d.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:0d.0 to 64
scsi6 : pata_amd
scsi7 : pata_amd
ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata7.00: ATA-7: Maxtor 2F040L0, VAM51JJ0, max UDMA/133
ata7.00: 80293248 sectors, multi 16: LBA
ata7.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      Maxtor 2F040L0   VAM5 PQ: 0 ANSI: 5
sd 6:0:0:0: [sdf] 80293248 512-byte hardware sectors (41110 MB)
sd 6:0:0:0: [sdf] Write Protect is off
sd 6:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 6:0:0:0: [sdf] 80293248 512-byte hardware sectors (41110 MB)
sd 6:0:0:0: [sdf] Write Protect is off
sd 6:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdf: sdf1 sdf2 sdf3
sd 6:0:0:0: [sdf] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg5 type 0
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
ACPI: PCI Interrupt 0000:02:00.1[B] -> Link [APC6] -> GSI 16 (level,
low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.1 to 64
scsi8 : pata_jmicron
scsi9 : pata_jmicron
ata9: PATA max UDMA/100 cmd 0x9000 ctl 0x9400 bmdma 0xa000 irq 16
ata10: PATA max UDMA/100 cmd 0x9800 ctl 0x9c00 bmdma 0xa008 irq 16
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [APCL] -> GSI 20 (level,
low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 20, io mem 0xf9008000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [APCF] -> GSI 23 (level,
low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 23, io mem 0xf9007000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
Initializing USB Mass Storage driver...
usb 2-4: new low speed USB device using ohci_hcd and address 2
usb 2-4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect
please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
gameport: EMU10K1 is pci0000:01:07.1/gameport0, io 0x8800, speed 1087kHz
input: AT Translated Set 2 keyboard as /class/input/input2
rtc-test rtc-test.0: rtc core: registered test as rtc0
rtc-test rtc-test.1: rtc core: registered test as rtc1
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c80
i2c-parport: adapter type unspecified
i2c-parport-light: adapter type unspecified
i2c-adapter i2c-1: detect fail: address match, 0x2e
pc87360: PC8736x not detected, module not inserted.
w83627ehf: Found W83627EHG chip at 0x290
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
input: Wireless INC TW Wireless  USB  Device as /class/input/input3
input: USB HID v1.10 Keyboard [Wireless INC TW Wireless  USB  Device]
on usb-0000:00:0b.0-4
input: Wireless INC TW Wireless  USB  Device as /class/input/input4
input: USB HID v1.10 Mouse [Wireless INC TW Wireless  USB  Device] on
usb-0000:00:0b.0-4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20
19:16:42 2007 UTC).
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC2] -> GSI 17 (level,
low) -> IRQ 17
ALSA sound/pci/emu10k1/emufx.c:1545: Installing spdif_bug patch:
Audigy 2 ZS [SB0350]
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: Audigy 2 ZS [SB0350] (rev.4, serial:0x20021102) at 0x8400, irq 17
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
rtc-test rtc-test.0: setting system clock to 2009-02-27 17:33:18 UTC
(1235755998)
UDF-fs: No VRS found
XFS mounting filesystem sdf3
Starting XFS recovery on filesystem: sdf3 (logdev: internal)
Ending XFS recovery on filesystem: sdf3 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 248k freed
udev: renamed network interface eth0 to eth3
udev: renamed network interface eth1 to eth2
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0
Starting XFS recovery on filesystem: dm-0 (logdev: internal)
Ending XFS recovery on filesystem: dm-0 (logdev: internal)
ip6_tables: (C) 2000-2006 Netfilter Core Team
r8169: eth2: link up
Clocksource tsc unstable (delta = -101766520 ns)
Adding 498004k swap on /dev/sdf2.  Priority:-1 extents:1 across:498004k
.. snip firewall stuff ..

after dmesg:
Linux version 2.6.29-rc6-rt3 (root@shapeshifter) (gcc version 4.3.3
(Gentoo 4.3.3 p1.0, pie-10.1.5) ) #2 SMP PREEMPT RT Tue Feb 24
10:18:10 PST 2009
Command line: root=/dev/sdf3
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000beff0000 (usable)
 BIOS-e820: 00000000beff0000 - 00000000beff3000 (ACPI NVS)
 BIOS-e820: 00000000beff3000 - 00000000bf000000 (ACPI data)
 BIOS-e820: 00000000bf000000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f2000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.3 present.
last_pfn = 0xbeff0 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000beff0000
 0000000000 - 00bee00000 page 2M
 00bee00000 - 00beff0000 page 4k
kernel direct mapping tables up to beff0000 @ 8000-d000
last_map_addr: beff0000 end: beff0000
ACPI: RSDP 000F6BC0, 0014 (r0 GBT   )
ACPI: RSDT BEFF3000, 0030 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP BEFF3040, 0074 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT BEFF30C0, 4D2C (r1 GBT    AWRDACPI     1000 MSFT  100000C)
ACPI: FACS BEFF0000, 0040
ACPI: MCFG BEFF7E80, 003C (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: APIC BEFF7E00, 0072 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: Local APIC address 0xfee00000
(5 early reservations) ==> bootmem [0000000000 - 00beff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00009d5d90]    TEXT DATA BSS ==> [0000200000 - 00009d5d90]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
found SMP MP-table at [ffff8800000f5210] f5210
 [ffffe20000000000-ffffe200029fffff] PMD ->
[ffff880001200000-ffff880003bfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000beff0
On node 0 totalpages: 782223
  DMA zone: 56 pages used for memmap
  DMA zone: 2109 pages reserved
  DMA zone: 1834 pages, LIFO batch:0
  DMA32 zone: 10640 pages used for memmap
  DMA32 zone: 767584 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 73728 bytes of per cpu data
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 769418
Kernel command line: root=/dev/sdf3
Initializing CPU#0
Preemptible RCU implementation.
NR_IRQS:320
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2209.886 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 1620000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 3070716k/3129280k available (4912k kernel code, 388k absent,
57716k reserved, 2040k data, 388k init)
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4421.92 BogoMIPS (lpj=7366286)
Security Framework initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20081204
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4421.01 BogoMIPS (lpj=7366419)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Brought up 2 CPUs
Total of 2 processors activated (8843.94 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
net_namespace: 1880 bytes
NET: Registered protocol family 16
node 0 link 0: io port [3000, fffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [f0000000, f1ffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, ffb7ffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [c0000000, fcffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in E820
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 31
PCI: Using MMCONFIG at f0000000 - f1ffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Warning (dsobject-0502): Package List length (6) larger than
NumElements count (2), truncated
 [20081204]
ACPI Warning (dsobject-0502): Package List length (6) larger than
NumElements count (2), truncated
 [20081204]
ACPI: Denied BIOS AML access to invalid port 0x4d0+0x2 (ELCR)
ACPI Exception (dsopcode-0419): AE_AML_ILLEGAL_ADDRESS, During address
validation of OpRegion [ELCR] [20081204]
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:03.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:05.0: reg 10 32bit mmio: [0xf2000000-0xf2ffffff]
pci 0000:00:05.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
pci 0000:00:05.0: reg 1c 64bit mmio: [0xf5000000-0xf5ffffff]
pci 0000:00:05.0: reg 30 32bit mmio: [0x000000-0x01ffff]
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:0a.1: reg 20 io port: [0x1c00-0x1c3f]
pci 0000:00:0a.1: reg 24 io port: [0x1c80-0x1cbf]
pci 0000:00:0a.1: PME# supported from D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0b.0: reg 10 32bit mmio: [0xf9007000-0xf9007fff]
pci 0000:00:0b.0: supports D1 D2
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0b.1: reg 10 32bit mmio: [0xf9008000-0xf90080ff]
pci 0000:00:0b.1: supports D1 D2
pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.1: PME# disabled
pci 0000:00:0d.0: reg 20 io port: [0xf000-0xf00f]
pci 0000:00:0e.0: reg 10 io port: [0x9f0-0x9f7]
pci 0000:00:0e.0: reg 14 io port: [0xbf0-0xbf3]
pci 0000:00:0e.0: reg 18 io port: [0x970-0x977]
pci 0000:00:0e.0: reg 1c io port: [0xb70-0xb73]
pci 0000:00:0e.0: reg 20 io port: [0xd400-0xd40f]
pci 0000:00:0e.0: reg 24 32bit mmio: [0xf9006000-0xf9006fff]
pci 0000:00:0f.0: reg 10 io port: [0x9e0-0x9e7]
pci 0000:00:0f.0: reg 14 io port: [0xbe0-0xbe3]
pci 0000:00:0f.0: reg 18 io port: [0x960-0x967]
pci 0000:00:0f.0: reg 1c io port: [0xb60-0xb63]
pci 0000:00:0f.0: reg 20 io port: [0xc000-0xc00f]
pci 0000:00:0f.0: reg 24 32bit mmio: [0xf9005000-0xf9005fff]
pci 0000:00:10.1: reg 10 32bit mmio: [0xf9000000-0xf9003fff]
pci 0000:00:10.1: PME# supported from D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:14.0: reg 10 32bit mmio: [0xf9004000-0xf9004fff]
pci 0000:00:14.0: reg 14 io port: [0xe000-0xe007]
pci 0000:00:14.0: supports D1 D2
pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:14.0: PME# disabled
pci 0000:02:00.0: reg 24 32bit mmio: [0xf8000000-0xf8001fff]
pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:02:00.0: PME# supported from D3hot
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.1: reg 10 io port: [0x9000-0x9007]
pci 0000:02:00.1: reg 14 io port: [0x9400-0x9403]
pci 0000:02:00.1: reg 18 io port: [0x9800-0x9807]
pci 0000:02:00.1: reg 1c io port: [0x9c00-0x9c03]
pci 0000:02:00.1: reg 20 io port: [0xa000-0xa00f]
pci 0000:00:03.0: bridge io port: [0x9000-0xafff]
pci 0000:00:03.0: bridge 32bit mmio: [0xf7000000-0xf8ffffff]
pci 0000:01:06.0: reg 10 io port: [0x8000-0x80ff]
pci 0000:01:06.0: reg 14 32bit mmio: [0xf4005000-0xf40050ff]
pci 0000:01:06.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:06.0: supports D1 D2
pci 0000:01:06.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:01:06.0: PME# disabled
pci 0000:01:07.0: reg 10 io port: [0x8400-0x843f]
pci 0000:01:07.0: supports D1 D2
pci 0000:01:07.1: reg 10 io port: [0x8800-0x8807]
pci 0000:01:07.1: supports D1 D2
pci 0000:01:07.2: reg 10 32bit mmio: [0xf4004000-0xf40047ff]
pci 0000:01:07.2: reg 14 32bit mmio: [0xf4000000-0xf4003fff]
pci 0000:01:07.2: supports D1 D2
pci 0000:01:07.2: PME# supported from D0 D1 D2 D3hot
pci 0000:01:07.2: PME# disabled
pci 0000:00:10.0: transparent bridge
pci 0000:00:10.0: bridge io port: [0x8000-0x8fff]
pci 0000:00:10.0: bridge 32bit mmio: [0xf3000000-0xf4ffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1080-0x10ff has been reserved
system 00:01: ioport range 0x1400-0x147f has been reserved
system 00:01: ioport range 0x1480-0x14ff has been reserved
system 00:01: ioport range 0x1800-0x187f has been reserved
system 00:01: ioport range 0x1880-0x18ff has been reserved
system 00:01: ioport range 0x2000-0x207f has been reserved
system 00:01: ioport range 0x2080-0x20ff has been reserved
system 00:01: iomem range 0xfefe0000-0xfefe01ff has been reserved
system 00:01: iomem range 0xbf000000-0xbfffffff has been reserved
system 00:01: iomem range 0xf0000000-0xf1ffffff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x290-0x29f has been reserved
system 00:08: iomem range 0xd3000-0xd3fff has been reserved
system 00:08: iomem range 0xf0000-0xf7fff could not be reserved
system 00:08: iomem range 0xf8000-0xfbfff could not be reserved
system 00:08: iomem range 0xfc000-0xfffff could not be reserved
system 00:08: iomem range 0xbeff0000-0xbeffffff could not be reserved
system 00:08: iomem range 0xffff0000-0xffffffff has been reserved
system 00:08: iomem range 0x0-0x9ffff could not be reserved
system 00:08: iomem range 0x100000-0xbefeffff could not be reserved
system 00:08: iomem range 0xbf000000-0xbfffffff has been reserved
system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:08: iomem range 0xfee00000-0xfee00fff has been reserved
pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
pci 0000:00:03.0:   IO window: 0x9000-0xafff
pci 0000:00:03.0:   MEM window: 0xf7000000-0xf8ffffff
pci 0000:00:03.0:   PREFETCH window: 0x000000c4000000-0x000000c40fffff
pci 0000:00:10.0: PCI bridge, secondary bus 0000:01
pci 0000:00:10.0:   IO window: 0x8000-0x8fff
pci 0000:00:10.0:   MEM window: 0xf3000000-0xf4ffffff
pci 0000:00:10.0:   PREFETCH window: 0x000000c4100000-0x000000c41fffff
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:10.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:02: resource 0 io:  [0x9000-0xafff]
pci_bus 0000:02: resource 1 mem: [0xf7000000-0xf8ffffff]
pci_bus 0000:02: resource 2 mem: [0xc4000000-0xc40fffff]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:01: resource 0 io:  [0x8000-0x8fff]
pci_bus 0000:01: resource 1 mem: [0xf3000000-0xf4ffffff]
pci_bus 0000:01: resource 2 mem: [0xc4100000-0xc41fffff]
pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.11)
SGI XFS with security attributes, large block/inode numbers, no debug enabled
msgmni has been set to 5998
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
pci 0000:00:05.0: Boot video device
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0f.0: Enabling HT MSI Mapping
pci 0000:00:10.0: Enabling HT MSI Mapping
pci 0000:00:10.1: Enabling HT MSI Mapping
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: irq 24 for MSI/MSI-X
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
lp: driver loaded but no devices found
Linux agpgart interface v0.103
loop: module loaded
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.62.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
forcedeth 0000:00:14.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:14.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x3f1 @ 7, addr 00:14:85:35:ce:4d
forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
r8169 0000:01:06.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
r8169 0000:01:06.0: no PCI Express capability
eth1: RTL8110s at 0xffffc2000001e000, 00:40:f4:a6:5c:ea, XID 04000000 IRQ 16
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:02:00.0: version 3.0
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
ahci 0000:02:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part
ahci 0000:02:00.0: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 abar m8192@0xf8000000 port 0xf8000100 irq 16
ata2: SATA max UDMA/133 abar m8192@0xf8000000 port 0xf8000180 irq 16
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01, max UDMA/133
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: unknown partition table
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
sata_nv 0000:00:0e.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
sata_nv 0000:00:0e.0: PCI INT A -> Link[APSI] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:0e.0: Using SWNCQ mode
sata_nv 0000:00:0e.0: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd400 irq 22
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd408 irq 22
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: Maxtor 3H500F0, HA431BV0, max UDMA/133
ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 3H500F0   HA43 PQ: 0 ANSI: 5
ata3.00: Disabling SWNCQ mode (depth 1)
sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: unknown partition table
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: Maxtor 3H500F0, HA431BV0, max UDMA/133
ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 3H500F0   HA43 PQ: 0 ANSI: 5
ata4.00: Disabling SWNCQ mode (depth 1)
sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: unknown partition table
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
sata_nv 0000:00:0f.0: PCI INT A -> Link[APSJ] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0f.0: Using SWNCQ mode
sata_nv 0000:00:0f.0: setting latency timer to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc000 irq 21
ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc008 irq 21
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDMA/133
ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sdd] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 4:0:0:0: [sdd] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdd: unknown partition table
sd 4:0:0:0: [sdd] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg3 type 0
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-7: Maxtor 6H500F0, HA431DD0, max UDMA/133
ata6.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata6.00: configured for UDMA/133
scsi 5:0:0:0: Direct-Access     ATA      Maxtor 6H500F0   HA43 PQ: 0 ANSI: 5
ata6.00: Disabling SWNCQ mode (depth 1)
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sde: unknown partition table
sd 5:0:0:0: [sde] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg4 type 0
pata_amd 0000:00:0d.0: version 0.3.11
pata_amd 0000:00:0d.0: setting latency timer to 64
scsi6 : pata_amd
scsi7 : pata_amd
ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata7.00: ATA-7: Maxtor 2F040L0, VAM51JJ0, max UDMA/133
ata7.00: 80293248 sectors, multi 16: LBA
ata7: nv_mode_filter: 0x7f39f&0x7f01f->0x7f01f, BIOS=0x7f000
(0xc7000000) ACPI=0x7f01f (15:600:0x13)
ata7.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      Maxtor 2F040L0   VAM5 PQ: 0 ANSI: 5
sd 6:0:0:0: [sdf] 80293248 512-byte hardware sectors: (41.1 GB/38.2 GiB)
sd 6:0:0:0: [sdf] Write Protect is off
sd 6:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 6:0:0:0: [sdf] 80293248 512-byte hardware sectors: (41.1 GB/38.2 GiB)
sd 6:0:0:0: [sdf] Write Protect is off
sd 6:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdf: sdf1 sdf2 sdf3
sd 6:0:0:0: [sdf] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg5 type 0
pata_jmicron 0000:02:00.1: enabling device (0000 -> 0001)
ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
pata_jmicron 0000:02:00.1: PCI INT B -> Link[APC6] -> GSI 16 (level,
low) -> IRQ 16
pata_jmicron 0000:02:00.1: setting latency timer to 64
scsi8 : pata_jmicron
scsi9 : pata_jmicron
ata9: PATA max UDMA/100 cmd 0x9000 ctl 0x9400 bmdma 0xa000 irq 16
ata10: PATA max UDMA/100 cmd 0x9800 ctl 0x9c00 bmdma 0xa008 irq 16
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ehci_hcd 0000:00:0b.1: PCI INT B -> Link[APCL] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:0b.1: setting latency timer to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
ehci_hcd 0000:00:0b.1: cache line size of 64 is not supported
ehci_hcd 0000:00:0b.1: irq 20, io mem 0xf9008000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29-rc6-rt3 ehci_hcd
usb usb1: SerialNumber: 0000:00:0b.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ohci_hcd 0000:00:0b.0: PCI INT A -> Link[APCF] -> GSI 23 (level, low) -> IRQ 23
ohci_hcd 0000:00:0b.0: setting latency timer to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 23, io mem 0xf9007000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29-rc6-rt3 ohci_hcd
usb usb2: SerialNumber: 0000:00:0b.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect
please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
gameport: EMU10K1 is pci0000:01:07.1/gameport0, io 0x8800, speed 1088kHz
mice: PS/2 mouse device common for all mice
rtc-test rtc-test.0: rtc core: registered test as rtc0
rtc-test rtc-test.1: rtc core: registered test as rtc1
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c80
i2c-parport: adapter type unspecified
i2c-parport-light: adapter type unspecified
input: AT Translated Set 2 keyboard as /class/input/input2
usb 2-4: new low speed USB device using ohci_hcd and address 2
usb 2-4: New USB device found, idVendor=0a91, idProduct=3801
usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-4: Product: Wireless  USB  Device
usb 2-4: Manufacturer: Wireless INC TW
usb 2-4: configuration #1 chosen from 1 choice
i2c-adapter i2c-1: detect fail: address match, 0x2e
pc87360: PC8736x not detected, module not inserted.
w83627ehf: Found W83627EHG chip at 0x290
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
input: Wireless INC TW Wireless  USB  Device as /class/input/input3
generic-usb 0003:0A91:3801.0001: input: USB HID v1.10 Keyboard
[Wireless INC TW Wireless  USB  Device] on usb-0000:00:0b.0-4/input0
input: Wireless INC TW Wireless  USB  Device as /class/input/input4
generic-usb 0003:0A91:3801.0002: input: USB HID v1.10 Mouse [Wireless
INC TW Wireless  USB  Device] on usb-0000:00:0b.0-4/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.18a.
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
EMU10K1_Audigy 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level,
low) -> IRQ 17
ALSA sound/pci/emu10k1/emufx.c:1546: Installing spdif_bug patch: SB
Audigy 2 ZS [SB0350]
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: SB Audigy 2 ZS [SB0350] (rev.4, serial:0x20021102) at 0x8400, irq 17
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP bic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
rtc-test rtc-test.0: setting system clock to 2009-02-27 17:13:18 UTC
(1235754798)
UDF-fs: No VRS found
XFS mounting filesystem sdf3
Ending clean XFS mount for filesystem: sdf3
VFS: Mounted root (xfs filesystem) readonly on device 8:83.
Freeing unused kernel memory: 388k freed
udev: renamed network interface eth0 to eth3
udev: renamed network interface eth1 to eth2
Filesystem "dm-0": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
ip6_tables: (C) 2000-2006 Netfilter Core Team
r8169: eth2: link up
Clocksource tsc unstable (delta = -271719379 ns)
eth3: no link during initialization.
ADDRCONF(NETDEV_UP): eth3: link is not ready
eth3: link up.
ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
eth2: no IPv6 routers present

.. snip more firewall stuff ..

Adding 498004k swap on /dev/sdf2.  Priority:-1 extents:1 across:498004k
eth3: no IPv6 routers present

.. snip firewall stuff ..

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata4.00: cmd 35/00:10:b0:70:75/00:00:1f:00:00/e0 tag 0 dma 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete

.. snip more firewall stuff..

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata4.00: cmd 35/00:10:b0:70:75/00:00:1f:00:00/e0 tag 0 dma 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete
Connection attempt (UNPRIV): IN=eth3 OUT=
MAC=00:14:85:35:ce:4d:00:0f:35:bf:d8:01:08:00 SRC=218.174.129.152
DST=98.224.98.19 LEN=126 TOS=0x00 PREC=0x20 TTL=108 ID=59452 PROTO=UDP
SPT=30164 DPT=6881 LEN=106
INFO: task rtorrent:3649 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rtorrent      T (004) [ffff8800b41e9060] ffffffff8028305b     0  3649   3647
 ffff8800bebba850 0000000000000086 ffff8800be1b9528 ffff8800be1b0a00
 000000000000ea40 ffff8800be1b0a00 ffff8800be1c6800 000000000000ea40
 ffff8800b41e9060 ffff8800b41e92f8 00000001be1c6a58 00000000ffffa9ad
Call Trace:
 [<ffffffff80285bc0>] ? sync_page+0x0/0x70
 [<ffffffff80285bc0>] ? sync_page+0x0/0x70
 [<ffffffff806c7a5a>] ? schedule+0xa/0x30
 [<ffffffff806c7ab4>] ? io_schedule+0x34/0x50
 [<ffffffff80285bf5>] ? sync_page+0x35/0x70
 [<ffffffff806c7d3a>] ? __wait_on_bit_lock+0x4a/0xa0
 [<ffffffff80285b9e>] ? __lock_page+0x5e/0x70
 [<ffffffff80257fd0>] ? wake_bit_function+0x0/0x30
 [<ffffffff80285d30>] ? find_lock_page+0x60/0x80
 [<ffffffff802864fa>] ? filemap_fault+0x33a/0x4c0
 [<ffffffff8029a395>] ? __do_fault+0x65/0x440
 [<ffffffff805d34ba>] ? __qdisc_run+0xda/0x2d0
 [<ffffffff8029c7c6>] ? handle_mm_fault+0x1f6/0x770
 [<ffffffff8022ac5c>] ? do_page_fault+0x10c/0x320
 [<ffffffff8022ac5c>] ? do_page_fault+0x10c/0x320
 [<ffffffff806c9acf>] ? page_fault+0x1f/0x30
 [<ffffffff806a19fc>] ? csum_partial_copy_from_user+0xac/0x100
 [<ffffffff8060ac12>] ? tcp_sendmsg+0x1e2/0xb40
 [<ffffffff805b2d6b>] ? sock_sendmsg+0xcb/0x100
 [<ffffffff80282e45>] ? perf_counter_task_sched_in+0x65/0x1b0
 [<ffffffff80257fa0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8024b884>] ? lock_timer_base+0x34/0x70
 [<ffffffff8024c378>] ? del_timer_sync+0x18/0x30
 [<ffffffff805b2322>] ? sockfd_lookup_light+0x22/0x90
 [<ffffffff805b3229>] ? sys_sendto+0x119/0x180
 [<ffffffff802b320e>] ? fget+0x7e/0xa0
 [<ffffffff802e2296>] ? sys_epoll_wait+0x106/0x5a0
 [<ffffffff8020c31b>] ? system_call_fastpath+0x16/0x1b

.. snip more firewall stuff ..

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata4.00: cmd 35/00:10:b0:70:75/00:00:1f:00:00/e0 tag 0 dma 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
