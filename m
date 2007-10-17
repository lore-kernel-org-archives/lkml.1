Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbXJQSAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbXJQSAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbXJQR7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:59:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbXJQR7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:59:47 -0400
Date: Wed, 17 Oct 2007 19:58:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017175807.GA7834@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017175512.GO15552@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20071017175512.GO15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Jens Axboe <jens.axboe@oracle.com> wrote:

> Also, can you send a dmesg from that system so I can see which libata 
> drivers are involved?

same system for which i sent the earlier bootlog - but here's the second 
crashlog too. Crash is reproducible - crashed twice in a row already. 
(NOTE: the attached log is from this second crash.)

	Ingo

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash2.log"

[    0.000000] Linux version 2.6.23 (mingo@dione) (gcc version 4.2.2) #6 Wed Oct 17 19:36:57 CEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] using polling idle threads.
[    0.000000] using polling idle threads.
[    0.000000] ignoring highmem size on non-highmem kernel!
[    0.000000] 1023MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f5680
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 2015 pages used for memmap
[    0.000000]   Normal zone: 256017 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
[    0.000000] Processor #0 15:3 APIC version 17
[    0.000000] Processor #1 15:3 APIC version 17
[    0.000000] WARNING: NR_CPUS limit of 1 reached.  Processor ignored.
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 1
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: root=/dev/sda1 console=tty 3 debug profile=0 initcall_debug selinux=0 enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled earlyprintk=serial,ttyS0,115200,keep idle=poll maxcpus=1 nosmp highres=0 lapic hpet=disable idle=poll highmem=512m
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] debug: sysrq always enabled.
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2160.236 MHz processor.
[   13.543809] spurious 8259A interrupt: IRQ7.
[   13.548674] Console: colour VGA+ 80x25
[   13.552245] console [tty0] enabled
[   13.852183] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   13.859892] ... MAX_LOCKDEP_SUBCLASSES:    8
[   13.864139] ... MAX_LOCK_DEPTH:          30
[   13.868298] ... MAX_LOCKDEP_KEYS:        2048
[   13.872632] ... CLASSHASH_SIZE:           1024
[   13.877052] ... MAX_LOCKDEP_ENTRIES:     8192
[   13.881384] ... MAX_LOCKDEP_CHAINS:      16384
[   13.885804] ... CHAINHASH_SIZE:          8192
[   13.890137]  memory used by lock dependency info: 992 kB
[   13.895424]  per task-struct memory footprint: 1200 bytes
[   13.901086] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   13.908333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   13.949067] Memory: 998396k/1048512k available (6599k kernel code, 49608k reserved, 2687k data, 372k init, 0k highmem)
[   13.959651] virtual kernel memory layout:
[   13.959652]     fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
[   13.959653]     vmalloc : 0xb8800000 - 0xfffb7000   (1143 MB)
[   13.959654]     lowmem  : 0x78000000 - 0xb7ff0000   (1023 MB)
[   13.959655]       .init : 0x78a14000 - 0x78a71000   ( 372 kB)
[   13.959656]       .data : 0x78771df2 - 0x78a11a74   (2687 kB)
[   13.959657]       .text : 0x78100000 - 0x78771df2   (6599 kB)
[   13.997953] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   14.089370] Calibrating delay using timer specific routine.. 4324.72 BogoMIPS (lpj=7204356)
[   14.097638] Security Framework initialized
[   14.101644] Capability LSM initialized
[   14.105376] Mount-cache hash table entries: 512
[   14.110252] CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003 00000000
[   14.120778] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   14.127890] CPU: L2 Cache: 512K (64 bytes/line)
[   14.132396] CPU: After all inits, caps: 178bfbf7 e3d3fbff 00000000 00000410 00000001 00000000 00000003 00000000
[   14.142446] Compat vDSO mapped to ffffe000.
[   14.146611] CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   14.153542] Checking 'hlt' instruction... OK.
[   14.170307] Freeing SMP alternatives: 0k freed
[   14.174750] enabled ExtINT on CPU#0
[   14.178166] ExtINT not setup in hardware but reported by MP table
[   14.184264] ENABLING IO-APIC IRQs
[   14.187469] init IO_APIC IRQs
[   14.190416]  IO-APIC (apicid-pin) 2-0 not connected.
[   14.195410]  IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[   14.204147] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[   14.242874] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   14.248568] ...trying to set up timer (IRQ0) through the 8259A ... 
[   14.254634] ..... (found pin 0) ...works.
[   14.291700] number of MP IRQ sources: 17.
[   14.295690] number of IO-APIC #2 registers: 24.
[   14.300196] testing the IO APIC.......................
[   14.305311] IO APIC #2......
[   14.308168] .... register #00: 00000000
[   14.311982] .......    : physical APIC id: 00
[   14.316314] .......    : Delivery Type: 0
[   14.320301] .......    : LTS          : 0
[   14.324288] .... register #01: 00170011
[   14.328101] .......     : max redirection entries: 0017
[   14.333300] .......     : PRQ implemented: 0
[   14.337546] .......     : IO APIC version: 0011
[   14.342053] .... register #02: 00000000
[   14.345866] .......     : arbitration: 00
[   14.349853] .... IRQ redirection table:
[   14.353665]  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
[   14.359734]  00 001 01  0    0    0   0   0    1    1    31
[   14.365281]  01 001 01  0    0    0   0   0    1    1    39
[   14.370826]  02 000 00  1    0    0   0   0    0    0    00
[   14.376373]  03 001 01  1    1    0   1   0    1    1    41
[   14.381919]  04 001 01  0    0    0   0   0    1    1    49
[   14.387466]  05 001 01  1    1    0   1   0    1    1    51
[   14.393012]  06 001 01  0    0    0   0   0    1    1    59
[   14.398558]  07 001 01  1    0    0   0   0    1    1    61
[   14.404104]  08 001 01  0    0    0   0   0    1    1    69
[   14.409651]  09 001 01  0    0    0   0   0    1    1    71
[   14.415197]  0a 001 01  0    0    0   0   0    1    1    79
[   14.420744]  0b 001 01  1    1    0   1   0    1    1    81
[   14.426290]  0c 001 01  0    0    0   0   0    1    1    89
[   14.431836]  0d 001 01  0    0    0   0   0    1    1    91
[   14.437382]  0e 001 01  0    0    0   0   0    1    1    99
[   14.442929]  0f 001 01  0    0    0   0   0    1    1    A1
[   14.448476]  10 000 00  1    0    0   0   0    0    0    00
[   14.454022]  11 000 00  1    0    0   0   0    0    0    00
[   14.459568]  12 000 00  1    0    0   0   0    0    0    00
[   14.465114]  13 000 00  1    0    0   0   0    0    0    00
[   14.470660]  14 000 00  1    0    0   0   0    0    0    00
[   14.476207]  15 000 00  1    0    0   0   0    0    0    00
[   14.481753]  16 000 00  1    0    0   0   0    0    0    00
[   14.487300]  17 000 00  1    0    0   0   0    0    0    00
[   14.492844] IRQ to pin mappings:
[   14.496050] IRQ0 -> 0:0
[   14.498473] IRQ1 -> 0:1
[   14.500899] IRQ3 -> 0:3
[   14.503325] IRQ4 -> 0:4
[   14.505752] IRQ5 -> 0:5
[   14.508179] IRQ6 -> 0:6
[   14.510605] IRQ7 -> 0:7
[   14.513032] IRQ8 -> 0:8
[   14.515459] IRQ9 -> 0:9
[   14.517885] IRQ10 -> 0:10
[   14.520484] IRQ11 -> 0:11
[   14.523084] IRQ12 -> 0:12
[   14.525684] IRQ13 -> 0:13
[   14.528284] IRQ14 -> 0:14
[   14.530884] IRQ15 -> 0:15
[   14.533485] .................................... done.
[   14.538601] Using local APIC timer interrupts.
[   14.538602] calibrating APIC timer ...
[   14.652626] ... lapic delta = 1350030
[   14.656153] ... PM timer delta = 0
[   14.659533] ..... delta 1350030
[   14.662652] ..... mult: 57987127
[   14.665859] ..... calibration result: 720016
[   14.670106] ..... CPU clock speed is 2160.0877 MHz.
[   14.674958] ..... host bus clock speed is 216.0088 MHz.
[   14.680158] ... verify APIC timer
[   14.790104] ... jiffies delta = 30
[   14.793376] ... jiffies result ok
[   14.796813] Calling initcall 0x78a4ac70: init_cpufreq_transition_notifier_list+0x0/0x10()
[   14.804830] initcall 0x78a4ac70: init_cpufreq_transition_notifier_list+0x0/0x10() returned 0.
[   14.813322] initcall 0x78a4ac70 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x10()
[   14.822163] Calling initcall 0x78a4d270: net_ns_init+0x0/0x180()
[   14.828141] net_namespace: 64 bytes
[   14.831639] initcall 0x78a4d270: net_ns_init+0x0/0x180() returned 0.
[   14.837934] initcall 0x78a4d270 ran for 3 msecs: net_ns_init+0x0/0x180()
[   14.844608] Calling initcall 0x78a19b40: cpufreq_tsc+0x0/0x10()
[   14.850500] initcall 0x78a19b40: cpufreq_tsc+0x0/0x10() returned 0.
[   14.856740] initcall 0x78a19b40 ran for 0 msecs: cpufreq_tsc+0x0/0x10()
[   14.863847] Calling initcall 0x78a1d9b0: reboot_init+0x0/0x10()
[   14.869741] initcall 0x78a1d9b0: reboot_init+0x0/0x10() returned 0.
[   14.875978] initcall 0x78a1d9b0 ran for 0 msecs: reboot_init+0x0/0x10()
[   14.882563] Calling initcall 0x78a232e0: print_banner+0x0/0x10()
[   14.888544] Booting paravirtualized kernel on bare hardware
[   14.894092] initcall 0x78a232e0: print_banner+0x0/0x10() returned 0.
[   14.900418] initcall 0x78a232e0 ran for 3 msecs: print_banner+0x0/0x10()
[   14.907090] Calling initcall 0x78a24840: sysctl_init+0x0/0x10()
[   14.912988] initcall 0x78a24840: sysctl_init+0x0/0x10() returned 0.
[   14.919221] initcall 0x78a24840 ran for 0 msecs: sysctl_init+0x0/0x10()
[   14.925807] Calling initcall 0x78a254b0: init_jiffies_clocksource+0x0/0x10()
[   14.932832] initcall 0x78a254b0: init_jiffies_clocksource+0x0/0x10() returned 0.
[   14.940195] initcall 0x78a254b0 ran for 0 msecs: init_jiffies_clocksource+0x0/0x10()
[   14.947908] Calling initcall 0x78a25980: ksysfs_init+0x0/0x50()
[   14.953803] initcall 0x78a25980: ksysfs_init+0x0/0x50() returned 0.
[   14.960041] initcall 0x78a25980 ran for 0 msecs: ksysfs_init+0x0/0x50()
[   14.966625] Calling initcall 0x78a27aa0: filelock_init+0x0/0x30()
[   14.972692] initcall 0x78a27aa0: filelock_init+0x0/0x30() returned 0.
[   14.979104] initcall 0x78a27aa0 ran for 0 msecs: filelock_init+0x0/0x30()
[   14.985863] Calling initcall 0x78a28480: init_misc_binfmt+0x0/0x40()
[   14.992197] initcall 0x78a28480: init_misc_binfmt+0x0/0x40() returned 0.
[   14.998863] initcall 0x78a28480 ran for 0 msecs: init_misc_binfmt+0x0/0x40()
[   15.005882] Calling initcall 0x78a284c0: init_script_binfmt+0x0/0x10()
[   15.012383] initcall 0x78a284c0: init_script_binfmt+0x0/0x10() returned 0.
[   15.019229] initcall 0x78a284c0 ran for 0 msecs: init_script_binfmt+0x0/0x10()
[   15.026422] Calling initcall 0x78a284d0: init_elf_binfmt+0x0/0x10()
[   15.032661] initcall 0x78a284d0: init_elf_binfmt+0x0/0x10() returned 0.
[   15.039247] initcall 0x78a284d0 ran for 0 msecs: init_elf_binfmt+0x0/0x10()
[   15.046180] Calling initcall 0x78a2a750: debugfs_init+0x0/0x40()
[   15.052163] initcall 0x78a2a750: debugfs_init+0x0/0x40() returned 0.
[   15.058486] initcall 0x78a2a750 ran for 0 msecs: debugfs_init+0x0/0x40()
[   15.065161] Calling initcall 0x78a2afc0: securityfs_init+0x0/0x40()
[   15.071401] initcall 0x78a2afc0: securityfs_init+0x0/0x40() returned 0.
[   15.077985] initcall 0x78a2afc0 ran for 0 msecs: securityfs_init+0x0/0x40()
[   15.084920] Calling initcall 0x78a2ba10: random32_init+0x0/0x20()
[   15.090984] initcall 0x78a2ba10: random32_init+0x0/0x20() returned 0.
[   15.097399] initcall 0x78a2ba10 ran for 0 msecs: random32_init+0x0/0x20()
[   15.104158] Calling initcall 0x78a4ac80: cpufreq_core_init+0x0/0x30()
[   15.110569] initcall 0x78a4ac80: cpufreq_core_init+0x0/0x30() returned 0.
[   15.117331] initcall 0x78a4ac80 ran for 0 msecs: cpufreq_core_init+0x0/0x30()
[   15.124437] Calling initcall 0x78a4d120: sock_init+0x0/0x60()
[   15.130188] initcall 0x78a4d120: sock_init+0x0/0x60() returned 0.
[   15.136222] initcall 0x78a4d120 ran for 0 msecs: sock_init+0x0/0x60()
[   15.142634] Calling initcall 0x78a4dc60: netpoll_init+0x0/0x40()
[   15.148614] initcall 0x78a4dc60: netpoll_init+0x0/0x40() returned 0.
[   15.154940] initcall 0x78a4dc60 ran for 0 msecs: netpoll_init+0x0/0x40()
[   15.161614] Calling initcall 0x78a4e370: netlink_proto_init+0x0/0x140()
[   15.168224] NET: Registered protocol family 16
[   15.172638] initcall 0x78a4e370: netlink_proto_init+0x0/0x140() returned 0.
[   15.179551] initcall 0x78a4e370 ran for 3 msecs: netlink_proto_init+0x0/0x140()
[   15.186832] Calling initcall 0x78a2bb30: pcibus_class_init+0x0/0x10()
[   15.193259] initcall 0x78a2bb30: pcibus_class_init+0x0/0x10() returned 0.
[   15.200005] initcall 0x78a2bb30 ran for 0 msecs: pcibus_class_init+0x0/0x10()
[   15.207111] Calling initcall 0x78a2d090: pci_driver_init+0x0/0x10()
[   15.213372] initcall 0x78a2d090: pci_driver_init+0x0/0x10() returned 0.
[   15.219936] initcall 0x78a2d090 ran for 0 msecs: pci_driver_init+0x0/0x10()
[   15.226870] Calling initcall 0x78a2d1d0: lcd_class_init+0x0/0x50()
[   15.233030] initcall 0x78a2d1d0: lcd_class_init+0x0/0x50() returned 0.
[   15.239522] initcall 0x78a2d1d0 ran for 0 msecs: lcd_class_init+0x0/0x50()
[   15.246367] Calling initcall 0x78a2d220: backlight_class_init+0x0/0x50()
[   15.253049] initcall 0x78a2d220: backlight_class_init+0x0/0x50() returned 0.
[   15.260062] initcall 0x78a2d220 ran for 0 msecs: backlight_class_init+0x0/0x50()
[   15.267428] Calling initcall 0x78a2d400: tty_class_init+0x0/0x20()
[   15.273588] initcall 0x78a2d400: tty_class_init+0x0/0x20() returned 0.
[   15.280080] initcall 0x78a2d400 ran for 0 msecs: tty_class_init+0x0/0x20()
[   15.286926] Calling initcall 0x78a2de20: vtconsole_class_init+0x0/0xd0()
[   15.293624] initcall 0x78a2de20: vtconsole_class_init+0x0/0xd0() returned 0.
[   15.300619] initcall 0x78a2de20 ran for 0 msecs: vtconsole_class_init+0x0/0xd0()
[   15.307985] Calling initcall 0x78a199b0: init_pit_clocksource+0x0/0x70()
[   15.314668] initcall 0x78a199b0: init_pit_clocksource+0x0/0x70() returned 0.
[   15.321678] initcall 0x78a199b0 ran for 0 msecs: init_pit_clocksource+0x0/0x70()
[   15.329046] Calling initcall 0x78a4b930: pci_access_init+0x0/0x30()
[   15.339864] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[   15.346084] initcall 0x78a4b930: pci_access_init+0x0/0x30() returned 0.
[   15.352667] initcall 0x78a4b930 ran for 6 msecs: pci_access_init+0x0/0x30()
[   15.359602] Calling initcall 0x78a19010: request_standard_resources+0x0/0x3a0()
[   15.366879] Setting up standard PCI resources
[   15.374039] initcall 0x78a19010: request_standard_resources+0x0/0x3a0() returned 0.
[   15.381536] initcall 0x78a19010 ran for 6 msecs: request_standard_resources+0x0/0x3a0()
[   15.389510] Calling initcall 0x78a198e0: topology_init+0x0/0x10()
[   15.395582] initcall 0x78a198e0: topology_init+0x0/0x10() returned 0.
[   15.401988] initcall 0x78a198e0 ran for 0 msecs: topology_init+0x0/0x10()
[   15.408749] Calling initcall 0x78a1d9f0: mca_init+0x0/0x330()
[   15.414476] initcall 0x78a1d9f0: mca_init+0x0/0x330() returned -19.
[   15.420705] initcall 0x78a1d9f0 ran for 0 msecs: mca_init+0x0/0x330()
[   15.427119] Calling initcall 0x78a24de0: param_sysfs_init+0x0/0x180()
[   15.434892] initcall 0x78a24de0: param_sysfs_init+0x0/0x180() returned 0.
[   15.441522] initcall 0x78a24de0 ran for 0 msecs: param_sysfs_init+0x0/0x180()
[   15.448630] Calling initcall 0x78a27820: readahead_init+0x0/0x10()
[   15.454783] initcall 0x78a27820: readahead_init+0x0/0x10() returned 0.
[   15.461279] initcall 0x78a27820 ran for 0 msecs: readahead_init+0x0/0x10()
[   15.468129] Calling initcall 0x78a28190: init_bio+0x0/0x100()
[   15.473871] initcall 0x78a28190: init_bio+0x0/0x100() returned 0.
[   15.479911] initcall 0x78a28190 ran for 0 msecs: init_bio+0x0/0x100()
[   15.486326] Calling initcall 0x78a2b760: genhd_device_init+0x0/0x60()
[   15.492769] initcall 0x78a2b760: genhd_device_init+0x0/0x60() returned 0.
[   15.499496] initcall 0x78a2b760 ran for 0 msecs: genhd_device_init+0x0/0x60()
[   15.506606] Calling initcall 0x78a2d8e0: misc_init+0x0/0x80()
[   15.512338] initcall 0x78a2d8e0: misc_init+0x0/0x80() returned 0.
[   15.518391] initcall 0x78a2d8e0 ran for 0 msecs: misc_init+0x0/0x80()
[   15.524805] Calling initcall 0x78a392a0: init_dvbdev+0x0/0xd0()
[   15.530701] initcall 0x78a392a0: init_dvbdev+0x0/0xd0() returned 0.
[   15.536936] initcall 0x78a392a0 ran for 0 msecs: init_dvbdev+0x0/0xd0()
[   15.543522] Calling initcall 0x78a39370: init_scsi+0x0/0xa0()
[   15.549391] SCSI subsystem initialized
[   15.553015] initcall 0x78a39370: init_scsi+0x0/0xa0() returned 0.
[   15.559078] initcall 0x78a39370 ran for 3 msecs: init_scsi+0x0/0xa0()
[   15.565491] Calling initcall 0x78a399c0: ata_init+0x0/0x70()
[   15.571166] libata version 3.00 loaded.
[   15.574940] initcall 0x78a399c0: ata_init+0x0/0x70() returned 0.
[   15.580917] initcall 0x78a399c0 ran for 3 msecs: ata_init+0x0/0x70()
[   15.587242] Calling initcall 0x78a3c920: spi_init+0x0/0x70()
[   15.592889] initcall 0x78a3c920: spi_init+0x0/0x70() returned 0.
[   15.598856] initcall 0x78a3c920 ran for 0 msecs: spi_init+0x0/0x70()
[   15.605182] Calling initcall 0x78a3d350: usb_init+0x0/0xd0()
[   15.610852] usbcore: registered new interface driver usbfs
[   15.616288] usbcore: registered new interface driver hub
[   15.621593] usbcore: registered new device driver usb
[   15.626590] initcall 0x78a3d350: usb_init+0x0/0xd0() returned 0.
[   15.632564] initcall 0x78a3d350 ran for 9 msecs: usb_init+0x0/0xd0()
[   15.638893] Calling initcall 0x78a3f3e0: serio_init+0x0/0xb0()
[   15.644737] initcall 0x78a3f3e0: serio_init+0x0/0xb0() returned 0.
[   15.650852] initcall 0x78a3f3e0 ran for 0 msecs: serio_init+0x0/0xb0()
[   15.657351] Calling initcall 0x78a3ff00: gameport_init+0x0/0xb0()
[   15.663470] initcall 0x78a3ff00: gameport_init+0x0/0xb0() returned 0.
[   15.669829] initcall 0x78a3ff00 ran for 0 msecs: gameport_init+0x0/0xb0()
[   15.676593] Calling initcall 0x78a40770: input_init+0x0/0x100()
[   15.682493] initcall 0x78a40770: input_init+0x0/0x100() returned 0.
[   15.688723] initcall 0x78a40770 ran for 0 msecs: input_init+0x0/0x100()
[   15.695309] Calling initcall 0x78a40ca0: i2c_init+0x0/0x20()
[   15.700956] initcall 0x78a40ca0: i2c_init+0x0/0x20() returned 0.
[   15.706921] initcall 0x78a40ca0 ran for 0 msecs: i2c_init+0x0/0x20()
[   15.713248] Calling initcall 0x78a42fe0: hwmon_init+0x0/0x40()
[   15.719057] initcall 0x78a42fe0: hwmon_init+0x0/0x40() returned 0.
[   15.725208] initcall 0x78a42fe0 ran for 0 msecs: hwmon_init+0x0/0x40()
[   15.731709] Calling initcall 0x78a4ad50: leds_init+0x0/0x20()
[   15.737433] initcall 0x78a4ad50: leds_init+0x0/0x20() returned 0.
[   15.743493] initcall 0x78a4ad50 ran for 0 msecs: leds_init+0x0/0x20()
[   15.749906] Calling initcall 0x78a4b570: ssb_modinit+0x0/0x80()
[   15.755834] initcall 0x78a4b570: ssb_modinit+0x0/0x80() returned 0.
[   15.762039] initcall 0x78a4b570 ran for 0 msecs: ssb_modinit+0x0/0x80()
[   15.768624] Calling initcall 0x78a4c190: pci_legacy_init+0x0/0x100()
[   15.774949] PCI: Probing PCI hardware
[   15.778606] PCI: Probing PCI hardware (bus 00)
[   15.785980] PCI: Transparent bridge - 0000:00:09.0
[   15.792938] initcall 0x78a4c190: pci_legacy_init+0x0/0x100() returned 0.
[   15.799474] initcall 0x78a4c190 ran for 12 msecs: pci_legacy_init+0x0/0x100()
[   15.806584] Calling initcall 0x78a4c7b0: pcibios_irq_init+0x0/0x510()
[   15.813253] PCI: Using IRQ router default [10de/005e] at 0000:00:00.0
[   15.819594] PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 3
[   15.825290] PCI->APIC IRQ transform: 0000:00:0a.0[A] -> IRQ 11
[   15.831120] PCI->APIC IRQ transform: 0000:05:07.0[A] -> IRQ 11
[   15.836894] PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 5
[   15.842614] initcall 0x78a4c7b0: pcibios_irq_init+0x0/0x510() returned 0.
[   15.849365] initcall 0x78a4c7b0 ran for 19 msecs: pcibios_irq_init+0x0/0x510()
[   15.856561] Calling initcall 0x78a4cd20: pcibios_init+0x0/0xa0()
[   15.916136] initcall 0x78a4cd20: pcibios_init+0x0/0xa0() returned 0.
[   15.922327] initcall 0x78a4cd20 ran for 50 msecs: pcibios_init+0x0/0xa0()
[   15.929087] Calling initcall 0x78a4d1e0: proto_init+0x0/0x30()
[   15.934892] initcall 0x78a4d1e0: proto_init+0x0/0x30() returned 0.
[   15.941045] initcall 0x78a4d1e0 ran for 0 msecs: proto_init+0x0/0x30()
[   15.947544] Calling initcall 0x78a4d5f0: net_dev_init+0x0/0x110()
[   15.953643] initcall 0x78a4d5f0: net_dev_init+0x0/0x110() returned 0.
[   15.960024] initcall 0x78a4d5f0 ran for 0 msecs: net_dev_init+0x0/0x110()
[   15.966786] Calling initcall 0x78a4d750: neigh_init+0x0/0x80()
[   15.972589] initcall 0x78a4d750: neigh_init+0x0/0x80() returned 0.
[   15.978743] initcall 0x78a4d750 ran for 0 msecs: neigh_init+0x0/0x80()
[   15.985243] Calling initcall 0x78a4e060: pktsched_init+0x0/0xd0()
[   15.991319] initcall 0x78a4e060: pktsched_init+0x0/0xd0() returned 0.
[   15.998244] initcall 0x78a4e060 ran for 0 msecs: pktsched_init+0x0/0xd0()
[   16.005004] Calling initcall 0x78a4e140: tc_filter_init+0x0/0x60()
[   16.011153] initcall 0x78a4e140: tc_filter_init+0x0/0x60() returned 0.
[   16.017653] initcall 0x78a4e140 ran for 0 msecs: tc_filter_init+0x0/0x60()
[   16.024500] Calling initcall 0x78a4e1a0: tc_action_init+0x0/0x60()
[   16.030651] initcall 0x78a4e1a0: tc_action_init+0x0/0x60() returned 0.
[   16.037153] initcall 0x78a4e1a0 ran for 0 msecs: tc_action_init+0x0/0x60()
[   16.043999] Calling initcall 0x78a4e4b0: genl_init+0x0/0xd0()
[   16.056537] initcall 0x78a4e4b0: genl_init+0x0/0xd0() returned 0.
[   16.062474] initcall 0x78a4e4b0 ran for 9 msecs: genl_init+0x0/0xd0()
[   16.068889] Calling initcall 0x78a50f70: cipso_v4_init+0x0/0x80()
[   16.074966] initcall 0x78a50f70: cipso_v4_init+0x0/0x80() returned 0.
[   16.081368] initcall 0x78a50f70 ran for 0 msecs: cipso_v4_init+0x0/0x80()
[   16.088129] Calling initcall 0x78a52490: wanrouter_init+0x0/0x60()
[   16.094279] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[   16.101566] initcall 0x78a52490: wanrouter_init+0x0/0x60() returned 0.
[   16.108059] initcall 0x78a52490 ran for 3 msecs: wanrouter_init+0x0/0x60()
[   16.114908] Calling initcall 0x78a529f0: irda_init+0x0/0x90()
[   16.120653] NET: Registered protocol family 23
[   16.125070] initcall 0x78a529f0: irda_init+0x0/0x90() returned 0.
[   16.131110] initcall 0x78a529f0 ran for 3 msecs: irda_init+0x0/0x90()
[   16.137524] Calling initcall 0x78a53910: wireless_nlevent_init+0x0/0x40()
[   16.144282] initcall 0x78a53910: wireless_nlevent_init+0x0/0x40() returned 0.
[   16.151391] initcall 0x78a53910 ran for 0 msecs: wireless_nlevent_init+0x0/0x40()
[   16.158845] Calling initcall 0x78730680: cfg80211_init+0x0/0x50()
[   16.165022] initcall 0x78730680: cfg80211_init+0x0/0x50() returned 0.
[   16.171322] initcall 0x78730680 ran for 0 msecs: cfg80211_init+0x0/0x50()
[   16.178084] Calling initcall 0x78a53950: ieee80211_init+0x0/0x40()
[   16.184234] initcall 0x78a53950: ieee80211_init+0x0/0x40() returned 0.
[   16.190733] initcall 0x78a53950 ran for 0 msecs: ieee80211_init+0x0/0x40()
[   16.197580] Calling initcall 0x78a53990: rate_control_simple_init+0x0/0x10()
[   16.204607] initcall 0x78a53990: rate_control_simple_init+0x0/0x10() returned 0.
[   16.211967] initcall 0x78a53990 ran for 0 msecs: rate_control_simple_init+0x0/0x10()
[   16.219681] Calling initcall 0x78a53b50: netlbl_init+0x0/0x80()
[   16.225570] NetLabel: Initializing
[   16.228954] NetLabel:  domain hash size = 128
[   16.233286] NetLabel:  protocols = UNLABELED CIPSOv4
[   16.238276] NetLabel:  unlabeled traffic allowed by default
[   16.243773] initcall 0x78a53b50: netlbl_init+0x0/0x80() returned 0.
[   16.250010] initcall 0x78a53b50 ran for 12 msecs: netlbl_init+0x0/0x80()
[   16.256683] Calling initcall 0x78a253c0: clocksource_done_booting+0x0/0x10()
[   16.263701] initcall 0x78a253c0<6>Time: tsc clocksource has been installed.
[   16.270645] : clocksource_done_booting+0x0/0x10() returned 0.
[   16.276353] initcall 0x78a253c0 ran for 0 msecs: clocksource_done_booting+0x0/0x10()
[   16.284071] Calling initcall 0x78a27a20: init_pipe_fs+0x0/0x50()
[   16.290076] initcall 0x78a27a20: init_pipe_fs+0x0/0x50() returned 0.
[   16.296372] initcall 0x78a27a20 ran for 0 msecs: init_pipe_fs+0x0/0x50()
[   16.303048] Calling initcall 0x78a28300: eventpoll_init+0x0/0x90()
[   16.309199] initcall 0x78a28300: eventpoll_init+0x0/0x90() returned 0.
[   16.315700] initcall 0x78a28300 ran for 0 msecs: eventpoll_init+0x0/0x90()
[   16.322546] Calling initcall 0x78a28390: anon_inode_init+0x0/0xf0()
[   16.328818] initcall 0x78a28390: anon_inode_init+0x0/0xf0() returned 0.
[   16.335372] initcall 0x78a28390 ran for 0 msecs: anon_inode_init+0x0/0xf0()
[   16.342305] Calling initcall 0x78a2d2e0: chr_dev_init+0x0/0xe0()
[   16.348383] initcall 0x78a2d2e0: chr_dev_init+0x0/0xe0() returned 0.
[   16.354611] initcall 0x78a2d2e0 ran for 0 msecs: chr_dev_init+0x0/0xe0()
[   16.361285] Calling initcall 0x78a311a0: firmware_class_init+0x0/0x70()
[   16.367877] initcall 0x78a311a0: firmware_class_init+0x0/0x70() returned 0.
[   16.374803] initcall 0x78a311a0 ran for 0 msecs: firmware_class_init+0x0/0x70()
[   16.382084] Calling initcall 0x78a33aa0: loopback_init+0x0/0x10()
[   16.388288] initcall 0x78a33aa0: loopback_init+0x0/0x10() returned 0.
[   16.394570] initcall 0x78a33aa0 ran for 0 msecs: loopback_init+0x0/0x10()
[   16.401331] Calling initcall 0x78a4ad30: cpufreq_gov_userspace_init+0x0/0x10()
[   16.408527] initcall 0x78a4ad30: cpufreq_gov_userspace_init+0x0/0x10() returned 0.
[   16.416060] initcall 0x78a4ad30 ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0x10()
[   16.423950] Calling initcall 0x78a4b600: pcibios_assign_resources+0x0/0xa0()
[   16.431006] PCI: Bridge: 0000:00:09.0
[   16.434613]   IO window: c000-cfff
[   16.438001]   MEM window: da000000-da0fffff
[   16.442157]   PREFETCH window: disabled.
[   16.446061] PCI: Bridge: 0000:00:0b.0
[   16.449688]   IO window: disabled.
[   16.453079]   MEM window: disabled.
[   16.456542]   PREFETCH window: disabled.
[   16.460447] PCI: Bridge: 0000:00:0c.0
[   16.464074]   IO window: disabled.
[   16.467465]   MEM window: disabled.
[   16.470927]   PREFETCH window: disabled.
[   16.474832] PCI: Bridge: 0000:00:0d.0
[   16.478460]   IO window: disabled.
[   16.481851]   MEM window: disabled.
[   16.485313]   PREFETCH window: disabled.
[   16.489221] PCI: Bridge: 0000:00:0e.0
[   16.492850]   IO window: b000-bfff
[   16.496237]   MEM window: d8000000-d9ffffff
[   16.500393]   PREFETCH window: d0000000-d7ffffff
[   16.505012] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   16.511264] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   16.517503] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   16.523743] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   16.529983] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   16.536181] initcall 0x78a4b600: pcibios_assign_resources+0x0/0xa0() returned 0.
[   16.543540] initcall 0x78a4b600 ran for 100 msecs: pcibios_assign_resources+0x0/0xa0()
[   16.551429] Calling initcall 0x78a4eef0: inet_init+0x0/0x300()
[   16.557236] NET: Registered protocol family 2
[   16.589825] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   16.597088] TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
[   16.613117] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[   16.623764] TCP: Hash tables configured (established 131072 bind 65536)
[   16.630268] TCP reno registered
[   16.643146] initcall 0x78a4eef0: inet_init+0x0/0x300() returned 0.
[   16.649170] initcall 0x78a4eef0 ran for 81 msecs: inet_init+0x0/0x300()
[   16.655758] Calling initcall 0x78a17600: populate_rootfs+0x0/0xa0()
[   16.662333] initcall 0x78a17600: populate_rootfs+0x0/0xa0() returned 0.
[   16.668792] initcall 0x78a17600 ran for 0 msecs: populate_rootfs+0x0/0xa0()
[   16.675725] Calling initcall 0x78a186b0: i8259A_init_sysfs+0x0/0x20()
[   16.682147] initcall 0x78a186b0: i8259A_init_sysfs+0x0/0x20() returned 0.
[   16.688898] initcall 0x78a186b0 ran for 0 msecs: i8259A_init_sysfs+0x0/0x20()
[   16.696004] Calling initcall 0x78a18830: sbf_init+0x0/0xd0()
[   16.701634] initcall 0x78a18830: sbf_init+0x0/0xd0() returned 0.
[   16.707616] initcall 0x78a18830 ran for 0 msecs: sbf_init+0x0/0xd0()
[   16.713942] Calling initcall 0x78a198c0: i8237A_init_sysfs+0x0/0x20()
[   16.720359] initcall 0x78a198c0: i8237A_init_sysfs+0x0/0x20() returned 0.
[   16.727115] initcall 0x78a198c0 ran for 0 msecs: i8237A_init_sysfs+0x0/0x20()
[   16.734221] Calling initcall 0x78a1cba0: cache_sysfs_init+0x0/0x200()
[   16.740678] initcall 0x78a1cba0: cache_sysfs_init+0x0/0x200() returned 0.
[   16.747393] initcall 0x78a1cba0 ran for 0 msecs: cache_sysfs_init+0x0/0x200()
[   16.754501] Calling initcall 0x78a1d450: longrun_init+0x0/0x30()
[   16.760477] initcall 0x78a1d450: longrun_init+0x0/0x30() returned -19.
[   16.766979] initcall 0x78a1d450 ran for 0 msecs: longrun_init+0x0/0x30()
[   16.773651] Calling initcall 0x78a1dd20: microcode_init+0x0/0xa0()
[   16.779901] microcode: CPU0 not a capable Intel processor
[   16.785182] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   16.792460] initcall 0x78a1dd20: microcode_init+0x0/0xa0() returned 0.
[   16.798957] initcall 0x78a1dd20 ran for 12 msecs: microcode_init+0x0/0xa0()
[   16.805891] Calling initcall 0x78a20290: ioapic_init_sysfs+0x0/0xe0()
[   16.812311] initcall 0x78a20290: ioapic_init_sysfs+0x0/0xe0() returned 0.
[   16.819061] initcall 0x78a20290 ran for 0 msecs: ioapic_init_sysfs+0x0/0xe0()
[   16.826169] Calling initcall 0x78a22fe0: init_vmi_clocksource+0x0/0x130()
[   16.832926] initcall 0x78a22fe0: init_vmi_clocksource+0x0/0x130() returned 0.
[   16.840034] initcall 0x78a22fe0 ran for 0 msecs: init_vmi_clocksource+0x0/0x130()
[   16.847487] Calling initcall 0x78a23310: add_pcspkr+0x0/0x60()
[   16.853304] initcall 0x78a23310: add_pcspkr+0x0/0x60() returned 0.
[   16.859444] initcall 0x78a23310 ran for 0 msecs: add_pcspkr+0x0/0x60()
[   16.865946] Calling initcall 0x78a23bc0: init+0x0/0x10()
[   16.871243] initcall 0x78a23bc0: init+0x0/0x10() returned 0.
[   16.876865] initcall 0x78a23bc0 ran for 0 msecs: init+0x0/0x10()
[   16.882843] Calling initcall 0x78a23bf0: init_sched_debug_procfs+0x0/0x30()
[   16.889779] initcall 0x78a23bf0: init_sched_debug_procfs+0x0/0x30() returned 0.
[   16.897058] initcall 0x78a23bf0 ran for 0 msecs: init_sched_debug_procfs+0x0/0x30()
[   16.904685] Calling initcall 0x78a24590: create_proc_profile+0x0/0x50()
[   16.911273] initcall 0x78a24590: create_proc_profile+0x0/0x50() returned 0.
[   16.918203] initcall 0x78a24590 ran for 0 msecs: create_proc_profile+0x0/0x50()
[   16.925485] Calling initcall 0x78a24720: ioresources_init+0x0/0x40()
[   16.931809] initcall 0x78a24720: ioresources_init+0x0/0x40() returned 0.
[   16.938482] initcall 0x78a24720 ran for 0 msecs: ioresources_init+0x0/0x40()
[   16.945503] Calling initcall 0x78a249e0: uid_cache_init+0x0/0x80()
[   16.951657] initcall 0x78a249e0: uid_cache_init+0x0/0x80() returned 0.
[   16.958153] initcall 0x78a249e0 ran for 0 msecs: uid_cache_init+0x0/0x80()
[   16.965002] Calling initcall 0x78a24f60: init_posix_timers+0x0/0x90()
[   16.971412] initcall 0x78a24f60: init_posix_timers+0x0/0x90() returned 0.
[   16.978173] initcall 0x78a24f60 ran for 0 msecs: <4>Clocksource tsc unstable (delta = 63281543 ns)
[   16.987108] init_posix_timers+0x0/0x90()
[   16.991011] Time: pit clocksource has been installed.
[   16.996032] Calling initcall 0x78a24ff0: init_posix_cpu_timers+0x0/0xa0()
[   17.002790] initcall 0x78a24ff0: init_posix_cpu_timers+0x0/0xa0() returned 0.
[   17.009894] initcall 0x78a24ff0 ran for 0 msecs: init_posix_cpu_timers+0x0/0xa0()
[   17.017348] Calling initcall 0x78a251b0: latency_init+0x0/0x20()
[   17.023334] initcall 0x78a251b0: latency_init+0x0/0x20() returned 0.
[   17.029647] initcall 0x78a251b0 ran for 0 msecs: latency_init+0x0/0x20()
[   17.036322] Calling initcall 0x78a251d0: nsproxy_cache_init+0x0/0x40()
[   17.043352] initcall 0x78a251d0: nsproxy_cache_init+0x0/0x40() returned 0.
[   17.050192] initcall 0x78a251d0 ran for 0 msecs: nsproxy_cache_init+0x0/0x40()
[   17.057384] Calling initcall 0x78a25210: timekeeping_init_device+0x0/0x20()
[   17.064324] initcall 0x78a25210: timekeeping_init_device+0x0/0x20() returned 0.
[   17.071594] initcall 0x78a25210 ran for 0 msecs: timekeeping_init_device+0x0/0x20()
[   17.079225] Calling initcall 0x78a253d0: init_clocksource_sysfs+0x0/0x40()
[   17.086081] initcall 0x78a253d0: init_clocksource_sysfs+0x0/0x40() returned 0.
[   17.093262] initcall 0x78a253d0 ran for 0 msecs: init_clocksource_sysfs+0x0/0x40()
[   17.100802] Calling initcall 0x78a254c0: init_timer_list_procfs+0x0/0x30()
[   17.107650] initcall 0x78a254c0: init_timer_list_procfs+0x0/0x30() returned 0.
[   17.114837] initcall 0x78a254c0 ran for 0 msecs: init_timer_list_procfs+0x0/0x30()
[   17.122383] Calling initcall 0x78a25500: init_tstats_procfs+0x0/0x30()
[   17.128884] initcall 0x78a25500: init_tstats_procfs+0x0/0x30() returned 0.
[   17.135720] initcall 0x78a25500 ran for 0 msecs: init_tstats_procfs+0x0/0x30()
[   17.142916] Calling initcall 0x78a25620: lockdep_proc_init+0x0/0x40()
[   17.149337] initcall 0x78a25620: lockdep_proc_init+0x0/0x40() returned 0.
[   17.156085] initcall 0x78a25620 ran for 0 msecs: lockdep_proc_init+0x0/0x40()
[   17.163200] Calling initcall 0x78a25660: init+0x0/0xf0()
[   17.168534] initcall 0x78a25660: init+0x0/0xf0() returned 0.
[   17.174117] initcall 0x78a25660 ran for 0 msecs: init+0x0/0xf0()
[   17.180096] Calling initcall 0x7813ac70: init_rttest+0x0/0x120()
[   17.186369] Initializing RT-Tester: OK
[   17.190004] initcall 0x7813ac70: init_rttest+0x0/0x120() returned 0.
[   17.196314] initcall 0x7813ac70 ran for 5 msecs: init_rttest+0x0/0x120()
[   17.202989] Calling initcall 0x78a25750: proc_dma_init+0x0/0x20()
[   17.209061] initcall 0x78a25750: proc_dma_init+0x0/0x20() returned 0.
[   17.215469] initcall 0x78a25750 ran for 0 msecs: proc_dma_init+0x0/0x20()
[   17.222228] Calling initcall 0x78a25770: kallsyms_init+0x0/0x20()
[   17.228301] initcall 0x78a25770: kallsyms_init+0x0/0x20() returned 0.
[   17.234707] initcall 0x78a25770 ran for 0 msecs: kallsyms_init+0x0/0x20()
[   17.241472] Calling initcall 0x78a25800: audit_init+0x0/0x100()
[   17.247362] audit: initializing netlink socket (disabled)
[   17.252768] audit(1192645292.849:1): initialized
[   17.257340] initcall 0x78a25800: audit_init+0x0/0x100() returned 0.
[   17.263569] initcall 0x78a25800 ran for 6 msecs: audit_init+0x0/0x100()
[   17.270154] Calling initcall 0x78a25a30: utsname_sysctl_init+0x0/0x10()
[   17.276745] initcall 0x78a25a30: utsname_sysctl_init+0x0/0x10() returned 0.
[   17.283673] initcall 0x78a25a30 ran for 0 msecs: utsname_sysctl_init+0x0/0x10()
[   17.290953] Calling initcall 0x78a27250: init_per_zone_pages_min+0x0/0x50()
[   17.297936] initcall 0x78a27250: init_per_zone_pages_min+0x0/0x50() returned 0.
[   17.305163] initcall 0x78a27250 ran for 0 msecs: init_per_zone_pages_min+0x0/0x50()
[   17.312794] Calling initcall 0x78a27810: pdflush_init+0x0/0x10()
[   17.318831] initcall 0x78a27810: pdflush_init+0x0/0x10() returned 0.
[   17.325095] initcall 0x78a27810 ran for 0 msecs: pdflush_init+0x0/0x10()
[   17.331773] Calling initcall 0x78a27860: kswapd_init+0x0/0x10()
[   17.337693] initcall 0x78a27860: kswapd_init+0x0/0x10() returned 0.
[   17.343904] initcall 0x78a27860 ran for 0 msecs: kswapd_init+0x0/0x10()
[   17.350490] Calling initcall 0x78a278b0: procswaps_init+0x0/0x20()
[   17.356647] initcall 0x78a278b0: procswaps_init+0x0/0x20() returned 0.
[   17.363142] initcall 0x78a278b0 ran for 0 msecs: procswaps_init+0x0/0x20()
[   17.369991] Calling initcall 0x78a278d0: init_tmpfs+0x0/0xd0()
[   17.375833] initcall 0x78a278d0: init_tmpfs+0x0/0xd0() returned 0.
[   17.381944] initcall 0x78a278d0 ran for 0 msecs: init_tmpfs+0x0/0xd0()
[   17.388444] Calling initcall 0x78a27a70: fasync_init+0x0/0x30()
[   17.394342] initcall 0x78a27a70: fasync_init+0x0/0x30() returned 0.
[   17.400580] initcall 0x78a27a70 ran for 0 msecs: fasync_init+0x0/0x30()
[   17.407166] Calling initcall 0x78a280d0: aio_setup+0x0/0x70()
[   17.412919] initcall 0x78a280d0: aio_setup+0x0/0x70() returned 0.
[   17.418946] initcall 0x78a280d0 ran for 0 msecs: aio_setup+0x0/0x70()
[   17.425362] Calling initcall 0x78a284e0: init_mbcache+0x0/0x10()
[   17.431348] initcall 0x78a284e0: init_mbcache+0x0/0x10() returned 0.
[   17.437665] initcall 0x78a284e0 ran for 0 msecs: init_mbcache+0x0/0x10()
[   17.444344] Calling initcall 0x78a284f0: dquot_init+0x0/0xf0()
[   17.450147] VFS: Disk quotas dquot_6.5.1
[   17.454058] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   17.460556] initcall 0x78a284f0: dquot_init+0x0/0xf0() returned 0.
[   17.466702] initcall 0x78a284f0 ran for 6 msecs: dquot_init+0x0/0xf0()
[   17.473202] Calling initcall 0x78a285e0: dnotify_init+0x0/0x30()
[   17.479185] initcall 0x78a285e0: dnotify_init+0x0/0x30() returned 0.
[   17.485505] initcall 0x78a285e0 ran for 0 msecs: dnotify_init+0x0/0x30()
[   17.492177] Calling initcall 0x78a28a90: configfs_init+0x0/0xd0()
[   17.498254] initcall 0x78a28a90: configfs_init+0x0/0xd0() returned 0.
[   17.504657] initcall 0x78a28a90 ran for 0 msecs: configfs_init+0x0/0xd0()
[   17.511422] Calling initcall 0x78a28b60: init_devpts_fs+0x0/0x30()
[   17.517630] initcall 0x78a28b60: init_devpts_fs+0x0/0x30() returned 0.
[   17.524072] initcall 0x78a28b60 ran for 0 msecs: init_devpts_fs+0x0/0x30()
[   17.530918] Calling initcall 0x78a28b90: init_reiserfs_fs+0x0/0x90()
[   17.537259] initcall 0x78a28b90: init_reiserfs_fs+0x0/0x90() returned 0.
[   17.543918] initcall 0x78a28b90 ran for 0 msecs: init_reiserfs_fs+0x0/0x90()
[   17.550937] Calling initcall 0x78a28d00: init_ext3_fs+0x0/0x70()
[   17.556929] initcall 0x78a28d00: init_ext3_fs+0x0/0x70() returned 0.
[   17.563243] initcall 0x78a28d00 ran for 0 msecs: init_ext3_fs+0x0/0x70()
[   17.569916] Calling initcall 0x78a28db0: init_ext4_fs+0x0/0x60()
[   17.575898] initcall 0x78a28db0: init_ext4_fs+0x0/0x60() returned 0.
[   17.582218] initcall 0x78a28db0 ran for 0 msecs: init_ext4_fs+0x0/0x60()
[   17.588892] Calling initcall 0x78a28e90: journal_init+0x0/0x100()
[   17.594965] initcall 0x78a28e90: journal_init+0x0/0x100() returned 0.
[   17.601370] initcall 0x78a28e90 ran for 0 msecs: journal_init+0x0/0x100()
[   17.608136] Calling initcall 0x78a29010: journal_init+0x0/0xd0()
[   17.614116] initcall 0x78a29010: journal_init+0x0/0xd0() returned 0.
[   17.620438] initcall 0x78a29010 ran for 0 msecs: journal_init+0x0/0xd0()
[   17.627112] Calling initcall 0x78a290e0: init_cramfs_fs+0x0/0x30()
[   17.633310] initcall 0x78a290e0: init_cramfs_fs+0x0/0x30() returned 0.
[   17.639764] initcall 0x78a290e0 ran for 0 msecs: init_cramfs_fs+0x0/0x30()
[   17.646613] Calling initcall 0x78a29110: init_ramfs_fs+0x0/0x10()
[   17.652681] initcall 0x78a29110: init_ramfs_fs+0x0/0x10() returned 0.
[   17.659085] initcall 0x78a29110 ran for 0 msecs: init_ramfs_fs+0x0/0x10()
[   17.665847] Calling initcall 0x78a29160: init_coda+0x0/0x190()
[   17.671714] initcall 0x78a29160: init_coda+0x0/0x190() returned 0.
[   17.677806] initcall 0x78a29160 ran for 0 msecs: init_coda+0x0/0x190()
[   17.684309] Calling initcall 0x78a292f0: init_minix_fs+0x0/0x60()
[   17.690378] initcall 0x78a292f0: init_minix_fs+0x0/0x60() returned 0.
[   17.696788] initcall 0x78a292f0 ran for 0 msecs: init_minix_fs+0x0/0x60()
[   17.703548] Calling initcall 0x78a29390: init_fat_fs+0x0/0x50()
[   17.709444] initcall 0x78a29390: init_fat_fs+0x0/0x50() returned 0.
[   17.715674] initcall 0x78a29390 ran for 0 msecs: init_fat_fs+0x0/0x50()
[   17.722263] Calling initcall 0x78a293e0: init_msdos_fs+0x0/0x10()
[   17.728336] initcall 0x78a293e0: init_msdos_fs+0x0/0x10() returned 0.
[   17.734743] initcall 0x78a293e0 ran for 0 msecs: init_msdos_fs+0x0/0x10()
[   17.741507] Calling initcall 0x78a293f0: init_vfat_fs+0x0/0x10()
[   17.747488] initcall 0x78a293f0: init_vfat_fs+0x0/0x10() returned 0.
[   17.753811] initcall 0x78a293f0 ran for 0 msecs: init_vfat_fs+0x0/0x10()
[   17.760483] Calling initcall 0x78a29400: init_iso9660_fs+0x0/0x70()
[   17.766743] initcall 0x78a29400: init_iso9660_fs+0x0/0x70() returned 0.
[   17.773310] initcall 0x78a29400 ran for 0 msecs: init_iso9660_fs+0x0/0x70()
[   17.780243] Calling initcall 0x78a29490: init_hfsplus_fs+0x0/0x70()
[   17.786485] initcall 0x78a29490: init_hfsplus_fs+0x0/0x70() returned 0.
[   17.793068] initcall 0x78a29490 ran for 0 msecs: init_hfsplus_fs+0x0/0x70()
[   17.800004] Calling initcall 0x78a29500: init_hfs_fs+0x0/0x70()
[   17.805897] initcall 0x78a29500: init_hfs_fs+0x0/0x70() returned 0.
[   17.812131] initcall 0x78a29500 ran for 0 msecs: init_hfs_fs+0x0/0x70()
[   17.818717] Calling initcall 0x78a29570: ecryptfs_init+0x0/0x1d0()
[   17.824944] initcall 0x78a29570: ecryptfs_init+0x0/0x1d0() returned 0.
[   17.831370] initcall 0x78a29570 ran for 0 msecs: ecryptfs_init+0x0/0x1d0()
[   17.838221] Calling initcall 0x78a29740: vxfs_init+0x0/0x70()
[   17.843943] initcall 0x78a29740: vxfs_init+0x0/0x70() returned 0.
[   17.850005] initcall 0x78a29740 ran for 0 msecs: vxfs_init+0x0/0x70()
[   17.856418] Calling initcall 0x78a297b0: init_nfsd+0x0/0xb0()
[   17.862136] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   17.868915] initcall 0x78a297b0: init_nfsd+0x0/0xb0() returned 0.
[   17.874847] initcall 0x78a297b0 ran for 2 msecs: init_nfsd+0x0/0xb0()
[   17.881265] Calling initcall 0x78a29860: init_nlm+0x0/0x20()
[   17.886900] initcall 0x78a29860: init_nlm+0x0/0x20() returned 0.
[   17.892871] initcall 0x78a29860 ran for 0 msecs: init_nlm+0x0/0x20()
[   17.899200] Calling initcall 0x78a29880: init_nls_cp437+0x0/0x10()
[   17.905365] initcall 0x78a29880: init_nls_cp437+0x0/0x10() returned 0.
[   17.911851] initcall 0x78a29880 ran for 0 msecs: init_nls_cp437+0x0/0x10()
[   17.918698] Calling initcall 0x78a29890: init_nls_cp775+0x0/0x10()
[   17.924857] initcall 0x78a29890: init_nls_cp775+0x0/0x10() returned 0.
[   17.931351] initcall 0x78a29890 ran for 0 msecs: init_nls_cp775+0x0/0x10()
[   17.938202] Calling initcall 0x78a298a0: init_nls_cp852+0x0/0x10()
[   17.944357] initcall 0x78a298a0: init_nls_cp852+0x0/0x10() returned 0.
[   17.950847] initcall 0x78a298a0 ran for 0 msecs: init_nls_cp852+0x0/0x10()
[   17.957701] Calling initcall 0x78a298b0: init_nls_cp857+0x0/0x10()
[   17.963854] initcall 0x78a298b0: init_nls_cp857+0x0/0x10() returned 0.
[   17.970351] initcall 0x78a298b0 ran for 0 msecs: init_nls_cp857+0x0/0x10()
[   17.977197] Calling initcall 0x78a298c0: init_nls_cp860+0x0/0x10()
[   17.983353] initcall 0x78a298c0: init_nls_cp860+0x0/0x10() returned 0.
[   17.989850] initcall 0x78a298c0 ran for 0 msecs: init_nls_cp860+0x0/0x10()
[   17.996696] Calling initcall 0x78a298d0: init_nls_cp861+0x0/0x10()
[   18.002851] initcall 0x78a298d0: init_nls_cp861+0x0/0x10() returned 0.
[   18.009343] initcall 0x78a298d0 ran for 0 msecs: init_nls_cp861+0x0/0x10()
[   18.016192] Calling initcall 0x78a298e0: init_nls_cp863+0x0/0x10()
[   18.022350] initcall 0x78a298e0: init_nls_cp863+0x0/0x10() returned 0.
[   18.028844] initcall 0x78a298e0 ran for 0 msecs: init_nls_cp863+0x0/0x10()
[   18.035691] Calling initcall 0x78a298f0: init_nls_cp864+0x0/0x10()
[   18.041850] initcall 0x78a298f0: init_nls_cp864+0x0/0x10() returned 0.
[   18.048343] initcall 0x78a298f0 ran for 0 msecs: init_nls_cp864+0x0/0x10()
[   18.055194] Calling initcall 0x78a29900: init_nls_cp869+0x0/0x10()
[   18.061348] initcall 0x78a29900: init_nls_cp869+0x0/0x10() returned 0.
[   18.067842] initcall 0x78a29900 ran for 0 msecs: init_nls_cp869+0x0/0x10()
[   18.074693] Calling initcall 0x78a29910: init_nls_cp874+0x0/0x10()
[   18.080847] initcall 0x78a29910: init_nls_cp874+0x0/0x10() returned 0.
[   18.087344] initcall 0x78a29910 ran for 0 msecs: init_nls_cp874+0x0/0x10()
[   18.094189] Calling initcall 0x78a29920: init_nls_cp932+0x0/0x10()
[   18.100345] initcall 0x78a29920: init_nls_cp932+0x0/0x10() returned 0.
[   18.106843] initcall 0x78a29920 ran for 0 msecs: init_nls_cp932+0x0/0x10()
[   18.113689] Calling initcall 0x78a29930: init_nls_euc_jp+0x0/0x40()
[   18.119931] initcall 0x78a29930: init_nls_euc_jp+0x0/0x40() returned 0.
[   18.127035] initcall 0x78a29930 ran for 0 msecs: init_nls_euc_jp+0x0/0x40()
[   18.133967] Calling initcall 0x78a29970: init_nls_cp936+0x0/0x10()
[   18.140123] initcall 0x78a29970: init_nls_cp936+0x0/0x10() returned 0.
[   18.146620] initcall 0x78a29970 ran for 0 msecs: init_nls_cp936+0x0/0x10()
[   18.153466] Calling initcall 0x78a29980: init_nls_cp1250+0x0/0x10()
[   18.159714] initcall 0x78a29980: init_nls_cp1250+0x0/0x10() returned 0.
[   18.166292] initcall 0x78a29980 ran for 0 msecs: init_nls_cp1250+0x0/0x10()
[   18.173227] Calling initcall 0x78a29990: init_nls_ascii+0x0/0x10()
[   18.179380] initcall 0x78a29990: init_nls_ascii+0x0/0x10() returned 0.
[   18.185872] initcall 0x78a29990 ran for 0 msecs: init_nls_ascii+0x0/0x10()
[   18.192721] Calling initcall 0x78a299a0: init_nls_iso8859_3+0x0/0x10()
[   18.199226] initcall 0x78a299a0: init_nls_iso8859_3+0x0/0x10() returned 0.
[   18.206064] initcall 0x78a299a0 ran for 0 msecs: init_nls_iso8859_3+0x0/0x10()
[   18.213265] Calling initcall 0x78a299b0: init_nls_iso8859_5+0x0/0x10()
[   18.219765] initcall 0x78a299b0: init_nls_iso8859_5+0x0/0x10() returned 0.
[   18.226609] initcall 0x78a299b0 ran for 0 msecs: init_nls_iso8859_5+0x0/0x10()
[   18.233801] Calling initcall 0x78a299c0: init_nls_iso8859_6+0x0/0x10()
[   18.240303] initcall 0x78a299c0: init_nls_iso8859_6+0x0/0x10() returned 0.
[   18.247147] initcall 0x78a299c0 ran for 0 msecs: init_nls_iso8859_6+0x0/0x10()
[   18.254342] Calling initcall 0x78a299d0: init_nls_iso8859_15+0x0/0x10()
[   18.260928] initcall 0x78a299d0: init_nls_iso8859_15+0x0/0x10() returned 0.
[   18.267855] initcall 0x78a299d0 ran for 0 msecs: init_nls_iso8859_15+0x0/0x10()
[   18.275140] Calling initcall 0x78a299e0: init_nls_koi8_r+0x0/0x10()
[   18.281380] initcall 0x78a299e0: init_nls_koi8_r+0x0/0x10() returned 0.
[   18.287962] initcall 0x78a299e0 ran for 0 msecs: init_nls_koi8_r+0x0/0x10()
[   18.294900] Calling initcall 0x78a299f0: init_nls_koi8_u+0x0/0x10()
[   18.301138] initcall 0x78a299f0: init_nls_koi8_u+0x0/0x10() returned 0.
[   18.307720] initcall 0x78a299f0 ran for 0 msecs: init_nls_koi8_u+0x0/0x10()
[   18.314658] Calling initcall 0x78a29a00: init_nls_koi8_ru+0x0/0x40()
[   18.320987] initcall 0x78a29a00: init_nls_koi8_ru+0x0/0x40() returned 0.
[   18.327652] initcall 0x78a29a00 ran for 0 msecs: init_nls_koi8_ru+0x0/0x40()
[   18.334676] Calling initcall 0x78a29a40: init_nls_utf8+0x0/0x30()
[   18.340744] initcall 0x78a29a40: init_nls_utf8+0x0/0x30() returned 0.
[   18.347153] initcall 0x78a29a40 ran for 0 msecs: init_nls_utf8+0x0/0x30()
[   18.353914] Calling initcall 0x78a29a70: init_cifs+0x0/0x510()
[   18.359849] initcall 0x78a29a70: init_cifs+0x0/0x510() returned 0.
[   18.365867] initcall 0x78a29a70 ran for 0 msecs: init_cifs+0x0/0x510()
[   18.372369] Calling initcall 0x78a29f80: init_ncp_fs+0x0/0x60()
[   18.378270] initcall 0x78a29f80: init_ncp_fs+0x0/0x60() returned 0.
[   18.384502] initcall 0x78a29f80 ran for 0 msecs: init_ncp_fs+0x0/0x60()
[   18.391093] Calling initcall 0x78a29fe0: init_hpfs_fs+0x0/0x60()
[   18.397075] initcall 0x78a29fe0: init_hpfs_fs+0x0/0x60() returned 0.
[   18.403398] initcall 0x78a29fe0 ran for 0 msecs: init_hpfs_fs+0x0/0x60()
[   18.410069] Calling initcall 0x78a2a040: init_ntfs_fs+0x0/0x270()
[   18.416135] NTFS driver 2.1.29 [Flags: R/W DEBUG].
[   18.420913] initcall 0x78a2a040: init_ntfs_fs+0x0/0x270() returned 0.
[   18.427315] initcall 0x78a2a040 ran for 3 msecs: init_ntfs_fs+0x0/0x270()
[   18.434074] Calling initcall 0x78a2a2b0: init_romfs_fs+0x0/0x60()
[   18.440145] initcall 0x78a2a2b0: init_romfs_fs+0x0/0x60() returned 0.
[   18.446554] initcall 0x78a2a2b0 ran for 0 msecs: init_romfs_fs+0x0/0x60()
[   18.453314] Calling initcall 0x78a2a310: init_qnx4_fs+0x0/0x70()
[   18.459294] QNX4 filesystem 0.2.3 registered.
[   18.463632] initcall 0x78a2a310: init_qnx4_fs+0x0/0x70() returned 0.
[   18.469953] initcall 0x78a2a310 ran for 3 msecs: init_qnx4_fs+0x0/0x70()
[   18.476627] Calling initcall 0x78a2a380: init_autofs_fs+0x0/0x10()
[   18.482782] initcall 0x78a2a380: init_autofs_fs+0x0/0x10() returned 0.
[   18.489273] initcall 0x78a2a380 ran for 0 msecs: init_autofs_fs+0x0/0x10()
[   18.496121] Calling initcall 0x78a2a390: init_autofs4_fs+0x0/0x10()
[   18.502367] initcall 0x78a2a390: init_autofs4_fs+0x0/0x10() returned -16.
[   18.509118] initcall 0x78a2a390 ran for 0 msecs: init_autofs4_fs+0x0/0x10()
[   18.516054] initcall at 0x78a2a390: init_autofs4_fs+0x0/0x10(): returned with error code -16
[   18.524464] Calling initcall 0x78a2a3a0: init_adfs_fs+0x0/0x60()
[   18.530446] initcall 0x78a2a3a0: init_adfs_fs+0x0/0x60() returned 0.
[   18.536768] initcall 0x78a2a3a0 ran for 0 msecs: init_adfs_fs+0x0/0x60()
[   18.543441] Calling initcall 0x78a2a470: fuse_init+0x0/0x120()
[   18.549246] fuse init (API version 7.8)
[   18.553089] initcall 0x78a2a470: fuse_init+0x0/0x120() returned 0.
[   18.559208] initcall 0x78a2a470 ran for 2 msecs: fuse_init+0x0/0x120()
[   18.565710] Calling initcall 0x78a2a5a0: init_udf_fs+0x0/0x60()
[   18.571611] initcall 0x78a2a5a0: init_udf_fs+0x0/0x60() returned 0.
[   18.577843] initcall 0x78a2a5a0 ran for 0 msecs: init_udf_fs+0x0/0x60()
[   18.584436] Calling initcall 0x78a2a6d0: init_xfs_fs+0x0/0x60()
[   18.590324] SGI XFS with large block numbers, no debug enabled
[   18.596248] SGI XFS Quota Management subsystem
[   18.600572] initcall 0x78a2a6d0: init_xfs_fs+0x0/0x60() returned 0.
[   18.606800] initcall 0x78a2a6d0 ran for 9 msecs: init_xfs_fs+0x0/0x60()
[   18.613386] Calling initcall 0x78a2a730: init_v9fs+0x0/0x20()
[   18.619104] Installing v9fs 9p2000 file system support
[   18.624226] initcall 0x78a2a730: init_v9fs+0x0/0x20() returned 0.
[   18.630285] initcall 0x78a2a730 ran for 3 msecs: init_v9fs+0x0/0x20()
[   18.636697] Calling initcall 0x78a2a790: ocfs2_init+0x0/0x300()
[   18.642589] OCFS2 1.3.3
[   18.645066] initcall 0x78a2a790: ocfs2_init+0x0/0x300() returned 0.
[   18.651254] initcall 0x78a2a790 ran for 1 msecs: ocfs2_init+0x0/0x300()
[   18.657846] Calling initcall 0x78a2ab30: init_o2nm+0x0/0xd0()
[   18.663562] OCFS2 Node Manager 1.3.3
[   18.667363] initcall 0x78a2ab30: init_o2nm+0x0/0xd0() returned 0.
[   18.673304] initcall 0x78a2ab30 ran for 3 msecs: init_o2nm+0x0/0xd0()
[   18.679716] Calling initcall 0x78a2ac00: dlm_init+0x0/0x100()
[   18.685435] OCFS2 DLM 1.3.3
[   18.688228] initcall 0x78a2ac00: dlm_init+0x0/0x100() returned 0.
[   18.694273] initcall 0x78a2ac00 ran for 1 msecs: dlm_init+0x0/0x100()
[   18.700689] Calling initcall 0x78a2ad00: init_dlmfs_fs+0x0/0xd0()
[   18.706753] OCFS2 DLMFS 1.3.3
[   18.709739] OCFS2 User DLM kernel interface loaded
[   18.714475] initcall 0x78a2ad00: init_dlmfs_fs+0x0/0xd0() returned 0.
[   18.720874] initcall 0x78a2ad00 ran for 4 msecs: init_dlmfs_fs+0x0/0xd0()
[   18.727644] Calling initcall 0x78a2af10: key_proc_init+0x0/0x60()
[   18.733711] initcall 0x78a2af10: key_proc_init+0x0/0x60() returned 0.
[   18.740119] initcall 0x78a2af10 ran for 0 msecs: key_proc_init+0x0/0x60()
[   18.746878] Calling initcall 0x78a2b090: crypto_algapi_init+0x0/0x10()
[   18.753381] initcall 0x78a2b090: crypto_algapi_init+0x0/0x10() returned 0.
[   18.760224] initcall 0x78a2b090 ran for 0 msecs: crypto_algapi_init+0x0/0x10()
[   18.767417] Calling initcall 0x78a2b0c0: cryptomgr_init+0x0/0x10()
[   18.773572] initcall 0x78a2b0c0: cryptomgr_init+0x0/0x10() returned 0.
[   18.780070] initcall 0x78a2b0c0 ran for 0 msecs: cryptomgr_init+0x0/0x10()
[   18.786916] Calling initcall 0x78a2b0d0: hmac_module_init+0x0/0x10()
[   18.793258] initcall 0x78a2b0d0: hmac_module_init+0x0/0x10() returned 0.
[   18.799915] initcall 0x78a2b0d0 ran for 0 msecs: hmac_module_init+0x0/0x10()
[   18.806935] Calling initcall 0x78a2b0e0: crypto_xcbc_module_init+0x0/0x10()
[   18.813870] initcall 0x78a2b0e0: crypto_xcbc_module_init+0x0/0x10() returned 0.
[   18.821144] initcall 0x78a2b0e0 ran for 0 msecs: crypto_xcbc_module_init+0x0/0x10()
[   18.828776] Calling initcall 0x78a2b0f0: init+0x0/0x50()
[   18.834065] initcall 0x78a2b0f0: init+0x0/0x50() returned 0.
[   18.839693] initcall 0x78a2b0f0 ran for 0 msecs: init+0x0/0x50()
[   18.845669] Calling initcall 0x78a2b140: init+0x0/0x10()
[   18.850963] initcall 0x78a2b140: init+0x0/0x10() returned 0.
[   18.856592] initcall 0x78a2b140 ran for 0 msecs: init+0x0/0x10()
[   18.862566] Calling initcall 0x78a2b150: init+0x0/0x10()
[   18.867860] initcall 0x78a2b150: init+0x0/0x10() returned 0.
[   18.873490] initcall 0x78a2b150 ran for 0 msecs: init+0x0/0x10()
[   18.879464] Calling initcall 0x78a2b160: init+0x0/0x10()
[   18.884759] initcall 0x78a2b160: init+0x0/0x10() returned 0.
[   18.890390] initcall 0x78a2b160 ran for 0 msecs: init+0x0/0x10()
[   18.896369] Calling initcall 0x78a2b170: init+0x0/0x10()
[   18.901658] initcall 0x78a2b170: init+0x0/0x10() returned 0.
[   18.907288] initcall 0x78a2b170 ran for 0 msecs: init+0x0/0x10()
[   18.913268] Calling initcall 0x78a2b180: crypto_ecb_module_init+0x0/0x10()
[   18.920116] initcall 0x78a2b180: crypto_ecb_module_init+0x0/0x10() returned 0.
[   18.927307] initcall 0x78a2b180 ran for 0 msecs: crypto_ecb_module_init+0x0/0x10()
[   18.934850] Calling initcall 0x78a2b190: crypto_cbc_module_init+0x0/0x10()
[   18.941695] initcall 0x78a2b190: crypto_cbc_module_init+0x0/0x10() returned 0.
[   18.948880] initcall 0x78a2b190 ran for 0 msecs: crypto_cbc_module_init+0x0/0x10()
[   18.956428] Calling initcall 0x78a2b1a0: crypto_pcbc_module_init+0x0/0x10()
[   18.963360] initcall 0x78a2b1a0: crypto_pcbc_module_init+0x0/0x10() returned 0.
[   18.970638] initcall 0x78a2b1a0 ran for 0 msecs: crypto_pcbc_module_init+0x0/0x10()
[   18.978267] Calling initcall 0x78a2b1b0: init+0x0/0x40()
[   18.983554] initcall 0x78a2b1b0: init+0x0/0x40() returned 0.
[   18.989178] initcall 0x78a2b1b0 ran for 0 msecs: init+0x0/0x40()
[   18.995160] Calling initcall 0x78a2b1f0: init+0x0/0x10()
[   19.000451] initcall 0x78a2b1f0: init+0x0/0x10() returned 0.
[   19.006077] initcall 0x78a2b1f0 ran for 0 msecs: init+0x0/0x10()
[   19.012059] Calling initcall 0x78a2b200: init+0x0/0x10()
[   19.017351] initcall 0x78a2b200: init+0x0/0x10() returned 0.
[   19.022982] initcall 0x78a2b200 ran for 0 msecs: init+0x0/0x10()
[   19.028958] Calling initcall 0x78a2b210: init+0x0/0x40()
[   19.034254] initcall 0x78a2b210: init+0x0/0x40() returned 0.
[   19.039881] initcall 0x78a2b210 ran for 0 msecs: init+0x0/0x40()
[   19.045855] Calling initcall 0x78a2b250: aes_init+0x0/0x330()
[   19.051598] initcall 0x78a2b250: aes_init+0x0/0x330() returned 0.
[   19.057643] initcall 0x78a2b250 ran for 0 msecs: aes_init+0x0/0x330()
[   19.064059] Calling initcall 0x78a2b580: camellia_init+0x0/0x10()
[   19.070127] initcall 0x78a2b580: camellia_init+0x0/0x10() returned 0.
[   19.076538] initcall 0x78a2b580 ran for 0 msecs: camellia_init+0x0/0x10()
[   19.083298] Calling initcall 0x78a2b590: init+0x0/0x10()
[   19.088587] initcall 0x78a2b590: init+0x0/0x10() returned 0.
[   19.094214] initcall 0x78a2b590 ran for 0 msecs: init+0x0/0x10()
[   19.100196] Calling initcall 0x78a2b5a0: init+0x0/0x10()
[   19.105485] initcall 0x78a2b5a0: init+0x0/0x10() returned 0.
[   19.111113] initcall 0x78a2b5a0 ran for 0 msecs: init+0x0/0x10()
[   19.117095] Calling initcall 0x78a2b5b0: arc4_init+0x0/0x10()
[   19.122824] initcall 0x78a2b5b0: arc4_init+0x0/0x10() returned 0.
[   19.128875] initcall 0x78a2b5b0 ran for 0 msecs: arc4_init+0x0/0x10()
[   19.135291] Calling initcall 0x78a2b5c0: init+0x0/0x60()
[   19.140584] initcall 0x78a2b5c0: init+0x0/0x60() returned 0.
[   19.146213] initcall 0x78a2b5c0 ran for 0 msecs: init+0x0/0x60()
[   19.152719] Calling initcall 0x78a2b620: init+0x0/0x10()
[   19.158011] initcall 0x78a2b620: init+0x0/0x10() returned 0.
[   19.163641] initcall 0x78a2b620 ran for 0 msecs: init+0x0/0x10()
[   19.169621] Calling initcall 0x78a2b630: init+0x0/0x10()
[   19.174911] initcall 0x78a2b630: init+0x0/0x10() returned 0.
[   19.180540] initcall 0x78a2b630 ran for 0 msecs: init+0x0/0x10()
[   19.186520] Calling initcall 0x78a2b940: noop_init+0x0/0x10()
[   19.192248] io scheduler noop registered (default)
[   19.197011] initcall 0x78a2b940: noop_init+0x0/0x10() returned 0.
[   19.203072] initcall 0x78a2b940 ran for 3 msecs: noop_init+0x0/0x10()
[   19.209485] Calling initcall 0x78a2b950: deadline_init+0x0/0x10()
[   19.215550] io scheduler deadline registered
[   19.219804] initcall 0x78a2b950: deadline_init+0x0/0x10() returned 0.
[   19.226210] initcall 0x78a2b950 ran for 3 msecs: deadline_init+0x0/0x10()
[   19.232972] Calling initcall 0x78a2ba60: audit_classes_init+0x0/0x50()
[   19.239480] initcall 0x78a2ba60: audit_classes_init+0x0/0x50() returned 0.
[   19.246316] initcall 0x78a2ba60 ran for 0 msecs: audit_classes_init+0x0/0x50()
[   19.253509] Calling initcall 0x78a2be80: pci_init+0x0/0x30()
[   19.279463] Boot video device is 0000:01:00.0
[   19.283701] initcall 0x78a2be80: pci_init+0x0/0x30() returned 0.
[   19.289673] initcall 0x78a2be80 ran for 15 msecs: pci_init+0x0/0x30()
[   19.296085] Calling initcall 0x78a2d0e0: pci_proc_init+0x0/0x70()
[   19.302189] initcall 0x78a2d0e0: pci_proc_init+0x0/0x70() returned 0.
[   19.308561] initcall 0x78a2d0e0 ran for 0 msecs: pci_proc_init+0x0/0x70()
[   19.315321] Calling initcall 0x78a2d270: corgibl_init+0x0/0x10()
[   19.321318] initcall 0x78a2d270: corgibl_init+0x0/0x10() returned 0.
[   19.327627] initcall 0x78a2d270 ran for 0 msecs: corgibl_init+0x0/0x10()
[   19.334306] Calling initcall 0x78a2d280: progearbl_init+0x0/0x60()
[   19.340488] ALI M7101 PMU not found.
[   19.344036] initcall 0x78a2d280: progearbl_init+0x0/0x60() returned 0.
[   19.350509] initcall 0x78a2d280 ran for 3 msecs: progearbl_init+0x0/0x60()
[   19.357355] Calling initcall 0x78a2d3c0: rand_initialize+0x0/0x30()
[   19.363623] initcall 0x78a2d3c0: rand_initialize+0x0/0x30() returned 0.
[   19.370180] initcall 0x78a2d3c0 ran for 0 msecs: rand_initialize+0x0/0x30()
[   19.377114] Calling initcall 0x78a2d420: tty_init+0x0/0x1f0()
[   19.383734] initcall 0x78a2d420: tty_init+0x0/0x1f0() returned 0.
[   19.389671] initcall 0x78a2d420 ran for 0 msecs: tty_init+0x0/0x1f0()
[   19.396084] Calling initcall 0x78a2d640: pty_init+0x0/0x2a0()
[   19.401811] initcall 0x78a2d640: pty_init+0x0/0x2a0() returned 0.
[   19.407867] initcall 0x78a2d640 ran for 0 msecs: pty_init+0x0/0x2a0()
[   19.414285] Calling initcall 0x78a2df20: raw_init+0x0/0xd0()
[   19.419937] initcall 0x78a2df20: raw_init+0x0/0xd0() returned 0.
[   19.425890] initcall 0x78a2df20 ran for 0 msecs: raw_init+0x0/0xd0()
[   19.432219] Calling initcall 0x78a2dff0: applicom_init+0x0/0x4c0()
[   19.438373] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   19.445483] ac.o: No PCI boards found.
[   19.449210] ac.o: For an ISA board you must supply memory and irq parameters.
[   19.456319] initcall 0x78a2dff0: applicom_init+0x0/0x4c0() returned -6.
[   19.462899] initcall 0x78a2dff0 ran for 10 msecs: applicom_init+0x0/0x4c0()
[   19.469832] initcall at 0x78a2dff0: applicom_init+0x0/0x4c0(): returned with error code -6
[   19.478067] Calling initcall 0x78a2e4b0: rtc_init+0x0/0x1b0()
[   19.483829] Real Time Clock Driver v1.12ac
[   19.487866] initcall 0x78a2e4b0: rtc_init+0x0/0x1b0() returned 0.
[   19.493924] initcall 0x78a2e4b0 ran for 0 msecs: rtc_init+0x0/0x1b0()
[   19.500337] Calling initcall 0x78a2e660: nvram_init+0x0/0x80()
[   19.506168] Non-volatile memory driver v1.2
[   19.510310] initcall 0x78a2e660: nvram_init+0x0/0x80() returned 0.
[   19.516456] initcall 0x78a2e660 ran for 3 msecs: nvram_init+0x0/0x80()
[   19.522955] Calling initcall 0x78a2e6e0: i8k_init+0x0/0x250()
[   19.528679] initcall 0x78a2e6e0: i8k_init+0x0/0x250() returned -19.
[   19.534911] initcall 0x78a2e6e0 ran for 0 msecs: i8k_init+0x0/0x250()
[   19.541325] Calling initcall 0x78a2e930: mod_init+0x0/0x210()
[   19.547057] initcall 0x78a2e930: mod_init+0x0/0x210() returned -19.
[   19.553287] initcall 0x78a2e930 ran for 0 msecs: mod_init+0x0/0x210()
[   19.559700] Calling initcall 0x78a2ec30: mod_init+0x0/0xb0()
[   19.565340] initcall 0x78a2ec30: mod_init+0x0/0xb0() returned -19.
[   19.571483] initcall 0x78a2ec30 ran for 0 msecs: mod_init+0x0/0xb0()
[   19.577815] Calling initcall 0x78a2ece0: cs5535_gpio_init+0x0/0x1d0()
[   19.584227] cs5535_gpio: DIVIL not found
[   19.588132] initcall 0x78a2ece0: cs5535_gpio_init+0x0/0x1d0() returned -19.
[   19.595055] initcall 0x78a2ece0 ran for 0 msecs: cs5535_gpio_init+0x0/0x1d0()
[   19.602161] Calling initcall 0x78a2eeb0: mwave_init+0x0/0x340()
[   19.608061] smapi::smapi_init, ERROR invalid usSmapiID
[   19.613173] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   19.622445] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   19.629639] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   19.635882] initcall 0x78a2eeb0: mwave_init+0x0/0x340() returned -5.
[   19.642196] initcall 0x78a2eeb0 ran for 13 msecs: mwave_init+0x0/0x340()
[   19.648872] initcall at 0x78a2eeb0: mwave_init+0x0/0x340(): returned with error code -5
[   19.656847] Calling initcall 0x78a2f230: agp_init+0x0/0x30()
[   19.662479] Linux agpgart interface v0.102
[   19.666560] initcall 0x78a2f230: agp_init+0x0/0x30() returned 0.
[   19.672528] initcall 0x78a2f230 ran for 2 msecs: agp_init+0x0/0x30()
[   19.678856] Calling initcall 0x78a2f3d0: agp_ali_init+0x0/0x30()
[   19.684864] initcall 0x78a2f3d0: agp_ali_init+0x0/0x30() returned 0.
[   19.691162] initcall 0x78a2f3d0 ran for 0 msecs: agp_ali_init+0x0/0x30()
[   19.697840] Calling initcall 0x78a2f4e0: agp_ati_init+0x0/0x30()
[   19.703839] initcall 0x78a2f4e0: agp_ati_init+0x0/0x30() returned 0.
[   19.710145] initcall 0x78a2f4e0 ran for 0 msecs: agp_ati_init+0x0/0x30()
[   19.716817] Calling initcall 0x78a2fc80: agp_amd64_init+0x0/0xd0()
[   19.722992] initcall 0x78a2fc80: agp_amd64_init+0x0/0xd0() returned 0.
[   19.729469] initcall 0x78a2fc80 ran for 0 msecs: agp_amd64_init+0x0/0xd0()
[   19.736318] Calling initcall 0x78a2feb0: agp_nvidia_init+0x0/0x30()
[   19.742576] initcall 0x78a2feb0: agp_nvidia_init+0x0/0x30() returned 0.
[   19.749136] initcall 0x78a2feb0 ran for 0 msecs: agp_nvidia_init+0x0/0x30()
[   19.756077] Calling initcall 0x78a30030: agp_sis_init+0x0/0x30()
[   19.762077] initcall 0x78a30030: agp_sis_init+0x0/0x30() returned 0.
[   19.768377] initcall 0x78a30030 ran for 0 msecs: agp_sis_init+0x0/0x30()
[   19.775050] Calling initcall 0x78a30060: drm_core_init+0x0/0x140()
[   19.781231] [drm] Initialized drm 1.1.0 20060810
[   19.785806] initcall 0x78a30060: drm_core_init+0x0/0x140() returned 0.
[   19.792293] initcall 0x78a30060 ran for 4 msecs: drm_core_init+0x0/0x140()
[   19.799142] Calling initcall 0x78a301a0: tdfx_init+0x0/0x10()
[   19.804869] initcall 0x78a301a0: tdfx_init+0x0/0x10() returned 0.
[   19.810928] initcall 0x78a301a0 ran for 0 msecs: tdfx_init+0x0/0x10()
[   19.817343] Calling initcall 0x78a301b0: radeon_init+0x0/0x20()
[   19.823446] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[   19.829247] initcall 0x78a301b0: radeon_init+0x0/0x20() returned 0.
[   19.835468] initcall 0x78a301b0 ran for 2 msecs: radeon_init+0x0/0x20()
[   19.842057] Calling initcall 0x78a301d0: mga_init+0x0/0x20()
[   19.847695] initcall 0x78a301d0: mga_init+0x0/0x20() returned 0.
[   19.853673] initcall 0x78a301d0 ran for 0 msecs: mga_init+0x0/0x20()
[   19.859999] Calling initcall 0x78a301f0: sis_init+0x0/0x20()
[   19.865636] initcall 0x78a301f0: sis_init+0x0/0x20() returned 0.
[   19.871608] initcall 0x78a301f0 ran for 0 msecs: sis_init+0x0/0x20()
[   19.877934] Calling initcall 0x78a30210: via_init+0x0/0x20()
[   19.883578] initcall 0x78a30210: via_init+0x0/0x20() returned 0.
[   19.889549] initcall 0x78a30210 ran for 0 msecs: via_init+0x0/0x20()
[   19.895873] Calling initcall 0x78a302f0: hangcheck_init+0x0/0xb0()
[   19.902028] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   19.910958] Hangcheck: Using get_cycles().
[   19.915035] initcall 0x78a302f0: hangcheck_init+0x0/0xb0() returned 0.
[   19.921525] initcall 0x78a302f0 ran for 5 msecs: hangcheck_init+0x0/0xb0()
[   19.928371] Calling initcall 0x78a30830: serial8250_init+0x0/0x140()
[   19.934699] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   19.942650] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   19.948706] initcall 0x78a30830: serial8250_init+0x0/0x140() returned 0.
[   19.955244] initcall 0x78a30830 ran for 7 msecs: serial8250_init+0x0/0x140()
[   19.962264] Calling initcall 0x78a30f60: mca_init+0x0/0x20()
[   19.967902] initcall 0x78a30f60: mca_init+0x0/0x20() returned -19.
[   19.974048] initcall 0x78a30f60 ran for 0 msecs: mca_init+0x0/0x20()
[   19.980380] Calling initcall 0x78a30f80: jsm_init_module+0x0/0x40()
[   19.986650] initcall 0x78a30f80: jsm_init_module+0x0/0x40() returned 0.
[   19.993205] initcall 0x78a30f80 ran for 0 msecs: jsm_init_module+0x0/0x40()
[   20.000139] Calling initcall 0x78a31210: e1000_init_module+0x0/0x90()
[   20.006550] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[   20.012533] Copyright (c) 1999-2006 Intel Corporation.
[   20.017669] initcall 0x78a31210: e1000_init_module+0x0/0x90() returned 0.
[   20.024401] initcall 0x78a31210 ran for 4 msecs: e1000_init_module+0x0/0x90()
[   20.031513] Calling initcall 0x78a33200: e100_init_module+0x0/0x60()
[   20.037835] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   20.043904] e100: Copyright(c) 1999-2006 Intel Corporation
[   20.049385] initcall 0x78a33200: e100_init_module+0x0/0x60() returned 0.
[   20.056035] initcall 0x78a33200 ran for 7 msecs: e100_init_module+0x0/0x60()
[   20.063057] Calling initcall 0x78a33a10: net_olddevs_init+0x0/0x90()
[   20.069392] initcall 0x78a33a10: net_olddevs_init+0x0/0x90() returned 0.
[   20.076054] initcall 0x78a33a10 ran for 0 msecs: net_olddevs_init+0x0/0x90()
[   20.083076] Calling initcall 0x78a33b40: init_nic+0x0/0x20()
[   20.088720] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   20.096036] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   20.616198] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   20.624441] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[   20.631386] initcall 0x78a33b40: init_nic+0x0/0x20() returned 0.
[   20.637347] initcall 0x78a33b40 ran for 503 msecs: init_nic+0x0/0x20()
[   20.643848] Calling initcall 0x78a35360: rtl8139_init_module+0x0/0x20()
[   20.650452] 8139too Fast Ethernet driver 0.9.28
[   20.655307] eth1: RealTek RTL8139 at 0xb8820000, 00:c0:df:03:68:5d, IRQ 11
[   20.662052] eth1:  Identified 8139 chip type 'RTL-8139B'
[   20.667344] initcall 0x78a35360: rtl8139_init_module+0x0/0x20() returned 0.
[   20.674264] initcall 0x78a35360 ran for 6 msecs: rtl8139_init_module+0x0/0x20()
[   20.681549] Calling initcall 0x78a35d90: ipddp_init_module+0x0/0x110()
[   20.688046] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   20.695685] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
[   20.702976] initcall 0x78a35d90: ipddp_init_module+0x0/0x110() returned 0.
[   20.709815] initcall 0x78a35d90 ran for 7 msecs: ipddp_init_module+0x0/0x110()
[   20.717009] Calling initcall 0x78a35ea0: usb_irda_init+0x0/0x50()
[   20.723080] usbcore: registered new interface driver irda-usb
[   20.729333] USB IrDA support registered
[   20.733142] initcall 0x78a35ea0: usb_irda_init+0x0/0x50() returned 0.
[   20.739549] initcall 0x78a35ea0 ran for 6 msecs: usb_irda_init+0x0/0x50()
[   20.746308] Calling initcall 0x78a35ef0: w83977af_init+0x0/0x520()
[   20.752511] initcall 0x78a35ef0: w83977af_init+0x0/0x520() returned -19.
[   20.759129] initcall 0x78a35ef0 ran for 0 msecs: w83977af_init+0x0/0x520()
[   20.765983] Calling initcall 0x78a36410: donauboe_init+0x0/0x20()
[   20.772069] initcall 0x78a36410: donauboe_init+0x0/0x20() returned 0.
[   20.778457] initcall 0x78a36410 ran for 0 msecs: donauboe_init+0x0/0x20()
[   20.785216] Calling initcall 0x78a37340: smsc_ircc_init+0x0/0x5c0()
[   20.791590] initcall 0x78a37340: smsc_ircc_init+0x0/0x5c0() returned -19.
[   20.798216] initcall 0x78a37340 ran for 0 msecs: smsc_ircc_init+0x0/0x5c0()
[   20.805149] Calling initcall 0x78a37bc0: ali_ircc_init+0x0/0x6a0()
[   20.811362] initcall 0x78a37bc0: ali_ircc_init+0x0/0x6a0() returned -19.
[   20.817974] initcall 0x78a37bc0 ran for 0 msecs: ali_ircc_init+0x0/0x6a0()
[   20.824826] Calling initcall 0x78a38260: vlsi_mod_init+0x0/0x130()
[   20.831001] initcall 0x78a38260: vlsi_mod_init+0x0/0x130() returned 0.
[   20.837473] initcall 0x78a38260 ran for 0 msecs: vlsi_mod_init+0x0/0x130()
[   20.844325] Calling initcall 0x78a38c80: via_ircc_init+0x0/0x20()
[   20.850410] initcall 0x78a38c80: via_ircc_init+0x0/0x20() returned 0.
[   20.856802] initcall 0x78a38c80 ran for 0 msecs: via_ircc_init+0x0/0x20()
[   20.863561] Calling initcall 0x78a39060: irtty_sir_init+0x0/0x40()
[   20.869717] initcall 0x78a39060: irtty_sir_init+0x0/0x40() returned 0.
[   20.876213] initcall 0x78a39060 ran for 0 msecs: irtty_sir_init+0x0/0x40()
[   20.883060] Calling initcall 0x78a390a0: sir_wq_init+0x0/0x20()
[   20.888991] initcall 0x78a390a0: sir_wq_init+0x0/0x20() returned 0.
[   20.895187] initcall 0x78a390a0 ran for 0 msecs: sir_wq_init+0x0/0x20()
[   20.901776] Calling initcall 0x78a390c0: ksdazzle_init+0x0/0x20()
[   20.907850] usbcore: registered new interface driver ksdazzle-sir
[   20.913918] initcall 0x78a390c0: ksdazzle_init+0x0/0x20() returned 0.
[   20.920325] initcall 0x78a390c0 ran for 5 msecs: ksdazzle_init+0x0/0x20()
[   20.927084] Calling initcall 0x78a39100: init_netconsole+0x0/0x1a0()
[   20.933409] console [netcon0] enabled
[   27.249628] netconsole: network logging started
[   27.254137] initcall 0x78a39100: init_netconsole+0x0/0x1a0() returned 0.
[   27.260801] initcall 0x78a39100 ran for 7 msecs: init_netconsole+0x0/0x1a0()
[   27.267820] Calling initcall 0x78a39600: raid_init+0x0/0x10()
[   27.273550] initcall 0x78a39600: raid_init+0x0/0x10() returned 0.
[   27.279603] initcall 0x78a39600 ran for 0 msecs: raid_init+0x0/0x10()
[   27.286022] Calling initcall 0x78a39610: spi_transport_init+0x0/0x30()
[   27.292545] initcall 0x78a39610: spi_transport_init+0x0/0x30() returned 0.
[   27.299368] initcall 0x78a39610 ran for 0 msecs: spi_transport_init+0x0/0x30()
[   27.306563] Calling initcall 0x78a39640: fc_transport_init+0x0/0x50()
[   27.312994] initcall 0x78a39640: fc_transport_init+0x0/0x50() returned 0.
[   27.319728] initcall 0x78a39640 ran for 0 msecs: fc_transport_init+0x0/0x50()
[   27.326843] Calling initcall 0x78a39690: iscsi_transport_init+0x0/0xe0()
[   27.333511] Loading iSCSI transport class v2.0-724.
[   27.338398] initcall 0x78a39690: iscsi_transport_init+0x0/0xe0() returned 0.
[   27.345385] initcall 0x78a39690 ran for 4 msecs: iscsi_transport_init+0x0/0xe0()
[   27.352752] Calling initcall 0x78a39770: sas_transport_init+0x0/0xa0()
[   27.359304] initcall 0x78a39770: sas_transport_init+0x0/0xa0() returned 0.
[   27.366097] initcall 0x78a39770 ran for 0 msecs: sas_transport_init+0x0/0xa0()
[   27.373292] Calling initcall 0x78a39810: sas_class_init+0x0/0x40()
[   27.379445] initcall 0x78a39810: sas_class_init+0x0/0x40() returned 0.
[   27.385942] initcall 0x78a39810 ran for 0 msecs: sas_class_init+0x0/0x40()
[   27.392788] Calling initcall 0x78a39850: init_sd+0x0/0xd0()
[   27.398389] initcall 0x78a39850: init_sd+0x0/0xd0() returned 0.
[   27.404225] initcall 0x78a39850 ran for 3 msecs: init_sd+0x0/0xd0()
[   27.410465] Calling initcall 0x78a39920: init_ch_module+0x0/0xa0()
[   27.416619] SCSI Media Changer driver v0.25 
[   27.420899] initcall 0x78a39920: init_ch_module+0x0/0xa0() returned 0.
[   27.427364] initcall 0x78a39920 ran for 4 msecs: init_ch_module+0x0/0xa0()
[   27.434210] Calling initcall 0x78a39a30: ahci_init+0x0/0x20()
[   27.439962] initcall 0x78a39a30: ahci_init+0x0/0x20() returned 0.
[   27.445999] initcall 0x78a39a30 ran for 0 msecs: ahci_init+0x0/0x20()
[   27.452411] Calling initcall 0x78a39a50: piix_init+0x0/0x20()
[   27.458158] initcall 0x78a39a50: piix_init+0x0/0x20() returned 0.
[   27.464195] initcall 0x78a39a50 ran for 0 msecs: piix_init+0x0/0x20()
[   27.470607] Calling initcall 0x78a39a70: pdc_ata_init+0x0/0x20()
[   27.476613] initcall 0x78a39a70: pdc_ata_init+0x0/0x20() returned 0.
[   27.482912] initcall 0x78a39a70 ran for 0 msecs: pdc_ata_init+0x0/0x20()
[   27.489590] Calling initcall 0x78a39a90: qs_ata_init+0x0/0x20()
[   27.495503] initcall 0x78a39a90: qs_ata_init+0x0/0x20() returned 0.
[   27.501722] initcall 0x78a39a90 ran for 0 msecs: qs_ata_init+0x0/0x20()
[   27.508304] Calling initcall 0x78a39d70: vsc_sata_init+0x0/0x20()
[   27.514396] initcall 0x78a39d70: vsc_sata_init+0x0/0x20() returned 0.
[   27.520784] initcall 0x78a39d70 ran for 0 msecs: vsc_sata_init+0x0/0x20()
[   27.527543] Calling initcall 0x78a39d90: nv_init+0x0/0x20()
[   27.533120] initcall 0x78a39d90: nv_init+0x0/0x20() returned 0.
[   27.538986] initcall 0x78a39d90 ran for 0 msecs: nv_init+0x0/0x20()
[   27.545226] Calling initcall 0x78a39db0: mv_init+0x0/0x20()
[   27.550809] initcall 0x78a39db0: mv_init+0x0/0x20() returned 0.
[   27.556662] initcall 0x78a39db0 ran for 0 msecs: mv_init+0x0/0x20()
[   27.562905] Calling initcall 0x78a39dd0: inic_init+0x0/0x20()
[   27.568645] initcall 0x78a39dd0: inic_init+0x0/0x20() returned 0.
[   27.574685] initcall 0x78a39dd0 ran for 0 msecs: inic_init+0x0/0x20()
[   27.581101] Calling initcall 0x78a39df0: amd_init+0x0/0x20()
[   27.586754] pata_amd 0000:00:06.0: version 0.3.9
[   27.591447] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   27.597683] scsi0 : pata_amd
[   27.600521] scsi1 : pata_amd
[   27.603344] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   27.610242] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   27.941995] ata1.00: ATA-5: MAXTOR 6L040J2, AR1.0500, max UDMA/133
[   27.948048] ata1.00: 78177792 sectors, multi 1: LBA 
[   27.953259] ata1.01: ATA-6: ST380011A, 3.06, max UDMA/100
[   27.958534] ata1.01: 156301488 sectors, multi 1: LBA48 
[   27.975254] ata1.00: configured for UDMA/133
[   27.991920] ata1.01: configured for UDMA/100
[   28.159362] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR 6L040J2   AR1. PQ: 0 ANSI: 5
[   28.167531] sd 0:0:0:0: [sda] 78177792 512-byte hardware sectors (40027 MB)
[   28.174380] sd 0:0:0:0: [sda] Write Protect is off
[   28.179130] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   28.184183] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.193457] sd 0:0:0:0: [sda] 78177792 512-byte hardware sectors (40027 MB)
[   28.200314] sd 0:0:0:0: [sda] Write Protect is off
[   28.205060] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   28.210124] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.219123]  sda: sda1 sda2 sda3 sda4 < sda5 >
[   28.257607] sd 0:0:0:0: [sda] Attached SCSI disk
[   28.262233] scsi 0:0:1:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
[   28.270314] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
[   28.277257] sd 0:0:1:0: [sdb] Write Protect is off
[   28.282005] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   28.287058] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.296106] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
[   28.303079] sd 0:0:1:0: [sdb] Write Protect is off
[   28.307830] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   28.312884] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.321872]  sdb: sdb1 sdb2 sdb3 < sdb5 >
[   28.337075] sd 0:0:1:0: [sdb] Attached SCSI disk
[   28.341613] initcall 0x78a39df0: amd_init+0x0/0x20() returned 0.
[   28.347538] initcall 0x78a39df0 ran for 637 msecs: amd_init+0x0/0x20()
[   28.354041] Calling initcall 0x78a39e10: artop_init+0x0/0x20()
[   28.360402] initcall 0x78a39e10: artop_init+0x0/0x20() returned 0.
[   28.366529] initcall 0x78a39e10 ran for 0 msecs: artop_init+0x0/0x20()
[   28.373034] Calling initcall 0x78a39e30: atiixp_init+0x0/0x20()
[   28.378945] initcall 0x78a39e30: atiixp_init+0x0/0x20() returned 0.
[   28.385163] initcall 0x78a39e30 ran for 0 msecs: atiixp_init+0x0/0x20()
[   28.391750] Calling initcall 0x78a39e50: cmd640_init+0x0/0x20()
[   28.397664] initcall 0x78a39e50: cmd640_init+0x0/0x20() returned 0.
[   28.403879] initcall 0x78a39e50 ran for 0 msecs: cmd640_init+0x0/0x20()
[   28.410466] Calling initcall 0x78a39e70: cmd64x_init+0x0/0x20()
[   28.416388] initcall 0x78a39e70: cmd64x_init+0x0/0x20() returned 0.
[   28.422601] initcall 0x78a39e70 ran for 0 msecs: cmd64x_init+0x0/0x20()
[   28.429187] Calling initcall 0x78a39e90: cs5535_init+0x0/0x20()
[   28.435102] initcall 0x78a39e90: cs5535_init+0x0/0x20() returned 0.
[   28.441314] initcall 0x78a39e90 ran for 0 msecs: cs5535_init+0x0/0x20()
[   28.447903] Calling initcall 0x78a39eb0: cy82c693_init+0x0/0x20()
[   28.453994] initcall 0x78a39eb0: cy82c693_init+0x0/0x20() returned 0.
[   28.460383] initcall 0x78a39eb0 ran for 0 msecs: cy82c693_init+0x0/0x20()
[   28.467142] Calling initcall 0x78a39ed0: hpt37x_init+0x0/0x20()
[   28.473063] initcall 0x78a39ed0: hpt37x_init+0x0/0x20() returned 0.
[   28.479278] initcall 0x78a39ed0 ran for 0 msecs: hpt37x_init+0x0/0x20()
[   28.485864] Calling initcall 0x78a39ef0: hpt3x2n_init+0x0/0x20()
[   28.491866] initcall 0x78a39ef0: hpt3x2n_init+0x0/0x20() returned 0.
[   28.498165] initcall 0x78a39ef0 ran for 0 msecs: hpt3x2n_init+0x0/0x20()
[   28.504840] Calling initcall 0x78a39f10: hpt3x3_init+0x0/0x20()
[   28.510758] initcall 0x78a39f10: hpt3x3_init+0x0/0x20() returned 0.
[   28.516972] initcall 0x78a39f10 ran for 0 msecs: hpt3x3_init+0x0/0x20()
[   28.523564] Calling initcall 0x78a39f30: it8213_init+0x0/0x20()
[   28.529477] initcall 0x78a39f30: it8213_init+0x0/0x20() returned 0.
[   28.535694] initcall 0x78a39f30 ran for 0 msecs: it8213_init+0x0/0x20()
[   28.542280] Calling initcall 0x78a39f50: netcell_init+0x0/0x20()
[   28.548288] initcall 0x78a39f50: netcell_init+0x0/0x20() returned 0.
[   28.554581] initcall 0x78a39f50 ran for 0 msecs: netcell_init+0x0/0x20()
[   28.561256] Calling initcall 0x78a39f70: ns87410_init+0x0/0x20()
[   28.567261] initcall 0x78a39f70: ns87410_init+0x0/0x20() returned 0.
[   28.573562] initcall 0x78a39f70 ran for 0 msecs: ns87410_init+0x0/0x20()
[   28.580241] Calling initcall 0x78a39f90: ns87415_init+0x0/0x20()
[   28.586267] initcall 0x78a39f90: ns87415_init+0x0/0x20() returned 0.
[   28.592543] initcall 0x78a39f90 ran for 0 msecs: ns87415_init+0x0/0x20()
[   28.599217] Calling initcall 0x78a39fb0: opti_init+0x0/0x20()
[   28.604958] initcall 0x78a39fb0: opti_init+0x0/0x20() returned 0.
[   28.610998] initcall 0x78a39fb0 ran for 0 msecs: opti_init+0x0/0x20()
[   28.617412] Calling initcall 0x78a39fd0: marvell_init+0x0/0x20()
[   28.623412] initcall 0x78a39fd0: marvell_init+0x0/0x20() returned 0.
[   28.629718] initcall 0x78a39fd0 ran for 0 msecs: marvell_init+0x0/0x20()
[   28.636397] Calling initcall 0x78a39ff0: mpiix_init+0x0/0x20()
[   28.642217] initcall 0x78a39ff0: mpiix_init+0x0/0x20() returned 0.
[   28.648354] initcall 0x78a39ff0 ran for 0 msecs: mpiix_init+0x0/0x20()
[   28.654856] Calling initcall 0x78a3a010: oldpiix_init+0x0/0x20()
[   28.660850] initcall 0x78a3a010: oldpiix_init+0x0/0x20() returned 0.
[   28.667156] initcall 0x78a3a010 ran for 0 msecs: oldpiix_init+0x0/0x20()
[   28.673829] Calling initcall 0x78a3a030: pdc202xx_init+0x0/0x20()
[   28.679916] initcall 0x78a3a030: pdc202xx_init+0x0/0x20() returned 0.
[   28.686308] initcall 0x78a3a030 ran for 0 msecs: pdc202xx_init+0x0/0x20()
[   28.693073] Calling initcall 0x78a3a050: serverworks_init+0x0/0x20()
[   28.699414] initcall 0x78a3a050: serverworks_init+0x0/0x20() returned 0.
[   28.706064] initcall 0x78a3a050 ran for 0 msecs: serverworks_init+0x0/0x20()
[   28.713091] Calling initcall 0x78a3a4b0: sil680_init+0x0/0x20()
[   28.719000] initcall 0x78a3a4b0: sil680_init+0x0/0x20() returned 0.
[   28.725222] initcall 0x78a3a4b0 ran for 0 msecs: sil680_init+0x0/0x20()
[   28.731808] Calling initcall 0x78a3a4d0: via_init+0x0/0x20()
[   28.737460] initcall 0x78a3a4d0: via_init+0x0/0x20() returned 0.
[   28.743418] initcall 0x78a3a4d0 ran for 0 msecs: via_init+0x0/0x20()
[   28.749749] Calling initcall 0x78a3a4f0: triflex_init+0x0/0x20()
[   28.755744] initcall 0x78a3a4f0: triflex_init+0x0/0x20() returned 0.
[   28.762053] initcall 0x78a3a4f0 ran for 0 msecs: triflex_init+0x0/0x20()
[   28.768726] Calling initcall 0x78a3a510: pata_platform_init+0x0/0x10()
[   28.775237] initcall 0x78a3a510: pata_platform_init+0x0/0x10() returned 0.
[   28.782072] initcall 0x78a3a510 ran for 0 msecs: pata_platform_init+0x0/0x10()
[   28.789265] Calling initcall 0x78a3a880: ata_generic_init+0x0/0x20()
[   28.795609] initcall 0x78a3a880: ata_generic_init+0x0/0x20() returned 0.
[   28.802264] initcall 0x78a3a880 ran for 0 msecs: ata_generic_init+0x0/0x20()
[   28.809283] Calling initcall 0x78a3a8a0: i2o_iop_init+0x0/0x50()
[   28.815261] I2O subsystem v1.325
[   28.818472] i2o: max drivers = 8
[   28.821766] initcall 0x78a3a8a0: i2o_iop_init+0x0/0x50() returned 0.
[   28.827997] initcall 0x78a3a8a0 ran for 6 msecs: i2o_iop_init+0x0/0x50()
[   28.834672] Calling initcall 0x78a3b210: i2o_config_init+0x0/0xa0()
[   28.840913] I2O Configuration OSM v1.323
[   28.844853] initcall 0x78a3b210: i2o_config_init+0x0/0xa0() returned 0.
[   28.851395] initcall 0x78a3b210 ran for 6 msecs: i2o_config_init+0x0/0xa0()
[   28.858337] Calling initcall 0x78a3b2b0: i2o_bus_init+0x0/0x40()
[   28.864312] I2O Bus Adapter OSM v1.317
[   28.868057] initcall 0x78a3b2b0: i2o_bus_init+0x0/0x40() returned 0.
[   28.874361] initcall 0x78a3b2b0 ran for 2 msecs: i2o_bus_init+0x0/0x40()
[   28.881036] Calling initcall 0x78a3b2f0: i2o_block_init+0x0/0x120()
[   28.887277] I2O Block Device OSM v1.325
[   28.891222] initcall 0x78a3b2f0: i2o_block_init+0x0/0x120() returned 0.
[   28.897673] initcall 0x78a3b2f0 ran for 3 msecs: i2o_block_init+0x0/0x120()
[   28.904608] Calling initcall 0x78a3b410: i2o_proc_init+0x0/0x190()
[   28.910762] I2O ProcFS OSM v1.316
[   28.914071] initcall 0x78a3b410: i2o_proc_init+0x0/0x190() returned 0.
[   28.920554] initcall 0x78a3b410 ran for 2 msecs: i2o_proc_init+0x0/0x190()
[   28.927399] Calling initcall 0x78a3b5a0: fusion_init+0x0/0x110()
[   28.933382] Fusion MPT base driver 3.04.06
[   28.937458] Copyright (c) 1999-2007 LSI Corporation
[   28.942319] initcall 0x78a3b5a0: fusion_init+0x0/0x110() returned 0.
[   28.948634] initcall 0x78a3b5a0 ran for 8 msecs: fusion_init+0x0/0x110()
[   28.955307] Calling initcall 0x78a3b6b0: mptspi_init+0x0/0xd0()
[   28.961199] Fusion MPT SPI Host driver 3.04.06
[   28.965645] initcall 0x78a3b6b0: mptspi_init+0x0/0xd0() returned 0.
[   28.971859] initcall 0x78a3b6b0 ran for 3 msecs: mptspi_init+0x0/0xd0()
[   28.978446] Calling initcall 0x78a3b780: mptfc_init+0x0/0xf0()
[   28.984251] Fusion MPT FC Host driver 3.04.06
[   28.988612] initcall 0x78a3b780: mptfc_init+0x0/0xf0() returned 0.
[   28.994732] initcall 0x78a3b780 ran for 3 msecs: mptfc_init+0x0/0xf0()
[   29.001235] Calling initcall 0x78a3b870: mptsas_init+0x0/0xf0()
[   29.007129] Fusion MPT SAS Host driver 3.04.06
[   29.011577] initcall 0x78a3b870: mptsas_init+0x0/0xf0() returned 0.
[   29.017785] initcall 0x78a3b870 ran for 3 msecs: mptsas_init+0x0/0xf0()
[   29.024374] Calling initcall 0x78a3b960: mptctl_init+0x0/0x100()
[   29.030355] Fusion MPT misc device (ioctl) driver 3.04.06
[   29.035742] mptctl: Registered with Fusion MPT base driver
[   29.041194] mptctl: /dev/mptctl @ (major,minor=10,220)
[   29.046308] initcall 0x78a3b960: mptctl_init+0x0/0x100() returned 0.
[   29.052628] initcall 0x78a3b960 ran for 8 msecs: mptctl_init+0x0/0x100()
[   29.059300] Calling initcall 0x78a3ba60: ieee1394_init+0x0/0x250()
[   29.065547] initcall 0x78a3ba60: ieee1394_init+0x0/0x250() returned 0.
[   29.071953] initcall 0x78a3ba60 ran for 0 msecs: ieee1394_init+0x0/0x250()
[   29.078800] Calling initcall 0x78a3bcb0: ohci1394_init+0x0/0x20()
[   29.084888] initcall 0x78a3bcb0: ohci1394_init+0x0/0x20() returned 0.
[   29.091274] initcall 0x78a3bcb0 ran for 0 msecs: ohci1394_init+0x0/0x20()
[   29.098035] Calling initcall 0x78a3c720: video1394_init_module+0x0/0xc0()
[   29.104813] video1394: Installed video1394 module
[   29.109484] initcall 0x78a3c720: video1394_init_module+0x0/0xc0() returned 0.
[   29.116580] initcall 0x78a3c720 ran for 4 msecs: video1394_init_module+0x0/0xc0()
[   29.124039] Calling initcall 0x78537590: sbp2_module_init+0x0/0xa0()
[   29.130374] initcall 0x78537590: sbp2_module_init+0x0/0xa0() returned 0.
[   29.137033] initcall 0x78537590 ran for 0 msecs: sbp2_module_init+0x0/0xa0()
[   29.144052] Calling initcall 0x78a3c7e0: dv1394_init_module+0x0/0xc0()
[   29.150554] NOTE: The dv1394 driver is unsupported and may be removed in a future Linux release. Use raw1394 instead.
[   29.161145] initcall 0x78a3c7e0: dv1394_init_module+0x0/0xc0() returned 0.
[   29.167969] initcall 0x78a3c7e0 ran for 3 msecs: dv1394_init_module+0x0/0xc0()
[   29.175169] Calling initcall 0x78a3c8a0: ether1394_init_module+0x0/0x70()
[   29.181938] initcall 0x78a3c8a0: ether1394_init_module+0x0/0x70() returned 0.
[   29.189033] initcall 0x78a3c8a0 ran for 0 msecs: ether1394_init_module+0x0/0x70()
[   29.196488] Calling initcall 0x78a3c910: uio_init+0x0/0x10()
[   29.202121] initcall 0x78a3c910: uio_init+0x0/0x10() returned 0.
[   29.208093] initcall 0x78a3c910 ran for 0 msecs: uio_init+0x0/0x10()
[   29.214422] Calling initcall 0x78a3ca30: at25_init+0x0/0x10()
[   29.220152] initcall 0x78a3ca30: at25_init+0x0/0x10() returned 0.
[   29.226207] initcall 0x78a3ca30 ran for 0 msecs: at25_init+0x0/0x10()
[   29.232623] Calling initcall 0x78a3ca40: tle62x0_init+0x0/0x10()
[   29.238611] initcall 0x78a3ca40: tle62x0_init+0x0/0x10() returned 0.
[   29.244929] initcall 0x78a3ca40 ran for 0 msecs: tle62x0_init+0x0/0x10()
[   29.251605] Calling initcall 0x78a3cc00: kvm_init+0x0/0x120()
[   29.257401] initcall 0x78a3cc00: kvm_init+0x0/0x120() returned 0.
[   29.263385] initcall 0x78a3cc00 ran for 0 msecs: kvm_init+0x0/0x120()
[   29.269804] Calling initcall 0x78a3d070: vmx_init+0x0/0x110()
[   29.275532] kvm: no hardware support
[   29.279083] initcall 0x78a3d070: vmx_init+0x0/0x110() returned -95.
[   29.285314] initcall 0x78a3d070 ran for 3 msecs: vmx_init+0x0/0x110()
[   29.291727] initcall at 0x78a3d070: vmx_init+0x0/0x110(): returned with error code -95
[   29.299615] Calling initcall 0x78a3d180: svm_init+0x0/0x20()
[   29.305244] has_svm: svm not available
[   29.308975] kvm: no hardware support
[   29.312531] initcall 0x78a3d180: svm_init+0x0/0x20() returned -95.
[   29.318678] initcall 0x78a3d180 ran for 6 msecs: svm_init+0x0/0x20()
[   29.325004] initcall at 0x78a3d180: svm_init+0x0/0x20(): returned with error code -95
[   29.332804] Calling initcall 0x78a3d4c0: mon_init+0x0/0x120()
[   29.338571] initcall 0x78a3d4c0: mon_init+0x0/0x120() returned 0.
[   29.344584] initcall 0x78a3d4c0 ran for 0 msecs: mon_init+0x0/0x120()
[   29.351000] Calling initcall 0x78a3db40: ehci_hcd_init+0x0/0x20()
[   29.357129] PCI: No IRQ known for interrupt pin B of device 0000:00:02.1. Probably buggy MP table.
[   29.365999] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[   29.374414] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[   29.380227] initcall 0x78a3db40: ehci_hcd_init+0x0/0x20() returned 0.
[   29.386617] initcall 0x78a3db40 ran for 9 msecs: ehci_hcd_init+0x0/0x20()
[   29.393382] Calling initcall 0x78a3db60: isp116x_init+0x0/0x40()
[   29.399357] 116x: driver isp116x-hcd, 03 Nov 2005
[   29.404060] initcall 0x78a3db60: isp116x_init+0x0/0x40() returned 0.
[   29.410362] initcall 0x78a3db60 ran for 1 msecs: isp116x_init+0x0/0x40()
[   29.417564] Calling initcall 0x78a3de80: ohci_hcd_mod_init+0x0/0x70()
[   29.423978] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   29.431502] PCI: No IRQ known for interrupt pin A of device 0000:00:02.0. Probably buggy MP table.
[   29.440362] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[   29.448776] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[   29.454605] initcall 0x78a3de80: ohci_hcd_mod_init+0x0/0x70() returned 0.
[   29.461325] initcall 0x78a3de80 ran for 13 msecs: ohci_hcd_mod_init+0x0/0x70()
[   29.468526] Calling initcall 0x78a3df50: uhci_hcd_init+0x0/0xb0()
[   29.474589] USB Universal Host Controller Interface driver v3.0
[   29.480512] initcall 0x78a3df50: uhci_hcd_init+0x0/0xb0() returned 0.
[   29.486893] initcall 0x78a3df50 ran for 1 msecs: uhci_hcd_init+0x0/0xb0()
[   29.493653] Calling initcall 0x78a3e000: r8a66597_init+0x0/0x50()
[   29.499720] drivers/usb/host/r8a66597-hcd.c: driver r8a66597_hcd, 29 May 2007
[   29.506850] initcall 0x78a3e000: r8a66597_init+0x0/0x50() returned 0.
[   29.513238] initcall 0x78a3e000 ran for 3 msecs: r8a66597_init+0x0/0x50()
[   29.520003] Calling initcall 0x78a3e2e0: usblp_init+0x0/0x20()
[   29.525819] usbcore: registered new interface driver usblp
[   29.531274] initcall 0x78a3e2e0: usblp_init+0x0/0x20() returned 0.
[   29.537414] initcall 0x78a3e2e0 ran for 2 msecs: usblp_init+0x0/0x20()
[   29.543916] Calling initcall 0x78a3e300: usb_stor_init+0x0/0x50()
[   29.549984] Initializing USB Mass Storage driver...
[   29.554854] usbcore: registered new interface driver usb-storage
[   29.560821] USB Mass Storage support registered.
[   29.565425] initcall 0x78a3e300: usb_stor_init+0x0/0x50() returned 0.
[   29.571824] initcall 0x78a3e300 ran for 11 msecs: usb_stor_init+0x0/0x50()
[   29.578670] Calling initcall 0x78a3e350: usb_usual_init+0x0/0x50()
[   29.584841] usbcore: registered new interface driver libusual
[   29.590550] initcall 0x78a3e350: usb_usual_init+0x0/0x50() returned 0.
[   29.597040] initcall 0x78a3e350 ran for 2 msecs: usb_usual_init+0x0/0x50()
[   29.603886] Calling initcall 0x78a3e3a0: usb_mdc800_init+0x0/0x230()
[   29.610228] usbcore: registered new interface driver mdc800
[   29.615765] drivers/usb/image/mdc800.c: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   29.625127] initcall 0x78a3e3a0: usb_mdc800_init+0x0/0x230() returned 0.
[   29.631794] initcall 0x78a3e3a0 ran for 7 msecs: usb_mdc800_init+0x0/0x230()
[   29.638813] Calling initcall 0x78a3e5d0: microtek_drv_init+0x0/0x20()
[   29.645236] usbcore: registered new interface driver microtekX6
[   29.651126] initcall 0x78a3e5d0: microtek_drv_init+0x0/0x20() returned 0.
[   29.657873] initcall 0x78a3e5d0 ran for 2 msecs: microtek_drv_init+0x0/0x20()
[   29.664987] Calling initcall 0x78a3e5f0: usb_serial_init+0x0/0x260()
[   29.671358] usbcore: registered new interface driver usbserial
[   29.677134] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   29.685018] usbcore: registered new interface driver usbserial_generic
[   29.691506] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   29.697749] initcall 0x78a3e5f0: usb_serial_init+0x0/0x260() returned 0.
[   29.704410] initcall 0x78a3e5f0 ran for 11 msecs: usb_serial_init+0x0/0x260()
[   29.711524] Calling initcall 0x78a3e850: aircable_init+0x0/0x40()
[   29.717599] drivers/usb/serial/usb-serial.c: USB Serial support registered for aircable
[   29.725576] usbcore: registered new interface driver aircable
[   29.731287] initcall 0x78a3e850: aircable_init+0x0/0x40() returned 0.
[   29.737687] initcall 0x78a3e850 ran for 5 msecs: aircable_init+0x0/0x40()
[   29.744450] Calling initcall 0x78a3e890: airprime_init+0x0/0x60()
[   29.750530] drivers/usb/serial/usb-serial.c: USB Serial support registered for airprime
[   29.758508] usbcore: registered new interface driver airprime
[   29.764219] initcall 0x78a3e890: airprime_init+0x0/0x60() returned 0.
[   29.770622] initcall 0x78a3e890 ran for 5 msecs: airprime_init+0x0/0x60()
[   29.777381] Calling initcall 0x78a3e8f0: ark3116_init+0x0/0x40()
[   29.783374] drivers/usb/serial/usb-serial.c: USB Serial support registered for ark3116
[   29.791264] usbcore: registered new interface driver ark3116
[   29.796891] initcall 0x78a3e8f0: ark3116_init+0x0/0x40() returned 0.
[   29.803207] initcall 0x78a3e8f0 ran for 6 msecs: ark3116_init+0x0/0x40()
[   29.809885] Calling initcall 0x78a3e930: cypress_init+0x0/0xd0()
[   29.815860] drivers/usb/serial/cypress_m8.c: cypress_init
[   29.821249] drivers/usb/serial/usb-serial.c: USB Serial support registered for DeLorme Earthmate USB
[   29.830350] drivers/usb/serial/usb-serial.c: USB Serial support registered for HID->COM RS232 Adapter
[   29.839535] drivers/usb/serial/usb-serial.c: USB Serial support registered for Nokia CA-42 V2 Adapter
[   29.848721] usbcore: registered new interface driver cypress
[   29.854343] drivers/usb/serial/cypress_m8.c: Cypress USB to Serial Driver v1.09
[   29.861625] initcall 0x78a3e930: cypress_init+0x0/0xd0() returned 0.
[   29.867940] initcall 0x78a3e930 ran for 18 msecs: cypress_init+0x0/0xd0()
[   29.874708] Calling initcall 0x78a3ea00: debug_init+0x0/0x40()
[   29.880522] drivers/usb/serial/usb-serial.c: USB Serial support registered for debug
[   29.888239] usbcore: registered new interface driver debug
[   29.893692] initcall 0x78a3ea00: debug_init+0x0/0x40() returned 0.
[   29.899834] initcall 0x78a3ea00 ran for 5 msecs: debug_init+0x0/0x40()
[   29.906339] Calling initcall 0x78a3ea40: empeg_init+0x0/0x120()
[   29.912270] drivers/usb/serial/usb-serial.c: USB Serial support registered for empeg
[   29.919957] usbcore: registered new interface driver empeg
[   29.925405] drivers/usb/serial/empeg.c: v1.2:USB Empeg Mark I/II Driver
[   29.931994] initcall 0x78a3ea40: empeg_init+0x0/0x120() returned 0.
[   29.938227] initcall 0x78a3ea40 ran for 9 msecs: empeg_init+0x0/0x120()
[   29.944817] Calling initcall 0x78a3eb60: ftdi_init+0x0/0xf0()
[   29.950544] drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
[   29.959734] usbcore: registered new interface driver ftdi_sio
[   29.965442] drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
[   29.973072] initcall 0x78a3eb60: ftdi_init+0x0/0xf0() returned 0.
[   29.979131] initcall 0x78a3eb60 ran for 7 msecs: ftdi_init+0x0/0xf0()
[   29.985545] Calling initcall 0x78a3ec50: funsoft_init+0x0/0x40()
[   29.991534] drivers/usb/serial/usb-serial.c: USB Serial support registered for funsoft
[   29.999426] usbcore: registered new interface driver funsoft
[   30.005051] initcall 0x78a3ec50: funsoft_init+0x0/0x40() returned 0.
[   30.011370] initcall 0x78a3ec50 ran for 6 msecs: funsoft_init+0x0/0x40()
[   30.018044] Calling initcall 0x78a3ec90: hp49gp_init+0x0/0x70()
[   30.023946] drivers/usb/serial/usb-serial.c: USB Serial support registered for hp4X
[   30.031578] usbcore: registered new interface driver hp4X
[   30.036939] drivers/usb/serial/hp4x.c: HP4x (48/49) Generic Serial driver v1.00
[   30.044220] initcall 0x78a3ec90: hp49gp_init+0x0/0x70() returned 0.
[   30.050451] initcall 0x78a3ec90 ran for 8 msecs: hp49gp_init+0x0/0x70()
[   30.057037] Calling initcall 0x7858aff0: usb_ipw_init+0x0/0x70()
[   30.063030] drivers/usb/serial/usb-serial.c: USB Serial support registered for IPWireless converter
[   30.072049] usbcore: registered new interface driver ipwtty
[   30.077582] drivers/usb/serial/ipw.c: IPWireless tty driver v0.3
[   30.083564] initcall 0x7858aff0: usb_ipw_init+0x0/0x70() returned 0.
[   30.089882] initcall 0x7858aff0 ran for 10 msecs: usb_ipw_init+0x0/0x70()
[   30.096646] Calling initcall 0x78a3ed00: keyspan_pda_init+0x0/0xa0()
[   30.102981] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA
[   30.111218] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA - (prerenumeration)
[   30.121184] drivers/usb/serial/usb-serial.c: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[   30.132017] usbcore: registered new interface driver keyspan_pda
[   30.137986] drivers/usb/serial/keyspan_pda.c: USB Keyspan PDA Converter driver v1.1
[   30.145614] initcall 0x78a3ed00: keyspan_pda_init+0x0/0xa0() returned 0.
[   30.152280] initcall 0x78a3ed00 ran for 18 msecs: keyspan_pda_init+0x0/0xa0()
[   30.159389] Calling initcall 0x78a3eda0: klsi_105_init+0x0/0x70()
[   30.165463] drivers/usb/serial/usb-serial.c: USB Serial support registered for KL5KUSB105D / PalmConnect
[   30.174914] usbcore: registered new interface driver kl5kusb105d
[   30.180882] drivers/usb/serial/kl5kusb105.c: KLSI KL5KUSB105 chipset USB->Serial Converter driver v0.3a
[   30.190244] initcall 0x78a3eda0: klsi_105_init+0x0/0x70() returned 0.
[   30.196648] initcall 0x78a3eda0 ran for 7 msecs: klsi_105_init+0x0/0x70()
[   30.203413] Calling initcall 0x78a3ee10: moschip7720_init+0x0/0x90()
[   30.209747] drivers/usb/serial/usb-serial.c: USB Serial support registered for Moschip 2 port adapter
[   30.218926] drivers/usb/serial/mos7720.c: Moschip USB Serial Driver 1.0.0.4F
[   30.225956] usbcore: registered new interface driver moschip7720
[   30.231930] initcall 0x78a3ee10: moschip7720_init+0x0/0x90() returned 0.
[   30.238595] initcall 0x78a3ee10 ran for 11 msecs: moschip7720_init+0x0/0x90()
[   30.245701] Calling initcall 0x78a3eea0: moschip7840_init+0x0/0xf0()
[   30.252038] drivers/usb/serial/usb-serial.c: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[   30.262344] drivers/usb/serial/mos7840.c: Moschip 7840/7820 USB Serial Driver 1.3.1
[   30.269981] usbcore: registered new interface driver mos7840
[   30.275607] initcall 0x78a3eea0: moschip7840_init+0x0/0xf0() returned 0.
[   30.282272] initcall 0x78a3eea0 ran for 9 msecs: moschip7840_init+0x0/0xf0()
[   30.289292] Calling initcall 0x78a3ef90: omninet_init+0x0/0x70()
[   30.295281] drivers/usb/serial/usb-serial.c: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[   30.305080] usbcore: registered new interface driver omninet
[   30.310700] drivers/usb/serial/omninet.c: v1.1:USB ZyXEL omni.net LCD PLUS Driver
[   30.318156] initcall 0x78a3ef90: omninet_init+0x0/0x70() returned 0.
[   30.324471] initcall 0x78a3ef90 ran for 9 msecs: omninet_init+0x0/0x70()
[   30.331146] Calling initcall 0x78a3f000: sierra_init+0x0/0x80()
[   30.337052] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sierra USB modem (1 port)
[   30.346504] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sierra USB modem (3 port)
[   30.355950] usbcore: registered new interface driver sierra
[   30.361485] drivers/usb/serial/sierra.c: USB Driver for Sierra Wireless USB modems: v.1.2.5b
[   30.369892] initcall 0x78a3f000: sierra_init+0x0/0x80() returned 0.
[   30.376123] initcall 0x78a3f000 ran for 11 msecs: sierra_init+0x0/0x80()
[   30.382801] Calling initcall 0x78a3f080: whiteheat_init+0x0/0x80()
[   30.388962] drivers/usb/serial/usb-serial.c: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[   30.400622] drivers/usb/serial/usb-serial.c: USB Serial support registered for Connect Tech - WhiteHEAT
[   30.409983] usbcore: registered new interface driver whiteheat
[   30.415777] drivers/usb/serial/whiteheat.c: USB ConnectTech WhiteHEAT driver v2.0
[   30.423233] initcall 0x78a3f080: whiteheat_init+0x0/0x80() returned 0.
[   30.429723] initcall 0x78a3f080 ran for 10 msecs: whiteheat_init+0x0/0x80()
[   30.436662] Calling initcall 0x78a3f100: appledisplay_init+0x0/0x50()
[   30.443119] usbcore: registered new interface driver appledisplay
[   30.449146] initcall 0x78a3f100: appledisplay_init+0x0/0x50() returned 0.
[   30.455892] initcall 0x78a3f100 ran for 5 msecs: appledisplay_init+0x0/0x50()
[   30.463007] Calling initcall 0x78a3f150: auerswald_init+0x0/0x40()
[   30.469161] usbcore: registered new interface driver auerswald
[   30.474969] initcall 0x78a3f150: auerswald_init+0x0/0x40() returned 0.
[   30.481463] initcall 0x78a3f150 ran for 2 msecs: auerswald_init+0x0/0x40()
[   30.488311] Calling initcall 0x78a3f190: berry_init+0x0/0x20()
[   30.494120] usbcore: registered new interface driver berry_charge
[   30.500189] initcall 0x78a3f190: berry_init+0x0/0x20() returned 0.
[   30.506332] initcall 0x78a3f190 ran for 1 msecs: berry_init+0x0/0x20()
[   30.512837] Calling initcall 0x78a3f1b0: emi26_init+0x0/0x20()
[   30.518644] usbcore: registered new interface driver emi26 - firmware loader
[   30.525666] initcall 0x78a3f1b0: emi26_init+0x0/0x20() returned 0.
[   30.531813] initcall 0x78a3f1b0 ran for 3 msecs: emi26_init+0x0/0x20()
[   30.538312] Calling initcall 0x78a3f1d0: usb_idmouse_init+0x0/0x50()
[   30.544643] drivers/usb/misc/idmouse.c: Siemens ID Mouse FingerTIP Sensor Driver 0.6
[   30.552361] usbcore: registered new interface driver idmouse
[   30.557991] initcall 0x78a3f1d0: usb_idmouse_init+0x0/0x50() returned 0.
[   30.564657] initcall 0x78a3f1d0 ran for 6 msecs: usb_idmouse_init+0x0/0x50()
[   30.571680] Calling initcall 0x78a3f220: ld_usb_init+0x0/0x40()
[   30.577575] usbcore: registered new interface driver ldusb
[   30.583037] initcall 0x78a3f220: ld_usb_init+0x0/0x40() returned 0.
[   30.589264] initcall 0x78a3f220 ran for 1 msecs: ld_usb_init+0x0/0x40()
[   30.595857] Calling initcall 0x78a3f260: usb_led_init+0x0/0x40()
[   30.601840] usbcore: registered new interface driver usbled
[   30.607388] initcall 0x78a3f260: usb_led_init+0x0/0x40() returned 0.
[   30.613706] initcall 0x78a3f260 ran for 2 msecs: usb_led_init+0x0/0x40()
[   30.620377] Calling initcall 0x78a3f2a0: lego_usb_tower_init+0x0/0xa0()
[   30.626972] usbcore: registered new interface driver legousbtower
[   30.633036] drivers/usb/misc/legousbtower.c: LEGO USB Tower Driver v0.96
[   30.639713] initcall 0x78a3f2a0: lego_usb_tower_init+0x0/0xa0() returned 0.
[   30.646637] initcall 0x78a3f2a0 ran for 5 msecs: lego_usb_tower_init+0x0/0xa0()
[   30.653921] Calling initcall 0x78a3f340: init_phidget+0x0/0x20()
[   30.659905] initcall 0x78a3f340: init_phidget+0x0/0x20() returned 0.
[   30.666221] initcall 0x78a3f340 ran for 0 msecs: init_phidget+0x0/0x20()
[   30.672900] Calling initcall 0x78a3f360: tv_init+0x0/0x60()
[   30.678455] usbcore: registered new interface driver trancevibrator
[   30.684688] drivers/usb/misc/trancevibrator.c: v1.1:PlayStation 2 Trance Vibrator driver
[   30.692750] initcall 0x78a3f360: tv_init+0x0/0x60() returned 0.
[   30.698636] initcall 0x78a3f360 ran for 4 msecs: tv_init+0x0/0x60()
[   30.704876] Calling initcall 0x78a3f3c0: usb_sisusb_init+0x0/0x20()
[   30.711125] usbcore: registered new interface driver sisusb
[   30.716669] initcall 0x78a3f3c0: usb_sisusb_init+0x0/0x20() returned 0.
[   30.723245] initcall 0x78a3f3c0 ran for 1 msecs: usb_sisusb_init+0x0/0x20()
[   30.730183] Calling initcall 0x78a3fcc0: i8042_init+0x0/0xe0()
[   30.738429] serio: i8042 KBD port at 0x60,0x64 irq 1
[   30.743287] serio: i8042 AUX port at 0x60,0x64 irq 12
[   30.748304] initcall 0x78a3fcc0: i8042_init+0x0/0xe0() returned 0.
[   30.754440] initcall 0x78a3fcc0 ran for 8 msecs: i8042_init+0x0/0xe0()
[   30.760943] Calling initcall 0x78a3fda0: pcips2_init+0x0/0x20()
[   30.766865] initcall 0x78a3fda0: pcips2_init+0x0/0x20() returned 0.
[   30.773076] initcall 0x78a3fda0 ran for 0 msecs: pcips2_init+0x0/0x20()
[   30.779667] Calling initcall 0x78a3fee0: serio_raw_init+0x0/0x20()
[   30.785835] initcall 0x78a3fee0: serio_raw_init+0x0/0x20() returned 0.
[   30.792317] initcall 0x78a3fee0 ran for 0 msecs: serio_raw_init+0x0/0x20()
[   30.799162] Calling initcall 0x78a40110: fm801_gp_init+0x0/0x20()
[   30.805252] initcall 0x78a40110: fm801_gp_init+0x0/0x20() returned 0.
[   30.811643] initcall 0x78a40110 ran for 0 msecs: fm801_gp_init+0x0/0x20()
[   30.818403] Calling initcall 0x78a40130: l4_init+0x0/0x2b0()
[   30.824048] initcall 0x78a40130: l4_init+0x0/0x2b0() returned -19.
[   30.830184] initcall 0x78a40130 ran for 0 msecs: l4_init+0x0/0x2b0()
[   30.836511] Calling initcall 0x78a403e0: ns558_init+0x0/0x390()
[   30.851150] initcall 0x78a403e0: ns558_init+0x0/0x390() returned -19.
[   30.857428] initcall 0x78a403e0 ran for 5 msecs: ns558_init+0x0/0x390()
[   30.864017] Calling initcall 0x78a40870: mousedev_init+0x0/0x90()
[   30.870127] mice: PS/2 mouse device common for all mice
[   30.875294] initcall 0x78a40870: mousedev_init+0x0/0x90() returned 0.
[   30.881700] initcall 0x78a40870 ran for 4 msecs: mousedev_init+0x0/0x90()
[   30.888458] Calling initcall 0x78a40900: evdev_init+0x0/0x10()
[   30.894267] initcall 0x78a40900: evdev_init+0x0/0x10() returned 0.
[   30.900415] initcall 0x78a40900 ran for 0 msecs: evdev_init+0x0/0x10()
[   30.906914] Calling initcall 0x78a40910: evbug_init+0x0/0x10()
[   30.912729] initcall 0x78a40910: evbug_init+0x0/0x10() returned 0.
[   30.918878] initcall 0x78a40910 ran for 0 msecs: evbug_init+0x0/0x10()
[   30.925377] Calling initcall 0x78a40920: atkbd_init+0x0/0x20()
[   30.931200] initcall 0x78a40920: atkbd_init+0x0/0x20() returned 0.
[   30.937330] initcall 0x78a40920 ran for 0 msecs: atkbd_init+0x0/0x20()
[   30.943832] Calling initcall 0x78a40940: sunkbd_init+0x0/0x20()
[   30.949746] initcall 0x78a40940: sunkbd_init+0x0/0x20() returned 0.
[   30.955965] initcall 0x78a40940 ran for 0 msecs: sunkbd_init+0x0/0x20()
[   30.962554] Calling initcall 0x78a40960: xtkbd_init+0x0/0x20()
[   30.968376] initcall 0x78a40960: xtkbd_init+0x0/0x20() returned 0.
[   30.974508] initcall 0x78a40960 ran for 0 msecs: xtkbd_init+0x0/0x20()
[   30.981010] Calling initcall 0x78a40980: a3d_init+0x0/0x10()
[   30.986660] initcall 0x78a40980: a3d_init+0x0/0x10() returned 0.
[   30.992622] initcall 0x78a40980 ran for 0 msecs: a3d_init+0x0/0x10()
[   30.998952] Calling initcall 0x78a40990: adi_init+0x0/0x10()
[   31.004594] initcall 0x78a40990: adi_init+0x0/0x10() returned 0.
[   31.010559] initcall 0x78a40990 ran for 0 msecs: adi_init+0x0/0x10()
[   31.016887] Calling initcall 0x78a409a0: analog_init+0x0/0x100()
[   31.022874] initcall 0x78a409a0: analog_init+0x0/0x100() returned 0.
[   31.029191] initcall 0x78a409a0 ran for 0 msecs: analog_init+0x0/0x100()
[   31.035869] Calling initcall 0x78a40aa0: cobra_init+0x0/0x10()
[   31.041679] initcall 0x78a40aa0: cobra_init+0x0/0x10() returned 0.
[   31.047823] initcall 0x78a40aa0 ran for 0 msecs: cobra_init+0x0/0x10()
[   31.054325] Calling initcall 0x78a40ab0: grip_init+0x0/0x10()
[   31.060051] initcall 0x78a40ab0: grip_init+0x0/0x10() returned 0.
[   31.066111] initcall 0x78a40ab0 ran for 0 msecs: grip_init+0x0/0x10()
[   31.072527] Calling initcall 0x78a40ac0: grip_init+0x0/0x10()
[   31.078251] initcall 0x78a40ac0: grip_init+0x0/0x10() returned 0.
[   31.084307] initcall 0x78a40ac0 ran for 0 msecs: grip_init+0x0/0x10()
[   31.090723] Calling initcall 0x78a40ad0: guillemot_init+0x0/0x10()
[   31.096881] initcall 0x78a40ad0: guillemot_init+0x0/0x10() returned 0.
[   31.103375] initcall 0x78a40ad0 ran for 0 msecs: guillemot_init+0x0/0x10()
[   31.110221] Calling initcall 0x78a40ae0: interact_init+0x0/0x10()
[   31.116293] initcall 0x78a40ae0: interact_init+0x0/0x10() returned 0.
[   31.122701] initcall 0x78a40ae0 ran for 0 msecs: interact_init+0x0/0x10()
[   31.129466] Calling initcall 0x78a40af0: joydump_init+0x0/0x10()
[   31.135446] initcall 0x78a40af0: joydump_init+0x0/0x10() returned 0.
[   31.141769] initcall 0x78a40af0 ran for 0 msecs: joydump_init+0x0/0x10()
[   31.148442] Calling initcall 0x78a40b00: magellan_init+0x0/0x20()
[   31.154531] initcall 0x78a40b00: magellan_init+0x0/0x20() returned 0.
[   31.160916] initcall 0x78a40b00 ran for 2 msecs: magellan_init+0x0/0x20()
[   31.167678] Calling initcall 0x78a40b20: sw_init+0x0/0x10()
[   31.173231] initcall 0x78a40b20: sw_init+0x0/0x10() returned 0.
[   31.179115] initcall 0x78a40b20 ran for 0 msecs: sw_init+0x0/0x10()
[   31.185360] Calling initcall 0x78a40b30: stinger_init+0x0/0x20()
[   31.191363] initcall 0x78a40b30: stinger_init+0x0/0x20() returned 0.
[   31.197661] initcall 0x78a40b30 ran for 0 msecs: stinger_init+0x0/0x20()
[   31.204336] Calling initcall 0x78a40b50: tmdc_init+0x0/0x10()
[   31.210062] initcall 0x78a40b50: tmdc_init+0x0/0x10() returned 0.
[   31.216122] initcall 0x78a40b50 ran for 0 msecs: tmdc_init+0x0/0x10()
[   31.222537] Calling initcall 0x78a40b60: usb_xpad_init+0x0/0x40()
[   31.228613] usbcore: registered new interface driver xpad
[   31.233981] drivers/input/joystick/xpad.c: X-Box pad driver:v0.0.6
[   31.240136] initcall 0x78a40b60: usb_xpad_init+0x0/0x40() returned 0.
[   31.246540] initcall 0x78a40b60 ran for 4 msecs: usb_xpad_init+0x0/0x40()
[   31.253305] Calling initcall 0x78a40ba0: iforce_init+0x0/0x20()
[   31.259213] initcall 0x78a40ba0: iforce_init+0x0/0x20() returned 0.
[   31.265435] initcall 0x78a40ba0 ran for 0 msecs: iforce_init+0x0/0x20()
[   31.272021] Calling initcall 0x78a40cc0: i2c_dev_init+0x0/0x90()
[   31.277999] i2c /dev entries driver
[   31.281514] initcall 0x78a40cc0: i2c_dev_init+0x0/0x90() returned 0.
[   31.287788] initcall 0x78a40cc0 ran for 3 msecs: i2c_dev_init+0x0/0x90()
[   31.294464] Calling initcall 0x78a40f70: ali1563_init+0x0/0x20()
[   31.300470] initcall 0x78a40f70: ali1563_init+0x0/0x20() returned 0.
[   31.306769] initcall 0x78a40f70 ran for 0 msecs: ali1563_init+0x0/0x20()
[   31.313442] Calling initcall 0x78a41140: i2c_amd8111_init+0x0/0x20()
[   31.319794] initcall 0x78a41140: i2c_amd8111_init+0x0/0x20() returned 0.
[   31.326441] initcall 0x78a41140 ran for 0 msecs: i2c_amd8111_init+0x0/0x20()
[   31.333466] Calling initcall 0x78a41230: i2c_i810_init+0x0/0x20()
[   31.339553] initcall 0x78a41230: i2c_i810_init+0x0/0x20() returned 0.
[   31.345940] initcall 0x78a41230 ran for 0 msecs: i2c_i810_init+0x0/0x20()
[   31.352706] Calling initcall 0x78a41250: i2c_parport_init+0x0/0x190()
[   31.359114] i2c-parport-light: adapter type unspecified
[   31.364321] initcall 0x78a41250: i2c_parport_init+0x0/0x190() returned -19.
[   31.371249] initcall 0x78a41250 ran for 1 msecs: i2c_parport_init+0x0/0x190()
[   31.378357] Calling initcall 0x78a41950: i2c_piix4_init+0x0/0x20()
[   31.384536] initcall 0x78a41950: i2c_piix4_init+0x0/0x20() returned 0.
[   31.391002] initcall 0x78a41950 ran for 0 msecs: i2c_piix4_init+0x0/0x20()
[   31.397855] Calling initcall 0x78a41b20: i2c_prosavage_init+0x0/0x20()
[   31.404376] initcall 0x78a41b20: i2c_prosavage_init+0x0/0x20() returned 0.
[   31.411199] initcall 0x78a41b20 ran for 0 msecs: i2c_prosavage_init+0x0/0x20()
[   31.418394] Calling initcall 0x78a41be0: i2c_savage4_init+0x0/0x20()
[   31.424742] initcall 0x78a41be0: i2c_savage4_init+0x0/0x20() returned 0.
[   31.431391] initcall 0x78a41be0 ran for 0 msecs: i2c_savage4_init+0x0/0x20()
[   31.438411] Calling initcall 0x78a41fc0: i2c_sis5595_init+0x0/0x20()
[   31.444760] initcall 0x78a41fc0: i2c_sis5595_init+0x0/0x20() returned 0.
[   31.451410] initcall 0x78a41fc0 ran for 0 msecs: i2c_sis5595_init+0x0/0x20()
[   31.458431] Calling initcall 0x78a42220: i2c_sis630_init+0x0/0x20()
[   31.464692] initcall 0x78a42220: i2c_sis630_init+0x0/0x20() returned 0.
[   31.471256] initcall 0x78a42220 ran for 0 msecs: i2c_sis630_init+0x0/0x20()
[   31.478190] Calling initcall 0x78a42240: usb_i2c_tiny_usb_init+0x0/0x20()
[   31.484958] usbcore: registered new interface driver i2c-tiny-usb
[   31.491022] initcall 0x78a42240: usb_i2c_tiny_usb_init+0x0/0x20() returned 0.
[   31.498121] initcall 0x78a42240 ran for 2 msecs: usb_i2c_tiny_usb_init+0x0/0x20()
[   31.506131] Calling initcall 0x78a42260: i2c_vt596_init+0x0/0x20()
[   31.512304] initcall 0x78a42260: i2c_vt596_init+0x0/0x20() returned 0.
[   31.518779] initcall 0x78a42260 ran for 0 msecs: i2c_vt596_init+0x0/0x20()
[   31.525627] Calling initcall 0x78a42730: i2c_voodoo3_init+0x0/0x20()
[   31.531976] initcall 0x78a42730: i2c_voodoo3_init+0x0/0x20() returned 0.
[   31.538626] initcall 0x78a42730 ran for 0 msecs: i2c_voodoo3_init+0x0/0x20()
[   31.545644] Calling initcall 0x78a42900: scx200_acb_init+0x0/0x220()
[   31.551970] scx200_acb: NatSemi SCx200 ACCESS.bus Driver
[   31.557266] initcall 0x78a42900: scx200_acb_init+0x0/0x220() returned -19.
[   31.564099] initcall 0x78a42900 ran for 1 msecs: scx200_acb_init+0x0/0x220()
[   31.571127] Calling initcall 0x78a42b20: ds1682_init+0x0/0x10()
[   31.577031] initcall 0x78a42b20: ds1682_init+0x0/0x10() returned 0.
[   31.583254] initcall 0x78a42b20 ran for 0 msecs: ds1682_init+0x0/0x10()
[   31.589845] Calling initcall 0x78a42b30: pcf8591_init+0x0/0x40()
[   31.595835] initcall 0x78a42b30: pcf8591_init+0x0/0x40() returned 0.
[   31.602148] initcall 0x78a42b30 ran for 0 msecs: pcf8591_init+0x0/0x40()
[   31.608821] Calling initcall 0x78a42d50: tsl2550_init+0x0/0x10()
[   31.614816] initcall 0x78a42d50: tsl2550_init+0x0/0x10() returned 0.
[   31.621127] initcall 0x78a42d50 ran for 0 msecs: tsl2550_init+0x0/0x10()
[   31.627803] Calling initcall 0x785c6a50: w1_init+0x0/0x120()
[   31.633432] Driver for 1-wire Dallas network protocol.
[   31.638953] initcall 0x785c6a50: w1_init+0x0/0x120() returned 0.
[   31.644804] initcall 0x785c6a50 ran for 3 msecs: w1_init+0x0/0x120()
[   31.651134] Calling initcall 0x78a42f90: matrox_w1_init+0x0/0x20()
[   31.657301] initcall 0x78a42f90: matrox_w1_init+0x0/0x20() returned 0.
[   31.663776] initcall 0x78a42f90 ran for 0 msecs: matrox_w1_init+0x0/0x20()
[   31.670624] Calling initcall 0x785c80c0: ds_init+0x0/0x40()
[   31.676180] usbcore: registered new interface driver DS9490R
[   31.681813] initcall 0x785c80c0: ds_init+0x0/0x40() returned 0.
[   31.687695] initcall 0x785c80c0 ran for 5 msecs: ds_init+0x0/0x40()
[   31.693937] Calling initcall 0x78a42fb0: w1_ds2760_init+0x0/0x30()
[   31.700091] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   31.708869] initcall 0x78a42fb0: w1_ds2760_init+0x0/0x30() returned 0.
[   31.715345] initcall 0x78a42fb0 ran for 5 msecs: w1_ds2760_init+0x0/0x30()
[   31.722191] Calling initcall 0x78a43020: asb100_init+0x0/0x10()
[   31.728093] initcall 0x78a43020: asb100_init+0x0/0x10() returned 0.
[   31.734318] initcall 0x78a43020 ran for 0 msecs: asb100_init+0x0/0x10()
[   31.740908] Calling initcall 0x78a43030: sensors_w83792d_init+0x0/0x10()
[   31.747592] initcall 0x78a43030: sensors_w83792d_init+0x0/0x10() returned 0.
[   31.754603] initcall 0x78a43030 ran for 0 msecs: sensors_w83792d_init+0x0/0x10()
[   31.761971] Calling initcall 0x78a43200: sensors_w83781d_init+0x0/0x420()
[   31.768747] w83781d: Detection failed at step 3
[   31.773242] initcall 0x78a43200: sensors_w83781d_init+0x0/0x420() returned 0.
[   31.780338] initcall 0x78a43200 ran for 1 msecs: sensors_w83781d_init+0x0/0x420()
[   31.787797] Calling initcall 0x78a43620: ad7418_init+0x0/0x10()
[   31.793695] initcall 0x78a43620: ad7418_init+0x0/0x10() returned 0.
[   31.799923] initcall 0x78a43620 ran for 0 msecs: ad7418_init+0x0/0x10()
[   31.806510] Calling initcall 0x78a43630: sensors_adm1021_init+0x0/0x10()
[   31.813194] initcall 0x78a43630: sensors_adm1021_init+0x0/0x10() returned 0.
[   31.820202] initcall 0x78a43630 ran for 0 msecs: sensors_adm1021_init+0x0/0x10()
[   31.827568] Calling initcall 0x78a43640: sensors_adm1031_init+0x0/0x10()
[   31.834252] initcall 0x78a43640: sensors_adm1031_init+0x0/0x10() returned 0.
[   31.841264] initcall 0x78a43640 ran for 0 msecs: sensors_adm1031_init+0x0/0x10()
[   31.848633] Calling initcall 0x78a43650: applesmc_init+0x0/0x520()
[   31.854783] applesmc: supported laptop not found!
[   31.859466] applesmc: driver init failed (ret=-19)!
[   31.864321] initcall 0x78a43650: applesmc_init+0x0/0x520() returned -19.
[   31.870983] initcall 0x78a43650 ran for 5 msecs: applesmc_init+0x0/0x520()
[   31.877838] Calling initcall 0x78a43cc0: f71805f_init+0x0/0x170()
[   31.883928] initcall 0x78a43cc0: f71805f_init+0x0/0x170() returned -19.
[   31.890484] initcall 0x78a43cc0 ran for 0 msecs: f71805f_init+0x0/0x170()
[   31.897243] Calling initcall 0x78a44250: sensors_f75375_init+0x0/0x10()
[   31.903842] initcall 0x78a44250: sensors_f75375_init+0x0/0x10() returned 0.
[   31.910761] initcall 0x78a44250 ran for 0 msecs: sensors_f75375_init+0x0/0x10()
[   31.918048] Calling initcall 0x78a44260: sensors_fscher_init+0x0/0x10()
[   31.924641] initcall 0x78a44260: sensors_fscher_init+0x0/0x10() returned 0.
[   31.931565] initcall 0x78a44260 ran for 0 msecs: sensors_fscher_init+0x0/0x10()
[   31.938845] Calling initcall 0x78a44270: sensors_gl518sm_init+0x0/0x10()
[   31.945525] initcall 0x78a44270: sensors_gl518sm_init+0x0/0x10() returned 0.
[   31.952534] initcall 0x78a44270 ran for 0 msecs: sensors_gl518sm_init+0x0/0x10()
[   31.959905] Calling initcall 0x78a44280: sensors_gl520sm_init+0x0/0x10()
[   31.966585] initcall 0x78a44280: sensors_gl520sm_init+0x0/0x10() returned 0.
[   31.973592] initcall 0x78a44280 ran for 0 msecs: sensors_gl520sm_init+0x0/0x10()
[   31.980959] Calling initcall 0x78a442e0: hdaps_init+0x0/0x1f0()
[   31.986857] hdaps: supported laptop not found!
[   31.991277] hdaps: driver init failed (ret=-19)!
[   31.995874] initcall 0x78a442e0: hdaps_init+0x0/0x1f0() returned -19.
[   32.002280] initcall 0x78a442e0 ran for 4 msecs: hdaps_init+0x0/0x1f0()
[   32.008866] Calling initcall 0x78a444d0: init_lm70+0x0/0x10()
[   32.014602] initcall 0x78a444d0: init_lm70+0x0/0x10() returned 0.
[   32.020647] initcall 0x78a444d0 ran for 0 msecs: init_lm70+0x0/0x10()
[   32.027063] Calling initcall 0x78a44600: sensors_lm77_init+0x0/0x10()
[   32.033492] initcall 0x78a44600: sensors_lm77_init+0x0/0x10() returned 0.
[   32.040235] initcall 0x78a44600 ran for 0 msecs: sensors_lm77_init+0x0/0x10()
[   32.047341] Calling initcall 0x78a44610: sensors_lm80_init+0x0/0x10()
[   32.053770] initcall 0x78a44610: sensors_lm80_init+0x0/0x10() returned 0.
[   32.060511] initcall 0x78a44610 ran for 0 msecs: sensors_lm80_init+0x0/0x10()
[   32.067620] Calling initcall 0x78a44620: sm_lm85_init+0x0/0x10()
[   32.073616] initcall 0x78a44620: sm_lm85_init+0x0/0x10() returned 0.
[   32.079926] initcall 0x78a44620 ran for 0 msecs: sm_lm85_init+0x0/0x10()
[   32.086599] Calling initcall 0x78a44630: sensors_lm87_init+0x0/0x10()
[   32.093028] initcall 0x78a44630: sensors_lm87_init+0x0/0x10() returned 0.
[   32.099772] initcall 0x78a44630 ran for 0 msecs: sensors_lm87_init+0x0/0x10()
[   32.106883] Calling initcall 0x78a44640: lm93_init+0x0/0x10()
[   32.112617] initcall 0x78a44640: lm93_init+0x0/0x10() returned 0.
[   32.118666] initcall 0x78a44640 ran for 0 msecs: lm93_init+0x0/0x10()
[   32.125079] Calling initcall 0x78a44650: sensors_max1619_init+0x0/0x10()
[   32.131765] initcall 0x78a44650: sensors_max1619_init+0x0/0x10() returned 0.
[   32.138772] initcall 0x78a44650 ran for 0 msecs: sensors_max1619_init+0x0/0x10()
[   32.146141] Calling initcall 0x78a44660: sensors_max6650_init+0x0/0x10()
[   32.152826] initcall 0x78a44660: sensors_max6650_init+0x0/0x10() returned 0.
[   32.159828] initcall 0x78a44660 ran for 0 msecs: sensors_max6650_init+0x0/0x10()
[   32.167199] Calling initcall 0x78a45540: pc87360_init+0x0/0x1a0()
[   32.173275] pc87360: PC8736x not detected, module not inserted.
[   32.179163] initcall 0x78a45540: pc87360_init+0x0/0x1a0() returned -19.
[   32.185742] initcall 0x78a45540 ran for 2 msecs: pc87360_init+0x0/0x1a0()
[   32.192504] Calling initcall 0x78a45800: pc87427_init+0x0/0x140()
[   32.198584] initcall 0x78a45800: pc87427_init+0x0/0x140() returned -19.
[   32.205154] initcall 0x78a45800 ran for 0 msecs: pc87427_init+0x0/0x140()
[   32.211914] Calling initcall 0x78a45c30: sm_sis5595_init+0x0/0x20()
[   32.218178] initcall 0x78a45c30: sm_sis5595_init+0x0/0x20() returned 0.
[   32.224740] initcall 0x78a45c30 ran for 0 msecs: sm_sis5595_init+0x0/0x20()
[   32.231674] Calling initcall 0x78a46350: vt1211_init+0x0/0x180()
[   32.237672] initcall 0x78a46350: vt1211_init+0x0/0x180() returned -19.
[   32.244147] initcall 0x78a46350 ran for 0 msecs: vt1211_init+0x0/0x180()
[   32.250821] Calling initcall 0x78a46890: sm_vt8231_init+0x0/0x20()
[   32.257001] initcall 0x78a46890: sm_vt8231_init+0x0/0x20() returned 0.
[   32.263474] initcall 0x78a46890 ran for 0 msecs: sm_vt8231_init+0x0/0x20()
[   32.270321] Calling initcall 0x78a46c90: sensors_w83627ehf_init+0x0/0x180()
[   32.277287] initcall 0x78a46c90: sensors_w83627ehf_init+0x0/0x180() returned -19.
[   32.284710] initcall 0x78a46c90 ran for 0 msecs: sensors_w83627ehf_init+0x0/0x180()
[   32.292336] Calling initcall 0x78a477b0: wdtpci_init+0x0/0x20()
[   32.298252] initcall 0x78a477b0: wdtpci_init+0x0/0x20() returned 0.
[   32.304468] initcall 0x78a477b0 ran for 0 msecs: wdtpci_init+0x0/0x20()
[   32.311057] Calling initcall 0x78a47920: acq_init+0x0/0x70()
[   32.316686] WDT driver for Acquire single board computer initialising.
[   32.323229] acquirewdt: I/O address 0x0043 already in use
[   32.328568] acquirewdt: probe of acquirewdt failed with error -5
[   32.334547] initcall 0x78a47920: acq_init+0x0/0x70() returned 0.
[   32.340514] initcall 0x78a47920 ran for 9 msecs: acq_init+0x0/0x70()
[   32.346843] Calling initcall 0x78a47b20: advwdt_init+0x0/0x70()
[   32.352737] WDT driver for Advantech single board computer initialising.
[   32.359470] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[   32.365574] initcall 0x78a47b20: advwdt_init+0x0/0x70() returned 0.
[   32.371803] initcall 0x78a47b20 ran for 9 msecs: advwdt_init+0x0/0x70()
[   32.378390] Calling initcall 0x78a47b90: watchdog_init+0x0/0x1a0()
[   32.384546] initcall 0x78a47b90: watchdog_init+0x0/0x1a0() returned -19.
[   32.391217] initcall 0x78a47b90 ran for 0 msecs: watchdog_init+0x0/0x1a0()
[   32.398065] Calling initcall 0x78a47d30: alim7101_wdt_init+0x0/0x200()
[   32.404560] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   32.410024] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   32.416093] initcall 0x78a47d30: alim7101_wdt_init+0x0/0x200() returned -16.
[   32.423104] initcall 0x78a47d30 ran for 4 msecs: alim7101_wdt_init+0x0/0x200()
[   32.430303] initcall at 0x78a47d30: alim7101_wdt_init+0x0/0x200(): returned with error code -16
[   32.438965] Calling initcall 0x78a47f30: sc520_wdt_init+0x0/0x110()
[   32.445208] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[   32.451628] initcall 0x78a47f30: sc520_wdt_init+0x0/0x110() returned -16.
[   32.458379] initcall 0x78a47f30 ran for 2 msecs: sc520_wdt_init+0x0/0x110()
[   32.465311] initcall at 0x78a47f30: sc520_wdt_init+0x0/0x110(): returned with error code -16
[   32.473720] Calling initcall 0x78a48040: watchdog_init+0x0/0x2e0()
[   32.479878] initcall 0x78a48040: watchdog_init+0x0/0x2e0() returned -19.
[   32.486540] initcall 0x78a48040 ran for 0 msecs: watchdog_init+0x0/0x2e0()
[   32.493386] Calling initcall 0x78a48320: iTCO_wdt_init_module+0x0/0x80()
[   32.500061] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   32.506873] iTCO_wdt: No card detected
[   32.510560] initcall 0x78a48320: iTCO_wdt_init_module+0x0/0x80() returned 0.
[   32.517563] initcall 0x78a48320 ran for 6 msecs: iTCO_wdt_init_module+0x0/0x80()
[   32.524937] Calling initcall 0x78a483a0: iTCO_vendor_init_module+0x0/0x20()
[   32.531866] iTCO_vendor_support: vendor-support=0
[   32.536553] initcall 0x78a483a0: iTCO_vendor_init_module+0x0/0x20() returned 0.
[   32.543821] initcall 0x78a483a0 ran for 1 msecs: iTCO_vendor_init_module+0x0/0x20()
[   32.552001] Calling initcall 0x78a483c0: cpu5wdt_init_module+0x0/0x150()
[   32.558671] cpu5wdt: misc_register failed
[   32.562665] initcall 0x78a483c0: cpu5wdt_init_module+0x0/0x150() returned -16.
[   32.569848] initcall 0x78a483c0 ran for 0 msecs: cpu5wdt_init_module+0x0/0x150()
[   32.577214] initcall at 0x78a483c0: cpu5wdt_init_module+0x0/0x150(): returned with error code -16
[   32.586058] Calling initcall 0x78a48510: wb_smsc_wdt_init+0x0/0x200()
[   32.592470] SMsC 37B787 watchdog component driver 1.1 initialising...
[   32.599923] smsc37b787_wdt: Unable to register miscdev on minor 130
[   32.606064] initcall 0x78a48510: wb_smsc_wdt_init+0x0/0x200() returned -16.
[   32.612988] initcall 0x78a48510 ran for 3 msecs: wb_smsc_wdt_init+0x0/0x200()
[   32.620099] initcall at 0x78a48510: wb_smsc_wdt_init+0x0/0x200(): returned with error code -16
[   32.628676] Calling initcall 0x78a48710: w83977f_wdt_init+0x0/0x160()
[   32.635087] W83977F WDT: W83977F WDT driver, v1.00
[   32.639860] W83977F WDT: cannot register miscdev on minor=130 (err=-16)
[   32.646448] initcall 0x78a48710: w83977f_wdt_init+0x0/0x160() returned -16.
[   32.653372] initcall 0x78a48710 ran for 4 msecs: w83977f_wdt_init+0x0/0x160()
[   32.660478] initcall at 0x78a48710: w83977f_wdt_init+0x0/0x160(): returned with error code -16
[   32.669062] Calling initcall 0x78a48870: zf_init+0x0/0x1c0()
[   32.674692] machzwd: MachZ ZF-Logic Watchdog driver initializing.
[   32.680764] machzwd: no ZF-Logic found
[   32.684492] initcall 0x78a48870: zf_init+0x0/0x1c0() returned -19.
[   32.690633] initcall 0x78a48870 ran for 6 msecs: zf_init+0x0/0x1c0()
[   32.696962] Calling initcall 0x78a48a30: watchdog_init+0x0/0xd0()
[   32.703031] epx_c3: cannot register miscdev on minor=130 (err=-16)
[   32.709191] initcall 0x78a48a30: watchdog_init+0x0/0xd0() returned -16.
[   32.715767] initcall 0x78a48a30 ran for 2 msecs: watchdog_init+0x0/0xd0()
[   32.722533] initcall at 0x78a48a30: watchdog_init+0x0/0xd0(): returned with error code -16
[   32.730760] Calling initcall 0x78a48b00: watchdog_init+0x0/0xe0()
[   32.736829] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   32.743076] initcall 0x78a48b00: watchdog_init+0x0/0xe0() returned -16.
[   32.749652] initcall 0x78a48b00 ran for 1 msecs: watchdog_init+0x0/0xe0()
[   32.756418] initcall at 0x78a48b00: watchdog_init+0x0/0xe0(): returned with error code -16
[   32.764650] Calling initcall 0x78a48be0: telephony_init+0x0/0x50()
[   32.770799] Linux telephony interface: v1.00
[   32.775064] initcall 0x78a48be0: telephony_init+0x0/0x50() returned 0.
[   32.781547] initcall 0x78a48be0 ran for 3 msecs: telephony_init+0x0/0x50()
[   32.788392] Calling initcall 0x78a48c30: dm_init+0x0/0x70()
[   32.793969] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   32.802352] initcall 0x78a48c30: dm_init+0x0/0x70() returned 0.
[   32.808238] initcall 0x78a48c30 ran for 3 msecs: dm_init+0x0/0x70()
[   32.814478] Calling initcall 0x78a48e60: dm_crypt_init+0x0/0xa0()
[   32.820593] initcall 0x78a48e60: dm_crypt_init+0x0/0xa0() returned 0.
[   32.826951] initcall 0x78a48e60 ran for 0 msecs: dm_crypt_init+0x0/0xa0()
[   32.833714] Calling initcall 0x78a48f00: dm_delay_init+0x0/0xc0()
[   32.839818] initcall 0x78a48f00: dm_delay_init+0x0/0xc0() returned 0.
[   32.846193] initcall 0x78a48f00 ran for 0 msecs: dm_delay_init+0x0/0xc0()
[   32.852958] Calling initcall 0x78a48fc0: dm_snapshot_init+0x0/0x1e0()
[   32.859450] initcall 0x78a48fc0: dm_snapshot_init+0x0/0x1e0() returned 0.
[   32.866125] initcall 0x78a48fc0 ran for 0 msecs: dm_snapshot_init+0x0/0x1e0()
[   32.873237] Calling initcall 0x78a491f0: dm_mirror_init+0x0/0x40()
[   32.879401] initcall 0x78a491f0: dm_mirror_init+0x0/0x40() returned 0.
[   32.885884] initcall 0x78a491f0 ran for 0 msecs: dm_mirror_init+0x0/0x40()
[   32.892735] Calling initcall 0x78a49230: kcapi_init+0x0/0xb0()
[   32.898548] CAPI Subsystem Rev 1.1.2.8
[   32.902273] initcall 0x78a49230: kcapi_init+0x0/0xb0() returned 0.
[   32.908419] initcall 0x78a49230 ran for 3 msecs: kcapi_init+0x0/0xb0()
[   32.914918] Calling initcall 0x78a49aa0: b1pci_init+0x0/0xd0()
[   32.920747] b1pci: revision 1.1.2.2
[   32.924197] initcall 0x78a49aa0: b1pci_init+0x0/0xd0() returned 0.
[   32.930339] initcall 0x78a49aa0 ran for 2 msecs: b1pci_init+0x0/0xd0()
[   32.936840] Calling initcall 0x78a49b70: b1_init+0x0/0x80()
[   32.942391] b1: revision 1.1.2.2
[   32.945600] initcall 0x78a49b70: b1_init+0x0/0x80() returned 0.
[   32.951489] initcall 0x78a49b70 ran for 3 msecs: b1_init+0x0/0x80()
[   32.957729] Calling initcall 0x78a49bf0: b1dma_init+0x0/0x80()
[   32.963534] b1dma: revision 1.1.2.3
[   32.967008] initcall 0x78a49bf0: b1dma_init+0x0/0x80() returned 0.
[   32.973152] initcall 0x78a49bf0 ran for 2 msecs: b1dma_init+0x0/0x80()
[   32.979651] Calling initcall 0x78a49c70: b1pcmcia_init+0x0/0xa0()
[   32.985721] b1pci: revision 1.1.2.2
[   32.989193] initcall 0x78a49c70: b1pcmcia_init+0x0/0xa0() returned 0.
[   32.995594] initcall 0x78a49c70 ran for 0 msecs: b1pcmcia_init+0x0/0xa0()
[   33.002361] Calling initcall 0x78a4a050: t1pci_init+0x0/0xb0()
[   33.008179] t1pci: revision 1.1.2.2
[   33.011638] initcall 0x78a4a050: t1pci_init+0x0/0xb0() returned 0.
[   33.017785] initcall 0x78a4a050 ran for 3 msecs: t1pci_init+0x0/0xb0()
[   33.024287] Calling initcall 0x78a4aa00: c4_init+0x0/0xd0()
[   33.029847] c4: revision 1.1.2.2
[   33.033043] initcall 0x78a4aa00: c4_init+0x0/0xd0() returned 0.
[   33.038925] initcall 0x78a4aa00 ran for 1 msecs: c4_init+0x0/0xd0()
[   33.045169] Calling initcall 0x78a4acb0: cpufreq_stats_init+0x0/0x70()
[   33.051680] initcall 0x78a4acb0: cpufreq_stats_init+0x0/0x70() returned 0.
[   33.058516] initcall 0x78a4acb0 ran for 0 msecs: cpufreq_stats_init+0x0/0x70()
[   33.065712] Calling initcall 0x78a4ad20: cpufreq_gov_powersave_init+0x0/0x10()
[   33.072906] initcall 0x78a4ad20: cpufreq_gov_powersave_init+0x0/0x10() returned 0.
[   33.080435] initcall 0x78a4ad20 ran for 0 msecs: cpufreq_gov_powersave_init+0x0/0x10()
[   33.088329] Calling initcall 0x78a4ad40: cpufreq_gov_dbs_init+0x0/0x10()
[   33.095003] initcall 0x78a4ad40: cpufreq_gov_dbs_init+0x0/0x10() returned 0.
[   33.102020] initcall 0x78a4ad40 ran for 0 msecs: cpufreq_gov_dbs_init+0x0/0x10()
[   33.109388] Calling initcall 0x78a4b4c0: hid_init+0x0/0x10()
[   33.115021] initcall 0x78a4b4c0: hid_init+0x0/0x10() returned 0.
[   33.120998] initcall 0x78a4b4c0 ran for 0 msecs: hid_init+0x0/0x10()
[   33.127321] Calling initcall 0x78a4b4d0: hid_init+0x0/0x60()
[   33.132970] usbcore: registered new interface driver usbhid
[   33.138507] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   33.144750] initcall 0x78a4b4d0: hid_init+0x0/0x60() returned 0.
[   33.150718] initcall 0x78a4b4d0 ran for 6 msecs: hid_init+0x0/0x60()
[   33.157046] Calling initcall 0x78a4b530: usb_mouse_init+0x0/0x40()
[   33.163212] usbcore: registered new interface driver usbmouse
[   33.168926] drivers/hid/usbhid/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
[   33.176468] initcall 0x78a4b530: usb_mouse_init+0x0/0x40() returned 0.
[   33.182958] initcall 0x78a4b530 ran for 6 msecs: usb_mouse_init+0x0/0x40()
[   33.189810] Calling initcall 0x78a4d910: flow_cache_init+0x0/0x100()
[   33.196140] initcall 0x78a4d910: flow_cache_init+0x0/0x100() returned 0.
[   33.202804] initcall 0x78a4d910 ran for 0 msecs: flow_cache_init+0x0/0x100()
[   33.209829] Calling initcall 0x78a4da10: pg_init+0x0/0x250()
[   33.215458] pktgen v2.69: Packet Generator for packet performance testing.
[   33.222355] initcall 0x78a4da10: pg_init+0x0/0x250() returned 0.
[   33.228284] initcall 0x78a4da10 ran for 3 msecs: pg_init+0x0/0x250()
[   33.234611] Calling initcall 0x78a4dca0: llc_init+0x0/0x70()
[   33.240248] initcall 0x78a4dca0: llc_init+0x0/0x70() returned 0.
[   33.246221] initcall 0x78a4dca0 ran for 0 msecs: llc_init+0x0/0x70()
[   33.252552] Calling initcall 0x78a4dd90: llc2_init+0x0/0xd0()
[   33.258280] NET: Registered protocol family 26
[   33.262696] initcall 0x78a4dd90: llc2_init+0x0/0xd0() returned 0.
[   33.268756] initcall 0x78a4dd90 ran for 1 msecs: llc2_init+0x0/0xd0()
[   33.275168] Calling initcall 0x78a4e020: snap_init+0x0/0x40()
[   33.280911] initcall 0x78a4e020: snap_init+0x0/0x40() returned 0.
[   33.286949] initcall 0x78a4e020 ran for 2 msecs: snap_init+0x0/0x40()
[   33.293365] Calling initcall 0x78a4e130: blackhole_module_init+0x0/0x10()
[   33.300131] initcall 0x78a4e130: blackhole_module_init+0x0/0x10() returned 0.
[   33.307228] initcall 0x78a4e130 ran for 0 msecs: blackhole_module_init+0x0/0x10()
[   33.314689] Calling initcall 0x78a4e200: gact_init_module+0x0/0x20()
[   33.321016] GACT probability on
[   33.324141] initcall 0x78a4e200: gact_init_module+0x0/0x20() returned 0.
[   33.330800] initcall 0x78a4e200 ran for 0 msecs: gact_init_module+0x0/0x20()
[   33.337827] Calling initcall 0x78a4e220: simp_init_module+0x0/0x30()
[   33.344150] Simple TC action Loaded
[   33.347623] initcall 0x78a4e220: simp_init_module+0x0/0x30() returned 0.
[   33.354291] initcall 0x78a4e220 ran for 2 msecs: simp_init_module+0x0/0x30()
[   33.361313] Calling initcall 0x78a4e250: hfsc_init+0x0/0x10()
[   33.367032] initcall 0x78a4e250: hfsc_init+0x0/0x10() returned 0.
[   33.373093] initcall 0x78a4e250 ran for 0 msecs: hfsc_init+0x0/0x10()
[   33.379505] Calling initcall 0x78a4e260: gred_module_init+0x0/0x10()
[   33.385837] initcall 0x78a4e260: gred_module_init+0x0/0x10() returned 0.
[   33.392505] initcall 0x78a4e260 ran for 0 msecs: gred_module_init+0x0/0x10()
[   33.399530] Calling initcall 0x78a4e270: sfq_module_init+0x0/0x10()
[   33.405772] initcall 0x78a4e270: sfq_module_init+0x0/0x10() returned 0.
[   33.412351] initcall 0x78a4e270 ran for 0 msecs: sfq_module_init+0x0/0x10()
[   33.419289] Calling initcall 0x78a4e280: prio_module_init+0x0/0x40()
[   33.425615] initcall 0x78a4e280: prio_module_init+0x0/0x40() returned 0.
[   33.432280] initcall 0x78a4e280 ran for 0 msecs: prio_module_init+0x0/0x40()
[   33.439308] Calling initcall 0x78a4e2c0: netem_module_init+0x0/0x20()
[   33.445719] netem: version 1.2
[   33.448755] initcall 0x78a4e2c0: netem_module_init+0x0/0x20() returned 0.
[   33.455505] initcall 0x78a4e2c0 ran for 3 msecs: netem_module_init+0x0/0x20()
[   33.462620] Calling initcall 0x78a4e2e0: init_u32+0x0/0x30()
[   33.468248] u32 classifier
[   33.470939]     Actions configured 
[   33.474418] initcall 0x78a4e2e0: init_u32+0x0/0x30() returned 0.
[   33.480377] initcall 0x78a4e2e0 ran for 5 msecs: init_u32+0x0/0x30()
[   33.486705] Calling initcall 0x78a4e310: init_route4+0x0/0x10()
[   33.492605] initcall 0x78a4e310: init_route4+0x0/0x10() returned 0.
[   33.498835] initcall 0x78a4e310 ran for 0 msecs: init_route4+0x0/0x10()
[   33.505427] Calling initcall 0x78a4e320: init_rsvp+0x0/0x10()
[   33.511149] initcall 0x78a4e320: init_rsvp+0x0/0x10() returned 0.
[   33.517207] initcall 0x78a4e320 ran for 0 msecs: init_rsvp+0x0/0x10()
[   33.523623] Calling initcall 0x78a4e330: init_rsvp+0x0/0x10()
[   33.529348] initcall 0x78a4e330: init_rsvp+0x0/0x10() returned 0.
[   33.535407] initcall 0x78a4e330 ran for 0 msecs: init_rsvp+0x0/0x10()
[   33.541826] Calling initcall 0x78a4f4e0: ipip_init+0x0/0xa0()
[   33.547549] IPv4 over IPv4 tunneling driver
[   33.551826] initcall 0x78a4f4e0: ipip_init+0x0/0xa0() returned 0.
[   33.557771] initcall 0x78a4f4e0 ran for 4 msecs: ipip_init+0x0/0xa0()
[   33.564179] Calling initcall 0x78a4f5d0: ipgre_init+0x0/0xa0()
[   33.570508] GRE over IPv4 tunneling driver
[   33.574670] initcall 0x78a4f5d0: ipgre_init+0x0/0xa0() returned 0.
[   33.580730] initcall 0x78a4f5d0 ran for 3 msecs: ipgre_init+0x0/0xa0()
[   33.587233] Calling initcall 0x78a4f6c0: ah4_init+0x0/0x70()
[   33.592871] initcall 0x78a4f6c0: ah4_init+0x0/0x70() returned 0.
[   33.598843] initcall 0x78a4f6c0 ran for 0 msecs: ah4_init+0x0/0x70()
[   33.605174] Calling initcall 0x78a4f730: ipcomp4_init+0x0/0x70()
[   33.611158] initcall 0x78a4f730: ipcomp4_init+0x0/0x70() returned 0.
[   33.617474] initcall 0x78a4f730 ran for 0 msecs: ipcomp4_init+0x0/0x70()
[   33.624150] Calling initcall 0x78a4f7a0: ipip_init+0x0/0xb0()
[   33.629876] initcall 0x78a4f7a0: ipip_init+0x0/0xb0() returned 0.
[   33.635936] initcall 0x78a4f7a0 ran for 0 msecs: ipip_init+0x0/0xb0()
[   33.642354] Calling initcall 0x78a4f850: xfrm4_beet_init+0x0/0x10()
[   33.648595] initcall 0x78a4f850: xfrm4_beet_init+0x0/0x10() returned 0.
[   33.655178] initcall 0x78a4f850 ran for 0 msecs: xfrm4_beet_init+0x0/0x10()
[   33.662111] Calling initcall 0x78a4f860: tunnel4_init+0x0/0x70()
[   33.668092] initcall 0x78a4f860: tunnel4_init+0x0/0x70() returned 0.
[   33.674416] initcall 0x78a4f860 ran for 0 msecs: tunnel4_init+0x0/0x70()
[   33.681089] Calling initcall 0x78a4f8d0: xfrm4_transport_init+0x0/0x10()
[   33.687765] initcall 0x78a4f8d0: xfrm4_transport_init+0x0/0x10() returned 0.
[   33.694782] initcall 0x78a4f8d0 ran for 0 msecs: xfrm4_transport_init+0x0/0x10()
[   33.702148] Calling initcall 0x78a4f8e0: xfrm4_tunnel_init+0x0/0x10()
[   33.708563] initcall 0x78a4f8e0: xfrm4_tunnel_init+0x0/0x10() returned 0.
[   33.715321] initcall 0x78a4f8e0 ran for 0 msecs: xfrm4_tunnel_init+0x0/0x10()
[   33.722430] Calling initcall 0x78a50ed0: cubictcp_register+0x0/0xa0()
[   33.728839] TCP cubic registered
[   33.732053] initcall 0x78a50ed0: cubictcp_register+0x0/0xa0() returned 0.
[   33.738801] initcall 0x78a50ed0 ran for 3 msecs: cubictcp_register+0x0/0xa0()
[   33.745914] Calling initcall 0x78a511b0: af_unix_init+0x0/0x70()
[   33.751892] NET: Registered protocol family 1
[   33.756234] initcall 0x78a511b0: af_unix_init+0x0/0x70() returned 0.
[   33.762548] initcall 0x78a511b0 ran for 0 msecs: af_unix_init+0x0/0x70()
[   33.769226] Calling initcall 0x78a51220: inet6_init+0x0/0x2e0()
[   33.775130] NET: Registered protocol family 10
[   33.779648] lo: Disabled Privacy Extensions
[   33.783876] tunl0: Disabled Privacy Extensions
[   33.788274] initcall 0x78a51220: inet6_init+0x0/0x2e0() returned 0.
[   33.794434] initcall 0x78a51220 ran for 9 msecs: inet6_init+0x0/0x2e0()
[   33.801020] Calling initcall 0x78a51da0: xfrm6_tunnel_init+0x0/0x10()
[   33.807435] initcall 0x78a51da0: xfrm6_tunnel_init+0x0/0x10() returned 0.
[   33.814193] initcall 0x78a51da0 ran for 0 msecs: xfrm6_tunnel_init+0x0/0x10()
[   33.821301] Calling initcall 0x78a51db0: xfrm6_beet_init+0x0/0x10()
[   33.827547] initcall 0x78a51db0: xfrm6_beet_init+0x0/0x10() returned 0.
[   33.834120] initcall 0x78a51db0 ran for 0 msecs: xfrm6_beet_init+0x0/0x10()
[   33.841060] Calling initcall 0x78a51dc0: sit_init+0x0/0xa0()
[   33.846689] IPv6 over IPv4 tunneling driver
[   33.850959] sit0: Disabled Privacy Extensions
[   33.855206] initcall 0x78a51dc0: sit_init+0x0/0xa0() returned 0.
[   33.861171] initcall 0x78a51dc0 ran for 6 msecs: sit_init+0x0/0xa0()
[   33.867498] Calling initcall 0x78a51eb0: packet_init+0x0/0x50()
[   33.873390] NET: Registered protocol family 17
[   33.877832] initcall 0x78a51eb0: packet_init+0x0/0x50() returned 0.
[   33.884045] initcall 0x78a51eb0 ran for 3 msecs: packet_init+0x0/0x50()
[   33.890634] Calling initcall 0x78a51f00: br_init+0x0/0xb0()
[   33.896201] initcall 0x78a51f00: br_init+0x0/0xb0() returned 0.
[   33.902070] initcall 0x78a51f00 ran for 0 msecs: br_init+0x0/0xb0()
[   33.908316] Calling initcall 0x78a52050: ipx_init+0x0/0xf0()
[   33.913948] NET: Registered protocol family 4
[   33.921762] input: AT Translated Set 2 keyboard as /class/input/input0
[   33.930824] initcall 0x78a52050: ipx_init+0x0/0xf0() returned 0.
[   33.936677] initcall 0x78a52050 ran for 11 msecs: ipx_init+0x0/0xf0()
[   33.943089] Calling initcall 0x78a52270: atalk_init+0x0/0x90()
[   33.948900] NET: Registered protocol family 5
[   33.970808] evbug.c: Connected device: "AT Translated Set 2 keyboard", isa0060/serio0/input0
[   33.979265] initcall 0x78a52270: atalk_init+0x0/0x90() returned 0.
[   33.985288] initcall 0x78a52270 ran for 22 msecs: atalk_init+0x0/0x90()
[   33.991874] Calling initcall 0x78a524f0: x25_init+0x0/0x60()
[   33.997512] NET: Registered protocol family 9
[   34.001844] X.25 for Linux. Version 0.2 for Linux 2.1.15
[   34.007138] initcall 0x78a524f0: x25_init+0x0/0x60() returned 0.
[   34.013103] initcall 0x78a524f0 ran for 6 msecs: x25_init+0x0/0x60()
[   34.019429] Calling initcall 0x78a52b00: irlan_init+0x0/0x220()
[   34.025468] initcall 0x78a52b00: irlan_init+0x0/0x220() returned 0.
[   34.031584] initcall 0x78a52b00 ran for 0 msecs: irlan_init+0x0/0x220()
[   34.038168] Calling initcall 0x78a52d20: ircomm_init+0x0/0x80()
[   34.044062] IrCOMM protocol (Dag Brattli)
[   34.048054] initcall 0x78a52d20: ircomm_init+0x0/0x80() returned 0.
[   34.054288] initcall 0x78a52d20 ran for 2 msecs: ircomm_init+0x0/0x80()
[   34.060877] Calling initcall 0x78a52da0: ircomm_tty_init+0x0/0x170()
[   34.067661] initcall 0x78a52da0: ircomm_tty_init+0x0/0x170() returned 0.
[   34.074203] initcall 0x78a52da0 ran for 3 msecs: ircomm_tty_init+0x0/0x170()
[   34.081224] Calling initcall 0x78a52f40: init_sunrpc+0x0/0x60()
[   34.087314] RPC: Registered udp transport module.
[   34.091899] RPC: Registered tcp transport module.
[   34.096582] initcall 0x78a52f40: init_sunrpc+0x0/0x60() returned 0.
[   34.102807] initcall 0x78a52f40 ran for 4 msecs: init_sunrpc+0x0/0x60()
[   34.109398] Calling initcall 0x78a52fa0: init_rpcsec_gss+0x0/0x30()
[   34.115663] initcall 0x78a52fa0: init_rpcsec_gss+0x0/0x30() returned 0.
[   34.122218] initcall 0x78a52fa0 ran for 0 msecs: init_rpcsec_gss+0x0/0x30()
[   34.129156] Calling initcall 0x78a52fd0: init_kerberos_module+0x0/0x30()
[   34.135851] initcall 0x78a52fd0: init_kerberos_module+0x0/0x30() returned 0.
[   34.142843] initcall 0x78a52fd0 ran for 0 msecs: init_kerberos_module+0x0/0x30()
[   34.150215] Calling initcall 0x78a53000: decnet_init+0x0/0x80()
[   34.156104] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   34.163935] DECnet: Routing cache hash table of 1024 buckets, 32Kbytes
[   34.170475] NET: Registered protocol family 12
[   34.174836] initcall 0x78a53000: decnet_init+0x0/0x80() returned 0.
[   34.181065] initcall 0x78a53000 ran for 11 msecs: decnet_init+0x0/0x80()
[   34.187737] Calling initcall 0x78a53360: econet_proto_init+0x0/0x40()
[   34.194154] NET: Registered protocol family 19
[   34.198578] initcall 0x78a53360: econet_proto_init+0x0/0x40() returned 0.
[   34.205324] initcall 0x78a53360 ran for 4 msecs: econet_proto_init+0x0/0x40()
[   34.212437] Calling initcall 0x78a533a0: vlan_proto_init+0x0/0xd0()
[   34.218673] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   34.225437] All bugs added by David S. Miller <davem@redhat.com>
[   34.231437] initcall 0x78a533a0: vlan_proto_init+0x0/0xd0() returned 0.
[   34.238000] initcall 0x78a533a0 ran for 5 msecs: vlan_proto_init+0x0/0xd0()
[   34.244933] Calling initcall 0x78a534d0: dccp_init+0x0/0x2c0()
[   34.259060] initcall 0x78a534d0: dccp_init+0x0/0x2c0() returned 0.
[   34.265092] initcall 0x78a534d0 ran for 8 msecs: dccp_init+0x0/0x2c0()
[   34.271591] Calling initcall 0x78a537d0: dccp_v4_init+0x0/0xa0()
[   34.287452] initcall 0x78a537d0: dccp_v4_init+0x0/0xa0() returned 0.
[   34.293649] initcall 0x78a537d0 ran for 9 msecs: dccp_v4_init+0x0/0xa0()
[   34.300324] Calling initcall 0x78a53870: dccp_v6_init+0x0/0xa0()
[   34.306330] initcall 0x78a53870: dccp_v6_init+0x0/0xa0() returned 0.
[   34.312630] initcall 0x78a53870 ran for 0 msecs: dccp_v6_init+0x0/0xa0()
[   34.319308] Calling initcall 0x78a539a0: ieee80211_init+0x0/0xb0()
[   34.325462] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   34.332047] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   34.340371] initcall 0x78a539a0: ieee80211_init+0x0/0xb0() returned 0.
[   34.346859] initcall 0x78a539a0 ran for 4 msecs: ieee80211_init+0x0/0xb0()
[   34.353708] Calling initcall 0x78a53a50: ieee80211_crypto_init+0x0/0x10()
[   34.360496] ieee80211_crypt: registered algorithm 'NULL'
[   34.365763] initcall 0x78a53a50: ieee80211_crypto_init+0x0/0x10() returned 0.
[   34.372859] initcall 0x78a53a50 ran for 1 msecs: ieee80211_crypto_init+0x0/0x10()
[   34.380318] Calling initcall 0x78a53a60: tipc_init+0x0/0xf0()
[   34.386043] TIPC: Activated (version 1.6.2 compiled Oct 17 2007 19:33:19)
[   34.394334] NET: Registered protocol family 30
[   34.398661] TIPC: Started in single node mode
[   34.402993] initcall 0x78a53a60: tipc_init+0x0/0xf0() returned 0.
[   34.409050] initcall 0x78a53a60 ran for 12 msecs: tipc_init+0x0/0xf0()
[   34.415555] Calling initcall 0x78a53bd0: init_p9+0x0/0x60()
[   34.421111] Installing 9P2000 support
[   34.424799] initcall 0x78a53bd0: init_p9+0x0/0x60() returned 0.
[   34.430626] initcall 0x78a53bd0 ran for 3 msecs: init_p9+0x0/0x60()
[   34.436868] Calling initcall 0x78a1d910: centrino_init+0x0/0x20()
[   34.442940] initcall 0x78a1d910: centrino_init+0x0/0x20() returned -19.
[   34.449520] initcall 0x78a1d910 ran for 0 msecs: centrino_init+0x0/0x20()
[   34.456285] Calling initcall 0x78a1fb20: check_nmi_watchdog+0x0/0x140()
[   34.462871] initcall 0x78a1fb20: check_nmi_watchdog+0x0/0x140() returned 0.
[   34.469799] initcall 0x78a1fb20 ran for 0 msecs: check_nmi_watchdog+0x0/0x140()
[   34.477078] Calling initcall 0x78a1fd90: io_apic_bug_finalize+0x0/0x20()
[   34.483757] initcall 0x78a1fd90: io_apic_bug_finalize+0x0/0x20() returned 0.
[   34.490774] initcall 0x78a1fd90 ran for 0 msecs: io_apic_bug_finalize+0x0/0x20()
[   34.498142] Calling initcall 0x78a23a30: print_ipi_mode+0x0/0x30()
[   34.504291] Using IPI Shortcut mode
[   34.507766] initcall 0x78a23a30: print_ipi_mode+0x0/0x30() returned 0.
[   34.514259] initcall 0x78a23a30 ran for 3 msecs: print_ipi_mode+0x0/0x30()
[   34.521108] Calling initcall 0x78a24170: disable_boot_consoles+0x0/0x50()
[   34.527868] initcall 0x78a24170: disable_boot_consoles+0x0/0x50() returned 0.
[   34.534971] initcall 0x78a24170 ran for 0 msecs: disable_boot_consoles+0x0/0x50()
[   34.542427] Calling initcall 0x78a25a50: taskstats_init+0x0/0x70()
[   34.548590] initcall 0x78a25a50: taskstats_init+0x0/0x70() returned 0.
[   34.555077] initcall 0x78a25a50 ran for 0 msecs: taskstats_init+0x0/0x70()
[   34.561923] Calling initcall 0x78a2ba30: random32_reseed+0x0/0x30()
[   34.568170] initcall 0x78a2ba30: random32_reseed+0x0/0x30() returned 0.
[   34.574748] initcall 0x78a2ba30 ran for 0 msecs: random32_reseed+0x0/0x30()
[   34.581681] Calling initcall 0x78a2d0a0: pci_sysfs_init+0x0/0x40()
[   34.587941] initcall 0x78a2d0a0: pci_sysfs_init+0x0/0x40() returned 0.
[   34.594334] initcall 0x78a2d0a0 ran for 0 msecs: pci_sysfs_init+0x0/0x40()
[   34.601180] Calling initcall 0x78a2d3f0: seqgen_init+0x0/0x10()
[   34.607090] initcall 0x78a2d3f0: seqgen_init+0x0/0x10() returned 0.
[   34.613310] initcall 0x78a2d3f0 ran for 0 msecs: seqgen_init+0x0/0x10()
[   34.619895] Calling initcall 0x784c9750: scsi_complete_async_scans+0x0/0xe0()
[   34.627008] initcall 0x784c9750: scsi_complete_async_scans+0x0/0xe0() returned 0.
[   34.634458] initcall 0x784c9750 ran for 0 msecs: scsi_complete_async_scans+0x0/0xe0()
[   34.642260] Calling initcall 0x78a4ec80: tcp_congestion_default+0x0/0x10()
[   34.649106] initcall 0x78a4ec80: tcp_congestion_default+0x0/0x10() returned 0.
[   34.656839] initcall 0x78a4ec80 ran for 0 msecs: tcp_congestion_default+0x0/0x10()
[   34.664384] Calling initcall 0x78a4fcd0: ip_auto_config+0x0/0xdc0()
[   34.670627] initcall 0x78a4fcd0: ip_auto_config+0x0/0xdc0() returned 0.
[   34.677203] initcall 0x78a4fcd0 ran for 0 msecs: ip_auto_config+0x0/0xdc0()
[   34.702979] EXT3-fs: INFO: recovery required on readonly filesystem.
[   34.709208] EXT3-fs: write access will be enabled during recovery.
[   35.007671] (fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status 0, recovered transactions 51094 to 51120
[   35.018561] (fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 843 and revoked 183/307 blocks
[   35.088716] kjournald starting.  Commit interval 5 seconds
[   35.094109] EXT3-fs: recovery complete.
[   35.098960] EXT3-fs: mounted filesystem with ordered data mode.
[   35.104779] VFS: Mounted root (ext3 filesystem) readonly.
[   35.110490] Freeing unused kernel memory: 372k freed
[   38.379727] warning: process `kmodule' used the removed sysctl system call with 1.23.
[   39.747156] BUG: unable to handle kernel paging request at virtual address 7ca9e000
[   39.754656] printing eip: 784e9480 *pde = 00dda027 *pte = 04a9e000 
[   39.760896] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   39.765056] 
[   39.766530] Pid: 0, comm: swapper Not tainted (2.6.23 #6)
[   39.771903] EIP: 0060:[<784e9480>] EFLAGS: 00010087 CPU: 0
[   39.777366] EIP is at ata_qc_issue+0x90/0x380
[   39.781694] EAX: 7ca9dff0 EBX: 0000001f ECX: 7ca9dff0 EDX: 79181e60
[   39.787934] ESI: 00000020 EDI: 7ca9de00 EBP: 7b54007c ESP: 78a13e18
[   39.794174]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   39.799547] Process swapper (pid: 0, ti=78a12000 task=789753e0 task.ti=78a12000)
[   39.806739] Stack: 7ca9de00 7b540000 7b540000 00000000 7ca9dfe0 7b54007c 7ca14e00 7b5417a4 
[   39.815058]        784c2490 784ef69e 784f21f3 7b52de98 7ca14e00 7b540000 7b5417a4 7ca14e00 
[   39.823378]        7b540000 7b524004 784f22e0 784ef380 784c2490 7ca14e00 00000202 7b524004 
[   39.831698] Call Trace:
[   39.834299]  [<784c2490>] scsi_done+0x0/0x20
[   39.838545]  [<784ef69e>] ata_scsi_translate+0xbe/0x140
[   39.843743]  [<784f21f3>] ata_scsi_queuecmd+0x33/0x200
[   39.848857]  [<784f22e0>] ata_scsi_queuecmd+0x120/0x200
[   39.854057]  [<784ef380>] ata_scsi_rw_xlat+0x0/0x220
[   39.858996]  [<784c2490>] scsi_done+0x0/0x20
[   39.863243]  [<784c2d12>] scsi_dispatch_cmd+0x152/0x290
[   39.868442]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[   39.873468]  [<784c8c7e>] scsi_request_fn+0x1be/0x370
[   39.878495]  [<78408086>] blk_run_queue+0x36/0x80
[   39.883174]  [<784c7520>] scsi_next_command+0x30/0x50
[   39.888201]  [<784c76ab>] scsi_end_request+0xab/0xe0
[   39.893140]  [<784c83f9>] scsi_io_completion+0xa9/0x3d0
[   39.898340]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[   39.903367]  [<78405125>] blk_done_softirq+0x45/0x80
[   39.908306]  [<78405153>] blk_done_softirq+0x73/0x80
[   39.913246]  [<7811d4c3>] __do_softirq+0x53/0xb0
[   39.917839]  [<7811d588>] do_softirq+0x68/0x70
[   39.922258]  [<78105351>] do_IRQ+0x51/0x90
[   39.926332]  [<7810f2d0>] pgd_dtor+0x0/0x50
[   39.930491]  [<7810388e>] common_interrupt+0x2e/0x40
[   39.935431]  [<7810f2d0>] pgd_dtor+0x0/0x50
[   39.939591]  [<7815f3bf>] quicklist_trim+0x5f/0x90
[   39.944357]  [<7810f2cb>] check_pgt_cache+0x1b/0x20
[   39.949210]  [<78100c52>] cpu_idle+0x32/0x60
[   39.953457]  [<78a14b35>] start_kernel+0x265/0x300
[   39.958223]  [<78a14380>] unknown_bootoption+0x0/0x1e0
[   39.963336]  =======================
[   39.966889] Code: 00 00 00 8b 45 34 a8 02 0f 84 ed 00 00 00 8b bd 88 00 00 00 31 db 89 3c 24 8b 75 3c 89 f8 c7 44 24 10 00 00 00 00 eb 1b 8d 76 00 <8b> 50 10 8d 48 10 f6 c2 01 0f 85 be 02 00 00 89 44 24 10 83 c3 
[   39.985695] EIP: [<784e9480>] ata_qc_issue+0x90/0x380 SS:ESP 0068:78a13e18
[   39.992541] Kernel panic - not syncing: Fatal exception in interrupt

--7AUc2qLy4jB3hD7Z--
