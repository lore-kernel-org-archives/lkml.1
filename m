Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbYGRRRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbYGRRRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYGRRRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:17:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:36173 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbYGRRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bteyFje3k5qzw16XqBbGh5yT90ai02Hc9najvJrSo0Z1IQ4q0oe0EuC3EJA75x2Gjc
         PNgM13EYJtDkxLZ9DCIserJM1xr1pLzmnEEtKlsTh8bYY9oLH5pp1QhylvIub7eBHFiQ
         qUygCNyAapsDqm7cFQ+rGGLIoj5p0Wl7Eec3c=
Message-ID: <4880CFC0.1000001@gmail.com>
Date: Fri, 18 Jul 2008 18:15:44 +0100
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
And finally.... nohz=off

Richard



[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-tip (root@localhost) (gcc version 
4.2.3 (Gentoo 4.2.3 p1.0)) #3 SMP Thu Jul 17 19:30:56 UTC 2008
[    0.000000] Command line: root=/dev/ram0 ramdisk=8192 
real_root=UUID=e1ef4642-3c14-4a73-be54-c04e9bcf2422 dolvm init=/linuxrc 
CONSOLE=/dev/tty1 nohz=off resume=swap:/dev/sda6 nox 
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
CONSOLE=/dev/tty1 nohz=off resume=swap:/dev/sda6 nox 
netconsole=@192.168.3.2/eth0,9999@192.168.3.1/
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 1994.904 MHz processor.
[    0.001999] Console: colour VGA+ 80x25
[    0.001999] console [tty0] enabled
[    0.001999] Checking aperture...
[    0.001999] No AGP bridge found
[    0.001999] Node 0: aperture @ d35c000000 size 32 MB
[    0.001999] Aperture beyond 4GB. Ignoring.
[    0.001999] Memory: 1920920k/1965760k available (6412k kernel code, 
44452k reserved, 3058k data, 484k init)
[    0.001999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.002184] Calibrating delay loop (skipped), value calculated using 
timer frequency.. <6>3989.80 BogoMIPS (lpj=1994904)
[    0.002285] Security Framework initialized
[    0.002331] SELinux:  Disabled at boot.
[    0.002563] Dentry cache hash table entries: 262144 (order: 9, 
2097152 bytes)
[    0.004906] Inode-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.006153] Mount-cache hash table entries: 256
[    0.006546] Initializing cgroup subsys debug
[    0.006636] Initializing cgroup subsys ns
[    0.006736] Initializing cgroup subsys cpuacct
[    0.006832] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.006919] CPU: L2 Cache: 256K (64 bytes/line)
[    0.006988] CPU 0/0 -> Node 0
[    0.007089] using C1E aware idle routine
[    0.007202] ACPI: Core revision 20080321
[    0.043993] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.054804] CPU0: Mobile AMD Sempron(tm) Processor 3600+ stepping 02
[    0.054909] Using local APIC timer interrupts.
[    0.055991] Detected 12.468 MHz APIC timer.
[    0.055991] Brought up 1 CPUs
[    0.055991] Total of 1 processors activated (3989.80 BogoMIPS).
[    0.055991] net_namespace: 1224 bytes
[    0.055991] xor: automatically using best checksumming function: 
generic_sse
[    0.060180]    generic_sse:  6144.000 MB/sec
[    0.060220] xor: using function: generic_sse (6144.000 MB/sec)
[    0.060294] NET: Registered protocol family 16
[    0.060561] No dock devices found.
[    0.060990] TOM: 0000000080000000 aka 2048M
[    0.061003] ACPI: bus type pci registered
[    0.061134] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.061173] PCI: MCFG area at e0000000 reserved in E820
[    0.067366] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.067410] PCI: Using configuration type 1 for base access
[    0.073911] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.337948] ACPI: Interpreter enabled
[    0.337948] ACPI: (supports S0 S3 S4 S5)
[    0.338120] ACPI: Using IOAPIC for interrupt routing
[    0.349227] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.349273] ACPI: EC: driver started in interrupt mode
[    0.349409] ACPI: PCI Root Bridge [C08B] (0000:00)
[    0.349646] PCI: 0000:00:12.0 reg 10 io port: [9000, 9007]
[    0.349690] PCI: 0000:00:12.0 reg 14 io port: [9008, 900b]
[    0.349733] PCI: 0000:00:12.0 reg 18 io port: [9010, 9017]
[    0.349776] PCI: 0000:00:12.0 reg 1c io port: [5018, 501b]
[    0.349819] PCI: 0000:00:12.0 reg 20 io port: [5020, 502f]
[    0.349863] PCI: 0000:00:12.0 reg 24 32bit mmio: [d0609000, d06093ff]
[    0.349923] pci 0000:00:12.0: set SATA to AHCI mode
[    0.349984] PCI: 0000:00:13.0 reg 10 32bit mmio: [d0601000, d0601fff]
[    0.350072] PCI: 0000:00:13.1 reg 10 32bit mmio: [d0602000, d0602fff]
[    0.350160] PCI: 0000:00:13.2 reg 10 32bit mmio: [d0603000, d0603fff]
[    0.350247] PCI: 0000:00:13.3 reg 10 32bit mmio: [d0604000, d0604fff]
[    0.350334] PCI: 0000:00:13.4 reg 10 32bit mmio: [d0605000, d0605fff]
[    0.350440] PCI: 0000:00:13.5 reg 10 32bit mmio: [d0606000, d06060ff]
[    0.350545] PCI: 0000:00:14.0 reg 10 io port: [8200, 820f]
[    0.350634] PCI: 0000:00:14.1 reg 10 io port: [0, 7]
[    0.350677] PCI: 0000:00:14.1 reg 14 io port: [0, 3]
[    0.350719] PCI: 0000:00:14.1 reg 18 io port: [0, 7]
[    0.350760] PCI: 0000:00:14.1 reg 1c io port: [0, 3]
[    0.350803] PCI: 0000:00:14.1 reg 20 io port: [5040, 504f]
[    0.350891] PCI: 0000:00:14.2 reg 10 64bit mmio: [d0608000, d060bfff]
[    0.351150] PCI: 0000:01:05.0 reg 10 64bit mmio: [c0000000, c7ffffff]
[    0.351193] PCI: 0000:01:05.0 reg 18 64bit mmio: [d0400000, d040ffff]
[    0.351234] PCI: 0000:01:05.0 reg 20 io port: [4000, 40ff]
[    0.351274] PCI: 0000:01:05.0 reg 24 32bit mmio: [d0500000, d05fffff]
[    0.351329] PCI: bridge 0000:00:01.0 io port: [4000, 4fff]
[    0.351369] PCI: bridge 0000:00:01.0 32bit mmio: [d0400000, d05fffff]
[    0.351410] PCI: bridge 0000:00:01.0 64bit mmio pref: [c0000000, 
c7ffffff]
[    0.351538] PCI: 0000:10:00.0 reg 10 64bit mmio: [d0000000, d000ffff]
[    0.351653] PCI: bridge 0000:00:04.0 32bit mmio: [d0000000, d00fffff]
[    0.351738] PCI: bridge 0000:00:05.0 io port: [2000, 3fff]
[    0.352945] PCI: bridge 0000:00:05.0 32bit mmio: [cc000000, cfffffff]
[    0.352945] PCI: 0000:30:00.0 reg 10 64bit mmio: [c8000000, c8003fff]
[    0.353043] PCI: bridge 0000:00:06.0 32bit mmio: [c8000000, c80fffff]
[    0.353221] PCI: 0000:02:04.0 reg 10 32bit mmio: [d0100000, d0100fff]
[    0.353388] PCI: 0000:02:04.1 reg 10 32bit mmio: [d0101000, d01017ff]
[    0.353663] PCI: Transparent bridge - 0000:00:14.4
[    0.353748] PCI: bridge 0000:00:14.4 32bit mmio: [d0100000, d03fffff]
[    0.376761] ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
[    0.377175] ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
[    0.377562] ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
[    0.377955] ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
[    0.378355] ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
[    0.378755] ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
[    0.379123] ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
[    0.379511] ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
[    0.379900] ACPI: Power Resource [C171] (off)
[    0.380142] ACPI: Power Resource [C230] (off)
[    0.380232] ACPI: Power Resource [C24C] (on)
[    0.380406] ACPI: Power Resource [C395] (off)
[    0.380539] ACPI: Power Resource [C396] (off)
[    0.380672] ACPI: Power Resource [C397] (off)
[    0.380805] ACPI: Power Resource [C398] (off)
[    0.381170] ACPI: WMI: Mapper loaded
[    0.381211] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.381282] pnp: PnP ACPI init
[    0.381327] ACPI: bus type pnp registered
[    0.392401] pnp: PnP ACPI: found 14 devices
[    0.392446] ACPI: ACPI bus type pnp unregistered
[    0.392794] SCSI subsystem initialized
[    0.393076] usbcore: registered new interface driver usbfs
[    0.393184] usbcore: registered new interface driver hub
[    0.393267] usbcore: registered new device driver usb
[    0.393528] PCI: Using ACPI for IRQ routing
[    0.393608] PCI: Cannot allocate resource region 0 of device 0000:00:14.2
[    0.398952] NetLabel: Initializing
[    0.398993] NetLabel:  domain hash size = 128
[    0.399030] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.399081] NetLabel:  unlabeled traffic allowed by default
[    0.399247] ACPI: RTC can wake from S4
[    0.401959] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.402003] system 00:00: iomem range 0xe0000-0xfffff could not be 
reserved
[    0.402042] system 00:00: iomem range 0x100000-0xffffffff could not 
be reserved
[    0.402097] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.402137] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.402176] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.402215] system 00:0a: ioport range 0x500-0x51f has been reserved
[    0.402255] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.402294] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.402333] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.402373] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.402412] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.402451] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.402491] system 00:0a: ioport range 0xcd0-0xcdf has been reserved
[    0.402531] system 00:0a: iomem range 0xffb00000-0xffbfffff could not 
be reserved
[    0.402575] system 00:0a: iomem range 0xfff00000-0xffffffff could not 
be reserved
[    0.402623] system 00:0c: ioport range 0x8000-0x802f has been reserved
[    0.402662] system 00:0c: ioport range 0x8100-0x811f has been reserved
[    0.402702] system 00:0c: iomem range 0xe0000000-0xefffffff could not 
be reserved
[    0.402745] system 00:0c: iomem range 0xfec00000-0xfec000ff could not 
be reserved
[    0.402788] system 00:0c: iomem range 0xfed45000-0xfed8ffff has been 
reserved
[    0.402832] system 00:0d: iomem range 0xcd400-0xcffff has been reserved
[    0.402871] system 00:0d: iomem range 0xd2a00-0xd2fff has been reserved
[    0.402910] system 00:0d: iomem range 0x0-0x7ffffff could not be reserved
[    0.402951] system 00:0d: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.403461] PCI: region 0000:02:04.0/9 too large: 
0x0000000000000000-0x0000000003ffffff
[    0.403519] PCI: Bridge: 0000:00:01.0
[    0.403556]   IO window: 4000-4fff
[    0.403594]   MEM window: 0xd0400000-0xd05fffff
[    0.403632]   PREFETCH window: 0x00000000c0000000-0x00000000c7ffffff
[    0.403671] PCI: Bridge: 0000:00:04.0
[    0.403707]   IO window: disabled.
[    0.403745]   MEM window: 0xd0000000-0xd00fffff
[    0.403782]   PREFETCH window: disabled.
[    0.403820] PCI: Bridge: 0000:00:05.0
[    0.403857]   IO window: 2000-3fff
[    0.403894]   MEM window: 0xcc000000-0xcfffffff
[    0.403957]   PREFETCH window: disabled.
[    0.404004] PCI: Bridge: 0000:00:06.0
[    0.404041]   IO window: disabled.
[    0.404078]   MEM window: 0xc8000000-0xc80fffff
[    0.404116]   PREFETCH window: disabled.
[    0.404157] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[    0.404195]   IO window: 0x00001000-0x000010ff
[    0.404235]   IO window: 0x00001400-0x000014ff
[    0.404276]   MEM window: 0x8c000000-0x8fffffff
[    0.404317] PCI: Bridge: 0000:00:14.4
[    0.404354]   IO window: 1000-1fff
[    0.404395]   MEM window: 0xd0100000-0xd03fffff
[    0.404434]   PREFETCH window: disabled.
[    0.404528] vendor=1002 device=4384
[    0.404569] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, 
low) -> IRQ 20
[    0.404647] bus: 00 index 0 io port: [0, ffff]
[    0.404685] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.404723] bus: 01 index 0 io port: [4000, 4fff]
[    0.404761] bus: 01 index 1 mmio: [d0400000, d05fffff]
[    0.404799] bus: 01 index 2 mmio: [c0000000, c7ffffff]
[    0.404837] bus: 01 index 3 mmio: [0, 0]
[    0.404874] bus: 10 index 0 mmio: [0, 0]
[    0.404911] bus: 10 index 1 mmio: [d0000000, d00fffff]
[    0.404949] bus: 10 index 2 mmio: [0, 0]
[    0.404986] bus: 10 index 3 mmio: [0, 0]
[    0.405032] bus: 20 index 0 io port: [2000, 3fff]
[    0.405070] bus: 20 index 1 mmio: [cc000000, cfffffff]
[    0.405108] bus: 20 index 2 mmio: [0, 0]
[    0.405145] bus: 20 index 3 mmio: [0, 0]
[    0.405183] bus: 30 index 0 mmio: [0, 0]
[    0.405220] bus: 30 index 1 mmio: [c8000000, c80fffff]
[    0.405258] bus: 30 index 2 mmio: [0, 0]
[    0.405295] bus: 30 index 3 mmio: [0, 0]
[    0.405332] bus: 02 index 0 io port: [1000, 1fff]
[    0.405370] bus: 02 index 1 mmio: [d0100000, d03fffff]
[    0.405408] bus: 02 index 2 mmio: [0, 0]
[    0.405445] bus: 02 index 3 io port: [0, ffff]
[    0.405482] bus: 02 index 4 mmio: [0, ffffffffffffffff]
[    0.405520] bus: 03 index 0 io port: [1000, 10ff]
[    0.405558] bus: 03 index 1 io port: [1400, 14ff]
[    0.405596] bus: 03 index 2 mmio: [0, 3ffffff]
[    0.405633] bus: 03 index 3 mmio: [8c000000, 8fffffff]
[    0.405683] NET: Registered protocol family 2
[    0.415117] IP route cache hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.416092] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.418413] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.419100] TCP: Hash tables configured (established 262144 bind 65536)
[    0.419145] TCP reno registered
[    0.422092] NET: Registered protocol family 1
[    0.422234] checking if image is initramfs... it is
[    0.696968] Freeing initrd memory: 4893k freed
[    0.700318] audit: initializing netlink socket (disabled)
[    0.700375] type=2000 audit(1216404168.699:1): initialized
[    0.700679] Total HugeTLB memory allocated, 0
[    0.704403] VFS: Disk quotas dquot_6.5.1
[    0.704561] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.707084] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.708126] NTFS driver 2.1.29 [Flags: R/W].
[    0.708575] QNX4 filesystem 0.2.3 registered.
[    0.708615] fuse init (API version 7.9)
[    0.709229] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.712133] SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
[    0.713181] SGI XFS Quota Management subsystem
[    0.713236] msgmni has been set to 3761
[    0.713455] async_tx: api initialized (async)
[    0.713587] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.713631] io scheduler noop registered
[    0.713668] io scheduler anticipatory registered
[    0.713705] io scheduler deadline registered
[    0.713923] io scheduler cfq registered (default)
[    0.714226] assign_interrupt_mode Found MSI capability
[    0.714463] assign_interrupt_mode Found MSI capability
[    0.714680] assign_interrupt_mode Found MSI capability
[    1.115555] ACPI: AC Adapter [C1EB] (off-line)
[    1.178060] ACPI: Battery Slot [C1ED] (battery present)
[    1.178336] ACPI: Battery Slot [C1EC] (battery absent)
[    1.178568] input: Power Button (FF) as /class/input/input0
[    1.178607] ACPI: Power Button (FF) [PWRF]
[    1.178795] input: Sleep Button (CM) as /class/input/input1
[    1.178834] ACPI: Sleep Button (CM) [C28D]
[    1.178969] input: Lid Switch as /class/input/input2
[    1.179117] ACPI: Lid Switch [C265]
[    1.179474] ACPI: Transitioning device [C399] to D3
[    1.179586] ACPI: PNP0C0B:00 is registered as cooling_device0
[    1.179628] ACPI: Fan [C399] (off)
[    1.179852] ACPI: Transitioning device [C39A] to D3
[    1.179949] ACPI: PNP0C0B:01 is registered as cooling_device1
[    1.180003] ACPI: Fan [C39A] (off)
[    1.180225] ACPI: Transitioning device [C39B] to D3
[    1.180323] ACPI: PNP0C0B:02 is registered as cooling_device2
[    1.180364] ACPI: Fan [C39B] (off)
[    1.180587] ACPI: Transitioning device [C39C] to D3
[    1.180683] ACPI: PNP0C0B:03 is registered as cooling_device3
[    1.180727] ACPI: Fan [C39C] (off)
[    1.184536] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.184753] ACPI: ACPI0007:00 is registered as cooling_device4
[    1.184794] ACPI: Processor [C000] (supports 8 throttling states)
[    1.197411] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.202582] ACPI: Thermal Zone [TZ1] (67 C)
[    1.258835] lp: driver loaded but no devices found
[    1.267778] ppdev: user-space parallel port driver
[    1.267836] Linux agpgart interface v0.103
[    1.267882] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[    1.272751] parport_pc 00:02: activated
[    1.272800] parport_pc 00:02: reported by Plug and Play ACPI
[    1.274172] parport_pc 00:02: disabled
[    1.274868] Floppy drive(s): fd0 is 1.44M
[    4.285951] floppy0: no floppy controllers found
[    4.288044] brd: module loaded
[    4.289155] loop: module loaded
[    4.289201] Compaq SMART2 Driver (v 2.6.0)
[    4.289326] HP CISS Driver (v 3.6.20)
[    4.289733] MM: desc_per_page = 128
[    4.289806] tg3.c:v3.92.1 (June 9, 2008)
[    4.289915] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    4.497637] eth0: Tigon3 [partno(none) rev b002 PHY(5787)] (PCI 
Express) 10/100/1000Base-T Ethernet 00:1a:4b:58:56:fe
[    4.497696] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] 
WireSpeed[1] TSOcap[1]
[    4.497751] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.497948] netconsole: local port 6665
[    4.497991] netconsole: local IP 192.168.3.2
[    4.498034] netconsole: interface eth0
[    4.498082] netconsole: remote port 9999
[    4.498125] netconsole: remote IP 192.168.3.1
[    4.498175] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[    4.498220] netconsole: device eth0 not up yet, forcing it
[    7.229923] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[    7.229978] tg3: eth0: Flow control is on for TX and on for RX.
[    7.233957] console [netcon0] enabled
[    7.257479] netconsole: network logging started
[    7.257694] input: Macintosh mouse button emulation as 
/class/input/input3
[    7.258097] Loading iSCSI transport class v2.0-870.
[    7.258871] iscsi: registered transport (tcp)
[    7.259299] Adaptec aacraid driver 1.1-5[2456]-ms
[    7.259527] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.259993] QLogic Fibre Channel HBA Driver: 8.02.01-k4
[    7.260226] iscsi: registered transport (qla4xxx)
[    7.260361] QLogic iSCSI HBA Driver
[    7.260411] Emulex LightPulse Fibre Channel SCSI driver 8.2.7
[    7.260458] Copyright(c) 2004-2008 Emulex.  All rights reserved.
[    7.260838] DC390: clustering now enabled by default. If you get 
problems load
[    7.260839]     with "disable_clustering=1" and report to maintainers
[    7.261122] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 
EST 2006)
[    7.261253] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 
2006)
[    7.261385] megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
[    7.261607] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    7.261883] 3ware Storage Controller device driver for Linux 
v1.26.02.002.
[    7.262139] 3ware 9000 Storage Controller device driver for Linux 
v2.26.02.010.
[    7.262273] ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 
(April 24, 2007)
[    7.262409] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[    7.262536] stex: Promise SuperTrak EX Driver version: 3.6.0000.1
[    7.262741] st: Version 20080224, fixed bufsize 32768, s/g segs 256
[    7.262858] Driver 'st' needs updating - please use bus_type methods
[    7.262990] osst :I: Tape driver with OnStream support version 0.99.4
[    7.262991] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.263144] Driver 'osst' needs updating - please use bus_type methods
[    7.263327] Driver 'sd' needs updating - please use bus_type methods
[    7.263434] Driver 'sr' needs updating - please use bus_type methods
[    7.263671] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    7.263794] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 
32bit
[    7.263946] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 
0x1 impl SATA mode
[    7.263999] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio 
slum part
[    7.264247] scsi0 : ahci
[    7.264549] scsi1 : ahci
[    7.264739] scsi2 : ahci
[    7.264944] scsi3 : ahci
[    7.265139] ata1: SATA max UDMA/133 abar m1024@0xd0609000 port 
0xd0609100 irq 16
[    7.265193] ata2: DUMMY
[    7.265242] ata3: DUMMY
[    7.265285] ata4: DUMMY
[    7.569938] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.570393] ata1.00: ATA-7: FUJITSU MHW2080BH PL, 891F, max UDMA/100
[    7.570445] ata1.00: 156301488 sectors, multi 16: LBA48
[    7.570497] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    7.571062] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    7.571114] ata1.00: configured for UDMA/100
[    7.571313] isa bounce pool size: 16 pages
[    7.571463] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2080B 
891F PQ: 0 ANSI: 5
[    7.571830] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    7.571921] sd 0:0:0:0: [sda] Write Protect is off
[    7.572030] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    7.572169] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    7.572245] sd 0:0:0:0: [sda] Write Protect is off
[    7.572344] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    7.572403]  sda: sda1 sda2 < sda5 sda6 >
[    7.697865] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.698069] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.699525] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, 
low) -> IRQ 16
[    7.699781] scsi4 : pata_atiixp
[    7.700042] scsi5 : pata_atiixp
[    7.700787] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5040 
irq 14
[    7.700836] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5048 
irq 15
[    7.890452] ata5.00: ATAPI: TSSTcorpCD/DVDW TS-L632D, HH17, max MWDMA2
[    7.931399] ata5.00: configured for MWDMA2
[    8.088284] scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-L632D 
HH17 PQ: 0 ANSI: 5
[    8.117092] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    8.117154] Uniform CD-ROM driver Revision: 3.20
[    8.117543] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    8.119888] I2O subsystem v1.325
[    8.119982] i2o: max drivers = 8
[    8.120275] I2O Configuration OSM v1.323
[    8.120470] I2O Bus Adapter OSM v1.317
[    8.120578] I2O Block Device OSM v1.325
[    8.120911] I2O SCSI Peripheral OSM v1.316
[    8.121027] I2O ProcFS OSM v1.316
[    8.121147] Fusion MPT base driver 3.04.07
[    8.121198] Copyright (c) 1999-2008 LSI Corporation
[    8.121247] Fusion MPT SPI Host driver 3.04.07
[    8.121410] Fusion MPT FC Host driver 3.04.07
[    8.121559] Fusion MPT SAS Host driver 3.04.07
[    8.121697] Fusion MPT misc device (ioctl) driver 3.04.07
[    8.125293] mptctl: Registered with Fusion MPT base driver
[    8.125340] mptctl: /dev/mptctl @ (major,minor=10,220)
[    8.125385] Fusion MPT LAN driver 3.04.07
[    8.125930] vendor=1002 device=4384
[    8.125987] ACPI: PCI Interrupt 0000:02:04.1[B] -> GSI 21 (level, 
low) -> IRQ 21
[    8.178514] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  
MMIO=[d0101000-d01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    8.183150] usbcore: registered new interface driver usblp
[    8.183202] Initializing USB Mass Storage driver...
[    8.183322] usbcore: registered new interface driver usb-storage
[    8.183368] USB Mass Storage support registered.
[    8.183494] usbcore: registered new interface driver libusual
[    8.183705] PNP: PS/2 Controller [PNP0303:C249,PNP0f13:C24A] at 
0x60,0x64 irq 1,12
[    8.185783] i8042.c: Detected active multiplexing controller, rev 1.1.
[    8.186574] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.186624] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    8.186674] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    8.186720] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    8.186773] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    8.195495] parkbd: no such parport
[    8.198037] mice: PS/2 mouse device common for all mice
[    8.210524] md: linear personality registered for level -1
[    8.210578] md: raid0 personality registered for level 0
[    8.210624] md: raid1 personality registered for level 1
[    8.210674] md: raid10 personality registered for level 10
[    8.226899] raid6: int64x1   1484 MB/s
[    8.243921] raid6: int64x2   1898 MB/s
[    8.260930] raid6: int64x4   1835 MB/s
[    8.277911] raid6: int64x8   1632 MB/s
[    8.294916] raid6: sse2x1    2085 MB/s
[    8.311903] raid6: sse2x2    3007 MB/s
[    8.328914] raid6: sse2x4    3101 MB/s
[    8.328958] raid6: using algorithm sse2x4 (3101 MB/s)
[    8.329010] md: raid6 personality registered for level 6
[    8.329055] md: raid5 personality registered for level 5
[    8.329100] md: raid4 personality registered for level 4
[    8.329152] md: multipath personality registered for level -4
[    8.329197] md: faulty personality registered for level -5
[    8.329506] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) 
initialised: dm-devel@redhat.com
[    8.330118] cpuidle: using governor ladder
[    8.330666] cpuidle: using governor menu
[    8.350511] input: AT Translated Set 2 keyboard as /class/input/input4
[    8.356102] dcdbas dcdbas: Dell Systems Management Base Driver 
(version 5.6.0-3.2)
[    8.356300] usbcore: registered new interface driver hiddev
[    8.356417] usbcore: registered new interface driver usbhid
[    8.356464] usbhid: v2.6:USB HID core driver
[    8.357253] TCP bic registered
[    8.357308] NET: Registered protocol family 17
[    8.357638] RPC: Registered udp transport module.
[    8.357685] RPC: Registered tcp transport module.
[    8.357746] powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 
3600+ processors (1 cpu cores) (version 2.20.00)
[    8.357862] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x10
[    8.357920] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x12
[    8.357973] powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x14
[    8.358020] powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x18
[    8.358100] powernow-k8: ph2 null fid transition 0xc
[    8.358467] registered taskstats version 1
[    8.358694] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    8.358800] Freeing unused kernel memory: 484k freed

