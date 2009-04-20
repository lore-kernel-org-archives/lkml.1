Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZDTRge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZDTRge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZDTRgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:36:24 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:33099 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDTRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:36:22 -0400
Date: Mon, 20 Apr 2009 14:35:27 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Jeff Garzik <jeff@garzik.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090420173526.GA7935@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca> <49EB1C9C.3000105@msgid.tls.msk.ru> <49EB1FB3.5000609@garzik.org> <20090419201132.GB2891@ime.usp.br> <49EB9758.3020506@garzik.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49EB9758.3020506@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi, Jeff.

On Apr 19 2009, Jeff Garzik wrote:
> Well, it's supposed to reduce speed in several circumstances... just
> not Michael's.  :)

Well, I'll take that as a yes. :-)

Can you comment on the dmesg log attached? I'd like to, at least,
understand what is happening, since I'm starting to consider using
libata with all my computers.

This computer, in particular, uses an IDE drive with a 40 ribbon cable
(and, thus, no UDMA/66). The cable is well put (checked two times
already) and I believe that everything is OK with this cable, since I
substituted it was already substituting one that gave me the same
results.

I can post any information that is desired about this machine (but the
dmesg talks a lot about it, of course).

(Yes, this dmesg is from Ubuntu, and, yes, I can use a vanilla kernel
from kernel.org--just let me know if it is necessary to change anything
and I will do just that).


Thanks, Rogério.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-dumont.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.27-14-generic (buildd@palmer) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #1 SMP Fri Mar 13 18:00:20 UTC 2009 (Ubuntu 2.6.27-14.30-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
[    0.000000]  BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
[    0.000000]  BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x1ffec max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 1ffec000 @ 7000-d000
[    0.000000] RAMDISK: 1f817000 - 1ffdbc0d
[    0.000000] ACPI: RSDP 000F6A90, 0014 (r0 ASUS  )
[    0.000000] ACPI: RSDT 1FFEC000, 002C (r1 ASUS   A7V      30303031 MSFT 31313031)
[    0.000000] ACPI: FACP 1FFEC080, 0074 (r1 ASUS   A7V      30303031 MSFT 31313031)
[    0.000000] ACPI: DSDT 1FFEC100, 2CE1 (r1   ASUS A7V          1000 MSFT  100000B)
[    0.000000] ACPI: FACS 1FFFF000, 0040
[    0.000000] ACPI: BOOT 1FFEC040, 0028 (r1 ASUS   A7V      30303031 MSFT 31313031)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1ffec000
[    0.000000]   low ram: 00000000 - 1ffec000
[    0.000000]   bootmap 00002000 - 00006000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 001ffec000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00005c39e0]    TEXT DATA BSS ==> [0000100000 - 00005c39e0]
[    0.000000]   #4 [001f817000 - 001ffdbc0d]          RAMDISK ==> [001f817000 - 001ffdbc0d]
[    0.000000]   #5 [00005c4000 - 00005c7000]    INIT_PG_TABLE ==> [00005c4000 - 00005c7000]
[    0.000000]   #6 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #8 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001ffec
[    0.000000]   HighMem  0x0001ffec -> 0x0001ffec
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001ffec
[    0.000000] On node 0 totalpages: 130955
[    0.000000] free_area_init_node: node 0, pgdat c048c700, node_mem_map c1000000
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 125840 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xe408
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] mapped APIC to ffffb000 (01482000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
[    0.000000] PERCPU: Allocating 41628 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 1, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129803
[    0.000000] Kernel command line: root=UUID=283b17d2-52e3-4a81-ab2d-c1ace5ecd06c ro quiet splash locale=pt_BR 
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PIT calibration value
[    0.000000] Detected 1049.982 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.004000] Memory: 505656k/524208k available (2577k kernel code, 17948k reserved, 1163k data, 428k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffc77000 - 0xfffff000   (3616 kB)
[    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.004000]     vmalloc : 0xe0800000 - 0xff3fe000   ( 491 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
[    0.004000]       .init : 0xc04ad000 - 0xc0518000   ( 428 kB)
[    0.004000]       .data : 0xc038473a - 0xc04a7680   (1163 kB)
[    0.004000]       .text : 0xc0100000 - 0xc038473a   (2577 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.004020] Calibrating delay loop (skipped), value calculated using timer frequency.. 2099.96 BogoMIPS (lpj=4199928)
[    0.004066] Security Framework initialized
[    0.004082] SELinux:  Disabled at boot.
[    0.004135] AppArmor: AppArmor initialized
[    0.004154] Mount-cache hash table entries: 512
[    0.004516] Initializing cgroup subsys ns
[    0.004529] Initializing cgroup subsys cpuacct
[    0.004534] Initializing cgroup subsys memory
[    0.004567] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004573] CPU: L2 Cache: 64K (64 bytes/line)
[    0.004606] Checking 'hlt' instruction... OK.
[    0.020591] SMP alternatives: switching to UP code
[    0.031087] Freeing SMP alternatives: 11k freed
[    0.031096] ACPI: Core revision 20080609
[    0.033428] ACPI: Checking initramfs for custom DSDT
[    0.660833] ACPI: setting ELCR to 0200 (from 0e20)
[    0.661062] weird, boot CPU (#0) not listedby the BIOS.
[    0.661068] SMP motherboard not detected.
[    0.661075] Local APIC not detected. Using dummy APIC emulation.
[    0.661080] SMP disabled
[    0.661237] Brought up 1 CPUs
[    0.661242] Total of 1 processors activated (2099.96 BogoMIPS).
[    0.661272] CPU0 attaching NULL sched-domain.
[    0.661848] net_namespace: 840 bytes
[    0.661870] Booting paravirtualized kernel on bare hardware
[    0.662281] Time:  5:43:06  Date: 04/20/09
[    0.662360] NET: Registered protocol family 16
[    0.663250] EISA bus registered
[    0.663312] ACPI: bus type pci registered
[    0.665971] PCI: PCI BIOS revision 2.10 entry at 0xf1180, last bus=1
[    0.665978] PCI: Using configuration type 1 for base access
[    0.669224] ACPI: EC: Look up EC in DSDT
[    0.676577] ACPI: Interpreter enabled
[    0.676594] ACPI: (supports S0 S1 S4 S5)
[    0.676628] ACPI: Using PIC for interrupt routing
[    0.694151] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.694353] PCI: 0000:00:00.0 reg 10 32bit mmio: [e6000000, e7ffffff]
[    0.694395] pci 0000:00:00.0: Disabling VIA memory write queue (PCI ID 0305, rev 02): [55] 89 & 1f -> 09
[    0.694460] pci 0000:00:01.0: supports D1
[    0.694557] PCI: 0000:00:04.1 reg 20 io port: [d800, d80f]
[    0.694628] PCI: 0000:00:04.2 reg 20 io port: [d400, d41f]
[    0.694696] PCI: 0000:00:04.3 reg 20 io port: [d000, d01f]
[    0.694787] pci 0000:00:04.4: quirk: region e400-e4ff claimed by vt82c586 ACPI
[    0.694794] pci 0000:00:04.4: quirk: region e200-e27f claimed by vt82c686 HW-mon
[    0.694802] pci 0000:00:04.4: quirk: region e800-e80f claimed by vt82c686 SMB
[    0.694850] PCI: 0000:00:09.0 reg 10 io port: [a400, a4ff]
[    0.694860] PCI: 0000:00:09.0 reg 14 32bit mmio: [e2000000, e20000ff]
[    0.694902] pci 0000:00:09.0: supports D1
[    0.694906] pci 0000:00:09.0: supports D2
[    0.694911] pci 0000:00:09.0: PME# supported from D1 D2 D3hot
[    0.694918] pci 0000:00:09.0: PME# disabled
[    0.694949] PCI: 0000:00:0a.0 reg 10 io port: [a000, a03f]
[    0.694995] pci 0000:00:0a.0: supports D2
[    0.695023] PCI: 0000:00:0b.0 reg 10 32bit mmio: [e1800000, e18007ff]
[    0.695033] PCI: 0000:00:0b.0 reg 14 io port: [9800, 987f]
[    0.695076] pci 0000:00:0b.0: supports D2
[    0.695081] pci 0000:00:0b.0: PME# supported from D2 D3hot D3cold
[    0.695087] pci 0000:00:0b.0: PME# disabled
[    0.695114] PCI: 0000:00:0c.0 reg 10 io port: [9400, 9407]
[    0.695158] pci 0000:00:0c.0: supports D2
[    0.695163] pci 0000:00:0c.0: PME# supported from D0 D2 D3hot D3cold
[    0.695170] pci 0000:00:0c.0: PME# disabled
[    0.695211] PCI: 0000:00:0d.0 reg 20 io port: [9000, 901f]
[    0.695241] pci 0000:00:0d.0: supports D1
[    0.695245] pci 0000:00:0d.0: supports D2
[    0.695249] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot
[    0.695256] pci 0000:00:0d.0: PME# disabled
[    0.695297] PCI: 0000:00:0d.1 reg 20 io port: [8800, 881f]
[    0.695327] pci 0000:00:0d.1: supports D1
[    0.695331] pci 0000:00:0d.1: supports D2
[    0.695335] pci 0000:00:0d.1: PME# supported from D0 D1 D2 D3hot
[    0.695342] pci 0000:00:0d.1: PME# disabled
[    0.695369] PCI: 0000:00:0d.2 reg 10 32bit mmio: [e1000000, e10000ff]
[    0.695414] pci 0000:00:0d.2: supports D1
[    0.695418] pci 0000:00:0d.2: supports D2
[    0.695422] pci 0000:00:0d.2: PME# supported from D0 D1 D2 D3hot
[    0.695429] pci 0000:00:0d.2: PME# disabled
[    0.695464] PCI: 0000:00:11.0 reg 10 io port: [8400, 8407]
[    0.695472] PCI: 0000:00:11.0 reg 14 io port: [8000, 8003]
[    0.695481] PCI: 0000:00:11.0 reg 18 io port: [7800, 7807]
[    0.695490] PCI: 0000:00:11.0 reg 1c io port: [7400, 7403]
[    0.695499] PCI: 0000:00:11.0 reg 20 io port: [7000, 703f]
[    0.695508] PCI: 0000:00:11.0 reg 24 32bit mmio: [e0800000, e081ffff]
[    0.695517] PCI: 0000:00:11.0 reg 30 32bit mmio: [0, ffff]
[    0.695589] PCI: 0000:01:00.0 reg 10 32bit mmio: [e4000000, e5ffffff]
[    0.695598] PCI: 0000:01:00.0 reg 14 32bit mmio: [e3000000, e3003fff]
[    0.695607] PCI: 0000:01:00.0 reg 18 32bit mmio: [e2800000, e2ffffff]
[    0.695627] PCI: 0000:01:00.0 reg 30 32bit mmio: [e3ff0000, e3ffffff]
[    0.695687] PCI: bridge 0000:00:01.0 32bit mmio: [e2800000, e3dfffff]
[    0.695695] PCI: bridge 0000:00:01.0 32bit mmio pref: [e3f00000, e5ffffff]
[    0.695705] bus 00 -> node 0
[    0.695729] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.822288] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.822521] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.822741] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.822959] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.823438] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.823536] pnp: PnP ACPI init
[    0.823564] ACPI: bus type pnp registered
[    0.825584] pnp 00:03: io resource (0xe400-0xe47f) overlaps 0000:00:04.4 BAR 7 (0xe400-0xe4ff), disabling
[    0.832140] pnp: PnP ACPI: found 14 devices
[    0.832150] ACPI: ACPI bus type pnp unregistered
[    0.832160] PnPBIOS: Disabled by ACPI PNP
[    0.833233] PCI: Using ACPI for IRQ routing
[    0.833518] NET: Registered protocol family 8
[    0.833518] NET: Registered protocol family 20
[    0.833518] NetLabel: Initializing
[    0.833518] NetLabel:  domain hash size = 128
[    0.833518] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.833518] NetLabel:  unlabeled traffic allowed by default
[    0.833518] tracer: 772 pages allocated for 65536 entries of 48 bytes
[    0.833518]    actual entries 65620
[    0.833518] AppArmor: AppArmor Filesystem Enabled
[    0.833518] ACPI: RTC can wake from S4
[    0.833518] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.833518] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.833518] system 00:00: iomem range 0x100000-0x1fffffff could not be reserved
[    0.833518] system 00:00: iomem range 0xfffe0000-0xffffffff could not be reserved
[    0.833518] system 00:02: ioport range 0x3f0-0x3f1 has been reserved
[    0.833518] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.833518] system 00:03: ioport range 0xe800-0xe80f has been reserved
[    0.871391] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.871400] pci 0000:00:01.0:   IO window: disabled
[    0.871409] pci 0000:00:01.0:   MEM window: 0xe2800000-0xe3dfffff
[    0.871417] pci 0000:00:01.0:   PREFETCH window: 0x000000e3f00000-0x000000e5ffffff
[    0.871439] pci 0000:00:01.0: setting latency timer to 64
[    0.871447] bus: 00 index 0 io port: [0, ffff]
[    0.871451] bus: 00 index 1 mmio: [0, ffffffff]
[    0.871456] bus: 01 index 0 mmio: [0, 0]
[    0.871460] bus: 01 index 1 mmio: [e2800000, e3dfffff]
[    0.871465] bus: 01 index 2 mmio: [e3f00000, e5ffffff]
[    0.871469] bus: 01 index 3 mmio: [0, 0]
[    0.871501] NET: Registered protocol family 2
[    0.871800] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.872354] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.872745] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.873117] TCP: Hash tables configured (established 16384 bind 16384)
[    0.873126] TCP reno registered
[    0.873377] NET: Registered protocol family 1
[    0.873653] checking if image is initramfs...<7>Switched to high resolution mode on CPU 0
[    1.498603]  it is
[    2.268393] Freeing initrd memory: 7955k freed
[    2.268760] Simple Boot Flag at 0x3a set to 0x1
[    2.270099] audit: initializing netlink socket (disabled)
[    2.270139] type=2000 audit(1240206187.268:1): initialized
[    2.281418] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.287248] VFS: Disk quotas dquot_6.5.1
[    2.287534] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.287868] msgmni has been set to 1003
[    2.289029] io scheduler noop registered
[    2.289039] io scheduler anticipatory registered
[    2.289044] io scheduler deadline registered
[    2.289106] io scheduler cfq registered (default)
[    2.289134] PCI: VIA PCI bridge detected.Disabling DAC.
[    2.289144] pci 0000:00:04.0: Disabling VIA external APIC routing
[    2.289256] pci 0000:01:00.0: Boot video device
[    2.290222] isapnp: Scanning for PnP cards...
[    2.644393] isapnp: No Plug & Play device found
[    2.862309] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    2.862571] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.863212] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.865958] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.867313] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.868884] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    2.868896] PCI: setting IRQ 11 as level-triggered
[    2.868907] serial 0000:00:0c.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    2.869738] 0000:00:0c.0: ttyS2 at I/O 0x9400 (irq = 11) is a 16550A
[    2.874849] brd: module loaded
[    2.875061] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    2.875396] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.875903] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.875917] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.877653] mice: PS/2 mouse device common for all mice
[    2.878224] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.878263] rtc0: alarms up to one year
[    2.878635] EISA: Probing bus 0 at eisa.0
[    2.878682] Cannot allocate resource for EISA slot 7
[    2.878687] Cannot allocate resource for EISA slot 8
[    2.878692] EISA: Detected 0 cards.
[    2.878698] cpuidle: using governor ladder
[    2.878703] cpuidle: using governor menu
[    2.879916] TCP cubic registered
[    2.879990] Using IPI No-Shortcut mode
[    2.881130] registered taskstats version 1
[    2.881388]   Magic number: 5:701:719
[    2.881737] rtc_cmos 00:05: setting system clock to 2009-04-20 05:43:08 UTC (1240206188)
[    2.881745] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.881750] EDD information not available.
[    2.882876] Freeing unused kernel memory: 428k freed
[    2.882993] Write protecting the kernel text: 2580k
[    2.883065] Write protecting the kernel read-only data: 940k
[    2.898724] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.380128] fuse init (API version 7.9)
[    3.457280] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    3.457444] processor ACPI0007:00: registered as cooling_device0
[    3.457455] ACPI: Processor [CPU0] (supports 16 throttling states)
[    4.704358] Floppy drive(s): fd0 is 1.44M
[    4.723794] FDC 0 is a post-1991 82077
[    4.979347] No dock devices found.
[    5.207381] SCSI subsystem initialized
[    5.213563] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    5.213611] 8139cp 0000:00:09.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
[    5.213621] 8139cp 0000:00:09.0: Try the "8139too" driver instead.
[    5.244329] 8139too Fast Ethernet driver 0.9.28
[    5.272089] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
[    5.272101] PCI: setting IRQ 9 as level-triggered
[    5.272111] 8139too 0000:00:09.0: PCI INT A -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
[    5.272974] eth0: RealTek RTL8139 at 0xa400, 00:e0:7d:96:28:8f, IRQ 9
[    5.272981] eth0:  Identified 8139 chip type 'RTL-8139C'
[    5.366397] usbcore: registered new interface driver usbfs
[    5.366478] usbcore: registered new interface driver hub
[    5.452225] usbcore: registered new device driver usb
[    5.540734] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.540747] PCI: setting IRQ 10 as level-triggered
[    5.540758] ohci1394 0000:00:0b.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[    5.593721] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  MMIO=[e1800000-e18007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    5.623739] libata version 3.00 loaded.
[    5.626074] USB Universal Host Controller Interface driver v3.0
[    5.639906] uhci_hcd 0000:00:04.2: PCI INT D -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
[    5.639926] uhci_hcd 0000:00:04.2: UHCI Host Controller
[    5.640171] uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
[    5.640214] uhci_hcd 0000:00:04.2: irq 9, io base 0x0000d400
[    5.640636] usb usb1: configuration #1 chosen from 1 choice
[    5.640706] hub 1-0:1.0: USB hub found
[    5.640735] hub 1-0:1.0: 2 ports detected
[    5.849622] uhci_hcd 0000:00:04.3: PCI INT D -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
[    5.849650] uhci_hcd 0000:00:04.3: UHCI Host Controller
[    5.849758] uhci_hcd 0000:00:04.3: new USB bus registered, assigned bus number 2
[    5.849799] uhci_hcd 0000:00:04.3: irq 9, io base 0x0000d000
[    5.850233] usb usb2: configuration #1 chosen from 1 choice
[    5.850297] hub 2-0:1.0: USB hub found
[    5.850322] hub 2-0:1.0: 2 ports detected
[    6.056809] uhci_hcd 0000:00:0d.0: PCI INT A -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
[    6.056832] uhci_hcd 0000:00:0d.0: UHCI Host Controller
[    6.056900] uhci_hcd 0000:00:0d.0: new USB bus registered, assigned bus number 3
[    6.056940] uhci_hcd 0000:00:0d.0: irq 9, io base 0x00009000
[    6.057329] usb usb3: configuration #1 chosen from 1 choice
[    6.057396] hub 3-0:1.0: USB hub found
[    6.057421] hub 3-0:1.0: 2 ports detected
[    6.168164] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    6.264778] uhci_hcd 0000:00:0d.1: PCI INT B -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    6.264801] uhci_hcd 0000:00:0d.1: UHCI Host Controller
[    6.264869] uhci_hcd 0000:00:0d.1: new USB bus registered, assigned bus number 4
[    6.264910] uhci_hcd 0000:00:0d.1: irq 11, io base 0x00008800
[    6.265289] usb usb4: configuration #1 chosen from 1 choice
[    6.265355] hub 4-0:1.0: USB hub found
[    6.265384] hub 4-0:1.0: 2 ports detected
[    6.334247] usb 2-2: configuration #1 chosen from 1 choice
[    6.335986] hub 2-2:1.0: USB hub found
[    6.337894] hub 2-2:1.0: 4 ports detected
[    6.472804] ehci_hcd 0000:00:0d.2: PCI INT C -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[    6.472835] ehci_hcd 0000:00:0d.2: EHCI Host Controller
[    6.472904] ehci_hcd 0000:00:0d.2: new USB bus registered, assigned bus number 5
[    6.472991] ehci_hcd 0000:00:0d.2: irq 10, io mem 0xe1000000
[    6.484097] ehci_hcd 0000:00:0d.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    6.484508] usb usb5: configuration #1 chosen from 1 choice
[    6.484599] hub 5-0:1.0: USB hub found
[    6.484625] hub 5-0:1.0: 4 ports detected
[    6.596262] pata_pdc202xx_old 0000:00:11.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[    6.601095] scsi0 : pata_pdc202xx_old
[    6.601478] scsi1 : pata_pdc202xx_old
[    6.601566] ata1: PATA max UDMA/100 cmd 0x8400 ctl 0x8000 bmdma 0x7000 irq 10
[    6.601573] ata2: PATA max UDMA/100 cmd 0x7800 ctl 0x7400 bmdma 0x7008 irq 10
[    6.764700] ata1.00: ATA-4: QUANTUM FIREBALL CX13.0A, A3F.0B00, max UDMA/66
[    6.764711] ata1.00: 25429824 sectors, multi 16: LBA 
[    6.764742] ata1.00: limited to UDMA/33 due to 40-wire cable
[    6.780633] ata1.00: configured for UDMA/33
[    6.908403] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011066645555ead]
[    7.563172] scsi 0:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A3F. PQ: 0 ANSI: 5
[    7.572736] pata_via 0000:00:04.1: version 0.3.3
[    7.573864] scsi2 : pata_via
[    7.574105] scsi3 : pata_via
[    7.575268] ata3: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xd800 irq 14
[    7.575278] ata4: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xd808 irq 15
[    7.603620] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    7.647415] Driver 'sd' needs updating - please use bus_type methods
[    7.647699] sd 0:0:0:0: [sda] 25429824 512-byte hardware sectors (13020 MB)
[    7.647739] sd 0:0:0:0: [sda] Write Protect is off
[    7.647746] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.647806] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.647977] sd 0:0:0:0: [sda] 25429824 512-byte hardware sectors (13020 MB)
[    7.648099] sd 0:0:0:0: [sda] Write Protect is off
[    7.648105] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.648171] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.648183]  sda: sda1 sda2 <Marking TSC unstable due to TSC halts in idle
[    7.684853]  sda5 >
[    7.685287] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.736331] ata3.00: ATAPI: HL-DT-ST DVDRAM GSA-4160B, A306, max UDMA/66
[    7.752267] ata3.00: configured for UDMA/66
[    7.916361] ata4.00: ATAPI: CREATIVE CD5230E, C1.01, max MWDMA2
[    7.924287] ata4.00: configured for MWDMA2
[    7.928186] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4160B A306 PQ: 0 ANSI: 5
[    7.929311] scsi 2:0:0:0: Attached scsi generic sg1 type 5
[    7.931396] scsi 3:0:0:0: CD-ROM            CREATIVE CD5230E          1.01 PQ: 0 ANSI: 5
[    7.931847] scsi 3:0:0:0: Attached scsi generic sg2 type 5
[    8.067355] Driver 'sr' needs updating - please use bus_type methods
[    8.081595] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    8.081608] Uniform CD-ROM driver Revision: 3.20
[    8.081853] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    8.085161] sr1: scsi3-mmc drive: 0x/52x cd/rw xa/form2 cdda tray
[    8.085419] sr 3:0:0:0: Attached scsi CD-ROM sr1
[    8.534715] PM: Starting manual resume from disk
[    8.534729] PM: Resume from partition 8:5
[    8.534733] PM: Checking hibernation image.
[    8.535247] PM: Resume from disk failed.
[    8.586541] EXT3-fs: INFO: recovery required on readonly filesystem.
[    8.586551] EXT3-fs: write access will be enabled during recovery.
[    8.861821] kjournald starting.  Commit interval 5 seconds
[    8.861867] EXT3-fs: recovery complete.
[    8.872729] EXT3-fs: mounted filesystem with ordered data mode.
[   19.648753] udevd version 124 started
[   21.485339] Linux agpgart interface v0.103
[   21.836447] agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
[   21.841619] agpgart-via 0000:00:00.0: AGP aperture is 32M @ 0xe6000000
[   21.924428] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   22.004489] parport_pc: VIA 686A/8231 detected
[   22.004497] parport_pc: probing current configuration
[   22.004517] parport_pc: Current parallel port base: 0x378
[   22.004594] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[   22.100280] parport_pc: VIA parallel port: io=0x378, irq=7
[   22.266742] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   22.353567] ACPI: I/O resource vt596_smbus [0xe800-0xe807] conflicts with ACPI region SM00 [0xe800-0xe806]
[   22.353579] ACPI: Device needs an ACPI driver
[   22.692437] via686a 0000:00:04.4: Sensors disabled, enable with force_addr=0xe200
[   22.944622] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   22.956597] ACPI: Power Button (FF) [PWRF]
[   22.956922] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[   22.975502] ACPI: Power Button (CM) [PWRB]
[   23.772430] Driver for 1-wire Dallas network protocol.
[   23.912118] matrox_w1 0000:01:00.0: Matrox G400 GPIO transport layer for 1-wire.
[   26.354879] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   26.685658] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 5
[   26.685670] PCI: setting IRQ 5 as level-triggered
[   26.685681] ENS1371 0000:00:0a.0: PCI INT A -> Link[LNKC] -> GSI 5 (level, low) -> IRQ 5
[   27.010477] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
[   32.634809] lp0: using parport0 (interrupt-driven).
[   32.975798] Adding 578300k swap on /dev/sda5.  Priority:-1 extents:1 across:578300k
[   33.631980] EXT3 FS on sda1, internal journal
[   35.131415] type=1505 audit(1240206220.754:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=3840
[   35.620313] type=1505 audit(1240206221.246:3): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=3845
[   35.621177] type=1505 audit(1240206221.246:4): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=3845
[   35.885678] ip_tables: (C) 2000-2006 Netfilter Core Team
[   37.836238] ACPI: WMI: Mapper loaded
[   40.016509] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   40.149297] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   40.149312] apm: overridden by ACPI.
[   40.423183] ppdev: user-space parallel port driver
[   43.377269] Bluetooth: Core ver 2.13
[   43.381449] NET: Registered protocol family 31
[   43.381461] Bluetooth: HCI device and connection manager initialized
[   43.381469] Bluetooth: HCI socket layer initialized
[   43.445015] Bluetooth: L2CAP ver 2.11
[   43.445027] Bluetooth: L2CAP socket layer initialized
[   43.469147] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   43.469160] Bluetooth: BNEP filters: protocol multicast
[   43.530784] Bridge firewalling registered
[   43.563298] Bluetooth: SCO (Voice Link) ver 0.6
[   43.563311] Bluetooth: SCO socket layer initialized
[   43.614114] Bluetooth: RFCOMM socket layer initialized
[   43.614750] Bluetooth: RFCOMM TTY layer initialized
[   43.614769] Bluetooth: RFCOMM ver 1.10
[   47.872800] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   48.215997] NET: Registered protocol family 17
[   50.408613] NET: Registered protocol family 10
[   50.410304] lo: Disabled Privacy Extensions
[   54.190994] [drm] Initialized drm 1.1.0 20060810
[   54.224680] matrox_w1 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[   54.226987] [drm] Initialized mga 3.2.1 20051102 on minor 0
[   54.230213] agpgart-via 0000:00:00.0: AGP 2.0 bridge
[   54.230267] agpgart-via 0000:00:00.0: putting AGP V2 device into 4x mode
[   54.230346] matrox_w1 0000:01:00.0: putting AGP V2 device into 4x mode
[   54.394749] [drm] Initialized card for AGP DMA.
[   61.132050] eth0: no IPv6 routers present
[   82.048531] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[   82.048548] ata1.00: BMDMA stat 0x4
[   82.048563] ata1.00: cmd c8/00:00:5f:9e:f6/00:00:00:00:00/e0 tag 0 dma 131072 in
[   82.048567]          res 51/84:00:5e:9f:f6/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
[   82.048574] ata1.00: status: { DRDY ERR }
[   82.048579] ata1.00: error: { ICRC ABRT }
[   82.048607] ata1: soft resetting link
[   82.228457] ata1.00: configured for UDMA/33
[   82.228494] ata1: EH complete
[   82.248586] sd 0:0:0:0: [sda] 25429824 512-byte hardware sectors (13020 MB)
[   82.249335] sd 0:0:0:0: [sda] Write Protect is off
[   82.249350] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   82.250199] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   94.419694] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[   94.419713] ata1.00: BMDMA stat 0x4
[   94.419727] ata1.00: cmd c8/00:08:b7:d3:e6/00:00:00:00:00/e0 tag 0 dma 4096 in
[   94.419730]          res 51/84:00:be:d3:e6/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
[   94.419738] ata1.00: status: { DRDY ERR }
[   94.419743] ata1.00: error: { ICRC ABRT }
[   94.419770] ata1: soft resetting link
[   94.591544] ata1.00: configured for UDMA/33
[   94.591590] ata1: EH complete
[   94.598347] sd 0:0:0:0: [sda] 25429824 512-byte hardware sectors (13020 MB)
[   94.606879] sd 0:0:0:0: [sda] Write Protect is off
[   94.606897] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   94.607929] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  175.060580] ppdev0: registered pardevice
[  175.108608] ppdev0: unregistered pardevice
[  176.500239] ppdev0: registered pardevice
[  176.548075] ppdev0: unregistered pardevice
[  178.176484] ppdev0: registered pardevice
[  178.224825] ppdev0: unregistered pardevice
[ 1115.090911] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[ 1115.090928] ata1.00: BMDMA stat 0x4
[ 1115.090943] ata1.00: cmd ca/00:00:a7:6d:19/00:00:00:00:00/e0 tag 0 dma 131072 out
[ 1115.090947]          res 51/84:00:a6:6e:19/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
[ 1115.090955] ata1.00: status: { DRDY ERR }
[ 1115.090960] ata1.00: error: { ICRC ABRT }
[ 1115.090985] ata1: soft resetting link
[ 1115.268520] ata1.00: configured for UDMA/33
[ 1115.268566] ata1: EH complete
[ 1115.276740] sd 0:0:0:0: [sda] 25429824 512-byte hardware sectors (13020 MB)
[ 1115.278856] sd 0:0:0:0: [sda] Write Protect is off
[ 1115.278874] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1115.286662] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1421.998585] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[ 1421.998602] ata1.00: BMDMA stat 0x4
[ 1421.998617] ata1.00: cmd ca/00:08:77:8d:d7/00:00:00:00:00/e0 tag 0 dma 4096 out
[ 1421.998621]          res 51/84:00:7e:8d:d7/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
[ 1421.998629] ata1.00: status: { DRDY ERR }
[ 1421.998633] ata1.00: error: { ICRC ABRT }
[ 1421.998661] ata1: soft resetting link
[ 1422.288427] ata1.00: configured for UDMA/33
[ 1422.288460] ata1: EH complete
[ 1422.289509] sd 0:0:0:0: [sda] 25429824 512-byte hardware sectors (13020 MB)
[ 1422.290149] sd 0:0:0:0: [sda] Write Protect is off
[ 1422.290171] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1422.291549] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--tThc/1wpZn/ma/RB--
