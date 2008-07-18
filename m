Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbYGRRNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbYGRRNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbYGRRNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:13:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:34608 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbYGRRNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=a6IA4xN6UrsobFynNyFm7BHLrDZ+x4e2urp3u9FaTF6DMlhUneV5dEeVygX2lZkei2
         A8yyK1r5o9LkYHh9HBapqIAx27S9BlCgSXK/WYG5FQwIoiHTM54lxeajKG+4XlbUO/wg
         NkxCtdEnTsN2TsEomVTQfIiP78GNFmdpfY3HY=
Message-ID: <4880CEEC.3050503@gmail.com>
Date: Fri, 18 Jul 2008 18:12:12 +0100
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080614)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de> <487F33F2.2060202@gmail.com> <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de> <487F39AC.3060805@gmail.com> <alpine.LFD.1.10.0807171400090.4316@apollo.tec.linutronix.de> <487F85C6.9@gmail.com> <alpine.LFD.1.10.0807171856010.4316@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807171856010.4316@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 17 Jul 2008, Richard wrote:
>   
>> Here you go.. a 2.6.26-tip dmesg  (the top seems to be missing for some
>> reason!) .. just shout if you need the bits on the top.
>>     
>
> Those are the interesting ones :)
>
> Questions: 
>
> Are CONFIG_HIGHRES_TIMERS and CONFIG_NO_HZ enabled ?
> Is it still necessary to add any command line option ?
> Is the system stable ?
>
> Also please provide the output of
>
> # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>
> and
>
> # cat /proc/timer_list
>
> Thanks,
>
> 	tglx
>
>   

Alas, a log.. there are 2 more in the following emails (Log 1 of 3)


Richard

with command line option noapictimer.


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-tip (root@localhost) (gcc version 
4.2.3 (Gentoo 4.2.3 p1.0)) #3 SMP Thu Jul 17 19:30:56 UTC 2008
[    0.000000] Command line: root=/dev/ram0 ramdisk=8192 
real_root=UUID=e1ef4642-3c14-4a73-be54-c04e9bcf2422 dolvm init=/linuxrc 
CONSOLE=/dev/tty1 noapictimer resume=swap:/dev/sda6 nox 
netconsole=@192.168.3.2/eth0,9999@192.168.3.1/
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077fb0000 (usable)
[    0.000000]  BIOS-e820: 0000000077fb0000 - 0000000077fc8000 (reserved)
[    0.000000]  BIOS-e820: 0000000077fc8000 - 0000000077fe7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077fe7fb8 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] last_pfn = 0x77fb0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: 77fb0000 end: 77fb0000
[    0.000000] RAMDISK: 77ad8000 - 77f9f5f9
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE0B0, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 77FC81BC, 0064 (r1 HPQOEM SLIC-MPC        1 
HP          1)
[    0.000000] ACPI: FACP 77FC8084, 00F4 (r4 HP     0944            3 
HP          1)
[    0.000000] ACPI Error (tbfadt-0453): 32/64X address mismatch in 
"Pm2ControlBlock": [00008800] [0000000000008100], using 64X [20080321]
[    0.000000] ACPI: DSDT 77FC84A4, 11437 (r1 HP        SB400    10000 
MSFT  3000001)
[    0.000000] ACPI: FACS 77FE7D80, 0040
[    0.000000] ACPI: SLIC 77FC8220, 0176 (r1 HPQOEM SLIC-MPC        1 
HP          1)
[    0.000000] ACPI: EPTH 77FC8398, 0038 (r1 HP     0944            1 
HP          1)
[    0.000000] ACPI: APIC 77FC83D0, 0062 (r1 HP     0944            1 
HP          1)
[    0.000000] ACPI: MCFG 77FC8434, 003C (r1 HP     0944            1 
HP          1)
[    0.000000] ACPI: TCPA 77FC8470, 0032 (r2 HP     0944            1 
HP          1)
[    0.000000] ACPI: SSDT 77FD98DB, 0059 (r1 HP       HPQNLP        1 
MSFT  3000001)
[    0.000000] ACPI: SSDT 77FD9934, 0115 (r1 HP     PSSTBLID        1 
HP          1)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000077fb0000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000077fb0000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000004fff]
[    0.000000]   bootmap [000000000000a000 -  0000000000018ff7] pages f
[    0.000000] (6 early reservations) ==> bootmem
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> 
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000c5a60c]    TEXT DATA BSS ==> 
[0000200000 - 0000c5a60c]
[    0.000000]   #3 [0077ad8000 - 0077f9f5f9]          RAMDISK ==> 
[0077ad8000 - 0077f9f5f9]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> 
[0000008000 - 000000a000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00077fb0
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 
80000000:60000000)
[    0.000000] PERCPU: Allocating 48320 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  
Total pages: 481873
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/ram0 ramdisk=8192 
real_root=UUID=e1ef4642-3c14-4a73-be54-c04e9bcf2422 dolvm init=/linuxrc 
CONSOLE=/dev/tty1 noapictimer resume=swap:/dev/sda6 nox 
netconsole=@192.168.3.2/eth0,9999@192.168.3.1/
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 1994.903 MHz processor.
[    0.001999] Console: colour VGA+ 80x25
[    0.001999] console [tty0] enabled
[    0.001999] Checking aperture...
[    0.001999] No AGP bridge found
[    0.001999] Node 0: aperture @ d05c000000 size 32 MB
[    0.001999] Aperture beyond 4GB. Ignoring.
[    0.001999] Memory: 1920920k/1965760k available (6412k kernel code, 
44452k reserved, 3058k data, 484k init)
[    0.001999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.002194] Calibrating delay loop (skipped), value calculated using 
timer frequency.. <6>3989.80 BogoMIPS (lpj=1994903)
[    0.002303] Security Framework initialized
[    0.002341] SELinux:  Disabled at boot.
[    0.002572] Dentry cache hash table entries: 262144 (order: 9, 
2097152 bytes)
[    0.004928] Inode-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.006138] Mount-cache hash table entries: 256
[    0.006550] Initializing cgroup subsys debug
[    0.006623] Initializing cgroup subsys ns
[    0.006723] Initializing cgroup subsys cpuacct
[    0.006820] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.006909] CPU: L2 Cache: 256K (64 bytes/line)
[    0.006980] CPU 0/0 -> Node 0
[    0.007100] using C1E aware idle routine
[    0.007199] ACPI: Core revision 20080321
[    0.043993] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.053880] CPU0: Mobile AMD Sempron(tm) Processor 3600+ stepping 02
[    0.053983] Disabling APIC timer
[    0.054075] Brought up 1 CPUs
[    0.054117] Total of 1 processors activated (3989.80 BogoMIPS).
[    0.054360] net_namespace: 1224 bytes
[    0.054560] xor: automatically using best checksumming function: 
generic_sse
[    0.058775]    generic_sse:  6144.000 MB/sec
[    0.058812] xor: using function: generic_sse (6144.000 MB/sec)
[    0.058885] NET: Registered protocol family 16
[    0.059153] No dock devices found.
[    0.059715] TOM: 0000000080000000 aka 2048M
[    0.059799] ACPI: bus type pci registered
[    0.059938] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.059978] PCI: MCFG area at e0000000 reserved in E820
[    0.066175] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.066218] PCI: Using configuration type 1 for base access
[    0.072489] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.336948] ACPI: Interpreter enabled
[    0.336948] ACPI: (supports S0 S3 S4 S5)
[    0.336948] ACPI: Using IOAPIC for interrupt routing
[    0.348195] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.348242] ACPI: EC: driver started in interrupt mode
[    0.348377] ACPI: PCI Root Bridge [C08B] (0000:00)
[    0.348613] PCI: 0000:00:12.0 reg 10 io port: [9000, 9007]
[    0.348656] PCI: 0000:00:12.0 reg 14 io port: [9008, 900b]
[    0.348699] PCI: 0000:00:12.0 reg 18 io port: [9010, 9017]
[    0.348742] PCI: 0000:00:12.0 reg 1c io port: [5018, 501b]
[    0.348785] PCI: 0000:00:12.0 reg 20 io port: [5020, 502f]
[    0.348828] PCI: 0000:00:12.0 reg 24 32bit mmio: [d0609000, d06093ff]
[    0.348888] pci 0000:00:12.0: set SATA to AHCI mode
[    0.348943] PCI: 0000:00:13.0 reg 10 32bit mmio: [d0601000, d0601fff]
[    0.349039] PCI: 0000:00:13.1 reg 10 32bit mmio: [d0602000, d0602fff]
[    0.349127] PCI: 0000:00:13.2 reg 10 32bit mmio: [d0603000, d0603fff]
[    0.349214] PCI: 0000:00:13.3 reg 10 32bit mmio: [d0604000, d0604fff]
[    0.349302] PCI: 0000:00:13.4 reg 10 32bit mmio: [d0605000, d0605fff]
[    0.349408] PCI: 0000:00:13.5 reg 10 32bit mmio: [d0606000, d06060ff]
[    0.349513] PCI: 0000:00:14.0 reg 10 io port: [8200, 820f]
[    0.349602] PCI: 0000:00:14.1 reg 10 io port: [0, 7]
[    0.349645] PCI: 0000:00:14.1 reg 14 io port: [0, 3]
[    0.349686] PCI: 0000:00:14.1 reg 18 io port: [0, 7]
[    0.349729] PCI: 0000:00:14.1 reg 1c io port: [0, 3]
[    0.349771] PCI: 0000:00:14.1 reg 20 io port: [5040, 504f]
[    0.349860] PCI: 0000:00:14.2 reg 10 64bit mmio: [d0608000, d060bfff]
[    0.350120] PCI: 0000:01:05.0 reg 10 64bit mmio: [c0000000, c7ffffff]
[    0.350162] PCI: 0000:01:05.0 reg 18 64bit mmio: [d0400000, d040ffff]
[    0.350202] PCI: 0000:01:05.0 reg 20 io port: [4000, 40ff]
[    0.350242] PCI: 0000:01:05.0 reg 24 32bit mmio: [d0500000, d05fffff]
[    0.350297] PCI: bridge 0000:00:01.0 io port: [4000, 4fff]
[    0.350336] PCI: bridge 0000:00:01.0 32bit mmio: [d0400000, d05fffff]
[    0.350377] PCI: bridge 0000:00:01.0 64bit mmio pref: [c0000000, 
c7ffffff]
[    0.350504] PCI: 0000:10:00.0 reg 10 64bit mmio: [d0000000, d000ffff]
[    0.350619] PCI: bridge 0000:00:04.0 32bit mmio: [d0000000, d00fffff]
[    0.350703] PCI: bridge 0000:00:05.0 io port: [2000, 3fff]
[    0.350742] PCI: bridge 0000:00:05.0 32bit mmio: [cc000000, cfffffff]
[    0.351946] PCI: 0000:30:00.0 reg 10 64bit mmio: [c8000000, c8003fff]
[    0.351946] PCI: bridge 0000:00:06.0 32bit mmio: [c8000000, c80fffff]
[    0.352042] PCI: 0000:02:04.0 reg 10 32bit mmio: [d0100000, d0100fff]
[    0.352211] PCI: 0000:02:04.1 reg 10 32bit mmio: [d0101000, d01017ff]
[    0.352486] PCI: Transparent bridge - 0000:00:14.4
[    0.352571] PCI: bridge 0000:00:14.4 32bit mmio: [d0100000, d03fffff]
[    0.375710] ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
[    0.376127] ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
[    0.376521] ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
[    0.376913] ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
[    0.377304] ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
[    0.377688] ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
[    0.378050] ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
[    0.378452] ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
[    0.378856] ACPI: Power Resource [C171] (off)
[    0.379100] ACPI: Power Resource [C230] (off)
[    0.379192] ACPI: Power Resource [C24C] (on)
[    0.379366] ACPI: Power Resource [C395] (off)
[    0.379499] ACPI: Power Resource [C396] (off)
[    0.379632] ACPI: Power Resource [C397] (off)
[    0.379766] ACPI: Power Resource [C398] (off)
[    0.380126] ACPI: WMI: Mapper loaded
[    0.380168] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.380237] pnp: PnP ACPI init
[    0.380282] ACPI: bus type pnp registered
[    0.391314] pnp: PnP ACPI: found 14 devices
[    0.391361] ACPI: ACPI bus type pnp unregistered
[    0.391731] SCSI subsystem initialized
[    0.392031] usbcore: registered new interface driver usbfs
[    0.392142] usbcore: registered new interface driver hub
[    0.392227] usbcore: registered new device driver usb
[    0.392486] PCI: Using ACPI for IRQ routing
[    0.392564] PCI: Cannot allocate resource region 0 of device 0000:00:14.2
[    0.397958] NetLabel: Initializing
[    0.397996] NetLabel:  domain hash size = 128
[    0.398033] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.398084] NetLabel:  unlabeled traffic allowed by default
[    0.398250] ACPI: RTC can wake from S4
[    0.400965] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.401004] system 00:00: iomem range 0xe0000-0xfffff could not be 
reserved
[    0.401043] system 00:00: iomem range 0x100000-0xffffffff could not 
be reserved
[    0.401095] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.401134] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.401173] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.401211] system 00:0a: ioport range 0x500-0x51f has been reserved
[    0.401250] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.401289] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.401327] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.401366] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.401404] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.401443] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.401481] system 00:0a: ioport range 0xcd0-0xcdf has been reserved
[    0.401522] system 00:0a: iomem range 0xffb00000-0xffbfffff could not 
be reserved
[    0.401565] system 00:0a: iomem range 0xfff00000-0xffffffff could not 
be reserved
[    0.401613] system 00:0c: ioport range 0x8000-0x802f has been reserved
[    0.401651] system 00:0c: ioport range 0x8100-0x811f has been reserved
[    0.401692] system 00:0c: iomem range 0xe0000000-0xefffffff could not 
be reserved
[    0.401734] system 00:0c: iomem range 0xfec00000-0xfec000ff could not 
be reserved
[    0.401777] system 00:0c: iomem range 0xfed45000-0xfed8ffff has been 
reserved
[    0.401821] system 00:0d: iomem range 0xcd400-0xcffff has been reserved
[    0.401859] system 00:0d: iomem range 0xd2a00-0xd2fff has been reserved
[    0.401898] system 00:0d: iomem range 0x0-0x7ffffff could not be reserved
[    0.401936] system 00:0d: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.402443] PCI: region 0000:02:04.0/9 too large: 
0x0000000000000000-0x0000000003ffffff
[    0.402501] PCI: Bridge: 0000:00:01.0
[    0.402537]   IO window: 4000-4fff
[    0.402574]   MEM window: 0xd0400000-0xd05fffff
[    0.402610]   PREFETCH window: 0x00000000c0000000-0x00000000c7ffffff
[    0.402649] PCI: Bridge: 0000:00:04.0
[    0.402685]   IO window: disabled.
[    0.402721]   MEM window: 0xd0000000-0xd00fffff
[    0.402757]   PREFETCH window: disabled.
[    0.402794] PCI: Bridge: 0000:00:05.0
[    0.402830]   IO window: 2000-3fff
[    0.402866]   MEM window: 0xcc000000-0xcfffffff
[    0.402903]   PREFETCH window: disabled.
[    0.402949] Clockevents: could not switch to one-shot mode: lapic is 
not functional.
[    0.403024] Could not switch to high resolution mode on CPU 0
[    0.403065] PCI: Bridge: 0000:00:06.0
[    0.403101]   IO window: disabled.
[    0.403139]   MEM window: 0xc8000000-0xc80fffff
[    0.403177]   PREFETCH window: disabled.
[    0.403218] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[    0.403256]   IO window: 0x00001000-0x000010ff
[    0.403296]   IO window: 0x00001400-0x000014ff
[    0.403337]   MEM window: 0x8c000000-0x8fffffff
[    0.403378] PCI: Bridge: 0000:00:14.4
[    0.403416]   IO window: 1000-1fff
[    0.403456]   MEM window: 0xd0100000-0xd03fffff
[    0.403496]   PREFETCH window: disabled.
[    0.403591] vendor=1002 device=4384
[    0.403633] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, 
low) -> IRQ 20
[    0.403710] bus: 00 index 0 io port: [0, ffff]
[    0.403748] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.403786] bus: 01 index 0 io port: [4000, 4fff]
[    0.403825] bus: 01 index 1 mmio: [d0400000, d05fffff]
[    0.403862] bus: 01 index 2 mmio: [c0000000, c7ffffff]
[    0.403901] bus: 01 index 3 mmio: [0, 0]
[    0.403943] bus: 10 index 0 mmio: [0, 0]
[    0.403980] bus: 10 index 1 mmio: [d0000000, d00fffff]
[    0.404018] bus: 10 index 2 mmio: [0, 0]
[    0.404055] bus: 10 index 3 mmio: [0, 0]
[    0.404092] bus: 20 index 0 io port: [2000, 3fff]
[    0.404130] bus: 20 index 1 mmio: [cc000000, cfffffff]
[    0.404168] bus: 20 index 2 mmio: [0, 0]
[    0.404205] bus: 20 index 3 mmio: [0, 0]
[    0.404242] bus: 30 index 0 mmio: [0, 0]
[    0.404279] bus: 30 index 1 mmio: [c8000000, c80fffff]
[    0.404316] bus: 30 index 2 mmio: [0, 0]
[    0.404353] bus: 30 index 3 mmio: [0, 0]
[    0.404390] bus: 02 index 0 io port: [1000, 1fff]
[    0.404428] bus: 02 index 1 mmio: [d0100000, d03fffff]
[    0.404466] bus: 02 index 2 mmio: [0, 0]
[    0.404503] bus: 02 index 3 io port: [0, ffff]
[    0.404540] bus: 02 index 4 mmio: [0, ffffffffffffffff]
[    0.404578] bus: 03 index 0 io port: [1000, 10ff]
[    0.404616] bus: 03 index 1 io port: [1400, 14ff]
[    0.404653] bus: 03 index 2 mmio: [0, 3ffffff]
[    0.404691] bus: 03 index 3 mmio: [8c000000, 8fffffff]
[    0.404740] NET: Registered protocol family 2
[    0.414035] IP route cache hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.415010] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.416914] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.417419] TCP: Hash tables configured (established 262144 bind 65536)
[    0.417462] TCP reno registered
[    0.420010] NET: Registered protocol family 1
[    0.420151] checking if image is initramfs... it is
[    0.693135] Freeing initrd memory: 4893k freed
[    0.696324] audit: initializing netlink socket (disabled)
[    0.696376] type=2000 audit(1216404031.694:1): initialized
[    0.696614] Total HugeTLB memory allocated, 0
[    0.699540] VFS: Disk quotas dquot_6.5.1
[    0.699674] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.701560] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.702383] NTFS driver 2.1.29 [Flags: R/W].
[    0.702735] QNX4 filesystem 0.2.3 registered.
[    0.702775] fuse init (API version 7.9)
[    0.703223] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.706059] SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
[    0.706917] SGI XFS Quota Management subsystem
[    0.706975] msgmni has been set to 3761
[    0.707191] async_tx: api initialized (async)
[    0.707304] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.707349] io scheduler noop registered
[    0.707386] io scheduler anticipatory registered
[    0.707424] io scheduler deadline registered
[    0.707615] io scheduler cfq registered (default)
[    0.707917] assign_interrupt_mode Found MSI capability
[    0.708120] assign_interrupt_mode Found MSI capability
[    0.708299] assign_interrupt_mode Found MSI capability
[    1.109346] ACPI: AC Adapter [C1EB] (off-line)
[    1.170892] ACPI: Battery Slot [C1ED] (battery present)
[    1.171164] ACPI: Battery Slot [C1EC] (battery absent)
[    1.171358] input: Power Button (FF) as /class/input/input0
[    1.171396] ACPI: Power Button (FF) [PWRF]
[    1.171564] input: Sleep Button (CM) as /class/input/input1
[    1.171603] ACPI: Sleep Button (CM) [C28D]
[    1.171719] input: Lid Switch as /class/input/input2
[    1.171864] ACPI: Lid Switch [C265]
[    1.172191] ACPI: Transitioning device [C399] to D3
[    1.172284] ACPI: PNP0C0B:00 is registered as cooling_device0
[    1.172326] ACPI: Fan [C399] (off)
[    1.172547] ACPI: Transitioning device [C39A] to D3
[    1.172627] ACPI: PNP0C0B:01 is registered as cooling_device1
[    1.172668] ACPI: Fan [C39A] (off)
[    1.172898] ACPI: Transitioning device [C39B] to D3
[    1.172978] ACPI: PNP0C0B:02 is registered as cooling_device2
[    1.173020] ACPI: Fan [C39B] (off)
[    1.173241] ACPI: Transitioning device [C39C] to D3
[    1.174851] ACPI: PNP0C0B:03 is registered as cooling_device3
[    1.174893] ACPI: Fan [C39C] (off)
[    1.175109] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.175310] ACPI: ACPI0007:00 is registered as cooling_device4
[    1.175780] ACPI: Processor [C000] (supports 8 throttling states)
[    1.188988] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.194351] ACPI: Thermal Zone [TZ1] (68 C)
[    1.238241] lp: driver loaded but no devices found
[    1.247249] ppdev: user-space parallel port driver
[    1.247304] Linux agpgart interface v0.103
[    1.247350] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[    1.252138] parport_pc 00:02: activated
[    1.252193] parport_pc 00:02: reported by Plug and Play ACPI
[    1.253547] parport_pc 00:02: disabled
[    1.254203] Floppy drive(s): fd0 is 1.44M
[    4.264246] floppy0: no floppy controllers found
[    4.266050] brd: module loaded
[    4.266996] loop: module loaded
[    4.267041] Compaq SMART2 Driver (v 2.6.0)
[    4.267161] HP CISS Driver (v 3.6.20)
[    4.267583] MM: desc_per_page = 128
[    4.267651] tg3.c:v3.92.1 (June 9, 2008)
[    4.267761] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    4.474876] eth0: Tigon3 [partno(none) rev b002 PHY(5787)] (PCI 
Express) 10/100/1000Base-T Ethernet 00:1a:4b:58:56:fe
[    4.474935] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] 
WireSpeed[1] TSOcap[1]
[    4.474983] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.475151] netconsole: local port 6665
[    4.475208] netconsole: local IP 192.168.3.2
[    4.475251] netconsole: interface eth0
[    4.475300] netconsole: remote port 9999
[    4.475343] netconsole: remote IP 192.168.3.1
[    4.475387] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[    4.475438] netconsole: device eth0 not up yet, forcing it
[    7.268736] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[    7.268796] tg3: eth0: Flow control is on for TX and on for RX.
[    7.272785] console [netcon0] enabled
[    7.295912] netconsole: network logging started
[    7.296123] input: Macintosh mouse button emulation as 
/class/input/input3
[    7.296864] Loading iSCSI transport class v2.0-870.
[    7.297413] iscsi: registered transport (tcp)
[    7.297753] Adaptec aacraid driver 1.1-5[2456]-ms
[    7.297971] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.298315] QLogic Fibre Channel HBA Driver: 8.02.01-k4
[    7.298489] iscsi: registered transport (qla4xxx)
[    7.298606] QLogic iSCSI HBA Driver
[    7.298651] Emulex LightPulse Fibre Channel SCSI driver 8.2.7
[    7.298704] Copyright(c) 2004-2008 Emulex.  All rights reserved.
[    7.299014] DC390: clustering now enabled by default. If you get 
problems load
[    7.299015]     with "disable_clustering=1" and report to maintainers
[    7.299243] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 
EST 2006)
[    7.299349] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 
2006)
[    7.299463] megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
[    7.299634] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    7.299861] 3ware Storage Controller device driver for Linux 
v1.26.02.002.
[    7.299965] 3ware 9000 Storage Controller device driver for Linux 
v2.26.02.010.
[    7.300072] ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 
(April 24, 2007)
[    7.300189] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[    7.300290] stex: Promise SuperTrak EX Driver version: 3.6.0000.1
[    7.300452] st: Version 20080224, fixed bufsize 32768, s/g segs 256
[    7.300549] Driver 'st' needs updating - please use bus_type methods
[    7.300645] osst :I: Tape driver with OnStream support version 0.99.4
[    7.300646] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.300910] Driver 'osst' needs updating - please use bus_type methods
[    7.301040] Driver 'sd' needs updating - please use bus_type methods
[    7.301124] Driver 'sr' needs updating - please use bus_type methods
[    7.301313] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    7.301435] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 
32bit
[    7.301554] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 
0x1 impl SATA mode
[    7.301613] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio 
slum part
[    7.301850] scsi0 : ahci
[    7.302108] scsi1 : ahci
[    7.302244] scsi2 : ahci
[    7.302381] scsi3 : ahci
[    7.302543] ata1: SATA max UDMA/133 abar m1024@0xd0609000 port 
0xd0609100 irq 16
[    7.302602] ata2: DUMMY
[    7.302644] ata3: DUMMY
[    7.302694] ata4: DUMMY
[    7.607739] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.608180] ata1.00: ATA-7: FUJITSU MHW2080BH PL, 891F, max UDMA/100
[    7.608232] ata1.00: 156301488 sectors, multi 16: LBA48
[    7.608284] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    7.608849] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    7.608902] ata1.00: configured for UDMA/100
[    7.609011] isa bounce pool size: 16 pages
[    7.609143] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2080B 
891F PQ: 0 ANSI: 5
[    7.609416] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    7.609488] sd 0:0:0:0: [sda] Write Protect is off
[    7.609563] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    7.609678] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    7.609759] sd 0:0:0:0: [sda] Write Protect is off
[    7.609832] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    7.609890]  sda: sda1 sda2 < sda5 sda6 >
[    7.726685] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.726864] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.728093] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, 
low) -> IRQ 16
[    7.728323] scsi4 : pata_atiixp
[    7.728475] scsi5 : pata_atiixp
[    7.729226] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5040 
irq 14
[    7.729276] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5048 
irq 15
[    7.918213] ata5.00: ATAPI: TSSTcorpCD/DVDW TS-L632D, HH17, max MWDMA2
[    7.959136] ata5.00: configured for MWDMA2
[    8.116013] scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-L632D 
HH17 PQ: 0 ANSI: 5
[    8.144818] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    8.144881] Uniform CD-ROM driver Revision: 3.20
[    8.145229] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    8.147281] I2O subsystem v1.325
[    8.147339] i2o: max drivers = 8
[    8.147562] I2O Configuration OSM v1.323
[    8.147736] I2O Bus Adapter OSM v1.317
[    8.147825] I2O Block Device OSM v1.325
[    8.148069] I2O SCSI Peripheral OSM v1.316
[    8.148158] I2O ProcFS OSM v1.316
[    8.148254] Fusion MPT base driver 3.04.07
[    8.148298] Copyright (c) 1999-2008 LSI Corporation
[    8.151313] Fusion MPT SPI Host driver 3.04.07
[    8.151446] Fusion MPT FC Host driver 3.04.07
[    8.151562] Fusion MPT SAS Host driver 3.04.07
[    8.151681] Fusion MPT misc device (ioctl) driver 3.04.07
[    8.151780] mptctl: Registered with Fusion MPT base driver
[    8.151826] mptctl: /dev/mptctl @ (major,minor=10,220)
[    8.151878] Fusion MPT LAN driver 3.04.07
[    8.152364] vendor=1002 device=4384
[    8.152422] ACPI: PCI Interrupt 0000:02:04.1[B] -> GSI 21 (level, 
low) -> IRQ 21
[    8.204930] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  
MMIO=[d0101000-d01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    8.210063] usbcore: registered new interface driver usblp
[    8.210119] Initializing USB Mass Storage driver...
[    8.210212] usbcore: registered new interface driver usb-storage
[    8.210258] USB Mass Storage support registered.
[    8.210361] usbcore: registered new interface driver libusual
[    8.210526] PNP: PS/2 Controller [PNP0303:C249,PNP0f13:C24A] at 
0x60,0x64 irq 1,12
[    8.212486] i8042.c: Detected active multiplexing controller, rev 1.1.
[    8.213270] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.213318] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    8.213369] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    8.213415] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    8.213459] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    8.222233] parkbd: no such parport
[    8.226082] mice: PS/2 mouse device common for all mice
[    8.238418] md: linear personality registered for level -1
[    8.238468] md: raid0 personality registered for level 0
[    8.238518] md: raid1 personality registered for level 1
[    8.238563] md: raid10 personality registered for level 10
[    8.254982] raid6: int64x1   1496 MB/s
[    8.271988] raid6: int64x2   1921 MB/s
[    8.288974] raid6: int64x4   1839 MB/s
[    8.305998] raid6: int64x8   1660 MB/s
[    8.322964] raid6: sse2x1    2093 MB/s
[    8.339961] raid6: sse2x2    3023 MB/s
[    8.356978] raid6: sse2x4    3117 MB/s
[    8.357028] raid6: using algorithm sse2x4 (3117 MB/s)
[    8.357073] md: raid6 personality registered for level 6
[    8.357117] md: raid5 personality registered for level 5
[    8.357167] md: raid4 personality registered for level 4
[    8.357213] md: multipath personality registered for level -4
[    8.357263] md: faulty personality registered for level -5
[    8.357480] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) 
initialised: dm-devel@redhat.com
[    8.357892] cpuidle: using governor ladder
[    8.358253] cpuidle: using governor menu
[    8.358420] dcdbas dcdbas: Dell Systems Management Base Driver 
(version 5.6.0-3.2)
[    8.358585] usbcore: registered new interface driver hiddev
[    8.358678] usbcore: registered new interface driver usbhid
[    8.358724] usbhid: v2.6:USB HID core driver
[    8.359503] TCP bic registered
[    8.359558] NET: Registered protocol family 17
[    8.359856] RPC: Registered udp transport module.
[    8.359903] RPC: Registered tcp transport module.
[    8.359972] powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 
3600+ processors (1 cpu cores) (version 2.20.00)
[    8.360086] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x10
[    8.360131] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x12
[    8.360183] powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x14
[    8.360227] powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x18
[    8.360309] powernow-k8: ph2 null fid transition 0xc
[    8.360583] registered taskstats version 1
[    8.360812] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    8.360918] Freeing unused kernel memory: 484k freed

