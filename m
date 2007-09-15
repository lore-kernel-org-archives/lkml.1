Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbXIOOBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbXIOOBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXIOOBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:01:06 -0400
Received: from tag.witbe.net ([81.88.96.48]:55299 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbXIOOBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:01:04 -0400
Date: Sat, 15 Sep 2007 13:16:56 +0000
From: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB?=
	=?UTF-8?Q?=E3=83=AD=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
To: linux-kernel@vger.kernel.org
Cc: rol@witbe.net
Subject: 2.6.23-rc6 : crash with RTL8187 USB
Message-ID: <20070915131656.4cddab33@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Each time I add the support for this piece of hardware, I have a crash during
the boot process.
Serial console gives the attached boot message...

Linux version 2.6.23-rc6 (root@donald.as2917.net) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP Sat Sep 15 15:02:47 CEST 2007
Command line: ro root=LABEL=/1 rhgb irqpoll vga=extended console=ttyS0,38400
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000c7f80000 (usable)
 BIOS-e820: 00000000c7f80000 - 00000000c7f8e000 (ACPI data)
 BIOS-e820: 00000000c7f8e000 - 00000000c7fe0000 (ACPI NVS)
 BIOS-e820: 00000000c7fe0000 - 00000000c8000000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000FAF20, 0014 (r0 ACPIAM)
ACPI: RSDT C7F80000, 0040 (r1 A_M_I_ OEMRSDT   7000724 MSFT       97)
ACPI: FACP C7F80200, 0081 (r1 A_M_I_ OEMFACP   7000724 MSFT       97)
ACPI: DSDT C7F80590, 9560 (r1  A0543 A0543000        0 INTL 20060113)
ACPI: FACS C7F8E000, 0040
ACPI: APIC C7F80390, 0080 (r1 A_M_I_ OEMAPIC   7000724 MSFT       97)
ACPI: OEMB C7F8E040, 0066 (r1 A_M_I_ AMI_OEM   7000724 MSFT       97)
ACPI: HPET C7F89AF0, 0038 (r1 A_M_I_ OEMHPET   7000724 MSFT       97)
ACPI: MCFG C7F89B30, 003C (r1 A_M_I_ OEMMCFG   7000724 MSFT       97)
ACPI: SSDT C7F8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
ACPI: SSDT C7F8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   819072
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at cc000000 (gap: c8000000:37b00000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 31320 bytes of per cpu data
Built 1 zonelists in Zone order.  Total pages: 805591
Kernel command line: ro root=LABEL=/1 rhgb irqpoll vga=extended console=ttyS0,38400
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2404.112 MHz processor.
Console: colour VGA+ 80x50
console [ttyS0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
Memory: 3212620k/3276288k available (4864k kernel code, 62832k reserved, 2733k data, 276k init)
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 4823.96 BogoMIPS (lpj=9647923)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16695222
Detected 16.695 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4808.32 BogoMIPS (lpj=9616640)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
xor: automatically using best checksumming function: generic_sse
   generic_sse:  8757.000 MB/sec
xor: using function: generic_sse (8757.000 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  62, should be 59 [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
pnp: 00:07: ioport range 0x290-0x297 has been reserved
pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
pnp: 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
pnp: 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: 00:0e: iomem range 0xf0000000-0xf3ffffff has been reserved
pnp: 00:0f: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0f: iomem range 0xc0000-0xdffff has been reserved
pnp: 00:0f: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0f: iomem range 0x100000-0xc7ffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: ff900000-ff9fffff
  PREFETCH window: cff00000-efefffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: cfe00000-cfefffff
PCI: Bridge: 0000:00:1c.3
  IO window: b000-bfff
  MEM window: ff800000-ff8fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: a000-afff
  MEM window: ff700000-ff7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-9fff
  MEM window: ff600000-ff6fffff
  PREFETCH window: cc000000-cc0fffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2798k freed
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.28 [Flags: R/W].
fuse init (API version 7.8)
JFS: nTxBlock = 8192, nTxLock = 65536
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._OSC] (Node ffff810037ffe500), AE_ALREADY_EXISTS
ACPI: Marking method _OSC as Serialized
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PDC] (Node ffff810037ffe4e0), AE_ALREADY_EXISTS
ACPI: Marking method _PDC as Serialized
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._OSC] (Node ffff810037ffe620), AE_ALREADY_EXISTS
ACPI: Marking method _OSC as Serialized
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._PDC] (Node ffff810037ffe600), AE_ALREADY_EXISTS
ACPI: Marking method _PDC as Serialized
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI Exception (processor_core-0797): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0797): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
loop: module loaded
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 19
sky2 0000:03:00.0: v1.17 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2
sky2 eth0: addr 00:1a:92:ba:9e:03
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
sky2 0000:02:00.0: v1.17 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2
sky2 eth1: addr 00:1a:92:ba:8d:78
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
usbcore: registered new interface driver rtl8187
Linux video capture interface: v2.00
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001ffa0 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001ffa8 irq 15
ata1.00: ATA-7: ST3500630A, 3.AAE, max UDMA/100
ata1.00: 976773168 sectors, multi 16: LBA48 
ata1.01: ATAPI: ASUS    DRW-1608P, 1.40, max UDMA/66
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      ST3500630A       3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 > sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: CD-ROM            ASUS     DRW-1608P        1.40 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi generic sg1 type 5
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x000000000001e400 ctl 0x000000000001e082 bmdma 0x000000000001d880 irq 23
ata4: SATA max UDMA/133 cmd 0x000000000001e000 ctl 0x000000000001dc02 bmdma 0x000000000001d888 irq 23
ata3.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata3.00: 490234752 sectors, multi 16: LBA48 NCQ (not used)
ata3.01: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata3.01: 490234752 sectors, multi 16: LBA48 NCQ (not used)
ata3.00: configured for UDMA/133
ata3.01: configured for UDMA/133
ata4.01: ATA-7: ST3500641AS, 3.AAB, max UDMA/133
ata4.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.01: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 2:0:1:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
sd 2:0:1:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:1:0: [sdc] Write Protect is off
sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:1:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:1:0: [sdc] Write Protect is off
sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 2:0:1:0: [sdc] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg3 type 0
scsi 3:0:1:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5
sd 3:0:1:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:1:0: [sdd] Write Protect is off
sd 3:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:1:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:1:0: [sdd] Write Protect is off
sd 3:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:1:0: [sdd] Attached SCSI disk
sd 3:0:1:0: Attached scsi generic sg4 type 0
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 21 (level, low) -> IRQ 21
pata_pdc2027x 0000:01:00.0: PLL input clock 16680 kHz
scsi4 : pata_pdc2027x
scsi5 : pata_pdc2027x
ata5: PATA max UDMA/133 cmd 0xffffc200006117c0 ctl 0xffffc20000611fda bmdma 0xffffc20000611000 irq 21
ata6: PATA max UDMA/133 cmd 0xffffc200006115c0 ctl 0xffffc20000611dda bmdma 0xffffc20000611008 irq 21
ata5.00: ATA-7: Maxtor 6L200P0, BAH41E00, max UDMA/133
ata5.00: 398297088 sectors, multi 16: LBA48 
ata5.00: configured for UDMA/133
ata6.00: ATAPI: ASUS    CRW-5232A3, 1.00, max UDMA/33
ata6.00: configured for UDMA/33
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6L200P0   BAH4 PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 398297088 512-byte hardware sectors (203928 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sde] 398297088 512-byte hardware sectors (203928 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1 sde2 sde3 sde4 < sde5 sde6 >
sd 4:0:0:0: [sde] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg5 type 0
scsi 5:0:0:0: CD-ROM            ASUS     CRW-5232A3       1.00 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
sr 5:0:0:0: Attached scsi generic sg6 type 5
ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 21 (level, low) -> IRQ 21
firewire_ohci: Added fw-ohci device 0000:01:03.0, OHCI version 1.10
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffafbc00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e480
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
firewire_core: created new fw device fw0 (0 config rom retries, S400)
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ec00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-7: new high speed USB device using ehci_hcd and address 3
usb 1-7: configuration #1 chosen from 1 choice
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usb 1-7.3: new high speed USB device using ehci_hcd and address 4
usb 1-7.3: configuration #1 chosen from 1 choice
WARNING: at lib/kref.c:33 kref_get()
Call Trace:
 [<ffffffff8121fa41>] kref_get+0x2f/0x36
 [<ffffffff8121ec3f>] kobject_get+0x12/0x17
 [<ffffffff8121edad>] kobject_shadow_add+0x7f/0x1a2
 [<ffffffff812beaa4>] device_add+0xb7/0x631
 [<ffffffff81040607>] msleep+0x14/0x1e
 [<ffffffff8149f95f>] wiphy_register+0x29/0x80
 [<ffffffff814a4a9b>] ieee80211_register_hw+0x11/0x208
 [<ffffffff812e1a64>] rtl8187_probe+0x544/0x624
 [<ffffffff812e3452>] rtl8187_eeprom_register_read+0x0/0x82
 [<ffffffff812e148a>] rtl8187_eeprom_register_write+0x0/0x96
 [<ffffffff8133129d>] usb_match_one_id+0x26/0x82
 [<ffffffff81331f5c>] usb_probe_interface+0x8b/0xc1
 [<ffffffff812c0e56>] driver_probe_device+0xf7/0x174
 [<ffffffff812c0ed3>] __device_attach+0x0/0x5
 [<ffffffff812c00c0>] bus_for_each_drv+0x40/0x72
 [<ffffffff812c0f74>] device_attach+0x79/0x90
 [<ffffffff812c0034>] bus_attach_device+0x2a/0x76
 [<ffffffff812bed7e>] device_add+0x391/0x631
 [<ffffffff81330736>] usb_set_configuration+0x449/0x4cb
 [<ffffffff81337872>] generic_probe+0x1a5/0x1f3
 [<ffffffff812c0e56>] driver_probe_device+0xf7/0x174
 [<ffffffff812c0ed3>] __device_attach+0x0/0x5
 [<ffffffff812c00c0>] bus_for_each_drv+0x40/0x72
 [<ffffffff812c0f74>] device_attach+0x79/0x90
 [<ffffffff812c0034>] bus_attach_device+0x2a/0x76
 [<ffffffff812bed7e>] device_add+0x391/0x631
 [<ffffffff8132bf27>] usb_new_device+0xab/0xe4
 [<ffffffff8132cb36>] hub_thread+0x768/0xb49
 [<ffffffff81049fbd>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8132c3ce>] hub_thread+0x0/0xb49
 [<ffffffff81049ea4>] kthread+0x47/0x73
 [<ffffffff8100cd38>] child_rip+0xa/0x12
 [<ffffffff81049e5d>] kthread+0x0/0x73
 [<ffffffff8100cd2e>] child_rip+0x0/0x12
Unable to handle kernel NULL pointer dereference at 0000000000000038 RIP: 
 [<ffffffff810c4932>] sysfs_addrm_start+0x2d/0x99
PGD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in:
Pid: 246, comm: khubd Not tainted 2.6.23-rc6 #1
RIP: 0010:[<ffffffff810c4932>]  [<ffffffff810c4932>] sysfs_addrm_start+0x2d/0x99
RSP: 0000:ffff810037c09920  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000272ac7f36820 RSI: 0000000000000056 RDI: ffff810037ff7000
RBP: ffff810037c09940 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000272ac7f36820 R12: ffff8100c6faa168
R13: 0000000000000000 R14: ffff810037c09998 R15: ffffffff8176ae90
FS:  0000000000000000(0000) GS:ffffffff8176c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000038 CR3: 0000000000201000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 246, threadinfo ffff810037c08000, task ffff8100c7f36820)
Stack:  ffff8100c6faa168 ffff810037f7c6e0 ffff8100c6faa160 ffffffff810c4f4a
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 ffff8100c6faa160 0000000000000000 ffff8100c6faa070 ffff8100c6faa2e0
Call Trace:
 [<ffffffff810c4f4a>] create_dir+0x46/0xa7
 [<ffffffff810c5000>] sysfs_create_dir+0x55/0x71
 [<ffffffff8121ec3f>] kobject_get+0x12/0x17
 [<ffffffff8121ee1d>] kobject_shadow_add+0xef/0x1a2
 [<ffffffff812beaa4>] device_add+0xb7/0x631
 [<ffffffff81040607>] msleep+0x14/0x1e
 [<ffffffff8149f95f>] wiphy_register+0x29/0x80
 [<ffffffff814a4a9b>] ieee80211_register_hw+0x11/0x208
 [<ffffffff812e1a64>] rtl8187_probe+0x544/0x624
 [<ffffffff812e3452>] rtl8187_eeprom_register_read+0x0/0x82
 [<ffffffff812e148a>] rtl8187_eeprom_register_write+0x0/0x96
 [<ffffffff8133129d>] usb_match_one_id+0x26/0x82
 [<ffffffff81331f5c>] usb_probe_interface+0x8b/0xc1
 [<ffffffff812c0e56>] driver_probe_device+0xf7/0x174
 [<ffffffff812c0ed3>] __device_attach+0x0/0x5
 [<ffffffff812c00c0>] bus_for_each_drv+0x40/0x72
 [<ffffffff812c0f74>] device_attach+0x79/0x90
 [<ffffffff812c0034>] bus_attach_device+0x2a/0x76
 [<ffffffff812bed7e>] device_add+0x391/0x631
 [<ffffffff81330736>] usb_set_configuration+0x449/0x4cb
 [<ffffffff81337872>] generic_probe+0x1a5/0x1f3
 [<ffffffff812c0e56>] driver_probe_device+0xf7/0x174
 [<ffffffff812c0ed3>] __device_attach+0x0/0x5
 [<ffffffff812c00c0>] bus_for_each_drv+0x40/0x72
 [<ffffffff812c0f74>] device_attach+0x79/0x90
 [<ffffffff812c0034>] bus_attach_device+0x2a/0x76
 [<ffffffff812bed7e>] device_add+0x391/0x631
 [<ffffffff8132bf27>] usb_new_device+0xab/0xe4
 [<ffffffff8132cb36>] hub_thread+0x768/0xb49
 [<ffffffff81049fbd>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8132c3ce>] hub_thread+0x0/0xb49
 [<ffffffff81049ea4>] kthread+0x47/0x73
 [<ffffffff8100cd38>] child_rip+0xa/0x12
 [<ffffffff81049e5d>] kthread+0x0/0x73
 [<ffffffff8100cd2e>] child_rip+0x0/0x12
Code: 48 8b 73 38 48 89 d9 48 c7 c2 c0 46 0c 81 e8 cb f8 fc ff 48 
RIP  [<ffffffff810c4932>] sysfs_addrm_start+0x2d/0x99
 RSP <ffff810037c09920>
CR2: 0000000000000038
