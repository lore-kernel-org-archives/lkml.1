Return-Path: <linux-kernel-owner+w=401wt.eu-S1946388AbXBCH6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946388AbXBCH6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 02:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946389AbXBCH6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 02:58:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:35698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946388AbXBCH6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 02:58:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,275,1167638400"; 
   d="scan'208"; a="195336991:sNHT25322465"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.20-rc6-mm3
Date: Sat, 3 Feb 2007 10:57:55 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC7CC8D8@mssmsx411>
In-Reply-To: <45C439F9.8090709@fr.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.20-rc6-mm3
Thread-Index: AcdHZSNS04bg44wnTSSFv/wgY+XooQAA3rMA
From: "Starikovskiy, Alexey Y" <alexey.y.starikovskiy@intel.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Cc: "Andrew Morton" <akpm@osdl.org>, <linux-kernel@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       "keith mannthey" <kmannth@us.ibm.com>
X-OriginalArrivalTime: 03 Feb 2007 07:58:01.0209 (UTC) FILETIME=[06A6EE90:01C74769]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This warning should probably be disabled, to not confuse users... Spec
says that some registers are optional, and ACPICA used to keep silence
then it encountered one, but now it produces this meaningless warning...
Ignore it...

Regards,
	Alex.

>-----Original Message-----
>From: Cedric Le Goater [mailto:clg@fr.ibm.com]
>Sent: Saturday, February 03, 2007 10:30 AM
>To: Cedric Le Goater
>Cc: Starikovskiy, Alexey Y; Andrew Morton;
linux-kernel@vger.kernel.org;
>Moore, Robert; keith mannthey
>Subject: Re: 2.6.20-rc6-mm3
>
>Cedric Le Goater wrote:
>> Starikovskiy, Alexey Y wrote:
>>>> so it probably means that drivers/acpi/tables/tbxfroot.c is
>>>> obsolete ?
>>> Yes.
>>>>> Could you please try it?
>>>> sure, I'll cancel the current boot test in which I was using
>>>> acpi_find_root_pointer() in tbxfroot.c and restart one with your
>>>> new patch. I should have the result today.
>>> How long does it take to boot this thing?
>>
>> well, not that long, but i don't have access directly to this
>> machine, only through a test batch manager ...
>
>dmesg looks fine. However, there is a :
>
>ACPI Warning (tbfadt-0415): Optional field "Gpe1Block" has zero address
or
>length: 0000000000000000/4 [20070126]
>
>but I don't know how to interpret this ? Any Idea ?
>
>thanks,
>
>
>C.
>
>
>Linux version 2.6.20-rc6-mm3-lxc2-autokern1 (root@fpos1) (gcc version
4.0.3
>(Ubuntu 4.0.3-1ubuntu5)) #1 SMP Fri Feb 2 20:38:46 UTC 2007
>BIOS-provided physical RAM map:
>sanitize start
>sanitize end
>copy_e820_map() start: 0000000000000000 size: 000000000009dc00 end:
>000000000009dc00 type: 1
>copy_e820_map() type is E820_RAM
>copy_e820_map() start: 000000000009dc00 size: 0000000000002400 end:
>00000000000a0000 type: 2
>copy_e820_map() start: 00000000000e0000 size: 0000000000020000 end:
>0000000000100000 type: 2
>copy_e820_map() start: 0000000000100000 size: 00000000dfea25c0 end:
>00000000dffa25c0 type: 1
>copy_e820_map() type is E820_RAM
>copy_e820_map() start: 00000000dffa25c0 size: 0000000000009c80 end:
>00000000dffac240 type: 3
>copy_e820_map() start: 00000000dffac240 size: 0000000000053dc0 end:
>00000000e0000000 type: 2
>copy_e820_map() start: 00000000fec00000 size: 0000000001400000 end:
>0000000100000000 type: 2
>copy_e820_map() start: 0000000100000000 size: 0000000120000000 end:
>0000000220000000 type: 1
>copy_e820_map() type is E820_RAM
> BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
> BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 00000000dffa25c0 (usable)
> BIOS-e820: 00000000dffa25c0 - 00000000dffac240 (ACPI data)
> BIOS-e820: 00000000dffac240 - 00000000e0000000 (reserved)
> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
>Node: 0, start_pfn: 0, end_pfn: 157
>Node: 0, start_pfn: 256, end_pfn: 917410
>Node: 0, start_pfn: 1048576, end_pfn: 2228224
>get_memcfg_from_srat: assigning address to rsdp
>RSD PTR  v0 [IBM   ]
>Begin SRAT table scan....
>CPU 0x00 in proximity domain 0x00
>CPU 0x02 in proximity domain 0x00
>CPU 0x10 in proximity domain 0x00
>CPU 0x12 in proximity domain 0x00
>CPU 0x01 in proximity domain 0x00
>CPU 0x03 in proximity domain 0x00
>CPU 0x11 in proximity domain 0x00
>CPU 0x13 in proximity domain 0x00
>Memory range 0x0 to 0xE0000 (type 0x1) in proximity domain 0x00 enabled
>Memory range 0x100000 to 0x220000 (type 0x1) in proximity domain 0x00
>enabled
>pxm bitmap: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00
>00 00 00 00 00 00 00 00 00 00 00
>Number of logical nodes in system = 1
>Number of memory chunks in system = 2
>chunk 0 nid 0 start_pfn 00000000 end_pfn 000e0000
>chunk 1 nid 0 start_pfn 00100000 end_pfn 00220000
>Node: 0, start_pfn: 0, end_pfn: 2228224
>Reserving 17920 pages of KVA for lmem_map of node 0
>Shrinking node 0 from 2228224 pages to 2210304 pages
>Reserving total of 17920 pages for numa KVA remap
>kva_start_pfn ~ 211456 find_max_low_pfn() ~ 229376
>max_pfn = 2228224
>7808MB HIGHMEM available.
>896MB LOWMEM available.
>min_low_pfn = 1156, max_low_pfn = 229376, highstart_pfn = 229376
>Low memory ends at vaddr f8000000
>node 0 will remap to vaddr f3a00000 - fc600000
>High memory starts at vaddr f8000000
>found SMP MP-table at 0009dd40
>Zone PFN ranges:
>  DMA             0 ->     4096
>  Normal       4096 ->   229376
>  HighMem    229376 ->  2228224
>early_node_map[2] active PFN ranges
>    0:        0 ->   917504
>    0:  1048576 ->  2210304
>DMI 2.3 present.
>Using APIC driver default
>IBM eserver xSeries 440 detected: force use of acpi=ht
>ACPI: RSDP @ 0x000fde20/0x0014 (v000 IBM   )
>ACPI: RSDT @ 0xdffac1c0/0x0034 (v001 IBM    SERVIGIL 0x00001000 IBM
>0x45444F43)
>ACPI: FACP @ 0xdffac140/0x0074 (v001 IBM    SERVIGIL 0x00001000 IBM
>0x45444F43)
>ACPI Warning (tbfadt-0415): Optional field "Gpe1Block" has zero address
or
>length: 0000000000000000/4 [20070126]
>ACPI: DSDT @ 0xdffa25c0/0x4436 (v001 IBM    SERVIGIL 0x00001000 INTL
>0x02002025)
>ACPI: FACS @ 0xdffabf00/0x0040
>ACPI: APIC @ 0xdffac040/0x00D2 (v001 IBM    SERVIGIL 0x00001000 IBM
>0x45444F43)
>ACPI: SRAT @ 0xdffabf40/0x0100 (v001 IBM    SERVIGIL 0x00001000 IBM
>0x45444F43)
>ACPI: SSDT @ 0xdffa6a00/0x5467 (v001 IBM    VIGSSDT0 0x00001000 INTL
>0x02002025)
>ACPI: PM-Timer IO Port: 0x508
>Switched to APIC driver `summit'.
>ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>Processor #0 15:1 APIC version 20
>ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
>Processor #2 15:1 APIC version 20
>ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
>Processor #16 15:1 APIC version 20
>ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
>Processor #18 15:1 APIC version 20
>ACPI: LAPIC (acpi_id[0x80] lapic_id[0x01] enabled)
>Processor #1 15:1 APIC version 20
>ACPI: LAPIC (acpi_id[0x81] lapic_id[0x03] enabled)
>Processor #3 15:1 APIC version 20
>ACPI: LAPIC (acpi_id[0x84] lapic_id[0x11] enabled)
>Processor #17 15:1 APIC version 20
>ACPI: LAPIC (acpi_id[0x85] lapic_id[0x13] enabled)
>Processor #19 15:1 APIC version 20
>ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
>ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
>ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
>ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
>ACPI: LAPIC_NMI (acpi_id[0x80] dfl dfl lint[0x1])
>ACPI: LAPIC_NMI (acpi_id[0x81] dfl dfl lint[0x1])
>ACPI: LAPIC_NMI (acpi_id[0x84] dfl dfl lint[0x1])
>ACPI: LAPIC_NMI (acpi_id[0x85] dfl dfl lint[0x1])
>Using ACPI for processor (LAPIC) configuration information
>Intel MultiProcessor Specification v1.4
>    Virtual Wire compatibility mode.
>OEM ID: IBM ENSW Product ID: VIGIL SMP    <6>Switched to APIC driver
>`summit'.
>APIC at: 0xFEE00000
>I/O APIC #14 Version 17 at 0xFEC00000.
>I/O APIC #13 Version 17 at 0xFEC01000.
>Enabling APIC mode:  Summit.  Using 2 I/O APICs
>Processors: 8
>Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
>Detected 1397.332 MHz processor.
>Built 1 zonelists.  Total pages: 2061964
>Kernel command line: console=tty0 console=ttyS0,57600 ro
autobench_args:
>root=/dev/sda2 ABAT:1170448788
>Enabling fast FPU save and restore... done.
>Enabling unmasked SIMD FPU exception support... done.
>Initializing CPU#0
>PID hash table entries: 4096 (order: 12, 16384 bytes)
>Console: colour VGA+ 80x25
>------------------------
>| Locking API testsuite:
>-----------------------------------------------------------------------
----
>-
>                                 | spin |wlock |rlock |mutex | wsem |
rsem
>|
>
------------------------------------------------------------------------
-
>-
>                     A-A deadlock:failed|failed|  ok
>|failed|failed|failed|
>                 A-B-B-A deadlock:failed|failed|  ok
>|failed|failed|failed|
>             A-B-B-C-C-A deadlock:failed|failed|  ok
>|failed|failed|failed|
>             A-B-C-A-B-C deadlock:failed|failed|  ok
>|failed|failed|failed|
>         A-B-B-C-C-D-D-A deadlock:failed|failed|  ok
>|failed|failed|failed|
>         A-B-C-D-B-D-D-A deadlock:failed|failed|  ok
>|failed|failed|failed|
>         A-B-C-D-B-C-D-A deadlock:failed|failed|  ok
>|failed|failed|failed|
>                    double unlock:failed|failed|failed|  ok
>|failed|failed|
>                  initialize
>held:failed|failed|failed|failed|failed|failed|
>                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |
ok
>|
>
------------------------------------------------------------------------
-
>-
>              recursive read-lock:             |  ok  |
>|failed|
>           recursive read-lock #2:             |  ok  |
>|failed|
>            mixed read-write-lock:             |failed|
>|failed|
>            mixed write-read-lock:             |failed|
>|failed|
>
------------------------------------------------------------------------
-
>-
>     hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
>     soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
>     hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
>     soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
>       sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
>       sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
>         hard-safe-A + irqs-on/12:failed|failed|  ok  |
>         soft-safe-A + irqs-on/12:failed|failed|  ok  |
>         hard-safe-A + irqs-on/21:failed|failed|  ok  |
>         soft-safe-A + irqs-on/21:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
>    hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
>    soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
>      hard-irq lock-inversion/123:failed|failed|  ok  |
>      soft-irq lock-inversion/123:failed|failed|  ok  |
>      hard-irq lock-inversion/132:failed|failed|  ok  |
>      soft-irq lock-inversion/132:failed|failed|  ok  |
>      hard-irq lock-inversion/213:failed|failed|  ok  |
>      soft-irq lock-inversion/213:failed|failed|  ok  |
>      hard-irq lock-inversion/231:failed|failed|  ok  |
>      soft-irq lock-inversion/231:failed|failed|  ok  |
>      hard-irq lock-inversion/312:failed|failed|  ok  |
>      soft-irq lock-inversion/312:failed|failed|  ok  |
>      hard-irq lock-inversion/321:failed|failed|  ok  |
>      soft-irq lock-inversion/321:failed|failed|  ok  |
>      hard-irq read-recursion/123:  ok  |
>      soft-irq read-recursion/123:  ok  |
>      hard-irq read-recursion/132:  ok  |
>      soft-irq read-recursion/132:  ok  |
>      hard-irq read-recursion/213:  ok  |
>      soft-irq read-recursion/213:  ok  |
>      hard-irq read-recursion/231:  ok  |
>      soft-irq read-recursion/231:  ok  |
>      hard-irq read-recursion/312:  ok  |
>      soft-irq read-recursion/312:  ok  |
>      hard-irq read-recursion/321:  ok  |
>      soft-irq read-recursion/321:  ok  |
>--------------------------------------------------------
>144 out of 218 testcases failed, as expected. |
>----------------------------------------------------
>Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>Initializing HighMem for node 0 (00038000:0021ba00)
>Memory: 8239724k/8912896k available (2098k kernel code, 76432k
reserved,
>968k data, 228k init, 7399048k highmem)
>virtual kernel memory layout:
>    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
>    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
>    vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
>    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>      .init : 0xc0406000 - 0xc043f000   ( 228 kB)
>      .data : 0xc030cb21 - 0xc03fee28   ( 968 kB)
>      .text : 0xc0100000 - 0xc030cb21   (2098 kB)
>Checking if this processor honours the WP bit even in supervisor
mode...
>Ok.
>Calibrating delay using timer specific routine.. 2800.13 BogoMIPS
>(lpj=5600271)
>Mount-cache hash table entries: 512
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 0
>Compat vDSO mapped to ffffe000.
>Checking 'hlt' instruction... OK.
>Freeing SMP alternatives: 15k freed
>CPU0: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Leaving ESR disabled.
>Mapping cpu 0 to node 0
>Booting processor 1/2 eip 2000
>Initializing CPU#1
>Leaving ESR disabled.
>Mapping cpu 1 to node 0
>Calibrating delay using timer specific routine.. 2794.79 BogoMIPS
>(lpj=5589582)
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 1
>CPU1: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Booting processor 2/16 eip 2000
>Initializing CPU#2
>Leaving ESR disabled.
>Mapping cpu 2 to node 0
>Calibrating delay using timer specific routine.. 2794.70 BogoMIPS
>(lpj=5589416)
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 8
>CPU2: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Booting processor 3/18 eip 2000
>Initializing CPU#3
>Leaving ESR disabled.
>Mapping cpu 3 to node 0
>Calibrating delay using timer specific routine.. 2794.72 BogoMIPS
>(lpj=5589444)
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 9
>CPU3: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Booting processor 4/1 eip 2000
>Initializing CPU#4
>Leaving ESR disabled.
>Mapping cpu 4 to node 0
>Calibrating delay using timer specific routine.. 2794.60 BogoMIPS
>(lpj=5589208)
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 0
>CPU4: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Booting processor 5/3 eip 2000
>Initializing CPU#5
>Leaving ESR disabled.
>Mapping cpu 5 to node 0
>Calibrating delay using timer specific routine.. 2794.68 BogoMIPS
>(lpj=5589369)
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 1
>CPU5: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Booting processor 6/17 eip 2000
>Initializing CPU#6
>Leaving ESR disabled.
>Mapping cpu 6 to node 0
>Calibrating delay using timer specific routine.. 2794.59 BogoMIPS
>(lpj=5589194)
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 8
>CPU6: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Booting processor 7/19 eip 2000
>Initializing CPU#7
>Leaving ESR disabled.
>Mapping cpu 7 to node 0
>Calibrating delay using timer specific routine.. 2794.56 BogoMIPS
>(lpj=5589132)
>CPU: Trace cache: 12K uops, L1 D cache: 8K
>CPU: L2 cache: 256K
>CPU: L3 cache: 512K
>CPU: Physical Processor ID: 9
>CPU7: Intel(R) Xeon(TM) CPU 1.40GHz stepping 01
>Total of 8 processors activated (22362.80 BogoMIPS).
>ENABLING IO-APIC IRQs
>..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
>Brought up 8 CPUs
>migration_cost=60,306
>NET: Registered protocol family 16
>ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread C1139AA0 could
not
>acquire Mutex [1] [20070126]
>No dock devices found.
>PCI: PCI BIOS revision 2.10 entry at 0xfd5bd, last bus=11
>PCI: Using configuration type 1
>Setting up standard PCI resources
>ACPI: Interpreter disabled.
>SCSI subsystem initialized
>PCI: Probing PCI hardware
>PCI quirk: region 0440-044f claimed by vt82c686 SMB
>PCI: Discovered peer bus 01
>PCI: Discovered peer bus 02
>PCI: Discovered peer bus 05
>PCI: Discovered peer bus 07
>PCI: Discovered peer bus 09
>PCI->APIC IRQ transform: 0000:00:03.0[A] -> IRQ 39
>PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 16
>PCI->APIC IRQ transform: 0000:00:05.2[D] -> IRQ 47
>PCI->APIC IRQ transform: 0000:00:05.3[D] -> IRQ 47
>PCI->APIC IRQ transform: 0000:01:03.0[A] -> IRQ 40
>PCI->APIC IRQ transform: 0000:01:03.1[B] -> IRQ 41
>PCI->APIC IRQ transform: 0000:01:04.0[A] -> IRQ 42
>NET: Registered protocol family 2
>IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
>TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
>TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
>TCP: Hash tables configured (established 131072 bind 65536)
>TCP reno registered
>IBM machine detected. Enabling interrupts during APM calls.
>apm: BIOS not found.
>highmem bounce pool size: 64 pages
>Total HugeTLB memory allocated, 0
>Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
>io scheduler noop registered
>io scheduler anticipatory registered (default)
>io scheduler deadline registered
>io scheduler cfq registered
>PCI: Enabling Via external APIC routing
>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing
disabled
>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>loop: loaded (max 8 devices)
>Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
>Copyright (c) 1999-2006 Intel Corporation.
>pcnet32.c:v1.33 27.Jun.2006 tsbogend@alpha.franken.de
>tg3.c:v3.72 (January 8, 2007)
>eth0: Tigon3 [partno(BCM95700A6) rev 7102 PHY(5401)] (PCI:66MHz:64-bit)
>10/100/1000Base-T Ethernet 00:02:55:dc:36:33
>eth0: RXcsums[1] LinkChgREG[1] MIirq[1] ASF[0] Split[0] WireSpeed[0]
>TSOcap[0]
>eth0: dma_rwctrl[76ff000f] dma_mask[64-bit]
>scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>        <Adaptec aic7899 Ultra160 SCSI adapter>
>        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
>
>scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>        <Adaptec aic7899 Ultra160 SCSI adapter>
>        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
>
>scsi 1:0:9:0: Processor         IBM      GNHv1 S2         0    PQ: 0
ANSI:
>2
> target1:0:9: Beginning Domain Validation
> target1:0:9: Ending Domain Validation
>scsi 1:0:12:0: Direct-Access     IBM-ESXS ST336607LC    F  B25J PQ: 0
ANSI:
>3
>scsi1:A:12:0: Tagged Queuing enabled.  Depth 253
> target1:0:12: Beginning Domain Validation
> target1:0:12: wide asynchronous
> target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
> target1:0:12: Ending Domain Validation
>scsi 1:0:13:0: Direct-Access     IBM-ESXS DTN036C1UCDY10F  S29C PQ: 0
ANSI:
>3
>scsi1:A:13:0: Tagged Queuing enabled.  Depth 253
> target1:0:13: Beginning Domain Validation
> target1:0:13: wide asynchronous
> target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
> target1:0:13: Ending Domain Validation
>st: Version 20061107, fixed bufsize 32768, s/g segs 256
>SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
>sda: Write Protect is off
>SCSI device sda: write cache: disabled, read cache: enabled, supports
DPO
>and FUA
>SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
>sda: Write Protect is off
>SCSI device sda: write cache: disabled, read cache: enabled, supports
DPO
>and FUA
> sda: sda1 sda2 sda3
>sd 1:0:12:0: Attached scsi disk sda
>SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
>sdb: Write Protect is off
>SCSI device sdb: write cache: disabled, read cache: enabled, doesn't
>support DPO or FUA
>SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
>sdb: Write Protect is off
>SCSI device sdb: write cache: disabled, read cache: enabled, doesn't
>support DPO or FUA
> sdb: sdb1 sdb2 sdb3 sdb4
>sd 1:0:13:0: Attached scsi disk sdb
>scsi 1:0:9:0: Attached scsi generic sg0 type 3
>sd 1:0:12:0: Attached scsi generic sg1 type 0
>sd 1:0:13:0: Attached scsi generic sg2 type 0
>serio: i8042 KBD port at 0x60,0x64 irq 1
>serio: i8042 AUX port at 0x60,0x64 irq 12
>mice: PS/2 mouse device common for all mice
>input: AT Translated Set 2 keyboard as /class/input/input0
>Summit chipset: Starting Cyclone Counter.
>TCP cubic registered
>NET: Registered protocol family 1
>NET: Registered protocol family 17
>Starting balanced_irq
>Using IPI Shortcut mode
>Time: cyclone clocksource has been installed.
>logips2pp: Detected unknown logitech mouse model 0
>input: PS/2 Logitech Mouse as /class/input/input1
>kjournald starting.  Commit interval 5 seconds
>EXT3-fs: mounted filesystem with ordered data mode.
>VFS: Mounted root (ext3 filesystem) readonly.
