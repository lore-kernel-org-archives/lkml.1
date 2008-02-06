Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbYBFVvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbYBFVvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYBFVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:50:57 -0500
Received: from rfc2324.org ([89.149.194.216]:40251 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYBFVuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:50:54 -0500
X-Greylist: delayed 2786 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 16:50:53 EST
Date: Wed, 6 Feb 2008 22:04:26 +0100
From: Maximilian Wilhelm <max@rfc2324.org>
To: linux-kernel@vger.kernel.org
Subject: Kernel Panic in MPT SAS on 2.6.24 (and 2.6.23.14, 2.6.23.9)
Message-ID: <20080206210426.GD11236@outback.rfc2324.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 2.6.23.9-grsec auf i686
X-Warning: This message may contain ironic / sarcastic elements.
X-GC-3.12: GCM/CS/IT d+(--) s+: a-- C++>$ UL++++$ US>++++ P++ L+++>++++ E--- W+ N o+ K- w O? M? V? PS+ PE Y+ PGP++ t 5? X- R tv b+(++) DI+(++) !D G++ e>+++  h!>--(---) r++ y+
X-message-Flag: Outlook: A programm to spread viri, but it can mail, too.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While installing my new firewall I got the following kernel panic in
the MPT SAS driver which I need for the disks.

The first kernel I bootet was 2.6.23.14 which did panic so I tried a
2.6.24 which panics, too. Our usual FAI kernel (2.6.23.9) is also
affected.

If there is any information you may need to track this down, please
let me know.

I've put the .config to http://files.rfc2324.org/mptsas_panic/2.6.24-config
to limit the size of this mail.


Linux version 2.6.24 (mwilhelm@ulam) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Wed Feb 6 21:12:13 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 000000007fb50000 (usable)
 BIOS-e820: 000000007fb50000 - 000000007fb66000 (reserved)
 BIOS-e820: 000000007fb66000 - 000000007fb85c00 (ACPI data)
 BIOS-e820: 000000007fb85c00 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
1147MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   523088
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   523088
DMI 2.4 present.
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: DELL     Product ID: PE 01B3      APIC at: 0xFEE00000
Processor #0 6:15 APIC version 20
Processor #3 6:15 APIC version 20
Processor #1 6:15 APIC version 20
Processor #2 6:15 APIC version 20
Processor #7 6:15 APIC version 20
Processor #4 6:15 APIC version 20
Processor #6 6:15 APIC version 20
Processor #5 6:15 APIC version 20
I/O APIC #8 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 8
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519002
Kernel command line: root=/dev/nfs ip=dhcp FAI_ACTION=install nfsroot=/debian/fai/nfsroot,v3,tcp,rsize=32768,wsize=32768 FAI_FLAGS=verbose,sshd,createvt console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz-2.6.24-firewall2 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1862.010 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2069704k/2092352k available (2496k kernel code, 21480k reserved, 983k data, 192k init, 1174848k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff52000 - 0xfffff000   ( 692 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc046c000 - 0xc049c000   ( 192 kB)
      .data : 0xc0370264 - 0xc0465e9c   ( 983 kB)
      .text : 0xc0100000 - 0xc0370264   (2496 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3726.96 BogoMIPS (lpj=7453936)
Mount-cache hash table entries: 512
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 14k freed
CPU0: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3724.09 BogoMIPS (lpj=7448192)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Booting processor 2/2 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 3724.12 BogoMIPS (lpj=7448240)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Booting processor 3/3 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 3724.14 BogoMIPS (lpj=7448293)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Booting processor 4/4 eip 2000
Initializing CPU#4
Calibrating delay using timer specific routine.. 3724.18 BogoMIPS (lpj=7448376)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#4.
CPU4: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Booting processor 5/5 eip 2000
Initializing CPU#5
Calibrating delay using timer specific routine.. 3724.17 BogoMIPS (lpj=7448349)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#5.
CPU5: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Booting processor 6/6 eip 2000
Initializing CPU#6
Calibrating delay using timer specific routine.. 3724.17 BogoMIPS (lpj=7448343)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#6.
CPU6: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Booting processor 7/7 eip 2000
Initializing CPU#7
Calibrating delay using timer specific routine.. 3724.14 BogoMIPS (lpj=7448284)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#7.
CPU7: Intel(R) Xeon(R) CPU           E5320  @ 1.86GHz stepping 0b
Total of 8 processors activated (29796.00 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
net_namespace: 64 bytes
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb05e, last bus=14
PCI: Using configuration type 1
Setting up standard PCI resources
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Dell PowerEdge 1950 detected, enabling pci=bfsort.
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2670] at 0000:00:1f.0
PCI->APIC IRQ transform: 0000:00:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:02.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:03.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:06.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1c.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1d.0[A] -> IRQ 21
PCI->APIC IRQ transform: 0000:00:1d.1[B] -> IRQ 20
PCI->APIC IRQ transform: 0000:00:1d.2[C] -> IRQ 21
PCI->APIC IRQ transform: 0000:00:1d.3[D] -> IRQ 20
PCI->APIC IRQ transform: 0000:00:1d.7[A] -> IRQ 21
PCI->APIC IRQ transform: 0000:00:1f.1[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:04:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:05:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:05:01.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:07:00.0[A] -> IRQ 16
PCI: using PPB 0000:00:03.0[A] to get irq 16
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:0a:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:0a:00.1[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:0c:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:0c:00.1[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:03:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:0e:0d.0[A] -> IRQ 19
PCI: Bridge: 0000:06:00.0
  IO window: disabled.
Time: tsc clocksource has been installed.
  MEM window: f4000000-f7ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.0
  IO window: disabled.
  MEM window: f4000000-f7ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:04:00.0
  IO window: disabled.
  MEM window: f4000000-f7ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:04:00.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: f2000000-f7ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: e000-efff
  MEM window: fc700000-fc9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: d000-dfff
  MEM window: fc500000-fc6fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: c000-cfff
  MEM window: fc300000-fc4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: f8000000-fbffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: f8000000-fbffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: fc100000-fc2fffff
  PREFETCH window: d8000000-dfffffff
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
highmem bounce pool size: 64 pages
SGI XFS with ACLs, security attributes, realtime, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
floppy0: no floppy controllers found
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000: 0000:0a:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:15:17:4a:b4:d6
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: 0000:0a:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:15:17:4a:b4:d7
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: 0000:0c:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:15:17:4a:b4:c4
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: 0000:0c:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:15:17:4a:b4:c5
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.6.9 (December 8, 2007)
eth4: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 16, node addr 00:1d:09:64:5a:7f
eth5: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f4000000, IRQ 16, node addr 00:1d:09:64:5a:81
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ESB2: IDE controller (0x8086:0x269e rev 0x09) at  PCI slot 0000:00:1f.1
ESB2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:pio
ESB2: IDE port disabled
hda: TEAC CD-ROM CD-224E-N, ATAPI CD/DVD-ROM drive
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X CD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
Driver 'sd' needs updating - please use bus_type methods
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SAS Host driver 3.04.06
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1068E B3: Capabilities={Initiator}
scsi0 : ioc0: LSISAS1068E B3, FwRev=00142e00h, Ports=1, MaxQ=511, IRQ=16
scsi 0:0:0:0: Direct-Access     SEAGATE  ST973402SS       S207 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     SEAGATE  ST973402SS       S207 PQ: 0 ANSI: 5
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
printing eip: c02c0b38 *pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.24 #1)
EIP: 0060:[<c02c0b38>] EFLAGS: 00010246 CPU: 1
EIP is at mptsas_probe_expander_phys+0x51/0x4a2
EAX: 00000010 EBX: f7457ec0 ECX: f7c3fd9c EDX: 00000004
ESI: f7fe7800 EDI: f7fe7800 EBP: f7fe7904 ESP: f7c3fe18
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f7c3e000 task=f7c22ab0 task.ti=f7c3e000)
Stack: 0000ffff 00000000 00200200 fffefd74 c02b9cc8 f7fe7800 c04c5280 f7c3fecc 
       376b1000 00000001 00000000 00000000 00000000 00100100 00200200 00000000 
       00200200 fffefd74 c02b9cc8 f7fe7800 c04c5280 f7c3fe8c 376b1000 00000001 
Call Trace:
 [<c02b9cc8>] mpt_timer_expired+0x0/0x5c
 [<c02b9cc8>] mpt_timer_expired+0x0/0x5c
 [<c0280000>] ide_wait_cmd+0x90/0xa0
 [<c02c2806>] mptsas_probe+0x38a/0x40b
 [<c0180522>] sysfs_create_link+0xb7/0xf9
 [<c021ceb6>] pci_device_probe+0x36/0x57
 [<c023bcd0>] driver_probe_device+0xde/0x15c
 [<c036d3e5>] klist_next+0x4b/0x6b
 [<c023bde0>] __driver_attach+0x0/0x79
 [<c023be26>] __driver_attach+0x46/0x79
 [<c023b2a8>] bus_for_each_dev+0x33/0x55
 [<c023bb37>] driver_attach+0x16/0x18
 [<c023bde0>] __driver_attach+0x0/0x79
 [<c023b58e>] bus_add_driver+0x6d/0x197
 [<c021cff2>] __pci_register_driver+0x48/0x74
 [<c0480bd3>] mptsas_init+0xbf/0xd6
 [<c046c74e>] kernel_init+0x140/0x2a2
 [<c01024ca>] ret_from_fork+0x6/0x1c
 [<c046c60e>] kernel_init+0x0/0x2a2
 [<c046c60e>] kernel_init+0x0/0x2a2
 [<c010319f>] kernel_thread_helper+0x7/0x10
 =======================
Code: 85 c0 0f 84 68 04 00 00 8b 54 24 1c 8b 02 89 04 24 31 c9 89 da 89 f8 e8 2b f2 ff ff 89 44 24 2c 85 c0 8b 43 0c 0f 85 39 04 00 00 <0f> b7 00 8b 74 24 1c 89 06 8d 87 24 05 00 00 89 44 24 20 e8 5b 
EIP: [<c02c0b38>] mptsas_probe_expander_phys+0x51/0x4a2 SS:ESP 0068:f7c3fe18
---[ end trace 50b3e7147499e641 ]---
Kernel panic - not syncing: Attempted to kill init!


Thanks
Ciao
Max
-- 
	Follow the white penguin.
