Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZBRR65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZBRR65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZBRR6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:58:49 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:13912
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751732AbZBRR6s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:58:48 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 12:58:47 EST
X-BigFish: VPS-7(zz936eQzzzzz32i6bh6di66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KF9VW9-02-F9H-01
Date: Wed, 18 Feb 2009 18:42:43 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Mark Hounschell <markh@compro.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090218174243.GD13304@aftab>
References: <498B1FA9.2050203@cfl.rr.com> <20090206135248.GB23459@aftab> <498C44FA.1010106@compro.net> <498C7980.2060309@compro.net> <498CB798.7050308@cfl.rr.com> <20090209141841.GA31643@aftab> <49904BED.7090208@cfl.rr.com> <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <499C3DED.1090807@cfl.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 Feb 2009 17:42:42.0721 (UTC) FILETIME=[4D065910:01C991F0]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> BIOS EBDA/lowmem at: 0009f000/0009f000
> Initializing cgroup subsys cpuset
> Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
> (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #4 SMP PREEMPT Wed Feb9
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000bffe0000 (usable)
>  BIOS-e820: 00000000bffe0000 - 00000000bffe3000 (ACPI NVS)
>  BIOS-e820: 00000000bffe3000 - 00000000bfff0000 (ACPI data)
>  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
> DMI 2.5 present.
> Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
> last_pfn = 0xbffe0 max_arch_pfn = 0x100000
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> RAMDISK: 374d0000 - 37feff67
> Allocated new RAMDISK: 004a7000 - 00fc6f67
> Move RAMDISK from 00000000374d0000 - 0000000037feff66 to 004a7000 - 00fc6f66
> ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
> ACPI: XSDT BFFE3080, 004C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
> ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
> FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
> ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
> ACPI: FACS BFFE0000, 0040
> ACPI: SSDT BFFE8E40, 088C (r1 PTLTD  POWERNOW        1  LTP        1)
> ACPI: HPET BFFE9700, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
> ACPI: MCFG BFFE9740, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
> ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
> 2183MB HIGHMEM available.
> 887MB LOWMEM available.
>   mapped low ram: 0 - 377fe000
>   low ram: 00000000 - 377fe000
>   bootmap 00012000 - 00018f00
> (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
>   #3 [0000100000 - 00004a3c54]    TEXT DATA BSS ==> [0000100000 - 00004a3c54]
>   #4 [00004a4000 - 00004a7000]    INIT_PG_TABLE ==> [00004a4000 - 00004a7000]
>   #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
>   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
>   #7 [00004a7000 - 0000fc6f67]      NEW RAMDISK ==> [00004a7000 - 0000fc6f67]
>   #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
> Scan SMP from c0000000 for 1024 bytes.
> Scan SMP from c009fc00 for 1024 bytes.
> Scan SMP from c00f0000 for 65536 bytes.
> found SMP MP-table at [c00f3f00] 000f3f00
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   0x00001000 -> 0x000377fe
>   HighMem  0x000377fe -> 0x000bffe0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x000bffe0
> ACPI: PM-Timer IO Port: 0x4008
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> Using ACPI (MADT) for SMP configuration information
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> mapped APIC to ffffb000 (fee00000)
> mapped IOAPIC to ffffa000 (fec00000)
> Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
> PERCPU: Allocating 36864 bytes of per cpu data
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780143
> Kernel command line: root=/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5
> hwprobe=-modules.pata apm=off selinux=0 noresume splash=silent apic=debug console=g
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> Preemptible RCU implementation.
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Fast TSC calibration using PIT
> Detected 3000.297 MHz processor.
> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 3103456k/3145600k available (1835k kernel code, 40784k reserved, 1099k
> data, 276k init, 2236296k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
>     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
>       .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
>       .data : 0xc02caf97 - 0xc03ddc4c   (1099 kB)
>       .text : 0xc0100000 - 0xc02caf97   (1835 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> HPET0 prog. values: now 20642, delta 14318, cfg: 0x15c,
> HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> Calibrating delay loop (skipped), value calculated using timer frequency..
> 6000.59 BogoMIPS (lpj=3000297)
> Security Framework initialized
> Mount-cache hash table entries: 512
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> using C1E aware idle routine
> Checking 'hlt' instruction...

now if you retry the same thing, does the machine hang with the exact
same output/at the exact same place in the boot process or it differs
each time?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

