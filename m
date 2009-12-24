Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZLXCdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZLXCdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 21:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZLXCc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 21:32:59 -0500
Received: from mail.crca.org.au ([67.207.131.56]:46490 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZLXCc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 21:32:57 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B32D2D6.3030707@crca.org.au>
Date: Thu, 24 Dec 2009 13:32:54 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
References: <200912210140.19713.rjw@sisk.pl> <4B2F22EF.6040500@crca.org.au> <200912232146.29339.rjw@sisk.pl>
In-Reply-To: <200912232146.29339.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------060802040905000902000807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060802040905000902000807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi.

I built the async branch of your tree and tested it, also running
2.6.33-rc1 + TuxOnIce for comparison. Dmesg for both are attached. Is
there anything I can/should be doing for you on top of this? I'll try
Dmitry's patch on top of this a little later - other things to do first.

I noticed that you were doing standard deviations in your stats - how
many runs were you basing them on? Not sure that I can be bothered to do
too many - too much else to do!

Regards,

Nigel

--------------060802040905000902000807
Content-Type: text/plain;
 name="m1530-sync.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="m1530-sync.dmesg"

[    0.000000] Linux version 2.6.33-rc1 (nigel@nigel-laptop) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #1 SMP PREEMPT Wed Dec 23 19:41:03 EST 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/head ro root=/dev/sda2 quiet vga=794 init S
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfe72000 (usable)
[    0.000000]  BIOS-e820: 00000000dfe72000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 0DFF00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfe72 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfe72000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfe72000 page 4k
[    0.000000] kernel direct mapping tables up to dfe72000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ c000-12000
[    0.000000] RAMDISK: 36894000 - 37fefea0
[    0.000000] ACPI: RSDP 00000000000fbc80 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000dfe73a00 00064 (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: FACP 00000000dfe7389c 000F4 (v04 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: DSDT 00000000dfe74000 04BC2 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000dfe82800 00040
[    0.000000] ACPI: HPET 00000000dfe73b00 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000dfe73c00 00068 (v01 DELL    M08     27D8070E ASL  00000047)
[    0.000000] ACPI: MCFG 00000000dfe73bc0 0003E (v16 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: SLIC 00000000dfe73c9c 00176 (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: OSFR 00000000dfe73200 0002C (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: BOOT 00000000dfe737c0 00028 (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: SSDT 00000000dfe721c0 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0001b56814]    TEXT DATA BSS ==> [0001000000 - 0001b56814]
[    0.000000]   #2 [0036894000 - 0037fefea0]          RAMDISK ==> [0036894000 - 0037fefea0]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [0001b57000 - 0001b571ec]              BRK ==> [0001b57000 - 0001b571ec]
[    0.000000]   #5 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #6 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #7 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #8 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfe72
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048081
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 109 pages reserved
[    0.000000]   DMA zone: 3834 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898730 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfe72000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:14000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880028200000 s76696 r8192 d21608 u1048576
[    0.000000] pcpu-alloc: s76696 r8192 d21608 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1031844
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/head ro root=/dev/sda2 quiet vga=794 init S
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4023868k/4718592k available (4396k kernel code, 526268k absent, 167464k reserved, 4268k data, 476k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.490 MHz processor.
[    0.010006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.98 BogoMIPS (lpj=21944900)
[    0.010045] Security Framework initialized
[    0.010066] Mount-cache hash table entries: 256
[    0.010202] CPU: Physical Processor ID: 0
[    0.010204] CPU: Processor Core ID: 0
[    0.010206] mce: CPU supports 6 MCE banks
[    0.010214] CPU0: Thermal monitoring enabled (TM2)
[    0.010217] using mwait in idle threads.
[    0.010218] Performance Events: Core2 events, Intel PMU driver.
[    0.010223] ... version:                2
[    0.010225] ... bit width:              40
[    0.010226] ... generic registers:      2
[    0.010227] ... value mask:             000000ffffffffff
[    0.010228] ... max period:             000000007fffffff
[    0.010230] ... fixed-purpose events:   3
[    0.010231] ... event mask:             0000000700000003
[    0.011014] ACPI: Core revision 20091214
[    0.024913] Setting APIC routing to flat
[    0.025292] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.125311] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.160022] Booting Node   0, Processors  #1 Ok.
[    0.330030] Brought up 2 CPUs
[    0.330033] Total of 2 processors activated (8777.95 BogoMIPS).
[    0.350067] PM: Adding info for No Bus:platform
[    0.350109] NET: Registered protocol family 16
[    0.350136] PM: Adding info for No Bus:vtcon0
[    0.350136] ACPI: bus type pci registered
[    0.350136] PM: Adding info for No Bus:id
[    0.350136] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.350136] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.352082] PCI: Using configuration type 1 for base access
[    0.352104] PM: Adding info for No Bus:default
[    0.352104] bio: create slab <bio-0> at 0
[    0.370937] ACPI: EC: Look up EC in DSDT
[    0.391033] ACPI: Interpreter enabled
[    0.391037] ACPI: (supports S0 S3 S4 S5)
[    0.391055] ACPI: Using IOAPIC for interrupt routing
[    0.391104] PM: Adding info for acpi:LNXSYSTM:00
[    0.391104] PM: Adding info for acpi:LNXCPU:00
[    0.391104] PM: Adding info for acpi:LNXCPU:01
[    0.391104] PM: Adding info for acpi:LNXSYBUS:00
[    0.391104] PM: Adding info for acpi:PNP0A03:00
[    0.391104] PM: Adding info for acpi:device:00
[    0.391104] PM: Adding info for acpi:PNP0C02:00
[    0.391104] PM: Adding info for acpi:PNP0F13:00
[    0.391104] PM: Adding info for acpi:PNP0303:00
[    0.391104] PM: Adding info for acpi:PNP0B00:00
[    0.391104] PM: Adding info for acpi:PNP0100:00
[    0.391104] PM: Adding info for acpi:PNP0800:00
[    0.391104] PM: Adding info for acpi:PNP0C01:00
[    0.391104] PM: Adding info for acpi:PNP0000:00
[    0.391104] PM: Adding info for acpi:PNP0200:00
[    0.391104] PM: Adding info for acpi:PNP0C04:00
[    0.391104] PM: Adding info for acpi:PNP0103:00
[    0.391104] PM: Adding info for acpi:device:01
[    0.391104] PM: Adding info for acpi:device:02
[    0.391104] PM: Adding info for acpi:device:03
[    0.394481] PM: Adding info for acpi:device:04
[    0.394499] PM: Adding info for acpi:device:05
[    0.394499] PM: Adding info for acpi:device:06
[    0.394499] PM: Adding info for acpi:device:07
[    0.401126] PM: Adding info for acpi:device:08
[    0.401144] PM: Adding info for acpi:device:09
[    0.401144] PM: Adding info for acpi:device:0a
[    0.401144] PM: Adding info for acpi:device:0b
[    0.404431] PM: Adding info for acpi:device:0c
[    0.404450] PM: Adding info for acpi:device:0d
[    0.404450] PM: Adding info for acpi:device:0e
[    0.404450] PM: Adding info for acpi:device:0f
[    0.410141] PM: Adding info for acpi:device:10
[    0.410161] PM: Adding info for acpi:device:11
[    0.410161] PM: Adding info for acpi:device:12
[    0.410161] PM: Adding info for acpi:device:13
[    0.414503] PM: Adding info for acpi:device:14
[    0.414522] PM: Adding info for acpi:device:15
[    0.414522] PM: Adding info for acpi:device:16
[    0.414522] PM: Adding info for acpi:device:17
[    0.414522] PM: Adding info for acpi:device:18
[    0.414522] PM: Adding info for acpi:device:19
[    0.414522] PM: Adding info for acpi:device:1a
[    0.414522] PM: Adding info for acpi:device:1b
[    0.414522] PM: Adding info for acpi:device:1c
[    0.414522] PM: Adding info for acpi:device:1d
[    0.424102] PM: Adding info for acpi:device:1e
[    0.424120] PM: Adding info for acpi:device:1f
[    0.424120] PM: Adding info for acpi:device:20
[    0.424120] PM: Adding info for acpi:device:21
[    0.424120] PM: Adding info for acpi:device:22
[    0.424120] PM: Adding info for acpi:device:23
[    0.424120] PM: Adding info for acpi:device:24
[    0.424120] PM: Adding info for acpi:device:25
[    0.424120] PM: Adding info for acpi:device:26
[    0.424120] PM: Adding info for acpi:device:27
[    0.424120] PM: Adding info for acpi:device:28
[    0.424120] PM: Adding info for acpi:device:29
[    0.424120] PM: Adding info for acpi:device:2a
[    0.424120] PM: Adding info for acpi:device:2b
[    0.424120] PM: Adding info for acpi:device:2c
[    0.424120] PM: Adding info for acpi:device:2d
[    0.424120] PM: Adding info for acpi:LNXVIDEO:00
[    0.424120] PM: Adding info for acpi:device:2e
[    0.424120] PM: Adding info for acpi:device:2f
[    0.424120] PM: Adding info for acpi:device:30
[    0.424120] PM: Adding info for acpi:device:31
[    0.424120] PM: Adding info for acpi:PNP0C01:01
[    0.424120] PM: Adding info for acpi:PNP0C01:02
[    0.424120] PM: Adding info for acpi:device:32
[    0.424120] PM: Adding info for acpi:device:33
[    0.424120] PM: Adding info for acpi:device:34
[    0.424120] PM: Adding info for acpi:device:35
[    0.424120] PM: Adding info for acpi:device:36
[    0.424120] PM: Adding info for acpi:device:37
[    0.424120] PM: Adding info for acpi:device:38
[    0.424120] PM: Adding info for acpi:device:39
[    0.424120] PM: Adding info for acpi:device:3a
[    0.424120] PM: Adding info for acpi:device:3b
[    0.424120] PM: Adding info for acpi:device:3c
[    0.424120] PM: Adding info for acpi:device:3d
[    0.424120] PM: Adding info for acpi:PNP0C0F:00
[    0.424120] PM: Adding info for acpi:PNP0C0F:01
[    0.424120] PM: Adding info for acpi:PNP0C0F:02
[    0.424120] PM: Adding info for acpi:PNP0C0F:03
[    0.424120] PM: Adding info for acpi:PNP0C0F:04
[    0.424120] PM: Adding info for acpi:PNP0C0F:05
[    0.424120] PM: Adding info for acpi:PNP0C0F:06
[    0.424120] PM: Adding info for acpi:PNP0C0F:07
[    0.424120] PM: Adding info for acpi:PNP0C01:03
[    0.424120] PM: Adding info for acpi:PNP0C0D:00
[    0.432140] PM: Adding info for acpi:PNP0C0C:00
[    0.432157] PM: Adding info for acpi:PNP0C0E:00
[    0.432157] PM: Adding info for acpi:ACPI0003:00
[    0.432157] PM: Adding info for acpi:PNP0C0A:00
[    0.432157] PM: Adding info for acpi:PNP0C32:00
[    0.432157] PM: Adding info for acpi:pnp0c14:00
[    0.432157] PM: Adding info for acpi:LNXTHERM:00
[    0.432157] PM: Adding info for acpi:LNXTHERM:01
[    0.432157] ACPI: No dock devices found.
[    0.447455] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.447468] PM: Adding info for No Bus:pci0000:00
[    0.447476] PM: Adding info for No Bus:0000:00
[    0.447494] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.476379] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.476382] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.476384] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.476387] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.476389] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf3ffffff] (ignored)
[    0.476391] pci_root PNP0A03:00: host bridge window [mem 0xf8000000-0xfebfffff] (ignored)
[    0.476394] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff] (ignored)
[    0.476396] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff] (ignored)
[    0.476398] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff] (ignored)
[    0.476400] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff] (ignored)
[    0.476403] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff] (ignored)
[    0.476405] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff] (ignored)
[    0.476407] pci_root PNP0A03:00: host bridge window [mem 0x120000000-0x317ffffff] (ignored)
[    0.476486] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.476489] pci 0000:00:01.0: PME# disabled
[    0.476577] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    0.476642] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    0.476706] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.476771] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.476776] pci 0000:00:1a.7: PME# disabled
[    0.476822] pci 0000:00:1b.0: reg 10: [mem 0xfebfc000-0xfebfffff 64bit]
[    0.476885] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.476889] pci 0000:00:1b.0: PME# disabled
[    0.476987] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.476992] pci 0000:00:1c.0: PME# disabled
[    0.477093] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.477098] pci 0000:00:1c.1: PME# disabled
[    0.477202] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.477207] pci 0000:00:1c.4: PME# disabled
[    0.477271] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    0.477335] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    0.477401] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.477463] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.477528] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.477533] pci 0000:00:1d.7: PME# disabled
[    0.477700] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.477704] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    0.477709] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    0.477712] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 006c (mask 0007)
[    0.477716] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    0.477770] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.477778] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.477786] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.477794] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.477801] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    0.477865] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    0.477873] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    0.477880] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    0.477888] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    0.477896] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    0.477903] pci 0000:00:1f.2: reg 24: [mem 0xfebfb800-0xfebfbfff]
[    0.477947] pci 0000:00:1f.2: PME# supported from D3hot
[    0.477952] pci 0000:00:1f.2: PME# disabled
[    0.477984] pci 0000:00:1f.3: reg 10: [mem 0xfebfb700-0xfebfb7ff]
[    0.478009] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    0.478076] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.478092] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.478107] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.478116] pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
[    0.478125] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.478232] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.478235] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.478238] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfeafffff]
[    0.478242] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.478305] pci 0000:09:00.0: reg 10: [mem 0xf9ffc000-0xf9ffffff 64bit]
[    0.478316] pci 0000:09:00.0: reg 18: [io  0xde00-0xdeff]
[    0.478406] pci 0000:09:00.0: supports D1 D2
[    0.478408] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.478414] pci 0000:09:00.0: PME# disabled
[    0.478489] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    0.478494] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.478498] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    0.478651] pci 0000:0b:00.0: reg 10: [mem 0xf9eff000-0xf9efffff]
[    0.478895] pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
[    0.478907] pci 0000:0b:00.0: PME# disabled
[    0.479012] pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
[    0.479020] pci 0000:00:1c.1:   bridge window [mem 0xf9e00000-0xf9efffff]
[    0.479086] pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
[    0.479090] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.479095] pci 0000:00:1c.4:   bridge window [mem 0xf9c00000-0xf9dfffff]
[    0.479103] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.479159] pci 0000:03:09.0: reg 10: [mem 0xf9bff800-0xf9bfffff]
[    0.479221] pci 0000:03:09.0: supports D1 D2
[    0.479223] pci 0000:03:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.479228] pci 0000:03:09.0: PME# disabled
[    0.479266] pci 0000:03:09.1: reg 10: [mem 0xf9bff500-0xf9bff5ff]
[    0.479327] pci 0000:03:09.1: supports D1 D2
[    0.479329] pci 0000:03:09.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.479333] pci 0000:03:09.1: PME# disabled
[    0.479372] pci 0000:03:09.2: reg 10: [mem 0xf9bff600-0xf9bff6ff]
[    0.479433] pci 0000:03:09.2: supports D1 D2
[    0.479435] pci 0000:03:09.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.479439] pci 0000:03:09.2: PME# disabled
[    0.479476] pci 0000:03:09.3: reg 10: [mem 0xf9bff700-0xf9bff7ff]
[    0.479538] pci 0000:03:09.3: supports D1 D2
[    0.479540] pci 0000:03:09.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.479544] pci 0000:03:09.3: PME# disabled
[    0.479604] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.479612] pci 0000:00:1e.0:   bridge window [mem 0xf9b00000-0xf9bfffff]
[    0.479647] pci_bus 0000:00: on NUMA node 0
[    0.479651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.479878] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.479985] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.480053] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.480116] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.480185] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.480824] PM: Adding info for pci:0000:00:00.0
[    0.480845] PM: Adding info for pci:0000:00:01.0
[    0.480845] PM: Adding info for pci:0000:00:1a.0
[    0.480845] PM: Adding info for pci:0000:00:1a.1
[    0.480845] PM: Adding info for pci:0000:00:1a.7
[    0.480845] PM: Adding info for pci:0000:00:1b.0
[    0.480845] PM: Adding info for pci:0000:00:1c.0
[    0.480845] PM: Adding info for pci:0000:00:1c.1
[    0.480845] PM: Adding info for pci:0000:00:1c.4
[    0.480845] PM: Adding info for pci:0000:00:1d.0
[    0.480845] PM: Adding info for pci:0000:00:1d.1
[    0.480845] PM: Adding info for pci:0000:00:1d.2
[    0.480845] PM: Adding info for pci:0000:00:1d.7
[    0.480845] PM: Adding info for pci:0000:00:1e.0
[    0.480845] PM: Adding info for pci:0000:00:1f.0
[    0.480845] PM: Adding info for pci:0000:00:1f.1
[    0.490469] PM: Adding info for pci:0000:00:1f.2
[    0.490577] PM: Adding info for pci:0000:00:1f.3
[    0.490595] PM: Adding info for pci:0000:01:00.0
[    0.490595] PM: Adding info for No Bus:0000:01
[    0.490595] PM: Adding info for pci:0000:09:00.0
[    0.490595] PM: Adding info for No Bus:0000:09
[    0.490595] PM: Adding info for pci:0000:0b:00.0
[    0.490595] PM: Adding info for No Bus:0000:0b
[    0.490595] PM: Adding info for No Bus:0000:0c
[    0.490595] PM: Adding info for pci:0000:03:09.0
[    0.490595] PM: Adding info for pci:0000:03:09.1
[    0.490595] PM: Adding info for pci:0000:03:09.2
[    0.490595] PM: Adding info for pci:0000:03:09.3
[    0.490595] PM: Adding info for No Bus:0000:03
[    0.490595] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *7
[    0.490595] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    0.490595] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *5
[    0.490595] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *0, disabled.
[    0.490595] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.490609] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.490716] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.490811] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.490873] PM: Adding info for No Bus:vga_arbiter
[    0.490873] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.490873] vgaarb: loaded
[    0.490873] SCSI subsystem initialized
[    0.510020] libata version 3.00 loaded.
[    0.510062] usbcore: registered new interface driver usbfs
[    0.510062] usbcore: registered new interface driver hub
[    0.510062] usbcore: registered new device driver usb
[    0.510062] PM: Adding info for No Bus:8D9DDCBC-A997-11DA-B012-B622A1EF5492
[    0.510062] PM: Adding info for No Bus:A80593CE-A997-11DA-B012-B622A1EF5492
[    0.510062] PM: Adding info for No Bus:9DBB5994-A997-11DA-B012-B622A1EF5492
[    0.510062] PM: Adding info for No Bus:A3776CE0-1E88-11DB-A98B-0800200C9A66
[    0.510062] PM: Adding info for No Bus:05901221-D566-11D1-B2F0-00A0C9062910
[    0.510062] ACPI: WMI: Mapper loaded
[    0.510062] PCI: Using ACPI for IRQ routing
[    0.510062] PCI: pci_cache_line_size set to 64 bytes
[    0.510191] PM: Adding info for No Bus:lo
[    0.510191] PM: Adding info for No Bus:rfkill
[    0.510191] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.510191] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.510191] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.520008] Switching to clocksource tsc
[    0.540046] pnp: PnP ACPI init
[    0.540054] PM: Adding info for No Bus:pnp0
[    0.540056] ACPI: bus type pnp registered
[    0.554546] PM: Adding info for pnp:00:00
[    0.554623] PM: Adding info for pnp:00:01
[    0.554697] PM: Adding info for pnp:00:02
[    0.554766] PM: Adding info for pnp:00:03
[    0.554833] PM: Adding info for pnp:00:04
[    0.554902] PM: Adding info for pnp:00:05
[    0.554983] PM: Adding info for pnp:00:06
[    0.555052] PM: Adding info for pnp:00:07
[    0.555121] PM: Adding info for pnp:00:08
[    0.555260] PM: Adding info for pnp:00:09
[    0.555507] pnp 00:0a: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.555510] pnp 00:0a: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.555549] PM: Adding info for pnp:00:0a
[    0.555617] pnp 00:0b: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.555620] pnp 00:0b: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.555623] pnp 00:0b: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.555661] PM: Adding info for pnp:00:0b
[    0.574090] PM: Adding info for pnp:00:0c
[    0.574234] pnp: PnP ACPI: found 13 devices
[    0.574236] ACPI: ACPI bus type pnp unregistered
[    0.574244] system 00:01: [mem 0xff800000-0xff8fffff] has been reserved
[    0.574247] system 00:01: [mem 0xffc00000-0xffcfffff] has been reserved
[    0.574253] system 00:06: [io  0x0c80-0x0cff] could not be reserved
[    0.574258] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.574263] system 00:0a: [io  0x0900-0x097f] has been reserved
[    0.574266] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.574272] system 00:0b: [io  0xf400-0xf4fe] has been reserved
[    0.574274] system 00:0b: [io  0x1080-0x10bf] has been reserved
[    0.574277] system 00:0b: [io  0x10c0-0x10df] has been reserved
[    0.574279] system 00:0b: [io  0x0809] has been reserved
[    0.574284] system 00:0c: [mem 0x00000000-0x0009efff] could not be reserved
[    0.574286] system 00:0c: [mem 0x0009f000-0x0009ffff] could not be reserved
[    0.574289] system 00:0c: [mem 0x000c0000-0x000cffff] has been reserved
[    0.574291] system 00:0c: [mem 0x000e0000-0x000fffff] has been reserved
[    0.574294] system 00:0c: [mem 0x00100000-0xdfe71fff] could not be reserved
[    0.574296] system 00:0c: [mem 0xdfe72000-0xdfefffff] has been reserved
[    0.574299] system 00:0c: [mem 0xdff00000-0xdfffffff] has been reserved
[    0.574301] system 00:0c: [mem 0xffe00000-0xffffffff] has been reserved
[    0.574304] system 00:0c: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.574306] system 00:0c: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    0.574309] system 00:0c: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.574311] system 00:0c: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.574314] system 00:0c: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    0.574317] system 00:0c: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    0.574319] system 00:0c: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    0.574321] system 00:0c: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    0.574324] system 00:0c: [mem 0xfed18000-0xfed1bfff] has been reserved
[    0.574326] system 00:0c: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.574390] PM: Adding info for No Bus:mem
[    0.574421] PM: Adding info for No Bus:kmem
[    0.574452] PM: Adding info for No Bus:null
[    0.574483] PM: Adding info for No Bus:port
[    0.574514] PM: Adding info for No Bus:zero
[    0.574547] PM: Adding info for No Bus:full
[    0.574578] PM: Adding info for No Bus:random
[    0.574610] PM: Adding info for No Bus:urandom
[    0.574641] PM: Adding info for No Bus:kmsg
[    0.594583] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.594587] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.594590] pci 0000:00:1c.1: BAR 7: assigned [io  0x2000-0x2fff]
[    0.594592] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
[    0.594595] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.594597] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.594601] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfeafffff]
[    0.594604] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.594609] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    0.594612] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.594618] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    0.594623] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.594631] pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
[    0.594635] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.594641] pci 0000:00:1c.1:   bridge window [mem 0xf9e00000-0xf9efffff]
[    0.594646] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.594654] pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
[    0.594657] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.594663] pci 0000:00:1c.4:   bridge window [mem 0xf9c00000-0xf9dfffff]
[    0.594668] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.594676] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.594678] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.594684] pci 0000:00:1e.0:   bridge window [mem 0xf9b00000-0xf9bfffff]
[    0.594689] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.594705] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.594708] pci 0000:00:01.0: setting latency timer to 64
[    0.594718] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.594722] pci 0000:00:1c.0: setting latency timer to 64
[    0.594733] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.594738] pci 0000:00:1c.1: setting latency timer to 64
[    0.594748] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.594752] pci 0000:00:1c.4: setting latency timer to 64
[    0.594760] pci 0000:00:1e.0: setting latency timer to 64
[    0.594764] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.594766] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.594769] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.594770] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfeafffff]
[    0.594773] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.594775] pci_bus 0000:09: resource 0 [io  0xd000-0xdfff]
[    0.594777] pci_bus 0000:09: resource 1 [mem 0xf9f00000-0xf9ffffff]
[    0.594779] pci_bus 0000:09: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.594781] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    0.594783] pci_bus 0000:0b: resource 1 [mem 0xf9e00000-0xf9efffff]
[    0.594785] pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.594787] pci_bus 0000:0c: resource 0 [io  0xc000-0xcfff]
[    0.594789] pci_bus 0000:0c: resource 1 [mem 0xf9c00000-0xf9dfffff]
[    0.594791] pci_bus 0000:0c: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.594794] pci_bus 0000:03: resource 1 [mem 0xf9b00000-0xf9bfffff]
[    0.594796] pci_bus 0000:03: resource 3 [io  0x0000-0xffff]
[    0.594798] pci_bus 0000:03: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.594833] NET: Registered protocol family 2
[    0.594886] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.595363] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.597164] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.597755] TCP: Hash tables configured (established 262144 bind 65536)
[    0.597757] TCP reno registered
[    0.597761] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.597799] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.597935] NET: Registered protocol family 1
[    0.597962] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.597964] pci 0000:00:1a.0: Performing full reset
[    0.597986] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.597987] pci 0000:00:1a.1: Performing full reset
[    0.598056] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.598057] pci 0000:00:1d.0: Performing full reset
[    0.598078] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.598080] pci 0000:00:1d.1: Performing full reset
[    0.598100] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
[    0.598102] pci 0000:00:1d.2: Performing full reset
[    0.598171] pci 0000:01:00.0: Boot video device
[    0.598236] PCI: CLS 64 bytes, default 64
[    0.598294] Unpacking initramfs...
[    0.828377] Freeing initrd memory: 23919k freed
[    0.841057] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.841062] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.841064] software IO TLB at phys 0x20000000 - 0x24000000
[    0.841253] Simple Boot Flag at 0x79 set to 0x1
[    0.841695] PM: Adding info for No Bus:mcelog
[    0.841774] PM: Adding info for No Bus:msr0
[    0.841810] PM: Adding info for No Bus:msr1
[    0.841877] PM: Adding info for No Bus:cpu0
[    0.841914] PM: Adding info for No Bus:cpu1
[    0.842007] PM: Adding info for platform:pcspkr
[    0.842234] PM: Adding info for No Bus:snapshot
[    0.842265] audit: initializing netlink socket (disabled)
[    0.842279] type=2000 audit(1261648936.830:1): initialized
[    0.842593] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.860093] VFS: Disk quotas dquot_6.5.2
[    0.860117] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.860251] NTFS driver 2.1.29 [Flags: R/O].
[    0.860278] fuse init (API version 7.13)
[    0.860297] PM: Adding info for No Bus:fuse
[    0.860339] msgmni has been set to 7907
[    0.880168] alg: No test for stdrng (krng)
[    0.880177] io scheduler noop registered (default)
[    0.880178] io scheduler deadline registered
[    0.880189] io scheduler cfq registered
[    0.880299] pcieport 0000:00:01.0: setting latency timer to 64
[    0.880331] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.880341] PM: Adding info for pci_express:0000:00:01.0:pcie01
[    0.880373] PM: Adding info for pci_express:0000:00:01.0:pcie04
[    0.880405] PM: Adding info for pci_express:0000:00:01.0:pcie08
[    0.880464] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.880517] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.880531] PM: Adding info for pci_express:0000:00:1c.0:pcie01
[    0.880562] PM: Adding info for pci_express:0000:00:1c.0:pcie04
[    0.880593] PM: Adding info for pci_express:0000:00:1c.0:pcie08
[    0.880679] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.880733] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
[    0.880747] PM: Adding info for pci_express:0000:00:1c.1:pcie01
[    0.880779] PM: Adding info for pci_express:0000:00:1c.1:pcie04
[    0.880811] PM: Adding info for pci_express:0000:00:1c.1:pcie08
[    0.880894] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.880948] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    0.880961] PM: Adding info for pci_express:0000:00:1c.4:pcie01
[    0.880992] PM: Adding info for pci_express:0000:00:1c.4:pcie04
[    0.881025] PM: Adding info for pci_express:0000:00:1c.4:pcie08
[    0.881194] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.881204] PM: Adding info for No Bus:fbcon
[    0.881267] PM: Adding info for platform:vesafb.0
[    0.881397] vesafb: framebuffer at 0xfb000000, mapped to 0xffffc90004100000, using 2560k, total 2560k
[    0.881400] vesafb: mode is 1280x1024x16, linelength=2560, pages=0
[    0.881401] vesafb: scrolling: redraw
[    0.881404] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.881417] PM: Adding info for No Bus:fb0
[    0.881478] PM: Adding info for No Bus:vtcon1
[    0.921216] Console: switching to colour frame buffer device 160x64
[    0.958175] fb0: VESA VGA frame buffer device
[    0.958733] ACPI: SSDT 00000000dfe72cf6 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.959222] ACPI: SSDT 00000000dfe7268c 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.959994] Monitor-Mwait will be used to enter C-1 state
[    0.969988] Monitor-Mwait will be used to enter C-2 state
[    0.979988] Monitor-Mwait will be used to enter C-3 state
[    0.979992] Marking TSC unstable due to TSC halts in idle
[    0.980062] PM: Adding info for No Bus:cooling_device0
[    0.980075] Switching to clocksource hpet
[    0.980420] ACPI: SSDT 00000000dfe72f7c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.980754] ACPI: SSDT 00000000dfe72c71 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.981273] PM: Adding info for No Bus:cooling_device1
[    0.984709] PM: Adding info for No Bus:thermal_zone0
[    0.984828] thermal LNXTHERM:01: registered as thermal_zone0
[    0.984835] ACPI: Thermal Zone [THM] (68 C)
[    0.984894] PM: Adding info for No Bus:tty
[    0.984933] PM: Adding info for No Bus:console
[    0.984974] PM: Adding info for No Bus:tty0
[    0.985043] PM: Adding info for No Bus:vcs
[    0.985079] PM: Adding info for No Bus:vcsa
[    0.985115] PM: Adding info for No Bus:vcs1
[    0.985153] PM: Adding info for No Bus:vcsa1
[    0.985191] PM: Adding info for No Bus:tty1
[    0.985228] PM: Adding info for No Bus:tty2
[    0.985265] PM: Adding info for No Bus:tty3
[    0.985302] PM: Adding info for No Bus:tty4
[    0.985339] PM: Adding info for No Bus:tty5
[    0.985377] PM: Adding info for No Bus:tty6
[    0.985415] PM: Adding info for No Bus:tty7
[    0.985452] PM: Adding info for No Bus:tty8
[    0.985490] PM: Adding info for No Bus:tty9
[    0.985527] PM: Adding info for No Bus:tty10
[    0.985565] PM: Adding info for No Bus:tty11
[    0.985604] PM: Adding info for No Bus:tty12
[    0.985642] PM: Adding info for No Bus:tty13
[    0.985680] PM: Adding info for No Bus:tty14
[    0.985719] PM: Adding info for No Bus:tty15
[    0.985758] PM: Adding info for No Bus:tty16
[    0.985797] PM: Adding info for No Bus:tty17
[    0.985837] PM: Adding info for No Bus:tty18
[    0.985876] PM: Adding info for No Bus:tty19
[    0.985915] PM: Adding info for No Bus:tty20
[    0.985953] PM: Adding info for No Bus:tty21
[    0.985992] PM: Adding info for No Bus:tty22
[    0.986032] PM: Adding info for No Bus:tty23
[    0.986071] PM: Adding info for No Bus:tty24
[    0.986110] PM: Adding info for No Bus:tty25
[    0.986150] PM: Adding info for No Bus:tty26
[    0.986190] PM: Adding info for No Bus:tty27
[    0.986230] PM: Adding info for No Bus:tty28
[    0.986270] PM: Adding info for No Bus:tty29
[    0.986310] PM: Adding info for No Bus:tty30
[    0.986350] PM: Adding info for No Bus:tty31
[    0.986390] PM: Adding info for No Bus:tty32
[    0.986429] PM: Adding info for No Bus:tty33
[    0.986469] PM: Adding info for No Bus:tty34
[    0.986509] PM: Adding info for No Bus:tty35
[    0.986550] PM: Adding info for No Bus:tty36
[    0.986589] PM: Adding info for No Bus:tty37
[    0.986629] PM: Adding info for No Bus:tty38
[    0.986669] PM: Adding info for No Bus:tty39
[    0.986710] PM: Adding info for No Bus:tty40
[    0.986751] PM: Adding info for No Bus:tty41
[    0.986793] PM: Adding info for No Bus:tty42
[    0.986834] PM: Adding info for No Bus:tty43
[    0.986874] PM: Adding info for No Bus:tty44
[    0.986917] PM: Adding info for No Bus:tty45
[    0.986958] PM: Adding info for No Bus:tty46
[    0.987000] PM: Adding info for No Bus:tty47
[    0.987044] PM: Adding info for No Bus:tty48
[    0.987085] PM: Adding info for No Bus:tty49
[    0.987126] PM: Adding info for No Bus:tty50
[    0.987167] PM: Adding info for No Bus:tty51
[    0.987208] PM: Adding info for No Bus:tty52
[    0.987250] PM: Adding info for No Bus:tty53
[    0.987292] PM: Adding info for No Bus:tty54
[    0.987334] PM: Adding info for No Bus:tty55
[    0.987377] PM: Adding info for No Bus:tty56
[    0.987419] PM: Adding info for No Bus:tty57
[    0.987461] PM: Adding info for No Bus:tty58
[    0.987502] PM: Adding info for No Bus:tty59
[    0.987546] PM: Adding info for No Bus:tty60
[    0.987588] PM: Adding info for No Bus:tty61
[    0.987630] PM: Adding info for No Bus:tty62
[    0.987673] PM: Adding info for No Bus:tty63
[    0.987736] PM: Adding info for No Bus:ptmx
[    0.987786] PM: Adding info for No Bus:hpet
[    0.987937] PM: Adding info for No Bus:nvram
[    0.987972] Non-volatile memory driver v1.3
[    0.987974] Linux agpgart interface v0.103
[    0.988116] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.988137] PM: Adding info for platform:serial8250
[    0.988197] PM: Adding info for No Bus:ttyS0
[    0.988252] PM: Adding info for No Bus:ttyS1
[    0.988304] PM: Adding info for No Bus:ttyS2
[    0.988358] PM: Adding info for No Bus:ttyS3
[    0.988899] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    0.988940] sky2 driver version 1.26
[    0.988969] sky2 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.988982] sky2 0000:09:00.0: setting latency timer to 64
[    0.989015] sky2 0000:09:00.0: Yukon-2 FE+ chip revision 0
[    0.989132] sky2 0000:09:00.0: irq 28 for MSI/MSI-X
[    0.989227] PM: Adding info for No Bus:eth0
[    0.989384] sky2 eth0: addr 00:15:c5:83:3e:24
[    0.989449] console [netcon0] enabled
[    0.989450] netconsole: network logging started
[    0.989463] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.989465] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    0.989489] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.989499] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.989502] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.989509] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.989517] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    0.989521] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    0.989553] ehci_hcd 0000:00:1a.7: debug port 1
[    0.989558] ehci_hcd 0000:00:1a.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    0.993427] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.993429] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.993442] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    0.993447] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.997324] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.022515] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.022538] usb usb1: default language 0x0409
[    1.022544] usb usb1: udev 1, busnum 1, minor = 0
[    1.022546] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.022548] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.022550] usb usb1: Product: EHCI Host Controller
[    1.022551] usb usb1: Manufacturer: Linux 2.6.33-rc1 ehci_hcd
[    1.022553] usb usb1: SerialNumber: 0000:00:1a.7
[    1.022578] PM: Adding info for usb:usb1
[    1.022587] usb usb1: uevent
[    1.022623] usb usb1: usb_probe_device
[    1.022625] usb usb1: configuration #1 chosen from 1 choice
[    1.022632] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.022641] PM: Adding info for usb:1-0:1.0
[    1.022645] usb 1-0:1.0: uevent
[    1.022678] hub 1-0:1.0: usb_probe_interface
[    1.022680] hub 1-0:1.0: usb_probe_interface - got id
[    1.022681] hub 1-0:1.0: USB hub found
[    1.022686] hub 1-0:1.0: 4 ports detected
[    1.022687] hub 1-0:1.0: standalone hub
[    1.022688] hub 1-0:1.0: no power switching (usb 1.0)
[    1.022690] hub 1-0:1.0: individual port over-current protection
[    1.022692] hub 1-0:1.0: power on to power good time: 20ms
[    1.022696] hub 1-0:1.0: local power source is good
[    1.022698] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.022723] PM: Adding info for No Bus:ep_81
[    1.022732] PM: Adding info for No Bus:ep_00
[    1.022751] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.022761] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.022764] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.022769] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.022776] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    1.022780] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    1.022806] ehci_hcd 0000:00:1d.7: debug port 1
[    1.022810] ehci_hcd 0000:00:1d.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    1.026690] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.026691] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.026703] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    1.026707] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.030587] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.042516] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.042545] usb usb2: default language 0x0409
[    1.042551] usb usb2: udev 1, busnum 2, minor = 128
[    1.042553] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.042555] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.042557] usb usb2: Product: EHCI Host Controller
[    1.042558] usb usb2: Manufacturer: Linux 2.6.33-rc1 ehci_hcd
[    1.042560] usb usb2: SerialNumber: 0000:00:1d.7
[    1.042582] PM: Adding info for usb:usb2
[    1.042590] usb usb2: uevent
[    1.042622] usb usb2: usb_probe_device
[    1.042624] usb usb2: configuration #1 chosen from 1 choice
[    1.042629] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.042639] PM: Adding info for usb:2-0:1.0
[    1.042642] usb 2-0:1.0: uevent
[    1.042674] hub 2-0:1.0: usb_probe_interface
[    1.042676] hub 2-0:1.0: usb_probe_interface - got id
[    1.042677] hub 2-0:1.0: USB hub found
[    1.042683] hub 2-0:1.0: 6 ports detected
[    1.042685] hub 2-0:1.0: standalone hub
[    1.042686] hub 2-0:1.0: no power switching (usb 1.0)
[    1.042687] hub 2-0:1.0: individual port over-current protection
[    1.042689] hub 2-0:1.0: power on to power good time: 20ms
[    1.042692] hub 2-0:1.0: local power source is good
[    1.042694] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.042723] PM: Adding info for No Bus:ep_81
[    1.042733] PM: Adding info for No Bus:ep_00
[    1.042772] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.042774] ohci_hcd: block sizes: ed 80 td 96
[    1.042813] uhci_hcd: USB Universal Host Controller Interface driver
[    1.042837] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.042844] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.042847] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.042851] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.042859] uhci_hcd 0000:00:1a.0: detected 2 ports
[    1.042864] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.042866] uhci_hcd 0000:00:1a.0: Performing full reset
[    1.042882] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    1.042887] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    1.042918] usb usb3: default language 0x0409
[    1.042923] usb usb3: udev 1, busnum 3, minor = 256
[    1.042925] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.042927] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.042929] usb usb3: Product: UHCI Host Controller
[    1.042930] usb usb3: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    1.042932] usb usb3: SerialNumber: 0000:00:1a.0
[    1.042959] PM: Adding info for usb:usb3
[    1.042968] usb usb3: uevent
[    1.043002] usb usb3: usb_probe_device
[    1.043004] usb usb3: configuration #1 chosen from 1 choice
[    1.043010] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.043019] PM: Adding info for usb:3-0:1.0
[    1.043022] usb 3-0:1.0: uevent
[    1.043054] hub 3-0:1.0: usb_probe_interface
[    1.043056] hub 3-0:1.0: usb_probe_interface - got id
[    1.043058] hub 3-0:1.0: USB hub found
[    1.043062] hub 3-0:1.0: 2 ports detected
[    1.043063] hub 3-0:1.0: standalone hub
[    1.043064] hub 3-0:1.0: no power switching (usb 1.0)
[    1.043066] hub 3-0:1.0: individual port over-current protection
[    1.043067] hub 3-0:1.0: power on to power good time: 2ms
[    1.043071] hub 3-0:1.0: local power source is good
[    1.043072] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    1.043085] PM: Adding info for No Bus:ep_81
[    1.043095] PM: Adding info for No Bus:ep_00
[    1.043116] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.043122] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.043125] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.043129] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.043136] uhci_hcd 0000:00:1a.1: detected 2 ports
[    1.043141] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.043142] uhci_hcd 0000:00:1a.1: Performing full reset
[    1.043158] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    1.043170] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    1.043204] usb usb4: default language 0x0409
[    1.043209] usb usb4: udev 1, busnum 4, minor = 384
[    1.043211] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.043213] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.043215] usb usb4: Product: UHCI Host Controller
[    1.043216] usb usb4: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    1.043218] usb usb4: SerialNumber: 0000:00:1a.1
[    1.043239] PM: Adding info for usb:usb4
[    1.043247] usb usb4: uevent
[    1.043280] usb usb4: usb_probe_device
[    1.043282] usb usb4: configuration #1 chosen from 1 choice
[    1.043287] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.043296] PM: Adding info for usb:4-0:1.0
[    1.043299] usb 4-0:1.0: uevent
[    1.043332] hub 4-0:1.0: usb_probe_interface
[    1.043334] hub 4-0:1.0: usb_probe_interface - got id
[    1.043336] hub 4-0:1.0: USB hub found
[    1.043340] hub 4-0:1.0: 2 ports detected
[    1.043341] hub 4-0:1.0: standalone hub
[    1.043342] hub 4-0:1.0: no power switching (usb 1.0)
[    1.043344] hub 4-0:1.0: individual port over-current protection
[    1.043346] hub 4-0:1.0: power on to power good time: 2ms
[    1.043349] hub 4-0:1.0: local power source is good
[    1.043351] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    1.043362] PM: Adding info for No Bus:ep_81
[    1.043372] PM: Adding info for No Bus:ep_00
[    1.043393] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.043399] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.043402] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.043406] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    1.043414] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.043419] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.043420] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.043436] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    1.043440] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    1.043471] usb usb5: default language 0x0409
[    1.043477] usb usb5: udev 1, busnum 5, minor = 512
[    1.043479] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.043481] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.043482] usb usb5: Product: UHCI Host Controller
[    1.043484] usb usb5: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    1.043486] usb usb5: SerialNumber: 0000:00:1d.0
[    1.043506] PM: Adding info for usb:usb5
[    1.043513] usb usb5: uevent
[    1.043549] usb usb5: usb_probe_device
[    1.043551] usb usb5: configuration #1 chosen from 1 choice
[    1.043556] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    1.043566] PM: Adding info for usb:5-0:1.0
[    1.043569] usb 5-0:1.0: uevent
[    1.043602] hub 5-0:1.0: usb_probe_interface
[    1.043603] hub 5-0:1.0: usb_probe_interface - got id
[    1.043605] hub 5-0:1.0: USB hub found
[    1.043609] hub 5-0:1.0: 2 ports detected
[    1.043610] hub 5-0:1.0: standalone hub
[    1.043612] hub 5-0:1.0: no power switching (usb 1.0)
[    1.043613] hub 5-0:1.0: individual port over-current protection
[    1.043615] hub 5-0:1.0: power on to power good time: 2ms
[    1.043618] hub 5-0:1.0: local power source is good
[    1.043620] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    1.043631] PM: Adding info for No Bus:ep_81
[    1.043640] PM: Adding info for No Bus:ep_00
[    1.043657] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.043663] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.043667] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.043671] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    1.043678] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.043682] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.043684] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.043699] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    1.043703] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    1.043735] usb usb6: default language 0x0409
[    1.043740] usb usb6: udev 1, busnum 6, minor = 640
[    1.043742] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.043744] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.043746] usb usb6: Product: UHCI Host Controller
[    1.043748] usb usb6: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    1.043749] usb usb6: SerialNumber: 0000:00:1d.1
[    1.043770] PM: Adding info for usb:usb6
[    1.043778] usb usb6: uevent
[    1.043811] usb usb6: usb_probe_device
[    1.043813] usb usb6: configuration #1 chosen from 1 choice
[    1.043818] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    1.043828] PM: Adding info for usb:6-0:1.0
[    1.043831] usb 6-0:1.0: uevent
[    1.043864] hub 6-0:1.0: usb_probe_interface
[    1.043866] hub 6-0:1.0: usb_probe_interface - got id
[    1.043868] hub 6-0:1.0: USB hub found
[    1.043872] hub 6-0:1.0: 2 ports detected
[    1.043873] hub 6-0:1.0: standalone hub
[    1.043874] hub 6-0:1.0: no power switching (usb 1.0)
[    1.043876] hub 6-0:1.0: individual port over-current protection
[    1.043877] hub 6-0:1.0: power on to power good time: 2ms
[    1.043881] hub 6-0:1.0: local power source is good
[    1.043883] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    1.043894] PM: Adding info for No Bus:ep_81
[    1.043903] PM: Adding info for No Bus:ep_00
[    1.043920] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.043927] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.043930] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.043934] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    1.043942] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.043946] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.043948] uhci_hcd 0000:00:1d.2: Performing full reset
[    1.043963] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    1.043967] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    1.043998] usb usb7: default language 0x0409
[    1.044004] usb usb7: udev 1, busnum 7, minor = 768
[    1.044006] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.044008] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.044009] usb usb7: Product: UHCI Host Controller
[    1.044011] usb usb7: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    1.044013] usb usb7: SerialNumber: 0000:00:1d.2
[    1.044034] PM: Adding info for usb:usb7
[    1.044043] usb usb7: uevent
[    1.044077] usb usb7: usb_probe_device
[    1.044079] usb usb7: configuration #1 chosen from 1 choice
[    1.044083] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    1.044092] PM: Adding info for usb:7-0:1.0
[    1.044096] usb 7-0:1.0: uevent
[    1.044130] hub 7-0:1.0: usb_probe_interface
[    1.044132] hub 7-0:1.0: usb_probe_interface - got id
[    1.044134] hub 7-0:1.0: USB hub found
[    1.044137] hub 7-0:1.0: 2 ports detected
[    1.044139] hub 7-0:1.0: standalone hub
[    1.044140] hub 7-0:1.0: no power switching (usb 1.0)
[    1.044141] hub 7-0:1.0: individual port over-current protection
[    1.044143] hub 7-0:1.0: power on to power good time: 2ms
[    1.044146] hub 7-0:1.0: local power source is good
[    1.044148] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    1.044160] PM: Adding info for No Bus:ep_81
[    1.044169] PM: Adding info for No Bus:ep_00
[    1.044256] usbcore: registered new interface driver usblp
[    1.044258] Initializing USB Mass Storage driver...
[    1.044313] usbcore: registered new interface driver usb-storage
[    1.044315] USB Mass Storage support registered.
[    1.044371] usbcore: registered new interface driver libusual
[    1.044451] usbcore: registered new interface driver usbserial
[    1.044486] USB Serial support registered for generic
[    1.044526] usbcore: registered new interface driver usbserial_generic
[    1.044528] usbserial: USB Serial Driver core
[    1.044562] USB Serial support registered for FTDI USB Serial Device
[    1.044630] usbcore: registered new interface driver ftdi_sio
[    1.044632] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[    1.044666] USB Serial support registered for PocketPC PDA
[    1.044730] usbcore: registered new interface driver ipaq
[    1.044732] ipaq: v0.5:USB PocketPC PDA driver
[    1.044823] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.044843] PM: Adding info for platform:i8042
[    1.055738] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.055743] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.055759] PM: Adding info for serio:serio0
[    1.055795] PM: Adding info for No Bus:mice
[    1.055809] PM: Adding info for serio:serio1
[    1.055845] mice: PS/2 mouse device common for all mice
[    1.056603] PM: Adding info for No Bus:input0
[    1.056645] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    1.056660] PM: Adding info for No Bus:event0
[    1.056724] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    1.056748] rtc_cmos 00:04: RTC can wake from S4
[    1.056766] PM: Adding info for No Bus:rtc0
[    1.056803] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.056835] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.056907] PM: Adding info for platform:coretemp.0
[    1.056973] PM: Adding info for No Bus:hwmon0
[    1.057011] PM: Adding info for platform:coretemp.1
[    1.057054] PM: Adding info for No Bus:hwmon1
[    1.057087] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    1.057126] PM: Adding info for platform:iTCO_wdt
[    1.057192] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    1.057225] PM: Adding info for No Bus:watchdog
[    1.057258] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.057563] cpuidle: using governor ladder
[    1.058059] cpuidle: using governor menu
[    1.058104] sdhci: Secure Digital Host Controller Interface driver
[    1.058105] sdhci: Copyright(c) Pierre Ossman
[    1.058120] sdhci-pci 0000:03:09.1: SDHCI controller found [1180:0822] (rev 22)
[    1.058139] sdhci-pci 0000:03:09.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    1.060184] PM: Adding info for No Bus:mmc0::
[    1.060254] Registered led device: mmc0::
[    1.060263] PM: Adding info for No Bus:mmc0
[    1.061340] mmc0: SDHCI controller on PCI [0000:03:09.1] using DMA
[    1.061373] ricoh-mmc: Ricoh MMC Controller disabling driver
[    1.061375] ricoh-mmc: Copyright(c) Philip Langdale
[    1.061453] PM: Adding info for platform:dell_rbu
[    1.061587] PM: Adding info for platform:dcdbas
[    1.061655] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    1.061802] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    1.061819] PM: Adding info for No Bus:timer
[    1.061898] PM: Adding info for No Bus:seq
[    1.061988] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.062036] HDA Intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[    1.062065] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.079204] PM: Adding info for No Bus:input1
[    1.079366] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.079393] PM: Adding info for No Bus:event1
[    1.122544] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[    1.122548] hub 1-0:1.0: port 1: status 0501 change 0001
[    1.122557] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[    1.122560] hub 1-0:1.0: port 2: status 0501 change 0001
[    1.142604] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[    1.142609] hub 2-0:1.0: port 1: status 0501 change 0001
[    1.142622] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[    1.142627] hub 2-0:1.0: port 2: status 0501 change 0001
[    1.142639] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
[    1.142643] hub 2-0:1.0: port 3: status 0501 change 0001
[    1.142661] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
[    1.142666] hub 2-0:1.0: port 6: status 0501 change 0001
[    1.142681] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    1.142694] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    1.142729] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    1.142743] uhci_hcd 0000:00:1d.0: port 2 portsc 0082,00
[    1.142751] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.142757] uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
[    1.142788] uhci_hcd 0000:00:1d.2: port 2 portsc 008a,00
[    1.222624] hub 1-0:1.0: state 7 ports 4 chg 0006 evt 0000
[    1.222634] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    1.280360] ehci_hcd 0000:00:1a.7: port 1 high speed
[    1.280363] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.340052] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.400236] ehci_hcd 0000:00:1a.7: port 1 high speed
[    1.400242] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.496715] usb 1-1: skipped 1 descriptor after configuration
[    1.496718] usb 1-1: skipped 7 descriptors after interface
[    1.496720] usb 1-1: skipped 1 descriptor after endpoint
[    1.496722] usb 1-1: skipped 19 descriptors after interface
[    1.496724] usb 1-1: skipped 1 descriptor after endpoint
[    1.496918] usb 1-1: default language 0x0409
[    1.497919] usb 1-1: udev 2, busnum 1, minor = 1
[    1.497923] usb 1-1: New USB device found, idVendor=05a9, idProduct=2640
[    1.497926] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.497930] usb 1-1: Product: Laptop Integrated Webcam
[    1.497933] usb 1-1: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
[    1.497978] PM: Adding info for usb:1-1
[    1.497997] usb 1-1: uevent
[    1.498147] usb 1-1: usb_probe_device
[    1.498150] usb 1-1: configuration #1 chosen from 1 choice
[    1.498277] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    1.498300] PM: Adding info for usb:1-1:1.0
[    1.498672] usb 1-1:1.0: uevent
[    1.498822] usbserial_generic 1-1:1.0: usb_probe_interface
[    1.498826] usbserial_generic 1-1:1.0: usb_probe_interface - got id
[    1.498870] PM: Adding info for No Bus:ep_83
[    1.498875] usb 1-1: adding 1-1:1.1 (config #1, interface 1)
[    1.498895] PM: Adding info for usb:1-1:1.1
[    1.498899] usb 1-1:1.1: uevent
[    1.499007] usbserial_generic 1-1:1.1: usb_probe_interface
[    1.499009] usbserial_generic 1-1:1.1: usb_probe_interface - got id
[    1.499029] PM: Adding info for No Bus:ep_00
[    1.499034] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    1.522696] PM: Adding info for No Bus:input2
[    1.522837] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input2
[    1.522849] PM: Adding info for No Bus:mouse0
[    1.522960] PM: Adding info for No Bus:event2
[    1.548341] PM: Adding info for No Bus:input3
[    1.548491] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input3
[    1.548516] PM: Adding info for No Bus:mouse1
[    1.548637] PM: Adding info for No Bus:event3
[    1.550235] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[    1.550241] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[    1.550246] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[    1.610050] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[    1.610076] hub 2-0:1.0: state 7 ports 6 chg 004e evt 0000
[    1.610084] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    1.670249] ehci_hcd 0000:00:1d.7: port 1 high speed
[    1.670255] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.672615] PM: Adding info for No Bus:card0
[    1.672734] PM: Adding info for No Bus:input4
[    1.672834] input: HDA Intel Mic at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[    1.672847] PM: Adding info for No Bus:event4
[    1.672924] PM: Adding info for No Bus:input5
[    1.672992] input: HDA Intel HP Out at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    1.673004] PM: Adding info for No Bus:event5
[    1.673081] PM: Adding info for No Bus:input6
[    1.673150] input: HDA Intel HP Out at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    1.673161] PM: Adding info for No Bus:event6
[    1.673234] PM: Adding info for No Bus:pcmC0D1p
[    1.673310] PM: Adding info for No Bus:pcmC0D0p
[    1.673386] PM: Adding info for No Bus:pcmC0D0c
[    1.673463] PM: Adding info for No Bus:hwC0D2
[    1.673546] PM: Adding info for No Bus:controlC0
[    1.673695] ALSA device list:
[    1.673697]   #0: HDA Intel at 0xfebfc000 irq 29
[    1.673910] TCP cubic registered
[    1.673912] Initializing XFRM netlink socket
[    1.673923] NET: Registered protocol family 17
[    1.674574] PM: Adding info for No Bus:cpu_dma_latency
[    1.674647] PM: Adding info for No Bus:network_latency
[    1.674720] PM: Adding info for No Bus:network_throughput
[    1.674785] TuxOnIce 3.0.99.44 (http://tuxonice.net)
[    1.674830] TuxOnIce: Ignoring late initcall, as requested.
[    1.674832] PM: Resume from disk failed.
[    1.674839] registered taskstats version 1
[    1.675320] rtc_cmos 00:04: setting system clock to 2009-12-24 10:02:18 UTC (1261648938)
[    1.675323] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.675324] EDD information not available.
[    1.675366] Freeing unused kernel memory: 476k freed
[    1.675534] Write protecting the kernel read-only data: 8192k
[    1.675778] Freeing unused kernel memory: 1728k freed
[    1.676495] Freeing unused kernel memory: 296k freed
[    1.732559] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.758284] PM: Adding info for No Bus:vcs2
[    1.758399] PM: Adding info for No Bus:vcsa2
[    1.762058] PM: Adding info for No Bus:vcs3
[    1.762271] PM: Adding info for No Bus:vcsa3
[    1.768185] PM: Adding info for No Bus:vcs4
[    1.768348] PM: Adding info for No Bus:vcsa4
[    1.774332] PM: Adding info for No Bus:vcs5
[    1.774488] PM: Adding info for No Bus:vcsa5
[    1.780389] PM: Adding info for No Bus:vcs6
[    1.780546] PM: Adding info for No Bus:vcsa6
[    1.792876] ehci_hcd 0000:00:1d.7: port 1 high speed
[    1.792889] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.849137] usb usb3: uevent
[    1.849155] usb 3-0:1.0: uevent
[    1.849187] usb usb4: uevent
[    1.849204] usb 4-0:1.0: uevent
[    1.849236] usb usb1: uevent
[    1.849253] usb 1-0:1.0: uevent
[    1.849272] usb 1-1: uevent
[    1.849289] usb 1-1:1.0: uevent
[    1.849308] usb 1-1:1.1: uevent
[    1.849771] usb usb5: uevent
[    1.849788] usb 5-0:1.0: uevent
[    1.849821] usb usb6: uevent
[    1.849837] usb 6-0:1.0: uevent
[    1.849869] usb usb7: uevent
[    1.849885] usb 7-0:1.0: uevent
[    1.849918] usb usb2: uevent
[    1.849934] usb 2-0:1.0: uevent
[    1.871703] ata_piix 0000:00:1f.1: version 2.13
[    1.871725] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.871776] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.882073] scsi0 : ata_piix
[    1.882118] PM: Adding info for scsi:host0
[    1.882143] PM: Adding info for No Bus:host0
[    1.883386] usb 2-1: default language 0x0409
[    1.883758] usb 2-1: udev 2, busnum 2, minor = 129
[    1.883760] usb 2-1: New USB device found, idVendor=066f, idProduct=852e
[    1.883762] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.883764] usb 2-1: Product: 6700            
[    1.883766] usb 2-1: Manufacturer: VERVE   
[    1.883767] usb 2-1: SerialNumber: F03A0917E3188B8B
[    1.883817] PM: Adding info for usb:2-1
[    1.883829] usb 2-1: uevent
[    1.883840] usb 2-1: usb_probe_device
[    1.883843] usb 2-1: configuration #1 chosen from 1 choice
[    1.884131] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    1.884144] PM: Adding info for usb:2-1:1.0
[    1.884261] usb 2-1:1.0: uevent
[    1.884276] usb-storage 2-1:1.0: usb_probe_interface
[    1.884281] usb-storage 2-1:1.0: usb_probe_interface - got id
[    1.885551] scsi1 : ata_piix
[    1.885566] PM: Adding info for scsi:host1
[    1.885591] PM: Adding info for No Bus:host1
[    1.886146] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    1.886149] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    1.890095] ahci 0000:00:1f.2: version 3.0
[    1.890120] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.890208] ahci 0000:00:1f.2: irq 30 for MSI/MSI-X
[    1.890290] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    1.890294] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    1.890299] ahci 0000:00:1f.2: setting latency timer to 64
[    1.894969] scsi2 : usb-storage 2-1:1.0
[    1.894988] PM: Adding info for scsi:host2
[    1.895019] PM: Adding info for No Bus:host2
[    1.903668] PM: Adding info for No Bus:ep_81
[    1.903679] PM: Adding info for No Bus:ep_02
[    1.903687] PM: Adding info for No Bus:ep_83
[    1.903703] PM: Adding info for No Bus:ep_00
[    1.903714] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    1.904223] ata2: port disabled. ignoring.
[    1.919583] scsi3 : ahci
[    1.919607] PM: Adding info for scsi:host3
[    1.919636] PM: Adding info for No Bus:host3
[    1.930132] scsi4 : ahci
[    1.930168] PM: Adding info for scsi:host4
[    1.930203] PM: Adding info for No Bus:host4
[    1.937771] scsi5 : ahci
[    1.937796] PM: Adding info for scsi:host5
[    1.937828] PM: Adding info for No Bus:host5
[    1.938063] ata3: SATA max UDMA/133 abar m2048@0xfebfb800 port 0xfebfb900 irq 30
[    1.938065] ata4: DUMMY
[    1.938068] ata5: SATA max UDMA/133 abar m2048@0xfebfb800 port 0xfebfba00 irq 30
[    1.960250] ehci_hcd 0000:00:1d.7: port 2 high speed
[    1.960257] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    2.020129] usb 2-2: new high speed USB device using ehci_hcd and address 3
[    2.042569] usb usb4: suspend_rh (auto-stop)
[    2.070619] ata1.00: ATAPI: TEAC   DVD+/-RW DVW28SLC, A.06, max UDMA/33
[    2.080377] ehci_hcd 0000:00:1d.7: port 2 high speed
[    2.080388] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    2.110532] ata1.00: configured for UDMA/33
[    2.134827] scsi 0:0:0:0: CD-ROM            TEAC     DVD+-RW DVW28SLC A.06 PQ: 0 ANSI: 5
[    2.134874] PM: Adding info for scsi:target0:0:0
[    2.134940] PM: Adding info for scsi:0:0:0:0
[    2.164052] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
[    2.164062] Uniform CD-ROM driver Revision: 3.20
[    2.164127] PM: Adding info for No Bus:sr0
[    2.164217] PM: Adding info for No Bus:11:0
[    2.164254] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.164280] PM: Adding info for No Bus:0:0:0:0
[    2.164365] PM: Adding info for No Bus:sg0
[    2.164388] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.171643] usb 2-2: default language 0x0409
[    2.172162] usb 2-2: udev 3, busnum 2, minor = 130
[    2.172169] usb 2-2: New USB device found, idVendor=05e3, idProduct=0608
[    2.172174] usb 2-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.172179] usb 2-2: Product: USB2.0 Hub
[    2.172282] PM: Adding info for usb:2-2
[    2.172310] usb 2-2: uevent
[    2.172347] usb 2-2: usb_probe_device
[    2.172355] usb 2-2: configuration #1 chosen from 1 choice
[    2.172668] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    2.172705] PM: Adding info for usb:2-2:1.0
[    2.172717] usb 2-2:1.0: uevent
[    2.172750] hub 2-2:1.0: usb_probe_interface
[    2.172756] hub 2-2:1.0: usb_probe_interface - got id
[    2.172761] hub 2-2:1.0: USB hub found
[    2.173150] hub 2-2:1.0: 4 ports detected
[    2.173156] hub 2-2:1.0: standalone hub
[    2.173160] hub 2-2:1.0: individual port power switching
[    2.173165] hub 2-2:1.0: individual port over-current protection
[    2.173169] hub 2-2:1.0: Single TT
[    2.173175] hub 2-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[    2.173179] hub 2-2:1.0: Port indicators are supported
[    2.173184] hub 2-2:1.0: power on to power good time: 100ms
[    2.173792] hub 2-2:1.0: local power source is good
[    2.173798] hub 2-2:1.0: enabling power on all ports
[    2.175320] PM: Adding info for No Bus:ep_81
[    2.175355] PM: Adding info for No Bus:ep_00
[    2.175371] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    2.175389] ehci_hcd 0000:00:1d.7: port 3 low speed --> companion
[    2.230174] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[    2.230223] hub 2-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    2.270663] hub 2-2:1.0: port 1: status 0101 change 0001
[    2.290254] ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
[    2.290266] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
[    2.290277] hub 2-0:1.0: port 6 not reset yet, waiting 50ms
[    2.292699] usb usb5: suspend_rh (auto-stop)
[    2.310183] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.310940] ata3.00: ATA-8: FUJITSU MHY2250BH, 0085000B, max UDMA/100
[    2.310948] ata3.00: 488397168 sectors, multi 8: LBA48 NCQ (depth 31/32), AA
[    2.312031] ata3.00: configured for UDMA/100
[    2.320210] ata5: SATA link down (SStatus 0 SControl 300)
[    2.330357] scsi 3:0:0:0: Direct-Access     ATA      FUJITSU MHY2250B 0085 PQ: 0 ANSI: 5
[    2.330393] PM: Adding info for scsi:target3:0:0
[    2.330457] PM: Adding info for scsi:3:0:0:0
[    2.330531] PM: Adding info for No Bus:3:0:0:0
[    2.330583] PM: Adding info for No Bus:3:0:0:0
[    2.330657] PM: Adding info for No Bus:sg1
[    2.330681] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    2.331537] sd 3:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.331663] sd 3:0:0:0: [sda] Write Protect is off
[    2.331669] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.331722] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.331779] PM: Adding info for No Bus:sda
[    2.332029]  sda:
[    2.350177] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[    2.350222] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    2.350238] uhci_hcd 0000:00:1a.0: port 2 portsc 0093,00
[    2.350251] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    2.361073]  sda1 sda2 sda3 <
[    2.370221] usb 2-2: link qh256-0001/ffff88011c2bc940 start 1 [1/0 us]
[    2.390676]  sda5 sda6 > sda4
[    2.398456] PM: Adding info for No Bus:sda1
[    2.398492] PM: Adding info for No Bus:sda2
[    2.398531] PM: Adding info for No Bus:sda3
[    2.398565] PM: Adding info for No Bus:sda4
[    2.398596] PM: Adding info for No Bus:sda5
[    2.398629] PM: Adding info for No Bus:sda6
[    2.398875] PM: Adding info for No Bus:8:0
[    2.400386] sd 3:0:0:0: [sda] Attached SCSI disk
[    2.520144] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    2.640140] usb 3-2: new full speed USB device using uhci_hcd and address 2
[    2.782654] usb 3-2: ep0 maxpacket = 8
[    2.803073] usb 3-2: default language 0x0409
[    2.822061] usb 3-2: udev 2, busnum 3, minor = 257
[    2.822069] usb 3-2: New USB device found, idVendor=0483, idProduct=2016
[    2.822075] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.822081] usb 3-2: Product: Biometric Coprocessor
[    2.822085] usb 3-2: Manufacturer: STMicroelectronics
[    2.822191] PM: Adding info for usb:3-2
[    2.822221] usb 3-2: uevent
[    2.822258] usb 3-2: usb_probe_device
[    2.822266] usb 3-2: configuration #1 chosen from 1 choice
[    2.823980] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    2.824020] PM: Adding info for usb:3-2:1.0
[    2.824033] usb 3-2:1.0: uevent
[    2.824086] usbserial_generic 3-2:1.0: usb_probe_interface
[    2.824092] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    2.824150] PM: Adding info for No Bus:ep_81
[    2.824174] PM: Adding info for No Bus:ep_02
[    2.824198] PM: Adding info for No Bus:ep_83
[    2.824225] PM: Adding info for No Bus:ep_00
[    2.824236] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.824246] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    2.824264] uhci_hcd 0000:00:1d.1: port 1 portsc 01a3,00
[    2.824278] hub 6-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    2.897619] Scanning swap devices for TuxOnIce signature...
[    2.951580] - Trying 8:5.
[    2.953631] TuxOnIce scan: No image found.
[    2.954007] TuxOnIce: No image found.
[    2.982697] hub 6-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    3.102703] usb 6-1: new low speed USB device using uhci_hcd and address 2
[    3.296895] usb 6-1: skipped 1 descriptor after interface
[    3.296906] usb 6-1: udev 2, busnum 6, minor = 641
[    3.296912] usb 6-1: New USB device found, idVendor=04d9, idProduct=048e
[    3.296917] usb 6-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.297022] PM: Adding info for usb:6-1
[    3.297051] usb 6-1: uevent
[    3.297089] usb 6-1: usb_probe_device
[    3.297097] usb 6-1: configuration #1 chosen from 1 choice
[    3.301902] usb 6-1: adding 6-1:1.0 (config #1, interface 0)
[    3.301949] PM: Adding info for usb:6-1:1.0
[    3.301963] usb 6-1:1.0: uevent
[    3.302020] usbserial_generic 6-1:1.0: usb_probe_interface
[    3.302027] usbserial_generic 6-1:1.0: usb_probe_interface - got id
[    3.302092] PM: Adding info for No Bus:ep_81
[    3.302128] PM: Adding info for No Bus:ep_00
[    3.302139] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    3.302158] uhci_hcd 0000:00:1d.2: port 2 portsc 0093,00
[    3.302174] hub 7-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    3.313511] usbcore: registered new interface driver hiddev
[    3.313526] usbhid 6-1:1.0: usb_probe_interface
[    3.313529] usbhid 6-1:1.0: usb_probe_interface - got id
[    3.313554] PM: Adding info for hid:0003:04D9:048E.0001
[    3.399265] PM: Adding info for No Bus:input7
[    3.399347] input: HID 04d9:048e as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input7
[    3.399375] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    3.399438] PM: Adding info for No Bus:mouse2
[    3.399490] PM: Adding info for No Bus:event7
[    3.399513] generic-usb 0003:04D9:048E.0001: input: USB HID v1.10 Mouse [HID 04d9:048e] on usb-0000:00:1d.1-1/input0
[    3.399576] usbcore: registered new interface driver usbhid
[    3.399581] usbhid: USB HID core driver
[    3.462675] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    3.582590] usb 7-2: new full speed USB device using uhci_hcd and address 2
[    3.722663] usb 7-2: ep0 maxpacket = 8
[    3.749154] usb 7-2: default language 0x0409
[    3.763136] usb 7-2: udev 2, busnum 7, minor = 769
[    3.763143] usb 7-2: New USB device found, idVendor=0a5c, idProduct=4500
[    3.763149] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.763154] usb 7-2: Product: BCM2045B2
[    3.763159] usb 7-2: Manufacturer: Broadcom
[    3.763265] PM: Adding info for usb:7-2
[    3.763294] usb 7-2: uevent
[    3.763332] usb 7-2: usb_probe_device
[    3.763340] usb 7-2: configuration #1 chosen from 1 choice
[    3.766077] usb 7-2: adding 7-2:1.0 (config #1, interface 0)
[    3.766117] PM: Adding info for usb:7-2:1.0
[    3.766129] usb 7-2:1.0: uevent
[    3.766163] hub 7-2:1.0: usb_probe_interface
[    3.766169] hub 7-2:1.0: usb_probe_interface - got id
[    3.766174] hub 7-2:1.0: USB hub found
[    3.768049] hub 7-2:1.0: 3 ports detected
[    3.768055] hub 7-2:1.0: compound device; port removable status: FFF
[    3.768060] hub 7-2:1.0: ganged power switching
[    3.768064] hub 7-2:1.0: global over-current protection
[    3.768069] hub 7-2:1.0: power on to power good time: 100ms
[    3.769072] hub 7-2:1.0: hub controller current requirement: 100mA
[    3.769078] hub 7-2:1.0: 100mA bus power budget for each child
[    3.770145] hub 7-2:1.0: local power source is good
[    3.770153] hub 7-2:1.0: no over-current condition exists
[    3.770159] hub 7-2:1.0: enabling power on all ports
[    3.773185] PM: Adding info for No Bus:ep_81
[    3.773218] PM: Adding info for No Bus:ep_00
[    3.773229] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0004
[    3.773247] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    3.773261] hub 2-2:1.0: state 7 ports 4 chg 0002 evt 0000
[    3.773661] hub 2-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    3.860537] usb 2-2.1: new full speed USB device using ehci_hcd and address 6
[    3.874147] hub 7-2:1.0: port 1: status 0101 change 0001
[    3.876057] hub 7-2:1.0: port 2: status 0101 change 0001
[    3.878152] hub 7-2:1.0: port 3: status 0101 change 0001
[    3.960159] usb 2-2.1: ep0 maxpacket = 8
[    3.962267] usb 2-2.1: default language 0x0409
[    3.963897] usb 2-2.1: udev 6, busnum 2, minor = 133
[    3.963904] usb 2-2.1: New USB device found, idVendor=04e8, idProduct=3419
[    3.963910] usb 2-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.963916] usb 2-2.1: Product: SCX-4x21 Series
[    3.963920] usb 2-2.1: Manufacturer: Samsung
[    3.963924] usb 2-2.1: SerialNumber: 8P54BAIQ223171Y.
[    3.964028] PM: Adding info for usb:2-2.1
[    3.964059] usb 2-2.1: uevent
[    3.964104] usb 2-2.1: usb_probe_device
[    3.964112] usb 2-2.1: configuration #1 chosen from 1 choice
[    3.964325] usb 2-2.1: adding 2-2.1:1.0 (config #1, interface 0)
[    3.964366] PM: Adding info for usb:2-2.1:1.0
[    3.964381] usb 2-2.1:1.0: uevent
[    3.964434] usbserial_generic 2-2.1:1.0: usb_probe_interface
[    3.964441] usbserial_generic 2-2.1:1.0: usb_probe_interface - got id
[    3.964518] PM: Adding info for No Bus:ep_04
[    3.964541] PM: Adding info for No Bus:ep_82
[    3.964548] usb 2-2.1: adding 2-2.1:1.1 (config #1, interface 1)
[    3.964586] PM: Adding info for usb:2-2.1:1.1
[    3.964599] usb 2-2.1:1.1: uevent
[    3.964629] usblp 2-2.1:1.1: usb_probe_interface
[    3.964634] usblp 2-2.1:1.1: usb_probe_interface - got id
[    3.964811] PM: Adding info for No Bus:ep_03
[    3.964834] PM: Adding info for No Bus:ep_81
[    3.965529] drivers/usb/core/file.c: looking for a minor, starting at 0
[    3.965628] PM: Adding info for No Bus:lp0
[    3.965653] usblp0: USB Bidirectional printer dev 6 if 1 alt 0 proto 2 vid 0x04E8 pid 0x3419
[    3.965691] PM: Adding info for No Bus:ep_00
[    3.965702] hub 2-2:1.0: state 7 ports 4 chg 0000 evt 0002
[    3.972738] uhci_hcd 0000:00:1d.2: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    3.972787] hub 7-2:1.0: state 7 ports 3 chg 000e evt 0000
[    3.974052] hub 7-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    4.050215] hub 4-0:1.0: hub_suspend
[    4.050232] usb usb4: bus auto-suspend
[    4.050238] usb usb4: suspend_rh
[    4.062137] usb 7-2.1: new full speed USB device using uhci_hcd and address 3
[    4.181095] usb 7-2.1: skipped 1 descriptor after interface
[    4.184154] usb 7-2.1: default language 0x0409
[    4.190166] usb 7-2.1: udev 3, busnum 7, minor = 770
[    4.190173] usb 7-2.1: New USB device found, idVendor=413c, idProduct=8126
[    4.190179] usb 7-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.190184] usb 7-2.1: Product: BCM2045
[    4.190189] usb 7-2.1: Manufacturer: Broadcom Corp
[    4.190291] PM: Adding info for usb:7-2.1
[    4.190322] usb 7-2.1: uevent
[    4.190365] usb 7-2.1: usb_probe_device
[    4.190373] usb 7-2.1: configuration #1 chosen from 1 choice
[    4.192068] usb 7-2.1: adding 7-2.1:1.0 (config #1, interface 0)
[    4.192112] PM: Adding info for usb:7-2.1:1.0
[    4.192126] usb 7-2.1:1.0: uevent
[    4.192179] usbserial_generic 7-2.1:1.0: usb_probe_interface
[    4.192185] usbserial_generic 7-2.1:1.0: usb_probe_interface - got id
[    4.192246] PM: Adding info for No Bus:ep_81
[    4.192274] PM: Adding info for No Bus:ep_82
[    4.192295] PM: Adding info for No Bus:ep_02
[    4.192301] usb 7-2.1: adding 7-2.1:1.1 (config #1, interface 1)
[    4.192325] PM: Adding info for usb:7-2.1:1.1
[    4.192335] usb 7-2.1:1.1: uevent
[    4.192374] usbserial_generic 7-2.1:1.1: usb_probe_interface
[    4.192379] usbserial_generic 7-2.1:1.1: usb_probe_interface - got id
[    4.192429] PM: Adding info for No Bus:ep_83
[    4.192452] PM: Adding info for No Bus:ep_03
[    4.192458] usb 7-2.1: adding 7-2.1:1.2 (config #1, interface 2)
[    4.192484] PM: Adding info for usb:7-2.1:1.2
[    4.192493] usb 7-2.1:1.2: uevent
[    4.192555] usbserial_generic 7-2.1:1.2: usb_probe_interface
[    4.192560] usbserial_generic 7-2.1:1.2: usb_probe_interface - got id
[    4.192614] PM: Adding info for No Bus:ep_84
[    4.192635] PM: Adding info for No Bus:ep_04
[    4.192640] usb 7-2.1: adding 7-2.1:1.3 (config #1, interface 3)
[    4.192668] PM: Adding info for usb:7-2.1:1.3
[    4.192677] usb 7-2.1:1.3: uevent
[    4.192713] usbserial_generic 7-2.1:1.3: usb_probe_interface
[    4.192718] usbserial_generic 7-2.1:1.3: usb_probe_interface - got id
[    4.192773] PM: Adding info for No Bus:ep_00
[    4.192780] hub 7-2:1.0: 400mA power budget left
[    4.194021] hub 7-2:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    4.272157] usb 7-2.2: new full speed USB device using uhci_hcd and address 4
[    4.370150] usb 7-2.2: ep0 maxpacket = 8
[    4.396158] usb 7-2.2: skipped 1 descriptor after interface
[    4.399151] usb 7-2.2: default language 0x0409
[    4.407155] usb 7-2.2: udev 4, busnum 7, minor = 771
[    4.407162] usb 7-2.2: New USB device found, idVendor=0a5c, idProduct=4502
[    4.407168] usb 7-2.2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    4.407173] usb 7-2.2: Manufacturer: Broadcom Corp
[    4.407276] PM: Adding info for usb:7-2.2
[    4.407307] usb 7-2.2: uevent
[    4.407346] usb 7-2.2: usb_probe_device
[    4.407354] usb 7-2.2: configuration #1 chosen from 1 choice
[    4.409063] usb 7-2.2: adding 7-2.2:1.0 (config #1, interface 0)
[    4.409109] PM: Adding info for usb:7-2.2:1.0
[    4.409124] usb 7-2.2:1.0: uevent
[    4.409178] usbserial_generic 7-2.2:1.0: usb_probe_interface
[    4.409185] usbserial_generic 7-2.2:1.0: usb_probe_interface - got id
[    4.409228] usbhid 7-2.2:1.0: usb_probe_interface
[    4.409232] usbhid 7-2.2:1.0: usb_probe_interface - got id
[    4.409277] PM: Adding info for hid:0003:0A5C:4502.0002
[    4.413645] PM: Adding info for No Bus:input8
[    4.413715] input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2/7-2.2:1.0/input/input8
[    4.413738] uhci_hcd 0000:00:1d.2: reserve dev 4 ep81-INT, period 8, phase 4, 17 us
[    4.413792] PM: Adding info for No Bus:event8
[    4.413817] generic-usb 0003:0A5C:4502.0002: input: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1d.2-2.2/input0
[    4.413874] PM: Adding info for No Bus:ep_81
[    4.413906] PM: Adding info for No Bus:ep_00
[    4.413914] hub 7-2:1.0: 400mA power budget left
[    4.415045] hub 7-2:1.0: port 3, status 0101, change 0000, 12 Mb/s
[    4.492144] usb 7-2.3: new full speed USB device using uhci_hcd and address 5
[    4.590071] usb 7-2.3: ep0 maxpacket = 8
[    4.615139] usb 7-2.3: skipped 1 descriptor after interface
[    4.618132] usb 7-2.3: default language 0x0409
[    4.626155] usb 7-2.3: udev 5, busnum 7, minor = 772
[    4.626163] usb 7-2.3: New USB device found, idVendor=0a5c, idProduct=4503
[    4.626168] usb 7-2.3: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    4.626174] usb 7-2.3: Manufacturer: Broadcom Corp
[    4.626284] PM: Adding info for usb:7-2.3
[    4.626314] usb 7-2.3: uevent
[    4.626353] usb 7-2.3: usb_probe_device
[    4.626361] usb 7-2.3: configuration #1 chosen from 1 choice
[    4.628067] usb 7-2.3: adding 7-2.3:1.0 (config #1, interface 0)
[    4.628113] PM: Adding info for usb:7-2.3:1.0
[    4.628128] usb 7-2.3:1.0: uevent
[    4.628181] usbserial_generic 7-2.3:1.0: usb_probe_interface
[    4.628188] usbserial_generic 7-2.3:1.0: usb_probe_interface - got id
[    4.628234] usbhid 7-2.3:1.0: usb_probe_interface
[    4.628239] usbhid 7-2.3:1.0: usb_probe_interface - got id
[    4.628282] PM: Adding info for hid:0003:0A5C:4503.0003
[    4.634047] PM: Adding info for No Bus:input9
[    4.634115] input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3/7-2.3:1.0/input/input9
[    4.634181] PM: Adding info for No Bus:mouse3
[    4.634229] PM: Adding info for No Bus:event9
[    4.634253] generic-usb 0003:0A5C:4503.0003: input: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1d.2-2.3/input0
[    4.634316] PM: Adding info for No Bus:ep_81
[    4.634347] PM: Adding info for No Bus:ep_00
[    4.634356] hub 7-2:1.0: 400mA power budget left
[    4.634364] hub 7-2:1.0: state 7 ports 3 chg 0000 evt 0008
[    5.012665] hub 5-0:1.0: hub_suspend
[    5.012683] usb usb5: bus auto-suspend
[    5.012689] usb usb5: suspend_rh
[    6.903224] scsi 2:0:0:0: Direct-Access     VERVE    6700             0100 PQ: 0 ANSI: 4
[    6.903750] PM: Adding info for scsi:target2:0:0
[    6.904197] PM: Adding info for scsi:2:0:0:0
[    6.904268] PM: Adding info for No Bus:2:0:0:0
[    6.904349] PM: Adding info for No Bus:2:0:0:0
[    6.904430] PM: Adding info for No Bus:sg2
[    6.904456] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    6.905160] sd 2:0:0:0: [sdb] 978560 2048-byte logical blocks: (2.00 GB/1.86 GiB)
[    6.905913] sd 2:0:0:0: [sdb] Write Protect is off
[    6.905920] sd 2:0:0:0: [sdb] Mode Sense: 3e 00 00 00
[    6.905925] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    6.906602] PM: Adding info for No Bus:sdb
[    6.907907] sd 2:0:0:0: [sdb] 978560 2048-byte logical blocks: (2.00 GB/1.86 GiB)
[    6.909100] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    6.909681]  sdb: sdb1
[    6.910740] PM: Adding info for No Bus:sdb1
[    6.911619] PM: Adding info for No Bus:8:16
[    6.912928] sd 2:0:0:0: [sdb] 978560 2048-byte logical blocks: (2.00 GB/1.86 GiB)
[    6.913424] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    6.913998] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    6.916335] usb 2-1:1.0: uevent
[    6.916620] usb 2-1: uevent
[    7.096524] usb 2-1:1.0: uevent
[    7.096797] usb 2-1: uevent
[    8.023930] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    8.023945] PM: Marking nosave pages: 00000000dfe72000 - 0000000100000000
[    8.025053] PM: Basic memory bitmaps created
[    8.062147] PM: Basic memory bitmaps freed
[    8.106626] EXT3-fs (sda2): mounted filesystem with writeback data mode
[    8.106796] kjournald starting.  Commit interval 5 seconds
[   14.051026] udev: starting version 141
[   14.078746] usb usb3: uevent
[   14.078860] usb 3-0:1.0: uevent
[   14.078989] usb 3-2: uevent
[   14.079098] usb 3-2:1.0: uevent
[   14.079390] usb usb4: uevent
[   14.079521] usb 4-0:1.0: uevent
[   14.079951] usb usb1: uevent
[   14.080021] usb 1-0:1.0: uevent
[   14.080021] usb 1-1: uevent
[   14.080353] usb 1-1:1.0: uevent
[   14.080450] usb 1-1:1.1: uevent
[   14.087063] usb usb5: uevent
[   14.087182] usb 5-0:1.0: uevent
[   14.087506] usb usb6: uevent
[   14.087651] usb 6-0:1.0: uevent
[   14.087764] usb 6-1: uevent
[   14.087850] usb 6-1:1.0: uevent
[   14.088549] usb usb7: uevent
[   14.088675] usb 7-0:1.0: uevent
[   14.088769] usb 7-2: uevent
[   14.088860] usb 7-2.1: uevent
[   14.088954] usb 7-2.1:1.0: uevent
[   14.089098] usb 7-2.1:1.1: uevent
[   14.089188] usb 7-2.1:1.2: uevent
[   14.089282] usb 7-2.1:1.3: uevent
[   14.089373] usb 7-2.2: uevent
[   14.089470] usb 7-2.2:1.0: uevent
[   14.089912] usb 7-2.3: uevent
[   14.093919] usb 7-2.3:1.0: uevent
[   14.094666] usb 7-2:1.0: uevent
[   14.095192] usb usb2: uevent
[   14.095340] usb 2-0:1.0: uevent
[   14.095462] usb 2-1: uevent
[   14.095584] usb 2-1:1.0: uevent
[   14.096736] usb 2-2: uevent
[   14.096866] usb 2-2.1: uevent
[   14.096996] usb 2-2.1:1.0: uevent
[   14.097122] usb 2-2.1:1.1: uevent
[   14.097372] usb 2-2:1.0: uevent
[   14.180489] usb 2-1:1.0: uevent
[   14.180598] usb 2-1: uevent
[   14.408337] usb 6-1:1.0: uevent
[   14.408440] usb 6-1: uevent
[   14.415611] usb 7-2.2:1.0: uevent
[   14.415722] usb 7-2.2: uevent
[   14.418059] usb 7-2.3:1.0: uevent
[   14.418163] usb 7-2.3: uevent
[   14.419328] usb 6-1:1.0: uevent
[   14.419421] usb 6-1: uevent
[   14.420139] usb 7-2.3:1.0: uevent
[   14.420239] usb 7-2.3: uevent
[   15.050936] Bluetooth: Core ver 2.15
[   15.051163] NET: Registered protocol family 31
[   15.051165] Bluetooth: HCI device and connection manager initialized
[   15.051168] Bluetooth: HCI socket layer initialized
[   15.752046] PM: Adding info for platform:regulatory.0
[   15.752243] cfg80211: Using static regulatory domain info
[   15.752245] cfg80211: Regulatory domain: 00
[   15.752247]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.752249]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   15.752251]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[   15.752254]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[   15.752256]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   15.752258]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   15.752266] cfg80211: Calling CRDA to update world regulatory domain
[   15.960122] cfg80211: World regulatory domain updated:
[   15.960133]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.960140]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.960147]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.960153]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.960159]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.960165]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   16.011395] PM: Adding info for platform:dell-laptop
[   16.038555] PM: Adding info for No Bus:input10
[   16.039119] input: Dell WMI hotkeys as /devices/virtual/input/input10
[   16.039197] PM: Adding info for No Bus:event10
[   16.162163] PM: Adding info for No Bus:BAT0
[   16.167476] ACPI: Battery Slot [BAT0] (battery present)
[   16.176943] PM: Adding info for No Bus:input11
[   16.176963] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input11
[   16.176998] PM: Adding info for No Bus:event11
[   16.321981] ACPI: Lid Switch [LID]
[   16.322024] PM: Adding info for No Bus:input12
[   16.322136] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input12
[   16.322168] PM: Adding info for No Bus:event12
[   16.322253] ACPI: Power Button [PBTN]
[   16.322284] PM: Adding info for No Bus:input13
[   16.322371] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input13
[   16.322386] PM: Adding info for No Bus:event13
[   16.322460] ACPI: Sleep Button [SBTN]
[   16.347726] PM: Adding info for No Bus:AC
[   16.347753] ACPI: AC Adapter [AC] (on-line)
[   16.391219] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   16.391282] btusb 7-2.1:1.0: usb_probe_interface
[   16.391289] btusb 7-2.1:1.0: usb_probe_interface - got id
[   16.391354] PM: Adding info for No Bus:hci0
[   16.393252] PM: Adding info for No Bus:rfkill0
[   16.393918] btusb 7-2.1:1.2: usb_probe_interface
[   16.393925] btusb 7-2.1:1.2: usb_probe_interface - got id
[   16.393942] btusb 7-2.1:1.3: usb_probe_interface
[   16.393946] btusb 7-2.1:1.3: usb_probe_interface - got id
[   16.394368] usbcore: registered new interface driver btusb
[   16.457851] PM: Adding info for No Bus:acpi_video0
[   16.458028] PM: Adding info for No Bus:cooling_device2
[   16.458212] acpi device:30: registered as cooling_device2
[   16.458225] PM: Adding info for No Bus:acpi_video0
[   16.458949] PM: Adding info for No Bus:input14
[   16.459113] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:2d/LNXVIDEO:00/input/input14
[   16.459151] PM: Adding info for No Bus:event14
[   16.459293] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   16.483062] Linux video capture interface: v2.00
[   16.716444] uvcvideo 1-1:1.0: usb_probe_interface
[   16.716454] uvcvideo 1-1:1.0: usb_probe_interface - got id
[   16.716495] uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
[   16.716895] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   16.717463] PM: Adding info for No Bus:video0
[   16.717704] PM: Adding info for No Bus:input15
[   16.717882] input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input15
[   16.717927] PM: Adding info for No Bus:event15
[   16.718428] usbcore: registered new interface driver uvcvideo
[   16.718433] USB Video Class driver (v0.1.0)
[   16.723603] usb 1-1:1.0: uevent
[   16.723868] usb 1-1: uevent
[   16.728634] usb 1-1:1.0: uevent
[   16.728895] usb 1-1: uevent
[   16.921995] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 2.6.33-rc1-ks
[   16.921998] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[   16.922120] iwl3945 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   16.922135] iwl3945 0000:0b:00.0: setting latency timer to 64
[   16.962679] iwl3945 0000:0b:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
[   16.962682] iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   16.962826] iwl3945 0000:0b:00.0: irq 31 for MSI/MSI-X
[   16.962992] PM: Adding info for No Bus:phy0
[   16.963019] PM: Adding info for No Bus:rfkill1
[   17.028315] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   17.028445] PM: Adding info for No Bus:wlan0
[   17.371986] Adding 3068372k swap on /dev/sda5.  Priority:-1 extents:1 across:3068372k 
[   17.476691] EXT3-fs (sda2): using internal journal
[   18.768863] kjournald starting.  Commit interval 5 seconds
[   18.769408] EXT3-fs (sda4): using internal journal
[   18.769424] EXT3-fs (sda4): mounted filesystem with writeback data mode
[   18.788553] kjournald starting.  Commit interval 5 seconds
[   18.789078] EXT3-fs (sda6): using internal journal
[   18.789094] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   27.171116] PM: Adding info for No Bus:vcs63
[   27.171173] PM: Adding info for No Bus:vcsa63
[   29.008441] usbcore: deregistering interface driver uvcvideo
[   29.008475] PM: Removing info for No Bus:video0
[   29.030195] PM: Removing info for No Bus:event15
[   29.060189] PM: Removing info for No Bus:input15
[   29.128810] TuxOnIce: No image found.
[   29.172071] TuxOnIce 3.0.99.44, with support for usm, compression, block i/o, swap storage, file storage, userui.
[   29.172365] Initiating a hibernation cycle.
[   29.281874] Stopping fuse filesystems.
[   29.281880] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   29.300024] Stopping normal filesystems.
[   29.462396] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   29.640919] Restarting normal filesystems.
[   29.646544] Stopping fuse filesystems.
[   29.646547] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   29.646553] Stopping normal filesystems.
[   29.821549] Freezing remaining freezable tasks ... 
[   29.838831] n is a3009. Action flags being changed from a3008 to a3009.(elapsed 0.02 seconds) done.
[   29.994838] ...20%...40%...60%...80%...100%
[   30.927625] Waited for i/o due to synchronous I/O 8 times.
[   30.930735] Suspending console(s) (use no_console_suspend to debug)
[   30.930840] pci 0000:00:00.0: preparing freeze
[   30.930845] pcieport 0000:00:01.0: preparing freeze
[   30.930851] uhci_hcd 0000:00:1a.0: preparing freeze
[   30.930856] uhci_hcd 0000:00:1a.1: preparing freeze
[   30.930861] ehci_hcd 0000:00:1a.7: preparing freeze
[   30.930866] HDA Intel 0000:00:1b.0: preparing freeze
[   30.930870] pcieport 0000:00:1c.0: preparing freeze
[   30.930875] pcieport 0000:00:1c.1: preparing freeze
[   30.930879] pcieport 0000:00:1c.4: preparing freeze
[   30.930884] uhci_hcd 0000:00:1d.0: preparing freeze
[   30.930888] uhci_hcd 0000:00:1d.1: preparing freeze
[   30.930893] uhci_hcd 0000:00:1d.2: preparing freeze
[   30.930897] ehci_hcd 0000:00:1d.7: preparing freeze
[   30.930902] pci 0000:00:1e.0: preparing freeze
[   30.930907] pci 0000:00:1f.0: preparing freeze
[   30.930912] ata_piix 0000:00:1f.1: preparing freeze
[   30.930917] ahci 0000:00:1f.2: preparing freeze
[   30.930922] pci 0000:00:1f.3: preparing freeze
[   30.930926] pci 0000:01:00.0: preparing freeze
[   30.930932] sky2 0000:09:00.0: preparing freeze
[   30.930938] iwl3945 0000:0b:00.0: preparing freeze
[   30.930945] pci 0000:03:09.0: preparing freeze
[   30.930950] sdhci-pci 0000:03:09.1: preparing freeze
[   30.930954] pci 0000:03:09.2: preparing freeze
[   30.930959] pci 0000:03:09.3: preparing freeze
[   30.930997] pcspkr pcspkr: preparing freeze
[   30.931016] vesafb vesafb.0: preparing freeze
[   30.931086] serial8250 serial8250: preparing freeze
[   30.931096] usb usb1: preparing type freeze
[   30.931104] usb usb2: preparing type freeze
[   30.931111] usb usb3: preparing type freeze
[   30.931118] usb usb4: preparing type freeze
[   30.931125] usb usb5: preparing type freeze
[   30.931132] usb usb6: preparing type freeze
[   30.931140] usb usb7: preparing type freeze
[   30.931147] i8042 i8042: preparing freeze
[   30.931159] coretemp coretemp.0: preparing freeze
[   30.931165] coretemp coretemp.1: preparing freeze
[   30.931170] iTCO_wdt iTCO_wdt: preparing freeze
[   30.931178] platform dell_rbu: preparing freeze
[   30.931183] dcdbas dcdbas: preparing freeze
[   30.931192] usb 1-1: preparing type freeze
[   30.931232] usb 2-1: preparing type freeze
[   30.931257] usb 2-2: preparing type freeze
[   30.931276] usb 3-2: preparing type freeze
[   30.931284] usb 6-1: preparing type freeze
[   30.931296] usb 7-2: preparing type freeze
[   30.931303] usb 2-2.1: preparing type freeze
[   30.931315] usb 7-2.1: preparing type freeze
[   30.931330] usb 7-2.2: preparing type freeze
[   30.931341] usb 7-2.3: preparing type freeze
[   30.931361] platform regulatory.0: preparing freeze
[   30.931366] dell-laptop dell-laptop: preparing freeze
[   30.931399] rfkill rfkill1: legacy class freeze
[   30.931404] ieee80211 phy0: legacy class freeze
[   30.970172] input input14: type freeze
[   30.970182] backlight acpi_video0: legacy class freeze
[   30.970188] rfkill rfkill0: legacy class freeze
[   30.970198] input input13: type freeze
[   30.970203] input input12: type freeze
[   30.970209] input input11: type freeze
[   30.970216] input input10: type freeze
[   30.970221] dell-laptop dell-laptop: freeze
[   30.970227] platform regulatory.0: freeze
[   30.970239] sd 2:0:0:0: legacy freeze
[   30.970250] scsi target2:0:0: legacy freeze
[   30.970259] input input9: type freeze
[   30.970267] usb 7-2.3: type freeze
[   30.970283] input input8: type freeze
[   30.970290] usb 7-2.2: type freeze
[   30.972087] uhci_hcd 0000:00:1d.2: release dev 4 ep81-INT, period 8, phase 4, 17 us
[   30.972137] usb 7-2.1: type freeze
[   30.972159] usb 2-2.1: type freeze
[   30.972170] usb 7-2: type freeze
[   30.972176] hub 7-2:1.0: hub_suspend
[   30.973085] uhci_hcd 0000:00:1d.2: release dev 2 ep81-INT, period 128, phase 0, 12 us
[   30.973130] input input7: type freeze
[   30.973140] usb 6-1: type freeze
[   30.974819] uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period 8, phase 4, 118 us
[   30.974865] usb 3-2: type freeze
[   30.974886] sd 3:0:0:0: legacy freeze
[   30.974894] sd 3:0:0:0: [sda] Synchronizing SCSI cache
[   30.975714] scsi target3:0:0: legacy freeze
[   30.975725] usb 2-2: type freeze
[   30.975731] hub 2-2:1.0: hub_suspend
[   30.975744] usb 2-2: unlink qh256-0001/ffff88011c2bc940 start 1 [1/0 us]
[   30.975827] sr 0:0:0:0: legacy freeze
[   30.975833] scsi target0:0:0: legacy freeze
[   30.975839] scsi host5: legacy freeze
[   30.975844] scsi host4: legacy freeze
[   30.975850] scsi host3: legacy freeze
[   30.975858] scsi host2: legacy freeze
[   30.975863] scsi host1: legacy freeze
[   30.975869] usb 2-1: type freeze
[   30.975878] scsi host0: legacy freeze
[   30.975902] input input6: type freeze
[   30.975908] input input5: type freeze
[   30.975914] input input4: type freeze
[   30.975922] input input3: type freeze
[   30.975929] input input2: type freeze
[   30.975937] usb 1-1: type freeze
[   30.975946] input input1: type freeze
[   30.975953] dcdbas dcdbas: freeze
[   30.975958] platform dell_rbu: freeze
[   30.975964] leds mmc0::: legacy class freeze
[   30.975971] iTCO_wdt iTCO_wdt: freeze
[   30.975977] coretemp coretemp.1: freeze
[   30.975983] coretemp coretemp.0: freeze
[   30.975988] rtc rtc0: legacy class freeze
[   30.976028] input input0: type freeze
[   30.976033] psmouse serio1: freeze
[   30.976038] atkbd serio0: freeze
[   30.976043] i8042 i8042: freeze
[   30.976051] usb usb7: type freeze
[   30.976055] hub 7-0:1.0: hub_suspend
[   30.976063] usb usb7: bus suspend
[   30.976067] usb usb7: suspend_rh
[   30.976095] usb usb6: type freeze
[   30.976100] hub 6-0:1.0: hub_suspend
[   30.976106] usb usb6: bus suspend
[   30.976109] usb usb6: suspend_rh
[   30.976134] usb usb5: type freeze
[   30.976142] usb usb4: type freeze
[   30.976149] usb usb3: type freeze
[   30.976154] hub 3-0:1.0: hub_suspend
[   30.976160] usb usb3: bus suspend
[   30.976163] usb usb3: suspend_rh
[   30.976189] usb usb2: type freeze
[   30.976193] hub 2-0:1.0: hub_suspend
[   30.976199] usb usb2: bus suspend
[   30.976203] ehci_hcd 0000:00:1d.7: suspend root hub
[   30.976393] usb usb1: type freeze
[   30.976397] hub 1-0:1.0: hub_suspend
[   30.976403] usb usb1: bus suspend
[   30.976406] ehci_hcd 0000:00:1a.7: suspend root hub
[   30.976590] serial8250 serial8250: freeze
[   30.976663] vesafb vesafb.0: freeze
[   30.976682] pcspkr pcspkr: freeze
[   30.976700] system 00:0c: legacy freeze
[   30.976716] system 00:0b: legacy freeze
[   30.976724] system 00:0a: legacy freeze
[   30.976731] system 00:09: legacy freeze
[   30.976738] pnp 00:08: legacy freeze
[   30.976743] pnp 00:07: legacy freeze
[   30.976747] system 00:06: legacy freeze
[   30.976755] pnp 00:05: legacy freeze
[   30.976759] rtc_cmos 00:04: legacy freeze
[   30.976772] i8042 kbd 00:03: legacy freeze
[   30.976779] i8042 aux 00:02: legacy freeze
[   30.976787] system 00:01: legacy freeze
[   30.976794] pnp 00:00: legacy freeze
[   30.976809] pci 0000:03:09.3: freeze
[   30.976815] pci 0000:03:09.2: freeze
[   30.976820] sdhci-pci 0000:03:09.1: freeze
[   30.976917] sdhci-pci 0000:03:09.1: PCI INT B disabled
[   30.990284] pci 0000:03:09.0: freeze
[   30.990293] iwl3945 0000:0b:00.0: freeze
[   30.990511] iwl3945 0000:0b:00.0: Master Disable Timed Out, 100 usec
[   31.010300] sky2 0000:09:00.0: freeze
[   31.030289] pci 0000:01:00.0: freeze
[   31.030296] pci 0000:00:1f.3: freeze
[   31.030301] ahci 0000:00:1f.2: freeze
[   31.070325] ata_piix 0000:00:1f.1: freeze
[   31.070429] ata2: port disabled. ignoring.
[   31.070501] ata_piix 0000:00:1f.1: PCI INT A disabled
[   31.070507] pci 0000:00:1f.0: freeze
[   31.070512] pci 0000:00:1e.0: freeze
[   31.070517] ehci_hcd 0000:00:1d.7: freeze
[   31.070523] uhci_hcd 0000:00:1d.2: freeze
[   31.070528] uhci_hcd 0000:00:1d.1: freeze
[   31.070533] uhci_hcd 0000:00:1d.0: freeze
[   31.070537] pcieport 0000:00:1c.4: freeze
[   31.070546] pcieport 0000:00:1c.1: freeze
[   31.070554] pcieport 0000:00:1c.0: freeze
[   31.070561] HDA Intel 0000:00:1b.0: freeze
[   31.620252] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   31.640178] ehci_hcd 0000:00:1a.7: freeze
[   31.640187] uhci_hcd 0000:00:1a.1: freeze
[   31.640192] uhci_hcd 0000:00:1a.0: freeze
[   31.640198] pcieport 0000:00:01.0: freeze
[   31.640206] pci 0000:00:00.0: freeze
[   31.640214] thermal LNXTHERM:01: legacy freeze
[   31.640219] acpi LNXTHERM:00: legacy freeze
[   31.640224] wmi pnp0c14:00: legacy freeze
[   31.640229] acpi PNP0C32:00: legacy freeze
[   31.640234] battery PNP0C0A:00: legacy freeze
[   31.640240] ac ACPI0003:00: legacy freeze
[   31.640245] button PNP0C0E:00: legacy freeze
[   31.640250] button PNP0C0C:00: legacy freeze
[   31.640254] button PNP0C0D:00: legacy freeze
[   31.640259] acpi PNP0C01:03: legacy freeze
[   31.640264] pci_link PNP0C0F:07: legacy freeze
[   31.640268] pci_link PNP0C0F:06: legacy freeze
[   31.640273] pci_link PNP0C0F:05: legacy freeze
[   31.640278] pci_link PNP0C0F:04: legacy freeze
[   31.640283] pci_link PNP0C0F:03: legacy freeze
[   31.640287] pci_link PNP0C0F:02: legacy freeze
[   31.640292] pci_link PNP0C0F:01: legacy freeze
[   31.640297] pci_link PNP0C0F:00: legacy freeze
[   31.640301] acpi device:3d: legacy freeze
[   31.640306] acpi device:3c: legacy freeze
[   31.640310] acpi device:3b: legacy freeze
[   31.640315] acpi device:3a: legacy freeze
[   31.640320] acpi device:39: legacy freeze
[   31.640324] acpi device:38: legacy freeze
[   31.640328] acpi device:37: legacy freeze
[   31.640333] acpi device:36: legacy freeze
[   31.640337] acpi device:35: legacy freeze
[   31.640342] acpi device:34: legacy freeze
[   31.640346] acpi device:33: legacy freeze
[   31.640350] acpi device:32: legacy freeze
[   31.640355] acpi PNP0C01:02: legacy freeze
[   31.640360] acpi PNP0C01:01: legacy freeze
[   31.640364] acpi device:31: legacy freeze
[   31.640368] acpi device:30: legacy freeze
[   31.640373] acpi device:2f: legacy freeze
[   31.640377] acpi device:2e: legacy freeze
[   31.640382] video LNXVIDEO:00: legacy freeze
[   31.640387] acpi device:2d: legacy freeze
[   31.640391] acpi device:2c: legacy freeze
[   31.640396] acpi device:2b: legacy freeze
[   31.640400] acpi device:2a: legacy freeze
[   31.640405] acpi device:29: legacy freeze
[   31.640409] acpi device:28: legacy freeze
[   31.640414] acpi device:27: legacy freeze
[   31.640418] acpi device:26: legacy freeze
[   31.640422] acpi device:25: legacy freeze
[   31.640427] acpi device:24: legacy freeze
[   31.640431] acpi device:23: legacy freeze
[   31.640436] acpi device:22: legacy freeze
[   31.640440] acpi device:21: legacy freeze
[   31.640445] acpi device:20: legacy freeze
[   31.640449] acpi device:1f: legacy freeze
[   31.640453] acpi device:1e: legacy freeze
[   31.640458] acpi device:1d: legacy freeze
[   31.640462] acpi device:1c: legacy freeze
[   31.640467] acpi device:1b: legacy freeze
[   31.640471] acpi device:1a: legacy freeze
[   31.640476] acpi device:19: legacy freeze
[   31.640480] acpi device:18: legacy freeze
[   31.640485] acpi device:17: legacy freeze
[   31.640489] acpi device:16: legacy freeze
[   31.640494] acpi device:15: legacy freeze
[   31.640498] acpi device:14: legacy freeze
[   31.640503] acpi device:13: legacy freeze
[   31.640507] acpi device:12: legacy freeze
[   31.640512] acpi device:11: legacy freeze
[   31.640516] acpi device:10: legacy freeze
[   31.640521] acpi device:0f: legacy freeze
[   31.640525] acpi device:0e: legacy freeze
[   31.640529] acpi device:0d: legacy freeze
[   31.640534] acpi device:0c: legacy freeze
[   31.640539] acpi device:0b: legacy freeze
[   31.640543] acpi device:0a: legacy freeze
[   31.640548] acpi device:09: legacy freeze
[   31.640552] acpi device:08: legacy freeze
[   31.640557] acpi device:07: legacy freeze
[   31.640561] acpi device:06: legacy freeze
[   31.640566] acpi device:05: legacy freeze
[   31.640570] acpi device:04: legacy freeze
[   31.640575] acpi device:03: legacy freeze
[   31.640579] acpi device:02: legacy freeze
[   31.640584] acpi device:01: legacy freeze
[   31.640588] acpi PNP0103:00: legacy freeze
[   31.640593] acpi PNP0C04:00: legacy freeze
[   31.640597] acpi PNP0200:00: legacy freeze
[   31.640602] acpi PNP0000:00: legacy freeze
[   31.640607] acpi PNP0C01:00: legacy freeze
[   31.640611] acpi PNP0800:00: legacy freeze
[   31.640616] acpi PNP0100:00: legacy freeze
[   31.640620] acpi PNP0B00:00: legacy freeze
[   31.640624] acpi PNP0303:00: legacy freeze
[   31.640629] acpi PNP0F13:00: legacy freeze
[   31.640633] acpi PNP0C02:00: legacy freeze
[   31.640638] acpi device:00: legacy freeze
[   31.640643] pci_root PNP0A03:00: legacy freeze
[   31.640648] acpi LNXSYBUS:00: legacy freeze
[   31.640652] processor LNXCPU:01: legacy freeze
[   31.640660] processor LNXCPU:00: legacy freeze
[   31.640665] acpi LNXSYSTM:00: legacy freeze
[   31.640676] PM: freeze of devices complete after 709.277 msecs
[   31.640762] dell-laptop dell-laptop: LATE freeze
[   31.640767] platform regulatory.0: LATE freeze
[   31.640794] dcdbas dcdbas: LATE freeze
[   31.640798] platform dell_rbu: LATE freeze
[   31.640803] iTCO_wdt iTCO_wdt: LATE freeze
[   31.640807] coretemp coretemp.1: LATE freeze
[   31.640811] coretemp coretemp.0: LATE freeze
[   31.640815] psmouse serio1: LATE freeze
[   31.640819] atkbd serio0: LATE freeze
[   31.640823] i8042 i8042: LATE freeze
[   31.640833] serial8250 serial8250: LATE freeze
[   31.640847] vesafb vesafb.0: LATE freeze
[   31.640853] pcspkr pcspkr: LATE freeze
[   31.640862] pci 0000:03:09.3: LATE freeze
[   31.640915] pci 0000:03:09.2: LATE freeze
[   31.640966] sdhci-pci 0000:03:09.1: LATE freeze
[   31.640970] pci 0000:03:09.0: LATE freeze
[   31.641021] iwl3945 0000:0b:00.0: LATE freeze
[   31.641026] sky2 0000:09:00.0: LATE freeze
[   31.641030] pci 0000:01:00.0: LATE freeze
[   31.641101] pci 0000:00:1f.3: LATE freeze
[   31.641145] ahci 0000:00:1f.2: LATE freeze
[   31.641149] ata_piix 0000:00:1f.1: LATE freeze
[   31.641153] pci 0000:00:1f.0: LATE freeze
[   31.641213] pci 0000:00:1e.0: LATE freeze
[   31.641263] ehci_hcd 0000:00:1d.7: LATE freeze
[   31.641319] uhci_hcd 0000:00:1d.2: LATE freeze
[   31.641363] uhci_hcd 0000:00:1d.1: LATE freeze
[   31.641406] uhci_hcd 0000:00:1d.0: LATE freeze
[   31.641450] pcieport 0000:00:1c.4: LATE freeze
[   31.641454] pcieport 0000:00:1c.1: LATE freeze
[   31.641458] pcieport 0000:00:1c.0: LATE freeze
[   31.641462] HDA Intel 0000:00:1b.0: LATE freeze
[   31.641466] ehci_hcd 0000:00:1a.7: LATE freeze
[   31.641521] uhci_hcd 0000:00:1a.1: LATE freeze
[   31.641564] uhci_hcd 0000:00:1a.0: LATE freeze
[   31.641607] pcieport 0000:00:01.0: LATE freeze
[   31.641611] pci 0000:00:00.0: LATE freeze
[   31.641656] PM: late freeze of devices complete after 0.974 msecs
[   31.646446] ACPI: Preparing to enter system sleep state S4
[   31.648925] PM: Saving platform NVS memory
[   31.680030] Disabling non-boot CPUs ...
[   31.841534] CPU 1 is now offline
[   31.841538] SMP alternatives: switching to UP code
[   31.851795] Extended CMOS year: 2000
[   31.851795] PM: Restoring platform NVS memory
[   31.851795] Extended CMOS year: 2000
[   31.851795] Enabling non-boot CPUs ...
[   31.870240] SMP alternatives: switching to SMP code
[   31.880808] Booting Node 0 Processor 1 APIC 0x1
[   32.100766] CPU1 is up
[   32.102106] ACPI: Waking up from system sleep state S4
[   32.112496] pci 0000:00:00.0: EARLY restore
[   32.112524] pcieport 0000:00:01.0: EARLY restore
[   32.112556] uhci_hcd 0000:00:1a.0: EARLY restore
[   32.112586] uhci_hcd 0000:00:1a.1: EARLY restore
[   32.112616] ehci_hcd 0000:00:1a.7: EARLY restore
[   32.112663] HDA Intel 0000:00:1b.0: EARLY restore
[   32.112717] pcieport 0000:00:1c.0: EARLY restore
[   32.112787] pcieport 0000:00:1c.1: EARLY restore
[   32.112857] pcieport 0000:00:1c.4: EARLY restore
[   32.112927] uhci_hcd 0000:00:1d.0: EARLY restore
[   32.112957] uhci_hcd 0000:00:1d.1: EARLY restore
[   32.112987] uhci_hcd 0000:00:1d.2: EARLY restore
[   32.113017] ehci_hcd 0000:00:1d.7: EARLY restore
[   32.113064] pci 0000:00:1e.0: EARLY restore
[   32.113103] pci 0000:00:1f.0: EARLY restore
[   32.113153] ata_piix 0000:00:1f.1: EARLY restore
[   32.113181] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2880001, writing 0x2880005)
[   32.113188] ahci 0000:00:1f.2: EARLY restore
[   32.113226] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[   32.113258] pci 0000:00:1f.3: EARLY restore
[   32.113287] pci 0000:01:00.0: EARLY restore
[   32.113365] sky2 0000:09:00.0: EARLY restore
[   32.113489] iwl3945 0000:0b:00.0: EARLY restore
[   32.113670] iwl3945 0000:0b:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[   32.113782] pci 0000:03:09.0: EARLY restore
[   32.113822] sdhci-pci 0000:03:09.1: EARLY restore
[   32.113855] sdhci-pci 0000:03:09.1: restoring config space at offset 0x1 (was 0x2100102, writing 0x2100106)
[   32.113866] pci 0000:03:09.2: EARLY restore
[   32.113906] pci 0000:03:09.3: EARLY restore
[   32.113951] pcspkr pcspkr: EARLY restore
[   32.113954] vesafb vesafb.0: EARLY restore
[   32.113961] serial8250 serial8250: EARLY restore
[   32.113966] i8042 i8042: EARLY restore
[   32.113968] atkbd serio0: EARLY restore
[   32.113970] psmouse serio1: EARLY restore
[   32.113972] coretemp coretemp.0: EARLY restore
[   32.113973] coretemp coretemp.1: EARLY restore
[   32.113975] iTCO_wdt iTCO_wdt: EARLY restore
[   32.113977] platform dell_rbu: EARLY restore
[   32.113979] dcdbas dcdbas: EARLY restore
[   32.113995] platform regulatory.0: EARLY restore
[   32.113997] dell-laptop dell-laptop: EARLY restore
[   32.114002] PM: early restore of devices complete after 1.520 msecs
[   32.114035] acpi LNXSYSTM:00: legacy restore
[   32.114037] processor LNXCPU:00: legacy restore
[   32.114041] processor LNXCPU:01: legacy restore
[   32.114042] acpi LNXSYBUS:00: legacy restore
[   32.114044] pci_root PNP0A03:00: legacy restore
[   32.114046] acpi device:00: legacy restore
[   32.114047] acpi PNP0C02:00: legacy restore
[   32.114049] acpi PNP0F13:00: legacy restore
[   32.114051] acpi PNP0303:00: legacy restore
[   32.114052] acpi PNP0B00:00: legacy restore
[   32.114054] acpi PNP0100:00: legacy restore
[   32.114055] acpi PNP0800:00: legacy restore
[   32.114057] acpi PNP0C01:00: legacy restore
[   32.114059] acpi PNP0000:00: legacy restore
[   32.114060] acpi PNP0200:00: legacy restore
[   32.114062] acpi PNP0C04:00: legacy restore
[   32.114063] acpi PNP0103:00: legacy restore
[   32.114065] acpi device:01: legacy restore
[   32.114066] acpi device:02: legacy restore
[   32.114068] acpi device:03: legacy restore
[   32.114069] acpi device:04: legacy restore
[   32.114071] acpi device:05: legacy restore
[   32.114073] acpi device:06: legacy restore
[   32.114074] acpi device:07: legacy restore
[   32.114076] acpi device:08: legacy restore
[   32.114077] acpi device:09: legacy restore
[   32.114079] acpi device:0a: legacy restore
[   32.114080] acpi device:0b: legacy restore
[   32.114082] acpi device:0c: legacy restore
[   32.114084] acpi device:0d: legacy restore
[   32.114085] acpi device:0e: legacy restore
[   32.114087] acpi device:0f: legacy restore
[   32.114088] acpi device:10: legacy restore
[   32.114090] acpi device:11: legacy restore
[   32.114091] acpi device:12: legacy restore
[   32.114093] acpi device:13: legacy restore
[   32.114095] acpi device:14: legacy restore
[   32.114096] acpi device:15: legacy restore
[   32.114098] acpi device:16: legacy restore
[   32.114099] acpi device:17: legacy restore
[   32.114101] acpi device:18: legacy restore
[   32.114102] acpi device:19: legacy restore
[   32.114104] acpi device:1a: legacy restore
[   32.114105] acpi device:1b: legacy restore
[   32.114107] acpi device:1c: legacy restore
[   32.114108] acpi device:1d: legacy restore
[   32.114110] acpi device:1e: legacy restore
[   32.114111] acpi device:1f: legacy restore
[   32.114119] acpi device:20: legacy restore
[   32.114120] acpi device:21: legacy restore
[   32.114122] acpi device:22: legacy restore
[   32.114123] acpi device:23: legacy restore
[   32.114124] acpi device:24: legacy restore
[   32.114126] acpi device:25: legacy restore
[   32.114127] acpi device:26: legacy restore
[   32.114129] acpi device:27: legacy restore
[   32.114130] acpi device:28: legacy restore
[   32.114132] acpi device:29: legacy restore
[   32.114133] acpi device:2a: legacy restore
[   32.114134] acpi device:2b: legacy restore
[   32.114136] acpi device:2c: legacy restore
[   32.114137] acpi device:2d: legacy restore
[   32.114139] video LNXVIDEO:00: legacy restore
[   32.115963] acpi device:2e: legacy restore
[   32.115965] acpi device:2f: legacy restore
[   32.115967] acpi device:30: legacy restore
[   32.115968] acpi device:31: legacy restore
[   32.115970] acpi PNP0C01:01: legacy restore
[   32.115971] acpi PNP0C01:02: legacy restore
[   32.115972] acpi device:32: legacy restore
[   32.115974] acpi device:33: legacy restore
[   32.115975] acpi device:34: legacy restore
[   32.115977] acpi device:35: legacy restore
[   32.115978] acpi device:36: legacy restore
[   32.115980] acpi device:37: legacy restore
[   32.115981] acpi device:38: legacy restore
[   32.115982] acpi device:39: legacy restore
[   32.115984] acpi device:3a: legacy restore
[   32.115985] acpi device:3b: legacy restore
[   32.115987] acpi device:3c: legacy restore
[   32.115988] acpi device:3d: legacy restore
[   32.115990] pci_link PNP0C0F:00: legacy restore
[   32.115991] pci_link PNP0C0F:01: legacy restore
[   32.115993] pci_link PNP0C0F:02: legacy restore
[   32.115994] pci_link PNP0C0F:03: legacy restore
[   32.115996] pci_link PNP0C0F:04: legacy restore
[   32.115997] pci_link PNP0C0F:05: legacy restore
[   32.115999] pci_link PNP0C0F:06: legacy restore
[   32.116001] pci_link PNP0C0F:07: legacy restore
[   32.116002] acpi PNP0C01:03: legacy restore
[   32.116004] button PNP0C0D:00: legacy restore
[   32.257677] button PNP0C0C:00: legacy restore
[   32.257680] button PNP0C0E:00: legacy restore
[   32.257682] ac ACPI0003:00: legacy restore
[   32.257717] battery PNP0C0A:00: legacy restore
[   32.283574] acpi PNP0C32:00: legacy restore
[   32.283577] wmi pnp0c14:00: legacy restore
[   32.283578] acpi LNXTHERM:00: legacy restore
[   32.283580] thermal LNXTHERM:01: legacy restore
[   32.283654] pci 0000:00:00.0: restore
[   32.283657] pcieport 0000:00:01.0: restore
[   32.283660] uhci_hcd 0000:00:1a.0: restore
[   32.283666] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   32.283669] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[   32.283688] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   32.283689] uhci_hcd 0000:00:1a.0: Performing full reset
[   32.283710] usb usb3: root hub lost power or was reset
[   32.283711] usb usb3: suspend_rh
[   32.283740] uhci_hcd 0000:00:1a.1: restore
[   32.283744] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   32.283747] uhci_hcd 0000:00:1a.1: uhci_pci_resume
[   32.283765] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[   32.283766] uhci_hcd 0000:00:1a.1: Performing full reset
[   32.283787] usb usb4: root hub lost power or was reset
[   32.283788] usb usb4: suspend_rh
[   32.283802] ehci_hcd 0000:00:1a.7: restore
[   32.283807] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   32.283812] usb usb1: root hub lost power or was reset
[   32.283817] ehci_hcd 0000:00:1a.7: reset command 010002 (park)=0 ithresh=1 period=1024 Reset HALT
[   32.287711] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   32.287716] HDA Intel 0000:00:1b.0: restore
[   32.287723] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   32.287729] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   32.287772] HDA Intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[   32.287805] pcieport 0000:00:1c.0: restore
[   32.287808] pcieport 0000:00:1c.1: restore
[   32.287810] pcieport 0000:00:1c.4: restore
[   32.287813] uhci_hcd 0000:00:1d.0: restore
[   32.287817] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   32.287820] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[   32.287838] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   32.287839] uhci_hcd 0000:00:1d.0: Performing full reset
[   32.287859] usb usb5: root hub lost power or was reset
[   32.287860] usb usb5: suspend_rh
[   32.287874] uhci_hcd 0000:00:1d.1: restore
[   32.287879] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   32.287882] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[   32.287899] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   32.287901] uhci_hcd 0000:00:1d.1: Performing full reset
[   32.287921] usb usb6: root hub lost power or was reset
[   32.287922] usb usb6: suspend_rh
[   32.287946] uhci_hcd 0000:00:1d.2: restore
[   32.287951] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   32.287954] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[   32.287972] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   32.287973] uhci_hcd 0000:00:1d.2: Performing full reset
[   32.287992] usb usb7: root hub lost power or was reset
[   32.287994] usb usb7: suspend_rh
[   32.288018] ehci_hcd 0000:00:1d.7: restore
[   32.288022] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   32.288027] usb usb2: root hub lost power or was reset
[   32.288032] ehci_hcd 0000:00:1d.7: reset command 010002 (park)=0 ithresh=1 period=1024 Reset HALT
[   32.291928] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   32.291933] pci 0000:00:1e.0: restore
[   32.291939] pci 0000:00:1e.0: setting latency timer to 64
[   32.291942] pci 0000:00:1f.0: restore
[   32.291944] ata_piix 0000:00:1f.1: restore
[   32.291949] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   32.291954] ata_piix 0000:00:1f.1: setting latency timer to 64
[   32.291970] ata1.00: _GTF evaluation failed (AE 0x1001)
[   32.292132] ata2: port disabled. ignoring.
[   32.292148] ahci 0000:00:1f.2: restore
[   32.292156] ahci 0000:00:1f.2: setting latency timer to 64
[   32.292207] pci 0000:00:1f.3: restore
[   32.292208] pci 0000:01:00.0: restore
[   32.292210] sky2 0000:09:00.0: restore
[   32.292264] iwl3945 0000:0b:00.0: restore
[   32.292312] pci 0000:03:09.0: restore
[   32.292313] sdhci-pci 0000:03:09.1: restore
[   32.292318] sdhci-pci 0000:03:09.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   32.293335] pci 0000:03:09.2: restore
[   32.293337] pci 0000:03:09.3: restore
[   32.293341] pnp 00:00: legacy restore
[   32.293343] system 00:01: legacy restore
[   32.293345] i8042 aux 00:02: legacy restore
[   32.293347] i8042 kbd 00:03: legacy restore
[   32.293350] rtc_cmos 00:04: legacy restore
[   32.293352] pnp 00:05: legacy restore
[   32.293354] system 00:06: legacy restore
[   32.293355] pnp 00:07: legacy restore
[   32.293357] pnp 00:08: legacy restore
[   32.293359] system 00:09: legacy restore
[   32.293361] system 00:0a: legacy restore
[   32.293362] system 00:0b: legacy restore
[   32.293364] system 00:0c: legacy restore
[   32.293370] pcspkr pcspkr: restore
[   32.293375] vesafb vesafb.0: restore
[   32.293394] serial8250 serial8250: restore
[   32.293398] usb usb1: type restore
[   32.293401] usb usb1: usb resume
[   32.293403] ehci_hcd 0000:00:1a.7: resume root hub after power loss
[   32.440506] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[   32.440517] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[   32.460247] hub 1-0:1.0: hub_reset_resume
[   32.460254] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   32.510594] ata1.00: configured for UDMA/33
[   32.570175] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[   32.570187] hub 1-0:1.0: port 1: status 0501 change 0001
[   32.570203] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[   32.640186] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   32.641909] ata3.00: configured for UDMA/100
[   32.660170] ata5: SATA link down (SStatus 0 SControl 300)
[   32.680201] usb usb2: type restore
[   32.680209] usb usb2: usb resume
[   32.680216] ehci_hcd 0000:00:1d.7: resume root hub after power loss
[   32.730254] ehci_hcd 0000:00:1d.7: port 3 low speed --> companion
[   32.830342] ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
[   32.830354] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
[   32.830365] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[   32.850187] hub 2-0:1.0: hub_reset_resume
[   32.850194] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   32.960180] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[   32.960192] hub 2-0:1.0: port 1: status 0501 change 0001
[   32.960208] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[   32.960214] hub 2-0:1.0: port 2: status 0501 change 0001
[   32.960241] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[   33.070177] usb usb3: type restore
[   33.070185] usb usb3: usb resume
[   33.070190] usb usb3: wakeup_rh
[   33.120231] hub 3-0:1.0: hub_reset_resume
[   33.120236] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   33.230254] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[   33.230272] uhci_hcd 0000:00:1a.0: port 2 portsc 009b,00
[   33.230279] hub 3-0:1.0: port 2: status 0101 change 0003
[   33.340177] usb usb4: type restore
[   33.340188] usb usb5: type restore
[   33.340195] usb usb6: type restore
[   33.340200] usb usb6: usb resume
[   33.340205] usb usb6: wakeup_rh
[   33.390232] hub 6-0:1.0: hub_reset_resume
[   33.390237] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   33.500180] uhci_hcd 0000:00:1d.1: port 1 portsc 01ab,00
[   33.500190] hub 6-0:1.0: port 1: status 0301 change 0003
[   33.610285] usb usb7: type restore
[   33.610294] usb usb7: usb resume
[   33.610298] usb usb7: wakeup_rh
[   33.660167] hub 7-0:1.0: hub_reset_resume
[   33.660174] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   33.770188] uhci_hcd 0000:00:1d.2: port 2 portsc 009b,00
[   33.770196] hub 7-0:1.0: port 2: status 0101 change 0003
[   33.880179] i8042 i8042: restore
[   33.882693] atkbd serio0: restore
[   33.882701] psmouse serio1: restore
[   33.882706] input input0: type restore
[   33.882726] rtc rtc0: legacy class restore
[   33.882802] coretemp coretemp.0: restore
[   33.882808] coretemp coretemp.1: restore
[   33.882814] iTCO_wdt iTCO_wdt: restore
[   33.882821] leds mmc0::: legacy class restore
[   33.882827] platform dell_rbu: restore
[   33.882832] dcdbas dcdbas: restore
[   33.882840] input input1: type restore
[   33.883499] usb 1-1: type restore
[   33.883518] usb 1-1: finish reset-resume
[   33.940382] ehci_hcd 0000:00:1a.7: port 1 high speed
[   33.940393] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   34.000190] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[   34.060379] ehci_hcd 0000:00:1a.7: port 1 high speed
[   34.060390] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   34.154536] input input2: type restore
[   34.154547] input input3: type restore
[   34.154555] input input4: type restore
[   34.154561] input input5: type restore
[   34.154567] input input6: type restore
[   34.154590] scsi host0: legacy restore
[   34.154597] usb 2-1: type restore
[   34.154614] usb 2-1: finish reset-resume
[   34.210464] ehci_hcd 0000:00:1d.7: port 1 high speed
[   34.210475] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   34.270185] usb 2-1: reset high speed USB device using ehci_hcd and address 2
[   34.330464] ehci_hcd 0000:00:1d.7: port 1 high speed
[   34.330474] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   34.421745] scsi host1: legacy restore
[   34.421754] scsi host2: legacy restore
[   34.421763] scsi host3: legacy restore
[   34.421769] scsi host4: legacy restore
[   34.421774] scsi host5: legacy restore
[   34.421779] scsi target0:0:0: legacy restore
[   34.421784] sr 0:0:0:0: legacy restore
[   34.421797] usb 2-2: type restore
[   34.421813] usb 2-2: finish reset-resume
[   34.480464] ehci_hcd 0000:00:1d.7: port 2 high speed
[   34.480475] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   34.540219] usb 2-2: reset high speed USB device using ehci_hcd and address 3
[   34.600464] ehci_hcd 0000:00:1d.7: port 2 high speed
[   34.600475] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   34.691982] hub 2-2:1.0: hub_reset_resume
[   34.691990] hub 2-2:1.0: enabling power on all ports
[   34.800611] hub 2-2:1.0: port 1: status 0101 change 0001
[   34.910186] usb 2-2: link qh256-0001/ffff88011c2bc940 start 2 [1/0 us]
[   34.910208] scsi target3:0:0: legacy restore
[   34.910213] sd 3:0:0:0: legacy restore
[   34.910220] sd 3:0:0:0: [sda] Starting disk
[   34.941998] usb 3-2: type restore
[   34.942024] usb 3-2: finish reset-resume
[   35.060177] usb 3-2: reset full speed USB device using uhci_hcd and address 2
[   35.200173] usb 3-2: ep0 maxpacket = 8
[   35.216414] usb 6-1: type restore
[   35.216436] usb 6-1: finish reset-resume
[   35.480177] usb 6-1: reset low speed USB device using uhci_hcd and address 2
[   35.830409] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   35.830427] input input7: type restore
[   35.830457] usb 7-2: type restore
[   35.830475] usb 7-2: finish reset-resume
[   35.950185] usb 7-2: reset full speed USB device using uhci_hcd and address 2
[   36.090165] usb 7-2: ep0 maxpacket = 8
[   36.105394] hub 7-2:1.0: hub_reset_resume
[   36.105402] hub 7-2:1.0: enabling power on all ports
[   36.211400] hub 7-2:1.0: port 1: status 0101 change 0001
[   36.213400] hub 7-2:1.0: port 2: status 0101 change 0001
[   36.215399] hub 7-2:1.0: port 3: status 0101 change 0001
[   36.320182] uhci_hcd 0000:00:1d.2: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[   36.320199] usb 2-2.1: type restore
[   36.320714] usb 2-2.1: finish reset-resume
[   36.400611] usb 2-2.1: reset full speed USB device using ehci_hcd and address 6
[   36.510166] usb 2-2.1: ep0 maxpacket = 8
[   36.512489] usblp 2-2.1:1.1: no reset_resume for driver usblp?
[   36.512497] usblp 2-2.1:1.1: forced unbind
[   36.512516] drivers/usb/core/file.c: removing 0 minor
[   36.512525] PM: Removing info for No Bus:lp0
[   36.512624] usblp0: removed
[   36.512643] usb 7-2.1: type restore
[   36.514400] usb 7-2.1: finish reset-resume
[   36.591403] usb 7-2.1: reset full speed USB device using uhci_hcd and address 3
[   36.703400] btusb 7-2.1:1.0: no reset_resume for driver btusb?
[   36.703408] btusb 7-2.1:1.1: no reset_resume for driver btusb?
[   36.703414] btusb 7-2.1:1.0: forced unbind
[   36.703445] PM: Removing info for No Bus:rfkill0
[   36.703497] PM: Removing info for No Bus:hci0
[   36.703561] usb 7-2.2: type restore
[   36.704400] usb 7-2.2: finish reset-resume
[   36.781394] usb 7-2.2: reset full speed USB device using uhci_hcd and address 4
[   36.880164] usb 7-2.2: ep0 maxpacket = 8
[   36.897406] uhci_hcd 0000:00:1d.2: reserve dev 4 ep81-INT, period 8, phase 4, 17 us
[   36.897423] input input8: type restore
[   36.897453] usb 7-2.3: type restore
[   36.898406] usb 7-2.3: finish reset-resume
[   36.971403] usb 7-2.3: reset full speed USB device using uhci_hcd and address 5
[   37.070166] usb 7-2.3: ep0 maxpacket = 8
[   37.087408] input input9: type restore
[   37.087422] scsi target2:0:0: legacy restore
[   37.087427] sd 2:0:0:0: legacy restore
[   37.087444] platform regulatory.0: restore
[   37.087450] dell-laptop dell-laptop: restore
[   37.087455] input input10: type restore
[   37.087463] input input11: type restore
[   37.087468] input input12: type restore
[   37.087474] input input13: type restore
[   37.087482] backlight acpi_video0: legacy class restore
[   37.087490] input input14: type restore
[   37.087496] ieee80211 phy0: legacy class restore
[   37.087512] rfkill rfkill1: legacy class restore
[   37.087548] PM: restore of devices complete after 4973.508 msecs
[   37.087565] dell-laptop dell-laptop: completing restore
[   37.087570] platform regulatory.0: completing restore
[   37.087584] usb 7-2.3: completing type restore
[   37.087597] usb 7-2.2: completing type restore
[   37.087616] usb 7-2.1: completing type restore
[   37.087655] usbserial_generic 7-2.1:1.0: usb_probe_interface
[   37.087660] usbserial_generic 7-2.1:1.0: usb_probe_interface - got id
[   37.087702] btusb 7-2.1:1.0: usb_probe_interface
[   37.087706] btusb 7-2.1:1.0: usb_probe_interface - got id
[   37.087766] PM: Adding info for No Bus:hci0
[   37.087808] PM: Adding info for No Bus:rfkill2
[   37.087887] usb 2-2.1: completing type restore
[   37.087903] usblp 2-2.1:1.1: usb_probe_interface
[   37.087908] usblp 2-2.1:1.1: usb_probe_interface - got id
[   37.089142] drivers/usb/core/file.c: looking for a minor, starting at 0
[   37.089228] PM: Adding info for No Bus:lp0
[   37.089263] usblp0: USB Bidirectional printer dev 6 if 1 alt 0 proto 2 vid 0x04E8 pid 0x3419
[   37.089277] usb 7-2: completing type restore
[   37.089291] usb 6-1: completing type restore
[   37.089302] usb 3-2: completing type restore
[   37.089324] usb 2-2: completing type restore
[   37.089349] usb 2-1: completing type restore
[   37.089393] usb 1-1: completing type restore
[   37.089405] dcdbas dcdbas: completing restore
[   37.089410] platform dell_rbu: completing restore
[   37.089418] iTCO_wdt iTCO_wdt: completing restore
[   37.089424] coretemp coretemp.1: completing restore
[   37.089430] coretemp coretemp.0: completing restore
[   37.089442] i8042 i8042: completing restore
[   37.089450] usb usb7: completing type restore
[   37.089459] usb usb6: completing type restore
[   37.089468] usb usb5: completing type restore
[   37.089476] usb usb4: completing type restore
[   37.089484] usb usb3: completing type restore
[   37.089493] usb usb2: completing type restore
[   37.089502] usb usb1: completing type restore
[   37.089513] serial8250 serial8250: completing restore
[   37.089586] vesafb vesafb.0: completing restore
[   37.089605] pcspkr pcspkr: completing restore
[   37.089646] pci 0000:03:09.3: completing restore
[   37.089651] pci 0000:03:09.2: completing restore
[   37.089656] sdhci-pci 0000:03:09.1: completing restore
[   37.089661] pci 0000:03:09.0: completing restore
[   37.089668] iwl3945 0000:0b:00.0: completing restore
[   37.089675] sky2 0000:09:00.0: completing restore
[   37.089681] pci 0000:01:00.0: completing restore
[   37.089685] pci 0000:00:1f.3: completing restore
[   37.089691] ahci 0000:00:1f.2: completing restore
[   37.089696] ata_piix 0000:00:1f.1: completing restore
[   37.089701] pci 0000:00:1f.0: completing restore
[   37.089705] pci 0000:00:1e.0: completing restore
[   37.089710] ehci_hcd 0000:00:1d.7: completing restore
[   37.089715] uhci_hcd 0000:00:1d.2: completing restore
[   37.089719] uhci_hcd 0000:00:1d.1: completing restore
[   37.089724] uhci_hcd 0000:00:1d.0: completing restore
[   37.089729] pcieport 0000:00:1c.4: completing restore
[   37.089733] pcieport 0000:00:1c.1: completing restore
[   37.089738] pcieport 0000:00:1c.0: completing restore
[   37.089743] HDA Intel 0000:00:1b.0: completing restore
[   37.089748] ehci_hcd 0000:00:1a.7: completing restore
[   37.089753] uhci_hcd 0000:00:1a.1: completing restore
[   37.089757] uhci_hcd 0000:00:1a.0: completing restore
[   37.089762] pcieport 0000:00:01.0: completing restore
[   37.089767] pci 0000:00:00.0: completing restore
[   37.322328] ...20%...40%...60%...80%...100%
[   38.089375] Waited for i/o due to readahead not ready 155 times.
[   38.089381] Waited for i/o due to throughput_throttle 95 times.
[   38.232567] Restarting all filesystems ...
[   38.233370] Restarting tasks ... 
[   38.233414] usb usb5: usb resume
[   38.233419] usb usb5: wakeup_rh
[   38.233430] hub 1-0:1.0: state 7 ports 4 chg 0002 evt 0000
[   38.233445] hub 1-0:1.0: port 1, status 0503, change 0000, 480 Mb/s
[   38.233451] hub 2-0:1.0: state 7 ports 6 chg 0006 evt 0000
[   38.233459] hub 2-0:1.0: port 1, status 0503, change 0000, 480 Mb/s
[   38.233466] hub 2-0:1.0: port 2, status 0503, change 0000, 480 Mb/s
[   38.233472] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
[   38.233482] hub 3-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[   38.233487] hub 6-0:1.0: state 7 ports 2 chg 0002 evt 0000
[   38.233497] hub 6-0:1.0: port 1, status 0303, change 0000, 1.5 Mb/s
[   38.233502] hub 7-0:1.0: state 7 ports 2 chg 0004 evt 0000
[   38.233512] hub 7-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[   38.233518] hub 2-2:1.0: state 7 ports 4 chg 0002 evt 0002
[   38.233554] Restarting tasks ... 
[   38.236237] hub 2-2:1.0: port 1, status 0103, change 0000, 12 Mb/s
[   38.236249] done.
[   38.236596] hub 7-2:1.0: state 7 ports 3 chg 000e evt 0008
[   38.238257] hub 7-2:1.0: port 1, status 0103, change 0000, 12 Mb/s
[   38.239248] hub 7-2:1.0: port 2, status 0103, change 0000, 12 Mb/s
[   38.240259] hub 7-2:1.0: port 3, status 0103, change 0000, 12 Mb/s
[   38.242843] TuxOnIce debugging info:
[   38.242845] - TuxOnIce core  : 3.0.99.44
[   38.242845] - Kernel Version : 2.6.33-rc1
[   38.242846] - Compiler vers. : 4.3
[   38.242847] - Attempt number : 1
[   38.242847] - Parameters     : 0 667657 0 1 0 4
[   38.242848] - Overall expected compression percentage: 55.
[   38.242849] - Compressor is 'lzo'.
[   38.242849]   Compressed 255631360 bytes into 63009417 (75 percent compression).
[   38.242850] - Block I/O active.
[   38.242851]   Used 15666 pages from swap on /dev/sda5.
[   38.242851] - Max outstanding reads 1381. Max writes 7145.
[   38.242852]   Memory_needed: 1024 x (4096 + 336 + 104) = 4644864 bytes.
[   38.242853]   Free mem throttle point reached 0.
[   38.242854] - Swap Allocator enabled.
[   38.242854]   Swap available for image: 767093 pages.
[   38.242855] - File Allocator active.
[   38.242856]   Storage available for image: 0 pages.
[   38.242856] - I/O speed: Write 151 MB/s, Read 156 MB/s.
[   38.242857] - Extra pages    : 0 used/2000.
[   38.242858] - Result         : Succeeded.
[   38.280049] hub 5-0:1.0: hub_reset_resume
[   38.280052] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   38.291297] uvcvideo 1-1:1.0: usb_probe_interface
[   38.291301] uvcvideo 1-1:1.0: usb_probe_interface - got id
[   38.291318] uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
[   38.291776] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   38.292340] PM: Adding info for No Bus:video0
[   38.292669] PM: Adding info for No Bus:input16
[   38.292951] input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input16
[   38.292974] PM: Adding info for No Bus:event15
[   38.293263] usbcore: registered new interface driver uvcvideo
[   38.293265] USB Video Class driver (v0.1.0)
[   38.294917] usb 1-1:1.0: uevent
[   38.295014] usb 1-1: uevent
[   38.299755] usb 1-1:1.0: uevent
[   38.299847] usb 1-1: uevent
[   38.390065] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[   38.390090] uhci_hcd 0000:00:1d.0: port 2 portsc 0082,00
[   38.500116] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   39.540182] usb usb5: suspend_rh (auto-stop)
[   41.040208] hub 5-0:1.0: hub_suspend
[   41.040226] usb usb5: bus auto-suspend
[   41.040231] usb usb5: suspend_rh

--------------060802040905000902000807
Content-Type: text/plain;
 name="m1530-async.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="m1530-async.dmesg"

[    0.000000] Linux version 2.6.33-rc1 (nigel@nigel-laptop) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #1 SMP PREEMPT Thu Dec 24 12:38:01 EST 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/head ro root=/dev/sda2 quiet vga=794 resume=/dev/sda5 init S
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfe72000 (usable)
[    0.000000]  BIOS-e820: 00000000dfe72000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 0DFF00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfe72 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfe72000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfe72000 page 4k
[    0.000000] kernel direct mapping tables up to dfe72000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ c000-12000
[    0.000000] RAMDISK: 36896000 - 37fef825
[    0.000000] ACPI: RSDP 00000000000fbc80 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000dfe73a00 00064 (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: FACP 00000000dfe7389c 000F4 (v04 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: DSDT 00000000dfe74000 04BC2 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000dfe82800 00040
[    0.000000] ACPI: HPET 00000000dfe73b00 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000dfe73c00 00068 (v01 DELL    M08     27D8070E ASL  00000047)
[    0.000000] ACPI: MCFG 00000000dfe73bc0 0003E (v16 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: SLIC 00000000dfe73c9c 00176 (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: OSFR 00000000dfe73200 0002C (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: BOOT 00000000dfe737c0 00028 (v01 DELL    M08     27D8070E ASL  00000061)
[    0.000000] ACPI: SSDT 00000000dfe721c0 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0001b4ec14]    TEXT DATA BSS ==> [0001000000 - 0001b4ec14]
[    0.000000]   #2 [0036896000 - 0037fef825]          RAMDISK ==> [0036896000 - 0037fef825]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [0001b4f000 - 0001b4f1ec]              BRK ==> [0001b4f000 - 0001b4f1ec]
[    0.000000]   #5 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #6 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #7 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #8 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfe72
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048081
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 109 pages reserved
[    0.000000]   DMA zone: 3834 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898730 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfe72000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:14000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880028200000 s76568 r8192 d21736 u1048576
[    0.000000] pcpu-alloc: s76568 r8192 d21736 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1031844
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/head ro root=/dev/sda2 quiet vga=794 resume=/dev/sda5 init S
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4023992k/4718592k available (4321k kernel code, 526268k absent, 167424k reserved, 4329k data, 472k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.205 MHz processor.
[    0.010006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.41 BogoMIPS (lpj=21942050)
[    0.010046] Security Framework initialized
[    0.010068] Mount-cache hash table entries: 256
[    0.010203] CPU: Physical Processor ID: 0
[    0.010204] CPU: Processor Core ID: 0
[    0.010207] mce: CPU supports 6 MCE banks
[    0.010214] CPU0: Thermal monitoring enabled (TM2)
[    0.010217] using mwait in idle threads.
[    0.010218] Performance Events: Core2 events, Intel PMU driver.
[    0.010223] ... version:                2
[    0.010224] ... bit width:              40
[    0.010226] ... generic registers:      2
[    0.010227] ... value mask:             000000ffffffffff
[    0.010228] ... max period:             000000007fffffff
[    0.010230] ... fixed-purpose events:   3
[    0.010231] ... event mask:             0000000700000003
[    0.011012] ACPI: Core revision 20091214
[    0.026119] Setting APIC routing to flat
[    0.026497] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.126500] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.160022] Booting Node   0, Processors  #1 Ok.
[    0.330033] Brought up 2 CPUs
[    0.330037] Total of 2 processors activated (8777.40 BogoMIPS).
[    0.330698] PM: Adding info for No Bus:platform
[    0.330698] NET: Registered protocol family 16
[    0.330698] PM: Adding info for No Bus:vtcon0
[    0.330698] ACPI: bus type pci registered
[    0.330698] PM: Adding info for No Bus:id
[    0.330698] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.330698] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.332092] PCI: Using configuration type 1 for base access
[    0.332106] PM: Adding info for No Bus:default
[    0.332106] bio: create slab <bio-0> at 0
[    0.332106] ACPI: EC: Look up EC in DSDT
[    0.358652] ACPI: Interpreter enabled
[    0.358656] ACPI: (supports S0 S3 S4 S5)
[    0.358674] ACPI: Using IOAPIC for interrupt routing
[    0.358712] PM: Adding info for acpi:LNXSYSTM:00
[    0.358712] PM: Adding info for acpi:LNXCPU:00
[    0.358712] PM: Adding info for acpi:LNXCPU:01
[    0.358712] PM: Adding info for acpi:LNXSYBUS:00
[    0.358712] PM: Adding info for acpi:PNP0A03:00
[    0.358712] PM: Adding info for acpi:device:00
[    0.358712] PM: Adding info for acpi:PNP0C02:00
[    0.358712] PM: Adding info for acpi:PNP0F13:00
[    0.358712] PM: Adding info for acpi:PNP0303:00
[    0.358712] PM: Adding info for acpi:PNP0B00:00
[    0.358712] PM: Adding info for acpi:PNP0100:00
[    0.358712] PM: Adding info for acpi:PNP0800:00
[    0.358712] PM: Adding info for acpi:PNP0C01:00
[    0.358712] PM: Adding info for acpi:PNP0000:00
[    0.358712] PM: Adding info for acpi:PNP0200:00
[    0.358712] PM: Adding info for acpi:PNP0C04:00
[    0.358712] PM: Adding info for acpi:PNP0103:00
[    0.358712] PM: Adding info for acpi:device:01
[    0.358712] PM: Adding info for acpi:device:02
[    0.360064] PM: Adding info for acpi:device:03
[    0.364646] PM: Adding info for acpi:device:04
[    0.364656] PM: Adding info for acpi:device:05
[    0.364656] PM: Adding info for acpi:device:06
[    0.364656] PM: Adding info for acpi:device:07
[    0.364656] PM: Adding info for acpi:device:08
[    0.364656] PM: Adding info for acpi:device:09
[    0.364656] PM: Adding info for acpi:device:0a
[    0.364656] PM: Adding info for acpi:device:0b
[    0.373493] PM: Adding info for acpi:device:0c
[    0.373503] PM: Adding info for acpi:device:0d
[    0.373503] PM: Adding info for acpi:device:0e
[    0.373503] PM: Adding info for acpi:device:0f
[    0.374353] PM: Adding info for acpi:device:10
[    0.374365] PM: Adding info for acpi:device:11
[    0.374365] PM: Adding info for acpi:device:12
[    0.374365] PM: Adding info for acpi:device:13
[    0.382694] PM: Adding info for acpi:device:14
[    0.382704] PM: Adding info for acpi:device:15
[    0.382704] PM: Adding info for acpi:device:16
[    0.382704] PM: Adding info for acpi:device:17
[    0.384267] PM: Adding info for acpi:device:18
[    0.384279] PM: Adding info for acpi:device:19
[    0.384279] PM: Adding info for acpi:device:1a
[    0.384279] PM: Adding info for acpi:device:1b
[    0.384279] PM: Adding info for acpi:device:1c
[    0.384279] PM: Adding info for acpi:device:1d
[    0.391638] PM: Adding info for acpi:device:1e
[    0.391648] PM: Adding info for acpi:device:1f
[    0.391648] PM: Adding info for acpi:device:20
[    0.391648] PM: Adding info for acpi:device:21
[    0.391648] PM: Adding info for acpi:device:22
[    0.391648] PM: Adding info for acpi:device:23
[    0.391648] PM: Adding info for acpi:device:24
[    0.391648] PM: Adding info for acpi:device:25
[    0.391648] PM: Adding info for acpi:device:26
[    0.391648] PM: Adding info for acpi:device:27
[    0.391648] PM: Adding info for acpi:device:28
[    0.391648] PM: Adding info for acpi:device:29
[    0.391648] PM: Adding info for acpi:device:2a
[    0.391648] PM: Adding info for acpi:device:2b
[    0.391648] PM: Adding info for acpi:device:2c
[    0.391648] PM: Adding info for acpi:device:2d
[    0.391648] PM: Adding info for acpi:LNXVIDEO:00
[    0.391648] PM: Adding info for acpi:device:2e
[    0.391648] PM: Adding info for acpi:device:2f
[    0.391648] PM: Adding info for acpi:device:30
[    0.391648] PM: Adding info for acpi:device:31
[    0.391648] PM: Adding info for acpi:PNP0C01:01
[    0.391648] PM: Adding info for acpi:PNP0C01:02
[    0.391648] PM: Adding info for acpi:device:32
[    0.391648] PM: Adding info for acpi:device:33
[    0.391648] PM: Adding info for acpi:device:34
[    0.391648] PM: Adding info for acpi:device:35
[    0.391648] PM: Adding info for acpi:device:36
[    0.391648] PM: Adding info for acpi:device:37
[    0.391648] PM: Adding info for acpi:device:38
[    0.391648] PM: Adding info for acpi:device:39
[    0.391648] PM: Adding info for acpi:device:3a
[    0.391648] PM: Adding info for acpi:device:3b
[    0.391648] PM: Adding info for acpi:device:3c
[    0.391648] PM: Adding info for acpi:device:3d
[    0.391648] PM: Adding info for acpi:PNP0C0F:00
[    0.391648] PM: Adding info for acpi:PNP0C0F:01
[    0.391648] PM: Adding info for acpi:PNP0C0F:02
[    0.391648] PM: Adding info for acpi:PNP0C0F:03
[    0.391648] PM: Adding info for acpi:PNP0C0F:04
[    0.391648] PM: Adding info for acpi:PNP0C0F:05
[    0.391648] PM: Adding info for acpi:PNP0C0F:06
[    0.391648] PM: Adding info for acpi:PNP0C0F:07
[    0.391648] PM: Adding info for acpi:PNP0C01:03
[    0.392426] PM: Adding info for acpi:PNP0C0D:00
[    0.392438] PM: Adding info for acpi:PNP0C0C:00
[    0.392438] PM: Adding info for acpi:PNP0C0E:00
[    0.392438] PM: Adding info for acpi:ACPI0003:00
[    0.400224] PM: Adding info for acpi:PNP0C0A:00
[    0.400232] PM: Adding info for acpi:PNP0C32:00
[    0.400232] PM: Adding info for acpi:pnp0c14:00
[    0.400232] PM: Adding info for acpi:LNXTHERM:00
[    0.400232] PM: Adding info for acpi:LNXTHERM:01
[    0.400274] ACPI: No dock devices found.
[    0.415353] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.415367] PM: Adding info for No Bus:pci0000:00
[    0.415375] PM: Adding info for No Bus:0000:00
[    0.415384] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.444304] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.444307] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.444310] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.444312] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.444314] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf3ffffff] (ignored)
[    0.444317] pci_root PNP0A03:00: host bridge window [mem 0xf8000000-0xfebfffff] (ignored)
[    0.444319] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff] (ignored)
[    0.444321] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff] (ignored)
[    0.444323] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff] (ignored)
[    0.444326] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff] (ignored)
[    0.444328] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff] (ignored)
[    0.444330] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff] (ignored)
[    0.444332] pci_root PNP0A03:00: host bridge window [mem 0x120000000-0x317ffffff] (ignored)
[    0.444412] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.444415] pci 0000:00:01.0: PME# disabled
[    0.444502] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    0.444568] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    0.444632] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.444696] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.444702] pci 0000:00:1a.7: PME# disabled
[    0.444747] pci 0000:00:1b.0: reg 10: [mem 0xfebfc000-0xfebfffff 64bit]
[    0.444810] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.444814] pci 0000:00:1b.0: PME# disabled
[    0.444912] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.444917] pci 0000:00:1c.0: PME# disabled
[    0.445018] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.445023] pci 0000:00:1c.1: PME# disabled
[    0.445127] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.445132] pci 0000:00:1c.4: PME# disabled
[    0.445195] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    0.445260] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    0.445325] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.445388] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.445453] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.445458] pci 0000:00:1d.7: PME# disabled
[    0.445625] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.445630] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    0.445634] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    0.445638] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 006c (mask 0007)
[    0.445641] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    0.445695] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.445703] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.445711] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.445718] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.445726] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    0.445790] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    0.445797] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    0.445805] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    0.445813] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    0.445820] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    0.445828] pci 0000:00:1f.2: reg 24: [mem 0xfebfb800-0xfebfbfff]
[    0.445872] pci 0000:00:1f.2: PME# supported from D3hot
[    0.445876] pci 0000:00:1f.2: PME# disabled
[    0.445908] pci 0000:00:1f.3: reg 10: [mem 0xfebfb700-0xfebfb7ff]
[    0.445934] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    0.446001] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.446017] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.446033] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.446042] pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
[    0.446050] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.446157] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.446160] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.446163] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfeafffff]
[    0.446168] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.446231] pci 0000:09:00.0: reg 10: [mem 0xf9ffc000-0xf9ffffff 64bit]
[    0.446242] pci 0000:09:00.0: reg 18: [io  0xde00-0xdeff]
[    0.446332] pci 0000:09:00.0: supports D1 D2
[    0.446333] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.446340] pci 0000:09:00.0: PME# disabled
[    0.446415] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    0.446419] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.446424] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    0.446576] pci 0000:0b:00.0: reg 10: [mem 0xf9eff000-0xf9efffff]
[    0.446821] pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
[    0.446833] pci 0000:0b:00.0: PME# disabled
[    0.446938] pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
[    0.446945] pci 0000:00:1c.1:   bridge window [mem 0xf9e00000-0xf9efffff]
[    0.447011] pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
[    0.447016] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.447021] pci 0000:00:1c.4:   bridge window [mem 0xf9c00000-0xf9dfffff]
[    0.447029] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.447086] pci 0000:03:09.0: reg 10: [mem 0xf9bff800-0xf9bfffff]
[    0.447147] pci 0000:03:09.0: supports D1 D2
[    0.447149] pci 0000:03:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.447154] pci 0000:03:09.0: PME# disabled
[    0.447191] pci 0000:03:09.1: reg 10: [mem 0xf9bff500-0xf9bff5ff]
[    0.447252] pci 0000:03:09.1: supports D1 D2
[    0.447254] pci 0000:03:09.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.447258] pci 0000:03:09.1: PME# disabled
[    0.447296] pci 0000:03:09.2: reg 10: [mem 0xf9bff600-0xf9bff6ff]
[    0.447358] pci 0000:03:09.2: supports D1 D2
[    0.447360] pci 0000:03:09.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.447365] pci 0000:03:09.2: PME# disabled
[    0.447401] pci 0000:03:09.3: reg 10: [mem 0xf9bff700-0xf9bff7ff]
[    0.447462] pci 0000:03:09.3: supports D1 D2
[    0.447464] pci 0000:03:09.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.447469] pci 0000:03:09.3: PME# disabled
[    0.447528] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.447536] pci 0000:00:1e.0:   bridge window [mem 0xf9b00000-0xf9bfffff]
[    0.447571] pci_bus 0000:00: on NUMA node 0
[    0.447575] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.447800] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.447908] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.447960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.448023] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.448092] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.448731] PM: Adding info for pci:0000:00:00.0
[    0.448743] PM: Adding info for pci:0000:00:01.0
[    0.448743] PM: Adding info for pci:0000:00:1a.0
[    0.450556] PM: Adding info for pci:0000:00:1a.1
[    0.450585] PM: Adding info for pci:0000:00:1a.7
[    0.450598] PM: Adding info for pci:0000:00:1b.0
[    0.450602] PM: Adding info for pci:0000:00:1c.0
[    0.450602] PM: Adding info for pci:0000:00:1c.1
[    0.450602] PM: Adding info for pci:0000:00:1c.4
[    0.450602] PM: Adding info for pci:0000:00:1d.0
[    0.450602] PM: Adding info for pci:0000:00:1d.1
[    0.450602] PM: Adding info for pci:0000:00:1d.2
[    0.450602] PM: Adding info for pci:0000:00:1d.7
[    0.450602] PM: Adding info for pci:0000:00:1e.0
[    0.450602] PM: Adding info for pci:0000:00:1f.0
[    0.450602] PM: Adding info for pci:0000:00:1f.1
[    0.450602] PM: Adding info for pci:0000:00:1f.2
[    0.450602] PM: Adding info for pci:0000:00:1f.3
[    0.450602] PM: Adding info for pci:0000:01:00.0
[    0.450602] PM: Adding info for No Bus:0000:01
[    0.450602] PM: Adding info for pci:0000:09:00.0
[    0.450602] PM: Adding info for No Bus:0000:09
[    0.450602] PM: Adding info for pci:0000:0b:00.0
[    0.450602] PM: Adding info for No Bus:0000:0b
[    0.450602] PM: Adding info for No Bus:0000:0c
[    0.450602] PM: Adding info for pci:0000:03:09.0
[    0.450602] PM: Adding info for pci:0000:03:09.1
[    0.450602] PM: Adding info for pci:0000:03:09.2
[    0.450602] PM: Adding info for pci:0000:03:09.3
[    0.450602] PM: Adding info for No Bus:0000:03
[    0.450602] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *7
[    0.450602] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    0.450602] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *5
[    0.460036] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *0, disabled.
[    0.460143] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.460250] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.460356] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.460452] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.460504] PM: Adding info for No Bus:vga_arbiter
[    0.460504] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.460504] vgaarb: loaded
[    0.460504] SCSI subsystem initialized
[    0.460504] libata version 3.00 loaded.
[    0.460504] usbcore: registered new interface driver usbfs
[    0.460504] usbcore: registered new interface driver hub
[    0.460504] usbcore: registered new device driver usb
[    0.460504] PM: Adding info for No Bus:8D9DDCBC-A997-11DA-B012-B622A1EF5492
[    0.460504] PM: Adding info for No Bus:A80593CE-A997-11DA-B012-B622A1EF5492
[    0.460504] PM: Adding info for No Bus:9DBB5994-A997-11DA-B012-B622A1EF5492
[    0.460504] PM: Adding info for No Bus:A3776CE0-1E88-11DB-A98B-0800200C9A66
[    0.460504] PM: Adding info for No Bus:05901221-D566-11D1-B2F0-00A0C9062910
[    0.460504] ACPI: WMI: Mapper loaded
[    0.460504] PCI: Using ACPI for IRQ routing
[    0.460504] PCI: pci_cache_line_size set to 64 bytes
[    0.460504] PM: Adding info for No Bus:lo
[    0.460504] PM: Adding info for No Bus:rfkill
[    0.460504] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.460504] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.460504] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.470037] Switching to clocksource tsc
[    0.470046] pnp: PnP ACPI init
[    0.470053] PM: Adding info for No Bus:pnp0
[    0.470055] ACPI: bus type pnp registered
[    0.484589] PM: Adding info for pnp:00:00
[    0.484668] PM: Adding info for pnp:00:01
[    0.484742] PM: Adding info for pnp:00:02
[    0.484812] PM: Adding info for pnp:00:03
[    0.484881] PM: Adding info for pnp:00:04
[    0.484950] PM: Adding info for pnp:00:05
[    0.485033] PM: Adding info for pnp:00:06
[    0.485104] PM: Adding info for pnp:00:07
[    0.485174] PM: Adding info for pnp:00:08
[    0.485313] PM: Adding info for pnp:00:09
[    0.485561] pnp 00:0a: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.485564] pnp 00:0a: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.485603] PM: Adding info for pnp:00:0a
[    0.485669] pnp 00:0b: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.485672] pnp 00:0b: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.485675] pnp 00:0b: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.485713] PM: Adding info for pnp:00:0b
[    0.504191] PM: Adding info for pnp:00:0c
[    0.504336] pnp: PnP ACPI: found 13 devices
[    0.504338] ACPI: ACPI bus type pnp unregistered
[    0.504346] system 00:01: [mem 0xff800000-0xff8fffff] has been reserved
[    0.504349] system 00:01: [mem 0xffc00000-0xffcfffff] has been reserved
[    0.504355] system 00:06: [io  0x0c80-0x0cff] could not be reserved
[    0.504360] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.504365] system 00:0a: [io  0x0900-0x097f] has been reserved
[    0.504368] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.504374] system 00:0b: [io  0xf400-0xf4fe] has been reserved
[    0.504376] system 00:0b: [io  0x1080-0x10bf] has been reserved
[    0.504378] system 00:0b: [io  0x10c0-0x10df] has been reserved
[    0.504381] system 00:0b: [io  0x0809] has been reserved
[    0.504385] system 00:0c: [mem 0x00000000-0x0009efff] could not be reserved
[    0.504388] system 00:0c: [mem 0x0009f000-0x0009ffff] could not be reserved
[    0.504390] system 00:0c: [mem 0x000c0000-0x000cffff] has been reserved
[    0.504393] system 00:0c: [mem 0x000e0000-0x000fffff] has been reserved
[    0.504395] system 00:0c: [mem 0x00100000-0xdfe71fff] could not be reserved
[    0.504398] system 00:0c: [mem 0xdfe72000-0xdfefffff] has been reserved
[    0.504400] system 00:0c: [mem 0xdff00000-0xdfffffff] has been reserved
[    0.504403] system 00:0c: [mem 0xffe00000-0xffffffff] has been reserved
[    0.504405] system 00:0c: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.504408] system 00:0c: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    0.504410] system 00:0c: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.504413] system 00:0c: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.504415] system 00:0c: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    0.504418] system 00:0c: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    0.504420] system 00:0c: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    0.504423] system 00:0c: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    0.504425] system 00:0c: [mem 0xfed18000-0xfed1bfff] has been reserved
[    0.504428] system 00:0c: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.504490] PM: Adding info for No Bus:mem
[    0.504522] PM: Adding info for No Bus:kmem
[    0.504553] PM: Adding info for No Bus:null
[    0.504584] PM: Adding info for No Bus:port
[    0.504616] PM: Adding info for No Bus:zero
[    0.504648] PM: Adding info for No Bus:full
[    0.504678] PM: Adding info for No Bus:random
[    0.504710] PM: Adding info for No Bus:urandom
[    0.504743] PM: Adding info for No Bus:kmsg
[    0.509411] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.509415] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.509417] pci 0000:00:1c.1: BAR 7: assigned [io  0x2000-0x2fff]
[    0.509420] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
[    0.509423] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.509425] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.509429] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfeafffff]
[    0.509432] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.509437] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    0.509440] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.509446] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    0.509451] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.509459] pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
[    0.509462] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.509469] pci 0000:00:1c.1:   bridge window [mem 0xf9e00000-0xf9efffff]
[    0.509474] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.509481] pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
[    0.509485] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.509491] pci 0000:00:1c.4:   bridge window [mem 0xf9c00000-0xf9dfffff]
[    0.509496] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.509504] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.509506] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.509512] pci 0000:00:1e.0:   bridge window [mem 0xf9b00000-0xf9bfffff]
[    0.509517] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.509533] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.509536] pci 0000:00:01.0: setting latency timer to 64
[    0.509545] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.509550] pci 0000:00:1c.0: setting latency timer to 64
[    0.509561] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.509565] pci 0000:00:1c.1: setting latency timer to 64
[    0.509575] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.509580] pci 0000:00:1c.4: setting latency timer to 64
[    0.509587] pci 0000:00:1e.0: setting latency timer to 64
[    0.509591] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.509594] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.509596] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.509598] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfeafffff]
[    0.509600] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.509602] pci_bus 0000:09: resource 0 [io  0xd000-0xdfff]
[    0.509604] pci_bus 0000:09: resource 1 [mem 0xf9f00000-0xf9ffffff]
[    0.509606] pci_bus 0000:09: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.509608] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    0.509610] pci_bus 0000:0b: resource 1 [mem 0xf9e00000-0xf9efffff]
[    0.509612] pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.509614] pci_bus 0000:0c: resource 0 [io  0xc000-0xcfff]
[    0.509616] pci_bus 0000:0c: resource 1 [mem 0xf9c00000-0xf9dfffff]
[    0.509618] pci_bus 0000:0c: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.509620] pci_bus 0000:03: resource 1 [mem 0xf9b00000-0xf9bfffff]
[    0.509622] pci_bus 0000:03: resource 3 [io  0x0000-0xffff]
[    0.509624] pci_bus 0000:03: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.509659] NET: Registered protocol family 2
[    0.509712] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.510256] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.511982] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.512563] TCP: Hash tables configured (established 262144 bind 65536)
[    0.512566] TCP reno registered
[    0.512569] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.512608] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.512746] NET: Registered protocol family 1
[    0.512773] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.512775] pci 0000:00:1a.0: Performing full reset
[    0.512796] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.512798] pci 0000:00:1a.1: Performing full reset
[    0.512866] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.512868] pci 0000:00:1d.0: Performing full reset
[    0.512889] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.512890] pci 0000:00:1d.1: Performing full reset
[    0.512911] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
[    0.512913] pci 0000:00:1d.2: Performing full reset
[    0.512982] pci 0000:01:00.0: Boot video device
[    0.513046] PCI: CLS 64 bytes, default 64
[    0.513103] Unpacking initramfs...
[    0.741403] Freeing initrd memory: 23910k freed
[    0.754061] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.754066] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.754068] software IO TLB at phys 0x20000000 - 0x24000000
[    0.754271] Simple Boot Flag at 0x79 set to 0x1
[    0.754726] PM: Adding info for No Bus:mcelog
[    0.754810] PM: Adding info for No Bus:msr0
[    0.754847] PM: Adding info for No Bus:msr1
[    0.754916] PM: Adding info for No Bus:cpu0
[    0.754955] PM: Adding info for No Bus:cpu1
[    0.755050] PM: Adding info for platform:pcspkr
[    0.755280] PM: Adding info for No Bus:snapshot
[    0.755312] audit: initializing netlink socket (disabled)
[    0.755328] type=2000 audit(1261660381.749:1): initialized
[    0.755641] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.755832] VFS: Disk quotas dquot_6.5.2
[    0.755854] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.755987] NTFS driver 2.1.29 [Flags: R/O].
[    0.756013] fuse init (API version 7.13)
[    0.756033] PM: Adding info for No Bus:fuse
[    0.756077] msgmni has been set to 7907
[    0.756313] alg: No test for stdrng (krng)
[    0.756322] io scheduler noop registered (default)
[    0.756324] io scheduler deadline registered
[    0.756335] io scheduler cfq registered
[    0.756444] pcieport 0000:00:01.0: setting latency timer to 64
[    0.756476] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.756486] PM: Adding info for pci_express:0000:00:01.0:pcie01
[    0.756524] PM: Adding info for pci_express:0000:00:01.0:pcie04
[    0.756558] PM: Adding info for pci_express:0000:00:01.0:pcie08
[    0.756619] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.756673] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.756686] PM: Adding info for pci_express:0000:00:1c.0:pcie01
[    0.756720] PM: Adding info for pci_express:0000:00:1c.0:pcie04
[    0.756756] PM: Adding info for pci_express:0000:00:1c.0:pcie08
[    0.756845] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.756898] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
[    0.756913] PM: Adding info for pci_express:0000:00:1c.1:pcie01
[    0.756949] PM: Adding info for pci_express:0000:00:1c.1:pcie04
[    0.756984] PM: Adding info for pci_express:0000:00:1c.1:pcie08
[    0.757074] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.757127] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    0.757140] PM: Adding info for pci_express:0000:00:1c.4:pcie01
[    0.757177] PM: Adding info for pci_express:0000:00:1c.4:pcie04
[    0.757211] PM: Adding info for pci_express:0000:00:1c.4:pcie08
[    0.757391] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.757400] PM: Adding info for No Bus:fbcon
[    0.757468] PM: Adding info for platform:vesafb.0
[    0.757602] vesafb: framebuffer at 0xfb000000, mapped to 0xffffc90004100000, using 2560k, total 2560k
[    0.757604] vesafb: mode is 1280x1024x16, linelength=2560, pages=0
[    0.757606] vesafb: scrolling: redraw
[    0.757608] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.757621] PM: Adding info for No Bus:fb0
[    0.757687] PM: Adding info for No Bus:vtcon1
[    0.797451] Console: switching to colour frame buffer device 160x64
[    0.834429] fb0: VESA VGA frame buffer device
[    0.834980] ACPI: SSDT 00000000dfe72cf6 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.835470] ACPI: SSDT 00000000dfe7268c 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.835835] Monitor-Mwait will be used to enter C-1 state
[    0.835856] Monitor-Mwait will be used to enter C-2 state
[    0.840010] Monitor-Mwait will be used to enter C-3 state
[    0.840016] Marking TSC unstable due to TSC halts in idle
[    0.840074] Switching to clocksource hpet
[    0.840098] PM: Adding info for No Bus:cooling_device0
[    0.840478] ACPI: SSDT 00000000dfe72f7c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.840817] ACPI: SSDT 00000000dfe72c71 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.882566] PM: Adding info for No Bus:cooling_device1
[    0.884758] PM: Adding info for No Bus:thermal_zone0
[    0.884876] thermal LNXTHERM:01: registered as thermal_zone0
[    0.884883] ACPI: Thermal Zone [THM] (66 C)
[    0.884942] PM: Adding info for No Bus:tty
[    0.884981] PM: Adding info for No Bus:console
[    0.885027] PM: Adding info for No Bus:tty0
[    0.885098] PM: Adding info for No Bus:vcs
[    0.885135] PM: Adding info for No Bus:vcsa
[    0.885172] PM: Adding info for No Bus:vcs1
[    0.885210] PM: Adding info for No Bus:vcsa1
[    0.885250] PM: Adding info for No Bus:tty1
[    0.885286] PM: Adding info for No Bus:tty2
[    0.885323] PM: Adding info for No Bus:tty3
[    0.885361] PM: Adding info for No Bus:tty4
[    0.885399] PM: Adding info for No Bus:tty5
[    0.885437] PM: Adding info for No Bus:tty6
[    0.885475] PM: Adding info for No Bus:tty7
[    0.885513] PM: Adding info for No Bus:tty8
[    0.885551] PM: Adding info for No Bus:tty9
[    0.885590] PM: Adding info for No Bus:tty10
[    0.885629] PM: Adding info for No Bus:tty11
[    0.885666] PM: Adding info for No Bus:tty12
[    0.885703] PM: Adding info for No Bus:tty13
[    0.885740] PM: Adding info for No Bus:tty14
[    0.885778] PM: Adding info for No Bus:tty15
[    0.885817] PM: Adding info for No Bus:tty16
[    0.885855] PM: Adding info for No Bus:tty17
[    0.885893] PM: Adding info for No Bus:tty18
[    0.885931] PM: Adding info for No Bus:tty19
[    0.885969] PM: Adding info for No Bus:tty20
[    0.886007] PM: Adding info for No Bus:tty21
[    0.886046] PM: Adding info for No Bus:tty22
[    0.886085] PM: Adding info for No Bus:tty23
[    0.886124] PM: Adding info for No Bus:tty24
[    0.886163] PM: Adding info for No Bus:tty25
[    0.886203] PM: Adding info for No Bus:tty26
[    0.886242] PM: Adding info for No Bus:tty27
[    0.886283] PM: Adding info for No Bus:tty28
[    0.886322] PM: Adding info for No Bus:tty29
[    0.886361] PM: Adding info for No Bus:tty30
[    0.886401] PM: Adding info for No Bus:tty31
[    0.886439] PM: Adding info for No Bus:tty32
[    0.886477] PM: Adding info for No Bus:tty33
[    0.886518] PM: Adding info for No Bus:tty34
[    0.886557] PM: Adding info for No Bus:tty35
[    0.886597] PM: Adding info for No Bus:tty36
[    0.886635] PM: Adding info for No Bus:tty37
[    0.886673] PM: Adding info for No Bus:tty38
[    0.886713] PM: Adding info for No Bus:tty39
[    0.886754] PM: Adding info for No Bus:tty40
[    0.886794] PM: Adding info for No Bus:tty41
[    0.886833] PM: Adding info for No Bus:tty42
[    0.886873] PM: Adding info for No Bus:tty43
[    0.886912] PM: Adding info for No Bus:tty44
[    0.886953] PM: Adding info for No Bus:tty45
[    0.886994] PM: Adding info for No Bus:tty46
[    0.887034] PM: Adding info for No Bus:tty47
[    0.887074] PM: Adding info for No Bus:tty48
[    0.887114] PM: Adding info for No Bus:tty49
[    0.887155] PM: Adding info for No Bus:tty50
[    0.887195] PM: Adding info for No Bus:tty51
[    0.887237] PM: Adding info for No Bus:tty52
[    0.887278] PM: Adding info for No Bus:tty53
[    0.887318] PM: Adding info for No Bus:tty54
[    0.887362] PM: Adding info for No Bus:tty55
[    0.887405] PM: Adding info for No Bus:tty56
[    0.887447] PM: Adding info for No Bus:tty57
[    0.887490] PM: Adding info for No Bus:tty58
[    0.887533] PM: Adding info for No Bus:tty59
[    0.887575] PM: Adding info for No Bus:tty60
[    0.887616] PM: Adding info for No Bus:tty61
[    0.887658] PM: Adding info for No Bus:tty62
[    0.887701] PM: Adding info for No Bus:tty63
[    0.887766] PM: Adding info for No Bus:ptmx
[    0.887817] PM: Adding info for No Bus:hpet
[    0.887962] PM: Adding info for No Bus:nvram
[    0.887997] Non-volatile memory driver v1.3
[    0.887999] Linux agpgart interface v0.103
[    0.888140] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.888162] PM: Adding info for platform:serial8250
[    0.888219] PM: Adding info for No Bus:ttyS0
[    0.888273] PM: Adding info for No Bus:ttyS1
[    0.888326] PM: Adding info for No Bus:ttyS2
[    0.888378] PM: Adding info for No Bus:ttyS3
[    0.888913] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    0.888953] sky2 driver version 1.26
[    0.888982] sky2 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.888995] sky2 0000:09:00.0: setting latency timer to 64
[    0.889027] sky2 0000:09:00.0: Yukon-2 FE+ chip revision 0
[    0.889146] sky2 0000:09:00.0: irq 28 for MSI/MSI-X
[    0.889231] PM: Adding info for No Bus:eth0
[    0.889386] sky2 eth0: addr 00:15:c5:83:3e:24
[    0.889452] console [netcon0] enabled
[    0.889454] netconsole: network logging started
[    0.889467] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.889469] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    0.889494] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.889504] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.889507] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.889514] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.889523] ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
[    0.889527] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    0.889558] ehci_hcd 0000:00:1a.7: debug port 1
[    0.889563] ehci_hcd 0000:00:1a.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    0.893439] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.893441] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.893454] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    0.893458] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.897337] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.912517] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.912540] usb usb1: default language 0x0409
[    0.912546] usb usb1: udev 1, busnum 1, minor = 0
[    0.912548] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.912550] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.912552] usb usb1: Product: EHCI Host Controller
[    0.912554] usb usb1: Manufacturer: Linux 2.6.33-rc1 ehci_hcd
[    0.912555] usb usb1: SerialNumber: 0000:00:1a.7
[    0.912579] PM: Adding info for usb:usb1
[    0.912587] usb usb1: uevent
[    0.912623] usb usb1: usb_probe_device
[    0.912626] usb usb1: configuration #1 chosen from 1 choice
[    0.912632] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.912642] PM: Adding info for usb:1-0:1.0
[    0.912646] usb 1-0:1.0: uevent
[    0.912681] hub 1-0:1.0: usb_probe_interface
[    0.912682] hub 1-0:1.0: usb_probe_interface - got id
[    0.912684] hub 1-0:1.0: USB hub found
[    0.912689] hub 1-0:1.0: 4 ports detected
[    0.912690] hub 1-0:1.0: standalone hub
[    0.912692] hub 1-0:1.0: no power switching (usb 1.0)
[    0.912693] hub 1-0:1.0: individual port over-current protection
[    0.912696] hub 1-0:1.0: power on to power good time: 20ms
[    0.912699] hub 1-0:1.0: local power source is good
[    0.912701] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.912725] PM: Adding info for No Bus:ep_81
[    0.912735] PM: Adding info for No Bus:ep_00
[    0.912754] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.912764] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.912768] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.912772] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.912779] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.912783] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    0.912809] ehci_hcd 0000:00:1d.7: debug port 1
[    0.912813] ehci_hcd 0000:00:1d.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    0.916688] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.916690] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    0.916702] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    0.916706] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.920585] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.932515] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.932543] usb usb2: default language 0x0409
[    0.932549] usb usb2: udev 1, busnum 2, minor = 128
[    0.932551] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.932553] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.932554] usb usb2: Product: EHCI Host Controller
[    0.932556] usb usb2: Manufacturer: Linux 2.6.33-rc1 ehci_hcd
[    0.932558] usb usb2: SerialNumber: 0000:00:1d.7
[    0.932580] PM: Adding info for usb:usb2
[    0.932588] usb usb2: uevent
[    0.932620] usb usb2: usb_probe_device
[    0.932622] usb usb2: configuration #1 chosen from 1 choice
[    0.932628] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    0.932638] PM: Adding info for usb:2-0:1.0
[    0.932642] usb 2-0:1.0: uevent
[    0.932674] hub 2-0:1.0: usb_probe_interface
[    0.932676] hub 2-0:1.0: usb_probe_interface - got id
[    0.932677] hub 2-0:1.0: USB hub found
[    0.932681] hub 2-0:1.0: 6 ports detected
[    0.932683] hub 2-0:1.0: standalone hub
[    0.932684] hub 2-0:1.0: no power switching (usb 1.0)
[    0.932686] hub 2-0:1.0: individual port over-current protection
[    0.932687] hub 2-0:1.0: power on to power good time: 20ms
[    0.932691] hub 2-0:1.0: local power source is good
[    0.932692] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    0.932723] PM: Adding info for No Bus:ep_81
[    0.932732] PM: Adding info for No Bus:ep_00
[    0.932770] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.932773] ohci_hcd: block sizes: ed 80 td 96
[    0.932813] uhci_hcd: USB Universal Host Controller Interface driver
[    0.932837] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.932843] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.932846] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.932851] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.932859] uhci_hcd 0000:00:1a.0: detected 2 ports
[    0.932864] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.932866] uhci_hcd 0000:00:1a.0: Performing full reset
[    0.932882] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    0.932886] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    0.932917] usb usb3: default language 0x0409
[    0.932923] usb usb3: udev 1, busnum 3, minor = 256
[    0.932925] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.932927] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.932928] usb usb3: Product: UHCI Host Controller
[    0.932930] usb usb3: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    0.932931] usb usb3: SerialNumber: 0000:00:1a.0
[    0.932958] PM: Adding info for usb:usb3
[    0.932968] usb usb3: uevent
[    0.933001] usb usb3: usb_probe_device
[    0.933003] usb usb3: configuration #1 chosen from 1 choice
[    0.933008] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    0.933018] PM: Adding info for usb:3-0:1.0
[    0.933021] usb 3-0:1.0: uevent
[    0.933054] hub 3-0:1.0: usb_probe_interface
[    0.933056] hub 3-0:1.0: usb_probe_interface - got id
[    0.933058] hub 3-0:1.0: USB hub found
[    0.933061] hub 3-0:1.0: 2 ports detected
[    0.933063] hub 3-0:1.0: standalone hub
[    0.933064] hub 3-0:1.0: no power switching (usb 1.0)
[    0.933066] hub 3-0:1.0: individual port over-current protection
[    0.933067] hub 3-0:1.0: power on to power good time: 2ms
[    0.933071] hub 3-0:1.0: local power source is good
[    0.933072] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    0.933084] PM: Adding info for No Bus:ep_81
[    0.933094] PM: Adding info for No Bus:ep_00
[    0.933116] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.933122] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.933125] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.933130] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.933137] uhci_hcd 0000:00:1a.1: detected 2 ports
[    0.933142] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.933144] uhci_hcd 0000:00:1a.1: Performing full reset
[    0.933160] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    0.933171] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    0.933206] usb usb4: default language 0x0409
[    0.933211] usb usb4: udev 1, busnum 4, minor = 384
[    0.933213] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.933215] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.933217] usb usb4: Product: UHCI Host Controller
[    0.933218] usb usb4: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    0.933220] usb usb4: SerialNumber: 0000:00:1a.1
[    0.933241] PM: Adding info for usb:usb4
[    0.933249] usb usb4: uevent
[    0.933282] usb usb4: usb_probe_device
[    0.933284] usb usb4: configuration #1 chosen from 1 choice
[    0.933289] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    0.933298] PM: Adding info for usb:4-0:1.0
[    0.933302] usb 4-0:1.0: uevent
[    0.933335] hub 4-0:1.0: usb_probe_interface
[    0.933337] hub 4-0:1.0: usb_probe_interface - got id
[    0.933339] hub 4-0:1.0: USB hub found
[    0.933343] hub 4-0:1.0: 2 ports detected
[    0.933344] hub 4-0:1.0: standalone hub
[    0.933346] hub 4-0:1.0: no power switching (usb 1.0)
[    0.933347] hub 4-0:1.0: individual port over-current protection
[    0.933349] hub 4-0:1.0: power on to power good time: 2ms
[    0.933352] hub 4-0:1.0: local power source is good
[    0.933354] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    0.933366] PM: Adding info for No Bus:ep_81
[    0.933375] PM: Adding info for No Bus:ep_00
[    0.933395] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.933401] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.933404] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.933408] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    0.933415] uhci_hcd 0000:00:1d.0: detected 2 ports
[    0.933420] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.933422] uhci_hcd 0000:00:1d.0: Performing full reset
[    0.933437] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    0.933441] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    0.933472] usb usb5: default language 0x0409
[    0.933478] usb usb5: udev 1, busnum 5, minor = 512
[    0.933480] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.933482] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.933484] usb usb5: Product: UHCI Host Controller
[    0.933485] usb usb5: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    0.933487] usb usb5: SerialNumber: 0000:00:1d.0
[    0.933508] PM: Adding info for usb:usb5
[    0.933516] usb usb5: uevent
[    0.933549] usb usb5: usb_probe_device
[    0.933551] usb usb5: configuration #1 chosen from 1 choice
[    0.933556] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    0.933565] PM: Adding info for usb:5-0:1.0
[    0.933569] usb 5-0:1.0: uevent
[    0.933602] hub 5-0:1.0: usb_probe_interface
[    0.933603] hub 5-0:1.0: usb_probe_interface - got id
[    0.933605] hub 5-0:1.0: USB hub found
[    0.933609] hub 5-0:1.0: 2 ports detected
[    0.933610] hub 5-0:1.0: standalone hub
[    0.933612] hub 5-0:1.0: no power switching (usb 1.0)
[    0.933613] hub 5-0:1.0: individual port over-current protection
[    0.933615] hub 5-0:1.0: power on to power good time: 2ms
[    0.933618] hub 5-0:1.0: local power source is good
[    0.933620] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    0.933631] PM: Adding info for No Bus:ep_81
[    0.933641] PM: Adding info for No Bus:ep_00
[    0.933659] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.933665] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.933668] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.933672] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    0.933679] uhci_hcd 0000:00:1d.1: detected 2 ports
[    0.933684] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.933685] uhci_hcd 0000:00:1d.1: Performing full reset
[    0.933701] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    0.933705] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    0.933738] usb usb6: default language 0x0409
[    0.933743] usb usb6: udev 1, busnum 6, minor = 640
[    0.933745] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.933747] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.933749] usb usb6: Product: UHCI Host Controller
[    0.933750] usb usb6: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    0.933752] usb usb6: SerialNumber: 0000:00:1d.1
[    0.933772] PM: Adding info for usb:usb6
[    0.933781] usb usb6: uevent
[    0.933816] usb usb6: usb_probe_device
[    0.933818] usb usb6: configuration #1 chosen from 1 choice
[    0.933823] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    0.933832] PM: Adding info for usb:6-0:1.0
[    0.933835] usb 6-0:1.0: uevent
[    0.933869] hub 6-0:1.0: usb_probe_interface
[    0.933871] hub 6-0:1.0: usb_probe_interface - got id
[    0.933873] hub 6-0:1.0: USB hub found
[    0.933877] hub 6-0:1.0: 2 ports detected
[    0.933878] hub 6-0:1.0: standalone hub
[    0.933880] hub 6-0:1.0: no power switching (usb 1.0)
[    0.933881] hub 6-0:1.0: individual port over-current protection
[    0.933883] hub 6-0:1.0: power on to power good time: 2ms
[    0.933886] hub 6-0:1.0: local power source is good
[    0.933888] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    0.933899] PM: Adding info for No Bus:ep_81
[    0.933908] PM: Adding info for No Bus:ep_00
[    0.933927] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.933933] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.933936] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.933940] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    0.933948] uhci_hcd 0000:00:1d.2: detected 2 ports
[    0.933952] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.933954] uhci_hcd 0000:00:1d.2: Performing full reset
[    0.933970] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    0.933975] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    0.934006] usb usb7: default language 0x0409
[    0.934011] usb usb7: udev 1, busnum 7, minor = 768
[    0.934013] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.934015] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.934017] usb usb7: Product: UHCI Host Controller
[    0.934018] usb usb7: Manufacturer: Linux 2.6.33-rc1 uhci_hcd
[    0.934020] usb usb7: SerialNumber: 0000:00:1d.2
[    0.934040] PM: Adding info for usb:usb7
[    0.934049] usb usb7: uevent
[    0.934083] usb usb7: usb_probe_device
[    0.934085] usb usb7: configuration #1 chosen from 1 choice
[    0.934090] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    0.934100] PM: Adding info for usb:7-0:1.0
[    0.934103] usb 7-0:1.0: uevent
[    0.934136] hub 7-0:1.0: usb_probe_interface
[    0.934138] hub 7-0:1.0: usb_probe_interface - got id
[    0.934140] hub 7-0:1.0: USB hub found
[    0.934143] hub 7-0:1.0: 2 ports detected
[    0.934144] hub 7-0:1.0: standalone hub
[    0.934146] hub 7-0:1.0: no power switching (usb 1.0)
[    0.934147] hub 7-0:1.0: individual port over-current protection
[    0.934149] hub 7-0:1.0: power on to power good time: 2ms
[    0.934152] hub 7-0:1.0: local power source is good
[    0.934154] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    0.934165] PM: Adding info for No Bus:ep_81
[    0.934174] PM: Adding info for No Bus:ep_00
[    0.934264] usbcore: registered new interface driver usblp
[    0.934266] Initializing USB Mass Storage driver...
[    0.934321] usbcore: registered new interface driver usb-storage
[    0.934322] USB Mass Storage support registered.
[    0.934376] usbcore: registered new interface driver libusual
[    0.934457] usbcore: registered new interface driver usbserial
[    0.934492] USB Serial support registered for generic
[    0.934532] usbcore: registered new interface driver usbserial_generic
[    0.934534] usbserial: USB Serial Driver core
[    0.934567] USB Serial support registered for FTDI USB Serial Device
[    0.934637] usbcore: registered new interface driver ftdi_sio
[    0.934639] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[    0.934672] USB Serial support registered for PocketPC PDA
[    0.934737] usbcore: registered new interface driver ipaq
[    0.934738] ipaq: v0.5:USB PocketPC PDA driver
[    0.934830] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.934850] PM: Adding info for platform:i8042
[    0.945485] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.945489] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.945506] PM: Adding info for serio:serio0
[    0.945562] PM: Adding info for No Bus:mice
[    0.945590] PM: Adding info for serio:serio1
[    0.945610] mice: PS/2 mouse device common for all mice
[    0.946148] PM: Adding info for No Bus:input0
[    0.946190] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    0.946206] PM: Adding info for No Bus:event0
[    0.946270] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.946294] rtc_cmos 00:04: RTC can wake from S4
[    0.946312] PM: Adding info for No Bus:rtc0
[    0.946351] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.946384] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.946456] PM: Adding info for platform:coretemp.0
[    0.946521] PM: Adding info for No Bus:hwmon0
[    0.946558] PM: Adding info for platform:coretemp.1
[    0.946602] PM: Adding info for No Bus:hwmon1
[    0.946634] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    0.946674] PM: Adding info for platform:iTCO_wdt
[    0.946742] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    0.946774] PM: Adding info for No Bus:watchdog
[    0.946807] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    0.962758] cpuidle: using governor ladder
[    0.963245] cpuidle: using governor menu
[    0.963291] sdhci: Secure Digital Host Controller Interface driver
[    0.963293] sdhci: Copyright(c) Pierre Ossman
[    0.963307] sdhci-pci 0000:03:09.1: SDHCI controller found [1180:0822] (rev 22)
[    0.963325] sdhci-pci 0000:03:09.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    0.965369] PM: Adding info for No Bus:mmc0::
[    0.965439] Registered led device: mmc0::
[    0.965448] PM: Adding info for No Bus:mmc0
[    0.966523] mmc0: SDHCI controller on PCI [0000:03:09.1] using DMA
[    0.966599] ricoh-mmc: Ricoh MMC Controller disabling driver
[    0.966601] ricoh-mmc: Copyright(c) Philip Langdale
[    0.966679] PM: Adding info for platform:dell_rbu
[    0.966815] PM: Adding info for platform:dcdbas
[    0.966883] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    0.967034] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    0.967050] PM: Adding info for No Bus:timer
[    0.967130] PM: Adding info for No Bus:seq
[    0.967228] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.967277] HDA Intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[    0.967306] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.968796] PM: Adding info for No Bus:input1
[    0.968960] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.968990] PM: Adding info for No Bus:event1
[    1.011941] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[    1.011944] hub 1-0:1.0: port 1: status 0501 change 0001
[    1.011954] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[    1.011956] hub 1-0:1.0: port 2: status 0501 change 0001
[    1.030657] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[    1.030660] hub 2-0:1.0: port 1: status 0501 change 0001
[    1.030668] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[    1.030671] hub 2-0:1.0: port 2: status 0501 change 0001
[    1.030679] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
[    1.030682] hub 2-0:1.0: port 3: status 0501 change 0001
[    1.030695] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
[    1.030698] hub 2-0:1.0: port 6: status 0501 change 0001
[    1.030709] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    1.030719] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    1.030744] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    1.030754] uhci_hcd 0000:00:1d.0: port 2 portsc 0082,00
[    1.030764] uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
[    1.030786] uhci_hcd 0000:00:1d.2: port 2 portsc 008a,00
[    1.030797] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.110059] hub 1-0:1.0: state 7 ports 4 chg 0006 evt 0000
[    1.110067] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    1.172871] ehci_hcd 0000:00:1a.7: port 1 high speed
[    1.172874] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.230059] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.290370] ehci_hcd 0000:00:1a.7: port 1 high speed
[    1.290373] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.386416] usb 1-1: skipped 1 descriptor after configuration
[    1.386420] usb 1-1: skipped 7 descriptors after interface
[    1.386424] usb 1-1: skipped 1 descriptor after endpoint
[    1.386428] usb 1-1: skipped 19 descriptors after interface
[    1.386432] usb 1-1: skipped 1 descriptor after endpoint
[    1.386681] usb 1-1: default language 0x0409
[    1.388163] usb 1-1: udev 2, busnum 1, minor = 1
[    1.388166] usb 1-1: New USB device found, idVendor=05a9, idProduct=2640
[    1.388170] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.388174] usb 1-1: Product: Laptop Integrated Webcam
[    1.388177] usb 1-1: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
[    1.388222] PM: Adding info for usb:1-1
[    1.388244] usb 1-1: uevent
[    1.388350] usb 1-1: usb_probe_device
[    1.388354] usb 1-1: configuration #1 chosen from 1 choice
[    1.388555] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    1.388577] PM: Adding info for usb:1-1:1.0
[    1.388915] usb 1-1:1.0: uevent
[    1.389021] usbserial_generic 1-1:1.0: usb_probe_interface
[    1.389024] usbserial_generic 1-1:1.0: usb_probe_interface - got id
[    1.389068] PM: Adding info for No Bus:ep_83
[    1.389072] usb 1-1: adding 1-1:1.1 (config #1, interface 1)
[    1.389095] PM: Adding info for usb:1-1:1.1
[    1.389102] usb 1-1:1.1: uevent
[    1.389191] usbserial_generic 1-1:1.1: usb_probe_interface
[    1.389193] usbserial_generic 1-1:1.1: usb_probe_interface - got id
[    1.389213] PM: Adding info for No Bus:ep_00
[    1.389218] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    1.392471] PM: Adding info for No Bus:input2
[    1.392625] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input2
[    1.392650] PM: Adding info for No Bus:mouse0
[    1.392769] PM: Adding info for No Bus:event2
[    1.416587] PM: Adding info for No Bus:input3
[    1.416737] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input3
[    1.416758] PM: Adding info for No Bus:mouse1
[    1.416887] PM: Adding info for No Bus:event3
[    1.440370] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[    1.440373] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[    1.440376] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[    1.502570] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[    1.502595] hub 2-0:1.0: state 7 ports 6 chg 004e evt 0000
[    1.502603] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    1.560372] ehci_hcd 0000:00:1d.7: port 1 high speed
[    1.560375] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.580113] PM: Adding info for No Bus:card0
[    1.580285] PM: Adding info for No Bus:input4
[    1.580400] input: HDA Intel Mic at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[    1.580413] PM: Adding info for No Bus:event4
[    1.580527] PM: Adding info for No Bus:input5
[    1.580633] input: HDA Intel HP Out at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    1.580644] PM: Adding info for No Bus:event5
[    1.580760] PM: Adding info for No Bus:input6
[    1.580867] input: HDA Intel HP Out at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    1.580878] PM: Adding info for No Bus:event6
[    1.580988] PM: Adding info for No Bus:pcmC0D1p
[    1.581102] PM: Adding info for No Bus:pcmC0D0p
[    1.581213] PM: Adding info for No Bus:pcmC0D0c
[    1.581326] PM: Adding info for No Bus:hwC0D2
[    1.581445] PM: Adding info for No Bus:controlC0
[    1.581667] ALSA device list:
[    1.581669]   #0: HDA Intel at 0xfebfc000 irq 29
[    1.581886] TCP cubic registered
[    1.581888] Initializing XFRM netlink socket
[    1.581899] NET: Registered protocol family 17
[    1.582619] PM: Adding info for No Bus:cpu_dma_latency
[    1.582730] PM: Adding info for No Bus:network_latency
[    1.582840] PM: Adding info for No Bus:network_throughput
[    1.582941] PM: Checking image partition /dev/sda5
[    1.582944] PM: Resume from disk failed.
[    1.582950] registered taskstats version 1
[    1.583430] rtc_cmos 00:04: setting system clock to 2009-12-24 13:13:03 UTC (1261660383)
[    1.583433] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.583434] EDD information not available.
[    1.583475] Freeing unused kernel memory: 472k freed
[    1.583647] Write protecting the kernel read-only data: 8192k
[    1.583896] Freeing unused kernel memory: 1804k freed
[    1.584662] Freeing unused kernel memory: 344k freed
[    1.622633] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.682874] ehci_hcd 0000:00:1d.7: port 1 high speed
[    1.682885] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    1.714152] PM: Adding info for No Bus:vcs2
[    1.714251] PM: Adding info for No Bus:vcsa2
[    1.716612] PM: Adding info for No Bus:vcs3
[    1.716703] PM: Adding info for No Bus:vcsa3
[    1.719035] PM: Adding info for No Bus:vcs4
[    1.719103] PM: Adding info for No Bus:vcsa4
[    1.721921] PM: Adding info for No Bus:vcs5
[    1.722018] PM: Adding info for No Bus:vcsa5
[    1.725111] PM: Adding info for No Bus:vcs6
[    1.725210] PM: Adding info for No Bus:vcsa6
[    1.770900] usb 2-1: default language 0x0409
[    1.771402] usb 2-1: udev 2, busnum 2, minor = 129
[    1.771405] usb 2-1: New USB device found, idVendor=066f, idProduct=852e
[    1.771407] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.771409] usb 2-1: Product: 6700            
[    1.771411] usb 2-1: Manufacturer: VERVE   
[    1.771412] usb 2-1: SerialNumber: F03A0917E3188B8B
[    1.771453] PM: Adding info for usb:2-1
[    1.771464] usb 2-1: uevent
[    1.771503] usb 2-1: usb_probe_device
[    1.771506] usb 2-1: configuration #1 chosen from 1 choice
[    1.771777] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    1.771789] PM: Adding info for usb:2-1:1.0
[    1.772028] usb 2-1:1.0: uevent
[    1.772064] usb-storage 2-1:1.0: usb_probe_interface
[    1.772069] usb-storage 2-1:1.0: usb_probe_interface - got id
[    1.772188] scsi0 : usb-storage 2-1:1.0
[    1.772221] PM: Adding info for scsi:host0
[    1.772746] PM: Adding info for No Bus:host0
[    1.772819] PM: Adding info for No Bus:ep_81
[    1.772827] PM: Adding info for No Bus:ep_02
[    1.772835] PM: Adding info for No Bus:ep_83
[    1.772844] PM: Adding info for No Bus:ep_00
[    1.772852] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    1.787403] usb usb3: uevent
[    1.787421] usb 3-0:1.0: uevent
[    1.787454] usb usb4: uevent
[    1.787470] usb 4-0:1.0: uevent
[    1.787502] usb usb1: uevent
[    1.787518] usb 1-0:1.0: uevent
[    1.787537] usb 1-1: uevent
[    1.787554] usb 1-1:1.0: uevent
[    1.787571] usb 1-1:1.1: uevent
[    1.788031] usb usb5: uevent
[    1.788048] usb 5-0:1.0: uevent
[    1.788082] usb usb6: uevent
[    1.788098] usb 6-0:1.0: uevent
[    1.788130] usb usb7: uevent
[    1.788148] usb 7-0:1.0: uevent
[    1.788180] usb usb2: uevent
[    1.788198] usb 2-0:1.0: uevent
[    1.788217] usb 2-1: uevent
[    1.788234] usb 2-1:1.0: uevent
[    1.808485] ata_piix 0000:00:1f.1: version 2.13
[    1.808501] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.808549] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.811756] scsi1 : ata_piix
[    1.811775] PM: Adding info for scsi:host1
[    1.811800] PM: Adding info for No Bus:host1
[    1.811834] scsi2 : ata_piix
[    1.811842] PM: Adding info for scsi:host2
[    1.811863] PM: Adding info for No Bus:host2
[    1.812411] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    1.812414] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    1.812647] ata2: port disabled. ignoring.
[    1.824532] ahci 0000:00:1f.2: version 3.0
[    1.824554] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.824638] ahci 0000:00:1f.2: irq 30 for MSI/MSI-X
[    1.824719] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    1.824722] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    1.824728] ahci 0000:00:1f.2: setting latency timer to 64
[    1.832873] ehci_hcd 0000:00:1d.7: port 2 high speed
[    1.832878] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    1.850221] scsi3 : ahci
[    1.850256] PM: Adding info for scsi:host3
[    1.850289] PM: Adding info for No Bus:host3
[    1.856487] scsi4 : ahci
[    1.856513] PM: Adding info for scsi:host4
[    1.856550] PM: Adding info for No Bus:host4
[    1.871982] scsi5 : ahci
[    1.872006] PM: Adding info for scsi:host5
[    1.872038] PM: Adding info for No Bus:host5
[    1.872255] ata3: SATA max UDMA/133 abar m2048@0xfebfb800 port 0xfebfb900 irq 30
[    1.872257] ata4: DUMMY
[    1.872260] ata5: SATA max UDMA/133 abar m2048@0xfebfb800 port 0xfebfba00 irq 30
[    1.892566] usb 2-2: new high speed USB device using ehci_hcd and address 3
[    1.950373] ehci_hcd 0000:00:1d.7: port 2 high speed
[    1.950379] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    1.990680] ata1.00: ATAPI: TEAC   DVD+/-RW DVW28SLC, A.06, max UDMA/33
[    2.030538] ata1.00: configured for UDMA/33
[    2.042641] usb usb4: suspend_rh (auto-stop)
[    2.042698] usb usb5: suspend_rh (auto-stop)
[    2.042745] usb usb6: suspend_rh (auto-stop)
[    2.042781] usb usb7: suspend_rh (auto-stop)
[    2.044391] usb 2-2: default language 0x0409
[    2.044912] usb 2-2: udev 3, busnum 2, minor = 130
[    2.044919] usb 2-2: New USB device found, idVendor=05e3, idProduct=0608
[    2.044924] usb 2-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.044929] usb 2-2: Product: USB2.0 Hub
[    2.045034] PM: Adding info for usb:2-2
[    2.045063] usb 2-2: uevent
[    2.045100] usb 2-2: usb_probe_device
[    2.045108] usb 2-2: configuration #1 chosen from 1 choice
[    2.045450] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    2.045489] PM: Adding info for usb:2-2:1.0
[    2.045505] usb 2-2:1.0: uevent
[    2.045536] hub 2-2:1.0: usb_probe_interface
[    2.045542] hub 2-2:1.0: usb_probe_interface - got id
[    2.045547] hub 2-2:1.0: USB hub found
[    2.045927] hub 2-2:1.0: 4 ports detected
[    2.045932] hub 2-2:1.0: standalone hub
[    2.045936] hub 2-2:1.0: individual port power switching
[    2.045941] hub 2-2:1.0: individual port over-current protection
[    2.045945] hub 2-2:1.0: Single TT
[    2.045950] hub 2-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[    2.045954] hub 2-2:1.0: Port indicators are supported
[    2.045959] hub 2-2:1.0: power on to power good time: 100ms
[    2.046544] hub 2-2:1.0: local power source is good
[    2.046550] hub 2-2:1.0: enabling power on all ports
[    2.048199] PM: Adding info for No Bus:ep_81
[    2.048227] PM: Adding info for No Bus:ep_00
[    2.048245] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    2.048260] ehci_hcd 0000:00:1d.7: port 3 low speed --> companion
[    2.048294] usb usb6: wakeup_rh (auto-start)
[    2.054654] scsi 1:0:0:0: CD-ROM            TEAC     DVD+-RW DVW28SLC A.06 PQ: 0 ANSI: 5
[    2.054704] PM: Adding info for scsi:target1:0:0
[    2.054771] PM: Adding info for scsi:1:0:0:0
[    2.082803] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
[    2.082812] Uniform CD-ROM driver Revision: 3.20
[    2.082875] PM: Adding info for No Bus:sr0
[    2.082965] PM: Adding info for No Bus:11:0
[    2.083005] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.083037] PM: Adding info for No Bus:1:0:0:0
[    2.083136] PM: Adding info for No Bus:sg0
[    2.083166] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    2.102718] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[    2.102765] hub 2-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    2.143165] hub 2-2:1.0: port 1: status 0101 change 0001
[    2.162877] ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
[    2.162890] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
[    2.162899] hub 2-0:1.0: port 6 not reset yet, waiting 50ms
[    2.162937] usb usb7: wakeup_rh (auto-start)
[    2.220073] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.220652] ata3.00: ATA-8: FUJITSU MHY2250BH, 0085000B, max UDMA/100
[    2.220660] ata3.00: 488397168 sectors, multi 8: LBA48 NCQ (depth 31/32), AA
[    2.221399] ata3.00: configured for UDMA/100
[    2.222763] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[    2.222806] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    2.222822] uhci_hcd 0000:00:1a.0: port 2 portsc 0093,00
[    2.222835] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    2.230174] ata5: SATA link down (SStatus 0 SControl 300)
[    2.240404] scsi 3:0:0:0: Direct-Access     ATA      FUJITSU MHY2250B 0085 PQ: 0 ANSI: 5
[    2.240441] PM: Adding info for scsi:target3:0:0
[    2.240508] PM: Adding info for scsi:3:0:0:0
[    2.240590] PM: Adding info for No Bus:3:0:0:0
[    2.240650] PM: Adding info for No Bus:3:0:0:0
[    2.240737] PM: Adding info for No Bus:sg1
[    2.240764] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    2.240935] sd 3:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.241081] sd 3:0:0:0: [sda] Write Protect is off
[    2.241088] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.241152] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.241211] PM: Adding info for No Bus:sda
[    2.241494]  sda:
[    2.242643] usb 2-2: link qh256-0001/ffff88011c72e4c0 start 1 [1/0 us]
[    2.269612]  sda1 sda2 sda3 < sda5 sda6 > sda4
[    2.307010] PM: Adding info for No Bus:sda1
[    2.307046] PM: Adding info for No Bus:sda2
[    2.307084] PM: Adding info for No Bus:sda3
[    2.307115] PM: Adding info for No Bus:sda4
[    2.307145] PM: Adding info for No Bus:sda5
[    2.307183] PM: Adding info for No Bus:sda6
[    2.307431] PM: Adding info for No Bus:8:0
[    2.307778] sd 3:0:0:0: [sda] Attached SCSI disk
[    2.382734] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    2.502672] usb 3-2: new full speed USB device using uhci_hcd and address 2
[    2.642574] usb 3-2: ep0 maxpacket = 8
[    2.664076] usb 3-2: default language 0x0409
[    2.683064] usb 3-2: udev 2, busnum 3, minor = 257
[    2.683072] usb 3-2: New USB device found, idVendor=0483, idProduct=2016
[    2.683078] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.683083] usb 3-2: Product: Biometric Coprocessor
[    2.683088] usb 3-2: Manufacturer: STMicroelectronics
[    2.683194] PM: Adding info for usb:3-2
[    2.683224] usb 3-2: uevent
[    2.683262] usb 3-2: usb_probe_device
[    2.683270] usb 3-2: configuration #1 chosen from 1 choice
[    2.684985] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    2.685025] PM: Adding info for usb:3-2:1.0
[    2.685039] usb 3-2:1.0: uevent
[    2.685089] usbserial_generic 3-2:1.0: usb_probe_interface
[    2.685095] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    2.685158] PM: Adding info for No Bus:ep_81
[    2.685179] PM: Adding info for No Bus:ep_02
[    2.685200] PM: Adding info for No Bus:ep_83
[    2.685231] PM: Adding info for No Bus:ep_00
[    2.685242] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.685253] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    2.685269] uhci_hcd 0000:00:1d.1: port 1 portsc 01a3,00
[    2.685284] hub 6-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    2.812549] PM: Starting manual resume from disk
[    2.812557] PM: Resume from partition 8:5
[    2.812560] PM: Checking hibernation image.
[    2.812917] PM: Error -22 checking image file
[    2.812921] PM: Resume from disk failed.
[    2.821410] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.821423] PM: Marking nosave pages: 00000000dfe72000 - 0000000100000000
[    2.822521] PM: Basic memory bitmaps created
[    2.842561] hub 6-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    2.844119] PM: Basic memory bitmaps freed
[    2.892180] kjournald starting.  Commit interval 5 seconds
[    2.892231] EXT3-fs (sda2): mounted filesystem with writeback data mode
[    2.962663] usb 6-1: new low speed USB device using uhci_hcd and address 2
[    3.157453] usb 6-1: skipped 1 descriptor after interface
[    3.157465] usb 6-1: udev 2, busnum 6, minor = 641
[    3.157470] usb 6-1: New USB device found, idVendor=04d9, idProduct=048e
[    3.157476] usb 6-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.157579] PM: Adding info for usb:6-1
[    3.157608] usb 6-1: uevent
[    3.157637] usb 6-1: usb_probe_device
[    3.157644] usb 6-1: configuration #1 chosen from 1 choice
[    3.162473] usb 6-1: adding 6-1:1.0 (config #1, interface 0)
[    3.162558] PM: Adding info for usb:6-1:1.0
[    3.162574] usb 6-1:1.0: uevent
[    3.162621] usbserial_generic 6-1:1.0: usb_probe_interface
[    3.162627] usbserial_generic 6-1:1.0: usb_probe_interface - got id
[    3.162686] PM: Adding info for No Bus:ep_81
[    3.162713] PM: Adding info for No Bus:ep_00
[    3.162724] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    3.162742] uhci_hcd 0000:00:1d.2: port 2 portsc 0093,00
[    3.162756] hub 7-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    3.322577] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    3.442665] usb 7-2: new full speed USB device using uhci_hcd and address 2
[    3.582702] usb 7-2: ep0 maxpacket = 8
[    3.609012] usb 7-2: default language 0x0409
[    3.623093] usb 7-2: udev 2, busnum 7, minor = 769
[    3.623101] usb 7-2: New USB device found, idVendor=0a5c, idProduct=4500
[    3.623107] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.623113] usb 7-2: Product: BCM2045B2
[    3.623117] usb 7-2: Manufacturer: Broadcom
[    3.623223] PM: Adding info for usb:7-2
[    3.623252] usb 7-2: uevent
[    3.623281] usb 7-2: usb_probe_device
[    3.623289] usb 7-2: configuration #1 chosen from 1 choice
[    3.625029] usb 7-2: adding 7-2:1.0 (config #1, interface 0)
[    3.625078] PM: Adding info for usb:7-2:1.0
[    3.625094] usb 7-2:1.0: uevent
[    3.625126] hub 7-2:1.0: usb_probe_interface
[    3.625132] hub 7-2:1.0: usb_probe_interface - got id
[    3.625137] hub 7-2:1.0: USB hub found
[    3.627006] hub 7-2:1.0: 3 ports detected
[    3.627012] hub 7-2:1.0: compound device; port removable status: FFF
[    3.627017] hub 7-2:1.0: ganged power switching
[    3.627021] hub 7-2:1.0: global over-current protection
[    3.627026] hub 7-2:1.0: power on to power good time: 100ms
[    3.627994] hub 7-2:1.0: hub controller current requirement: 100mA
[    3.627999] hub 7-2:1.0: 100mA bus power budget for each child
[    3.628997] hub 7-2:1.0: local power source is good
[    3.629003] hub 7-2:1.0: no over-current condition exists
[    3.629009] hub 7-2:1.0: enabling power on all ports
[    3.632137] PM: Adding info for No Bus:ep_81
[    3.632169] PM: Adding info for No Bus:ep_00
[    3.632180] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0004
[    3.632198] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    3.632212] hub 2-2:1.0: state 7 ports 4 chg 0002 evt 0000
[    3.632646] hub 2-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    3.720666] usb 2-2.1: new full speed USB device using ehci_hcd and address 6
[    3.732097] hub 7-2:1.0: port 1: status 0101 change 0001
[    3.734111] hub 7-2:1.0: port 2: status 0101 change 0001
[    3.736109] hub 7-2:1.0: port 3: status 0101 change 0001
[    3.830208] usb 2-2.1: ep0 maxpacket = 8
[    3.832033] usb 2-2.1: default language 0x0409
[    3.833270] usb 2-2.1: udev 6, busnum 2, minor = 133
[    3.833277] usb 2-2.1: New USB device found, idVendor=04e8, idProduct=3419
[    3.833283] usb 2-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.833289] usb 2-2.1: Product: SCX-4x21 Series
[    3.833293] usb 2-2.1: Manufacturer: Samsung
[    3.833297] usb 2-2.1: SerialNumber: 8P54BAIQ223171Y.
[    3.833405] PM: Adding info for usb:2-2.1
[    3.833436] usb 2-2.1: uevent
[    3.833466] usb 2-2.1: usb_probe_device
[    3.833474] usb 2-2.1: configuration #1 chosen from 1 choice
[    3.833795] usb 2-2.1: adding 2-2.1:1.0 (config #1, interface 0)
[    3.833842] PM: Adding info for usb:2-2.1:1.0
[    3.833857] usb 2-2.1:1.0: uevent
[    3.833904] usbserial_generic 2-2.1:1.0: usb_probe_interface
[    3.833911] usbserial_generic 2-2.1:1.0: usb_probe_interface - got id
[    3.833969] PM: Adding info for No Bus:ep_04
[    3.833995] PM: Adding info for No Bus:ep_82
[    3.834001] usb 2-2.1: adding 2-2.1:1.1 (config #1, interface 1)
[    3.834027] PM: Adding info for usb:2-2.1:1.1
[    3.834037] usb 2-2.1:1.1: uevent
[    3.834060] usblp 2-2.1:1.1: usb_probe_interface
[    3.834065] usblp 2-2.1:1.1: usb_probe_interface - got id
[    3.834434] PM: Adding info for No Bus:ep_03
[    3.834462] PM: Adding info for No Bus:ep_81
[    3.835419] drivers/usb/core/file.c: looking for a minor, starting at 0
[    3.835508] PM: Adding info for No Bus:lp0
[    3.835534] usblp0: USB Bidirectional printer dev 6 if 1 alt 0 proto 2 vid 0x04E8 pid 0x3419
[    3.835573] PM: Adding info for No Bus:ep_00
[    3.835584] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    3.835605] hub 2-2:1.0: state 7 ports 4 chg 0000 evt 0002
[    3.840172] uhci_hcd 0000:00:1d.2: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    3.840203] hub 7-2:1.0: state 7 ports 3 chg 000e evt 0000
[    3.842114] hub 7-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    3.932007] usb 7-2.1: new full speed USB device using uhci_hcd and address 3
[    4.012638] hub 4-0:1.0: hub_suspend
[    4.012655] usb usb4: bus auto-suspend
[    4.012661] usb usb4: suspend_rh
[    4.071032] usb 7-2.1: skipped 1 descriptor after interface
[    4.074091] usb 7-2.1: default language 0x0409
[    4.080095] usb 7-2.1: udev 3, busnum 7, minor = 770
[    4.080103] usb 7-2.1: New USB device found, idVendor=413c, idProduct=8126
[    4.080108] usb 7-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.080113] usb 7-2.1: Product: BCM2045
[    4.080118] usb 7-2.1: Manufacturer: Broadcom Corp
[    4.080227] PM: Adding info for usb:7-2.1
[    4.080258] usb 7-2.1: uevent
[    4.080288] usb 7-2.1: usb_probe_device
[    4.080295] usb 7-2.1: configuration #1 chosen from 1 choice
[    4.082126] usb 7-2.1: adding 7-2.1:1.0 (config #1, interface 0)
[    4.082172] PM: Adding info for usb:7-2.1:1.0
[    4.082187] usb 7-2.1:1.0: uevent
[    4.082234] usbserial_generic 7-2.1:1.0: usb_probe_interface
[    4.082240] usbserial_generic 7-2.1:1.0: usb_probe_interface - got id
[    4.082304] PM: Adding info for No Bus:ep_81
[    4.082325] PM: Adding info for No Bus:ep_82
[    4.082348] PM: Adding info for No Bus:ep_02
[    4.082354] usb 7-2.1: adding 7-2.1:1.1 (config #1, interface 1)
[    4.082380] PM: Adding info for usb:7-2.1:1.1
[    4.082390] usb 7-2.1:1.1: uevent
[    4.082427] usbserial_generic 7-2.1:1.1: usb_probe_interface
[    4.082432] usbserial_generic 7-2.1:1.1: usb_probe_interface - got id
[    4.082482] PM: Adding info for No Bus:ep_83
[    4.082541] PM: Adding info for No Bus:ep_03
[    4.082548] usb 7-2.1: adding 7-2.1:1.2 (config #1, interface 2)
[    4.082574] PM: Adding info for usb:7-2.1:1.2
[    4.082584] usb 7-2.1:1.2: uevent
[    4.082619] usbserial_generic 7-2.1:1.2: usb_probe_interface
[    4.082624] usbserial_generic 7-2.1:1.2: usb_probe_interface - got id
[    4.082685] PM: Adding info for No Bus:ep_84
[    4.082706] PM: Adding info for No Bus:ep_04
[    4.082712] usb 7-2.1: adding 7-2.1:1.3 (config #1, interface 3)
[    4.082738] PM: Adding info for usb:7-2.1:1.3
[    4.082748] usb 7-2.1:1.3: uevent
[    4.082782] usbserial_generic 7-2.1:1.3: usb_probe_interface
[    4.082787] usbserial_generic 7-2.1:1.3: usb_probe_interface - got id
[    4.082841] PM: Adding info for No Bus:ep_00
[    4.082847] hub 7-2:1.0: 400mA power budget left
[    4.084019] hub 7-2:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    4.164114] usb 7-2.2: new full speed USB device using uhci_hcd and address 4
[    4.262594] usb 7-2.2: ep0 maxpacket = 8
[    4.287011] usb 7-2.2: skipped 1 descriptor after interface
[    4.290111] usb 7-2.2: default language 0x0409
[    4.298093] usb 7-2.2: udev 4, busnum 7, minor = 771
[    4.298099] usb 7-2.2: New USB device found, idVendor=0a5c, idProduct=4502
[    4.298105] usb 7-2.2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    4.298110] usb 7-2.2: Manufacturer: Broadcom Corp
[    4.298218] PM: Adding info for usb:7-2.2
[    4.298248] usb 7-2.2: uevent
[    4.298278] usb 7-2.2: usb_probe_device
[    4.298286] usb 7-2.2: configuration #1 chosen from 1 choice
[    4.300112] usb 7-2.2: adding 7-2.2:1.0 (config #1, interface 0)
[    4.300161] PM: Adding info for usb:7-2.2:1.0
[    4.300176] usb 7-2.2:1.0: uevent
[    4.300223] usbserial_generic 7-2.2:1.0: usb_probe_interface
[    4.300229] usbserial_generic 7-2.2:1.0: usb_probe_interface - got id
[    4.300287] PM: Adding info for No Bus:ep_81
[    4.300314] PM: Adding info for No Bus:ep_00
[    4.300320] hub 7-2:1.0: 400mA power budget left
[    4.301114] hub 7-2:1.0: port 3, status 0101, change 0000, 12 Mb/s
[    4.382121] usb 7-2.3: new full speed USB device using uhci_hcd and address 5
[    4.480071] usb 7-2.3: ep0 maxpacket = 8
[    4.505115] usb 7-2.3: skipped 1 descriptor after interface
[    4.507998] usb 7-2.3: default language 0x0409
[    4.516093] usb 7-2.3: udev 5, busnum 7, minor = 772
[    4.516100] usb 7-2.3: New USB device found, idVendor=0a5c, idProduct=4503
[    4.516106] usb 7-2.3: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    4.516112] usb 7-2.3: Manufacturer: Broadcom Corp
[    4.516220] PM: Adding info for usb:7-2.3
[    4.516250] usb 7-2.3: uevent
[    4.516281] usb 7-2.3: usb_probe_device
[    4.516289] usb 7-2.3: configuration #1 chosen from 1 choice
[    4.518116] usb 7-2.3: adding 7-2.3:1.0 (config #1, interface 0)
[    4.518164] PM: Adding info for usb:7-2.3:1.0
[    4.518178] usb 7-2.3:1.0: uevent
[    4.518225] usbserial_generic 7-2.3:1.0: usb_probe_interface
[    4.518232] usbserial_generic 7-2.3:1.0: usb_probe_interface - got id
[    4.518289] PM: Adding info for No Bus:ep_81
[    4.518322] PM: Adding info for No Bus:ep_00
[    4.518329] hub 7-2:1.0: 400mA power budget left
[    4.518338] hub 7-2:1.0: state 7 ports 3 chg 0000 evt 0008
[    5.012662] hub 5-0:1.0: hub_suspend
[    5.012679] usb usb5: bus auto-suspend
[    5.012684] usb usb5: suspend_rh
[    6.773465] scsi 0:0:0:0: Direct-Access     VERVE    6700             0100 PQ: 0 ANSI: 4
[    6.774009] PM: Adding info for scsi:target0:0:0
[    6.774069] PM: Adding info for scsi:0:0:0:0
[    6.774126] PM: Adding info for No Bus:0:0:0:0
[    6.774173] PM: Adding info for No Bus:0:0:0:0
[    6.774252] PM: Adding info for No Bus:sg2
[    6.774293] sd 0:0:0:0: Attached scsi generic sg2 type 0
[    6.775103] sd 0:0:0:0: [sdb] 978560 2048-byte logical blocks: (2.00 GB/1.86 GiB)
[    6.775723] sd 0:0:0:0: [sdb] Write Protect is off
[    6.775729] sd 0:0:0:0: [sdb] Mode Sense: 3e 00 00 00
[    6.775734] sd 0:0:0:0: [sdb] Assuming drive cache: write through
[    6.776355] PM: Adding info for No Bus:sdb
[    6.777966] sd 0:0:0:0: [sdb] 978560 2048-byte logical blocks: (2.00 GB/1.86 GiB)
[    6.778587] sd 0:0:0:0: [sdb] Assuming drive cache: write through
[    6.779163]  sdb: sdb1
[    6.780371] PM: Adding info for No Bus:sdb1
[    6.780918] PM: Adding info for No Bus:8:16
[    6.781824] sd 0:0:0:0: [sdb] 978560 2048-byte logical blocks: (2.00 GB/1.86 GiB)
[    6.782460] sd 0:0:0:0: [sdb] Assuming drive cache: write through
[    6.783039] sd 0:0:0:0: [sdb] Attached SCSI removable disk
[    8.825485] udev: starting version 141
[    8.872797] usb usb3: uevent
[    8.872847] usb 3-0:1.0: uevent
[    8.872893] usb 3-2: uevent
[    8.872938] usb 3-2:1.0: uevent
[    8.873022] usb usb4: uevent
[    8.873066] usb 4-0:1.0: uevent
[    8.873158] usb usb1: uevent
[    8.873202] usb 1-0:1.0: uevent
[    8.873247] usb 1-1: uevent
[    8.873293] usb 1-1:1.0: uevent
[    8.873336] usb 1-1:1.1: uevent
[    8.874550] usb usb5: uevent
[    8.874596] usb 5-0:1.0: uevent
[    8.874680] usb usb6: uevent
[    8.874723] usb 6-0:1.0: uevent
[    8.874769] usb 6-1: uevent
[    8.874813] usb 6-1:1.0: uevent
[    8.874903] usb usb7: uevent
[    8.874947] usb 7-0:1.0: uevent
[    8.874991] usb 7-2: uevent
[    8.875039] usb 7-2.1: uevent
[    8.875085] usb 7-2.1:1.0: uevent
[    8.875128] usb 7-2.1:1.1: uevent
[    8.875172] usb 7-2.1:1.2: uevent
[    8.875215] usb 7-2.1:1.3: uevent
[    8.875260] usb 7-2.2: uevent
[    8.875307] usb 7-2.2:1.0: uevent
[    8.875352] usb 7-2.3: uevent
[    8.875403] usb 7-2.3:1.0: uevent
[    8.875445] usb 7-2:1.0: uevent
[    8.875529] usb usb2: uevent
[    8.875573] usb 2-0:1.0: uevent
[    8.875618] usb 2-1: uevent
[    8.875663] usb 2-1:1.0: uevent
[    8.876070] usb 2-2: uevent
[    8.876120] usb 2-2.1: uevent
[    8.876166] usb 2-2.1:1.0: uevent
[    8.876211] usb 2-2.1:1.1: uevent
[    8.876297] usb 2-2:1.0: uevent
[    8.956939] usb 2-1:1.0: uevent
[    8.957061] usb 2-1: uevent
[   10.053926] PM: Adding info for platform:regulatory.0
[   10.054149] cfg80211: Using static regulatory domain info
[   10.054152] cfg80211: Regulatory domain: 00
[   10.054153]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.054156]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   10.054158]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[   10.054160]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[   10.054162]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   10.054165]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   10.054171] cfg80211: Calling CRDA to update world regulatory domain
[   10.456579] cfg80211: World regulatory domain updated:
[   10.456588]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.456596]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.456602]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.456609]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.456615]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.456621]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.667373] Bluetooth: Core ver 2.15
[   10.667515] NET: Registered protocol family 31
[   10.667519] Bluetooth: HCI device and connection manager initialized
[   10.667527] Bluetooth: HCI socket layer initialized
[   10.933863] Linux video capture interface: v2.00
[   11.152221] usbcore: registered new interface driver hiddev
[   11.154498] usbhid 6-1:1.0: usb_probe_interface
[   11.154507] usbhid 6-1:1.0: usb_probe_interface - got id
[   11.154571] PM: Adding info for hid:0003:04D9:048E.0001
[   11.184910] PM: Adding info for No Bus:AC
[   11.185226] ACPI: AC Adapter [AC] (on-line)
[   11.197519] PM: Adding info for No Bus:input7
[   11.197570] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input7
[   11.197637] PM: Adding info for No Bus:event7
[   11.341261] PM: Adding info for No Bus:input8
[   11.341289] input: HID 04d9:048e as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input8
[   11.341301] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   11.341320] PM: Adding info for No Bus:mouse2
[   11.341341] PM: Adding info for No Bus:event8
[   11.341352] generic-usb 0003:04D9:048E.0001: input: USB HID v1.10 Mouse [HID 04d9:048e] on usb-0000:00:1d.1-1/input0
[   11.341379] usbhid 7-2.2:1.0: usb_probe_interface
[   11.341382] usbhid 7-2.2:1.0: usb_probe_interface - got id
[   11.341401] PM: Adding info for hid:0003:0A5C:4502.0002
[   11.342651] ACPI: Lid Switch [LID]
[   11.342691] PM: Adding info for No Bus:input9
[   11.342739] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input9
[   11.342765] PM: Adding info for No Bus:event9
[   11.342811] ACPI: Power Button [PBTN]
[   11.342839] PM: Adding info for No Bus:input10
[   11.342878] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input10
[   11.342892] PM: Adding info for No Bus:event10
[   11.342921] ACPI: Sleep Button [SBTN]
[   11.345203] PM: Adding info for No Bus:input11
[   11.345234] input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2/7-2.2:1.0/input/input11
[   11.345246] uhci_hcd 0000:00:1d.2: reserve dev 4 ep81-INT, period 8, phase 4, 17 us
[   11.345274] PM: Adding info for No Bus:event11
[   11.345286] generic-usb 0003:0A5C:4502.0002: input: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1d.2-2.2/input0
[   11.345305] usbhid 7-2.3:1.0: usb_probe_interface
[   11.345309] usbhid 7-2.3:1.0: usb_probe_interface - got id
[   11.345330] PM: Adding info for hid:0003:0A5C:4503.0003
[   11.349860] PM: Adding info for No Bus:input12
[   11.349886] input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3/7-2.3:1.0/input/input12
[   11.349914] PM: Adding info for No Bus:mouse3
[   11.349944] PM: Adding info for No Bus:event12
[   11.349956] generic-usb 0003:0A5C:4503.0003: input: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1d.2-2.3/input0
[   11.349983] usbcore: registered new interface driver usbhid
[   11.349985] usbhid: USB HID core driver
[   11.357423] usb 7-2.2:1.0: uevent
[   11.357526] usb 7-2.2: uevent
[   11.357773] PM: Adding info for platform:dell-laptop
[   11.365839] usb 7-2.3:1.0: uevent
[   11.365945] usb 7-2.3: uevent
[   11.367145] usb 7-2.3:1.0: uevent
[   11.367237] usb 7-2.3: uevent
[   11.376361] PM: Adding info for No Bus:input13
[   11.376383] input: Dell WMI hotkeys as /devices/virtual/input/input13
[   11.376422] PM: Adding info for No Bus:event13
[   11.385690] PM: Adding info for No Bus:BAT0
[   11.397027] ACPI: Battery Slot [BAT0] (battery present)
[   11.434522] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   11.434585] btusb 7-2.1:1.0: usb_probe_interface
[   11.434592] btusb 7-2.1:1.0: usb_probe_interface - got id
[   11.434659] PM: Adding info for No Bus:hci0
[   11.434763] PM: Adding info for No Bus:rfkill0
[   11.434870] btusb 7-2.1:1.2: usb_probe_interface
[   11.434875] btusb 7-2.1:1.2: usb_probe_interface - got id
[   11.434892] btusb 7-2.1:1.3: usb_probe_interface
[   11.434896] btusb 7-2.1:1.3: usb_probe_interface - got id
[   11.435059] usbcore: registered new interface driver btusb
[   11.488592] usb 6-1:1.0: uevent
[   11.488834] usb 6-1: uevent
[   11.490423] PM: Adding info for No Bus:acpi_video0
[   11.491919] usb 6-1:1.0: uevent
[   11.492018] usb 6-1: uevent
[   11.492022] PM: Adding info for No Bus:cooling_device2
[   11.492273] acpi device:30: registered as cooling_device2
[   11.492289] PM: Adding info for No Bus:acpi_video0
[   11.493105] PM: Adding info for No Bus:input14
[   11.493246] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:2d/LNXVIDEO:00/input/input14
[   11.493286] PM: Adding info for No Bus:event14
[   11.493370] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   11.755821] uvcvideo 1-1:1.0: usb_probe_interface
[   11.755830] uvcvideo 1-1:1.0: usb_probe_interface - got id
[   11.755871] uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
[   11.756997] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   11.757725] PM: Adding info for No Bus:video0
[   11.757927] PM: Adding info for No Bus:input15
[   11.758047] input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input15
[   11.758095] PM: Adding info for No Bus:event15
[   11.758296] usbcore: registered new interface driver uvcvideo
[   11.758302] USB Video Class driver (v0.1.0)
[   11.859569] usb 1-1:1.0: uevent
[   11.859670] usb 1-1: uevent
[   11.861848] usb 1-1:1.0: uevent
[   11.861941] usb 1-1: uevent
[   11.925255] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 2.6.33-rc1-ks
[   11.925259] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[   11.925380] iwl3945 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.925394] iwl3945 0000:0b:00.0: setting latency timer to 64
[   11.965951] iwl3945 0000:0b:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
[   11.965953] iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   11.966097] iwl3945 0000:0b:00.0: irq 31 for MSI/MSI-X
[   11.966353] PM: Adding info for No Bus:phy0
[   11.966438] PM: Adding info for No Bus:rfkill1
[   12.016416] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   12.016545] PM: Adding info for No Bus:wlan0
[   12.398645] Adding 3068372k swap on /dev/sda5.  Priority:-1 extents:1 across:3068372k 
[   12.499602] EXT3-fs (sda2): using internal journal
[   12.650114] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x21ab0000
[   13.787821] kjournald starting.  Commit interval 5 seconds
[   13.788259] EXT3-fs (sda4): using internal journal
[   13.788273] EXT3-fs (sda4): mounted filesystem with writeback data mode
[   13.807488] kjournald starting.  Commit interval 5 seconds
[   13.807891] EXT3-fs (sda6): using internal journal
[   13.807905] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   24.601511] PM: Adding info for No Bus:vcs63
[   24.602140] PM: Adding info for No Bus:vcsa63
[   24.605708] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[   24.605720] PM: Marking nosave pages: 00000000dfe72000 - 0000000100000000
[   24.606814] PM: Basic memory bitmaps created
[   24.606817] PM: Syncing filesystems ... done.
[   24.722725] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   24.740197] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   24.760232] PM: Preallocating image memory... done (allocated 60704 pages)
[   24.979312] PM: Allocated 242816 kbytes in 0.21 seconds (1156.26 MB/s)
[   24.979314] Suspending console(s) (use no_console_suspend to debug)
[   24.979364] pci 0000:00:00.0: preparing freeze
[   24.979366] pcieport 0000:00:01.0: preparing freeze
[   24.979369] uhci_hcd 0000:00:1a.0: preparing freeze
[   24.979370] uhci_hcd 0000:00:1a.1: preparing freeze
[   24.979372] ehci_hcd 0000:00:1a.7: preparing freeze
[   24.979374] HDA Intel 0000:00:1b.0: preparing freeze
[   24.979376] pcieport 0000:00:1c.0: preparing freeze
[   24.979378] pcieport 0000:00:1c.1: preparing freeze
[   24.979379] pcieport 0000:00:1c.4: preparing freeze
[   24.979381] uhci_hcd 0000:00:1d.0: preparing freeze
[   24.979383] uhci_hcd 0000:00:1d.1: preparing freeze
[   24.979385] uhci_hcd 0000:00:1d.2: preparing freeze
[   24.979386] ehci_hcd 0000:00:1d.7: preparing freeze
[   24.979388] pci 0000:00:1e.0: preparing freeze
[   24.979390] pci 0000:00:1f.0: preparing freeze
[   24.979392] ata_piix 0000:00:1f.1: preparing freeze
[   24.979394] ahci 0000:00:1f.2: preparing freeze
[   24.979396] pci 0000:00:1f.3: preparing freeze
[   24.979397] pci 0000:01:00.0: preparing freeze
[   24.979400] sky2 0000:09:00.0: preparing freeze
[   24.979402] iwl3945 0000:0b:00.0: preparing freeze
[   24.979405] pci 0000:03:09.0: preparing freeze
[   24.979407] sdhci-pci 0000:03:09.1: preparing freeze
[   24.979408] pci 0000:03:09.2: preparing freeze
[   24.979410] pci 0000:03:09.3: preparing freeze
[   24.979430] pcspkr pcspkr: preparing freeze
[   24.979439] vesafb vesafb.0: preparing freeze
[   24.979477] serial8250 serial8250: preparing freeze
[   24.979482] usb usb1: preparing type freeze
[   24.979485] usb usb2: preparing type freeze
[   24.979488] usb usb3: preparing type freeze
[   24.979491] usb usb4: preparing type freeze
[   24.979494] usb usb5: preparing type freeze
[   24.979497] usb usb6: preparing type freeze
[   24.979500] usb usb7: preparing type freeze
[   24.979503] i8042 i8042: preparing freeze
[   24.979509] coretemp coretemp.0: preparing freeze
[   24.979511] coretemp coretemp.1: preparing freeze
[   24.979513] iTCO_wdt iTCO_wdt: preparing freeze
[   24.979516] platform dell_rbu: preparing freeze
[   24.979518] dcdbas dcdbas: preparing freeze
[   24.979522] usb 1-1: preparing type freeze
[   24.979542] usb 2-1: preparing type freeze
[   24.979551] usb 2-2: preparing type freeze
[   24.979564] usb 3-2: preparing type freeze
[   24.979568] usb 6-1: preparing type freeze
[   24.979571] usb 7-2: preparing type freeze
[   24.979574] usb 2-2.1: preparing type freeze
[   24.979579] usb 7-2.1: preparing type freeze
[   24.979586] usb 7-2.2: preparing type freeze
[   24.979589] usb 7-2.3: preparing type freeze
[   24.979596] platform regulatory.0: preparing freeze
[   24.979608] dell-laptop dell-laptop: preparing freeze
[   24.980403] scsi host5: legacy freeze
[   24.980407] scsi host4: legacy freeze
[   24.980434] scsi host2: legacy freeze
[   24.981282] pci 0000:03:09.3: freeze
[   24.981286] pci 0000:03:09.2: freeze
[   24.981477] pci 0000:03:09.0: freeze
[   24.981650] pci 0000:01:00.0: freeze
[   24.981653] pci 0000:00:1f.3: freeze
[   24.981895] pci 0000:00:1f.0: freeze
[   24.982856] pci 0000:00:00.0: freeze
[   24.983014] rfkill rfkill1: legacy class freeze
[   24.983018] ieee80211 phy0: legacy class freeze
[   25.030217] input input15: type freeze
[   25.030230] input input14: type freeze
[   25.030240] backlight acpi_video0: legacy class freeze
[   25.030246] iwl3945 0000:0b:00.0: freeze
[   25.030252] rfkill rfkill0: legacy class freeze
[   25.030268] input input13: type freeze
[   25.030274] dell-laptop dell-laptop: freeze
[   25.030284] input input12: type freeze
[   25.030292] input input11: type freeze
[   25.030300] input input10: type freeze
[   25.030307] input input9: type freeze
[   25.030318] input input8: type freeze
[   25.030325] input input7: type freeze
[   25.030334] platform regulatory.0: freeze
[   25.030359] sd 0:0:0:0: legacy freeze
[   25.030400] usb 7-2.3: type freeze
[   25.030436] usb 7-2.2: type freeze
[   25.030467] iwl3945 0000:0b:00.0: Master Disable Timed Out, 100 usec
[   25.030506] usb 7-2.1: type freeze
[   25.030558] usb 2-2.1: type freeze
[   25.030610] usb 6-1: type freeze
[   25.030650] usb 3-2: type freeze
[   25.030686] sd 3:0:0:0: legacy freeze
[   25.030693] sd 3:0:0:0: [sda] Synchronizing SCSI cache
[   25.030703] scsi target0:0:0: legacy freeze
[   25.030721] scsi host0: legacy freeze
[   25.030737] battery PNP0C0A:00: legacy freeze
[   25.030760] sr 1:0:0:0: legacy freeze
[   25.030772] usb 2-2: type freeze
[   25.030778] scsi target1:0:0: legacy freeze
[   25.030782] hub 2-2:1.0: hub_suspend
[   25.030792] scsi host1: legacy freeze
[   25.030799] usb 2-2: unlink qh256-0001/ffff88011c72e4c0 start 1 [1/0 us]
[   25.030806] ata_piix 0000:00:1f.1: freeze
[   25.030920] scsi target3:0:0: legacy freeze
[   25.030926] ata2: port disabled. ignoring.
[   25.030950] scsi host3: legacy freeze
[   25.030964] ahci 0000:00:1f.2: freeze
[   25.030969] usb 2-1: type freeze
[   25.031012] input input6: type freeze
[   25.031020] input input5: type freeze
[   25.031027] input input4: type freeze
[   25.031036] ata_piix 0000:00:1f.1: PCI INT A disabled
[   25.031043] HDA Intel 0000:00:1b.0: freeze
[   25.031069] input input3: type freeze
[   25.031077] input input2: type freeze
[   25.031102] input input1: type freeze
[   25.031113] atkbd serio0: freeze
[   25.031119] psmouse serio1: freeze
[   25.031132] dcdbas dcdbas: freeze
[   25.031142] i8042 i8042: freeze
[   25.031145] usb 1-1: type freeze
[   25.031160] platform dell_rbu: freeze
[   25.031168] leds mmc0::: legacy class freeze
[   25.031179] iTCO_wdt iTCO_wdt: freeze
[   25.031187] coretemp coretemp.1: freeze
[   25.031195] coretemp coretemp.0: freeze
[   25.031200] rtc rtc0: legacy class freeze
[   25.031209] sdhci-pci 0000:03:09.1: freeze
[   25.031251] input input0: type freeze
[   25.031319] sdhci-pci 0000:03:09.1: PCI INT B disabled
[   25.031323] usb usb4: type freeze
[   25.031336] uhci_hcd 0000:00:1a.1: freeze
[   25.031356] usb usb5: type freeze
[   25.031375] uhci_hcd 0000:00:1d.0: freeze
[   25.031380] usb usb3: type freeze
[   25.031385] hub 3-0:1.0: hub_suspend
[   25.031397] usb usb3: bus suspend
[   25.031401] usb usb3: suspend_rh
[   25.031434] uhci_hcd 0000:00:1a.0: freeze
[   25.031468] sky2 0000:09:00.0: freeze
[   25.031504] usb usb2: type freeze
[   25.031509] hub 2-0:1.0: hub_suspend
[   25.031522] usb usb2: bus suspend
[   25.031526] ehci_hcd 0000:00:1d.7: suspend root hub
[   25.031646] serial8250 serial8250: freeze
[   25.031729] usb usb1: type freeze
[   25.031734] hub 1-0:1.0: hub_suspend
[   25.031743] usb usb1: bus suspend
[   25.031747] ehci_hcd 0000:00:1a.7: suspend root hub
[   25.031763] vesafb vesafb.0: freeze
[   25.031789] pcspkr pcspkr: freeze
[   25.031816] system 00:0c: legacy freeze
[   25.031826] system 00:0b: legacy freeze
[   25.031834] system 00:0a: legacy freeze
[   25.031841] system 00:09: legacy freeze
[   25.031850] pnp 00:08: legacy freeze
[   25.031855] pnp 00:07: legacy freeze
[   25.031860] system 00:06: legacy freeze
[   25.031868] pnp 00:05: legacy freeze
[   25.031873] rtc_cmos 00:04: legacy freeze
[   25.031886] i8042 kbd 00:03: legacy freeze
[   25.031893] i8042 aux 00:02: legacy freeze
[   25.031901] system 00:01: legacy freeze
[   25.031910] pnp 00:00: legacy freeze
[   25.031947] uhci_hcd 0000:00:1d.2: release dev 4 ep81-INT, period 8, phase 4, 17 us
[   25.031960] pcieport 0000:00:1c.4: freeze
[   25.031970] ehci_hcd 0000:00:1d.7: freeze
[   25.031972] usb 7-2: type freeze
[   25.031979] hub 7-2:1.0: hub_suspend
[   25.031985] ehci_hcd 0000:00:1a.7: freeze
[   25.032007] pcieport 0000:00:01.0: freeze
[   25.032012] thermal LNXTHERM:01: legacy freeze
[   25.032018] acpi LNXTHERM:00: legacy freeze
[   25.032024] wmi pnp0c14:00: legacy freeze
[   25.032029] acpi PNP0C32:00: legacy freeze
[   25.032036] ac ACPI0003:00: legacy freeze
[   25.032042] button PNP0C0E:00: legacy freeze
[   25.032048] button PNP0C0C:00: legacy freeze
[   25.032054] button PNP0C0D:00: legacy freeze
[   25.032060] acpi PNP0C01:03: legacy freeze
[   25.032065] pci_link PNP0C0F:07: legacy freeze
[   25.032071] pci_link PNP0C0F:06: legacy freeze
[   25.032076] pci_link PNP0C0F:05: legacy freeze
[   25.032082] pci_link PNP0C0F:04: legacy freeze
[   25.032087] pci_link PNP0C0F:03: legacy freeze
[   25.032092] pci_link PNP0C0F:02: legacy freeze
[   25.032097] pci_link PNP0C0F:01: legacy freeze
[   25.032103] pci_link PNP0C0F:00: legacy freeze
[   25.032108] acpi device:3d: legacy freeze
[   25.032114] acpi device:3c: legacy freeze
[   25.032119] acpi device:3b: legacy freeze
[   25.032125] acpi device:3a: legacy freeze
[   25.032130] acpi device:39: legacy freeze
[   25.032135] acpi device:38: legacy freeze
[   25.032141] acpi device:37: legacy freeze
[   25.032146] acpi device:36: legacy freeze
[   25.032151] acpi device:35: legacy freeze
[   25.032157] acpi device:34: legacy freeze
[   25.032162] acpi device:33: legacy freeze
[   25.032168] acpi device:32: legacy freeze
[   25.032173] acpi PNP0C01:02: legacy freeze
[   25.032178] acpi PNP0C01:01: legacy freeze
[   25.032183] acpi device:31: legacy freeze
[   25.032188] acpi device:30: legacy freeze
[   25.032193] acpi device:2f: legacy freeze
[   25.032198] acpi device:2e: legacy freeze
[   25.032206] video LNXVIDEO:00: legacy freeze
[   25.032212] acpi device:2d: legacy freeze
[   25.032217] acpi device:2c: legacy freeze
[   25.032222] acpi device:2b: legacy freeze
[   25.032227] acpi device:2a: legacy freeze
[   25.032233] acpi device:29: legacy freeze
[   25.032238] acpi device:28: legacy freeze
[   25.032243] acpi device:27: legacy freeze
[   25.032249] acpi device:26: legacy freeze
[   25.032254] acpi device:25: legacy freeze
[   25.032259] acpi device:24: legacy freeze
[   25.032265] acpi device:23: legacy freeze
[   25.032288] uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period 8, phase 4, 118 us
[   25.032301] acpi device:22: legacy freeze
[   25.032307] acpi device:21: legacy freeze
[   25.032312] acpi device:20: legacy freeze
[   25.032326] usb usb6: type freeze
[   25.032328] hub 6-0:1.0: hub_suspend
[   25.032337] usb usb6: bus suspend
[   25.032340] usb usb6: suspend_rh
[   25.032371] acpi device:1f: legacy freeze
[   25.032377] acpi device:1e: legacy freeze
[   25.032382] acpi device:1d: legacy freeze
[   25.032387] acpi device:1c: legacy freeze
[   25.032392] acpi device:1b: legacy freeze
[   25.032400] uhci_hcd 0000:00:1d.1: freeze
[   25.032402] acpi device:1a: legacy freeze
[   25.032409] acpi device:19: legacy freeze
[   25.032414] acpi device:18: legacy freeze
[   25.032419] acpi device:17: legacy freeze
[   25.032424] acpi device:16: legacy freeze
[   25.032430] acpi device:15: legacy freeze
[   25.032435] acpi device:14: legacy freeze
[   25.032440] acpi device:13: legacy freeze
[   25.032445] acpi device:12: legacy freeze
[   25.032451] acpi device:11: legacy freeze
[   25.032457] acpi device:10: legacy freeze
[   25.032462] acpi device:0f: legacy freeze
[   25.032467] acpi device:0e: legacy freeze
[   25.032473] acpi device:0d: legacy freeze
[   25.032478] acpi device:0c: legacy freeze
[   25.032483] acpi device:0b: legacy freeze
[   25.032488] acpi device:0a: legacy freeze
[   25.032494] acpi device:09: legacy freeze
[   25.032499] acpi device:08: legacy freeze
[   25.032505] acpi device:07: legacy freeze
[   25.032510] acpi device:06: legacy freeze
[   25.032516] acpi device:05: legacy freeze
[   25.032521] acpi device:04: legacy freeze
[   25.032527] acpi device:03: legacy freeze
[   25.032532] acpi device:02: legacy freeze
[   25.032538] acpi device:01: legacy freeze
[   25.032543] acpi PNP0103:00: legacy freeze
[   25.032548] acpi PNP0C04:00: legacy freeze
[   25.032554] acpi PNP0200:00: legacy freeze
[   25.032559] acpi PNP0000:00: legacy freeze
[   25.032564] acpi PNP0C01:00: legacy freeze
[   25.032570] acpi PNP0800:00: legacy freeze
[   25.032575] acpi PNP0100:00: legacy freeze
[   25.032580] acpi PNP0B00:00: legacy freeze
[   25.032585] acpi PNP0303:00: legacy freeze
[   25.032590] acpi PNP0F13:00: legacy freeze
[   25.032595] acpi PNP0C02:00: legacy freeze
[   25.032604] acpi device:00: legacy freeze
[   25.032618] pci_root PNP0A03:00: legacy freeze
[   25.032626] acpi LNXSYBUS:00: legacy freeze
[   25.032632] processor LNXCPU:01: legacy freeze
[   25.032640] processor LNXCPU:00: legacy freeze
[   25.032646] acpi LNXSYSTM:00: legacy freeze
[   25.032937] uhci_hcd 0000:00:1d.2: release dev 2 ep81-INT, period 128, phase 0, 12 us
[   25.032957] usb usb7: type freeze
[   25.032962] hub 7-0:1.0: hub_suspend
[   25.032968] usb usb7: bus suspend
[   25.032972] usb usb7: suspend_rh
[   25.033027] uhci_hcd 0000:00:1d.2: freeze
[   25.050071] pcieport 0000:00:1c.0: freeze
[   25.052550] pci 0000:00:1e.0: freeze
[   25.052607] pcieport 0000:00:1c.1: freeze
[   25.580075] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   25.600067] PM: freeze of devices complete after 620.429 msecs
[   25.600148] dell-laptop dell-laptop: LATE freeze
[   25.600155] platform regulatory.0: LATE freeze
[   25.600164] dcdbas dcdbas: LATE freeze
[   25.600168] platform dell_rbu: LATE freeze
[   25.600172] iTCO_wdt iTCO_wdt: LATE freeze
[   25.600176] coretemp coretemp.1: LATE freeze
[   25.600179] coretemp coretemp.0: LATE freeze
[   25.600183] psmouse serio1: LATE freeze
[   25.600186] atkbd serio0: LATE freeze
[   25.600190] i8042 i8042: LATE freeze
[   25.600195] serial8250 serial8250: LATE freeze
[   25.600200] vesafb vesafb.0: LATE freeze
[   25.600204] pcspkr pcspkr: LATE freeze
[   25.600209] pci 0000:03:09.3: LATE freeze
[   25.600260] pci 0000:03:09.2: LATE freeze
[   25.600311] sdhci-pci 0000:03:09.1: LATE freeze
[   25.600315] pci 0000:03:09.0: LATE freeze
[   25.600366] iwl3945 0000:0b:00.0: LATE freeze
[   25.600370] sky2 0000:09:00.0: LATE freeze
[   25.600373] pci 0000:01:00.0: LATE freeze
[   25.600445] pci 0000:00:1f.3: LATE freeze
[   25.600488] ahci 0000:00:1f.2: LATE freeze
[   25.600492] ata_piix 0000:00:1f.1: LATE freeze
[   25.600496] pci 0000:00:1f.0: LATE freeze
[   25.600555] pci 0000:00:1e.0: LATE freeze
[   25.600605] ehci_hcd 0000:00:1d.7: LATE freeze
[   25.600660] uhci_hcd 0000:00:1d.2: LATE freeze
[   25.600704] uhci_hcd 0000:00:1d.1: LATE freeze
[   25.600747] uhci_hcd 0000:00:1d.0: LATE freeze
[   25.600790] pcieport 0000:00:1c.4: LATE freeze
[   25.600794] pcieport 0000:00:1c.1: LATE freeze
[   25.600798] pcieport 0000:00:1c.0: LATE freeze
[   25.600802] HDA Intel 0000:00:1b.0: LATE freeze
[   25.600805] ehci_hcd 0000:00:1a.7: LATE freeze
[   25.600860] uhci_hcd 0000:00:1a.1: LATE freeze
[   25.600903] uhci_hcd 0000:00:1a.0: LATE freeze
[   25.600947] pcieport 0000:00:01.0: LATE freeze
[   25.600950] pci 0000:00:00.0: LATE freeze
[   25.600986] PM: late freeze of devices complete after 0.913 msecs
[   25.605936] ACPI: Preparing to enter system sleep state S4
[   25.608232] PM: Saving platform NVS memory
[   25.608419] Disabling non-boot CPUs ...
[   25.830040] CPU 1 is now offline
[   25.830045] SMP alternatives: switching to UP code
[   25.840873] Task kthreadd (pid = 2) is on cpu 1				(state = 1, flags = 80208040) 
[   25.840876] Task events/1 (pid = 8) is on cpu 1				(state = 1, flags = 84208040) 
[   25.840878] Task ata/1 (pid = 319) is on cpu 1				(state = 1, flags = 84208040) 
[   25.840880] Task kmmcd (pid = 334) is on cpu 1				(state = 1, flags = 80208040) 
[   25.841019] Extended CMOS year: 2000
[   25.841117] PM: Creating hibernation image: 
[   25.850012] PM: Need to copy 60432 pages
[   25.850012] PM: Normal pages needed: 60432 + 1024, available pages: 987574
[   25.850012] PM: Restoring platform NVS memory
[   25.850012] Extended CMOS year: 2000
[   25.850012] Enabling non-boot CPUs ...
[   25.860238] SMP alternatives: switching to SMP code
[   25.870645] Booting Node 0 Processor 1 APIC 0x1
[   26.092552] CPU1 is up
[   26.093881] ACPI: Waking up from system sleep state S4
[   26.105841] pci 0000:00:00.0: EARLY restore
[   26.105888] pcieport 0000:00:01.0: EARLY restore
[   26.105964] uhci_hcd 0000:00:1a.0: EARLY restore
[   26.106012] uhci_hcd 0000:00:1a.1: EARLY restore
[   26.106060] ehci_hcd 0000:00:1a.7: EARLY restore
[   26.106133] HDA Intel 0000:00:1b.0: EARLY restore
[   26.106217] pcieport 0000:00:1c.0: EARLY restore
[   26.106324] pcieport 0000:00:1c.1: EARLY restore
[   26.106431] pcieport 0000:00:1c.4: EARLY restore
[   26.106538] uhci_hcd 0000:00:1d.0: EARLY restore
[   26.106586] uhci_hcd 0000:00:1d.1: EARLY restore
[   26.106633] uhci_hcd 0000:00:1d.2: EARLY restore
[   26.106680] ehci_hcd 0000:00:1d.7: EARLY restore
[   26.106753] pci 0000:00:1e.0: EARLY restore
[   26.106814] pci 0000:00:1f.0: EARLY restore
[   26.106887] ata_piix 0000:00:1f.1: EARLY restore
[   26.106930] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2880001, writing 0x2880005)
[   26.106943] ahci 0000:00:1f.2: EARLY restore
[   26.107004] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[   26.107054] pci 0000:00:1f.3: EARLY restore
[   26.107101] pci 0000:01:00.0: EARLY restore
[   26.107214] sky2 0000:09:00.0: EARLY restore
[   26.107380] iwl3945 0000:0b:00.0: EARLY restore
[   26.107586] iwl3945 0000:0b:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[   26.107717] pci 0000:03:09.0: EARLY restore
[   26.107780] sdhci-pci 0000:03:09.1: EARLY restore
[   26.107832] sdhci-pci 0000:03:09.1: restoring config space at offset 0x1 (was 0x2100102, writing 0x2100106)
[   26.107851] pci 0000:03:09.2: EARLY restore
[   26.107913] pci 0000:03:09.3: EARLY restore
[   26.107982] pcspkr pcspkr: EARLY restore
[   26.107989] vesafb vesafb.0: EARLY restore
[   26.108003] serial8250 serial8250: EARLY restore
[   26.108013] i8042 i8042: EARLY restore
[   26.108018] atkbd serio0: EARLY restore
[   26.108021] psmouse serio1: EARLY restore
[   26.108026] coretemp coretemp.0: EARLY restore
[   26.108030] coretemp coretemp.1: EARLY restore
[   26.108034] iTCO_wdt iTCO_wdt: EARLY restore
[   26.108039] platform dell_rbu: EARLY restore
[   26.108043] dcdbas dcdbas: EARLY restore
[   26.108069] platform regulatory.0: EARLY restore
[   26.108076] dell-laptop dell-laptop: EARLY restore
[   26.108086] PM: early restore of devices complete after 2.266 msecs
[   26.137419] pci 0000:00:00.0: restore
[   26.137426] pcieport 0000:00:01.0: restore
[   26.137455] uhci_hcd 0000:00:1a.0: restore
[   26.137462] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   26.137466] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[   26.137485] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   26.137487] uhci_hcd 0000:00:1a.0: Performing full reset
[   26.137508] usb usb3: root hub lost power or was reset
[   26.137510] usb usb3: suspend_rh
[   26.137527] uhci_hcd 0000:00:1a.1: restore
[   26.137536] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   26.137539] uhci_hcd 0000:00:1a.1: uhci_pci_resume
[   26.137558] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[   26.137559] uhci_hcd 0000:00:1a.1: Performing full reset
[   26.137580] usb usb4: root hub lost power or was reset
[   26.137581] usb usb4: suspend_rh
[   26.137597] ehci_hcd 0000:00:1a.7: restore
[   26.137602] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   26.137606] usb usb1: root hub lost power or was reset
[   26.137613] ehci_hcd 0000:00:1a.7: reset command 010002 (park)=0 ithresh=1 period=1024 Reset HALT
[   26.137689] acpi LNXSYSTM:00: legacy restore
[   26.137692] processor LNXCPU:00: legacy restore
[   26.137697] processor LNXCPU:01: legacy restore
[   26.137699] acpi LNXSYBUS:00: legacy restore
[   26.137702] battery PNP0C0A:00: legacy restore
[   26.141502] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   26.141509] HDA Intel 0000:00:1b.0: restore
[   26.141517] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   26.141665] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   26.141715] HDA Intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[   26.141754] pcieport 0000:00:1c.0: restore
[   26.141757] pcieport 0000:00:1c.1: restore
[   26.141761] pcieport 0000:00:1c.4: restore
[   26.141904] uhci_hcd 0000:00:1d.0: restore
[   26.141910] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   26.141913] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[   26.141931] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   26.141932] uhci_hcd 0000:00:1d.0: Performing full reset
[   26.141952] usb usb5: root hub lost power or was reset
[   26.141954] usb usb5: suspend_rh
[   26.141970] uhci_hcd 0000:00:1d.1: restore
[   26.141975] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   26.141978] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[   26.141998] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   26.142000] uhci_hcd 0000:00:1d.1: Performing full reset
[   26.142161] usb usb6: root hub lost power or was reset
[   26.142163] usb usb6: suspend_rh
[   26.142178] uhci_hcd 0000:00:1d.2: restore
[   26.142186] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   26.142189] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[   26.142207] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   26.142208] uhci_hcd 0000:00:1d.2: Performing full reset
[   26.142228] usb usb7: root hub lost power or was reset
[   26.142230] usb usb7: suspend_rh
[   26.142245] ehci_hcd 0000:00:1d.7: restore
[   26.142252] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   26.142256] usb usb2: root hub lost power or was reset
[   26.142262] ehci_hcd 0000:00:1d.7: reset command 010002 (park)=0 ithresh=1 period=1024 Reset HALT
[   26.146267] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   26.146273] pci 0000:00:1e.0: restore
[   26.146281] pci 0000:00:1e.0: setting latency timer to 64
[   26.146284] pci 0000:00:1f.0: restore
[   26.146287] ata_piix 0000:00:1f.1: restore
[   26.146293] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   26.146298] ata_piix 0000:00:1f.1: setting latency timer to 64
[   26.146321] ata1.00: _GTF evaluation failed (AE 0x1001)
[   26.146599] ahci 0000:00:1f.2: restore
[   26.146749] ahci 0000:00:1f.2: setting latency timer to 64
[   26.146806] pci 0000:00:1f.3: restore
[   26.146808] pci 0000:01:00.0: restore
[   26.146811] sky2 0000:09:00.0: restore
[   26.147006] iwl3945 0000:0b:00.0: restore
[   26.147054] pci 0000:03:09.0: restore
[   26.147057] sdhci-pci 0000:03:09.1: restore
[   26.147062] sdhci-pci 0000:03:09.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   26.148168] pci 0000:03:09.2: restore
[   26.148171] pci 0000:03:09.3: restore
[   26.148173] usb usb1: type restore
[   26.148176] usb usb1: usb resume
[   26.148179] ehci_hcd 0000:00:1a.7: resume root hub after power loss
[   26.148204] pci_root PNP0A03:00: legacy restore
[   26.148205] acpi device:00: legacy restore
[   26.148207] acpi PNP0C02:00: legacy restore
[   26.148209] acpi PNP0F13:00: legacy restore
[   26.148211] acpi PNP0303:00: legacy restore
[   26.148213] acpi PNP0B00:00: legacy restore
[   26.148214] acpi PNP0100:00: legacy restore
[   26.148216] acpi PNP0800:00: legacy restore
[   26.148218] acpi PNP0C01:00: legacy restore
[   26.148220] acpi PNP0000:00: legacy restore
[   26.148221] acpi PNP0200:00: legacy restore
[   26.148223] acpi PNP0C04:00: legacy restore
[   26.148225] acpi PNP0103:00: legacy restore
[   26.148226] acpi device:01: legacy restore
[   26.148232] ata2: port disabled. ignoring.
[   26.148230] acpi device:02: legacy restore
[   26.148232] acpi device:03: legacy restore
[   26.148234] acpi device:04: legacy restore
[   26.148239] acpi device:05: legacy restore
[   26.148242] usb usb2: type restore
[   26.148244] usb usb2: usb resume
[   26.148247] ehci_hcd 0000:00:1d.7: resume root hub after power loss
[   26.148251] acpi device:06: legacy restore
[   26.148252] acpi device:07: legacy restore
[   26.148254] acpi device:08: legacy restore
[   26.148267] acpi device:09: legacy restore
[   26.148276] acpi device:0a: legacy restore
[   26.148276] acpi device:0b: legacy restore
[   26.148276] acpi device:0c: legacy restore
[   26.148276] acpi device:0d: legacy restore
[   26.148276] acpi device:0e: legacy restore
[   26.148278] acpi device:0f: legacy restore
[   26.148279] acpi device:10: legacy restore
[   26.148281] acpi device:11: legacy restore
[   26.148283] acpi device:12: legacy restore
[   26.148296] acpi device:13: legacy restore
[   26.148298] usb usb3: type restore
[   26.148300] usb usb3: usb resume
[   26.148302] usb usb3: wakeup_rh
[   26.148307] acpi device:14: legacy restore
[   26.148311] acpi device:15: legacy restore
[   26.148319] acpi device:16: legacy restore
[   26.148319] acpi device:17: legacy restore
[   26.148319] acpi device:18: legacy restore
[   26.148319] acpi device:19: legacy restore
[   26.148319] acpi device:1a: legacy restore
[   26.148321] acpi device:1b: legacy restore
[   26.148323] acpi device:1c: legacy restore
[   26.148324] acpi device:1d: legacy restore
[   26.148326] acpi device:1e: legacy restore
[   26.148341] usb usb4: type restore
[   26.148344] usb usb5: type restore
[   26.148347] usb usb6: type restore
[   26.148349] usb usb6: usb resume
[   26.148350] usb usb6: wakeup_rh
[   26.148347] acpi device:1f: legacy restore
[   26.148347] acpi device:20: legacy restore
[   26.148347] acpi device:21: legacy restore
[   26.148347] acpi device:22: legacy restore
[   26.148358] acpi device:23: legacy restore
[   26.148366] acpi device:24: legacy restore
[   26.148366] acpi device:25: legacy restore
[   26.148366] acpi device:26: legacy restore
[   26.148367] acpi device:27: legacy restore
[   26.148369] acpi device:28: legacy restore
[   26.148371] acpi device:29: legacy restore
[   26.148372] acpi device:2a: legacy restore
[   26.148384] acpi device:2b: legacy restore
[   26.148387] usb usb7: type restore
[   26.148389] usb usb7: usb resume
[   26.148390] usb usb7: wakeup_rh
[   26.148395] acpi device:2c: legacy restore
[   26.148395] acpi device:2d: legacy restore
[   26.148395] video LNXVIDEO:00: legacy restore
[   26.148431] i8042 i8042: restore
[   26.152215] atkbd serio0: restore
[   26.152217] psmouse serio1: restore
[   26.152362] scsi host1: legacy restore
[   26.152365] scsi host2: legacy restore
[   26.152368] scsi host3: legacy restore
[   26.152371] scsi host4: legacy restore
[   26.152373] scsi host5: legacy restore
[   26.152403] scsi target1:0:0: legacy restore
[   26.152406] sr 1:0:0:0: legacy restore
[   26.152412] scsi target3:0:0: legacy restore
[   26.152415] sd 3:0:0:0: legacy restore
[   26.152418] sd 3:0:0:0: [sda] Starting disk
[   26.161180] acpi device:2e: legacy restore
[   26.161183] acpi device:2f: legacy restore
[   26.161185] acpi device:30: legacy restore
[   26.161187] acpi device:31: legacy restore
[   26.161188] acpi PNP0C01:01: legacy restore
[   26.161190] acpi PNP0C01:02: legacy restore
[   26.161192] acpi device:32: legacy restore
[   26.161193] acpi device:33: legacy restore
[   26.161195] acpi device:34: legacy restore
[   26.161197] acpi device:35: legacy restore
[   26.161198] acpi device:36: legacy restore
[   26.161200] acpi device:37: legacy restore
[   26.161202] acpi device:38: legacy restore
[   26.161203] acpi device:39: legacy restore
[   26.161205] acpi device:3a: legacy restore
[   26.161206] acpi device:3b: legacy restore
[   26.161208] acpi device:3c: legacy restore
[   26.161210] acpi device:3d: legacy restore
[   26.161212] pci_link PNP0C0F:00: legacy restore
[   26.161214] pci_link PNP0C0F:01: legacy restore
[   26.161216] pci_link PNP0C0F:02: legacy restore
[   26.161218] pci_link PNP0C0F:03: legacy restore
[   26.161220] pci_link PNP0C0F:04: legacy restore
[   26.161221] pci_link PNP0C0F:05: legacy restore
[   26.161223] pci_link PNP0C0F:06: legacy restore
[   26.161225] pci_link PNP0C0F:07: legacy restore
[   26.161226] acpi PNP0C01:03: legacy restore
[   26.161228] button PNP0C0D:00: legacy restore
[   26.306963] button PNP0C0C:00: legacy restore
[   26.306966] button PNP0C0E:00: legacy restore
[   26.306968] ac ACPI0003:00: legacy restore
[   26.306997] acpi PNP0C32:00: legacy restore
[   26.306999] wmi pnp0c14:00: legacy restore
[   26.307001] acpi LNXTHERM:00: legacy restore
[   26.307003] thermal LNXTHERM:01: legacy restore
[   26.307088] pnp 00:00: legacy restore
[   26.307091] system 00:01: legacy restore
[   26.307094] i8042 aux 00:02: legacy restore
[   26.307097] i8042 kbd 00:03: legacy restore
[   26.307099] rtc_cmos 00:04: legacy restore
[   26.307102] pnp 00:05: legacy restore
[   26.307104] system 00:06: legacy restore
[   26.307106] pnp 00:07: legacy restore
[   26.307108] pnp 00:08: legacy restore
[   26.307109] system 00:09: legacy restore
[   26.307111] system 00:0a: legacy restore
[   26.307113] system 00:0b: legacy restore
[   26.307115] system 00:0c: legacy restore
[   26.307124] pcspkr pcspkr: restore
[   26.307133] vesafb vesafb.0: restore
[   26.307165] serial8250 serial8250: restore
[   26.323715] hub 7-0:1.0: hub_reset_resume
[   26.323718] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   26.323729] hub 6-0:1.0: hub_reset_resume
[   26.323731] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   26.323739] hub 3-0:1.0: hub_reset_resume
[   26.323741] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   26.334080] ehci_hcd 0000:00:1d.7: port 3 low speed --> companion
[   26.363109] ata1.00: configured for UDMA/33
[   26.432749] uhci_hcd 0000:00:1d.1: port 1 portsc 01ab,00
[   26.432760] hub 6-0:1.0: port 1: status 0301 change 0003
[   26.433040] ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
[   26.433049] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[   26.433068] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[   26.433085] uhci_hcd 0000:00:1a.0: port 2 portsc 008b,00
[   26.433091] hub 3-0:1.0: port 2: status 0101 change 0003
[   26.433124] uhci_hcd 0000:00:1d.2: port 2 portsc 008a,00
[   26.433130] hub 7-0:1.0: port 2: status 0100 change 0003
[   26.433302] ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
[   26.433309] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
[   26.433320] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[   26.452678] hub 2-0:1.0: hub_reset_resume
[   26.452685] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   26.452728] hub 1-0:1.0: hub_reset_resume
[   26.452732] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   26.542769] usb 7-2: type restore
[   26.542788] uhci_hcd 0000:00:1d.2: port 2 portsc 0093,00
[   26.542801] usb 7-2: finish reset-resume
[   26.542841] usb 3-2: type restore
[   26.542853] usb 3-2: finish reset-resume
[   26.542882] usb 6-1: type restore
[   26.542895] usb 6-1: finish reset-resume
[   26.562737] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[   26.562746] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[   26.562754] hub 2-0:1.0: port 1: status 0501 change 0001
[   26.562760] hub 1-0:1.0: port 1: status 0501 change 0001
[   26.562772] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[   26.562778] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[   26.562785] hub 2-0:1.0: port 2: status 0501 change 0001
[   26.562815] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[   26.632727] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   26.634564] ata3.00: configured for UDMA/100
[   26.650142] ata5: SATA link down (SStatus 0 SControl 300)
[   26.662690] usb 7-2: reset full speed USB device using uhci_hcd and address 2
[   26.670211] usb 1-1: type restore
[   26.670232] usb 1-1: finish reset-resume
[   26.670300] usb 2-1: type restore
[   26.670310] usb 2-2: type restore
[   26.670315] usb 2-1: finish reset-resume
[   26.670324] usb 2-2: finish reset-resume
[   26.670363] input input0: type restore
[   26.670387] rtc rtc0: legacy class restore
[   26.670454] coretemp coretemp.0: restore
[   26.670461] coretemp coretemp.1: restore
[   26.670467] iTCO_wdt iTCO_wdt: restore
[   26.670474] leds mmc0::: legacy class restore
[   26.670482] platform dell_rbu: restore
[   26.670487] dcdbas dcdbas: restore
[   26.670495] input input1: type restore
[   26.802655] usb 7-2: ep0 maxpacket = 8
[   26.817855] hub 7-2:1.0: hub_reset_resume
[   26.817862] hub 7-2:1.0: enabling power on all ports
[   26.920168] usb 3-2: reset full speed USB device using uhci_hcd and address 2
[   26.934853] hub 7-2:1.0: port 1: status 0101 change 0001
[   26.936854] hub 7-2:1.0: port 2: status 0101 change 0001
[   26.938852] hub 7-2:1.0: port 3: status 0101 change 0001
[   27.040239] uhci_hcd 0000:00:1d.2: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[   27.040274] usb 7-2.1: type restore
[   27.040288] usb 7-2.2: type restore
[   27.040297] usb 7-2.3: type restore
[   27.041855] usb 7-2.1: finish reset-resume
[   27.042848] usb 7-2.2: finish reset-resume
[   27.043854] usb 7-2.3: finish reset-resume
[   27.060193] usb 3-2: ep0 maxpacket = 8
[   27.330202] usb 6-1: reset low speed USB device using uhci_hcd and address 2
[   27.683826] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   27.710418] ehci_hcd 0000:00:1a.7: port 1 high speed
[   27.710428] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   27.762730] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[   27.820417] ehci_hcd 0000:00:1a.7: port 1 high speed
[   27.820428] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   27.970430] ehci_hcd 0000:00:1d.7: port 1 high speed
[   27.970441] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   27.971366] input input2: type restore
[   27.971378] input input3: type restore
[   27.971387] input input4: type restore
[   27.971393] input input5: type restore
[   27.971399] input input6: type restore
[   28.030177] usb 2-1: reset high speed USB device using ehci_hcd and address 2
[   28.092929] ehci_hcd 0000:00:1d.7: port 1 high speed
[   28.092940] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[   28.184385] scsi host0: legacy restore
[   28.184406] scsi target0:0:0: legacy restore
[   28.184418] sd 0:0:0:0: legacy restore
[   28.240433] ehci_hcd 0000:00:1d.7: port 2 high speed
[   28.240444] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   28.302706] usb 2-2: reset high speed USB device using ehci_hcd and address 3
[   28.360431] ehci_hcd 0000:00:1d.7: port 2 high speed
[   28.360441] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   28.452213] hub 2-2:1.0: hub_reset_resume
[   28.452220] hub 2-2:1.0: enabling power on all ports
[   28.531836] usb 7-2.1: reset full speed USB device using uhci_hcd and address 3
[   28.563092] hub 2-2:1.0: port 1: status 0101 change 0001
[   28.643830] btusb 7-2.1:1.0: no reset_resume for driver btusb?
[   28.643838] btusb 7-2.1:1.1: no reset_resume for driver btusb?
[   28.643844] btusb 7-2.1:1.0: forced unbind
[   28.643878] PM: Removing info for No Bus:rfkill0
[   28.643932] PM: Removing info for No Bus:hci0
[   28.672707] usb 2-2: link qh256-0001/ffff88011c72e4c0 start 2 [1/0 us]
[   28.672746] usb 2-2.1: type restore
[   28.673212] usb 2-2.1: finish reset-resume
[   28.721832] usb 7-2.2: reset full speed USB device using uhci_hcd and address 4
[   28.820154] usb 7-2.2: ep0 maxpacket = 8
[   28.837843] uhci_hcd 0000:00:1d.2: reserve dev 4 ep81-INT, period 8, phase 4, 17 us
[   28.901852] usb 7-2.3: reset full speed USB device using uhci_hcd and address 5
[   29.002658] usb 7-2.3: ep0 maxpacket = 8
[   29.083090] usb 2-2.1: reset full speed USB device using ehci_hcd and address 6
[   29.192693] usb 2-2.1: ep0 maxpacket = 8
[   29.194964] usblp 2-2.1:1.1: no reset_resume for driver usblp?
[   29.194971] usblp 2-2.1:1.1: forced unbind
[   29.194989] drivers/usb/core/file.c: removing 0 minor
[   29.194998] PM: Removing info for No Bus:lp0
[   29.195101] usblp0: removed
[   29.195177] platform regulatory.0: restore
[   29.195188] input input7: type restore
[   29.195196] input input8: type restore
[   29.195232] input input9: type restore
[   29.195239] input input10: type restore
[   29.195246] input input11: type restore
[   29.195270] input input12: type restore
[   29.195279] dell-laptop dell-laptop: restore
[   29.195284] input input13: type restore
[   29.195293] backlight acpi_video0: legacy class restore
[   29.195302] input input14: type restore
[   29.195311] input input15: type restore
[   29.195318] ieee80211 phy0: legacy class restore
[   29.195334] rfkill rfkill1: legacy class restore
[   29.195366] PM: restore of devices complete after 3057.982 msecs
[   29.195380] dell-laptop dell-laptop: completing restore
[   29.195395] platform regulatory.0: completing restore
[   29.195407] usb 7-2.3: completing type restore
[   29.195416] usb 7-2.2: completing type restore
[   29.195429] usb 7-2.1: completing type restore
[   29.195465] usbserial_generic 7-2.1:1.0: usb_probe_interface
[   29.195471] usbserial_generic 7-2.1:1.0: usb_probe_interface - got id
[   29.195512] btusb 7-2.1:1.0: usb_probe_interface
[   29.195516] btusb 7-2.1:1.0: usb_probe_interface - got id
[   29.195580] PM: Adding info for No Bus:hci0
[   29.195621] PM: Adding info for No Bus:rfkill2
[   29.195698] usb 2-2.1: completing type restore
[   29.195712] usblp 2-2.1:1.1: usb_probe_interface
[   29.195718] usblp 2-2.1:1.1: usb_probe_interface - got id
[   29.196861] drivers/usb/core/file.c: looking for a minor, starting at 0
[   29.196931] PM: Adding info for No Bus:lp0
[   29.196954] usblp0: USB Bidirectional printer dev 6 if 1 alt 0 proto 2 vid 0x04E8 pid 0x3419
[   29.196968] usb 7-2: completing type restore
[   29.196977] usb 6-1: completing type restore
[   29.196988] usb 3-2: completing type restore
[   29.197015] usb 2-2: completing type restore
[   29.197038] usb 2-1: completing type restore
[   29.197080] usb 1-1: completing type restore
[   29.197091] dcdbas dcdbas: completing restore
[   29.197096] platform dell_rbu: completing restore
[   29.197105] iTCO_wdt iTCO_wdt: completing restore
[   29.197111] coretemp coretemp.1: completing restore
[   29.197118] coretemp coretemp.0: completing restore
[   29.197129] i8042 i8042: completing restore
[   29.197137] usb usb7: completing type restore
[   29.197146] usb usb6: completing type restore
[   29.197155] usb usb5: completing type restore
[   29.197163] usb usb4: completing type restore
[   29.197170] usb usb3: completing type restore
[   29.197179] usb usb2: completing type restore
[   29.197188] usb usb1: completing type restore
[   29.197199] serial8250 serial8250: completing restore
[   29.197277] vesafb vesafb.0: completing restore
[   29.197295] pcspkr pcspkr: completing restore
[   29.197336] pci 0000:03:09.3: completing restore
[   29.197341] pci 0000:03:09.2: completing restore
[   29.197346] sdhci-pci 0000:03:09.1: completing restore
[   29.197351] pci 0000:03:09.0: completing restore
[   29.197359] iwl3945 0000:0b:00.0: completing restore
[   29.197365] sky2 0000:09:00.0: completing restore
[   29.197371] pci 0000:01:00.0: completing restore
[   29.197376] pci 0000:00:1f.3: completing restore
[   29.197381] ahci 0000:00:1f.2: completing restore
[   29.197387] ata_piix 0000:00:1f.1: completing restore
[   29.197391] pci 0000:00:1f.0: completing restore
[   29.197396] pci 0000:00:1e.0: completing restore
[   29.197401] ehci_hcd 0000:00:1d.7: completing restore
[   29.197406] uhci_hcd 0000:00:1d.2: completing restore
[   29.197411] uhci_hcd 0000:00:1d.1: completing restore
[   29.197415] uhci_hcd 0000:00:1d.0: completing restore
[   29.197420] pcieport 0000:00:1c.4: completing restore
[   29.197425] pcieport 0000:00:1c.1: completing restore
[   29.197430] pcieport 0000:00:1c.0: completing restore
[   29.197435] HDA Intel 0000:00:1b.0: completing restore
[   29.197439] ehci_hcd 0000:00:1a.7: completing restore
[   29.197444] uhci_hcd 0000:00:1a.1: completing restore
[   29.197449] uhci_hcd 0000:00:1a.0: completing restore
[   29.197454] pcieport 0000:00:01.0: completing restore
[   29.197458] pci 0000:00:00.0: completing restore
[   29.197798] PM: Image restored successfully.
[   29.197802] Restarting tasks ... 
[   29.197858] hub 7-0:1.0: state 7 ports 2 chg 0004 evt 0000
[   29.197863] usb usb5: usb resume
[   29.197868] usb usb5: wakeup_rh
[   29.197885] hub 7-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[   29.197893] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
[   29.197907] hub 3-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[   29.197915] hub 6-0:1.0: state 7 ports 2 chg 0002 evt 0000
[   29.197929] hub 6-0:1.0: port 1, status 0303, change 0000, 1.5 Mb/s
[   29.197937] hub 1-0:1.0: state 7 ports 4 chg 0002 evt 0000
[   29.197949] hub 1-0:1.0: port 1, status 0503, change 0000, 480 Mb/s
[   29.197957] hub 2-0:1.0: state 7 ports 6 chg 0006 evt 0000
[   29.197966] hub 2-0:1.0: port 1, status 0503, change 0000, 480 Mb/s
[   29.197976] hub 2-0:1.0: port 2, status 0503, change 0000, 480 Mb/s
[   29.197983] hub 7-2:1.0: state 7 ports 3 chg 000e evt 0008
[   29.198724] hub 7-2:1.0: port 1, status 0103, change 0000, 12 Mb/s
[   29.199717] hub 7-2:1.0: port 2, status 0103, change 0000, 12 Mb/s
[   29.200715] hub 7-2:1.0: port 3, status 0103, change 0000, 12 Mb/s
[   29.200726] hub 2-2:1.0: state 7 ports 4 chg 0002 evt 0000
[   29.201083] hub 2-2:1.0: port 1, status 0103, change 0000, 12 Mb/s
[   29.204143] done.
[   29.204253] PM: Basic memory bitmaps freed
[   29.242525] hub 5-0:1.0: hub_reset_resume
[   29.242527] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   29.350208] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[   29.350231] uhci_hcd 0000:00:1d.0: port 2 portsc 0082,00
[   29.460245] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   30.540210] usb usb5: suspend_rh (auto-stop)
[   31.235528] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[   31.235536] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.
[   31.432948] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[   31.432955] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.
[   31.619950] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[   31.619958] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.
[   31.768903] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[   31.768911] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.
[   31.943189] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[   31.943196] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.
[   32.040236] hub 5-0:1.0: hub_suspend
[   32.040255] usb usb5: bus auto-suspend
[   32.040262] usb usb5: suspend_rh
[   32.120337] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[   32.120344] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.
[   32.309458] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[   32.309465] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.

--------------060802040905000902000807--
