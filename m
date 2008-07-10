Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYGJUxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYGJUxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYGJUxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:53:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54630 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbYGJUxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:53:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: ACPI Error under 2.6.26-rc*
Date: Thu, 10 Jul 2008 22:55:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andre Prendel <andre_prendel@gmx.de>, kernel-testers@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
References: <20080709083829.GA5748@linux.int.dgn.ag>
In-Reply-To: <20080709083829.GA5748@linux.int.dgn.ag>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102255.23090.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs.]

On Wednesday, 9 of July 2008, Andre Prendel wrote:
> Hi,
> 
> I have had some ACPI Problems working under the 2.6.26-rc's in the last weeks.
> Power off does not work well. "System halted" is the last output, but power is
> not switch off. The lastest stable kernel (2.6.25.10) works fine for me. After
> that I tried 2.6.26-rc1 and the error occurs. AFAIR I had these problems with
> all 2.6.26-rc's until 2.6.26-rc8-git4. I did not tested newer ones.
> 
> Dmesg output is attached.
> 
> Andre
> 
> ----------------------------------
> [    0.000000] Linux version 2.6.26-rc1 (andre@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #8 SMP Tue Jul 8 22:28:14 CEST 2008
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
> [    0.000000]  BIOS-e820: 0000000021ff0000 - 0000000021ff8000 (ACPI data)
> [    0.000000]  BIOS-e820: 0000000021ff8000 - 0000000022000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> [    0.000000] x86: PAT support disabled.
> [    0.000000] 511MB LOWMEM available.
> [    0.000000] Entering add_active_range(0, 0, 131056) 0 entries of 256 used
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   Normal       4096 ->   131056
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[1] active PFN ranges
> [    0.000000]     0:        0 ->   131056
> [    0.000000] On node 0 totalpages: 131056
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
> [    0.000000]   Normal zone: 991 pages used for memmap
> [    0.000000]   Normal zone: 125969 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] DMI 2.3 present.
> [    0.000000] ACPI: RSDP 000FA340, 0014 (r0 AMI   )
> [    0.000000] ACPI:      21FF0000, 0000 (r0                        0             0)
> [    0.000000] ACPI Error (tbutils-0472): Invalid length 0x0 in RSDT/XSDT [20080321]
> [    0.000000] Allocating PCI resources starting at 30000000 (gap: 22000000:dcc00000)
> [    0.000000] SMP: Allowing 0 CPUs, 0 hotplug CPUs
> [    0.000000] PERCPU: Allocating 39184 bytes of per cpu data
> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 1
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130033
> [    0.000000] Kernel command line: root=/dev/mapper/lvm--sdb-root ro
> [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
> [    0.000000] mapped APIC to ffffb000 (0140d000)
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
> [    0.000000] Detected 1659.680 MHz processor.
> [    0.004000] Console: colour VGA+ 80x25
> [    0.004000] console [tty0] enabled
> [    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.004000] Memory: 501880k/524224k available (2364k kernel code, 21736k reserved, 1107k data, 248k init, 0k highmem)
> [    0.004000] virtual kernel memory layout:
> [    0.004000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
> [    0.004000]     vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
> [    0.004000]     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
> [    0.004000]       .init : 0xc046b000 - 0xc04a9000   ( 248 kB)
> [    0.004000]       .data : 0xc034f1e1 - 0xc0464040   (1107 kB)
> [    0.004000]       .text : 0xc0100000 - 0xc034f1e1   (2364 kB)
> [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
> [    0.004000] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.084007] Calibrating delay using timer specific routine.. 3321.01 BogoMIPS (lpj=6642038)
> [    0.084161] Security Framework initialized
> [    0.084234] SELinux:  Disabled at boot.
> [    0.084315] Mount-cache hash table entries: 512
> [    0.084593] CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
> [    0.084666] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.084738] CPU: L2 Cache: 256K (64 bytes/line)
> [    0.084817] Checking 'hlt' instruction... OK.
> [    0.100346] SMP alternatives: switching to UP code
> [    0.104041] Freeing SMP alternatives: 11k freed
> [    0.104109] ACPI: Core revision 20080321
> [    0.104257] ACPI Exception (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20080321]
> [    0.104432] ACPI: Unable to load the System Description Tables
> [    0.104586] weird, boot CPU (#0) not listedby the BIOS.
> [    0.104655] SMP motherboard not detected.
> [    0.104721] Local APIC not detected. Using dummy APIC emulation.
> [    0.104790] SMP disabled
> [    0.104937] Brought up 1 CPUs
> [    0.105001] Total of 1 processors activated (3321.01 BogoMIPS).
> [    0.105099] CPU0 attaching sched-domain:
> [    0.105103]  domain 0: span 0
> [    0.105106]   groups: 0
> [    0.105236] PM: Adding info for No Bus:platform
> [    0.105470] net_namespace: 644 bytes
> [    0.105787] NET: Registered protocol family 16
> [    0.106060] No dock devices found.
> [    0.106199] PM: Adding info for No Bus:vtcon0
> [    0.107540] PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
> [    0.107612] PCI: Using configuration type 1 for base access
> [    0.107681] Setting up standard PCI resources
> [    0.109171] PM: Adding info for No Bus:default
> [    0.109343] ACPI: Interpreter disabled.
> [    0.109412] Linux Plug and Play Support v0.97 (c) Adam Belay
> [    0.109524] pnp: PnP ACPI: disabled
> [    0.109823] SCSI subsystem initialized
> [    0.109922] libata version 3.00 loaded.
> [    0.110115] PCI: Probing PCI hardware
> [    0.110195] PCI: Probing PCI hardware (bus 00)
> [    0.110205] PM: Adding info for No Bus:pci0000:00
> [    0.110216] PM: Adding info for No Bus:0000:00
> [    0.110388] pci 0000:00:02.0: Enabling SiS 96x SMBus
> [    0.111026] PM: Adding info for pci:0000:00:00.0
> [    0.111083] PM: Adding info for pci:0000:00:01.0
> [    0.111133] PM: Adding info for pci:0000:00:02.0
> [    0.111190] PM: Adding info for pci:0000:00:02.1
> [    0.111239] PM: Adding info for pci:0000:00:02.2
> [    0.111292] PM: Adding info for pci:0000:00:02.3
> [    0.111343] PM: Adding info for pci:0000:00:02.5
> [    0.111400] PM: Adding info for pci:0000:00:02.7
> [    0.111456] PM: Adding info for pci:0000:00:0d.0
> [    0.111507] PM: Adding info for pci:0000:00:13.0
> [    0.111558] PM: Adding info for pci:0000:00:13.1
> [    0.111615] PM: Adding info for pci:0000:00:13.2
> [    0.111665] PM: Adding info for pci:0000:01:00.0
> [    0.111708] PM: Adding info for No Bus:0000:01
> [    0.111811] PCI: Using IRQ router SIS [1039/0018] at 0000:00:02.0
> [    0.111900] PCI: setting IRQ 11 as level-triggered
> [    0.111903] PCI: Found IRQ 11 for device 0000:00:02.1
> [    0.111986] PCI: Sharing IRQ 11 with 0000:00:13.1
> [    0.112307] NET: Registered protocol family 8
> [    0.112374] NET: Registered protocol family 20
> [    0.112597] PM: Adding info for No Bus:mem
> [    0.112636] PM: Adding info for No Bus:kmem
> [    0.112674] PM: Adding info for No Bus:null
> [    0.112710] PM: Adding info for No Bus:port
> [    0.112747] PM: Adding info for No Bus:zero
> [    0.112785] PM: Adding info for No Bus:full
> [    0.112822] PM: Adding info for No Bus:random
> [    0.112863] PM: Adding info for No Bus:urandom
> [    0.112901] PM: Adding info for No Bus:kmsg
> [    0.113004] PM: Adding info for No Bus:lo
> [    0.113074] PCI: Bridge: 0000:00:01.0
> [    0.113140]   IO window: disabled.
> [    0.113209]   MEM window: 0xcde00000-0xcfefffff
> [    0.113278]   PREFETCH window: 0x00000000c5c00000-0x00000000cdcfffff
> [    0.113376] NET: Registered protocol family 2
> [    0.113558] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.113912] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> [    0.114273] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
> [    0.114613] TCP: Hash tables configured (established 16384 bind 16384)
> [    0.114685] TCP reno registered
> [    0.114888] NET: Registered protocol family 1
> [    0.115128] checking if image is initramfs... it is
> [    1.446353] Freeing initrd memory: 12959k freed
> [    1.446954] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
> [    1.447090] PM: Adding info for No Bus:apm_bios
> [    1.447519] audit: initializing netlink socket (disabled)
> [    1.447610] type=2000 audit(1215557401.444:1): initialized
> [    1.457268] VFS: Disk quotas dquot_6.5.1
> [    1.457455] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    1.457885] msgmni has been set to 1005 for ipc namespace c0442b40
> [    1.458115] io scheduler noop registered
> [    1.458181] io scheduler anticipatory registered
> [    1.458248] io scheduler deadline registered
> [    1.458326] io scheduler cfq registered (default)
> [    1.458493] pci 0000:01:00.0: Boot video device
> [    1.458778] PM: Adding info for No Bus:tty
> [    1.458832] PM: Adding info for No Bus:console
> [    1.458878] PM: Adding info for No Bus:ptmx
> [    1.458919] PM: Adding info for No Bus:tty0
> [    1.458996] PM: Adding info for No Bus:vcs
> [    1.459036] PM: Adding info for No Bus:vcsa
> [    1.459091] PM: Adding info for No Bus:tty1
> [    1.459132] PM: Adding info for No Bus:tty2
> [    1.459172] PM: Adding info for No Bus:tty3
> [    1.459212] PM: Adding info for No Bus:tty4
> [    1.459254] PM: Adding info for No Bus:tty5
> [    1.459294] PM: Adding info for No Bus:tty6
> [    1.459334] PM: Adding info for No Bus:tty7
> [    1.459375] PM: Adding info for No Bus:tty8
> [    1.459416] PM: Adding info for No Bus:tty9
> [    1.459466] PM: Adding info for No Bus:tty10
> [    1.459508] PM: Adding info for No Bus:tty11
> [    1.459548] PM: Adding info for No Bus:tty12
> [    1.459590] PM: Adding info for No Bus:tty13
> [    1.459632] PM: Adding info for No Bus:tty14
> [    1.459677] PM: Adding info for No Bus:tty15
> [    1.459717] PM: Adding info for No Bus:tty16
> [    1.459759] PM: Adding info for No Bus:tty17
> [    1.459799] PM: Adding info for No Bus:tty18
> [    1.459843] PM: Adding info for No Bus:tty19
> [    1.459883] PM: Adding info for No Bus:tty20
> [    1.459926] PM: Adding info for No Bus:tty21
> [    1.459967] PM: Adding info for No Bus:tty22
> [    1.460009] PM: Adding info for No Bus:tty23
> [    1.460058] PM: Adding info for No Bus:tty24
> [    1.460519] PM: Adding info for No Bus:tty25
> [    1.460569] PM: Adding info for No Bus:tty26
> [    1.460608] PM: Adding info for No Bus:tty27
> [    1.460649] PM: Adding info for No Bus:tty28
> [    1.460691] PM: Adding info for No Bus:tty29
> [    1.460732] PM: Adding info for No Bus:tty30
> [    1.460773] PM: Adding info for No Bus:tty31
> [    1.460814] PM: Adding info for No Bus:tty32
> [    1.460855] PM: Adding info for No Bus:tty33
> [    1.460897] PM: Adding info for No Bus:tty34
> [    1.460938] PM: Adding info for No Bus:tty35
> [    1.460978] PM: Adding info for No Bus:tty36
> [    1.461019] PM: Adding info for No Bus:tty37
> [    1.461066] PM: Adding info for No Bus:tty38
> [    1.461108] PM: Adding info for No Bus:tty39
> [    1.461150] PM: Adding info for No Bus:tty40
> [    1.461191] PM: Adding info for No Bus:tty41
> [    1.461232] PM: Adding info for No Bus:tty42
> [    1.461274] PM: Adding info for No Bus:tty43
> [    1.461317] PM: Adding info for No Bus:tty44
> [    1.461358] PM: Adding info for No Bus:tty45
> [    1.461399] PM: Adding info for No Bus:tty46
> [    1.461440] PM: Adding info for No Bus:tty47
> [    1.461481] PM: Adding info for No Bus:tty48
> [    1.461523] PM: Adding info for No Bus:tty49
> [    1.461563] PM: Adding info for No Bus:tty50
> [    1.461604] PM: Adding info for No Bus:tty51
> [    1.461652] PM: Adding info for No Bus:tty52
> [    1.461694] PM: Adding info for No Bus:tty53
> [    1.461736] PM: Adding info for No Bus:tty54
> [    1.461778] PM: Adding info for No Bus:tty55
> [    1.461819] PM: Adding info for No Bus:tty56
> [    1.461861] PM: Adding info for No Bus:tty57
> [    1.461902] PM: Adding info for No Bus:tty58
> [    1.461943] PM: Adding info for No Bus:tty59
> [    1.461984] PM: Adding info for No Bus:tty60
> [    1.462025] PM: Adding info for No Bus:tty61
> [    1.462066] PM: Adding info for No Bus:tty62
> [    1.462110] PM: Adding info for No Bus:tty63
> [    1.462223] PM: Adding info for No Bus:ptyp0
> [    1.462276] PM: Adding info for No Bus:ptyp1
> [    1.462340] PM: Adding info for No Bus:ptyp2
> [    1.462382] PM: Adding info for No Bus:ptyp3
> [    1.462423] PM: Adding info for No Bus:ptyp4
> [    1.462465] PM: Adding info for No Bus:ptyp5
> [    1.462508] PM: Adding info for No Bus:ptyp6
> [    1.462549] PM: Adding info for No Bus:ptyp7
> [    1.462592] PM: Adding info for No Bus:ptyp8
> [    1.462639] PM: Adding info for No Bus:ptyp9
> [    1.462684] PM: Adding info for No Bus:ptypa
> [    1.462726] PM: Adding info for No Bus:ptypb
> [    1.462768] PM: Adding info for No Bus:ptypc
> [    1.462810] PM: Adding info for No Bus:ptypd
> [    1.462854] PM: Adding info for No Bus:ptype
> [    1.462896] PM: Adding info for No Bus:ptypf
> [    1.462946] PM: Adding info for No Bus:ptyq0
> [    1.462992] PM: Adding info for No Bus:ptyq1
> [    1.463038] PM: Adding info for No Bus:ptyq2
> [    1.463081] PM: Adding info for No Bus:ptyq3
> [    1.463126] PM: Adding info for No Bus:ptyq4
> [    1.463168] PM: Adding info for No Bus:ptyq5
> [    1.463212] PM: Adding info for No Bus:ptyq6
> [    1.463254] PM: Adding info for No Bus:ptyq7
> [    1.463298] PM: Adding info for No Bus:ptyq8
> [    1.463340] PM: Adding info for No Bus:ptyq9
> [    1.463386] PM: Adding info for No Bus:ptyqa
> [    1.463429] PM: Adding info for No Bus:ptyqb
> [    1.463472] PM: Adding info for No Bus:ptyqc
> [    1.463515] PM: Adding info for No Bus:ptyqd
> [    1.463562] PM: Adding info for No Bus:ptyqe
> [    1.463616] PM: Adding info for No Bus:ptyqf
> [    1.463660] PM: Adding info for No Bus:ptyr0
> [    1.463703] PM: Adding info for No Bus:ptyr1
> [    1.463753] PM: Adding info for No Bus:ptyr2
> [    1.463799] PM: Adding info for No Bus:ptyr3
> [    1.463843] PM: Adding info for No Bus:ptyr4
> [    1.463886] PM: Adding info for No Bus:ptyr5
> [    1.463932] PM: Adding info for No Bus:ptyr6
> [    1.463976] PM: Adding info for No Bus:ptyr7
> [    1.464021] PM: Adding info for No Bus:ptyr8
> [    1.464065] PM: Adding info for No Bus:ptyr9
> [    1.464141] PM: Adding info for No Bus:ptyra
> [    1.464186] PM: Adding info for No Bus:ptyrb
> [    1.464232] PM: Adding info for No Bus:ptyrc
> [    1.464286] PM: Adding info for No Bus:ptyrd
> [    1.464349] PM: Adding info for No Bus:ptyre
> [    1.464395] PM: Adding info for No Bus:ptyrf
> [    1.464438] PM: Adding info for No Bus:ptys0
> [    1.464482] PM: Adding info for No Bus:ptys1
> [    1.464529] PM: Adding info for No Bus:ptys2
> [    1.464573] PM: Adding info for No Bus:ptys3
> [    1.464616] PM: Adding info for No Bus:ptys4
> [    1.464662] PM: Adding info for No Bus:ptys5
> [    1.464707] PM: Adding info for No Bus:ptys6
> [    1.464751] PM: Adding info for No Bus:ptys7
> [    1.464794] PM: Adding info for No Bus:ptys8
> [    1.464838] PM: Adding info for No Bus:ptys9
> [    1.464883] PM: Adding info for No Bus:ptysa
> [    1.464946] PM: Adding info for No Bus:ptysb
> [    1.464992] PM: Adding info for No Bus:ptysc
> [    1.465037] PM: Adding info for No Bus:ptysd
> [    1.465084] PM: Adding info for No Bus:ptyse
> [    1.465129] PM: Adding info for No Bus:ptysf
> [    1.465172] PM: Adding info for No Bus:ptyt0
> [    1.465215] PM: Adding info for No Bus:ptyt1
> [    1.465261] PM: Adding info for No Bus:ptyt2
> [    1.465305] PM: Adding info for No Bus:ptyt3
> [    1.465349] PM: Adding info for No Bus:ptyt4
> [    1.465393] PM: Adding info for No Bus:ptyt5
> [    1.465440] PM: Adding info for No Bus:ptyt6
> [    1.465486] PM: Adding info for No Bus:ptyt7
> [    1.465529] PM: Adding info for No Bus:ptyt8
> [    1.465581] PM: Adding info for No Bus:ptyt9
> [    1.465627] PM: Adding info for No Bus:ptyta
> [    1.465672] PM: Adding info for No Bus:ptytb
> [    1.465716] PM: Adding info for No Bus:ptytc
> [    1.465760] PM: Adding info for No Bus:ptytd
> [    1.465807] PM: Adding info for No Bus:ptyte
> [    1.465852] PM: Adding info for No Bus:ptytf
> [    1.465899] PM: Adding info for No Bus:ptyu0
> [    1.465945] PM: Adding info for No Bus:ptyu1
> [    1.465991] PM: Adding info for No Bus:ptyu2
> [    1.466044] PM: Adding info for No Bus:ptyu3
> [    1.466092] PM: Adding info for No Bus:ptyu4
> [    1.466136] PM: Adding info for No Bus:ptyu5
> [    1.466182] PM: Adding info for No Bus:ptyu6
> [    1.466236] PM: Adding info for No Bus:ptyu7
> [    1.466280] PM: Adding info for No Bus:ptyu8
> [    1.466327] PM: Adding info for No Bus:ptyu9
> [    1.466375] PM: Adding info for No Bus:ptyua
> [    1.466419] PM: Adding info for No Bus:ptyub
> [    1.466464] PM: Adding info for No Bus:ptyuc
> [    1.466508] PM: Adding info for No Bus:ptyud
> [    1.466554] PM: Adding info for No Bus:ptyue
> [    1.466598] PM: Adding info for No Bus:ptyuf
> [    1.466643] PM: Adding info for No Bus:ptyv0
> [    1.466687] PM: Adding info for No Bus:ptyv1
> [    1.466735] PM: Adding info for No Bus:ptyv2
> [    1.466780] PM: Adding info for No Bus:ptyv3
> [    1.466826] PM: Adding info for No Bus:ptyv4
> [    1.466880] PM: Adding info for No Bus:ptyv5
> [    1.466926] PM: Adding info for No Bus:ptyv6
> [    1.466971] PM: Adding info for No Bus:ptyv7
> [    1.467015] PM: Adding info for No Bus:ptyv8
> [    1.467059] PM: Adding info for No Bus:ptyv9
> [    1.467107] PM: Adding info for No Bus:ptyva
> [    1.467154] PM: Adding info for No Bus:ptyvb
> [    1.467199] PM: Adding info for No Bus:ptyvc
> [    1.467247] PM: Adding info for No Bus:ptyvd
> [    1.467314] PM: Adding info for No Bus:ptyve
> [    1.467360] PM: Adding info for No Bus:ptyvf
> [    1.467405] PM: Adding info for No Bus:ptyw0
> [    1.467450] PM: Adding info for No Bus:ptyw1
> [    1.467496] PM: Adding info for No Bus:ptyw2
> [    1.467542] PM: Adding info for No Bus:ptyw3
> [    1.467598] PM: Adding info for No Bus:ptyw4
> [    1.467643] PM: Adding info for No Bus:ptyw5
> [    1.467690] PM: Adding info for No Bus:ptyw6
> [    1.467734] PM: Adding info for No Bus:ptyw7
> [    1.467781] PM: Adding info for No Bus:ptyw8
> [    1.467827] PM: Adding info for No Bus:ptyw9
> [    1.467874] PM: Adding info for No Bus:ptywa
> [    1.467919] PM: Adding info for No Bus:ptywb
> [    1.467964] PM: Adding info for No Bus:ptywc
> [    1.468016] PM: Adding info for No Bus:ptywd
> [    1.468065] PM: Adding info for No Bus:ptywe
> [    1.468145] PM: Adding info for No Bus:ptywf
> [    1.468192] PM: Adding info for No Bus:ptyx0
> [    1.468240] PM: Adding info for No Bus:ptyx1
> [    1.468301] PM: Adding info for No Bus:ptyx2
> [    1.468348] PM: Adding info for No Bus:ptyx3
> [    1.468395] PM: Adding info for No Bus:ptyx4
> [    1.468443] PM: Adding info for No Bus:ptyx5
> [    1.468494] PM: Adding info for No Bus:ptyx6
> [    1.468545] PM: Adding info for No Bus:ptyx7
> [    1.468594] PM: Adding info for No Bus:ptyx8
> [    1.468641] PM: Adding info for No Bus:ptyx9
> [    1.468690] PM: Adding info for No Bus:ptyxa
> [    1.468737] PM: Adding info for No Bus:ptyxb
> [    1.468788] PM: Adding info for No Bus:ptyxc
> [    1.468836] PM: Adding info for No Bus:ptyxd
> [    1.468885] PM: Adding info for No Bus:ptyxe
> [    1.468935] PM: Adding info for No Bus:ptyxf
> [    1.468993] PM: Adding info for No Bus:ptyy0
> [    1.469042] PM: Adding info for No Bus:ptyy1
> [    1.469092] PM: Adding info for No Bus:ptyy2
> [    1.469149] PM: Adding info for No Bus:ptyy3
> [    1.469197] PM: Adding info for No Bus:ptyy4
> [    1.469245] PM: Adding info for No Bus:ptyy5
> [    1.469296] PM: Adding info for No Bus:ptyy6
> [    1.469345] PM: Adding info for No Bus:ptyy7
> [    1.469395] PM: Adding info for No Bus:ptyy8
> [    1.469443] PM: Adding info for No Bus:ptyy9
> [    1.469494] PM: Adding info for No Bus:ptyya
> [    1.469542] PM: Adding info for No Bus:ptyyb
> [    1.469591] PM: Adding info for No Bus:ptyyc
> [    1.469640] PM: Adding info for No Bus:ptyyd
> [    1.469700] PM: Adding info for No Bus:ptyye
> [    1.469748] PM: Adding info for No Bus:ptyyf
> [    1.469802] PM: Adding info for No Bus:ptyz0
> [    1.469852] PM: Adding info for No Bus:ptyz1
> [    1.469903] PM: Adding info for No Bus:ptyz2
> [    1.469951] PM: Adding info for No Bus:ptyz3
> [    1.470000] PM: Adding info for No Bus:ptyz4
> [    1.470049] PM: Adding info for No Bus:ptyz5
> [    1.470099] PM: Adding info for No Bus:ptyz6
> [    1.470149] PM: Adding info for No Bus:ptyz7
> [    1.470198] PM: Adding info for No Bus:ptyz8
> [    1.470247] PM: Adding info for No Bus:ptyz9
> [    1.470302] PM: Adding info for No Bus:ptyza
> [    1.470351] PM: Adding info for No Bus:ptyzb
> [    1.470409] PM: Adding info for No Bus:ptyzc
> [    1.470485] PM: Adding info for No Bus:ptyzd
> [    1.470536] PM: Adding info for No Bus:ptyze
> [    1.470586] PM: Adding info for No Bus:ptyzf
> [    1.470635] PM: Adding info for No Bus:ptya0
> [    1.470684] PM: Adding info for No Bus:ptya1
> [    1.470736] PM: Adding info for No Bus:ptya2
> [    1.470787] PM: Adding info for No Bus:ptya3
> [    1.470838] PM: Adding info for No Bus:ptya4
> [    1.470888] PM: Adding info for No Bus:ptya5
> [    1.470940] PM: Adding info for No Bus:ptya6
> [    1.470990] PM: Adding info for No Bus:ptya7
> [    1.471040] PM: Adding info for No Bus:ptya8
> [    1.471093] PM: Adding info for No Bus:ptya9
> [    1.471153] PM: Adding info for No Bus:ptyaa
> [    1.471203] PM: Adding info for No Bus:ptyab
> [    1.471255] PM: Adding info for No Bus:ptyac
> [    1.471305] PM: Adding info for No Bus:ptyad
> [    1.471359] PM: Adding info for No Bus:ptyae
> [    1.471409] PM: Adding info for No Bus:ptyaf
> [    1.471459] PM: Adding info for No Bus:ptyb0
> [    1.471509] PM: Adding info for No Bus:ptyb1
> [    1.471561] PM: Adding info for No Bus:ptyb2
> [    1.471611] PM: Adding info for No Bus:ptyb3
> [    1.471663] PM: Adding info for No Bus:ptyb4
> [    1.471716] PM: Adding info for No Bus:ptyb5
> [    1.471768] PM: Adding info for No Bus:ptyb6
> [    1.471818] PM: Adding info for No Bus:ptyb7
> [    1.471871] PM: Adding info for No Bus:ptyb8
> [    1.471931] PM: Adding info for No Bus:ptyb9
> [    1.471983] PM: Adding info for No Bus:ptyba
> [    1.472034] PM: Adding info for No Bus:ptybb
> [    1.472114] PM: Adding info for No Bus:ptybc
> [    1.472167] PM: Adding info for No Bus:ptybd
> [    1.472223] PM: Adding info for No Bus:ptybe
> [    1.472273] PM: Adding info for No Bus:ptybf
> [    1.472324] PM: Adding info for No Bus:ptyc0
> [    1.472376] PM: Adding info for No Bus:ptyc1
> [    1.472435] PM: Adding info for No Bus:ptyc2
> [    1.472496] PM: Adding info for No Bus:ptyc3
> [    1.472548] PM: Adding info for No Bus:ptyc4
> [    1.472599] PM: Adding info for No Bus:ptyc5
> [    1.472652] PM: Adding info for No Bus:ptyc6
> [    1.472715] PM: Adding info for No Bus:ptyc7
> [    1.472766] PM: Adding info for No Bus:ptyc8
> [    1.472817] PM: Adding info for No Bus:ptyc9
> [    1.472871] PM: Adding info for No Bus:ptyca
> [    1.472923] PM: Adding info for No Bus:ptycb
> [    1.472975] PM: Adding info for No Bus:ptycc
> [    1.473027] PM: Adding info for No Bus:ptycd
> [    1.473081] PM: Adding info for No Bus:ptyce
> [    1.473133] PM: Adding info for No Bus:ptycf
> [    1.473193] PM: Adding info for No Bus:ptyd0
> [    1.473244] PM: Adding info for No Bus:ptyd1
> [    1.473299] PM: Adding info for No Bus:ptyd2
> [    1.473351] PM: Adding info for No Bus:ptyd3
> [    1.473402] PM: Adding info for No Bus:ptyd4
> [    1.473462] PM: Adding info for No Bus:ptyd5
> [    1.473517] PM: Adding info for No Bus:ptyd6
> [    1.473568] PM: Adding info for No Bus:ptyd7
> [    1.473620] PM: Adding info for No Bus:ptyd8
> [    1.473674] PM: Adding info for No Bus:ptyd9
> [    1.473728] PM: Adding info for No Bus:ptyda
> [    1.473784] PM: Adding info for No Bus:ptydb
> [    1.473836] PM: Adding info for No Bus:ptydc
> [    1.473887] PM: Adding info for No Bus:ptydd
> [    1.473954] PM: Adding info for No Bus:ptyde
> [    1.474007] PM: Adding info for No Bus:ptydf
> [    1.474060] PM: Adding info for No Bus:ptye0
> [    1.474112] PM: Adding info for No Bus:ptye1
> [    1.474169] PM: Adding info for No Bus:ptye2
> [    1.474230] PM: Adding info for No Bus:ptye3
> [    1.474282] PM: Adding info for No Bus:ptye4
> [    1.474335] PM: Adding info for No Bus:ptye5
> [    1.474389] PM: Adding info for No Bus:ptye6
> [    1.474440] PM: Adding info for No Bus:ptye7
> [    1.474493] PM: Adding info for No Bus:ptye8
> [    1.474546] PM: Adding info for No Bus:ptye9
> [    1.474602] PM: Adding info for No Bus:ptyea
> [    1.474656] PM: Adding info for No Bus:ptyeb
> [    1.474709] PM: Adding info for No Bus:ptyec
> [    1.474761] PM: Adding info for No Bus:ptyed
> [    1.474816] PM: Adding info for No Bus:ptyee
> [    1.474868] PM: Adding info for No Bus:ptyef
> [    1.474926] PM: Adding info for No Bus:ttyp0
> [    1.474994] PM: Adding info for No Bus:ttyp1
> [    1.475047] PM: Adding info for No Bus:ttyp2
> [    1.475098] PM: Adding info for No Bus:ttyp3
> [    1.475157] PM: Adding info for No Bus:ttyp4
> [    1.475208] PM: Adding info for No Bus:ttyp5
> [    1.475260] PM: Adding info for No Bus:ttyp6
> [    1.475312] PM: Adding info for No Bus:ttyp7
> [    1.475363] PM: Adding info for No Bus:ttyp8
> [    1.475414] PM: Adding info for No Bus:ttyp9
> [    1.475467] PM: Adding info for No Bus:ttypa
> [    1.475518] PM: Adding info for No Bus:ttypb
> [    1.475568] PM: Adding info for No Bus:ttypc
> [    1.475622] PM: Adding info for No Bus:ttypd
> [    1.475678] PM: Adding info for No Bus:ttype
> [    1.475739] PM: Adding info for No Bus:ttypf
> [    1.475790] PM: Adding info for No Bus:ttyq0
> [    1.475843] PM: Adding info for No Bus:ttyq1
> [    1.475897] PM: Adding info for No Bus:ttyq2
> [    1.475958] PM: Adding info for No Bus:ttyq3
> [    1.476009] PM: Adding info for No Bus:ttyq4
> [    1.476061] PM: Adding info for No Bus:ttyq5
> [    1.477087] PM: Adding info for No Bus:ttyq6
> [    1.477161] PM: Adding info for No Bus:ttyq7
> [    1.477215] PM: Adding info for No Bus:ttyq8
> [    1.477267] PM: Adding info for No Bus:ttyq9
> [    1.477320] PM: Adding info for No Bus:ttyqa
> [    1.477371] PM: Adding info for No Bus:ttyqb
> [    1.477423] PM: Adding info for No Bus:ttyqc
> [    1.477475] PM: Adding info for No Bus:ttyqd
> [    1.477531] PM: Adding info for No Bus:ttyqe
> [    1.477585] PM: Adding info for No Bus:ttyqf
> [    1.477638] PM: Adding info for No Bus:ttyr0
> [    1.477691] PM: Adding info for No Bus:ttyr1
> [    1.477744] PM: Adding info for No Bus:ttyr2
> [    1.477797] PM: Adding info for No Bus:ttyr3
> [    1.477849] PM: Adding info for No Bus:ttyr4
> [    1.477902] PM: Adding info for No Bus:ttyr5
> [    1.477954] PM: Adding info for No Bus:ttyr6
> [    1.478008] PM: Adding info for No Bus:ttyr7
> [    1.478060] PM: Adding info for No Bus:ttyr8
> [    1.478114] PM: Adding info for No Bus:ttyr9
> [    1.478167] PM: Adding info for No Bus:ttyra
> [    1.478220] PM: Adding info for No Bus:ttyrb
> [    1.478281] PM: Adding info for No Bus:ttyrc
> [    1.478334] PM: Adding info for No Bus:ttyrd
> [    1.478386] PM: Adding info for No Bus:ttyre
> [    1.478439] PM: Adding info for No Bus:ttyrf
> [    1.478492] PM: Adding info for No Bus:ttys0
> [    1.478545] PM: Adding info for No Bus:ttys1
> [    1.478598] PM: Adding info for No Bus:ttys2
> [    1.478651] PM: Adding info for No Bus:ttys3
> [    1.478705] PM: Adding info for No Bus:ttys4
> [    1.478758] PM: Adding info for No Bus:ttys5
> [    1.478811] PM: Adding info for No Bus:ttys6
> [    1.478865] PM: Adding info for No Bus:ttys7
> [    1.478919] PM: Adding info for No Bus:ttys8
> [    1.478973] PM: Adding info for No Bus:ttys9
> [    1.479033] PM: Adding info for No Bus:ttysa
> [    1.479088] PM: Adding info for No Bus:ttysb
> [    1.479143] PM: Adding info for No Bus:ttysc
> [    1.479199] PM: Adding info for No Bus:ttysd
> [    1.479253] PM: Adding info for No Bus:ttyse
> [    1.479308] PM: Adding info for No Bus:ttysf
> [    1.479362] PM: Adding info for No Bus:ttyt0
> [    1.479416] PM: Adding info for No Bus:ttyt1
> [    1.479470] PM: Adding info for No Bus:ttyt2
> [    1.479525] PM: Adding info for No Bus:ttyt3
> [    1.479580] PM: Adding info for No Bus:ttyt4
> [    1.479636] PM: Adding info for No Bus:ttyt5
> [    1.479693] PM: Adding info for No Bus:ttyt6
> [    1.479749] PM: Adding info for No Bus:ttyt7
> [    1.479811] PM: Adding info for No Bus:ttyt8
> [    1.479866] PM: Adding info for No Bus:ttyt9
> [    1.479919] PM: Adding info for No Bus:ttyta
> [    1.479973] PM: Adding info for No Bus:ttytb
> [    1.480028] PM: Adding info for No Bus:ttytc
> [    1.480109] PM: Adding info for No Bus:ttytd
> [    1.480168] PM: Adding info for No Bus:ttyte
> [    1.480225] PM: Adding info for No Bus:ttytf
> [    1.480279] PM: Adding info for No Bus:ttyu0
> [    1.480337] PM: Adding info for No Bus:ttyu1
> [    1.480391] PM: Adding info for No Bus:ttyu2
> [    1.480447] PM: Adding info for No Bus:ttyu3
> [    1.480502] PM: Adding info for No Bus:ttyu4
> [    1.480557] PM: Adding info for No Bus:ttyu5
> [    1.480619] PM: Adding info for No Bus:ttyu6
> [    1.480676] PM: Adding info for No Bus:ttyu7
> [    1.480745] PM: Adding info for No Bus:ttyu8
> [    1.480800] PM: Adding info for No Bus:ttyu9
> [    1.480855] PM: Adding info for No Bus:ttyua
> [    1.480912] PM: Adding info for No Bus:ttyub
> [    1.480968] PM: Adding info for No Bus:ttyuc
> [    1.481023] PM: Adding info for No Bus:ttyud
> [    1.481079] PM: Adding info for No Bus:ttyue
> [    1.481139] PM: Adding info for No Bus:ttyuf
> [    1.481195] PM: Adding info for No Bus:ttyv0
> [    1.481250] PM: Adding info for No Bus:ttyv1
> [    1.481305] PM: Adding info for No Bus:ttyv2
> [    1.481360] PM: Adding info for No Bus:ttyv3
> [    1.481425] PM: Adding info for No Bus:ttyv4
> [    1.481483] PM: Adding info for No Bus:ttyv5
> [    1.481538] PM: Adding info for No Bus:ttyv6
> [    1.481593] PM: Adding info for No Bus:ttyv7
> [    1.481648] PM: Adding info for No Bus:ttyv8
> [    1.481706] PM: Adding info for No Bus:ttyv9
> [    1.481762] PM: Adding info for No Bus:ttyva
> [    1.481817] PM: Adding info for No Bus:ttyvb
> [    1.481873] PM: Adding info for No Bus:ttyvc
> [    1.481928] PM: Adding info for No Bus:ttyvd
> [    1.481995] PM: Adding info for No Bus:ttyve
> [    1.482052] PM: Adding info for No Bus:ttyvf
> [    1.482108] PM: Adding info for No Bus:ttyw0
> [    1.482163] PM: Adding info for No Bus:ttyw1
> [    1.482221] PM: Adding info for No Bus:ttyw2
> [    1.482288] PM: Adding info for No Bus:ttyw3
> [    1.482345] PM: Adding info for No Bus:ttyw4
> [    1.482402] PM: Adding info for No Bus:ttyw5
> [    1.482458] PM: Adding info for No Bus:ttyw6
> [    1.482515] PM: Adding info for No Bus:ttyw7
> [    1.482575] PM: Adding info for No Bus:ttyw8
> [    1.482634] PM: Adding info for No Bus:ttyw9
> [    1.482691] PM: Adding info for No Bus:ttywa
> [    1.482750] PM: Adding info for No Bus:ttywb
> [    1.482808] PM: Adding info for No Bus:ttywc
> [    1.482865] PM: Adding info for No Bus:ttywd
> [    1.482922] PM: Adding info for No Bus:ttywe
> [    1.482980] PM: Adding info for No Bus:ttywf
> [    1.483037] PM: Adding info for No Bus:ttyx0
> [    1.483103] PM: Adding info for No Bus:ttyx1
> [    1.483161] PM: Adding info for No Bus:ttyx2
> [    1.483221] PM: Adding info for No Bus:ttyx3
> [    1.483279] PM: Adding info for No Bus:ttyx4
> [    1.483344] PM: Adding info for No Bus:ttyx5
> [    1.483401] PM: Adding info for No Bus:ttyx6
> [    1.483459] PM: Adding info for No Bus:ttyx7
> [    1.483516] PM: Adding info for No Bus:ttyx8
> [    1.483574] PM: Adding info for No Bus:ttyx9
> [    1.483632] PM: Adding info for No Bus:ttyxa
> [    1.483690] PM: Adding info for No Bus:ttyxb
> [    1.483747] PM: Adding info for No Bus:ttyxc
> [    1.483809] PM: Adding info for No Bus:ttyxd
> [    1.483867] PM: Adding info for No Bus:ttyxe
> [    1.483934] PM: Adding info for No Bus:ttyxf
> [    1.483993] PM: Adding info for No Bus:ttyy0
> [    1.484054] PM: Adding info for No Bus:ttyy1
> [    1.484136] PM: Adding info for No Bus:ttyy2
> [    1.484195] PM: Adding info for No Bus:ttyy3
> [    1.484253] PM: Adding info for No Bus:ttyy4
> [    1.484311] PM: Adding info for No Bus:ttyy5
> [    1.484370] PM: Adding info for No Bus:ttyy6
> [    1.484430] PM: Adding info for No Bus:ttyy7
> [    1.484487] PM: Adding info for No Bus:ttyy8
> [    1.484544] PM: Adding info for No Bus:ttyy9
> [    1.484602] PM: Adding info for No Bus:ttyya
> [    1.484660] PM: Adding info for No Bus:ttyyb
> [    1.484718] PM: Adding info for No Bus:ttyyc
> [    1.484785] PM: Adding info for No Bus:ttyyd
> [    1.484843] PM: Adding info for No Bus:ttyye
> [    1.484905] PM: Adding info for No Bus:ttyyf
> [    1.484964] PM: Adding info for No Bus:ttyz0
> [    1.485024] PM: Adding info for No Bus:ttyz1
> [    1.485083] PM: Adding info for No Bus:ttyz2
> [    1.485141] PM: Adding info for No Bus:ttyz3
> [    1.485201] PM: Adding info for No Bus:ttyz4
> [    1.485259] PM: Adding info for No Bus:ttyz5
> [    1.485319] PM: Adding info for No Bus:ttyz6
> [    1.485377] PM: Adding info for No Bus:ttyz7
> [    1.485438] PM: Adding info for No Bus:ttyz8
> [    1.485498] PM: Adding info for No Bus:ttyz9
> [    1.485562] PM: Adding info for No Bus:ttyza
> [    1.485633] PM: Adding info for No Bus:ttyzb
> [    1.485693] PM: Adding info for No Bus:ttyzc
> [    1.485753] PM: Adding info for No Bus:ttyzd
> [    1.485812] PM: Adding info for No Bus:ttyze
> [    1.485872] PM: Adding info for No Bus:ttyzf
> [    1.485931] PM: Adding info for No Bus:ttya0
> [    1.485992] PM: Adding info for No Bus:ttya1
> [    1.486052] PM: Adding info for No Bus:ttya2
> [    1.486113] PM: Adding info for No Bus:ttya3
> [    1.486172] PM: Adding info for No Bus:ttya4
> [    1.486235] PM: Adding info for No Bus:ttya5
> [    1.486294] PM: Adding info for No Bus:ttya6
> [    1.486353] PM: Adding info for No Bus:ttya7
> [    1.486413] PM: Adding info for No Bus:ttya8
> [    1.486484] PM: Adding info for No Bus:ttya9
> [    1.486546] PM: Adding info for No Bus:ttyaa
> [    1.486607] PM: Adding info for No Bus:ttyab
> [    1.486666] PM: Adding info for No Bus:ttyac
> [    1.486728] PM: Adding info for No Bus:ttyad
> [    1.486789] PM: Adding info for No Bus:ttyae
> [    1.486852] PM: Adding info for No Bus:ttyaf
> [    1.486913] PM: Adding info for No Bus:ttyb0
> [    1.486976] PM: Adding info for No Bus:ttyb1
> [    1.487038] PM: Adding info for No Bus:ttyb2
> [    1.487106] PM: Adding info for No Bus:ttyb3
> [    1.487168] PM: Adding info for No Bus:ttyb4
> [    1.487230] PM: Adding info for No Bus:ttyb5
> [    1.487291] PM: Adding info for No Bus:ttyb6
> [    1.487351] PM: Adding info for No Bus:ttyb7
> [    1.487422] PM: Adding info for No Bus:ttyb8
> [    1.487487] PM: Adding info for No Bus:ttyb9
> [    1.487549] PM: Adding info for No Bus:ttyba
> [    1.487609] PM: Adding info for No Bus:ttybb
> [    1.487673] PM: Adding info for No Bus:ttybc
> [    1.487737] PM: Adding info for No Bus:ttybd
> [    1.487799] PM: Adding info for No Bus:ttybe
> [    1.487861] PM: Adding info for No Bus:ttybf
> [    1.487931] PM: Adding info for No Bus:ttyc0
> [    1.487995] PM: Adding info for No Bus:ttyc1
> [    1.488057] PM: Adding info for No Bus:ttyc2
> [    1.488719] PM: Adding info for No Bus:ttyc3
> [    1.488799] PM: Adding info for No Bus:ttyc4
> [    1.488860] PM: Adding info for No Bus:ttyc5
> [    1.488928] PM: Adding info for No Bus:ttyc6
> [    1.488989] PM: Adding info for No Bus:ttyc7
> [    1.489051] PM: Adding info for No Bus:ttyc8
> [    1.489112] PM: Adding info for No Bus:ttyc9
> [    1.489173] PM: Adding info for No Bus:ttyca
> [    1.489236] PM: Adding info for No Bus:ttycb
> [    1.489299] PM: Adding info for No Bus:ttycc
> [    1.489362] PM: Adding info for No Bus:ttycd
> [    1.489425] PM: Adding info for No Bus:ttyce
> [    1.489488] PM: Adding info for No Bus:ttycf
> [    1.489551] PM: Adding info for No Bus:ttyd0
> [    1.489615] PM: Adding info for No Bus:ttyd1
> [    1.489679] PM: Adding info for No Bus:ttyd2
> [    1.489741] PM: Adding info for No Bus:ttyd3
> [    1.489811] PM: Adding info for No Bus:ttyd4
> [    1.489875] PM: Adding info for No Bus:ttyd5
> [    1.489940] PM: Adding info for No Bus:ttyd6
> [    1.490004] PM: Adding info for No Bus:ttyd7
> [    1.490068] PM: Adding info for No Bus:ttyd8
> [    1.490131] PM: Adding info for No Bus:ttyd9
> [    1.490194] PM: Adding info for No Bus:ttyda
> [    1.490257] PM: Adding info for No Bus:ttydb
> [    1.490320] PM: Adding info for No Bus:ttydc
> [    1.490384] PM: Adding info for No Bus:ttydd
> [    1.490446] PM: Adding info for No Bus:ttyde
> [    1.490509] PM: Adding info for No Bus:ttydf
> [    1.490574] PM: Adding info for No Bus:ttye0
> [    1.490638] PM: Adding info for No Bus:ttye1
> [    1.490710] PM: Adding info for No Bus:ttye2
> [    1.490774] PM: Adding info for No Bus:ttye3
> [    1.490837] PM: Adding info for No Bus:ttye4
> [    1.490900] PM: Adding info for No Bus:ttye5
> [    1.490964] PM: Adding info for No Bus:ttye6
> [    1.491027] PM: Adding info for No Bus:ttye7
> [    1.491090] PM: Adding info for No Bus:ttye8
> [    1.491155] PM: Adding info for No Bus:ttye9
> [    1.491222] PM: Adding info for No Bus:ttyea
> [    1.491286] PM: Adding info for No Bus:ttyeb
> [    1.491351] PM: Adding info for No Bus:ttyec
> [    1.491415] PM: Adding info for No Bus:ttyed
> [    1.491479] PM: Adding info for No Bus:ttyee
> [    1.491544] PM: Adding info for No Bus:ttyef
> [    1.491662] PM: Adding info for No Bus:rtc
> [    1.491724] Real Time Clock Driver v1.12ac
> [    1.491805] PM: Adding info for No Bus:hpet
> [    1.491857] PM: Removing info for No Bus:hpet
> [    1.491913] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> [    1.492031] PM: Adding info for platform:serial8250
> [    1.492191] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.492321] PM: Adding info for No Bus:ttyS0
> [    1.492446] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    1.492547] PM: Adding info for No Bus:ttyS1
> [    1.492630] PM: Adding info for No Bus:ttyS2
> [    1.492710] PM: Adding info for No Bus:ttyS3
> [    1.493038] PM: Adding info for No Bus:ram0
> [    1.493092] PM: Adding info for No Bus:1:0
> [    1.493163] PM: Adding info for No Bus:ram1
> [    1.493213] PM: Adding info for No Bus:1:1
> [    1.493263] PM: Adding info for No Bus:ram2
> [    1.493312] PM: Adding info for No Bus:1:2
> [    1.493362] PM: Adding info for No Bus:ram3
> [    1.493410] PM: Adding info for No Bus:1:3
> [    1.493459] PM: Adding info for No Bus:ram4
> [    1.493509] PM: Adding info for No Bus:1:4
> [    1.493568] PM: Adding info for No Bus:ram5
> [    1.493616] PM: Adding info for No Bus:1:5
> [    1.493665] PM: Adding info for No Bus:ram6
> [    1.493715] PM: Adding info for No Bus:1:6
> [    1.493764] PM: Adding info for No Bus:ram7
> [    1.493812] PM: Adding info for No Bus:1:7
> [    1.493861] PM: Adding info for No Bus:ram8
> [    1.493913] PM: Adding info for No Bus:1:8
> [    1.493980] PM: Adding info for No Bus:ram9
> [    1.494028] PM: Adding info for No Bus:1:9
> [    1.494092] PM: Adding info for No Bus:ram10
> [    1.494139] PM: Adding info for No Bus:1:10
> [    1.494186] PM: Adding info for No Bus:ram11
> [    1.494236] PM: Adding info for No Bus:1:11
> [    1.494283] PM: Adding info for No Bus:ram12
> [    1.494338] PM: Adding info for No Bus:1:12
> [    1.494386] PM: Adding info for No Bus:ram13
> [    1.494435] PM: Adding info for No Bus:1:13
> [    1.494482] PM: Adding info for No Bus:ram14
> [    1.494528] PM: Adding info for No Bus:1:14
> [    1.494576] PM: Adding info for No Bus:ram15
> [    1.494622] PM: Adding info for No Bus:1:15
> [    1.494662] brd: module loaded
> [    1.494788] Driver 'sd' needs updating - please use bus_type methods
> [    1.494971] pata_sis 0000:00:02.5: version 0.5.2
> [    1.495129] scsi0 : pata_sis
> [    1.495343] PM: Adding info for No Bus:host0
> [    1.495363] PM: Adding info for No Bus:host0
> [    1.495424] scsi1 : pata_sis
> [    1.495492] PM: Adding info for No Bus:host1
> [    1.495508] PM: Adding info for No Bus:host1
> [    1.495556] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
> [    1.495630] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
> [    1.680811] ata1.00: ATA-6: IC35L060AVV207-0, V22OA66A, max UDMA/100
> [    1.680884] ata1.00: 120103200 sectors, multi 16: LBA48 
> [    1.681366] ata1.01: ATA-6: IC35L060AVV207-0, V22OA66A, max UDMA/100
> [    1.681437] ata1.01: 120103200 sectors, multi 16: LBA48 
> [    1.704631] ata1.00: configured for UDMA/100
> [    1.728631] ata1.01: configured for UDMA/100
> [    1.892451] ata2.00: ATAPI: TSSTcorpCD-R/RW SH-R522C, TS04, max UDMA/33
> [    1.892539] ata2.01: ATAPI: TSSTcorpDVD-ROM TS-H352A, TS03, max UDMA/33
> [    1.900338] ata2.00: configured for UDMA/33
> [    1.916328] ata2.01: configured for UDMA/33
> [    1.916560] scsi 0:0:0:0: Direct-Access     ATA      IC35L060AVV207-0 V22O PQ: 0 ANSI: 5
> [    1.916668] PM: Adding info for No Bus:target0:0:0
> [    1.916701] PM: Adding info for scsi:0:0:0:0
> [    1.916814] PM: Adding info for No Bus:0:0:0:0
> [    1.916892] sd 0:0:0:0: [sda] 120103200 512-byte hardware sectors (61493 MB)
> [    1.916984] sd 0:0:0:0: [sda] Write Protect is off
> [    1.917052] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.917081] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.917197] PM: Adding info for No Bus:sda
> [    1.917249] sd 0:0:0:0: [sda] 120103200 512-byte hardware sectors (61493 MB)
> [    1.917335] sd 0:0:0:0: [sda] Write Protect is off
> [    1.917403] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.917428] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.917523]  sda: sda1 sda2 sda3 sda4 < sda5 >
> [    1.955208]  sda3: <minix: sda6 sda7 sda8 >
> [    1.955442] PM: Adding info for No Bus:sda1
> [    1.955456] PM: Adding info for No Bus:sda2
> [    1.955468] PM: Adding info for No Bus:sda3
> [    1.955480] PM: Adding info for No Bus:sda4
> [    1.955500] PM: Adding info for No Bus:sda5
> [    1.955512] PM: Adding info for No Bus:sda6
> [    1.955523] PM: Adding info for No Bus:sda7
> [    1.955535] PM: Adding info for No Bus:sda8
> [    1.955902] PM: Adding info for No Bus:8:0
> [    1.955953] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.956033] PM: Adding info for No Bus:0:0:0:0
> [    1.956094] PM: Adding info for No Bus:sg0
> [    1.956151] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.956319] scsi 0:0:1:0: Direct-Access     ATA      IC35L060AVV207-0 V22O PQ: 0 ANSI: 5
> [    1.956416] PM: Adding info for No Bus:target0:0:1
> [    1.956444] PM: Adding info for scsi:0:0:1:0
> [    1.956504] PM: Adding info for No Bus:0:0:1:0
> [    1.956575] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493 MB)
> [    1.956666] sd 0:0:1:0: [sdb] Write Protect is off
> [    1.956734] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.956761] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.956870] PM: Adding info for No Bus:sdb
> [    1.956911] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493 MB)
> [    1.956997] sd 0:0:1:0: [sdb] Write Protect is off
> [    1.957065] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.957091] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.957185]  sdb: sdb1 sdb2
> [    1.968339] PM: Adding info for No Bus:sdb1
> [    1.968353] PM: Adding info for No Bus:sdb2
> [    1.968512] PM: Adding info for No Bus:8:16
> [    1.968557] sd 0:0:1:0: [sdb] Attached SCSI disk
> [    1.968635] PM: Adding info for No Bus:0:0:1:0
> [    1.968690] PM: Adding info for No Bus:sg1
> [    1.968730] sd 0:0:1:0: Attached scsi generic sg1 type 0
> [    1.970200] scsi 1:0:0:0: CD-ROM            TSSTcorp CD-R/RW SH-R522C TS04 PQ: 0 ANSI: 5
> [    1.970300] PM: Adding info for No Bus:target1:0:0
> [    1.970322] PM: Adding info for scsi:1:0:0:0
> [    1.970377] PM: Adding info for No Bus:1:0:0:0
> [    1.970435] PM: Adding info for No Bus:sg2
> [    1.970474] scsi 1:0:0:0: Attached scsi generic sg2 type 5
> [    1.971011] scsi 1:0:1:0: CD-ROM            TSSTcorp DVD-ROM TS-H352A TS03 PQ: 0 ANSI: 5
> [    1.971110] PM: Adding info for No Bus:target1:0:1
> [    1.971138] PM: Adding info for scsi:1:0:1:0
> [    1.971189] PM: Adding info for No Bus:1:0:1:0
> [    1.971238] PM: Adding info for No Bus:sg3
> [    1.971275] scsi 1:0:1:0: Attached scsi generic sg3 type 5
> [    1.971561] PNP: No PS/2 controller found. Probing ports directly.
> [    1.971708] PM: Adding info for platform:i8042
> [    1.971946] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.972018] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.972096] PM: Adding info for No Bus:mice
> [    1.972137] PM: Adding info for serio:serio0
> [    1.972210] PM: Adding info for No Bus:psaux
> [    1.972268] PM: Adding info for serio:serio1
> [    1.972307] mice: PS/2 mouse device common for all mice
> [    1.972636] PM: Adding info for No Bus:device-mapper
> [    1.972675] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> [    1.973331] TCP cubic registered
> [    1.973427] Using IPI No-Shortcut mode
> [    1.973514] PM: Adding info for No Bus:cpu_dma_latency
> [    1.973562] PM: Adding info for No Bus:network_latency
> [    1.973608] PM: Adding info for No Bus:network_throughput
> [    1.974190] Freeing unused kernel memory: 248k freed
> [    1.974335] PM: Adding info for No Bus:vcs1
> [    1.974461] PM: Adding info for No Bus:vcsa1
> [    1.999063] PM: Adding info for No Bus:input0
> [    2.002140] input: AT Translated Set 2 keyboard as /class/input/input0
> [    2.066734] PM: Adding info for No Bus:vcs2
> [    2.066827] PM: Adding info for No Bus:vcsa2
> [    2.067294] PM: Removing info for No Bus:vcs2
> [    2.067362] PM: Removing info for No Bus:vcsa2
> [    2.069433] PM: Adding info for No Bus:vcs2
> [    2.069601] PM: Adding info for No Bus:vcsa2
> [    2.072991] PM: Removing info for No Bus:vcs2
> [    2.073109] PM: Removing info for No Bus:vcsa2
> [    2.074533] PM: Adding info for No Bus:vcs2
> [    2.074612] PM: Adding info for No Bus:vcsa2
> [    2.075878] PM: Removing info for No Bus:vcs2
> [    2.076001] PM: Removing info for No Bus:vcsa2
> [    2.077027] PM: Adding info for No Bus:vcs3
> [    2.077105] PM: Adding info for No Bus:vcsa3
> [    2.077549] PM: Removing info for No Bus:vcs3
> [    2.077616] PM: Removing info for No Bus:vcsa3
> [    2.079599] PM: Adding info for No Bus:vcs3
> [    2.079767] PM: Adding info for No Bus:vcsa3
> [    2.083128] PM: Removing info for No Bus:vcs3
> [    2.083241] PM: Removing info for No Bus:vcsa3
> [    2.084832] PM: Adding info for No Bus:vcs3
> [    2.084915] PM: Adding info for No Bus:vcsa3
> [    2.086174] PM: Removing info for No Bus:vcs3
> [    2.086296] PM: Removing info for No Bus:vcsa3
> [    2.087246] PM: Adding info for No Bus:vcs4
> [    2.087319] PM: Adding info for No Bus:vcsa4
> [    2.087777] PM: Removing info for No Bus:vcs4
> [    2.087840] PM: Removing info for No Bus:vcsa4
> [    2.089856] PM: Adding info for No Bus:vcs4
> [    2.090025] PM: Adding info for No Bus:vcsa4
> [    2.093411] PM: Removing info for No Bus:vcs4
> [    2.093531] PM: Removing info for No Bus:vcsa4
> [    2.094961] PM: Adding info for No Bus:vcs4
> [    2.095044] PM: Adding info for No Bus:vcsa4
> [    2.096365] PM: Removing info for No Bus:vcs4
> [    2.096489] PM: Removing info for No Bus:vcsa4
> [    2.097422] PM: Adding info for No Bus:vcs5
> [    2.097493] PM: Adding info for No Bus:vcsa5
> [    2.097943] PM: Removing info for No Bus:vcs5
> [    2.098011] PM: Removing info for No Bus:vcsa5
> [    2.099969] PM: Adding info for No Bus:vcs5
> [    2.100316] PM: Adding info for No Bus:vcsa5
> [    2.103655] PM: Removing info for No Bus:vcs5
> [    2.103768] PM: Removing info for No Bus:vcsa5
> [    2.105237] PM: Adding info for No Bus:vcs5
> [    2.105319] PM: Adding info for No Bus:vcsa5
> [    2.106599] PM: Removing info for No Bus:vcs5
> [    2.106724] PM: Removing info for No Bus:vcsa5
> [    2.107675] PM: Adding info for No Bus:vcs6
> [    2.107749] PM: Adding info for No Bus:vcsa6
> [    2.108248] PM: Removing info for No Bus:vcs6
> [    2.108317] PM: Removing info for No Bus:vcsa6
> [    2.110353] PM: Adding info for No Bus:vcs6
> [    2.110520] PM: Adding info for No Bus:vcsa6
> [    2.113908] PM: Removing info for No Bus:vcs6
> [    2.114023] PM: Removing info for No Bus:vcsa6
> [    2.115410] PM: Adding info for No Bus:vcs6
> [    2.115488] PM: Adding info for No Bus:vcsa6
> [    2.116780] PM: Removing info for No Bus:vcs6
> [    2.116905] PM: Removing info for No Bus:vcsa6
> [    2.200465] fuse init (API version 7.9)
> [    2.200744] PM: Adding info for No Bus:fuse
> [    2.217008] thermal: Unknown symbol acpi_processor_set_thermal_limit
> [    3.157347] PM: Adding info for No Bus:dm-0
> [    3.157399] PM: Adding info for No Bus:254:0
> [    3.179271] PM: Adding info for No Bus:dm-1
> [    3.179325] PM: Adding info for No Bus:254:1
> [    3.202192] PM: Adding info for No Bus:dm-2
> [    3.202247] PM: Adding info for No Bus:254:2
> [    3.284559] Uniform Multi-Platform E-IDE driver
> [    3.284640] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> [    3.328406] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
> [    3.328516] 8139cp 0000:00:0d.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
> [    3.329363] 8139cp 0000:00:0d.0: Try the "8139too" driver instead.
> [    3.346369] 8139too Fast Ethernet driver 0.9.28
> [    3.346504] PCI: setting IRQ 10 as level-triggered
> [    3.346508] PCI: Found IRQ 10 for device 0000:00:0d.0
> [    3.346589] PCI: Sharing IRQ 10 with 0000:00:02.7
> [    3.346662] PCI: Sharing IRQ 10 with 0000:00:13.2
> [    3.347012] PM: Adding info for No Bus:eth0
> [    3.347274] eth0: RealTek RTL8139 at 0xe082af00, 00:10:b5:11:4a:b0, IRQ 10
> [    3.347346] eth0:  Identified 8139 chip type 'RTL-8139C'
> [    3.399841] usbcore: registered new interface driver usbfs
> [    3.399944] usbcore: registered new interface driver hub
> [    3.410500] usbcore: registered new device driver usb
> [    3.414574] Driver 'sr' needs updating - please use bus_type methods
> [    3.422561] PCI: Found IRQ 10 for device 0000:00:13.2
> [    3.422651] PCI: Sharing IRQ 10 with 0000:00:02.7
> [    3.422720] PCI: Sharing IRQ 10 with 0000:00:0d.0
> [    3.422810] ehci_hcd 0000:00:13.2: EHCI Host Controller
> [    3.422902] PM: Adding info for No Bus:usb_host1
> [    3.422919] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
> [    3.423068] ehci_hcd 0000:00:13.2: irq 10, io mem 0xcfffde00
> [    3.424436] sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
> [    3.424548] Uniform CD-ROM driver Revision: 3.20
> [    3.424672] PM: Adding info for No Bus:sr0
> [    3.424747] PM: Adding info for No Bus:11:0
> [    3.424774] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    3.430946] sr1: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
> [    3.431076] PM: Adding info for No Bus:sr1
> [    3.431146] PM: Adding info for No Bus:11:1
> [    3.431170] sr 1:0:1:0: Attached scsi CD-ROM sr1
> [    3.436330] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
> [    3.436517] PM: Adding info for usb:usb1
> [    3.436625] PM: Adding info for No Bus:usbdev1.1_ep00
> [    3.436646] usb usb1: configuration #1 chosen from 1 choice
> [    3.436729] PM: Adding info for usb:1-0:1.0
> [    3.436749] hub 1-0:1.0: USB hub found
> [    3.436829] hub 1-0:1.0: 4 ports detected
> [    3.540842] PM: Adding info for No Bus:usbdev1.1_ep81
> [    3.540910] PM: Adding info for No Bus:usbdev1.1
> [    3.605935] kjournald starting.  Commit interval 5 seconds
> [    3.606030] EXT3-fs: mounted filesystem with ordered data mode.
> [    3.780255] usb 1-1: new high speed USB device using ehci_hcd and address 2
> [    3.896365] PM: Removing info for No Bus:vcs1
> [    3.896429] PM: Removing info for No Bus:vcsa1
> [    3.896508] PM: Adding info for No Bus:vcs1
> [    3.896530] PM: Adding info for No Bus:vcsa1
> [    3.913635] PM: Adding info for usb:1-1
> [    3.913720] PM: Adding info for No Bus:usbdev1.2_ep00
> [    3.913741] usb 1-1: configuration #1 chosen from 1 choice
> [    3.914112] PM: Adding info for usb:1-1:1.0
> [    3.914156] PM: Adding info for No Bus:usbdev1.2_ep81
> [    3.914184] PM: Adding info for No Bus:usbdev1.2_ep02
> [    3.914211] PM: Adding info for No Bus:usbdev1.2
> [    4.152298] hub 1-0:1.0: unable to enumerate USB device on port 3
> [    7.628736] PM: Adding info for No Bus:vcs2
> [    7.628772] PM: Adding info for No Bus:vcsa2
> [    7.630178] PM: Removing info for No Bus:vcs2
> [    7.630228] PM: Removing info for No Bus:vcsa2
> [    7.630424] PM: Adding info for No Bus:vcs3
> [    7.630445] PM: Adding info for No Bus:vcsa3
> [    7.631855] PM: Removing info for No Bus:vcs3
> [    7.631905] PM: Removing info for No Bus:vcsa3
> [    7.632099] PM: Adding info for No Bus:vcs4
> [    7.632119] PM: Adding info for No Bus:vcsa4
> [    7.633572] PM: Removing info for No Bus:vcs4
> [    7.633621] PM: Removing info for No Bus:vcsa4
> [    7.633816] PM: Adding info for No Bus:vcs5
> [    7.633837] PM: Adding info for No Bus:vcsa5
> [    7.635249] PM: Removing info for No Bus:vcs5
> [    7.635299] PM: Removing info for No Bus:vcsa5
> [    7.635492] PM: Adding info for No Bus:vcs6
> [    7.635513] PM: Adding info for No Bus:vcsa6
> [    7.636957] PM: Removing info for No Bus:vcs6
> [    7.637006] PM: Removing info for No Bus:vcsa6
> [    9.168836] eth0: link down
> [    9.452702] PM: Adding info for No Bus:event0
> [   10.304546] NET: Registered protocol family 10
> [   10.305128] lo: Disabled Privacy Extensions
> [   10.305668] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   11.020911] Linux agpgart interface v0.103
> [   11.229411] agpgart: Detected SiS chipset - id:1845
> [   11.233993] PM: Adding info for No Bus:agpgart
> [   11.234037] agpgart: AGP aperture is 64M @ 0xd0000000
> [   11.382741] sis630_smbus 0000:00:02.0: SIS630 comp. bus not detected, module not inserted.
> [   11.399313] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
> [   11.399420] PM: Adding info for No Bus:i2c-0
> [   11.626749] PM: Adding info for No Bus:timer
> [   11.739808] Initializing USB Mass Storage driver...
> [   11.743857] scsi2 : SCSI emulation for USB Mass Storage devices
> [   11.743958] PM: Adding info for No Bus:host2
> [   11.743988] PM: Adding info for No Bus:host2
> [   11.744375] usbcore: registered new interface driver usb-storage
> [   11.744449] USB Mass Storage support registered.
> [   11.749294] usb-storage: device found at 2
> [   11.749301] usb-storage: waiting for device to settle before scanning
> [   11.828555] PCI: Found IRQ 10 for device 0000:00:02.7
> [   11.828649] PCI: Sharing IRQ 10 with 0000:00:0d.0
> [   11.828756] PCI: Sharing IRQ 10 with 0000:00:13.2
> [   12.144766] intel8x0_measure_ac97_clock: measured 55903 usecs
> [   12.144844] intel8x0: clocking to 48000
> [   12.144945] PM: Adding info for No Bus:pcmC0D1c
> [   12.145006] PM: Adding info for No Bus:adsp
> [   12.145030] PM: Adding info for No Bus:pcmC0D0p
> [   12.145055] PM: Adding info for No Bus:pcmC0D0c
> [   12.145081] PM: Adding info for No Bus:dsp
> [   12.145100] PM: Adding info for No Bus:audio
> [   12.145125] PM: Adding info for ac97:0-0:CMI9738
> [   12.145146] PM: Adding info for No Bus:controlC0
> [   12.145178] PM: Adding info for No Bus:mixer
> [   12.379259] PM: Adding info for No Bus:input1
> [   12.379323] input: ImPS/2 Logitech Wheel Mouse as /class/input/input1
> [   12.393815] PM: Adding info for No Bus:mouse0
> [   12.408162] PM: Adding info for No Bus:event1
> [   12.761738] PM: Adding info for No Bus:loop0
> [   12.761791] PM: Adding info for No Bus:7:0
> [   12.761830] PM: Adding info for No Bus:loop1
> [   12.761851] PM: Adding info for No Bus:7:1
> [   12.761875] PM: Adding info for No Bus:loop2
> [   12.761896] PM: Adding info for No Bus:7:2
> [   12.761917] PM: Adding info for No Bus:loop3
> [   12.761944] PM: Adding info for No Bus:7:3
> [   12.761967] PM: Adding info for No Bus:loop4
> [   12.761988] PM: Adding info for No Bus:7:4
> [   12.762013] PM: Adding info for No Bus:loop5
> [   12.762033] PM: Adding info for No Bus:7:5
> [   12.762069] PM: Adding info for No Bus:loop6
> [   12.762091] PM: Adding info for No Bus:7:6
> [   12.762113] PM: Adding info for No Bus:loop7
> [   12.762140] PM: Adding info for No Bus:7:7
> [   12.762153] loop: module loaded
> [   12.873903] Adding 1048568k swap on /dev/mapper/lvm--sdb-swap.  Priority:-1 extents:1 across:1048568k
> [   13.580665] EXT3 FS on dm-1, internal journal
> [   16.160882] kjournald starting.  Commit interval 5 seconds
> [   16.161141] EXT3 FS on sdb1, internal journal
> [   16.161148] EXT3-fs: mounted filesystem with ordered data mode.
> [   16.191286] kjournald starting.  Commit interval 5 seconds
> [   16.191584] EXT3 FS on dm-2, internal journal
> [   16.191589] EXT3-fs: mounted filesystem with ordered data mode.
> [   16.316325] PM: Adding info for No Bus:8:1
> [   16.432456] PM: Adding info for No Bus:8:2
> [   16.757124] scsi 2:0:0:0: Direct-Access     WDC WD40 0UE-22HCT0       0811 PQ: 0 ANSI: 0
> [   16.757154] PM: Adding info for No Bus:target2:0:0
> [   16.757193] PM: Adding info for scsi:2:0:0:0
> [   16.757256] PM: Adding info for No Bus:2:0:0:0
> [   16.777427] sd 2:0:0:0: [sdc] 78140160 512-byte hardware sectors (40008 MB)
> [   16.791095] sd 2:0:0:0: [sdc] Test WP failed, assume Write Enabled
> [   16.791108] sd 2:0:0:0: [sdc] Assuming drive cache: write through
> [   16.791239] PM: Adding info for No Bus:sdc
> [   16.803567] sd 2:0:0:0: [sdc] 78140160 512-byte hardware sectors (40008 MB)
> [   16.814360] sd 2:0:0:0: [sdc] Test WP failed, assume Write Enabled
> [   16.814372] sd 2:0:0:0: [sdc] Assuming drive cache: write through
> [   16.814453]  sdc: sdc1
> [   16.818009] PM: Adding info for No Bus:sdc1
> [   16.818143] PM: Adding info for No Bus:8:32
> [   16.818175] sd 2:0:0:0: [sdc] Attached SCSI disk
> [   16.818198] PM: Adding info for No Bus:2:0:0:0
> [   16.818228] PM: Adding info for No Bus:sg4
> [   16.818243] sd 2:0:0:0: Attached scsi generic sg4 type 0
> [   16.818525] usb-storage: device scan complete
> [   16.980922] PM: Adding info for No Bus:vcs2
> [   16.980965] PM: Adding info for No Bus:vcsa2
> [   16.984354] PM: Removing info for No Bus:vcs2
> [   16.984409] PM: Removing info for No Bus:vcsa2
> [   16.986042] PM: Adding info for No Bus:vcs2
> [   16.986087] PM: Adding info for No Bus:vcsa2
> [   17.000059] PM: Removing info for No Bus:vcs2
> [   17.000116] PM: Removing info for No Bus:vcsa2
> [   17.000418] PM: Adding info for No Bus:vcs3
> [   17.000442] PM: Adding info for No Bus:vcsa3
> [   17.004078] PM: Removing info for No Bus:vcs3
> [   17.004127] PM: Removing info for No Bus:vcsa3
> [   17.005770] PM: Adding info for No Bus:vcs3
> [   17.005811] PM: Adding info for No Bus:vcsa3
> [   17.019822] PM: Removing info for No Bus:vcs3
> [   17.019874] PM: Removing info for No Bus:vcsa3
> [   17.020150] PM: Adding info for No Bus:vcs4
> [   17.020175] PM: Adding info for No Bus:vcsa4
> [   17.023737] PM: Removing info for No Bus:vcs4
> [   17.023787] PM: Removing info for No Bus:vcsa4
> [   17.025493] PM: Adding info for No Bus:vcs4
> [   17.025535] PM: Adding info for No Bus:vcsa4
> [   17.039522] PM: Removing info for No Bus:vcs4
> [   17.039573] PM: Removing info for No Bus:vcsa4
> [   17.039857] PM: Adding info for No Bus:vcs5
> [   17.039881] PM: Adding info for No Bus:vcsa5
> [   17.043439] PM: Removing info for No Bus:vcs5
> [   17.043488] PM: Removing info for No Bus:vcsa5
> [   17.045170] PM: Adding info for No Bus:vcs5
> [   17.045212] PM: Adding info for No Bus:vcsa5
> [   17.059129] PM: Removing info for No Bus:vcs5
> [   17.059183] PM: Removing info for No Bus:vcsa5
> [   17.059461] PM: Adding info for No Bus:vcs6
> [   17.059486] PM: Adding info for No Bus:vcsa6
> [   17.063065] PM: Removing info for No Bus:vcs6
> [   17.063113] PM: Removing info for No Bus:vcsa6
> [   17.064737] PM: Adding info for No Bus:vcs6
> [   17.064782] PM: Adding info for No Bus:vcsa6
> [   17.079135] PM: Removing info for No Bus:vcs6
> [   17.079187] PM: Removing info for No Bus:vcsa6
> [   17.091804] PM: Adding info for No Bus:vcs2
> [   17.091842] PM: Adding info for No Bus:vcsa2
> [   17.095606] PM: Removing info for No Bus:vcs2
> [   17.095655] PM: Removing info for No Bus:vcsa2
> [   17.095864] PM: Adding info for No Bus:vcs3
> [   17.095889] PM: Adding info for No Bus:vcsa3
> [   17.099668] PM: Removing info for No Bus:vcs3
> [   17.099717] PM: Removing info for No Bus:vcsa3
> [   17.099924] PM: Adding info for No Bus:vcs4
> [   17.099948] PM: Adding info for No Bus:vcsa4
> [   17.103673] PM: Removing info for No Bus:vcs4
> [   17.103721] PM: Removing info for No Bus:vcsa4
> [   17.103930] PM: Adding info for No Bus:vcs5
> [   17.103953] PM: Adding info for No Bus:vcsa5
> [   17.107769] PM: Removing info for No Bus:vcs5
> [   17.107822] PM: Removing info for No Bus:vcsa5
> [   17.108033] PM: Adding info for No Bus:vcs6
> [   17.108056] PM: Adding info for No Bus:vcsa6
> [   17.111712] PM: Removing info for No Bus:vcs6
> [   17.111761] PM: Removing info for No Bus:vcsa6
> [   17.974825] PM: Adding info for No Bus:vcs4
> [   17.974874] PM: Adding info for No Bus:vcsa4
> [   17.978191] PM: Adding info for No Bus:vcs2
> [   17.978232] PM: Adding info for No Bus:vcsa2
> [   17.979286] PM: Adding info for No Bus:vcs5
> [   17.979325] PM: Adding info for No Bus:vcsa5
> [   17.981471] PM: Adding info for No Bus:vcs3
> [   17.981510] PM: Adding info for No Bus:vcsa3
> [   17.992306] PM: Adding info for No Bus:vcs6
> [   17.992348] PM: Adding info for No Bus:vcsa6
> [   18.283990] powernow_k7: Unknown symbol acpi_processor_notify_smm
> [   18.284052] powernow_k7: Unknown symbol acpi_processor_unregister_performance
> [   18.284161] powernow_k7: Unknown symbol acpi_processor_register_performance
> [   18.302286] acpi_cpufreq: Unknown symbol acpi_processor_notify_smm
> [   18.302347] acpi_cpufreq: Unknown symbol acpi_processor_unregister_performance
> [   18.302554] acpi_cpufreq: Unknown symbol acpi_processor_preregister_performance
> [   18.302637] acpi_cpufreq: Unknown symbol acpi_processor_register_performance
> [   22.826324] PM: Adding info for No Bus:vcs7
> [   22.826375] PM: Adding info for No Bus:vcsa7
> [   22.905310] PM: Removing info for No Bus:vcs7
> [   22.905380] PM: Removing info for No Bus:vcsa7
> [   23.207901] PM: Adding info for No Bus:vcs7
> [   23.207961] PM: Adding info for No Bus:vcsa7
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


