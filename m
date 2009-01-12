Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZALHi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZALHi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 02:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZALHiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 02:38:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:15906 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZALHiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aBJd0lDmda1EilCvQ7ZB34QJtZkBf9obEM6dv9H/h1JFY2l1UbuKiBcr+yjcZWBcqX
         vJCPLstAneY4kEYkGKkj0ZD1iC5qbz2En2BNuWkH8lbd2HfxmNCwcmx7sRwOhbvJhJmT
         ZoYyRBlPl5eqzf+O+j4HjjG/5sfVtDov2kWVI=
MIME-Version: 1.0
Date: Mon, 12 Jan 2009 10:38:08 +0300
Message-ID: <d6a046090901112338s66143f5ekd03d461027407cf4@mail.gmail.com>
Subject: ath5k related kernel panic in 2.6.29-rc1
From: "Sergey S. Kostyliov" <rathamahata@gmail.com>
To: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Full dmesg including an oops is below:

Linux version 2.6.29-rc1 (rathamahata@autonomist.ath.cx) (gcc version
4.3.2 (Gentoo 4.3.2-r2 p1.5, pie-10.1.5) ) #2 SMP PREEMPT Mon Jan 12
00:08:24 MSK 2009
Command line: BOOT_IMAGE=/boot/linux-2.6.29-rc1 root=/dev/sda2
rootflags=commit=11 elevator=deadline
netconsole=6666@192.168.168.2/eth0,6667@192.168.168.1/00:13:8f:e0:34:f5
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003de80000 (usable)
 BIOS-e820: 000000003de80000 - 000000003de97000 (ACPI data)
 BIOS-e820: 000000003de97000 - 000000003df00000 (ACPI NVS)
 BIOS-e820: 000000003df00000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x3de80 max_arch_pfn = 0x100000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-000000003de80000
last_map_addr: 3de80000 end: 3de80000
ACPI: RSDP 000F7D80, 0014 (r0 ACRSYS)
ACPI: RSDT 3DE8E70B, 0038 (r1 ACRSYS ACRPRDCT  6040000  LTP        0)
ACPI: FACP 3DE96C04, 0074 (r1 ATI    Bowfin    6040000 ATI     F4240)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
FADT: X_PM1b_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3DE8E743, 84C1 (r1   Acer  Navarro  6040000 MSFT  3000000)
ACPI: FACS 3DE97FC0, 0040
ACPI: SLIC 3DE96C78, 0176 (r1 ACRSYS ACRPRDCT  6040000 LOHR        0)
ACPI: APIC 3DE96DEE, 0054 (r1 PTLTD      APIC    6040000  LTP
0)
ACPI: MCFG 3DE96E42, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
ACPI: SSDT 3DE96E7E, 0182 (r1 PTLTD  POWERNOW  6040000  LTP        1)
(5 early reservations) ==> bootmem [0000000000 - 003de80000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
  #2 [0000200000 - 000089cff4]    TEXT DATA BSS ==> [0000200000 -
000089cff4]
  #3 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 -
0000100000]
  #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 -
0000009000]
found SMP MP-table at [ffff8800000f7e40] 000f7e40
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x0003de80
SB4X0 revision 0x83
Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x8008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 49152 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
248206
Kernel command line: BOOT_IMAGE=/boot/linux-2.6.29-rc1 root=/dev/sda2
rootflags=commit=11 elevator=deadline
netconsole=6666@192.168.168.2/eth0,6667@192.168.168.1/00:13:8f:e0:34:f5
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 1596.202 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ cd0000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 990432k/1014272k available (4414k kernel code, 396k absent,
22856k reserved, 1647k data, 320k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2,
Nodes=1
Calibrating delay loop (skipped), value calculated using timer
frequency.. 3192.40 BogoMIPS (lpj=1596202)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20081204
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-52 stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3191.37 BogoMIPS
(lpj=1595687)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
System has AMD C1E enabled
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-52 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (6383.77 BogoMIPS).
net_namespace: 936 bytes
NET: Registered protocol family 16
Switch to broadcast mode on CPU1
TOM: 0000000040000000 aka 1024M
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 7
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e07fffff
PCI: Using configuration type 1 for base access
Switch to broadcast mode on CPU0
bio: create slab <bio-0> at 0
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:02:00.0: PME# supported from D3hot
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:06:01.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:06:01.0: PME# disabled
pci 0000:06:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:04.0: PME# disabled
pci 0000:06:04.1: PME# supported from D0 D1 D2 D3hot
pci 0000:06:04.1: PME# disabled
pci 0000:06:04.2: PME# supported from D0 D1 D2 D3hot
pci 0000:06:04.2: PME# disabled
pci 0000:06:04.3: PME# supported from D0 D1 D2 D3hot
pci 0000:06:04.3: PME# disabled
pci 0000:06:04.4: PME# supported from D0 D1 D2 D3hot
pci 0000:06:04.4: PME# disabled
pci 0000:00:14.4: transparent bridge
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKU] (IRQs 3 4 5 7) *0, disabled.
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:04.0: BAR 7: can't allocate resource
pci 0000:00:04.0: BAR 8: can't allocate resource
pci 0000:00:04.0: BAR 9: can't allocate resource
pci 0000:00:05.0: BAR 7: can't allocate resource
pci 0000:00:05.0: BAR 8: can't allocate resource
pci 0000:02:00.0: BAR 0: can't allocate resource
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:09: mem resource (0x0-0xfff) overlaps 0000:00:12.0 BAR 6
(0x0-0x7ffff), disabling
pnp 00:09: mem resource (0x0-0xfff) overlaps 0000:01:05.0 BAR 6
(0x0-0x1ffff), disabling
pnp 00:09: mem resource (0x0-0xfff) overlaps 0000:02:00.0 BAR 0
(0x0-0xffff), disabling
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:08: ioport range 0x1080-0x1080 has been reserved
system 00:08: ioport range 0x40b-0x40b has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0xc00-0xc01 has been reserved
system 00:08: ioport range 0xc14-0xc14 has been reserved
system 00:08: ioport range 0xc50-0xc52 has been reserved
system 00:08: ioport range 0xc6c-0xc6c has been reserved
system 00:08: ioport range 0xc6f-0xc6f has been reserved
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x280-0x293 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xe0000-0xfffff could not be reserved
system 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xfc000000-0xfc0fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000f8000000-0x000000fbffffff
pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
pci 0000:00:04.0:   IO window: disabled
pci 0000:00:04.0:   MEM window: 0x54000000-0x540fffff
pci 0000:00:04.0:   PREFETCH window: disabled
pci 0000:00:05.0: PCI bridge, secondary bus 0000:04
pci 0000:00:05.0:   IO window: disabled
pci 0000:00:05.0:   MEM window: disabled
pci 0000:00:05.0:   PREFETCH window: disabled
pci 0000:06:04.0: CardBus bridge, secondary bus 0000:07
pci 0000:06:04.0:   IO window: 0x00a400-0x00a4ff
pci 0000:06:04.0:   IO window: 0x00a800-0x00a8ff
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pci 0000:06:04.0:   PREFETCH window: 0x50000000-0x53ffffff
pci 0000:06:04.0:   MEM window: 0x58000000-0x5bffffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:06
pci 0000:00:14.4:   IO window: 0xa000-0xafff
pci 0000:00:14.4:   MEM window: 0xfc200000-0xfc2fffff
pci 0000:00:14.4:   PREFETCH window: 0x00000050000000-0x00000053ffffff
pci 0000:00:04.0: enabling device (0000 -> 0002)
pci 0000:06:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with security attributes, large block/inode numbers, no debug
enabled
msgmni has been set to 1935
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
pci 0000:00:00.0: MSI quirk detected; MSI disabled
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: processor limited to max C-state 1
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (68 C)
lp: driver loaded but no devices found
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:05.0: power state changed by ACPI to D0
pci 0000:01:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[drm] Initialized radeon 1.29.0 20080528 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
8139too Fast Ethernet driver 0.9.28
8139too 0000:06:01.0: power state changed by ACPI to D0
8139too 0000:06:01.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
eth0: RealTek RTL8139 at 0xffffc20000032000, 00:16:d4:ce:03:15, IRQ 21
ath5k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath5k 0000:02:00.0: registered as 'phy0'
wmaster0 (ath5k): not using net_device_ops yet
wlan0 (ath5k): not using net_device_ops yet
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
netconsole: local port 6666
netconsole: local IP 192.168.168.2
netconsole: interface eth0
netconsole: remote port 6667
netconsole: remote IP 192.168.168.1
netconsole: remote ethernet address 00:13:8f:e0:34:f5
netconsole: device eth0 not up yet, forcing it
eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
console [netcon0] enabled
netconsole: network logging started
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_sil 0000:00:12.0: enabling device (0005 -> 0007)
sata_sil 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xfc507000 tf 0xfc507080 irq 22
ata2: SATA max UDMA/100 mmio m512@0xfc507000 tf 0xfc5070c0 irq 22
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7: Hitachi HTS541612J9SA00, SBDOC70P, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54161 SBDO PQ: 0
ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111
GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111
GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata2: SATA link down (SStatus 0 SControl 310)
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
scsi2 : pata_atiixp
scsi3 : pata_atiixp
ata3: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8420 irq 14
ata4: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8428 irq 15
ata3.00: ATAPI: Slimtype DVD A  DS8A1P, CA11, max UDMA/33
ata3.00: configured for UDMA/33
scsi 2:0:0:0: CD-ROM            Slimtype DVD A  DS8A1P    CA11 PQ: 0
ANSI: 5
sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi generic sg1 type 5
ieee1394: raw1394: /dev/raw1394 device initialized
usbmon: debugfs is not available
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:13.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfc506000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29-rc1 ehci_hcd
usb usb1: SerialNumber: 0000:00:13.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 19, io mem 0xfc504000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29-rc1 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ohci_hcd 0000:00:13.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 19, io mem 0xfc505000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.29-rc1 ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSS0] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram
i2c /dev entries driver
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8410, revision 0
cpuidle: using governor ladder
cpuidle: using governor menu
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:06:04.2: SDHCI controller found [1524:0550] (rev 1)
sdhci-pci 0000:06:04.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
Registered led device: mmc0
mmc0: SDHCI controller on PCI [0000:06:04.2] using PIO
sdhci-pci 0000:06:04.4: SDHCI controller found [1524:0551] (rev 1)
sdhci-pci 0000:06:04.4: enabling device (0000 -> 0002)
sdhci-pci 0000:06:04.4: PCI INT B -> GSI 23 (level, low) -> IRQ 23
Registered led device: mmc1
mmc1: SDHCI controller on PCI [0000:06:04.4] using PIO
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.18a.
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ALSA device list:
  #0: HDA ATI SB at 0xfc500000 irq 16
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-52
processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x13
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
rtc_cmos 00:04: setting system clock to 2009-01-11 21:15:02 UTC
(1231708502)
usb 1-4: new high speed USB device using ehci_hcd and address 2
usb 1-4: New USB device found, idVendor=5986, idProduct=0100
usb 1-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-4: Product: USB2.0 Camera
usb 1-4: configuration #1 chosen from 1 choice
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1280b1, caps:
0xa04713/0x204000
input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio4/input/input5
EXT4-fs: barriers enabled
kjournald2 starting: pid 1199, dev sda2:8, commit interval 11 seconds
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem sda2 with ordered data mode
VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
Freeing unused kernel memory: 320k freed
usb 2-4: new low speed USB device using ohci_hcd and address 2
usb 2-4: New USB device found, idVendor=046d, idProduct=c019
usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-4: Product: USB Optical Mouse
usb 2-4: Manufacturer: Logitech
usb 2-4: configuration #1 chosen from 1 choice
input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:13.0/usb2/2-4/2-4:1.0/input/input6
generic-usb 0003:046D:C019.0001: input: USB HID v1.11 Mouse [Logitech
USB Optical Mouse] on usb-0000:00:13.0-4/input0
SysRq : Changing Loglevel
Loglevel set to 6
SysRq : Changing Loglevel
Loglevel set to 8
------------[ cut here ]------------
WARNING: at net/mac80211/tx.c:567 invoke_tx_handlers+0xdde/0xe30()
Hardware name: Aspire 5100
Modules linked in:
Pid: 3508, comm: rsync Not tainted 2.6.29-rc1 #2
Call Trace:
 [<ffffffff8023e55a>] warn_slowpath+0xea/0x160
 [<ffffffff8062f6ce>] invoke_tx_handlers+0xdde/0xe30
 [<ffffffff8062e3b6>] __ieee80211_tx_prepare+0x196/0x310
 [<ffffffff805933a0>] pskb_expand_head+0x110/0x180
 [<ffffffff80630a1a>] ieee80211_master_start_xmit+0x20a/0x4c0
 [<ffffffff805acb86>] __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff806305b3>] ieee80211_subif_start_xmit+0x3b3/0x610
 [<ffffffff805acb86>] __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff805bf6ce>] ip_queue_xmit+0x22e/0x430
 [<ffffffff802badc0>] pollwake+0x0/0x50
 [<ffffffff805d2f7f>] tcp_transmit_skb+0x4bf/0x760
 [<ffffffff805d54e9>] tcp_write_xmit+0x1f9/0xa40
 [<ffffffff805d5d83>] __tcp_push_pending_frames+0x23/0x80
 [<ffffffff805c89d5>] tcp_sendmsg+0x8b5/0xc00
 [<ffffffff802bbee8>] dput+0xa8/0x170
 [<ffffffff8058a677>] sock_aio_write+0x147/0x160
 [<ffffffff802aa24b>] do_sync_write+0xdb/0x120
 [<ffffffff80254e70>] autoremove_wake_function+0x0/0x30
 [<ffffffff8025c128>] getnstimeofday+0x58/0xe0
 [<ffffffff80258330>] ktime_get_ts+0x30/0x60
 [<ffffffff802b9614>] poll_select_copy_remaining+0x104/0x160
 [<ffffffff802aacfe>] vfs_write+0x15e/0x170
 [<ffffffff802aae13>] sys_write+0x53/0xa0
 [<ffffffff8020ba1b>] system_call_fastpath+0x16/0x1b
---[ end trace bd3017b2640f5911 ]---
------------[ cut here ]------------
WARNING: at net/mac80211/tx.c:56 ieee80211_duration+0x239/0x250()
Hardware name: Aspire 5100
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc1 #2
Call Trace:
 <IRQ>  [<ffffffff8023e55a>] warn_slowpath+0xea/0x160
 [<ffffffff8025c128>] getnstimeofday+0x58/0xe0
 [<ffffffff80258330>] ktime_get_ts+0x30/0x60
 [<ffffffff8027ac65>] __rmqueue_smallest+0x105/0x1b0
 [<ffffffff8027ad40>] __rmqueue+0x30/0x2b0
 [<ffffffff8025f214>] tick_handle_oneshot_broadcast+0xc4/0x100
 [<ffffffff804ac3cd>] ath5k_hw_start_tx_dma+0xfd/0x140
 [<ffffffff804b5e64>] ath5k_tx+0x494/0x5d0
 [<ffffffff8062f0bd>] invoke_tx_handlers+0x7cd/0xe30
 [<ffffffff8062e8d9>] ieee80211_duration+0x239/0x250
 [<ffffffff8062f0bd>] invoke_tx_handlers+0x7cd/0xe30
 [<ffffffff8062e3b6>] __ieee80211_tx_prepare+0x196/0x310
 [<ffffffff805933a0>] pskb_expand_head+0x110/0x180
 [<ffffffff80630a1a>] ieee80211_master_start_xmit+0x20a/0x4c0
 [<ffffffff805acb86>] __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff806305b3>] ieee80211_subif_start_xmit+0x3b3/0x610
 [<ffffffff80231cdf>] activate_task+0x2f/0x50
 [<ffffffff805acb86>] __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff805bf6ce>] ip_queue_xmit+0x22e/0x430
 [<ffffffff8062ba1b>] ieee80211_deliver_skb+0xbb/0x1a0
 [<ffffffff8062bf09>] ieee80211_invoke_rx_handlers+0x409/0x15c0
 [<ffffffff805d2f7f>] tcp_transmit_skb+0x4bf/0x760
 [<ffffffff805d0d1d>] tcp_rcv_established+0x3cd/0x920
 [<ffffffff805d877d>] tcp_v4_do_rcv+0xdd/0x210
 [<ffffffff805d8f22>] tcp_v4_rcv+0x672/0x710
 [<ffffffff805ba6e5>] ip_local_deliver_finish+0xb5/0x160
 [<ffffffff805ba131>] ip_rcv_finish+0x121/0x340
 [<ffffffff80212900>] nommu_map_single+0x0/0xa0
 [<ffffffff8059a64b>] netif_receive_skb+0x28b/0x370
 [<ffffffff8059ac90>] process_backlog+0x70/0xc0
 [<ffffffff80598d71>] net_rx_action+0x121/0x1e0
 [<ffffffff802442f3>] __do_softirq+0x73/0x130
 [<ffffffff8020caac>] call_softirq+0x1c/0x30
 [<ffffffff8020e475>] do_softirq+0x35/0x80
 [<ffffffff80243f9d>] irq_exit+0x8d/0xb0
 [<ffffffff8020e6d3>] do_IRQ+0x83/0x110
 [<ffffffff8020c353>] ret_from_intr+0x0/0xa
 <EOI> <4>---[ end trace bd3017b2640f5912 ]---
------------[ cut here ]------------
WARNING: at include/net/mac80211.h:991 ath5k_tx+0x4b5/0x5d0()
Hardware name: Aspire 5100
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc1 #2
Call Trace:
 <IRQ>  [<ffffffff804abbe0>] ath5k_hw_setup_4word_tx_desc+0x0/0x260
 [<ffffffff804abbe0>] ath5k_hw_setup_4word_tx_desc+0x0/0x260
 [<ffffffff8023e55a>] warn_slowpath+0xea/0x160
 [<ffffffff8025c128>] getnstimeofday+0x58/0xe0
 [<ffffffff80258330>] ktime_get_ts+0x30/0x60
 [<ffffffff8027ac65>] __rmqueue_smallest+0x105/0x1b0
 [<ffffffff8025f214>] tick_handle_oneshot_broadcast+0xc4/0x100
 [<ffffffff804b5e64>] ath5k_tx+0x494/0x5d0
 [<ffffffff8062f0bd>] invoke_tx_handlers+0x7cd/0xe30
 [<ffffffff804abbe0>] ath5k_hw_setup_4word_tx_desc+0x0/0x260
 [<ffffffff804b5e85>] ath5k_tx+0x4b5/0x5d0
 [<ffffffff8062f0bd>] invoke_tx_handlers+0x7cd/0xe30
 [<ffffffff804abbe0>] ath5k_hw_setup_4word_tx_desc+0x0/0x260
 [<ffffffff805933a0>] pskb_expand_head+0x110/0x180
 [<ffffffff8062fd4e>] __ieee80211_tx+0x4e/0x150
 [<ffffffff80630a41>] ieee80211_master_start_xmit+0x231/0x4c0
 [<ffffffff805acb86>] __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff806305b3>] ieee80211_subif_start_xmit+0x3b3/0x610
 [<ffffffff80231cdf>] activate_task+0x2f/0x50
 [<ffffffff805acb86>] __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff805bf6ce>] ip_queue_xmit+0x22e/0x430
 [<ffffffff8062ba1b>] ieee80211_deliver_skb+0xbb/0x1a0
 [<ffffffff8062bf09>] ieee80211_invoke_rx_handlers+0x409/0x15c0
 [<ffffffff805d2f7f>] tcp_transmit_skb+0x4bf/0x760
 [<ffffffff805d0d1d>] tcp_rcv_established+0x3cd/0x920
 [<ffffffff805d877d>] tcp_v4_do_rcv+0xdd/0x210
 [<ffffffff805d8f22>] tcp_v4_rcv+0x672/0x710
 [<ffffffff805ba6e5>] ip_local_deliver_finish+0xb5/0x160
 [<ffffffff805ba131>] ip_rcv_finish+0x121/0x340
 [<ffffffff80212900>] nommu_map_single+0x0/0xa0
 [<ffffffff8059a64b>] netif_receive_skb+0x28b/0x370
 [<ffffffff8059ac90>] process_backlog+0x70/0xc0
 [<ffffffff80598d71>] net_rx_action+0x121/0x1e0
 [<ffffffff802442f3>] __do_softirq+0x73/0x130
 [<ffffffff8020caac>] call_softirq+0x1c/0x30
 [<ffffffff8020e475>] do_softirq+0x35/0x80
 [<ffffffff80243f9d>] irq_exit+0x8d/0xb0
 [<ffffffff8020e6d3>] do_IRQ+0x83/0x110
 [<ffffffff8020c353>] ret_from_intr+0x0/0xa
 <EOI> <4>---[ end trace bd3017b2640f5913 ]---
BUG: unable to handle kernel NULL pointer dereference at
0000000000000006
IP: [<ffffffff804b5bd8>] ath5k_tx+0x208/0x5d0
PGD 3c9dc067 PUD 3c079067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1c/PNP0C0A:00/power_supply/BAT1/charge_full
CPU 1
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc1 #2
RIP: 0010:[<ffffffff804b5bd8>]  [<ffffffff804b5bd8>]
ath5k_tx+0x208/0x5d0
RSP: 0018:ffff88003d88b8a8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff804abbe0 RCX: ffffffff804a6ff5
RDX: ffff8800807ca000 RSI: 0000000000000046 RDI: ffff8800350d6000
RBP: ffff88003cc9b090 R08: ffff88000101be00 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003d9d5890
R13: ffff88003cd51900 R14: ffff8800350d6000 R15: 0000000000000011
FS:  00007fd3486846f0(0000) GS:ffff88003d805b00(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000006 CR3: 000000003acb4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88003d884000, task ffff88003d862160)
Stack:
 ffff88003cd502a0 ffff88003cd7b080 ffff88003cd7b080 0000000000000001
 ffff88003d88b9e8 ffff8800350d6000 ffff88003cd7b080 ffffffff8062f0bd
 ffff88003d88b958 ffff88003cd54b90 ffff88003cd54b80 00000060ffffffff
Call Trace:
 <IRQ> <0> [<ffffffff8062f0bd>] ? invoke_tx_handlers+0x7cd/0xe30
 [<ffffffff804abbe0>] ? ath5k_hw_setup_4word_tx_desc+0x0/0x260
 [<ffffffff805933a0>] ? pskb_expand_head+0x110/0x180
 [<ffffffff8062fd4e>] ? __ieee80211_tx+0x4e/0x150
 [<ffffffff80630a41>] ? ieee80211_master_start_xmit+0x231/0x4c0
 [<ffffffff805acb86>] ? __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] ? dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff806305b3>] ? ieee80211_subif_start_xmit+0x3b3/0x610
 [<ffffffff80231cdf>] ? activate_task+0x2f/0x50
 [<ffffffff805acb86>] ? __qdisc_run+0x226/0x270
 [<ffffffff8059b8a0>] ? dev_queue_xmit+0x2a0/0x5b0
 [<ffffffff805bf6ce>] ? ip_queue_xmit+0x22e/0x430
 [<ffffffff8062ba1b>] ? ieee80211_deliver_skb+0xbb/0x1a0
 [<ffffffff8062bf09>] ? ieee80211_invoke_rx_handlers+0x409/0x15c0
 [<ffffffff805d2f7f>] ? tcp_transmit_skb+0x4bf/0x760
 [<ffffffff805d0d1d>] ? tcp_rcv_established+0x3cd/0x920
 [<ffffffff805d877d>] ? tcp_v4_do_rcv+0xdd/0x210
 [<ffffffff805d8f22>] ? tcp_v4_rcv+0x672/0x710
 [<ffffffff805ba6e5>] ? ip_local_deliver_finish+0xb5/0x160
 [<ffffffff805ba131>] ? ip_rcv_finish+0x121/0x340
 [<ffffffff80212900>] ? nommu_map_single+0x0/0xa0
 [<ffffffff8059a64b>] ? netif_receive_skb+0x28b/0x370
 [<ffffffff8059ac90>] ? process_backlog+0x70/0xc0
 [<ffffffff80598d71>] ? net_rx_action+0x121/0x1e0
 [<ffffffff802442f3>] ? __do_softirq+0x73/0x130
 [<ffffffff8020caac>] ? call_softirq+0x1c/0x30
 [<ffffffff8020e475>] ? do_softirq+0x35/0x80
 [<ffffffff80243f9d>] ? irq_exit+0x8d/0xb0
 [<ffffffff8020e6d3>] ? do_IRQ+0x83/0x110
 [<ffffffff8020c353>] ? ret_from_intr+0x0/0xa
 <EOI> <0>Code: 8b 4c 24 60 48 8b 50 28 0f b6 41 04 48 8b 4c c2 18 48
0f be c6 48 8d 14 85 00 00 00 00 48 c1 e0 04 48 29 d0 48 03 41 08 4c
89 f7 <44> 0f b760 06 41 8b 9d 18 34 00 00 e8 07 be 17 00 89 c1 8b 44
RIP  [<ffffffff804b5bd8>] ath5k_tx+0x208/0x5d0
 RSP <ffff88003d88b8a8>
CR2: 0000000000000006
---[ end trace bd3017b2640f5914 ]---
