Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbYEEWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbYEEWTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759333AbYEEWTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:19:38 -0400
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:42940 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbYEEWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:19:36 -0400
Message-ID: <481F87F2.70005@numericable.fr>
Date: Tue, 06 May 2008 00:19:30 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com>
In-Reply-To: <20080505172619.GD28173@linux-os.sc.intel.com>
Content-Type: multipart/mixed;
 boundary="------------020903080906090201040301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020903080906090201040301
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Suresh Siddha a =E9crit :
> On Sun, May 04, 2008 at 11:03:52AM +0200, Rufus & Azrael wrote:
>  =20
>> Ingo Molnar a =E9crit :
>>    =20
>>> * Rufus & Azrael <rufus-azrael@numericable.fr> wrote:
>>>      =20
>>>> When upgrading to 2.6.25-git18 and above kernel this Xorg error occu=
rs :
>>>>
>>>> xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (In=
valid=20
>>>> argument)
>>>>
>>>> The latest working kernel was 25-git17 and perhaps is it related to =

>>>> http://lkml.org/lkml/2008/4/28/52
>>>>   =20
>>>>        =20
>>> does this X-does-not-start-up problem go away if you disable this=20
>>> option:
>>> =20
>>>      =20
>>>> CONFIG_X86_PAT=3Dy
>>>>   =20
>>>>        =20
>>> ?
>>> =20
>>>      =20
>> Thanks for your help Ingo, all work fine when CONFIG_PAT=3Dn :-)
>>    =20
>
> hi, Can you please send us the "dmesg" output in the failing scenario
> with PAT enabled, after the X crash?
>
> thanks,
> suresh
>
>  =20
Hi,

Here is my dmesg with 2.6.26-rc1-git3 and CONFIG_X86_PAT=3Dy

Hope it can help you to fixe the crash.

Regards.

--------------020903080906090201040301
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

 23 to node: 00
[    0.157804] bus: 24 to node: 00
[    0.157805] bus: 25 to node: 00
[    0.157806] bus: 26 to node: 00
[    0.157807] bus: 27 to node: 00
[    0.157808] bus: 28 to node: 00
[    0.157809] bus: 29 to node: 00
[    0.157810] bus: 2a to node: 00
[    0.157812] bus: 2b to node: 00
[    0.157813] bus: 2c to node: 00
[    0.157814] bus: 2d to node: 00
[    0.157815] bus: 2e to node: 00
[    0.157816] bus: 2f to node: 00
[    0.157817] bus: 30 to node: 00
[    0.157819] bus: 31 to node: 00
[    0.157820] bus: 32 to node: 00
[    0.157821] bus: 33 to node: 00
[    0.157822] bus: 34 to node: 00
[    0.157823] bus: 35 to node: 00
[    0.157824] bus: 36 to node: 00
[    0.157825] bus: 37 to node: 00
[    0.157827] bus: 38 to node: 00
[    0.157828] bus: 39 to node: 00
[    0.157829] bus: 3a to node: 00
[    0.157830] bus: 3b to node: 00
[    0.157831] bus: 3c to node: 00
[    0.157832] bus: 3d to node: 00
[    0.157833] bus: 3e to node: 00
[    0.157834] bus: 3f to node: 00
[    0.157836] bus: 40 to node: 00
[    0.157837] bus: 41 to node: 00
[    0.157838] bus: 42 to node: 00
[    0.157839] bus: 43 to node: 00
[    0.157840] bus: 44 to node: 00
[    0.157841] bus: 45 to node: 00
[    0.157842] bus: 46 to node: 00
[    0.157843] bus: 47 to node: 00
[    0.157845] bus: 48 to node: 00
[    0.157846] bus: 49 to node: 00
[    0.157847] bus: 4a to node: 00
[    0.157848] bus: 4b to node: 00
[    0.157849] bus: 4c to node: 00
[    0.157850] bus: 4d to node: 00
[    0.157851] bus: 4e to node: 00
[    0.157852] bus: 4f to node: 00
[    0.157853] bus: 50 to node: 00
[    0.157855] bus: 51 to node: 00
[    0.157856] bus: 52 to node: 00
[    0.157857] bus: 53 to node: 00
[    0.157858] bus: 54 to node: 00
[    0.157859] bus: 55 to node: 00
[    0.157860] bus: 56 to node: 00
[    0.157861] bus: 57 to node: 00
[    0.157862] bus: 58 to node: 00
[    0.157864] bus: 59 to node: 00
[    0.157865] bus: 5a to node: 00
[    0.157866] bus: 5b to node: 00
[    0.157867] bus: 5c to node: 00
[    0.157868] bus: 5d to node: 00
[    0.157869] bus: 5e to node: 00
[    0.157870] bus: 5f to node: 00
[    0.157872] bus: 60 to node: 00
[    0.157873] bus: 61 to node: 00
[    0.157874] bus: 62 to node: 00
[    0.157875] bus: 63 to node: 00
[    0.157876] bus: 64 to node: 00
[    0.157877] bus: 65 to node: 00
[    0.157878] bus: 66 to node: 00
[    0.157880] bus: 67 to node: 00
[    0.157881] bus: 68 to node: 00
[    0.157882] bus: 69 to node: 00
[    0.157883] bus: 6a to node: 00
[    0.157884] bus: 6b to node: 00
[    0.157885] bus: 6c to node: 00
[    0.157887] bus: 6d to node: 00
[    0.157888] bus: 6e to node: 00
[    0.157889] bus: 6f to node: 00
[    0.157890] bus: 70 to node: 00
[    0.157891] bus: 71 to node: 00
[    0.157892] bus: 72 to node: 00
[    0.157893] bus: 73 to node: 00
[    0.157894] bus: 74 to node: 00
[    0.157895] bus: 75 to node: 00
[    0.157897] bus: 76 to node: 00
[    0.157898] bus: 77 to node: 00
[    0.157899] bus: 78 to node: 00
[    0.157900] bus: 79 to node: 00
[    0.157901] bus: 7a to node: 00
[    0.157903] bus: 7b to node: 00
[    0.157904] bus: 7c to node: 00
[    0.157905] bus: 7d to node: 00
[    0.157906] bus: 7e to node: 00
[    0.157907] bus: 7f to node: 00
[    0.157908] bus: 80 to node: 00
[    0.157910] bus: 81 to node: 00
[    0.157911] bus: 82 to node: 00
[    0.157912] bus: 83 to node: 00
[    0.157913] bus: 84 to node: 00
[    0.157914] bus: 85 to node: 00
[    0.157915] bus: 86 to node: 00
[    0.157916] bus: 87 to node: 00
[    0.157917] bus: 88 to node: 00
[    0.157918] bus: 89 to node: 00
[    0.157919] bus: 8a to node: 00
[    0.157920] bus: 8b to node: 00
[    0.157922] bus: 8c to node: 00
[    0.157923] bus: 8d to node: 00
[    0.157924] bus: 8e to node: 00
[    0.157925] bus: 8f to node: 00
[    0.157926] bus: 90 to node: 00
[    0.157927] bus: 91 to node: 00
[    0.157928] bus: 92 to node: 00
[    0.157929] bus: 93 to node: 00
[    0.157930] bus: 94 to node: 00
[    0.157931] bus: 95 to node: 00
[    0.157933] bus: 96 to node: 00
[    0.157934] bus: 97 to node: 00
[    0.157935] bus: 98 to node: 00
[    0.157936] bus: 99 to node: 00
[    0.157937] bus: 9a to node: 00
[    0.157938] bus: 9b to node: 00
[    0.157939] bus: 9c to node: 00
[    0.157940] bus: 9d to node: 00
[    0.157942] bus: 9e to node: 00
[    0.157943] bus: 9f to node: 00
[    0.157944] bus: a0 to node: 00
[    0.157945] bus: a1 to node: 00
[    0.157946] bus: a2 to node: 00
[    0.157947] bus: a3 to node: 00
[    0.157948] bus: a4 to node: 00
[    0.157949] bus: a5 to node: 00
[    0.157951] bus: a6 to node: 00
[    0.157952] bus: a7 to node: 00
[    0.157953] bus: a8 to node: 00
[    0.157954] bus: a9 to node: 00
[    0.157955] bus: aa to node: 00
[    0.157956] bus: ab to node: 00
[    0.157958] bus: ac to node: 00
[    0.157959] bus: ad to node: 00
[    0.157960] bus: ae to node: 00
[    0.157961] bus: af to node: 00
[    0.157962] bus: b0 to node: 00
[    0.157963] bus: b1 to node: 00
[    0.157964] bus: b2 to node: 00
[    0.157965] bus: b3 to node: 00
[    0.157966] bus: b4 to node: 00
[    0.157967] bus: b5 to node: 00
[    0.157968] bus: b6 to node: 00
[    0.157970] bus: b7 to node: 00
[    0.157971] bus: b8 to node: 00
[    0.157972] bus: b9 to node: 00
[    0.157973] bus: ba to node: 00
[    0.157974] bus: bb to node: 00
[    0.157977] bus: bc to node: 00
[    0.157978] bus: bd to node: 00
[    0.157979] bus: be to node: 00
[    0.157980] bus: bf to node: 00
[    0.157981] bus: c0 to node: 00
[    0.157982] bus: c1 to node: 00
[    0.157983] bus: c2 to node: 00
[    0.157984] bus: c3 to node: 00
[    0.157985] bus: c4 to node: 00
[    0.157986] bus: c5 to node: 00
[    0.157987] bus: c6 to node: 00
[    0.157988] bus: c7 to node: 00
[    0.157989] bus: c8 to node: 00
[    0.157990] bus: c9 to node: 00
[    0.157991] bus: ca to node: 00
[    0.157992] bus: cb to node: 00
[    0.157993] bus: cc to node: 00
[    0.157994] bus: cd to node: 00
[    0.157995] bus: ce to node: 00
[    0.157996] bus: cf to node: 00
[    0.157997] bus: d0 to node: 00
[    0.157998] bus: d1 to node: 00
[    0.157999] bus: d2 to node: 00
[    0.158000] bus: d3 to node: 00
[    0.158001] bus: d4 to node: 00
[    0.158002] bus: d5 to node: 00
[    0.158003] bus: d6 to node: 00
[    0.158004] bus: d7 to node: 00
[    0.158005] bus: d8 to node: 00
[    0.158006] bus: d9 to node: 00
[    0.158007] bus: da to node: 00
[    0.158008] bus: db to node: 00
[    0.158009] bus: dc to node: 00
[    0.158009] bus: dd to node: 00
[    0.158010] bus: de to node: 00
[    0.158011] bus: df to node: 00
[    0.158012] bus: e0 to node: 00
[    0.158013] bus: e1 to node: 00
[    0.158014] bus: e2 to node: 00
[    0.158015] bus: e3 to node: 00
[    0.158016] bus: e4 to node: 00
[    0.158017] bus: e5 to node: 00
[    0.158018] bus: e6 to node: 00
[    0.158019] bus: e7 to node: 00
[    0.158020] bus: e8 to node: 00
[    0.158021] bus: e9 to node: 00
[    0.158022] bus: ea to node: 00
[    0.158023] bus: eb to node: 00
[    0.158024] bus: ec to node: 00
[    0.158025] bus: ed to node: 00
[    0.158026] bus: ee to node: 00
[    0.158027] bus: ef to node: 00
[    0.158028] bus: f0 to node: 00
[    0.158029] bus: f1 to node: 00
[    0.158030] bus: f2 to node: 00
[    0.158031] bus: f3 to node: 00
[    0.158032] bus: f4 to node: 00
[    0.158033] bus: f5 to node: 00
[    0.158034] bus: f6 to node: 00
[    0.158035] bus: f7 to node: 00
[    0.158036] bus: f8 to node: 00
[    0.158037] bus: f9 to node: 00
[    0.158038] bus: fa to node: 00
[    0.158039] bus: fb to node: 00
[    0.158040] bus: fc to node: 00
[    0.158041] bus: fd to node: 00
[    0.158042] bus: fe to node: 00
[    0.158043] bus: ff to node: 00
[    0.158044] bus: [00,ff] on node 0 link 0
[    0.158045] bus: 00 index 0 io port: [0, ffff]
[    0.158046] bus: 00 index 1 mmio: [80000000, fcffffffff]
[    0.158048] bus: 00 index 2 mmio: [a0000, bffff]
[    0.158052] ACPI: bus type pci registered
[    0.158101] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.158138] PCI: Not using MMCONFIG.
[    0.158173] PCI: Using configuration type 1 for base access
[    0.161005] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[    0.161155] ACPI: EC: Look up EC in DSDT
[    0.163711] Completing Region/Field/Buffer/Package initialization:................................................................................................
[    0.168891] Initialized 8/17 Regions 22/22 Fields 30/30 Buffers 36/37 Packages (751 nodes)
[    0.168975] Initializing Device/Processor/Thermal objects by executing _INI methods:..
[    0.169204] Executed 2 _INI methods requiring 0 _STA executions (examined 67 objects)
[    0.171574] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 6 Wake, Enabled 11 Runtime GPEs in this block
[    0.171690] ACPI: Interpreter enabled
[    0.171726] ACPI: (supports S0 S5)
[    0.171826] ACPI: Using IOAPIC for interrupt routing
[    0.171904] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.175196] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.181825] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.188838] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.191464] PCI: Transparent bridge - 0000:00:14.4
[    0.191524] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.191762] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.191979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.192065] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.195547] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 10 11 12 14 15)
[    0.196014] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 7 10 11 12 14 15)
[    0.196476] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *10 11 12 14 15)
[    0.196938] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
[    0.197401] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.197929] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.198434] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 *11 12 14 15)
[    0.198897] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.199471] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - FE, should be F2 [20080321]
[    0.199623] ACPI: WMI: Mapper loaded
[    0.199659] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.199717] pnp: PnP ACPI init
[    0.199754] ACPI: bus type pnp registered
[    0.203506] pnp: PnP ACPI: found 16 devices
[    0.203542] ACPI: ACPI bus type pnp unregistered
[    0.203736] SCSI subsystem initialized
[    0.203830] libata version 3.00 loaded.
[    0.203930] usbcore: registered new interface driver usbfs
[    0.204000] usbcore: registered new interface driver hub
[    0.204081] usbcore: registered new device driver usb
[    0.204359] PCI: Using ACPI for IRQ routing
[    0.209058] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.209249] hpet0: 4 32-bit timers, 14318180 Hz
[    0.210250] ACPI: RTC can wake from S4
[    0.211001] Switched to high resolution mode on CPU 0
[    0.211257] Switched to high resolution mode on CPU 1
[    0.217004] system 00:01: iomem range 0x78000000-0x7fffffff has been reserved
[    0.217047] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.217085] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.217127] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.217164] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.217201] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.217238] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.217278] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.217316] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.217352] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.217389] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.217425] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.217462] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.217499] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    0.217536] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.217572] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.217609] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    0.217646] system 00:0a: ioport range 0x800-0x89f has been reserved
[    0.217683] system 00:0a: ioport range 0xb10-0xb1f has been reserved
[    0.217720] system 00:0a: ioport range 0x900-0x90f has been reserved
[    0.217759] system 00:0a: ioport range 0x910-0x91f has been reserved
[    0.217795] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    0.217833] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.217870] system 00:0a: iomem range 0xfff80000-0xffffffff could not be reserved
[    0.217913] system 00:0d: ioport range 0x600-0x6df has been reserved
[    0.217950] system 00:0d: ioport range 0xae0-0xaef has been reserved
[    0.217997] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    0.218036] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    0.218073] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    0.218110] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    0.218147] system 00:0f: iomem range 0x100000-0x77ffffff could not be reserved
[    0.218188] system 00:0f: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.218426] PCI: Bridge: 0000:00:01.0
[    0.218462]   IO window: d000-dfff
[    0.218499]   MEM window: 0xfe900000-0xfeafffff
[    0.218536]   PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
[    0.218574] PCI: Bridge: 0000:00:07.0
[    0.218609]   IO window: e000-efff
[    0.218646]   MEM window: 0xfeb00000-0xfebfffff
[    0.218681]   PREFETCH window: disabled.
[    0.218718] PCI: Bridge: 0000:00:14.4
[    0.218753]   IO window: disabled.
[    0.218792]   MEM window: disabled.
[    0.218829]   PREFETCH window: disabled.
[    0.218882] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    0.218896] NET: Registered protocol family 2
[    0.228065] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.228710] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.231039] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.232202] TCP: Hash tables configured (established 262144 bind 65536)
[    0.232244] TCP reno registered
[    0.235061] NET: Registered protocol family 1
[    0.240697] msgmni has been set to 3768 for ipc namespace ffffffff807d29c0
[    0.240825] io scheduler noop registered
[    0.240861] io scheduler anticipatory registered
[    0.240897] io scheduler deadline registered
[    0.241037] io scheduler cfq registered (default)
[    0.326899] pci 0000:01:05.0: Boot video device
[    0.326993] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    0.327011] assign_interrupt_mode Found MSI capability
[    0.327048] Allocate Port Service[0000:00:07.0:pcie00]
[    0.327091] Allocate Port Service[0000:00:07.0:pcie03]
[    0.327238] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.327275] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.329523] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.329605] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.332352] hpet_resources: 0xfed00000 is busy
[    0.332439] Non-volatile memory driver v1.2
[    0.332541] Linux agpgart interface v0.103
[    0.332611] [drm] Initialized drm 1.1.0 20060810
[    0.333074] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 18 (level, low) -> IRQ 18
[    0.333352] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[    0.334110] uvesafb: (C) 1988-2005, ATI Technologies Inc. RS69001.00, RS69001.00, 01.00, OEM: ATI ATOMBIOS(C) 1988-2005, ATI Technologies Inc. RS69001.00, VBE v3.0
[    0.351570] uvesafb: VBIOS/hardware supports DDC2 transfers
[    0.410125] uvesafb: monitor limits: vf = 75 Hz, hf = 83 kHz, clk = 140 MHz
[    0.410313] uvesafb: scrolling: redraw
[    0.412579] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[    0.657370] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[    0.894472] Console: switching to colour frame buffer device 160x64
[    0.894532] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[    1.128483] uvesafb: framebuffer at 0xf0000000, mapped to 0xffffc20010a80000, using 16384k, total 16384k
[    1.128518] fb0: VESA VGA frame buffer device
[    1.128618] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.134078] ACPI: Power Button (FF) [PWRF]
[    1.134194] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.137083] ACPI: Power Button (CM) [PWRB]
[    1.137304] ACPI: duty_cycle spans bit 4
[    1.137386] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.137467] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.139685] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    1.140745] loop: module loaded
[    1.140893] r8169 Gigabit Ethernet driver 2.2LK loaded
[    1.140937] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[    1.140981] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    1.141001] r8169 0000:02:00.0: no MSI. Back to INTx.
[    1.141195] eth0: RTL8101e at 0xffffc20000332000, 00:19:db:86:af:87, XID 34000000 IRQ 19
[    1.142143] Linux video capture interface: v2.00
[    1.142255] pwc: Philips webcam module version 10.0.13 loaded.
[    1.142279] pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
[    1.142312] pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
[    1.142384] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
[    1.142456] usbcore: registered new interface driver Philips webcam
[    1.142512] Driver 'sd' needs updating - please use bus_type methods
[    1.142567] Driver 'sr' needs updating - please use bus_type methods
[    1.142656] ahci 0000:00:12.0: version 3.0
[    1.142671] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
[    1.142716] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    1.142741] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_PMP
[    1.863372] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.863403] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part 
[    2.001305] scsi0 : ahci
[    2.001494] scsi1 : ahci
[    2.001634] scsi2 : ahci
[    2.001770] scsi3 : ahci
[    2.001941] ata1: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff900 irq 22
[    2.001991] ata2: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff980 irq 22
[    2.002021] ata3: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa00 irq 22
[    2.002050] ata4: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa80 irq 22
[    2.123317] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.236042] ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
[    2.237071] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.238127] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    2.241139] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    2.242204] ata1.00: configured for UDMA/133
[    2.471620] ata2: SATA link down (SStatus 0 SControl 300)
[    2.678561] ata3: SATA link down (SStatus 0 SControl 300)
[    2.908585] ata4: SATA link down (SStatus 0 SControl 300)
[    2.909712] isa bounce pool size: 16 pages
[    2.910908] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[    2.912232] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.913429] sd 0:0:0:0: [sda] Write Protect is off
[    2.914622] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.914642] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.915946] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.917219] sd 0:0:0:0: [sda] Write Protect is off
[    2.918489] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.918508] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.919822]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
[    2.994805] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.996209] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.997806] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[    2.999183] PCI: Setting latency timer of device 0000:00:14.1 to 64
[    2.999245] scsi4 : pata_atiixp
[    3.000695] scsi5 : pata_atiixp
[    3.003040] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    3.004375] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    3.027907] ata5.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB05, max UDMA/33
[    3.164028] ata5.00: configured for UDMA/33
[    3.319230] scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB05 PQ: 0 ANSI: 5
[    3.325602] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.326922] Uniform CD-ROM driver Revision: 3.20
[    3.329345] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    3.329425] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    3.331309] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
[    3.333597] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    3.335003] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    3.336392] ehci_hcd 0000:00:13.5: debug port 1
[    3.337749] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe8ff000
[    3.343078] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.346370] usb usb1: configuration #1 chosen from 1 choice
[    3.347723] hub 1-0:1.0: USB hub found
[    3.349036] hub 1-0:1.0: 10 ports detected
[    3.423961] 116x: driver isp116x-hcd, 03 Nov 2005
[    3.425267] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.425277] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
[    3.426586] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.427961] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    3.429252] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe8fe000
[    3.484957] usb usb2: configuration #1 chosen from 1 choice
[    3.486272] hub 2-0:1.0: USB hub found
[    3.487568] hub 2-0:1.0: 2 ports detected
[    3.565912] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
[    3.567219] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.568565] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    3.569891] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe8fd000
[    3.575204] hub 1-0:1.0: unable to enumerate USB device on port 1
[    3.625915] usb usb3: configuration #1 chosen from 1 choice
[    3.627283] hub 3-0:1.0: USB hub found
[    3.628623] hub 3-0:1.0: 2 ports detected
[    3.713881] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.715258] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    3.716690] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    3.718091] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe8fc000
[    3.773881] usb usb4: configuration #1 chosen from 1 choice
[    3.775294] hub 4-0:1.0: USB hub found
[    3.776688] hub 4-0:1.0: 2 ports detected
[    3.782089] usb 1-9: new high speed USB device using ehci_hcd and address 3
[    3.878816] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
[    3.880243] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    3.881724] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    3.883196] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe8fb000
[    3.913242] usb 1-9: configuration #1 chosen from 1 choice
[    3.938822] usb usb5: configuration #1 chosen from 1 choice
[    3.940281] hub 5-0:1.0: USB hub found
[    3.941772] hub 5-0:1.0: 2 ports detected
[    4.032762] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -> IRQ 18
[    4.034198] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    4.035674] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    4.037112] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe8fa000
[    4.092765] usb usb6: configuration #1 chosen from 1 choice
[    4.094189] hub 6-0:1.0: USB hub found
[    4.095593] hub 6-0:1.0: 2 ports detected
[    4.103974] usb 2-1: new full speed USB device using ohci_hcd and address 2
[    4.196700] sl811: driver sl811-hcd, 19 May 2005
[    4.198116] driver u132_hcd built at 23:29:42 on May  5 2008
[    4.199565] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
[    4.200992] Initializing USB Mass Storage driver...
[    4.302713] usb 2-1: configuration #1 chosen from 1 choice
[    4.305922] pwc: Logitech QuickCam Pro 3000 USB webcam detected.
[    4.307341] pwc: Registered as /dev/video0.
[    4.521798] scsi6 : SCSI emulation for USB Mass Storage devices
[    4.523456] usb-storage: device found at 3
[    4.523458] usb-storage: waiting for device to settle before scanning
[    4.523458] usbcore: registered new interface driver usb-storage
[    4.524823] USB Mass Storage support registered.
[    4.526159] driver ftdi-elan built at 23:29:43 on May  5 2008
[    4.527637] usbcore: registered new interface driver ftdi-elan
[    4.529060] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    4.533051] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.534440] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.535899] mice: PS/2 mouse device common for all mice
[    4.562568] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    4.574486] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    4.716581] logips2pp: Detected unknown logitech mouse model 127
[    5.045189] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    5.058031] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.059424] rtc0: alarms up to one month, y3k
[    5.060823] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[    5.062374] EDAC MC: Ver: 2.1.0 May  5 2008
[    5.063928] cpuidle: using governor ladder
[    5.065289] cpuidle: using governor menu
[    5.066717] usbcore: registered new interface driver hiddev
[    5.068107] usbcore: registered new interface driver usbhid
[    5.069425] usbhid: v2.6:USB HID core driver
[    5.070764] Advanced Linux Sound Architecture Driver Version 1.0.16.
[    5.072345] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
[    5.149003] usbcore: registered new interface driver snd-usb-audio
[    5.150325] ALSA device list:
[    5.151623]   #0: HDA ATI SB at 0xfe8f4000 irq 16
[    5.152925]   #1: USB Device 0x46d:0x8b0 at usb-0000:00:13.0-1, full speed
[    5.154301] Netfilter messages via NETLINK v0.30.
[    5.155666] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.157365] TCP cubic registered
[    5.158666] Initializing XFRM netlink socket
[    5.159957] NET: Registered protocol family 17
[    5.161255] NET: Registered protocol family 15
[    5.162564] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[    5.163949] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x8
[    5.165282] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0xa
[    5.166573] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xc
[    5.167845] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xe
[    5.169119] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0x10
[    5.170371] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    5.171616] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    5.172843] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    5.225969] kjournald starting.  Commit interval 5 seconds
[    5.227212] EXT3-fs: mounted filesystem with ordered data mode.
[    5.228428] VFS: Mounted root (ext3 filesystem) readonly.
[    5.229659] Freeing unused kernel memory: 508k freed
[    5.231111] Write protecting the kernel read-only data: 5844k
[    6.652832] Clocksource tsc unstable (delta = -334133044 ns)
[    6.859537] parport_pc 00:07: reported by Plug and Play ACPI
[    6.859550] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    8.230691] usb-storage: device scan complete
[    8.230888] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    8.231758] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    8.232637] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    8.232839] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    8.239889] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    8.239915] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    8.241941] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[    8.241965] sd 6:0:0:1: Attached scsi generic sg3 type 0
[    8.243996] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[    8.244021] sd 6:0:0:2: Attached scsi generic sg4 type 0
[    8.248053] sd 6:0:0:3: [sde] Attached SCSI removable disk
[    8.248082] sd 6:0:0:3: Attached scsi generic sg5 type 0
[   18.535957] EXT3 FS on sda3, internal journal
[   18.689875] kjournald starting.  Commit interval 5 seconds
[   18.689941] EXT3 FS on sda5, internal journal
[   18.689945] EXT3-fs: mounted filesystem with ordered data mode.
[   18.702701] kjournald starting.  Commit interval 5 seconds
[   18.702761] EXT3 FS on sda6, internal journal
[   18.702763] EXT3-fs: mounted filesystem with ordered data mode.
[   18.713170] kjournald starting.  Commit interval 5 seconds
[   18.713236] EXT3 FS on sda7, internal journal
[   18.713238] EXT3-fs: mounted filesystem with ordered data mode.
[   18.723589] kjournald starting.  Commit interval 5 seconds
[   18.723682] EXT3 FS on sda8, internal journal
[   18.723684] EXT3-fs: mounted filesystem with ordered data mode.
[   18.734343] kjournald starting.  Commit interval 5 seconds
[   18.734430] EXT3 FS on sda9, internal journal
[   18.734432] EXT3-fs: mounted filesystem with ordered data mode.
[   18.743238] kjournald starting.  Commit interval 5 seconds
[   18.743308] EXT3 FS on sda10, internal journal
[   18.743311] EXT3-fs: mounted filesystem with ordered data mode.
[   18.821320] ReiserFS: sda11: found reiserfs format "3.6" with standard journal
[   18.821332] ReiserFS: sda11: using ordered data mode
[   18.824066] ReiserFS: sda11: journal params: device sda11, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   18.825379] ReiserFS: sda11: checking transaction log (sda11)
[   18.834537] ReiserFS: sda11: Using r5 hash to sort names

--------------020903080906090201040301--
