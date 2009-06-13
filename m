Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZFML4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZFML4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZFMLz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:55:59 -0400
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:48533
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZFMLzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:55:55 -0400
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2009 07:55:53 EDT
X-Trace: 168558799/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.11.44/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-MUA: KMail/1.9.10
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAFYuM0pTQwss/2dsb2JhbACBT75GjnKEDQU
X-IronPort-AV: E=Sophos;i="4.42,214,1243810800"; 
   d="scan'208";a="168558799"
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: linux-acpi@vger.kernel.org
Subject: [2.6.30][regression] ACPI continuously logging errors and exceptions while reading DVD
Date: Sat, 13 Jun 2009 12:44:45 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tE5MKyFEO8SdGrV"
Message-Id: <200906131244.45309.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_tE5MKyFEO8SdGrV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi,

Just booted up 2.6.30 for the first time on this machine and found this problem.	Hope the attachment goes through because everything is in there. Log is 
shortened since errors are always the same and repeating constantly while DVD is in use.

Tvrtko

P.S. Rafael hope you don't mind CC-ing you directly, I know you do a great job tracking regressions so I though to make it easier like this.

--Boundary-00=_tE5MKyFEO8SdGrV
Content-Type: text/plain;
  charset="iso 8859-15";
  name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="messages"

Jun 13 12:03:30 media kernel: [    0.000000] Linux version 2.6.30 (tvrtko@sol) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 Sat Jun 13 11:49:26 BST 2009
Jun 13 12:03:30 media kernel: [    0.000000] Command line: root=UUID=6bb0c1d1-16cc-447f-bd89-0b62ef6f9739 ro quiet splash
Jun 13 12:03:30 media kernel: [    0.000000] KERNEL supported cpus:
Jun 13 12:03:30 media kernel: [    0.000000]   Intel GenuineIntel
Jun 13 12:03:30 media kernel: [    0.000000]   AMD AuthenticAMD
Jun 13 12:03:30 media kernel: [    0.000000]   Centaur CentaurHauls
Jun 13 12:03:30 media kernel: [    0.000000] BIOS-provided physical RAM map:
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000003bef0000 (usable)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 000000003bef0000 - 000000003bef3000 (ACPI NVS)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 000000003bef3000 - 000000003bf00000 (ACPI data)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jun 13 12:03:30 media kernel: [    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Jun 13 12:03:30 media kernel: [    0.000000] DMI present.
Jun 13 12:03:30 media kernel: [    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
Jun 13 12:03:30 media kernel: [    0.000000] last_pfn = 0x3bef0 max_arch_pfn = 0x100000000
Jun 13 12:03:30 media kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jun 13 12:03:30 media kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000003bef0000
Jun 13 12:03:30 media kernel: [    0.000000] RAMDISK: 37aab000 - 37fef6e3
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: RSDP 00000000000f7590 00014 (v00 HP-CPC)
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: RSDT 000000003bef3040 00030 (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: FACP 000000003bef30c0 00074 (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: DSDT 000000003bef3180 0497C (v01 HP-CPC AWRDACPI 00001000 MSFT 0100000E)
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: FACS 000000003bef0000 00040
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: MCFG 000000003bef7c00 0003C (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: APIC 000000003bef7b40 0005A (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
Jun 13 12:03:30 media kernel: [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 003bef0000]
Jun 13 12:03:30 media kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jun 13 12:03:30 media kernel: [    0.000000]   #1 [0000200000 - 0000627fa0]    TEXT DATA BSS ==> [0000200000 - 0000627fa0]
Jun 13 12:03:30 media kernel: [    0.000000]   #2 [0037aab000 - 0037fef6e3]          RAMDISK ==> [0037aab000 - 0037fef6e3]
Jun 13 12:03:30 media kernel: [    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
Jun 13 12:03:30 media kernel: [    0.000000]   #4 [0000628000 - 0000628270]              BRK ==> [0000628000 - 0000628270]
Jun 13 12:03:30 media kernel: [    0.000000]   #5 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
Jun 13 12:03:30 media kernel: [    0.000000] found SMP MP-table at [ffff8800000f5980] f5980
Jun 13 12:03:30 media kernel: [    0.000000] Zone PFN ranges:
Jun 13 12:03:30 media kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Jun 13 12:03:30 media kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Jun 13 12:03:30 media kernel: [    0.000000]   Normal   0x00100000 -> 0x00100000
Jun 13 12:03:30 media kernel: [    0.000000] Movable zone start PFN for each node
Jun 13 12:03:30 media kernel: [    0.000000] early_node_map[2] active PFN ranges
Jun 13 12:03:30 media kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Jun 13 12:03:30 media kernel: [    0.000000]     0: 0x00000100 -> 0x0003bef0
Jun 13 12:03:30 media kernel: [    0.000000] SB4X0 revision 0x12
Jun 13 12:03:30 media kernel: [    0.000000] Ignoring ACPI timer override.
Jun 13 12:03:30 media kernel: [    0.000000] If you got timer trouble try acpi_use_timer_override
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jun 13 12:03:30 media kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
Jun 13 12:03:30 media kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Jun 13 12:03:30 media kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jun 13 12:03:30 media kernel: [    0.000000] Allocating PCI resources starting at 40000000 (gap: 3bf00000:a4100000)
Jun 13 12:03:30 media kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 240857
Jun 13 12:03:30 media kernel: [    0.000000] Kernel command line: root=UUID=6bb0c1d1-16cc-447f-bd89-0b62ef6f9739 ro quiet splash
Jun 13 12:03:30 media kernel: [    0.000000] Initializing CPU#0
Jun 13 12:03:30 media kernel: [    0.000000] NR_IRQS:288
Jun 13 12:03:30 media kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Jun 13 12:03:30 media kernel: [    0.000000] Fast TSC calibration using PIT
Jun 13 12:03:30 media kernel: [    0.000000] Detected 1790.812 MHz processor.
Jun 13 12:03:30 media kernel: [    0.000999] Console: colour VGA+ 80x25
Jun 13 12:03:30 media kernel: [    0.000999] console [tty0] enabled
Jun 13 12:03:30 media kernel: [    0.000999] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jun 13 12:03:30 media kernel: [    0.000999] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Jun 13 12:03:30 media kernel: [    0.000999] Checking aperture...
Jun 13 12:03:30 media kernel: [    0.000999] No AGP bridge found
Jun 13 12:03:30 media kernel: [    0.000999] Node 0: aperture @ 2114000000 size 32 MB
Jun 13 12:03:30 media kernel: [    0.000999] Aperture beyond 4GB. Ignoring.
Jun 13 12:03:30 media kernel: [    0.000999] Memory: 955152k/981952k available (2331k kernel code, 452k absent, 25612k reserved, 1274k data, 320k init)
Jun 13 12:03:30 media kernel: [    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Jun 13 12:03:30 media kernel: [    0.001012] Calibrating delay loop (skipped), value calculated using timer frequency.. 3581.62 BogoMIPS (lpj=1790812)
Jun 13 12:03:30 media kernel: [    0.001047] Mount-cache hash table entries: 256
Jun 13 12:03:30 media kernel: [    0.001227] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jun 13 12:03:30 media kernel: [    0.001230] CPU: L2 Cache: 1024K (64 bytes/line)
Jun 13 12:03:30 media kernel: [    0.001244] CPU: AMD Turion(tm) 64 Mobile Technology ML-34 stepping 02
Jun 13 12:03:30 media kernel: [    0.001270] ACPI: Core revision 20090320
Jun 13 12:03:30 media kernel: [    0.009080] Setting APIC routing to flat
Jun 13 12:03:30 media kernel: [    0.010211] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
Jun 13 12:03:30 media kernel: [    0.020996] net_namespace: 1744 bytes
Jun 13 12:03:30 media kernel: [    0.020996] NET: Registered protocol family 16
Jun 13 12:03:30 media kernel: [    0.020996] TOM: 0000000040000000 aka 1024M
Jun 13 12:03:30 media kernel: [    0.020996] ACPI: bus type pci registered
Jun 13 12:03:30 media kernel: [    0.020996] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Jun 13 12:03:30 media kernel: [    0.020996] PCI: MCFG area at e0000000 reserved in E820
Jun 13 12:03:30 media kernel: [    0.029062] PCI: Using MMCONFIG at e0000000 - efffffff
Jun 13 12:03:30 media kernel: [    0.029064] PCI: Using configuration type 1 for base access
Jun 13 12:03:30 media kernel: [    0.029952] bio: create slab <bio-0> at 0
Jun 13 12:03:30 media kernel: [    0.032723] ACPI Warning (dsobject-0502): Package List length (7) larger than NumElements count (3), truncated
Jun 13 12:03:30 media kernel: [    0.032728]  [20090320]
Jun 13 12:03:30 media kernel: [    0.036643] ACPI: Interpreter enabled
Jun 13 12:03:30 media kernel: [    0.036645] ACPI: (supports S0 S5)
Jun 13 12:03:30 media kernel: [    0.036657] ACPI: Using IOAPIC for interrupt routing
Jun 13 12:03:30 media kernel: [    0.041673] ACPI: PCI Root Bridge [PCI0] (0000:00)
Jun 13 12:03:30 media kernel: [    0.042297] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Jun 13 12:03:30 media kernel: [    0.042303] pci 0000:00:13.2: PME# disabled
Jun 13 12:03:30 media kernel: [    0.042403] HPET not enabled in BIOS. You might try hpet=force boot option
Jun 13 12:03:30 media kernel: [    0.043059] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot
Jun 13 12:03:30 media kernel: [    0.043066] pci 0000:02:01.0: PME# disabled
Jun 13 12:03:30 media kernel: [    0.043208] pci 0000:02:03.0: PME# supported from D1 D2 D3hot D3cold
Jun 13 12:03:30 media kernel: [    0.043214] pci 0000:02:03.0: PME# disabled
Jun 13 12:03:30 media kernel: [    0.043386] pci 0000:02:08.0: PME# supported from D0 D1 D2 D3hot D3cold
Jun 13 12:03:30 media kernel: [    0.043393] pci 0000:02:08.0: PME# disabled
Jun 13 12:03:30 media kernel: [    0.043451] pci 0000:00:14.4: transparent bridge
Jun 13 12:03:30 media kernel: [    0.063159] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jun 13 12:03:30 media kernel: [    0.063323] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jun 13 12:03:30 media kernel: [    0.063486] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jun 13 12:03:30 media kernel: [    0.063649] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jun 13 12:03:30 media kernel: [    0.063812] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jun 13 12:03:30 media kernel: [    0.063974] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11)
Jun 13 12:03:30 media kernel: [    0.064140] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
Jun 13 12:03:30 media kernel: [    0.064302] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jun 13 12:03:30 media kernel: [    0.064594] PCI: Using ACPI for IRQ routing
Jun 13 12:03:30 media kernel: [    0.064965] pnp: PnP ACPI init
Jun 13 12:03:30 media kernel: [    0.064974] ACPI: bus type pnp registered
Jun 13 12:03:30 media kernel: [    0.067757] pnp: PnP ACPI: found 9 devices
Jun 13 12:03:30 media kernel: [    0.067760] ACPI: ACPI bus type pnp unregistered
Jun 13 12:03:30 media kernel: [    0.067769] system 00:01: ioport range 0x228-0x22f has been reserved
Jun 13 12:03:30 media kernel: [    0.067773] system 00:01: ioport range 0x40b-0x40b has been reserved
Jun 13 12:03:30 media kernel: [    0.067777] system 00:01: ioport range 0x4d6-0x4d6 has been reserved
Jun 13 12:03:30 media kernel: [    0.067780] system 00:01: ioport range 0xc00-0xc01 has been reserved
Jun 13 12:03:30 media kernel: [    0.067784] system 00:01: ioport range 0xc14-0xc14 has been reserved
Jun 13 12:03:30 media kernel: [    0.067788] system 00:01: ioport range 0xc50-0xc52 has been reserved
Jun 13 12:03:30 media kernel: [    0.067791] system 00:01: ioport range 0xc6c-0xc6d has been reserved
Jun 13 12:03:30 media kernel: [    0.067795] system 00:01: ioport range 0xc6f-0xc6f has been reserved
Jun 13 12:03:30 media kernel: [    0.067798] system 00:01: ioport range 0xcd4-0xcdf has been reserved
Jun 13 12:03:30 media kernel: [    0.067802] system 00:01: ioport range 0x4000-0x40fe has been reserved
Jun 13 12:03:30 media kernel: [    0.067806] system 00:01: ioport range 0x4210-0x4217 has been reserved
Jun 13 12:03:30 media kernel: [    0.067813] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
Jun 13 12:03:30 media kernel: [    0.067817] system 00:06: ioport range 0x800-0x87f has been reserved
Jun 13 12:03:30 media kernel: [    0.067823] system 00:07: iomem range 0xe0000000-0xefffffff has been reserved
Jun 13 12:03:30 media kernel: [    0.067829] system 00:08: iomem range 0xd0000-0xd3fff has been reserved
Jun 13 12:03:30 media kernel: [    0.067833] system 00:08: iomem range 0xf0000-0xf7fff could not be reserved
Jun 13 12:03:30 media kernel: [    0.067837] system 00:08: iomem range 0xf8000-0xfbfff could not be reserved
Jun 13 12:03:30 media kernel: [    0.067840] system 00:08: iomem range 0xfc000-0xfffff could not be reserved
Jun 13 12:03:30 media kernel: [    0.067844] system 00:08: iomem range 0x3bf00000-0x3bffffff has been reserved
Jun 13 12:03:30 media kernel: [    0.067848] system 00:08: iomem range 0x3bef0000-0x3befffff could not be reserved
Jun 13 12:03:30 media kernel: [    0.067852] system 00:08: iomem range 0xffff0000-0xffffffff has been reserved
Jun 13 12:03:30 media kernel: [    0.067855] system 00:08: iomem range 0x0-0x9ffff could not be reserved
Jun 13 12:03:30 media kernel: [    0.067859] system 00:08: iomem range 0x100000-0x3beeffff could not be reserved
Jun 13 12:03:30 media kernel: [    0.067863] system 00:08: iomem range 0x3c000000-0x3fffffff has been reserved
Jun 13 12:03:30 media kernel: [    0.067867] system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
Jun 13 12:03:30 media kernel: [    0.067870] system 00:08: iomem range 0xfee00000-0xfee00fff has been reserved
Jun 13 12:03:30 media kernel: [    0.067874] system 00:08: iomem range 0xfff80000-0xfffeffff has been reserved
Jun 13 12:03:30 media kernel: [    0.072749] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Jun 13 12:03:30 media kernel: [    0.072752] pci 0000:00:01.0:   IO window: 0xe000-0xefff
Jun 13 12:03:30 media kernel: [    0.072756] pci 0000:00:01.0:   MEM window: 0xfdd00000-0xfddfffff
Jun 13 12:03:30 media kernel: [    0.072760] pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
Jun 13 12:03:30 media kernel: [    0.072766] pci 0000:00:14.4: PCI bridge, secondary bus 0000:02
Jun 13 12:03:30 media kernel: [    0.072770] pci 0000:00:14.4:   IO window: 0xd000-0xdfff
Jun 13 12:03:30 media kernel: [    0.072778] pci 0000:00:14.4:   MEM window: 0xfdc00000-0xfdcfffff
Jun 13 12:03:30 media kernel: [    0.072783] pci 0000:00:14.4:   PREFETCH window: 0x000000fde00000-0x000000fdefffff
Jun 13 12:03:30 media kernel: [    0.072852] NET: Registered protocol family 2
Jun 13 12:03:30 media kernel: [    0.072884] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
Jun 13 12:03:30 media kernel: [    0.073229] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
Jun 13 12:03:30 media kernel: [    0.074970] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Jun 13 12:03:30 media kernel: [    0.075482] TCP: Hash tables configured (established 131072 bind 65536)
Jun 13 12:03:30 media kernel: [    0.075486] TCP reno registered
Jun 13 12:03:30 media kernel: [    0.075570] NET: Registered protocol family 1
Jun 13 12:03:30 media kernel: [    0.075635] Trying to unpack rootfs image as initramfs...
Jun 13 12:03:30 media kernel: [    0.323353] Freeing initrd memory: 5393k freed
Jun 13 12:03:30 media kernel: [    0.329372] audit: initializing netlink socket (disabled)
Jun 13 12:03:30 media kernel: [    0.329387] type=2000 audit(1244890966.328:1): initialized
Jun 13 12:03:30 media kernel: [    0.332182] msgmni has been set to 1877
Jun 13 12:03:30 media kernel: [    0.332329] alg: No test for stdrng (krng)
Jun 13 12:03:30 media kernel: [    0.332340] io scheduler noop registered
Jun 13 12:03:30 media kernel: [    0.332342] io scheduler anticipatory registered
Jun 13 12:03:30 media kernel: [    0.332345] io scheduler deadline registered (default)
Jun 13 12:03:30 media kernel: [    0.332357] io scheduler cfq registered
Jun 13 12:03:30 media kernel: [    0.332364] pci 0000:00:00.0: MSI quirk detected; MSI disabled
Jun 13 12:03:30 media kernel: [    0.392633] Linux agpgart interface v0.103
Jun 13 12:03:30 media kernel: [    0.392636] Serial: 8250/16550 driver, 2 ports, IRQ sharing enabled
Jun 13 12:03:30 media kernel: [    0.394384] brd: module loaded
Jun 13 12:03:30 media kernel: [    0.394510] PNP: No PS/2 controller found. Probing ports directly.
Jun 13 12:03:30 media kernel: [    0.397113] serio: i8042 KBD port at 0x60,0x64 irq 1
Jun 13 12:03:30 media kernel: [    0.397119] serio: i8042 AUX port at 0x60,0x64 irq 12
Jun 13 12:03:30 media kernel: [    0.397296] mice: PS/2 mouse device common for all mice
Jun 13 12:03:30 media kernel: [    0.397366] rtc_cmos 00:03: RTC can wake from S4
Jun 13 12:03:30 media kernel: [    0.397440] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Jun 13 12:03:30 media kernel: [    0.397467] rtc0: alarms up to one month, 242 bytes nvram
Jun 13 12:03:30 media kernel: [    0.397497] cpuidle: using governor ladder
Jun 13 12:03:30 media kernel: [    0.397500] cpuidle: using governor menu
Jun 13 12:03:30 media kernel: [    0.397556] NET: Registered protocol family 26
Jun 13 12:03:30 media kernel: [    0.397614] TCP cubic registered
Jun 13 12:03:30 media kernel: [    0.397733] registered taskstats version 1
Jun 13 12:03:30 media kernel: [    0.397896] rtc_cmos 00:03: setting system clock to 2009-06-13 11:02:47 UTC (1244890967)
Jun 13 12:03:30 media kernel: [    0.397900] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Jun 13 12:03:30 media kernel: [    0.397902] EDD information not available.
Jun 13 12:03:30 media kernel: [    0.397969] Freeing unused kernel memory: 320k freed
Jun 13 12:03:30 media kernel: [    0.398264] Write protecting the kernel read-only data: 3256k
Jun 13 12:03:30 media kernel: [    0.542647] fuse init (API version 7.11)
Jun 13 12:03:30 media kernel: [    0.553017] fan PNP0C0B:00: registered as cooling_device0
Jun 13 12:03:30 media kernel: [    0.553024] ACPI: Fan [FAN] (on)
Jun 13 12:03:30 media kernel: [    0.575672] thermal LNXTHERM:01: registered as thermal_zone0
Jun 13 12:03:30 media kernel: [    0.575682] ACPI: Thermal Zone [THRM] (40 C)
Jun 13 12:03:30 media kernel: [    0.781845] usbcore: registered new interface driver usbfs
Jun 13 12:03:30 media kernel: [    0.781878] usbcore: registered new interface driver hub
Jun 13 12:03:30 media kernel: [    0.781906] usbcore: registered new device driver usb
Jun 13 12:03:30 media kernel: [    0.783981] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jun 13 12:03:30 media kernel: [    0.784025] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jun 13 12:03:30 media kernel: [    0.784047] ohci_hcd 0000:00:13.0: OHCI Host Controller
Jun 13 12:03:30 media kernel: [    0.784095] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
Jun 13 12:03:30 media kernel: [    0.784123] ohci_hcd 0000:00:13.0: irq 19, io mem 0xfe02e000
Jun 13 12:03:30 media kernel: [    0.839140] usb usb1: configuration #1 chosen from 1 choice
Jun 13 12:03:30 media kernel: [    0.839187] hub 1-0:1.0: USB hub found
Jun 13 12:03:30 media kernel: [    0.839201] hub 1-0:1.0: 4 ports detected
Jun 13 12:03:30 media kernel: [    0.839338] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jun 13 12:03:30 media kernel: [    0.839362] ohci_hcd 0000:00:13.1: OHCI Host Controller
Jun 13 12:03:30 media kernel: [    0.839390] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
Jun 13 12:03:30 media kernel: [    0.839412] ohci_hcd 0000:00:13.1: irq 19, io mem 0xfe02d000
Jun 13 12:03:30 media kernel: [    0.895464] usb usb2: configuration #1 chosen from 1 choice
Jun 13 12:03:30 media kernel: [    0.895500] hub 2-0:1.0: USB hub found
Jun 13 12:03:30 media kernel: [    0.895517] hub 2-0:1.0: 4 ports detected
Jun 13 12:03:30 media kernel: [    0.898081] SCSI subsystem initialized
Jun 13 12:03:30 media kernel: [    0.943071] skge 0000:02:08.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jun 13 12:03:30 media kernel: [    0.943132] skge 1.13 addr 0xfdcf8000 irq 22 chip Yukon-Lite rev 9
Jun 13 12:03:30 media kernel: [    0.943337] skge eth0: addr 00:1b:11:c3:1b:6f
Jun 13 12:03:30 media kernel: [    0.947590] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Jun 13 12:03:30 media kernel: [    0.947605] 8139cp 0000:02:03.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
Jun 13 12:03:30 media kernel: [    0.950682] 8139too Fast Ethernet driver 0.9.28
Jun 13 12:03:30 media kernel: [    0.953688] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jun 13 12:03:30 media kernel: [    0.953691] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
Jun 13 12:03:30 media kernel: [    0.953716] ehci_hcd 0000:00:13.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jun 13 12:03:30 media kernel: [    0.953731] ehci_hcd 0000:00:13.2: EHCI Host Controller
Jun 13 12:03:30 media kernel: [    0.953765] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
Jun 13 12:03:30 media kernel: [    0.953827] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe02c000
Jun 13 12:03:30 media kernel: [    0.954145] 8139too 0000:02:03.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Jun 13 12:03:30 media kernel: [    0.954844] eth1: RealTek RTL8139 at 0xffffc200101ec000, 00:17:31:9d:c0:82, IRQ 21
Jun 13 12:03:30 media kernel: [    0.959018] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Jun 13 12:03:30 media kernel: [    0.959137] usb usb3: configuration #1 chosen from 1 choice
Jun 13 12:03:30 media kernel: [    0.959172] hub 3-0:1.0: USB hub found
Jun 13 12:03:30 media kernel: [    0.959181] hub 3-0:1.0: 8 ports detected
Jun 13 12:03:30 media kernel: [    0.963367] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jun 13 12:03:30 media kernel: [    0.963512] scsi0 : pata_atiixp
Jun 13 12:03:30 media kernel: [    0.963628] scsi1 : pata_atiixp
Jun 13 12:03:30 media kernel: [    0.963682] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
Jun 13 12:03:30 media kernel: [    0.963685] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf908 irq 15
Jun 13 12:03:30 media kernel: [    1.058441] sata_sil 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jun 13 12:03:30 media kernel: [    1.061164] scsi2 : sata_sil
Jun 13 12:03:30 media kernel: [    1.061246] scsi3 : sata_sil
Jun 13 12:03:30 media kernel: [    1.061287] ata3: SATA max UDMA/100 mmio m512@0xfe02f000 tf 0xfe02f080 irq 22
Jun 13 12:03:30 media kernel: [    1.061292] ata4: SATA max UDMA/100 mmio m512@0xfe02f000 tf 0xfe02f0c0 irq 22
Jun 13 12:03:30 media kernel: [    1.121573] ata1.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB04, max UDMA/33
Jun 13 12:03:30 media kernel: [    1.127525] ata1.00: configured for UDMA/33
Jun 13 12:03:30 media kernel: [    1.128947] scsi 0:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB04 PQ: 0 ANSI: 5
Jun 13 12:03:30 media kernel: [    1.367054] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jun 13 12:03:30 media kernel: [    1.397452] ata3.00: ATA-8: WDC WD5000AACS-00ZUB0, 01.01B01, max UDMA/133
Jun 13 12:03:30 media kernel: [    1.397456] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jun 13 12:03:30 media kernel: [    1.403681] ata3.00: configured for UDMA/100
Jun 13 12:03:30 media kernel: [    1.403774] scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AACS-0 01.0 PQ: 0 ANSI: 5
Jun 13 12:03:30 media kernel: [    1.709033] ata4: SATA link down (SStatus 0 SControl 300)
Jun 13 12:03:30 media kernel: [    1.721490] Driver 'sr' needs updating - please use bus_type methods
Jun 13 12:03:30 media kernel: [    1.730165] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jun 13 12:03:30 media kernel: [    1.730170] Uniform CD-ROM driver Revision: 3.20
Jun 13 12:03:30 media kernel: [    1.736836] sr 0:0:0:0: Attached scsi generic sg0 type 5
Jun 13 12:03:30 media kernel: [    1.736871] scsi 2:0:0:0: Attached scsi generic sg1 type 0
Jun 13 12:03:30 media kernel: [    1.736955] Driver 'sd' needs updating - please use bus_type methods
Jun 13 12:03:30 media kernel: [    1.737076] sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
Jun 13 12:03:30 media kernel: [    1.737091] sd 2:0:0:0: [sda] Write Protect is off
Jun 13 12:03:30 media kernel: [    1.737112] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 13 12:03:30 media kernel: [    1.737195]  sda: sda1 sda2 < sda5 sda6 >
Jun 13 12:03:30 media kernel: [    1.758484] sd 2:0:0:0: [sda] Attached SCSI disk
Jun 13 12:03:30 media kernel: [    1.867021] usb 1-1: new full speed USB device using ohci_hcd and address 2
Jun 13 12:03:30 media kernel: [    2.078170] usb 1-1: configuration #1 chosen from 1 choice
Jun 13 12:03:30 media kernel: [    2.108915] EXT3-fs: INFO: recovery required on readonly filesystem.
Jun 13 12:03:30 media kernel: [    2.108919] EXT3-fs: write access will be enabled during recovery.
Jun 13 12:03:30 media kernel: [    2.341017] usb 1-2: new low speed USB device using ohci_hcd and address 3
Jun 13 12:03:30 media kernel: [    2.526166] usb 1-2: configuration #1 chosen from 1 choice
Jun 13 12:03:30 media kernel: [    2.550597] usbcore: registered new interface driver hiddev
Jun 13 12:03:30 media kernel: [    2.554429] input: BTC USB Multimedia Cordless Kit   as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2:1.0/input/input0
Jun 13 12:03:30 media kernel: [    2.554485] generic-usb 0003:03F0:0B0C.0001: input,hidraw0: USB HID v1.00 Keyboard [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:13.0-2/input0
Jun 13 12:03:30 media kernel: [    2.566989] input: BTC USB Multimedia Cordless Kit   as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2:1.1/input/input1
Jun 13 12:03:30 media kernel: [    2.567122] generic-usb 0003:03F0:0B0C.0002: input,hiddev96,hidraw1: USB HID v1.00 Mouse [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:13.0-2/input1
Jun 13 12:03:30 media kernel: [    2.567147] usbcore: registered new interface driver usbhid
Jun 13 12:03:30 media kernel: [    2.567151] usbhid: v2.6:USB HID core driver
Jun 13 12:03:30 media kernel: [    2.792038] usb 1-3: new full speed USB device using ohci_hcd and address 4
Jun 13 12:03:30 media kernel: [    2.977171] usb 1-3: configuration #1 chosen from 1 choice
Jun 13 12:03:30 media kernel: [    2.990428] Initializing USB Mass Storage driver...
Jun 13 12:03:30 media kernel: [    2.991232] scsi4 : SCSI emulation for USB Mass Storage devices
Jun 13 12:03:30 media kernel: [    2.991920] usbcore: registered new interface driver usb-storage
Jun 13 12:03:30 media kernel: [    2.991924] USB Mass Storage support registered.
Jun 13 12:03:30 media kernel: [    5.093165] kjournald starting.  Commit interval 5 seconds
Jun 13 12:03:30 media kernel: [    5.093187] EXT3-fs: sda1: orphan cleanup on readonly fs
Jun 13 12:03:30 media kernel: [    5.250420] EXT3-fs: sda1: 13 orphan inodes deleted
Jun 13 12:03:30 media kernel: [    5.250422] EXT3-fs: recovery complete.
Jun 13 12:03:30 media kernel: [    5.260440] EXT3-fs: mounted filesystem with writeback data mode.
Jun 13 12:03:30 media kernel: [    7.040208] udev: starting version 141
Jun 13 12:03:30 media kernel: [    7.692523] udev: renamed network interface eth0 to eth1
Jun 13 12:03:30 media kernel: [    7.741362] udev: renamed network interface eth1_rename to eth0
Jun 13 12:03:30 media kernel: [    7.813336] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Jun 13 12:03:30 media kernel: [    7.813381] ACPI: Power Button [PWRF]
Jun 13 12:03:30 media kernel: [    7.813470] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
Jun 13 12:03:30 media kernel: [    7.813495] ACPI: Power Button [PWRB]
Jun 13 12:03:30 media kernel: [    7.882795] processor ACPI_CPU:00: registered as cooling_device1
Jun 13 12:03:30 media kernel: [    7.882801] ACPI: Processor [CPU0] (supports 8 throttling states)
Jun 13 12:03:30 media kernel: [    7.999121] scsi 4:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
Jun 13 12:03:30 media kernel: [    8.005115] scsi 4:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
Jun 13 12:03:30 media kernel: [    8.011114] scsi 4:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
Jun 13 12:03:30 media kernel: [    8.017115] scsi 4:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
Jun 13 12:03:30 media kernel: [    8.017494] sd 4:0:0:0: Attached scsi generic sg2 type 0
Jun 13 12:03:30 media kernel: [    8.017633] sd 4:0:0:1: Attached scsi generic sg3 type 0
Jun 13 12:03:30 media kernel: [    8.017781] sd 4:0:0:2: Attached scsi generic sg4 type 0
Jun 13 12:03:30 media kernel: [    8.017914] sd 4:0:0:3: Attached scsi generic sg5 type 0
Jun 13 12:03:30 media kernel: [    8.020995] input: PC Speaker as /devices/platform/pcspkr/input/input4
Jun 13 12:03:30 media kernel: [    8.021963] skge eth1: enabling interface
Jun 13 12:03:30 media kernel: [    8.029532] sd 4:0:0:0: [sdb] Attached SCSI removable disk
Jun 13 12:03:30 media kernel: [    8.038295] sd 4:0:0:1: [sdc] Attached SCSI removable disk
Jun 13 12:03:30 media kernel: [    8.048820] usblp0: Disabling reads from problematic bidirectional printer
Jun 13 12:03:30 media kernel: [    8.049488] sd 4:0:0:2: [sdd] Attached SCSI removable disk
Jun 13 12:03:30 media kernel: [    8.058177] usblp0: USB Unidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0604
Jun 13 12:03:30 media kernel: [    8.058207] usbcore: registered new interface driver usblp
Jun 13 12:03:30 media kernel: [    8.060310] sd 4:0:0:3: [sde] Attached SCSI removable disk
Jun 13 12:03:30 media kernel: [    8.113349] ACPI Error (hwvalid-0154): Illegal I/O port address/length above 64K: 0x0000000000400020/4 [20090320]
Jun 13 12:03:30 media kernel: [    8.113359] ACPI Exception (evregion-0422): AE_LIMIT, Returned by Handler for [SystemIO] [20090320]
Jun 13 12:03:30 media kernel: [    8.113366] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L09] (Node ffff88003b812500), AE_LIMIT
Jun 13 12:03:30 media kernel: [    8.113412] ACPI Exception (evgpe-0568): AE_LIMIT, while evaluating GPE method [_L09] [20090320]
Jun 13 12:03:30 media kernel: [    8.332221] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Jun 13 12:03:30 media kernel: [    8.695996] ATI IXP AC97 controller 0000:00:14.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jun 13 12:03:30 media kernel: [    8.972033] i2c-adapter i2c-0: Found a DME1737 chip at 0x2e (rev 0x8a).
Jun 13 12:03:30 media kernel: [    8.976060] dme1737 0-002e: Optional features: pwm3=yes, pwm5=no, pwm6=no, fan3=no, fan4=yes, fan5=no, fan6=no.
Jun 13 12:03:30 media kernel: [    9.786794] Adding 891568k swap on /dev/sda5.  Priority:-1 extents:1 across:891568k
Jun 13 12:03:30 media kernel: [   10.612835] NET: Registered protocol family 10
Jun 13 12:03:30 media kernel: [   10.612990] lo: Disabled Privacy Extensions
Jun 13 12:03:30 media kernel: [   10.613089] ADDRCONF(NETDEV_UP): eth1: link is not ready
Jun 13 12:03:30 media kernel: [   10.707612] EXT3 FS on sda1, internal journal
Jun 13 12:03:30 media kernel: [   11.797394] skge eth1: Link is up at 1000 Mbps, full duplex, flow control both
Jun 13 12:03:30 media kernel: [   11.797394] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
Jun 13 12:03:30 media kernel: [   20.551931] JFS: nTxBlock = 7512, nTxLock = 60100
Jun 13 12:03:41 media kernel: [   54.139110] RPC: Registered udp transport module.
Jun 13 12:03:41 media kernel: [   54.139114] RPC: Registered tcp transport module.
Jun 13 12:03:41 media kernel: [   54.263215] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Jun 13 12:03:41 media kernel: [   54.377539] svc: failed to register lockdv1 RPC service (errno 97).
Jun 13 12:03:41 media kernel: [   54.377969] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Jun 13 12:03:41 media kernel: [   54.420426] NFSD: starting 90-second grace period
Jun 13 12:03:46 media squid[5980]: Squid Parent: child process 5982 started
Jun 13 12:03:48 media kernel: [   61.259788] pci 0000:01:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jun 13 12:03:48 media kernel: [   61.357935] [drm] Initialized drm 1.1.0 20060810
Jun 13 12:03:48 media kernel: [   61.429341] [drm] Initialized radeon 1.30.0 20080528 for 0000:01:05.0 on minor 0
Jun 13 12:03:49 media kernel: [   62.012024] [drm] Setting GART location based on new memory map
Jun 13 12:03:49 media kernel: [   62.012508] [drm] Loading R300 Microcode
Jun 13 12:03:49 media kernel: [   62.012529] [drm] Num pipes: 4
Jun 13 12:03:49 media kernel: [   62.012537] [drm] writeback test succeeded in 1 usecs
Jun 13 12:16:27 media kernel: [  819.771775] ACPI Error (hwvalid-0154): Illegal I/O port address/length above 64K: 0x0000000000400020/4 [20090320]
Jun 13 12:16:27 media kernel: [  819.771784] ACPI Exception (evregion-0422): AE_LIMIT, Returned by Handler for [SystemIO] [20090320]
Jun 13 12:16:27 media kernel: [  819.771791] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L09] (Node ffff88003b812500), AE_LIMIT
Jun 13 12:16:27 media kernel: [  819.771837] ACPI Exception (evgpe-0568): AE_LIMIT, while evaluating GPE method [_L09] [20090320]
Jun 13 12:16:27 media kernel: [  820.692197] cdrom: sr0: mrw address space DMA selected
Jun 13 12:16:28 media kernel: [  820.749562] cdrom: sr0: mrw address space DMA selected
Jun 13 12:16:28 media kernel: [  820.978766] UDF-fs: Partition marked readonly; forcing readonly mount
Jun 13 12:16:28 media kernel: [  821.012452] UDF-fs INFO UDF: Mounting volume 'LES_MISERABLES', timestamp 1999/09/13 17:39 (1000)
Jun 13 12:17:16 media kernel: [  869.585387] ACPI Error (hwvalid-0154): Illegal I/O port address/length above 64K: 0x0000000000400020/4 [20090320]
Jun 13 12:17:16 media kernel: [  869.585396] ACPI Exception (evregion-0422): AE_LIMIT, Returned by Handler for [SystemIO] [20090320]
Jun 13 12:17:16 media kernel: [  869.585403] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L09] (Node ffff88003b812500), AE_LIMIT
Jun 13 12:17:16 media kernel: [  869.585449] ACPI Exception (evgpe-0568): AE_LIMIT, while evaluating GPE method [_L09] [20090320]
Jun 13 12:17:22 media kernel: [  874.784387] ACPI Error (hwvalid-0154): Illegal I/O port address/length above 64K: 0x0000000000400020/4 [20090320]
Jun 13 12:17:22 media kernel: [  874.784397] ACPI Exception (evregion-0422): AE_LIMIT, Returned by Handler for [SystemIO] [20090320]
Jun 13 12:17:22 media kernel: [  874.784404] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L09] (Node ffff88003b812500), AE_LIMIT
Jun 13 12:17:22 media kernel: [  874.784450] ACPI Exception (evgpe-0568): AE_LIMIT, while evaluating GPE method [_L09] [20090320]
Jun 13 12:17:23 media kernel: [  875.723378] ACPI Error (hwvalid-0154): Illegal I/O port address/length above 64K: 0x0000000000400020/4 [20090320]
Jun 13 12:17:23 media kernel: [  875.723387] ACPI Exception (evregion-0422): AE_LIMIT, Returned by Handler for [SystemIO] [20090320]
Jun 13 12:17:23 media kernel: [  875.723394] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L09] (Node ffff88003b812500), AE_LIMIT
Jun 13 12:17:23 media kernel: [  875.723440] ACPI Exception (evgpe-0568): AE_LIMIT, while evaluating GPE method [_L09] [20090320]
Jun 13 12:17:23 media kernel: [  875.768525] ACPI Error (hwvalid-0154): Illegal I/O port address/length above 64K: 0x0000000000400020/4 [20090320]
Jun 13 12:17:23 media kernel: [  875.768532] ACPI Exception (evregion-0422): AE_LIMIT, Returned by Handler for [SystemIO] [20090320]
Jun 13 12:17:23 media kernel: [  875.768538] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L09] (Node ffff88003b812500), AE_LIMIT
Jun 13 12:17:23 media kernel: [  875.768582] ACPI Exception (evgpe-0568): AE_LIMIT, while evaluating GPE method [_L09] [20090320]

--Boundary-00=_tE5MKyFEO8SdGrV--
