Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYE1JvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYE1JvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYE1Jux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:50:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57168 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYE1Jur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lIYY/QKuL2CIeY6Ps7UDy1/6Ox1FXdZcQkrpDKj1ITqcZ9ES4ua/7nRWJEKE+Fr6g0hAEZ1f6BWDY56AuelUWS9W1lTcmCfQkmxCnHpyH/1odm6llnnUZDETwgIhRw1JDqldO6avauPZaIRfLIn5EvxWOpYn4QPad2AYY3VVHUM=
Subject: two different oopses with 2.6.26-rc4
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 28 May 2008 11:50:34 +0200
Message-Id: <1211968234.9895.7.camel@Varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent this to the list with other mail address and it didn't reach it
afaics. apologies if someone sees this twice

i cced wireless becouse of the first oops

First boot into 2.6.26-rc4 

  Compiled and booting into 2.6.26-rc4

 1) With splash quiet on grub line it doesn't boot (or i didin't wait long
    enough)
 2) without quiet and splash I get into VT X filas becouse i use the evil
    nvidia driver that's expected. But ubuntu failsafe mode (xserver with vesa
    in low res) doesn't show up either *regression*
 3) i get an oops with network manager
 4) if i try to run some sudo command it gets stuck (Crtl +C doesnt' help)
    "ip route" gets stuck too. User programs i tried wrok fine (only ls and
    htop). Network realted problem?

 5) printk times on dmesg go crazy

But the second time a boot into it i got a working system (i even compiled the
*famous* nvidia driver) with only a bluetooth related oops ...

Both dmesg follow. This is on a hardy 8.04 64 bits system. If more info is needed
just ask

No working first one
[    0.000000] Linux version 2.6.26-rc4 (alex@Varda) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #28 SMP PREEMPT Mon May 26 21:46:39 CEST 2008
[    0.000000] Command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.26-rc4 root=UUID=ee465ea1-394d-4dd2-a5f9-a35567176c40 ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffc0000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 786352) 1 entries of 256 used
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F90F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFB0000, 0040 (r1 A M I  OEMRSDT   3000715 MSFT       97)
[    0.000000] ACPI: FACP BFFB0200, 0084 (r2 A M I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT BFFB0440, 4B5A (r1  AM2ES AM2ES136      136 INTL  2002026)
[    0.000000] ACPI: FACS BFFC0000, 0040
[    0.000000] ACPI: APIC BFFB0390, 0068 (r1 A M I  OEMAPIC   3000715 MSFT       97)
[    0.000000] ACPI: MCFG BFFB0400, 003C (r1 A M I  OEMMCFG   3000715 MSFT       97)
[    0.000000] ACPI: SSDT BFFB4FA0, 002B (r1 OEM_ID OEMTBLID        1 INTL  2002026)
[    0.000000] ACPI: OEMB BFFC0040, 0056 (r1 A M I  AMI_OEM   3000715 MSFT       97)
[    0.000000] ACPI: HPET BFFB4FD0, 0038 (r1 A M I  OEMHPET   3000715 MSFT       97)
[    0.000000] ACPI: SSDT BFFB5010, 01C4 (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 786352) 1 entries of 256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-5b3bcb] TEXT DATA BSS
[    0.000000]   early res: 3 [37c9d000-37fef7af] RAMDISK
[    0.000000]   early res: 4 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-cfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200029fffff] PMD -> [ffff810001200000-ffff810003bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   786352
[    0.000000] On node 0 totalpages: 786255
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1053 pages reserved
[    0.000000]   DMA zone: 2890 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10695 pages used for memmap
[    0.000000]   DMA32 zone: 771561 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 0, address 0xfec10000, GSI 24-44
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3f380000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 33860 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 774451
[4294014.506571] Kernel command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.26-rc4 root=UUID=ee465ea1-394d-4dd2-a5f9-a35567176c40 ro
[4294014.506571] Initializing CPU#0
[4294014.506571] Preemptible RCU implementation.
[4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes)
[4294014.506571] TSC calibrated against PM_TIMER
[4294014.506571] Marking TSC unstable due to TSCs unsynchronized
[4294014.506571] time.c: Detected 1999.978 MHz processor.
[4294014.506571] Console: colour VGA+ 80x25
[4294014.506571] console [tty0] enabled
[4294014.506571] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[4294014.506571] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[4294014.506571] Checking aperture...
[4294014.506571] Node 0: aperture @ b52a000000 size 32 MB
[4294014.506571] Aperture beyond 4GB. Ignoring.
[4294014.506571] No AGP bridge found
[4294014.506571] Memory: 3087728k/3145408k available (2085k kernel code, 56648k reserved, 948k data, 240k init)
[4294014.506571] CPA: page pool initialized 1 of 1 pages preallocated
[4294014.506571] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[4294014.506571] hpet clockevent registered
[4294014.566574] Calibrating delay using timer specific routine.. 4002.04 BogoMIPS (lpj=2001023)
[4294014.566704] Mount-cache hash table entries: 256
[4294014.566890] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[4294014.566954] CPU: L2 Cache: 512K (64 bytes/line)
[4294014.567014] CPU: Physical Processor ID: 0
[4294014.567066] CPU: Processor Core ID: 0
[4294014.567137] ACPI: Core revision 20080321
[4294014.583931] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[4294014.584076] Using local APIC timer interrupts.
[4294014.585558] APIC timer calibration result 12499860
[4294014.585558] Detected 12.499 MHz APIC timer.
[4294014.585558] Booting processor 1/1 ip 6000
[4294014.595452] Initializing CPU#1
[4294014.595452] Calibrating delay using timer specific routine.. 3999.78 BogoMIPS (lpj=1999890)
[4294014.595452] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[4294014.595452] CPU: L2 Cache: 512K (64 bytes/line)
[4294014.595452] CPU: Physical Processor ID: 0
[4294014.595452] CPU: Processor Core ID: 1
[4294014.595452] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[4294014.656548] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[4294014.656548] Brought up 2 CPUs
[4294014.656548] Total of 2 processors activated (8001.82 BogoMIPS).
[4294014.656723] CPU0 attaching sched-domain:
[4294014.656726]  domain 0: span 0-1
[4294014.656728]   groups: 0 1
[4294014.656732] CPU1 attaching sched-domain:
[4294014.656734]  domain 0: span 0-1
[4294014.656736]   groups: 1 0
[4294014.657547] net_namespace: 1176 bytes
[4294014.657547] NET: Registered protocol family 16
[4294014.657547] No dock devices found.
[4294014.657547] node 0 link 0: io port [1000, ffffff]
[4294014.657547] TOM: 00000000c0000000 aka 3072M
[4294014.657604] node 0 link 0: mmio [e0000000, efffffff]
[4294014.657608] node 0 link 0: mmio [a0000, bffff]
[4294014.657611] node 0 link 0: mmio [c0000000, ffffffff]
[4294014.657614] bus: [00,ff] on node 0 link 0
[4294014.657617] bus: 00 index 0 io port: [0, ffff]
[4294014.657619] bus: 00 index 1 mmio: [c0000000, fcffffffff]
[4294014.657622] bus: 00 index 2 mmio: [a0000, bffff]
[4294014.657627] ACPI: bus type pci registered
[4294014.658547] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.658547] PCI: Not using MMCONFIG.
[4294014.658547] PCI: Using configuration type 1 for base access
[4294014.659553] ACPI: EC: Look up EC in DSDT
[4294014.667938] ACPI: Interpreter enabled
[4294014.667993] ACPI: (supports S0 S1 S3 S5)
[4294014.668546] ACPI: Using IOAPIC for interrupt routing
[4294014.668650] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.673061] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[4294014.684031] PCI: Using MMCONFIG at e0000000 - efffffff
[4294014.692877] ACPI: PCI Root Bridge [PCI0] (0000:00)
[4294014.692877] pci 0000:00:15.1: quirk: region 4000-403f claimed by ali7101 ACPI
[4294014.693876] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[4294014.694027] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE2P._PRT]
[4294014.694199] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
[4294014.694294] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
[4294014.694373] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
[4294014.694471] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB4._PRT]
[4294014.706371] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.706371] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[4294014.707371] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.708080] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.708791] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[4294014.709499] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 6 *10 11 12 14 15)
[4294014.710079] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.710784] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[4294014.711533] ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.712659] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 52, should be 25 [20080321]
[4294014.712659] Linux Plug and Play Support v0.97 (c) Adam Belay
[4294014.712659] pnp: PnP ACPI init
[4294014.712659] ACPI: bus type pnp registered
[4294014.717658] pnp: PnP ACPI: found 16 devices
[4294014.717716] ACPI: ACPI bus type pnp unregistered
[4294014.718658] SCSI subsystem initialized
[4294014.718658] libata version 3.00 loaded.
[4294014.718658] PCI: Using ACPI for IRQ routing
[4294014.728015] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[4294014.728015] hpet0: 3 64-bit timers, 14318180 Hz
[4294014.729015] ACPI: RTC can wake from S4
[4294014.729567] Switched to high resolution mode on CPU 0
[4294014.730356] Switched to high resolution mode on CPU 1
[4294014.738610] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[4294014.738667] system 00:08: ioport range 0x4000-0x40bf could not be reserved
[4294014.738724] system 00:08: ioport range 0x40c0-0x40df has been reserved
[4294014.738779] system 00:08: ioport range 0x400-0x40f has been reserved
[4294014.738835] system 00:08: ioport range 0x480-0x48f has been reserved
[4294014.738892] system 00:08: iomem range 0xfff80000-0xffffffff could not be reserved
[4294014.739342] system 00:08: iomem range 0xfec10000-0xfec10fff has been reserved
[4294014.739407] system 00:08: iomem range 0xfe000000-0xfe0000ff has been reserved
[4294014.739441] system 00:0a: iomem range 0xff380000-0xffffffff could not be reserved
[4294014.739441] system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
[4294014.739441] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
[4294014.739441] system 00:0d: ioport range 0x290-0x29f has been reserved
[4294014.739441] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[4294014.739441] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[4294014.739441] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[4294014.739441] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[4294014.739504] system 00:0f: iomem range 0x100000-0xbfffffff could not be reserved
[4294014.739568] system 00:0f: iomem range 0x0-0xffffffffffffffff could not be reserved
[4294014.740442] PCI: Bridge: 0000:00:01.0
[4294014.740442]   IO window: d000-dfff
[4294014.740442]   MEM window: 0xdc000000-0xdeefffff
[4294014.740442]   PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
[4294014.740442] PCI: Bridge: 0000:00:02.0
[4294014.745016]   IO window: disabled.
[4294014.745074]   MEM window: disabled.
[4294014.745127]   PREFETCH window: 0x00000000dad00000-0x00000000dadfffff
[4294014.745184] PCI: Bridge: 0000:00:03.0
[4294014.745236]   IO window: disabled.
[4294014.745289]   MEM window: disabled.
[4294014.746037]   PREFETCH window: 0x00000000dae00000-0x00000000daefffff
[4294014.746037] PCI: Bridge: 0000:00:04.0
[4294014.746037]   IO window: disabled.
[4294014.746037]   MEM window: disabled.
[4294014.746037]   PREFETCH window: 0x00000000daf00000-0x00000000daffffff
[4294014.746037] PCI: Bridge: 0000:00:11.0
[4294014.746037]   IO window: e000-efff
[4294014.746037]   MEM window: 0xdef00000-0xdeffffff
[4294014.746037]   PREFETCH window: disabled.
[4294014.746037] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 29 (level, low) -> IRQ 29
[4294014.746037] PCI: Setting latency timer of device 0000:00:01.0 to 64
[4294014.746037] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 34 (level, low) -> IRQ 34
[4294014.746042] PCI: Setting latency timer of device 0000:00:02.0 to 64
[4294014.746050] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 39 (level, low) -> IRQ 39
[4294014.746155] PCI: Setting latency timer of device 0000:00:03.0 to 64
[4294014.746163] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 44 (level, low) -> IRQ 44
[4294014.747032] PCI: Setting latency timer of device 0000:00:04.0 to 64
[4294014.747032] PCI: Setting latency timer of device 0000:00:11.0 to 64
[4294014.747032] NET: Registered protocol family 2
[4294014.779077] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[4294014.780173] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[4294014.783019] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[4294014.784018] TCP: Hash tables configured (established 262144 bind 65536)
[4294014.784018] TCP reno registered
[4294014.795187] checking if image is initramfs... it is
[4294015.059017] Freeing initrd memory: 3401k freed
[4294015.066019] JFS: nTxBlock = 8192, nTxLock = 65536
[4294015.069406] msgmni has been set to 6038 for ipc namespace ffffffff804de850
[4294015.069406] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[4294015.069406] io scheduler noop registered
[4294015.070018] io scheduler cfq registered (default)
[4294015.070018] pci 0000:00:00.0: Enabling HT MSI Mapping
[4294015.070018] pci 0000:00:01.0: Enabling HT MSI Mapping
[4294015.070018] pci 0000:00:02.0: Enabling HT MSI Mapping
[4294015.070082] pci 0000:00:03.0: Enabling HT MSI Mapping
[4294015.070082] pci 0000:00:04.0: Enabling HT MSI Mapping
[4294015.104083] pci 0000:01:00.0: Boot video device
[4294015.105016] PCI: Setting latency timer of device 0000:00:01.0 to 64
[4294015.105016] assign_interrupt_mode Found MSI capability
[4294015.105090] Allocate Port Service[0000:00:01.0:pcie00]
[4294015.105090] Allocate Port Service[0000:00:01.0:pcie01]
[4294015.105090] Allocate Port Service[0000:00:01.0:pcie03]
[4294015.105090] PCI: Setting latency timer of device 0000:00:02.0 to 64
[4294015.105090] assign_interrupt_mode Found MSI capability
[4294015.105090] Allocate Port Service[0000:00:02.0:pcie00]
[4294015.105090] Allocate Port Service[0000:00:02.0:pcie01]
[4294015.105090] Allocate Port Service[0000:00:02.0:pcie03]
[4294015.105090] PCI: Setting latency timer of device 0000:00:03.0 to 64
[4294015.105090] assign_interrupt_mode Found MSI capability
[4294015.105090] Allocate Port Service[0000:00:03.0:pcie00]
[4294015.105090] Allocate Port Service[0000:00:03.0:pcie01]
[4294015.105090] Allocate Port Service[0000:00:03.0:pcie03]
[4294015.105090] PCI: Setting latency timer of device 0000:00:04.0 to 64
[4294015.105104] assign_interrupt_mode Found MSI capability
[4294015.105174] Allocate Port Service[0000:00:04.0:pcie00]
[4294015.106014] Allocate Port Service[0000:00:04.0:pcie01]
[4294015.106014] Allocate Port Service[0000:00:04.0:pcie03]
[4294015.108514] Load service driver aer on pcie device 0000:00:01.0:pcie01
[4294015.110514] Load service driver aer on pcie device 0000:00:02.0:pcie01
[4294015.113514] Load service driver aer on pcie device 0000:00:03.0:pcie01
[4294015.115514] Load service driver aer on pcie device 0000:00:04.0:pcie01
[4294015.118550] hpet_resources: 0xfed00000 is busy
[4294015.119520] Linux agpgart interface v0.103
[4294015.120538] brd: module loaded
[4294015.120538] Driver 'sd' needs updating - please use bus_type methods
[4294015.120538] ahci 0000:00:16.1: version 3.0
[4294015.120538] ACPI: PCI Interrupt 0000:00:16.1[A] -> GSI 21 (level, low) -> IRQ 21
[4294016.124541] ahci 0000:00:16.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[4294016.124607] ahci 0000:00:16.1: flags: ncq sntf ilck pm led clo pmp pio slum part 
[4294016.125516] scsi0 : ahci
[4294016.125516] scsi1 : ahci
[4294016.125516] scsi2 : ahci
[4294016.126559] scsi3 : ahci
[4294016.126559] ata1: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef500 irq 21
[4294016.126559] ata2: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef580 irq 21
[4294016.126559] ata3: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef600 irq 21
[4294016.126559] ata4: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef680 irq 21
[4294016.430541] ata1: SATA link down (SStatus 0 SControl 300)
[4294016.735540] ata2: SATA link down (SStatus 0 SControl 300)
[4294017.040539] ata3: SATA link down (SStatus 0 SControl 300)
[4294017.498539] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[4294017.536523] ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[4294017.536523] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[4294017.546522] ata4.00: configured for UDMA/133
[4294017.513572] isa bounce pool size: 16 pages
[4294017.513572] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[4294017.596571] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[4294017.596571] sd 3:0:0:0: [sda] Write Protect is off
[4294017.596571] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.596571] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.596571] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[4294017.596571] sd 3:0:0:0: [sda] Write Protect is off
[4294017.596571] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.596571] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.596571]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[4294017.634905] sd 3:0:0:0: [sda] Attached SCSI disk
[4294017.666026] ACPI: PCI Interrupt 0000:00:16.0[A] -> GSI 21 (level, low) -> IRQ 21
[4294017.666734] scsi4 : pata_ali
[4294017.666909] scsi5 : pata_ali
[4294017.668759] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[4294017.668816] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[4294017.994508] ata5.00: ATA-6: ST3160021A, 8.01, max UDMA/100
[4294017.994508] ata5.00: 312581808 sectors, multi 16: LBA48 
[4294017.994508] ata5.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[4294017.994508] ata5.01: 160086528 sectors, multi 16: LBA 
[4294018.000153] ata5.00: configured for UDMA/100
[4294018.006114] ata5.01: configured for UDMA/133
[4294018.171069] ata6.00: ATAPI: _NEC DVD_RW ND-3540A, 1.01, max UDMA/33
[4294018.171131] ata6.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled
[4294018.171196] ata6.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
[4294018.177007] ata6.00: configured for UDMA/33
[4294018.177007] scsi 4:0:0:0: Direct-Access     ATA      ST3160021A       8.01 PQ: 0 ANSI: 5
[4294018.177007] sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
[4294018.177007] sd 4:0:0:0: [sdb] Write Protect is off
[4294018.177007] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[4294018.177007] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.177007] sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
[4294018.177007] sd 4:0:0:0: [sdb] Write Protect is off
[4294018.177007] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[4294018.177007] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.177007]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
[4294018.229068] sd 4:0:0:0: [sdb] Attached SCSI disk
[4294018.229068] scsi 4:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
[4294018.229103] sd 4:0:1:0: [sdc] 160086528 512-byte hardware sectors (81964 MB)
[4294018.229179] sd 4:0:1:0: [sdc] Write Protect is off
[4294018.229234] sd 4:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[4294018.229259] sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.229366] sd 4:0:1:0: [sdc] 160086528 512-byte hardware sectors (81964 MB)
[4294018.229441] sd 4:0:1:0: [sdc] Write Protect is off
[4294018.229495] sd 4:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[4294018.229521] sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.229587]  sdc: sdc1 sdc2 sdc3
[4294018.238707] sd 4:0:1:0: [sdc] Attached SCSI disk
[4294018.240511] scsi 5:0:0:0: CD-ROM            _NEC     DVD_RW ND-3540A  1.01 PQ: 0 ANSI: 5
[4294018.241510] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[4294018.241510] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[4294018.241959] serio: i8042 KBD port at 0x60,0x64 irq 1
[4294018.242510] mice: PS/2 mouse device common for all mice
[4294018.253516] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[4294018.278512] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[4294018.278512] rtc0: alarms up to one month
[4294018.278512] cpuidle: using governor ladder
[4294018.278512] cpuidle: using governor menu
[4294018.278512] TCP cubic registered
[4294018.278512] ieee80211: 802.11 data/management/control stack, git-1.1.13
[4294018.278512] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[4294018.278512] ieee80211_crypt: registered algorithm 'NULL'
[4294018.279511] rtc_cmos 00:02: setting system clock to 2008-05-27 10:20:09 UTC (1211883609)
[4294018.279511] Freeing unused kernel memory: 240k freed
[4294018.279511] Write protecting the kernel read-only data: 2828k
[4294018.422411] fuse init (API version 7.9)
[4294018.432629] ACPI: duty_cycle spans bit 4
[4294018.432629] ACPI: ACPI0007:00 is registered as cooling_device0
[4294018.432629] ACPI: ACPI0007:01 is registered as cooling_device1
[4294018.438341] NET: Registered protocol family 1
[4294018.568755] usbcore: registered new interface driver usbfs
[4294018.568755] usbcore: registered new interface driver hub
[4294018.568755] usbcore: registered new device driver usb
[4294018.569759] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[4294018.569759] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 17 (level, low) -> IRQ 17
[4294018.569759] ohci_hcd 0000:00:13.0: OHCI Host Controller
[4294018.569759] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[4294018.573833] ohci_hcd 0000:00:13.0: irq 17, io mem 0xdbfee000
[4294018.610580] sd 3:0:0:0: Attached scsi generic sg0 type 0
[4294018.610580] sd 4:0:0:0: Attached scsi generic sg1 type 0
[4294018.610580] sd 4:0:1:0: Attached scsi generic sg2 type 0
[4294018.610580] scsi 5:0:0:0: Attached scsi generic sg3 type 5
[4294018.631760] usb usb1: configuration #1 chosen from 1 choice
[4294018.631851] hub 1-0:1.0: USB hub found
[4294018.631914] hub 1-0:1.0: 3 ports detected
[4294018.673461] Floppy drive(s): fd0 is 1.44M
[4294018.689459] FDC 0 is a post-1991 82077
[4294018.734789] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 18 (level, low) -> IRQ 18
[4294018.734789] ohci_hcd 0000:00:13.1: OHCI Host Controller
[4294018.734789] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
[4294018.734789] ohci_hcd 0000:00:13.1: irq 18, io mem 0xdbfed000
[4294018.788411] usb usb2: configuration #1 chosen from 1 choice
[4294018.788411] hub 2-0:1.0: USB hub found
[4294018.788411] hub 2-0:1.0: 3 ports detected
[4294018.890422] ACPI: PCI Interrupt 0000:00:13.3[D] -> GSI 23 (level, low) -> IRQ 23
[4294018.890422] ehci_hcd 0000:00:13.3: EHCI Host Controller
[4294018.890435] ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 3
[4294018.910481] ehci_hcd 0000:00:13.3: debug port 1
[4294018.910557] ehci_hcd 0000:00:13.3: irq 23, io mem 0xdbfef800
[4294018.953035] usb 1-2: new low speed USB device using ohci_hcd and address 2
[4294018.959020] ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[4294018.959189] usb usb3: configuration #1 chosen from 1 choice
[4294018.959274] hub 3-0:1.0: USB hub found
[4294018.959334] hub 3-0:1.0: 8 ports detected
[4294019.011792] hub 1-0:1.0: unable to enumerate USB device on port 2
[4294019.045812] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 19 (level, low) -> IRQ 19
[4294019.060825] ohci_hcd 0000:00:13.2: OHCI Host Controller
[4294019.060921] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[4294019.061007] ohci_hcd 0000:00:13.2: irq 19, io mem 0xdbfec000
[4294019.113664] usb usb4: configuration #1 chosen from 1 choice
[4294019.113745] hub 4-0:1.0: USB hub found
[4294019.113813] hub 4-0:1.0: 3 ports detected
[4294019.216565] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[4294019.216642] ACPI: PCI Interrupt 0000:05:0b.0[A] -> GSI 19 (level, low) -> IRQ 19
[4294019.216804] eth0: RTL8110s at 0xffffc20000038c00, 00:4f:63:00:a4:73, XID 04000000 IRQ 19
[4294019.271591] hub 3-0:1.0: unable to enumerate USB device on port 2
[4294019.477582] hub 3-0:1.0: unable to enumerate USB device on port 8
[4294019.695836] usb 4-2: new full speed USB device using ohci_hcd and address 2
[4294019.861668] usb 4-2: configuration #1 chosen from 1 choice
[4294020.092796] usb 1-2: new low speed USB device using ohci_hcd and address 3
[4294020.239781] usb 1-2: configuration #1 chosen from 1 choice
[4294027.076603] ali15x3_smbus 0000:00:15.1: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
[4294027.076683] ali15x3_smbus 0000:00:15.1: ALI15X3 not detected, module not inserted.
[4294027.106267] ali1535_smbus 0000:00:15.1: ALI1535_smb region uninitialized - upgrade BIOS?
[4294027.106337] ali1535_smbus 0000:00:15.1: ALI1535 not detected, module not inserted.
[4294027.116049] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[4294027.116173] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 20 (level, low) -> IRQ 20
[4294027.120047] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[4294027.129714] ACPI: Power Button (FF) [PWRF]
[4294027.130050] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[4294027.138078] ACPI: Power Button (CM) [PWRB]
[4294027.139541] eth1: ULi M5263 at pci0000:00:12.0, 00:13:8f:b3:14:a4, irq 20.
[4294027.369451] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x1904
[4294027.369561] usbcore: registered new interface driver usblp
[4294027.407263] usbcore: registered new interface driver hiddev
[4294027.413260] input: KYE NetScroll+ Traveler as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2:1.0/input/input3
[4294027.419343] input,hidraw0: USB HID v1.10 Mouse [KYE NetScroll+ Traveler] on usb-0000:00:13.0-2
[4294027.420261] usbcore: registered new interface driver usbhid
[4294027.420261] usbhid: v2.6:USB HID core driver
[4294027.432260] Driver 'sr' needs updating - please use bus_type methods
[4294027.440506] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[4294027.440506] Uniform CD-ROM driver Revision: 3.20
[4294027.440676] sr 5:0:0:0: Attached scsi CD-ROM sr0
[4294027.514403] input: PC Speaker as /devices/platform/pcspkr/input/input4
[4294027.546783] ACPI: PCI Interrupt 0000:05:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
[4294027.562783] phy0: Selected rate control algorithm 'pid'
[4294027.849983] parport_pc 00:06: reported by Plug and Play ACPI
[4294027.849983] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[4294027.855982] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[4294027.855982] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[4294027.936400] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[4294028.014917] udev: renamed network interface eth1 to eth0
[4294028.015077] Registered led device: rt2500pci-phy0:radio
[4294028.017062] ACPI: PCI Interrupt 0000:00:14.0[C] -> GSI 22 (level, low) -> IRQ 22
[4294028.027740] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[4294028.066587] udev: renamed network interface eth0_rename to eth1
[4294028.813021] lp0: using parport0 (interrupt-driven).
[4294028.827532] w83627ehf: Found W83627EHG chip at 0x290
[4294028.988729] Adding 1992020k swap on /dev/sdb7.  Priority:1 extents:1 across:1992020k
[4294029.014313] Adding 1020116k swap on /dev/sdc2.  Priority:1 extents:1 across:1020116k
[4294039.966713] ip_tables: (C) 2000-2006 Netfilter Core Team
[4294041.264835] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[4294042.636604] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (2 cpu cores) (version 2.20.00)
[4294042.637641] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xa
[4294042.637641] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xc
[4294042.637641] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[4294044.445366] NET: Registered protocol family 10
[4294044.447432] lo: Disabled Privacy Extensions
[4294044.675038] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[4294046.349541] Clocksource tsc unstable (delta = -187065313 ns)
[4294050.559251] ADDRCONF(NETDEV_UP): eth0: link is not ready
[4294050.581346] r8169: eth1: link down
[4294050.581525] r8169: eth1: link down
[4294050.584175] ADDRCONF(NETDEV_UP): eth1: link is not ready
[4294050.608562] BUG: scheduling while atomic: NetworkManager/4142/0x00010001
[4294050.608605] CPU 1:
[4294050.608607] Modules linked in: ipv6 container powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative nf_conntrack_ftp nf_conntrack_irc xt_tcpudp ipt_ULOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables kvm_amd kvm w83627ehf hwmon_vid lp arc4 ecb 8250_pnp snd_mpu401 crypto_blkcipher 8250 parport_pc serial_core snd_mpu401_uart parport cryptomgr crypto_algapi evdev snd_hda_intel rt2500pci rt2x00pci snd_pcm_oss rt2x00lib pcspkr snd_mixer_oss k8temp rfkill snd_pcm sr_mod cdrom usbhid led_class ff_memless usblp input_polldev snd_seq_dummy mac80211 snd_seq_oss cfg80211 snd_seq_midi snd_rawmidi eeprom_93cx6 snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc button uli526x i2c_ali1535 i2c_ali15x3 i2c_core floppy sg ata_generic ehci_hcd r8169 ohci_hcd usbcore unix thermal processor fan fuse
[4294050.608666] Pid: 4142, comm: NetworkManager Not tainted 2.6.26-rc4 #28
[4294050.608669] RIP: 0010:[<ffffffffa016b50d>]  [<ffffffffa016b50d>] :rt2500pci:rt2500pci_config_intf+0x43/0x10a
[4294050.608680] RSP: 0018:ffff8100bed898b8  EFLAGS: 00000202
[4294050.608682] RAX: 00000000000000f0 RBX: 000000000000000a RCX: 000000000000ffff
[4294050.608685] RDX: 00000000000500f0 RSI: ffffc2000003c000 RDI: 0000000000000010
[4294050.608687] RBP: 00000000000186d4 R08: ffff8100beb00090 R09: ffff8100bed898d8
[4294050.608690] R10: 0000000000000001 R11: 0000000000000005 R12: 0000000000000016
[4294050.608692] R13: 00000000379cd2d2 R14: 00000000379cd2d2 R15: 00000000000016a1
[4294050.608696] FS:  00007f3905056780(0000) GS:ffff8100bf806580(0000) knlGS:0000000000000000
[4294050.608698] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[4294050.608701] CR2: 0000000000fea000 CR3: 00000000beb44000 CR4: 00000000000006e0
[4294050.608703] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[4294050.608706] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[4294050.608708] 
[4294050.608709] Call Trace:
[4294050.608716]  [<ffffffffa016b4e0>] ? :rt2500pci:rt2500pci_config_intf+0x16/0x10a
[4294050.608728]  [<ffffffffa01547bd>] ? :rt2x00lib:rt2x00lib_config_intf+0xc5/0xca
[4294050.608739]  [<ffffffffa01546b3>] ? :rt2x00lib:rt2x00mac_config_interface+0x5d/0xa2
[4294050.608757]  [<ffffffffa00e82ad>] ? :mac80211:__ieee80211_if_config+0xce/0xd7
[4294050.608775]  [<ffffffffa00ea313>] ? :mac80211:ieee80211_open+0x37b/0x4e4
[4294050.608783]  [<ffffffff803b51aa>] ? __nla_reserve+0x1e/0x47
[4294050.608790]  [<ffffffff8039fbbc>] ? dev_open+0x6c/0xa0
[4294050.608795]  [<ffffffff8039e79e>] ? dev_change_flags+0xa6/0x15d
[4294050.608801]  [<ffffffff803a688a>] ? do_setlink+0x24b/0x315
[4294050.608812]  [<ffffffff803a78f8>] ? rtnl_setlink+0xce/0xe8
[4294050.608828]  [<ffffffff803a7455>] ? rtnetlink_rcv_msg+0x0/0x1d4
[4294050.608832]  [<ffffffff803b3f01>] ? netlink_rcv_skb+0x34/0x7c
[4294050.608837]  [<ffffffff803a744f>] ? rtnetlink_rcv+0x18/0x1e
[4294050.608841]  [<ffffffff803b3ce6>] ? netlink_unicast+0x1fb/0x271
[4294050.608850]  [<ffffffff803b43f5>] ? netlink_sendmsg+0x245/0x258
[4294050.608862]  [<ffffffff80393a19>] ? sock_sendmsg+0xcb/0xe3
[4294050.608873]  [<ffffffff8023f4f8>] ? autoremove_wake_function+0x0/0x2e
[4294050.608891]  [<ffffffffa00ea9a9>] ? :mac80211:ieee80211_ioctl_siwscan+0x0/0x48
[4294050.608898]  [<ffffffff8025b2d9>] ? get_page_from_freelist+0x3d3/0x4c0
[4294050.608908]  [<ffffffff8027a78f>] ? fget_light+0x97/0x9f
[4294050.608912]  [<ffffffff80392cf2>] ? move_addr_to_kernel+0x25/0x36
[4294050.608916]  [<ffffffff8039abe9>] ? verify_iovec+0x46/0x81
[4294050.608921]  [<ffffffff80393c48>] ? sys_sendmsg+0x217/0x28a
[4294050.608938]  [<ffffffff80264a83>] ? handle_mm_fault+0x675/0x68f
[4294050.608946]  [<ffffffff80394952>] ? sys_getsockname+0x8c/0xa2
[4294050.608962]  [<ffffffff8020b1db>] ? system_call_after_swapgs+0x7b/0x80
[4294050.608971] 
[4294050.682615] Bluetooth: Core ver 2.11
[4294050.685810] NET: Registered protocol family 31
[4294050.685810] Bluetooth: HCI device and connection manager initialized
[4294050.685810] Bluetooth: HCI socket layer initialized
[4294050.707155] Bluetooth: L2CAP ver 2.9
[4294050.707233] Bluetooth: L2CAP socket layer initialized
[4294050.724832] Bluetooth: RFCOMM socket layer initialized
[4294050.725555] Bluetooth: RFCOMM TTY layer initialized
[4294050.725632] Bluetooth: RFCOMM ver 1.8
[4294053.632616] uli526x: eth0 NIC Link is Down

Working Second one
[    0.000000] Linux version 2.6.26-rc4 (alex@Varda) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #28 SMP PREEMPT Mon May 26 21:46:39 CEST 2008
[    0.000000] Command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.26-rc4 root=UUID=ee465ea1-394d-4dd2-a5f9-a35567176c40 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffc0000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 786352) 1 entries of 256 used
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F90F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFB0000, 0040 (r1 A M I  OEMRSDT   3000715 MSFT       97)
[    0.000000] ACPI: FACP BFFB0200, 0084 (r2 A M I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT BFFB0440, 4B5A (r1  AM2ES AM2ES136      136 INTL  2002026)
[    0.000000] ACPI: FACS BFFC0000, 0040
[    0.000000] ACPI: APIC BFFB0390, 0068 (r1 A M I  OEMAPIC   3000715 MSFT       97)
[    0.000000] ACPI: MCFG BFFB0400, 003C (r1 A M I  OEMMCFG   3000715 MSFT       97)
[    0.000000] ACPI: SSDT BFFB4FA0, 002B (r1 OEM_ID OEMTBLID        1 INTL  2002026)
[    0.000000] ACPI: OEMB BFFC0040, 0056 (r1 A M I  AMI_OEM   3000715 MSFT       97)
[    0.000000] ACPI: HPET BFFB4FD0, 0038 (r1 A M I  OEMHPET   3000715 MSFT       97)
[    0.000000] ACPI: SSDT BFFB5010, 01C4 (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 786352) 1 entries of 256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-5b3bcb] TEXT DATA BSS
[    0.000000]   early res: 3 [37c9d000-37fef7af] RAMDISK
[    0.000000]   early res: 4 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-cfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200029fffff] PMD -> [ffff810001200000-ffff810003bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   786352
[    0.000000] On node 0 totalpages: 786255
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1053 pages reserved
[    0.000000]   DMA zone: 2890 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10695 pages used for memmap
[    0.000000]   DMA32 zone: 771561 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 0, address 0xfec10000, GSI 24-44
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3f380000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 33860 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 774451
[4294014.506571] Kernel command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.26-rc4 root=UUID=ee465ea1-394d-4dd2-a5f9-a35567176c40 ro quiet splash
[4294014.506571] Initializing CPU#0
[4294014.506571] Preemptible RCU implementation.
[4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes)
[4294014.506571] TSC calibrated against PM_TIMER
[4294014.506571] Marking TSC unstable due to TSCs unsynchronized
[4294014.506571] time.c: Detected 1999.972 MHz processor.
[4294014.506571] Console: colour VGA+ 80x25
[4294014.506571] console [tty0] enabled
[4294014.506571] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[4294014.506571] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[4294014.506571] Checking aperture...
[4294014.506571] Node 0: aperture @ b56a000000 size 32 MB
[4294014.506571] Aperture beyond 4GB. Ignoring.
[4294014.506571] No AGP bridge found
[4294014.506571] Memory: 3087728k/3145408k available (2085k kernel code, 56648k reserved, 948k data, 240k init)
[4294014.506571] CPA: page pool initialized 1 of 1 pages preallocated
[4294014.506571] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[4294014.506571] hpet clockevent registered
[4294014.566574] Calibrating delay using timer specific routine.. 4002.05 BogoMIPS (lpj=2001028)
[4294014.566602] Mount-cache hash table entries: 256
[4294014.566737] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[4294014.566740] CPU: L2 Cache: 512K (64 bytes/line)
[4294014.566749] CPU: Physical Processor ID: 0
[4294014.566751] CPU: Processor Core ID: 0
[4294014.566772] ACPI: Core revision 20080321
[4294014.583515] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[4294014.583519] Using local APIC timer interrupts.
[4294014.584559] APIC timer calibration result 12499834
[4294014.584559] Detected 12.499 MHz APIC timer.
[4294014.584559] Booting processor 1/1 ip 6000
[4294014.594453] Initializing CPU#1
[4294014.594453] Calibrating delay using timer specific routine.. 3999.78 BogoMIPS (lpj=1999893)
[4294014.594453] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[4294014.594453] CPU: L2 Cache: 512K (64 bytes/line)
[4294014.594453] CPU: Physical Processor ID: 0
[4294014.594453] CPU: Processor Core ID: 1
[4294014.594453] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[4294014.655548] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[4294014.655548] Brought up 2 CPUs
[4294014.655548] Total of 2 processors activated (8001.84 BogoMIPS).
[4294014.655548] CPU0 attaching sched-domain:
[4294014.655548]  domain 0: span 0-1
[4294014.655548]   groups: 0 1
[4294014.655548] CPU1 attaching sched-domain:
[4294014.655548]  domain 0: span 0-1
[4294014.655548]   groups: 1 0
[4294014.655548] net_namespace: 1176 bytes
[4294014.655548] NET: Registered protocol family 16
[4294014.656548] No dock devices found.
[4294014.656548] node 0 link 0: io port [1000, ffffff]
[4294014.656548] TOM: 00000000c0000000 aka 3072M
[4294014.656548] node 0 link 0: mmio [e0000000, efffffff]
[4294014.656548] node 0 link 0: mmio [a0000, bffff]
[4294014.656548] node 0 link 0: mmio [c0000000, ffffffff]
[4294014.656548] bus: [00,ff] on node 0 link 0
[4294014.656548] bus: 00 index 0 io port: [0, ffff]
[4294014.656548] bus: 00 index 1 mmio: [c0000000, fcffffffff]
[4294014.656548] bus: 00 index 2 mmio: [a0000, bffff]
[4294014.656548] ACPI: bus type pci registered
[4294014.656548] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.656548] PCI: Not using MMCONFIG.
[4294014.656548] PCI: Using configuration type 1 for base access
[4294014.658149] ACPI: EC: Look up EC in DSDT
[4294014.666546] ACPI: Interpreter enabled
[4294014.666546] ACPI: (supports S0 S1 S3 S5)
[4294014.666546] ACPI: Using IOAPIC for interrupt routing
[4294014.666546] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.670545] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[4294014.680931] PCI: Using MMCONFIG at e0000000 - efffffff
[4294014.689543] ACPI: PCI Root Bridge [PCI0] (0000:00)
[4294014.690002] pci 0000:00:15.1: quirk: region 4000-403f claimed by ali7101 ACPI
[4294014.690532] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[4294014.690634] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE2P._PRT]
[4294014.690634] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
[4294014.690735] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
[4294014.690831] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
[4294014.690927] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB4._PRT]
[4294014.702633] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.702633] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[4294014.702633] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.702633] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.702804] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[4294014.702971] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 6 *10 11 12 14 15)
[4294014.703135] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.703297] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[4294014.703463] ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[4294014.703715] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 52, should be 25 [20080321]
[4294014.703733] Linux Plug and Play Support v0.97 (c) Adam Belay
[4294014.704632] pnp: PnP ACPI init
[4294014.704632] ACPI: bus type pnp registered
[4294014.708981] pnp: PnP ACPI: found 16 devices
[4294014.708984] ACPI: ACPI bus type pnp unregistered
[4294014.709632] SCSI subsystem initialized
[4294014.709632] libata version 3.00 loaded.
[4294014.709632] PCI: Using ACPI for IRQ routing
[4294014.719989] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[4294014.719989] hpet0: 3 64-bit timers, 14318180 Hz
[4294014.720989] ACPI: RTC can wake from S4
[4294014.721854] Switched to high resolution mode on CPU 0
[4294014.722329] Switched to high resolution mode on CPU 1
[4294014.730896] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[4294014.730900] system 00:08: ioport range 0x4000-0x40bf could not be reserved
[4294014.730903] system 00:08: ioport range 0x40c0-0x40df has been reserved
[4294014.730906] system 00:08: ioport range 0x400-0x40f has been reserved
[4294014.730910] system 00:08: ioport range 0x480-0x48f has been reserved
[4294014.730914] system 00:08: iomem range 0xfff80000-0xffffffff could not be reserved
[4294014.730917] system 00:08: iomem range 0xfec10000-0xfec10fff has been reserved
[4294014.730920] system 00:08: iomem range 0xfe000000-0xfe0000ff has been reserved
[4294014.730930] system 00:0a: iomem range 0xff380000-0xffffffff could not be reserved
[4294014.730933] system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
[4294014.730936] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
[4294014.730944] system 00:0d: ioport range 0x290-0x29f has been reserved
[4294014.730954] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[4294014.730964] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[4294014.730967] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[4294014.730970] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[4294014.730973] system 00:0f: iomem range 0x100000-0xbfffffff could not be reserved
[4294014.730977] system 00:0f: iomem range 0x0-0xffffffffffffffff could not be reserved
[4294014.731028] PCI: Bridge: 0000:00:01.0
[4294014.731028]   IO window: d000-dfff
[4294014.731028]   MEM window: 0xdc000000-0xdeefffff
[4294014.731028]   PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
[4294014.731028] PCI: Bridge: 0000:00:02.0
[4294014.731028]   IO window: disabled.
[4294014.731028]   MEM window: disabled.
[4294014.731028]   PREFETCH window: 0x00000000dad00000-0x00000000dadfffff
[4294014.731028] PCI: Bridge: 0000:00:03.0
[4294014.731028]   IO window: disabled.
[4294014.731028]   MEM window: disabled.
[4294014.731028]   PREFETCH window: 0x00000000dae00000-0x00000000daefffff
[4294014.731028] PCI: Bridge: 0000:00:04.0
[4294014.731028]   IO window: disabled.
[4294014.731028]   MEM window: disabled.
[4294014.731028]   PREFETCH window: 0x00000000daf00000-0x00000000daffffff
[4294014.731028] PCI: Bridge: 0000:00:11.0
[4294014.731028]   IO window: e000-efff
[4294014.731028]   MEM window: 0xdef00000-0xdeffffff
[4294014.731028]   PREFETCH window: disabled.
[4294014.731028] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 29 (level, low) -> IRQ 29
[4294014.731028] PCI: Setting latency timer of device 0000:00:01.0 to 64
[4294014.731028] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 34 (level, low) -> IRQ 34
[4294014.731028] PCI: Setting latency timer of device 0000:00:02.0 to 64
[4294014.731028] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 39 (level, low) -> IRQ 39
[4294014.731028] PCI: Setting latency timer of device 0000:00:03.0 to 64
[4294014.731028] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 44 (level, low) -> IRQ 44
[4294014.731028] PCI: Setting latency timer of device 0000:00:04.0 to 64
[4294014.731028] PCI: Setting latency timer of device 0000:00:11.0 to 64
[4294014.731028] NET: Registered protocol family 2
[4294014.766931] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[4294014.767962] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[4294014.770873] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[4294014.771872] TCP: Hash tables configured (established 262144 bind 65536)
[4294014.771872] TCP reno registered
[4294014.783041] checking if image is initramfs... it is
[4294015.045048] Freeing initrd memory: 3401k freed
[4294015.051986] JFS: nTxBlock = 8192, nTxLock = 65536
[4294015.055910] msgmni has been set to 6038 for ipc namespace ffffffff804de850
[4294015.055910] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[4294015.055910] io scheduler noop registered
[4294015.055910] io scheduler cfq registered (default)
[4294015.055910] pci 0000:00:00.0: Enabling HT MSI Mapping
[4294015.055910] pci 0000:00:01.0: Enabling HT MSI Mapping
[4294015.055910] pci 0000:00:02.0: Enabling HT MSI Mapping
[4294015.055910] pci 0000:00:03.0: Enabling HT MSI Mapping
[4294015.055910] pci 0000:00:04.0: Enabling HT MSI Mapping
[4294015.090159] pci 0000:01:00.0: Boot video device
[4294015.091091] PCI: Setting latency timer of device 0000:00:01.0 to 64
[4294015.091091] assign_interrupt_mode Found MSI capability
[4294015.091091] Allocate Port Service[0000:00:01.0:pcie00]
[4294015.091091] Allocate Port Service[0000:00:01.0:pcie01]
[4294015.091091] Allocate Port Service[0000:00:01.0:pcie03]
[4294015.091091] PCI: Setting latency timer of device 0000:00:02.0 to 64
[4294015.091091] assign_interrupt_mode Found MSI capability
[4294015.091091] Allocate Port Service[0000:00:02.0:pcie00]
[4294015.091091] Allocate Port Service[0000:00:02.0:pcie01]
[4294015.091091] Allocate Port Service[0000:00:02.0:pcie03]
[4294015.091091] PCI: Setting latency timer of device 0000:00:03.0 to 64
[4294015.091091] assign_interrupt_mode Found MSI capability
[4294015.091091] Allocate Port Service[0000:00:03.0:pcie00]
[4294015.091091] Allocate Port Service[0000:00:03.0:pcie01]
[4294015.091091] Allocate Port Service[0000:00:03.0:pcie03]
[4294015.091091] PCI: Setting latency timer of device 0000:00:04.0 to 64
[4294015.091091] assign_interrupt_mode Found MSI capability
[4294015.091091] Allocate Port Service[0000:00:04.0:pcie00]
[4294015.091091] Allocate Port Service[0000:00:04.0:pcie01]
[4294015.091091] Allocate Port Service[0000:00:04.0:pcie03]
[4294015.094486] Load service driver aer on pcie device 0000:00:01.0:pcie01
[4294015.096278] Load service driver aer on pcie device 0000:00:02.0:pcie01
[4294015.098374] Load service driver aer on pcie device 0000:00:03.0:pcie01
[4294015.101231] Load service driver aer on pcie device 0000:00:04.0:pcie01
[4294015.104250] hpet_resources: 0xfed00000 is busy
[4294015.104250] Linux agpgart interface v0.103
[4294015.106233] brd: module loaded
[4294015.106233] Driver 'sd' needs updating - please use bus_type methods
[4294015.106233] ahci 0000:00:16.1: version 3.0
[4294015.106233] ACPI: PCI Interrupt 0000:00:16.1[A] -> GSI 21 (level, low) -> IRQ 21
[4294016.107111] ahci 0000:00:16.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[4294016.107116] ahci 0000:00:16.1: flags: ncq sntf ilck pm led clo pmp pio slum part 
[4294016.108086] scsi0 : ahci
[4294016.108086] scsi1 : ahci
[4294016.108086] scsi2 : ahci
[4294016.108086] scsi3 : ahci
[4294016.109086] ata1: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef500 irq 21
[4294016.109086] ata2: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef580 irq 21
[4294016.109086] ata3: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef600 irq 21
[4294016.109086] ata4: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef680 irq 21
[4294016.413763] ata1: SATA link down (SStatus 0 SControl 300)
[4294016.718761] ata2: SATA link down (SStatus 0 SControl 300)
[4294017.023761] ata3: SATA link down (SStatus 0 SControl 300)
[4294017.481760] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[4294017.523746] ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[4294017.523746] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[4294017.542743] ata4.00: configured for UDMA/133
[4294017.509792] isa bounce pool size: 16 pages
[4294017.509792] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[4294017.509792] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[4294017.509792] sd 3:0:0:0: [sda] Write Protect is off
[4294017.509792] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.509792] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.509792] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[4294017.509792] sd 3:0:0:0: [sda] Write Protect is off
[4294017.509792] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.509792] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.509792]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[4294017.638996] sd 3:0:0:0: [sda] Attached SCSI disk
[4294017.638996] ACPI: PCI Interrupt 0000:00:16.0[A] -> GSI 21 (level, low) -> IRQ 21
[4294017.638996] scsi4 : pata_ali
[4294017.653998] scsi5 : pata_ali
[4294017.669599] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[4294017.669602] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[4294017.995282] ata5.00: ATA-6: ST3160021A, 8.01, max UDMA/100
[4294017.995285] ata5.00: 312581808 sectors, multi 16: LBA48 
[4294017.995505] ata5.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[4294017.995507] ata5.01: 160086528 sectors, multi 16: LBA 
[4294018.001296] ata5.00: configured for UDMA/100
[4294018.007279] ata5.01: configured for UDMA/133
[4294018.161367] ata6.00: ATAPI: _NEC DVD_RW ND-3540A, 1.01, max UDMA/33
[4294018.161376] ata6.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled
[4294018.161379] ata6.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
[4294018.167300] ata6.00: configured for UDMA/33
[4294018.167300] scsi 4:0:0:0: Direct-Access     ATA      ST3160021A       8.01 PQ: 0 ANSI: 5
[4294018.167300] sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
[4294018.167300] sd 4:0:0:0: [sdb] Write Protect is off
[4294018.167300] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[4294018.167300] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.167300] sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
[4294018.167300] sd 4:0:0:0: [sdb] Write Protect is off
[4294018.167300] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[4294018.167300] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.167300]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
[4294018.167301] sd 4:0:0:0: [sdb] Attached SCSI disk
[4294018.234378] scsi 4:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
[4294018.235319] sd 4:0:1:0: [sdc] 160086528 512-byte hardware sectors (81964 MB)
[4294018.235319] sd 4:0:1:0: [sdc] Write Protect is off
[4294018.235319] sd 4:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[4294018.235319] sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.235319] sd 4:0:1:0: [sdc] 160086528 512-byte hardware sectors (81964 MB)
[4294018.235319] sd 4:0:1:0: [sdc] Write Protect is off
[4294018.235319] sd 4:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[4294018.235319] sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.235319]  sdc: sdc1 sdc2 sdc3
[4294018.240319] sd 4:0:1:0: [sdc] Attached SCSI disk
[4294018.242223] scsi 5:0:0:0: CD-ROM            _NEC     DVD_RW ND-3540A  1.01 PQ: 0 ANSI: 5
[4294018.243223] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[4294018.243223] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[4294018.243223] serio: i8042 KBD port at 0x60,0x64 irq 1
[4294018.243247] mice: PS/2 mouse device common for all mice
[4294018.271586] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[4294018.280588] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[4294018.280588] rtc0: alarms up to one month
[4294018.280588] cpuidle: using governor ladder
[4294018.280588] cpuidle: using governor menu
[4294018.280588] TCP cubic registered
[4294018.280588] ieee80211: 802.11 data/management/control stack, git-1.1.13
[4294018.280588] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[4294018.280588] ieee80211_crypt: registered algorithm 'NULL'
[4294018.280588] rtc_cmos 00:02: setting system clock to 2008-05-28 08:56:00 UTC (1211964960)
[4294018.280588] Freeing unused kernel memory: 240k freed
[4294018.280618] Write protecting the kernel read-only data: 2828k
[4294019.437523] fuse init (API version 7.9)
[4294019.446192] ACPI: duty_cycle spans bit 4
[4294019.446523] ACPI: ACPI0007:00 is registered as cooling_device0
[4294019.446523] ACPI: ACPI0007:01 is registered as cooling_device1
[4294019.451660] NET: Registered protocol family 1
[4294019.594060] usbcore: registered new interface driver usbfs
[4294019.594123] usbcore: registered new interface driver hub
[4294019.596066] usbcore: registered new device driver usb
[4294019.596066] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[4294019.596066] ACPI: PCI Interrupt 0000:05:0b.0[A] -> GSI 19 (level, low) -> IRQ 19
[4294019.596315] eth0: RTL8110s at 0xffffc20000030c00, 00:4f:63:00:a4:73, XID 04000000 IRQ 19
[4294019.601061] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[4294019.601061] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 17 (level, low) -> IRQ 17
[4294019.601061] ohci_hcd 0000:00:13.0: OHCI Host Controller
[4294019.601076] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[4294019.601100] ohci_hcd 0000:00:13.0: irq 17, io mem 0xdbfee000
[4294019.622812] sd 3:0:0:0: Attached scsi generic sg0 type 0
[4294019.622841] sd 4:0:0:0: Attached scsi generic sg1 type 0
[4294019.622865] sd 4:0:1:0: Attached scsi generic sg2 type 0
[4294019.622888] scsi 5:0:0:0: Attached scsi generic sg3 type 5
[4294019.654885] usb usb1: configuration #1 chosen from 1 choice
[4294019.654914] hub 1-0:1.0: USB hub found
[4294019.654927] hub 1-0:1.0: 3 ports detected
[4294019.675883] Floppy drive(s): fd0 is 1.44M
[4294019.690544] FDC 0 is a post-1991 82077
[4294019.757057] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 18 (level, low) -> IRQ 18
[4294019.757057] ohci_hcd 0000:00:13.1: OHCI Host Controller
[4294019.757057] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
[4294019.757057] ohci_hcd 0000:00:13.1: irq 18, io mem 0xdbfed000
[4294019.809971] usb usb2: configuration #1 chosen from 1 choice
[4294019.810001] hub 2-0:1.0: USB hub found
[4294019.810011] hub 2-0:1.0: 3 ports detected
[4294019.911541] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 19 (level, low) -> IRQ 19
[4294019.911541] ohci_hcd 0000:00:13.2: OHCI Host Controller
[4294019.911541] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[4294019.911541] ohci_hcd 0000:00:13.2: irq 19, io mem 0xdbfec000
[4294019.964555] usb usb3: configuration #1 chosen from 1 choice
[4294019.964585] hub 3-0:1.0: USB hub found
[4294019.964596] hub 3-0:1.0: 3 ports detected
[4294019.975364] usb 1-2: new low speed USB device using ohci_hcd and address 2
[4294020.066385] ACPI: PCI Interrupt 0000:00:13.3[D] -> GSI 23 (level, low) -> IRQ 23
[4294020.066385] ehci_hcd 0000:00:13.3: EHCI Host Controller
[4294020.066385] ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
[4294020.087400] ehci_hcd 0000:00:13.3: debug port 1
[4294020.087417] ehci_hcd 0000:00:13.3: irq 23, io mem 0xdbfef800
[4294020.101639] ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[4294020.101729] usb usb4: configuration #1 chosen from 1 choice
[4294020.101757] hub 4-0:1.0: USB hub found
[4294020.101765] hub 4-0:1.0: 8 ports detected
[4294020.505794] usb 1-2: device not accepting address 2, error -62
[4294020.556569] hub 1-0:1.0: unable to enumerate USB device on port 2
[4294020.925197] hub 4-0:1.0: unable to enumerate USB device on port 2
[4294021.141297] hub 4-0:1.0: unable to enumerate USB device on port 8
[4294021.358691] usb 1-2: new low speed USB device using ohci_hcd and address 4
[4294021.505050] usb 1-2: configuration #1 chosen from 1 choice
[4294021.732057] usb 3-2: new full speed USB device using ohci_hcd and address 2
[4294021.897145] usb 3-2: configuration #1 chosen from 1 choice
[4294027.122417] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[4294027.122417] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 20 (level, low) -> IRQ 20
[4294027.145416] eth1: ULi M5263 at pci0000:00:12.0, 00:13:8f:b3:14:a4, irq 20.
[4294027.152419] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[4294027.158483] ACPI: Power Button (FF) [PWRF]
[4294027.158617] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[4294027.167469] ACPI: Power Button (CM) [PWRB]
[4294027.233616] ali15x3_smbus 0000:00:15.1: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
[4294027.233616] ali15x3_smbus 0000:00:15.1: ALI15X3 not detected, module not inserted.
[4294027.250701] ali1535_smbus 0000:00:15.1: ALI1535_smb region uninitialized - upgrade BIOS?
[4294027.250706] ali1535_smbus 0000:00:15.1: ALI1535 not detected, module not inserted.
[4294027.433976] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x1904
[4294027.433976] usbcore: registered new interface driver usblp
[4294027.449798] usbcore: registered new interface driver hiddev
[4294027.455956] input: KYE NetScroll+ Traveler as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2:1.0/input/input3
[4294027.462644] input,hidraw0: USB HID v1.10 Mouse [KYE NetScroll+ Traveler] on usb-0000:00:13.0-2
[4294027.462669] usbcore: registered new interface driver usbhid
[4294027.462673] usbhid: v2.6:USB HID core driver
[4294027.539417] ACPI: PCI Interrupt 0000:05:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
[4294027.562595] phy0: Selected rate control algorithm 'pid'
[4294027.590852] input: PC Speaker as /devices/platform/pcspkr/input/input4
[4294027.677079] Driver 'sr' needs updating - please use bus_type methods
[4294027.681082] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[4294027.681082] Uniform CD-ROM driver Revision: 3.20
[4294027.681082] sr 5:0:0:0: Attached scsi CD-ROM sr0
[4294027.685552] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[4294027.686028] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[4294027.704444] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[4294027.769735] parport_pc 00:06: reported by Plug and Play ACPI
[4294027.769735] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[4294027.900664] Registered led device: rt2500pci-phy0:radio
[4294027.900929] udev: renamed network interface eth1 to eth0
[4294027.951195] udev: renamed network interface eth0_rename to eth1
[4294028.122821] ACPI: PCI Interrupt 0000:00:14.0[C] -> GSI 22 (level, low) -> IRQ 22
[4294028.132675] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[4294028.806243] lp0: using parport0 (interrupt-driven).
[4294028.820714] w83627ehf: Found W83627EHG chip at 0x290
[4294028.977309] Adding 1992020k swap on /dev/sdb7.  Priority:1 extents:1 across:1992020k
[4294029.014282] Adding 1020116k swap on /dev/sdc2.  Priority:1 extents:1 across:1020116k
[4294031.457231] ip_tables: (C) 2000-2006 Netfilter Core Team
[4294032.698611] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[4294033.907220] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (2 cpu cores) (version 2.20.00)
[4294033.906944] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xa
[4294033.906944] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xc
[4294033.906944] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[4294035.793408] NET: Registered protocol family 10
[4294035.795734] lo: Disabled Privacy Extensions
[4294036.032974] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[4294037.729296] Clocksource tsc unstable (delta = -249471632 ns)
[4294042.180312] ADDRCONF(NETDEV_UP): eth0: link is not ready
[4294042.204390] r8169: eth1: link down
[4294042.205306] r8169: eth1: link down
[4294042.206416] ADDRCONF(NETDEV_UP): eth1: link is not ready
[4294042.231137] BUG: scheduling while atomic: S25bluetooth/4382/0x00010002
[4294042.231144] CPU 1:
[4294042.231146] Modules linked in: ipv6 container powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative nf_conntrack_ftp nf_conntrack_irc xt_tcpudp ipt_ULOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables kvm_amd kvm w83627ehf hwmon_vid lp snd_hda_intel snd_pcm_oss snd_mixer_oss arc4 snd_pcm ecb parport_pc parport crypto_blkcipher snd_mpu401 snd_mpu401_uart 8250_pnp 8250 serial_core snd_seq_dummy sr_mod cdrom cryptomgr crypto_algapi evdev snd_seq_oss pcspkr snd_seq_midi snd_rawmidi k8temp rt2500pci rt2x00pci rt2x00lib snd_seq_midi_event rfkill usbhid snd_seq led_class usblp ff_memless input_polldev mac80211 snd_timer snd_seq_device cfg80211 snd eeprom_93cx6 i2c_ali1535 i2c_ali15x3 soundcore snd_page_alloc i2c_core button uli526x floppy sg ata_generic ehci_hcd ohci_hcd r8169 usbcore unix thermal processor fan fuse
[4294042.231224] Pid: 4382, comm: S25bluetooth Not tainted 2.6.26-rc4 #28
[4294042.231227] RIP: 0010:[<ffffffff80265b99>]  [<ffffffff80265b99>] free_pgd_range+0xbf/0x3c3
[4294042.231302] RSP: 0018:ffff8100b9f05bf8  EFLAGS: 00000286
[4294042.231306] RAX: ffff8100be51ba80 RBX: 0000000000400000 RCX: 00000000006f7000
[4294042.231309] RDX: 00007f0000000000 RSI: 0000000000400000 RDI: ffff8100b9f05cf0
[4294042.231312] RBP: 0000000000000080 R08: 00007f1f3d012000 R09: ffff8100b9e0d7f8
[4294042.231315] R10: ffff8100b9e0d7f8 R11: ffff8100bf593390 R12: 00000080bf592f18
[4294042.231319] R13: 0000000000000001 R14: 0000000000000080 R15: ffff8100b9f05c08
[4294042.231322] FS:  00007f1f3d5756e0(0000) GS:ffff8100bf806580(0000) knlGS:0000000000000000
[4294042.231326] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[4294042.231329] CR2: 0000000000617ee8 CR3: 00000000b9e0e000 CR4: 00000000000006e0
[4294042.231332] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[4294042.231335] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[4294042.231338] 
[4294042.231339] Call Trace:
[4294042.231344]  [<ffffffff80263b0e>] ? unmap_vmas+0x4d4/0x792
[4294042.231363]  [<ffffffff8026622e>] ? free_pgtables+0x87/0x99
[4294042.231372]  [<ffffffff802675b4>] ? exit_mmap+0xa0/0x120
[4294042.231380]  [<ffffffff8022bbe3>] ? mmput+0x20/0xa4
[4294042.231386]  [<ffffffff8027dcae>] ? flush_old_exec+0x4b6/0x7cf
[4294042.231390]  [<ffffffff80279ce6>] ? vfs_read+0x10b/0x11f
[4294042.231399]  [<ffffffff802a8a37>] ? load_elf_binary+0x0/0x1738
[4294042.231405]  [<ffffffff802a8da6>] ? load_elf_binary+0x36f/0x1738
[4294042.231409]  [<ffffffff802acc16>] ? load_elf_binary+0x16bf/0x17e2
[4294042.231417]  [<ffffffff80264dcc>] ? get_user_pages+0x32f/0x389
[4294042.231427]  [<ffffffff8027ca2c>] ? get_arg_page+0x46/0xa5
[4294042.231437]  [<ffffffff802a8a37>] ? load_elf_binary+0x0/0x1738
[4294042.231443]  [<ffffffff8027ce71>] ? search_binary_handler+0xdb/0x21d
[4294042.231452]  [<ffffffff8027e119>] ? do_execve+0x152/0x1d6
[4294042.231461]  [<ffffffff8020981a>] ? sys_execve+0x35/0x53
[4294042.231468]  [<ffffffff8020b59a>] ? stub_execve+0x6a/0xc0
[4294042.231481] 
[4294042.244824] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[4294042.352377] Bluetooth: Core ver 2.11
[4294042.358411] NET: Registered protocol family 31
[4294042.358416] Bluetooth: HCI device and connection manager initialized
[4294042.358421] Bluetooth: HCI socket layer initialized
[4294042.408932] Bluetooth: L2CAP ver 2.9
[4294042.408932] Bluetooth: L2CAP socket layer initialized
[4294042.427442] Bluetooth: RFCOMM socket layer initialized
[4294042.427460] Bluetooth: RFCOMM TTY layer initialized
[4294042.427463] Bluetooth: RFCOMM ver 1.8
[4294043.376174] NET: Registered protocol family 17
[4294045.202822] uli526x: eth0 NIC Link is Down





