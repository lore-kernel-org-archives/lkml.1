Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbZC3XZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbZC3XZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZC3XZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:25:21 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:36136 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZC3XZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TLZZPGMt+aGmCrDAcDrmcltJ6TZ+Eo+CJVXKjC7HPBDvDcWC2Vfa6Paxu39tYBNrd3
         iOUf8q9CdGTl6aG9T26EmQGrQazuLYrwXSWIGXMh5+eBemt+DE/jSj0DLyrWcPK8Tz2F
         EH5o/Qq63J0W2n3IXLHqn4XGezxvRETa0rdX0=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.29 git master and PAT problems
Date: Tue, 31 Mar 2009 01:25:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903302317.04515.a.miskiewicz@gmail.com> <1238449555.4529.1095.camel@localhost.localdomain> <200903310031.10335.a.miskiewicz@gmail.com>
In-Reply-To: <200903310031.10335.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903310125.12120.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 of March 2009, Arkadiusz Miskiewicz wrote:
> On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
>
> More info follows. Now I've switched to
> e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm fixes
> and now I get much lower numbers of PAT errors but still.

Also when I switch t400 into discrete mode (radeon hd 3400 instead
of integrated intel GM45) I get such errors (probably unrelated
to these seen when using intel):

[  419.187657] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  419.187670] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  419.553914] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  419.553923] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  419.813592] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  419.813601] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  420.100102] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  420.100111] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back


# cat /debug/x86/pat_memtype_list
PAT memtype list:
uncached-minus @ 0xbfad1000-0xbfad2000
uncached-minus @ 0xbfad2000-0xbfad3000
uncached-minus @ 0xbfad3000-0xbfad4000
uncached-minus @ 0xbfb06000-0xbfb07000
uncached-minus @ 0xbfb07000-0xbfb08000
uncached-minus @ 0xbfd6a000-0xbfd6b000
uncached-minus @ 0xbfd6a000-0xbfd6b000
uncached-minus @ 0xbfd6a000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd7b000-0xbfd7c000
uncached-minus @ 0xbfd8d000-0xbfd8e000
uncached-minus @ 0xbfd8e000-0xbfd8f000
uncached-minus @ 0xbfd8e000-0xbfd8f000
write-combining @ 0xd0000000-0xe0000000
write-combining @ 0xd0000000-0xe0000000
write-combining @ 0xdfff0000-0xe0000000
write-combining @ 0xdfff0000-0xe0000000
write-combining @ 0xdfff0000-0xe0000000
uncached-minus @ 0xe0000000-0xe4000000
uncached-minus @ 0xf4200000-0xf4202000
uncached-minus @ 0xf4300000-0xf4301000
uncached-minus @ 0xf4301000-0xf4302000
uncached-minus @ 0xf4301000-0xf4302000
uncached-minus @ 0xfc200000-0xfc220000
uncached-minus @ 0xfc220000-0xfc224000
uncached-minus @ 0xfc225000-0xfc226000
uncached-minus @ 0xfc226000-0xfc227000
uncached-minus @ 0xfc226000-0xfc227000
uncached-minus @ 0xfc227000-0xfc228000
uncached-minus @ 0xfed00000-0xfed01000
uncached-minus @ 0xfed1f000-0xfed20000
# cat /proc/mtrr
reg00: base=0x13c000000 ( 5056MB), size=   64MB, count=1: uncachable
reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg03: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining

[    0.000000] Linux version 2.6.29 (root@t400) (gcc version 4.3.3 20090307 (release) (PLD-Linux) ) #122 SMP PREEMPT Mon Mar 30 23:59:15 CEST 2009
[    0.000000] Command line: root=/dev/sda3 elevator=cfq resume=/dev/sda2 ro vga=6
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf8a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bf8a1000 - 00000000bf8a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf8a7000 - 00000000bf9b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bf9b7000 - 00000000bfa0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfa0f000 - 00000000bfac6000 (usable)
[    0.000000]  BIOS-e820: 00000000bfac6000 - 00000000bfad1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfad1000 - 00000000bfad4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfad4000 - 00000000bfad8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfad8000 - 00000000bfadc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfadc000 - 00000000bfadf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfadf000 - 00000000bfb06000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfb06000 - 00000000bfb08000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfb08000 - 00000000bfd0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfd0f000 - 00000000bfd9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfd9f000 - 00000000bfdff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfdff000 - 00000000bfe00000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[    0.000000]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[    0.000000]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[    0.000000]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfe00 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe00000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000] kernel direct mapping tables up to bfe00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] RAMDISK: 37f14000 - 37fef63c
[    0.000000] ACPI: RSDP 000F64E0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT BFD6A2C6, 009C (r1 LENOVO TP-7U        2070  LTP        0)
[    0.000000] ACPI: FACP BFD6A400, 00F4 (r3 LENOVO TP-7U        2070 LNVO        1)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aControlBlock: 16/32 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBlock: 32, using default 16 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT BFD6A7DB, F3A8 (r1 LENOVO TP-7U        2070 MSFT  3000000)
[    0.000000] ACPI: FACS BFD8E000, 0040
[    0.000000] ACPI: SSDT BFD6A5B4, 0227 (r1 LENOVO TP-7U        2070 MSFT  3000000)
[    0.000000] ACPI: ECDT BFD79B83, 0052 (r1 LENOVO TP-7U        2070 LNVO        1)
[    0.000000] ACPI: APIC BFD79BD5, 0078 (r1 LENOVO TP-7U        2070 LNVO        1)
[    0.000000] ACPI: MCFG BFD79C4D, 003C (r1 LENOVO TP-7U        2070 LNVO        1)
[    0.000000] ACPI: HPET BFD79C89, 0038 (r1 LENOVO TP-7U        2070 LNVO        1)
[    0.000000] ACPI: SLIC BFD79DC2, 0176 (r1 LENOVO TP-7U        2070  LTP        0)
[    0.000000] ACPI: BOOT BFD79F38, 0028 (r1 LENOVO TP-7U        2070  LTP        1)
[    0.000000] ACPI: ASF! BFD79F60, 00A0 (r16 LENOVO TP-7U        2070 PTL         1)
[    0.000000] ACPI: SSDT BFD8D213, 054F (r1 LENOVO TP-7U        2070 INTL 20050513)
[    0.000000] ACPI: TCPA BFB07000, 0032 (r0                        0             0)
[    0.000000] ACPI: DMAR BFB06000, 00D8 (r1                       1             0)
[    0.000000] ACPI: SSDT BFAD3000, 0655 (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: SSDT BFAD2000, 0274 (r1  PmRef  Cpu0Tst     3000 INTL 20050624)
[    0.000000] ACPI: SSDT BFAD1000, 0242 (r1  PmRef    ApTst     3000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00007984d0]    TEXT DATA BSS ==> [0000200000 - 00007984d0]
[    0.000000]   #3 [0037f14000 - 0037fef63c]          RAMDISK ==> [0037f14000 - 0037fef63c]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0000799000 - 000079914c]              BRK ==> [0000799000 - 000079914c]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f6520] f6520
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bf8a1
[    0.000000]     0: 0x000bf8a7 -> 0x000bf9b7
[    0.000000]     0: 0x000bfa0f -> 0x000bfac6
[    0.000000]     0: 0x000bfdff -> 0x000bfe00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1030663
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1535 pages reserved
[    0.000000]   DMA zone: 2407 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 766625 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf8a1000 - 00000000bf8a7000
[    0.000000] PM: Registered nosave memory: 00000000bf9b7000 - 00000000bfa0f000
[    0.000000] PM: Registered nosave memory: 00000000bfac6000 - 00000000bfad1000
[    0.000000] PM: Registered nosave memory: 00000000bfad1000 - 00000000bfad4000
[    0.000000] PM: Registered nosave memory: 00000000bfad4000 - 00000000bfad8000
[    0.000000] PM: Registered nosave memory: 00000000bfad8000 - 00000000bfadc000
[    0.000000] PM: Registered nosave memory: 00000000bfadc000 - 00000000bfadf000
[    0.000000] PM: Registered nosave memory: 00000000bfadf000 - 00000000bfb06000
[    0.000000] PM: Registered nosave memory: 00000000bfb06000 - 00000000bfb08000
[    0.000000] PM: Registered nosave memory: 00000000bfb08000 - 00000000bfd0f000
[    0.000000] PM: Registered nosave memory: 00000000bfd0f000 - 00000000bfd9f000
[    0.000000] PM: Registered nosave memory: 00000000bfd9f000 - 00000000bfdff000
[    0.000000] PM: Registered nosave memory: 00000000bfe00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028023000, static data 73376 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1011432
[    0.000000] Kernel command line: root=/dev/sda3 elevator=cfq resume=/dev/sda2 ro vga=6
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.902 MHz processor.
[    0.004000] Console: colour VGA+ 80x60
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.004000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.004000] Memory: 3970900k/5177344k available (2870k kernel code, 1054692k absent, 150828k reserved, 1353k data, 424k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.80 BogoMIPS (lpj=10107608)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20081204
[    0.024057] Setting APIC routing to flat
[    0.024479] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065449] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5053.96 BogoMIPS (lpj=10107928)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.153676] CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.154412] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156026] Brought up 2 CPUs
[    0.156088] Total of 2 processors activated (10107.76 BogoMIPS).
[    0.156195] CPU0 attaching sched-domain:
[    0.156198]  domain 0: span 0-1 level MC
[    0.156199]   groups: 0 1
[    0.156203] CPU1 attaching sched-domain:
[    0.156205]  domain 0: span 0-1 level MC
[    0.156206]   groups: 1 0
[    0.156271] net_namespace: 1952 bytes
[    0.156271] regulator: core version 0.5
[    0.156278] NET: Registered protocol family 16
[    0.156428] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.156501] ACPI: bus type pci registered
[    0.156635] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.156701] PCI: MCFG area at e0000000 reserved in E820
[    0.164342] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.164406] PCI: Using configuration type 1 for base access
[    0.164784] bio: create slab <bio-0> at 0
[    0.166081] ACPI: EC: EC description table is found, configuring boot EC
[    0.173775] ACPI: BIOS _OSI(Linux) query ignored
[    0.172019] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.186079] ACPI: Interpreter enabled
[    0.186145] ACPI: (supports S0 S3 S4 S5)
[    0.188215] ACPI: Using IOAPIC for interrupt routing
[    0.220702] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.220766] ACPI: EC: driver started in interrupt mode
[    0.225221] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.225641] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.225641] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.225641] pci 0000:00:01.0: PME# disabled
[    0.225641] pci 0000:00:03.0: reg 10 64bit mmio: [0xfc226800-0xfc22680f]
[    0.225641] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.225641] pci 0000:00:03.0: PME# disabled
[    0.225641] pci 0000:00:03.2: reg 10 io port: [0x1820-0x1827]
[    0.225641] pci 0000:00:03.2: reg 14 io port: [0x1814-0x1817]
[    0.225641] pci 0000:00:03.2: reg 18 io port: [0x1818-0x181f]
[    0.225641] pci 0000:00:03.2: reg 1c io port: [0x1810-0x1813]
[    0.225641] pci 0000:00:03.2: reg 20 io port: [0x1800-0x180f]
[    0.225641] pci 0000:00:03.3: reg 10 io port: [0x1828-0x182f]
[    0.225641] pci 0000:00:03.3: reg 14 32bit mmio: [0xfc224000-0xfc224fff]
[    0.225641] pci 0000:00:19.0: reg 10 32bit mmio: [0xfc200000-0xfc21ffff]
[    0.225641] pci 0000:00:19.0: reg 14 32bit mmio: [0xfc225000-0xfc225fff]
[    0.225641] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.225641] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.225641] pci 0000:00:19.0: PME# disabled
[    0.225641] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.225641] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.225641] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.225641] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfc226c00-0xfc226fff]
[    0.225641] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.225641] pci 0000:00:1a.7: PME# disabled
[    0.225641] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfc220000-0xfc223fff]
[    0.225641] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.225650] pci 0000:00:1b.0: PME# disabled
[    0.225786] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.225852] pci 0000:00:1c.0: PME# disabled
[    0.225989] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.226055] pci 0000:00:1c.1: PME# disabled
[    0.226195] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.226261] pci 0000:00:1c.3: PME# disabled
[    0.226400] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.226464] pci 0000:00:1c.4: PME# disabled
[    0.226594] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.226679] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.226764] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.226849] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfc227000-0xfc2273ff]
[    0.226912] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.226978] pci 0000:00:1d.7: PME# disabled
[    0.227273] pci 0000:00:1f.2: reg 10 io port: [0x1c40-0x1c47]
[    0.227280] pci 0000:00:1f.2: reg 14 io port: [0x1834-0x1837]
[    0.227287] pci 0000:00:1f.2: reg 18 io port: [0x1838-0x183f]
[    0.227294] pci 0000:00:1f.2: reg 1c io port: [0x1830-0x1833]
[    0.227300] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.227307] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfc226000-0xfc2267ff]
[    0.227351] pci 0000:00:1f.2: PME# supported from D3hot
[    0.227415] pci 0000:00:1f.2: PME# disabled
[    0.227513] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfc227400-0xfc2274ff]
[    0.227530] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.227587] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
[    0.227594] pci 0000:01:00.0: reg 14 io port: [0x2000-0x20ff]
[    0.227601] pci 0000:01:00.0: reg 18 32bit mmio: [0xcfff0000-0xcfffffff]
[    0.227623] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.227649] pci 0000:01:00.0: supports D1 D2
[    0.227704] pci 0000:00:01.0: bridge io port: [0x2000-0x2fff]
[    0.227707] pci 0000:00:01.0: bridge 32bit mmio: [0xcff00000-0xcfffffff]
[    0.227710] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.227889] pci 0000:03:00.0: reg 10 64bit mmio: [0xf4200000-0xf4201fff]
[    0.228044] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.228135] pci 0000:03:00.0: PME# disabled
[    0.228291] pci 0000:00:1c.1: bridge 32bit mmio: [0xf4200000-0xf42fffff]
[    0.228351] pci 0000:00:1c.3: bridge io port: [0x3000-0x3fff]
[    0.228356] pci 0000:00:1c.3: bridge 32bit mmio: [0xf8000000-0xf9ffffff]
[    0.228363] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf4000000-0xf40fffff]
[    0.228417] pci 0000:00:1c.4: bridge io port: [0x4000-0x4fff]
[    0.228421] pci 0000:00:1c.4: bridge 32bit mmio: [0xfa000000-0xfbffffff]
[    0.228428] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xf4100000-0xf41fffff]
[    0.228476] pci 0000:15:00.0: reg 10 32bit mmio: [0xf4300000-0xf4300fff]
[    0.228503] pci 0000:15:00.0: supports D1 D2
[    0.228505] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.228572] pci 0000:15:00.0: PME# disabled
[    0.228680] pci 0000:15:00.1: reg 10 32bit mmio: [0xf4301000-0xf43017ff]
[    0.228748] pci 0000:15:00.1: supports D1 D2
[    0.228750] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.228817] pci 0000:15:00.1: PME# disabled
[    0.228925] pci 0000:15:00.2: reg 10 32bit mmio: [0xf4301800-0xf43018ff]
[    0.228994] pci 0000:15:00.2: supports D1 D2
[    0.228995] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229063] pci 0000:15:00.2: PME# disabled
[    0.229171] pci 0000:15:00.3: reg 10 32bit mmio: [0xf4301c00-0xf4301cff]
[    0.229239] pci 0000:15:00.3: supports D1 D2
[    0.229240] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229308] pci 0000:15:00.3: PME# disabled
[    0.229415] pci 0000:15:00.4: reg 10 32bit mmio: [0xf4302000-0xf43020ff]
[    0.229484] pci 0000:15:00.4: supports D1 D2
[    0.229486] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229554] pci 0000:15:00.4: PME# disabled
[    0.229661] pci 0000:15:00.5: reg 10 32bit mmio: [0xf4302400-0xf43024ff]
[    0.229729] pci 0000:15:00.5: supports D1 D2
[    0.229731] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229798] pci 0000:15:00.5: PME# disabled
[    0.229928] pci 0000:00:1e.0: transparent bridge
[    0.229993] pci 0000:00:1e.0: bridge io port: [0x5000-0x8fff]
[    0.229997] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4300000-0xf7ffffff]
[    0.230005] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf0000000-0xf3ffffff]
[    0.230058] pci_bus 0000:00: on NUMA node 0
[    0.230064] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.230224] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.230306] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.230389] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.230473] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.230557] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.230641] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.236643] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.237469] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.238293] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.239115] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.239939] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.240715] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.241538] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.242362] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.244061] ACPI: Power Resource [PUBS] (on)
[    0.244144] PCI: Using ACPI for IRQ routing
[    0.256083] NetLabel: Initializing
[    0.256144] NetLabel:  domain hash size = 128
[    0.256206] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.256278] NetLabel:  unlabeled traffic allowed by default
[    0.256367] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.256694] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.282557] pnp: PnP ACPI init
[    0.282624] ACPI: bus type pnp registered
[    0.346224] pnp: PnP ACPI: found 10 devices
[    0.346286] ACPI: ACPI bus type pnp unregistered
[    0.346354] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.346418] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.346482] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.346546] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.346610] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.346674] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.346738] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.346802] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.346866] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.346930] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.346995] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.347059] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.347124] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.347194] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.347263] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.347336] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.347400] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.347463] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.347527] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.347590] system 00:02: ioport range 0x1600-0x167f has been reserved
[    0.347654] system 00:02: ioport range 0x1680-0x169f has been reserved
[    0.347718] system 00:02: iomem range 0xe0000000-0xefffffff has been reserved
[    0.347782] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.347847] system 00:02: iomem range 0xfed10000-0xfed13fff has been reserved
[    0.347912] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.347976] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.348045] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    0.352801] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.352865] pci 0000:00:01.0:   IO window: 0x2000-0x2fff
[    0.358134] pci 0000:00:01.0:   MEM window: 0xcff00000-0xcfffffff
[    0.358198] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.358270] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.358333] pci 0000:00:1c.0:   IO window: disabled
[    0.358398] pci 0000:00:1c.0:   MEM window: disabled
[    0.358463] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.358530] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.358593] pci 0000:00:1c.1:   IO window: disabled
[    0.358658] pci 0000:00:1c.1:   MEM window: 0xf4200000-0xf42fffff
[    0.358724] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.358792] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.358856] pci 0000:00:1c.3:   IO window: 0x3000-0x3fff
[    0.358923] pci 0000:00:1c.3:   MEM window: 0xf8000000-0xf9ffffff
[    0.358988] pci 0000:00:1c.3:   PREFETCH window: 0x000000f4000000-0x000000f40fffff
[    0.359062] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
[    0.359126] pci 0000:00:1c.4:   IO window: 0x4000-0x4fff
[    0.359193] pci 0000:00:1c.4:   MEM window: 0xfa000000-0xfbffffff
[    0.359258] pci 0000:00:1c.4:   PREFETCH window: 0x000000f4100000-0x000000f41fffff
[    0.359335] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    0.359398] pci 0000:15:00.0:   IO window: 0x005000-0x0050ff
[    0.359464] pci 0000:15:00.0:   IO window: 0x005400-0x0054ff
[    0.359531] pci 0000:15:00.0:   PREFETCH window: 0xf0000000-0xf3ffffff
[    0.359598] pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff
[    0.359665] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
[    0.359729] pci 0000:00:1e.0:   IO window: 0x5000-0x8fff
[    0.359795] pci 0000:00:1e.0:   MEM window: 0xf4300000-0xf7ffffff
[    0.359860] pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f3ffffff
[    0.359940] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.360009] pci 0000:00:01.0: setting latency timer to 64
[    0.360020] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.360087] pci 0000:00:1c.0: setting latency timer to 64
[    0.360095] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.360162] pci 0000:00:1c.1: setting latency timer to 64
[    0.360170] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.360237] pci 0000:00:1c.3: setting latency timer to 64
[    0.360245] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.360312] pci 0000:00:1c.4: setting latency timer to 64
[    0.360318] pci 0000:00:1e.0: setting latency timer to 64
[    0.360328] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.360397] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.360398] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.360400] pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]
[    0.360402] pci_bus 0000:01: resource 1 mem: [0xcff00000-0xcfffffff]
[    0.360404] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xdfffffff]
[    0.360406] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.360407] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.360409] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    0.360411] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.360412] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.360414] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.360415] pci_bus 0000:03: resource 1 mem: [0xf4200000-0xf42fffff]
[    0.360417] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.360419] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.360420] pci_bus 0000:05: resource 0 io:  [0x3000-0x3fff]
[    0.360422] pci_bus 0000:05: resource 1 mem: [0xf8000000-0xf9ffffff]
[    0.360424] pci_bus 0000:05: resource 2 mem: [0xf4000000-0xf40fffff]
[    0.360426] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
[    0.360427] pci_bus 0000:0d: resource 0 io:  [0x4000-0x4fff]
[    0.360429] pci_bus 0000:0d: resource 1 mem: [0xfa000000-0xfbffffff]
[    0.360431] pci_bus 0000:0d: resource 2 mem: [0xf4100000-0xf41fffff]
[    0.360433] pci_bus 0000:0d: resource 3 mem: [0x0-0x0]
[    0.360434] pci_bus 0000:15: resource 0 io:  [0x5000-0x8fff]
[    0.360436] pci_bus 0000:15: resource 1 mem: [0xf4300000-0xf7ffffff]
[    0.360438] pci_bus 0000:15: resource 2 mem: [0xf0000000-0xf3ffffff]
[    0.360439] pci_bus 0000:15: resource 3 io:  [0x00-0xffff]
[    0.360441] pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.360443] pci_bus 0000:16: resource 0 io:  [0x5000-0x50ff]
[    0.360445] pci_bus 0000:16: resource 1 io:  [0x5400-0x54ff]
[    0.360447] pci_bus 0000:16: resource 2 mem: [0xf0000000-0xf3ffffff]
[    0.360448] pci_bus 0000:16: resource 3 mem: [0xc4000000-0xc7ffffff]
[    0.360471] NET: Registered protocol family 2
[    0.408051] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.408773] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.410069] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.410522] TCP: Hash tables configured (established 262144 bind 65536)
[    0.410586] TCP reno registered
[    0.420085] NET: Registered protocol family 1
[    0.420200] checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
[    0.421921] Freeing initrd memory: 877k freed
[    0.422201] Simple Boot Flag at 0x35 set to 0x1
[    0.422601] audit: initializing netlink socket (disabled)
[    0.422681] type=2000 audit(1238461930.420:1): initialized
[    0.423099] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.424445] VFS: Disk quotas dquot_6.5.2
[    0.424562] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.424717] msgmni has been set to 7759
[    0.425014] alg: No test for stdrng (krng)
[    0.425121] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.425190] io scheduler noop registered
[    0.425252] io scheduler anticipatory registered
[    0.425314] io scheduler deadline registered
[    0.425406] io scheduler cfq registered (default)
[    0.425635] pci 0000:01:00.0: Boot video device
[    0.425731] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.425772] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.425849] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.425918] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.426023] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.426092] pcieport-driver 0000:00:1c.1: irq 26 for MSI/MSI-X
[    0.426202] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.426271] pcieport-driver 0000:00:1c.3: irq 27 for MSI/MSI-X
[    0.426375] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.426444] pcieport-driver 0000:00:1c.4: irq 28 for MSI/MSI-X
[    0.437633] Linux agpgart interface v0.103
[    0.437697] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.438078] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.438246] 0000:00:03.3: ttyS0 at I/O 0x1828 (irq = 17) is a 16550A
[    0.438981] brd: module loaded
[    0.439082] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.448639] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.448705] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.448866] mice: PS/2 mouse device common for all mice
[    0.448981] rtc_cmos 00:07: RTC can wake from S4
[    0.449087] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.449185] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.449266] cpuidle: using governor ladder
[    0.449331] cpuidle: using governor menu
[    0.449665] TCP cubic registered
[    0.449730] NET: Registered protocol family 17
[    0.449903] registered taskstats version 1
[    0.450159] rtc_cmos 00:07: setting system clock to 2009-03-31 01:12:11 UTC (1238461931)
[    0.450348] RAMDISK: gzip image found at block 0
[    0.473389] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
[    0.478323] input: AT Translated Set 2 keyboard as /class/input/input0
[    0.487954] SCSI subsystem initialized
[    0.499902] libata version 3.00 loaded.
[    0.502595] ahci 0000:00:1f.2: version 3.0
[    0.502610] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.502722] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    0.502759] ahci: SSS flag set, parallel bus scan disabled
[    0.502844] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    0.502914] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    0.502987] ahci 0000:00:1f.2: setting latency timer to 64
[    0.503143] scsi0 : ahci
[    0.503289] scsi1 : ahci
[    0.503396] scsi2 : ahci
[    0.503499] scsi3 : ahci
[    0.504453] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 29
[    0.504524] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 29
[    0.504592] ata3: DUMMY
[    0.504652] ata4: DUMMY
[    0.507996] Driver 'sd' needs updating - please use bus_type methods
[    0.542558] Switched to high resolution mode on CPU 1
[    0.544010] Switched to high resolution mode on CPU 0
[    0.785016] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.785701] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    0.785704] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    0.785849] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    0.785852] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    0.786313] ata1.00: ATA-8: FUJITSU MHZ2160BJ G1, 0084001F, max UDMA/100
[    0.786378] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.787172] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    0.787174] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    0.787319] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    0.787322] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    0.787767] ata1.00: configured for UDMA/100
[    0.800891] ata1.00: configured for UDMA/100
[    0.800954] ata1: EH complete
[    0.801091] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHZ2160B 0084 PQ: 0 ANSI: 5
[    0.801332] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    0.801414] sd 0:0:0:0: [sda] Write Protect is off
[    0.801476] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.801497] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.801650]  sda: sda1 sda2 sda3 sda4
[    0.832144] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.120016] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.123460] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    1.124489] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    1.124491] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.125527] ata2.00: ATAPI: Optiarc  DVD RW AD-7910S, 1.D0, max UDMA/100
[    1.129484] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    1.130513] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    1.130516] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.131573] ata2.00: configured for UDMA/100
[    1.149550] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7910S  1.D0 PQ: 0 ANSI: 5
[    2.514874] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    2.515318] SGI XFS Quota Management subsystem
[    2.553316] XFS mounting filesystem sda3
[    3.224747] Starting XFS recovery on filesystem: sda3 (logdev: internal)
[    3.646666] Ending XFS recovery on filesystem: sda3 (logdev: internal)
[    3.646763] VFS: Mounted root (xfs filesystem) readonly on device 8:3.
[    3.646826] Trying to move old root to /initrd ... okay
[    3.647339] Freeing unused kernel memory: 424k freed
[    5.702245] input: Power Button (FF) as /class/input/input1
[    5.713018] ACPI: Power Button (FF) [PWRF]
[    5.713067] input: Lid Switch as /class/input/input2
[    5.715599] ACPI: Lid Switch [LID]
[    5.715644] input: Sleep Button (CM) as /class/input/input3
[    5.725859] ACPI: SSDT BFAD6C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    5.726424] ACPI: SSDT BFAD4020, 087A (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    5.729289] ACPI: Sleep Button (CM) [SLPB]
[    5.729522] Monitor-Mwait will be used to enter C-1 state
[    5.729527] Monitor-Mwait will be used to enter C-2 state
[    5.729531] Monitor-Mwait will be used to enter C-3 state
[    5.729585] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    5.729610] processor ACPI_CPU:00: registered as cooling_device0
[    5.729613] ACPI: Processor [CPU0] (supports 8 throttling states)
[    5.730221] ACPI: SSDT BFAD5CA0, 01CF (r1  PmRef    ApIst     3000 INTL 20050624)
[    5.730680] ACPI: SSDT BFAD5F20, 008D (r1  PmRef    ApCst     3000 INTL 20050624)
[    5.732067] Marking TSC unstable due to TSC halts in idle
[    5.732393] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    5.732412] processor ACPI_CPU:01: registered as cooling_device1
[    5.732417] ACPI: Processor [CPU1] (supports 8 throttling states)
[    5.750739] ACPI: Battery Slot [BAT0] (battery present)
[    5.755711] ACPI: AC Adapter [AC] (on-line)
[    5.785525] Non-volatile memory driver v1.3
[    5.848595] iTCO_vendor_support: vendor-support=0
[    5.850670] thermal LNXTHERM:01: registered as thermal_zone0
[    5.854665] ACPI: Thermal Zone [THM0] (53 C)
[    5.855765] thermal LNXTHERM:02: registered as thermal_zone1
[    5.857090] ACPI: Thermal Zone [THM1] (43 C)
[    5.869136] cfg80211: Calling CRDA to update world regulatory domain
[    5.873152] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    5.873243] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
[    5.873317] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.893583] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    5.893585] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    5.893620] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.893628] e1000e 0000:00:19.0: setting latency timer to 64
[    5.893729] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[    5.939330] Driver 'sr' needs updating - please use bus_type methods
[    5.948480] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.948483] Uniform CD-ROM driver Revision: 3.20
[    5.948551] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.960052] input: PC Speaker as /class/input/input4
[    5.962285] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.962318] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.982507] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:86:a2:19:06
[    5.982509] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.982536] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    6.001061] Clocksource tsc unstable (delta = -173190576 ns)
[    6.029910] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.131371] ricoh-mmc: Ricoh MMC Controller disabling driver
[    6.131373] ricoh-mmc: Copyright(c) Philip Langdale
[    6.131395] ricoh-mmc: Ricoh MMC controller found at 0000:15:00.3 [1180:0843] (rev 11)
[    6.131415] ricoh-mmc: Controller is now disabled.
[    6.188831] sdhci: Secure Digital Host Controller Interface driver
[    6.188833] sdhci: Copyright(c) Pierre Ossman
[    6.191672] pata_acpi 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.191698] pata_acpi 0000:00:03.2: setting latency timer to 64
[    6.191708] pata_acpi 0000:00:03.2: PCI INT C disabled
[    6.203655] acpi device:0a: registered as cooling_device2
[    6.203872] input: Video Bus as /class/input/input5
[    6.220299] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
[    6.220315] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.221352] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    6.222390] Registered led device: mmc0::
[    6.223418] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[    6.234513] usbcore: registered new interface driver usbfs
[    6.234541] usbcore: registered new interface driver hub
[    6.234560] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    6.238302] usbcore: registered new device driver usb
[    6.255661] ACPI: WMI: Mapper loaded
[    6.283894] Uniform Multi-Platform E-IDE driver
[    6.319039] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[    6.319042] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    6.319163] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.319199] iwlagn 0000:03:00.0: setting latency timer to 64
[    6.319273] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5350AGN REV=0x24
[    6.328726] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[    6.340614] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    6.340678] iwlagn 0000:03:00.0: irq 31 for MSI/MSI-X
[    6.340867] thinkpad_acpi: ThinkPad ACPI Extras v0.22
[    6.340869] thinkpad_acpi: http://ibm-acpi.sf.net/
[    6.340870] thinkpad_acpi: ThinkPad BIOS 7UET61WW (2.07 ), EC 7VHT12WW-1.01
[    6.340872] thinkpad_acpi: Lenovo ThinkPad T400, model 2764CTO
[    6.341526] thinkpad_acpi: radio switch found; radios are enabled
[    6.341635] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    6.341638] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    6.344931] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    6.349176] Registered led device: tpacpi::thinklight
[    6.349211] Registered led device: tpacpi::power
[    6.349226] Registered led device: tpacpi:orange:batt
[    6.349243] Registered led device: tpacpi:green:batt
[    6.349257] Registered led device: tpacpi::dock_active
[    6.349272] Registered led device: tpacpi::bay_active
[    6.349288] Registered led device: tpacpi::dock_batt
[    6.349303] Registered led device: tpacpi::unknown_led
[    6.349318] Registered led device: tpacpi::standby
[    6.351715] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[    6.352076] input: ThinkPad Extra Buttons as /class/input/input6
[    6.361195] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.361708] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    6.361718] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    6.361744] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.361748] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.361788] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.365727] ehci_hcd 0000:00:1a.7: debug port 1
[    6.365734] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.365750] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    6.371007] Monitor-Mwait will be used to enter C-3 state
[    6.380050] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.380072] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.380074] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.380076] usb usb1: Product: EHCI Host Controller
[    6.380078] usb usb1: Manufacturer: Linux 2.6.29 ehci_hcd
[    6.380079] usb usb1: SerialNumber: 0000:00:1a.7
[    6.380135] usb usb1: configuration #1 chosen from 1 choice
[    6.380162] hub 1-0:1.0: USB hub found
[    6.380169] hub 1-0:1.0: 6 ports detected
[    6.380923] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    6.380937] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    6.380965] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.380968] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.380992] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.384892] ehci_hcd 0000:00:1d.7: debug port 1
[    6.384897] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.384912] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    6.400118] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.400141] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.400144] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.400147] usb usb2: Product: EHCI Host Controller
[    6.400150] usb usb2: Manufacturer: Linux 2.6.29 ehci_hcd
[    6.400152] usb usb2: SerialNumber: 0000:00:1d.7
[    6.400228] usb usb2: configuration #1 chosen from 1 choice
[    6.400273] hub 2-0:1.0: USB hub found
[    6.400279] hub 2-0:1.0: 6 ports detected
[    6.436464] uhci_hcd: USB Universal Host Controller Interface driver
[    6.437195] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    6.437203] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.437212] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.437215] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.437241] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.437282] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    6.437321] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.437323] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.437325] usb usb3: Product: UHCI Host Controller
[    6.437327] usb usb3: Manufacturer: Linux 2.6.29 uhci_hcd
[    6.437328] usb usb3: SerialNumber: 0000:00:1a.0
[    6.437396] usb usb3: configuration #1 chosen from 1 choice
[    6.437422] hub 3-0:1.0: USB hub found
[    6.437429] hub 3-0:1.0: 2 ports detected
[    6.437531] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.437538] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.437541] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.437561] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.437595] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    6.437630] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.437632] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.437634] usb usb4: Product: UHCI Host Controller
[    6.437636] usb usb4: Manufacturer: Linux 2.6.29 uhci_hcd
[    6.437637] usb usb4: SerialNumber: 0000:00:1a.1
[    6.437682] usb usb4: configuration #1 chosen from 1 choice
[    6.437706] hub 4-0:1.0: USB hub found
[    6.437712] hub 4-0:1.0: 2 ports detected
[    6.438546] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    6.438554] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    6.438560] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.438564] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.438586] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.438621] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    6.438658] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.438660] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.438662] usb usb5: Product: UHCI Host Controller
[    6.438664] usb usb5: Manufacturer: Linux 2.6.29 uhci_hcd
[    6.438665] usb usb5: SerialNumber: 0000:00:1a.2
[    6.438714] usb usb5: configuration #1 chosen from 1 choice
[    6.438744] hub 5-0:1.0: USB hub found
[    6.438750] hub 5-0:1.0: 2 ports detected
[    6.439317] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    6.439322] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.439328] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.439331] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.439356] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.439382] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    6.439415] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.439417] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.439418] usb usb6: Product: UHCI Host Controller
[    6.439420] usb usb6: Manufacturer: Linux 2.6.29 uhci_hcd
[    6.439421] usb usb6: SerialNumber: 0000:00:1d.0
[    6.439466] usb usb6: configuration #1 chosen from 1 choice
[    6.439491] hub 6-0:1.0: USB hub found
[    6.439497] hub 6-0:1.0: 2 ports detected
[    6.439602] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.439609] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.439612] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.439631] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.439666] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    6.439700] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.439702] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.439704] usb usb7: Product: UHCI Host Controller
[    6.439705] usb usb7: Manufacturer: Linux 2.6.29 uhci_hcd
[    6.439707] usb usb7: SerialNumber: 0000:00:1d.1
[    6.439751] usb usb7: configuration #1 chosen from 1 choice
[    6.439777] hub 7-0:1.0: USB hub found
[    6.439783] hub 7-0:1.0: 2 ports detected
[    6.439891] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.439898] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.439901] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.439920] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.439948] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    6.439982] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    6.439984] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.439986] usb usb8: Product: UHCI Host Controller
[    6.439988] usb usb8: Manufacturer: Linux 2.6.29 uhci_hcd
[    6.439989] usb usb8: SerialNumber: 0000:00:1d.2
[    6.440035] usb usb8: configuration #1 chosen from 1 choice
[    6.440059] hub 8-0:1.0: USB hub found
[    6.440065] hub 8-0:1.0: 2 ports detected
[    6.451107] udev: renamed network interface wlan0 to eth1
[    6.456945] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    6.456949] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[    6.456953] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x5000 - 0x8fff
[    6.456956] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf4300000 - 0xf7ffffff
[    6.456959] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf3ffffff
[    6.457747] firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.536068] firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI version 1.10
[    6.674683] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.674718] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.820901] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000
[    6.820905] serio: Synaptics pass-through port at isa0060/serio1/input0
[    6.860076] usb 1-6: new high speed USB device using ehci_hcd and address 4
[    6.863539] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[    7.003831] usb 1-6: New USB device found, idVendor=17ef, idProduct=1004
[    7.003834] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    7.003836] usb 1-6: Product: Integrated Camera
[    7.003837] usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
[    7.003839] usb 1-6: SerialNumber: SN0001
[    7.003929] usb 1-6: configuration #1 chosen from 1 choice
[    7.037113] firewire_core: created device fw0: GUID 00061b032a347baa, S400
[    7.047622] input: HDA Intel Headphone as /class/input/input8
[    7.064121] input: HDA Intel Mic as /class/input/input9
[    7.080132] input: HDA Intel Mic as /class/input/input10
[    7.096128] input: HDA Intel Headphone as /class/input/input11
[    7.185214] Linux video capture interface: v2.00
[    7.224493] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:1004)
[    7.229652] input: Integrated Camera as /class/input/input12
[    7.245055] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    7.261103] usbcore: registered new interface driver uvcvideo
[    7.261106] USB Video Class driver (v0.1.0)
[    7.418350] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
[    7.418353] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.418355] usb 3-1: Product: Trackball
[    7.418357] usb 3-1: Manufacturer: Logitech
[    7.418471] usb 3-1: configuration #1 chosen from 1 choice
[    7.544631] usbcore: registered new interface driver hiddev
[    7.563623] input: Logitech Trackball as /class/input/input13
[    7.597123] generic-usb 0003:046D:C404.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1a.0-1/input0
[    7.597138] usbcore: registered new interface driver usbhid
[    7.597140] usbhid: v2.6:USB HID core driver
[    7.660071] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    7.826670] usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
[    7.826673] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.826675] usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    7.826677] usb 4-2: Manufacturer: Lenovo Computer Corp
[    7.826767] usb 4-2: configuration #1 chosen from 1 choice
[    7.860051] Bluetooth: Core ver 2.15
[    7.860265] NET: Registered protocol family 31
[    7.860266] Bluetooth: HCI device and connection manager initialized
[    7.860269] Bluetooth: HCI socket layer initialized
[    7.877070] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    7.877157] usbcore: registered new interface driver btusb
[    8.229145] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   12.550673] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   12.801441] input: TPPS/2 IBM TrackPoint as /class/input/input14
[   15.105052] Intel AES-NI instructions are not detected.
[   15.837764] [drm] Initialized drm 1.1.0 20060810
[   16.309470] Filesystem "dm-0": Disabling barriers, trial barrier write failed
[   16.313439] XFS mounting filesystem dm-0
[   16.670612] Starting XFS recovery on filesystem: dm-0 (logdev: internal)
[   17.741776] Ending XFS recovery on filesystem: dm-0 (logdev: internal)
[   19.636486] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   19.692163] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   25.869120] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.ucode
[   25.913890] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
[   26.075531] Registered led device: iwl-phy0::radio
[   26.075588] Registered led device: iwl-phy0::assoc
[   26.075639] Registered led device: iwl-phy0::RX
[   26.075694] Registered led device: iwl-phy0::TX
[   27.212720] eth1: authenticate with AP 00:11:22:33:44:57
[   27.214791] eth1: authenticated
[   27.214796] eth1: associate with AP 00:11:22:33:44:57
[   27.217395] eth1: RX AssocResp from 00:11:22:33:44:57 (capab=0x411 status=0 aid=1)
[   27.217402] eth1: associated
[   27.223642] eth1: authenticate with AP 00:11:22:33:44:57
[   27.225696] eth1: authenticated
[   27.225701] eth1: associate with AP 00:11:22:33:44:57
[   27.228356] eth1: RX ReassocResp from 00:11:22:33:44:57 (capab=0x411 status=0 aid=1)
[   27.228362] eth1: associated
[   34.550267] NET: Registered protocol family 10
[   34.551600] lo: Disabled Privacy Extensions
[   34.552968] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.904151] Bluetooth: L2CAP ver 2.13
[   35.904157] Bluetooth: L2CAP socket layer initialized
[   35.944696] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   35.976965] Bluetooth: SCO (Voice Link) ver 0.6
[   35.976971] Bluetooth: SCO socket layer initialized
[   36.003042] Bluetooth: RFCOMM socket layer initialized
[   36.003068] Bluetooth: RFCOMM TTY layer initialized
[   36.003072] Bluetooth: RFCOMM ver 1.11
[   36.046595] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   36.046601] Bluetooth: BNEP filters: protocol multicast
[   36.089638] Bridge firewalling registered
[   45.052101] eth1: no IPv6 routers present
[   46.241232] tun: Universal TUN/TAP device driver, 1.6
[   46.241238] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   46.430769] ip_tables: (C) 2000-2006 Netfilter Core Team
[   46.505171] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   46.506875] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   46.506882] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   46.506888] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   92.868603] pci 0000:01:00.0: power state changed by ACPI to D0
[   92.868613] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   92.877078]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   92.877081]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   92.877084]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   92.877087]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   92.877117]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   92.877120]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   92.877122]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   92.877125]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   92.877378]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   92.877381]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   92.877384]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   92.877386]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   92.878741] X:5776 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[   92.878744] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[   92.894594] pci 0000:01:00.0: setting latency timer to 64
[   92.894899] [drm] Initialized radeon 1.29.0 20080528 for 0000:01:00.0 on minor 0
[   92.895100]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   92.895103]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   92.895105]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   92.895107]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   92.895109]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   92.895112]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   92.895114]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   92.895116]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   92.896690]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[   93.079626]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.079632]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.079637]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.079641]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.113081]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.113087]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.113091]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.113095]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.780184]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.780193]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.780200]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.780206]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.780215]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.780221]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.780228]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.780235]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.785313]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[   93.789987]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.789997]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.790003]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.790010]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.790018]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.790024]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.790031]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.790037]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.795049]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[   93.799695]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.799704]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.799710]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.799717]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.799725]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   93.799732]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   93.799739]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   93.799745]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   93.889644] [drm] Setting GART location based on new memory map
[   93.904791] [drm] Loading RV620 CP Microcode
[   93.905098] [drm] Loading RV620 PFP Microcode
[   93.920025] [drm] Resetting GPU
[   93.920082] [drm] writeback test succeeded in 1 usecs
[   94.496946] X:5776 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[   94.496949] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[   95.039974] X:5776 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[   95.039983] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[   95.297046] X:5776 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[   95.297055] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[   95.522813] X:5776 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[   95.522816] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  117.593651] [drm] Resetting GPU
[  118.209583]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[  118.209594]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[  118.209603]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[  118.209611]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[  118.209621]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[  118.229744] X:5776 freeing invalid memtype cfff0000-d0000000
[  118.229762] X:5776 freeing invalid memtype cfff0000-d0000000
[  118.276236]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[  118.276238]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[  118.276240]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[  118.276242]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[  118.276244]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[  118.276246]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[  118.302211]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[  118.302216]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[  118.302218]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[  118.302221]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[  118.393103] mtrr: base(0xd0000000) is not aligned on a size(0xfff0000) boundary
[  118.415831] [drm] Setting GART location based on new memory map
[  118.430972] [drm] Loading RV620 CP Microcode
[  118.431224] [drm] Loading RV620 PFP Microcode
[  118.446151] [drm] Resetting GPU
[  118.446214] [drm] writeback test succeeded in 1 usecs
[  119.123433]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[  119.123450]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[  119.123459]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[  119.123468]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[  119.217085] X:5776 freeing invalid memtype cfff0000-d0000000
[  119.217089] mtrr: MTRR 4 not used
[  119.217100] X:5776 freeing invalid memtype cfff0000-d0000000
[  167.916804] thinkpad_acpi: EC reports that Thermal Table has changed
[  417.710749]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.710761]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.710770]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.710779]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.710857]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.710866]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.710875]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.710884]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.711583]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.711593]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.711602]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.711611]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.712216]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.712224]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.712231]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.712238]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.712245]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.712252]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.712259]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.712266]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.716909]   get_mtrr: cpu1 reg04 base=00000d0000 size=0000010000 write-combining
[  417.721344]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.721352]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.721359]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.721365]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.721373]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.721380]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.721386]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.721393]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.726108]   get_mtrr: cpu1 reg04 base=00000d0000 size=0000010000 write-combining
[  417.889054]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.889065]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.889074]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.889116]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  417.958051]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  417.958062]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  417.958071]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  417.958080]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  418.649649]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  418.649658]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  418.649665]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  418.649672]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  418.649680]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  418.649687]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  418.649693]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  418.649700]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  418.654130]   get_mtrr: cpu1 reg04 base=00000d0000 size=0000010000 write-combining
[  418.658621]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  418.658630]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  418.658636]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  418.658643]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  418.658651]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  418.658657]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  418.658664]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  418.658670]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  418.663049]   get_mtrr: cpu1 reg04 base=00000d0000 size=0000010000 write-combining
[  418.667491]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  418.667500]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  418.667508]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  418.667515]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  418.667524]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  418.667531]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  418.667538]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  418.667546]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  418.737509] [drm] Setting GART location based on new memory map
[  418.753162] [drm] Loading RV620 CP Microcode
[  418.753776] [drm] Loading RV620 PFP Microcode
[  418.768764] [drm] Resetting GPU
[  418.768826] [drm] writeback test succeeded in 1 usecs
[  419.187657] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  419.187670] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  419.553914] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  419.553923] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  419.813592] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  419.813601] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  420.100102] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
[  420.100111] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
[  664.836771]   get_mtrr: cpu1 reg00 base=000013c000 size=0000004000 uncachable
[  664.836784]   get_mtrr: cpu1 reg01 base=0000000000 size=0000080000 write-back
[  664.836794]   get_mtrr: cpu1 reg02 base=0000080000 size=0000040000 write-back
[  664.836803]   get_mtrr: cpu1 reg03 base=0000100000 size=0000040000 write-back
[  664.836812]   get_mtrr: cpu1 reg04 base=00000d0000 size=0000010000 write-combining

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

