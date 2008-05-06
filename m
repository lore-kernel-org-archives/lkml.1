Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYEFV44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYEFV44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYEFV4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:56:45 -0400
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:36927 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYEFV4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:56:41 -0400
Message-ID: <4820D415.5090900@numericable.fr>
Date: Tue, 06 May 2008 23:56:37 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------030508050600030404030703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030508050600030404030703
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Pallipadi, Venkatesh a =E9crit :
> =20
>
>  =20
>> -----Original Message-----
>> From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr]=20
>> Sent: Tuesday, May 06, 2008 10:32 AM
>> To: Ingo Molnar
>> Cc: Pallipadi, Venkatesh; Siddha, Suresh B; Linux-kernel Mailing List
>> Subject: Re: [2.6.25-git18 =3D> 2.6.26-rc1-git1] Xorg crash with=20
>> xf86MapVidMem error
>>
>> Ingo Molnar a =E9crit :
>>    =20
>>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>>
>>>  =20
>>>      =20
>>>> Below is the patch to enable debug messages by a boot option=20
>>>> "debugpat".
>>>>    =20
>>>>        =20
>> Hi all,
>>
>> I have applied the patch from Ingo and I put my
>> dmesg/syslog/messages/Xorg.log files in attached to help you=20
>> to identify
>> the problem (two mails).
>>
>> Hope it can help you.
>>
>>    =20
>
> Did you use "debugpat" kernel boot option after applying Ingo's patch?
> With Ingo's patch, that option is needed to print more info (Not needed=
 with one line change I sent you yday).
>
> Also, 'dmesg -s 256000' will not truncate the msg at 32K and will give =
bigger dmesg output.
>
> Thanks,
> Venki
>
>  =20
Hi,

Here is my dmesg.log file with CONFIG_X86_PAT=3Dy and debugpat kernel boo=
t=20
option.

Is it helpfull ? :-).

Regards.


--------------030508050600030404030703
Content-Type: text/plain;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.log"

4014.663547] bus: [00,ff] on node 0 link 0
[4294014.663547] bus: 00 index 0 io port: [0, ffff]
[4294014.663547] bus: 00 index 1 mmio: [80000000, fcffffffff]
[4294014.663547] bus: 00 index 2 mmio: [a0000, bffff]
[4294014.663547] ACPI: bus type pci registered
[4294014.663592] Overlap at 0x77fd0000-0x77fd5000
[4294014.663628] reserve_memtype added 0x77fd0000-0x77fd1000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.663675] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.663714] PCI: Not using MMCONFIG.
[4294014.663749] PCI: Using configuration type 1 for base access
[4294014.666546] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[4294014.666685] New Entry
[4294014.666720] reserve_memtype added 0x77fde000-0x77fdf000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.666771] ACPI: EC: Look up EC in DSDT
[4294014.667596] Overlap at 0x77fde000-0x77fdf000
[4294014.667632] reserve_memtype added 0x77fde000-0x77fdf000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.668899] New Entry
[4294014.668938] reserve_memtype added 0xe0090000-0xe0092000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.668993] New Entry
[4294014.669029] reserve_memtype added 0xfe8ff000-0xfe901000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.669854] Completing Region/Field/Buffer/Package initialization:................................................................................................
[4294014.674842] Initialized 8/17 Regions 22/22 Fields 30/30 Buffers 36/37 Packages (751 nodes)
[4294014.674917] Initializing Device/Processor/Thermal objects by executing _INI methods:<6>free_memtype request 0xe0090000-0xe0092000
[4294014.675028] New Entry
[4294014.675063] reserve_memtype added 0xe00a0000-0xe00a2000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.675126] ..
[4294014.675590] Executed 2 _INI methods requiring 0 _STA executions (examined 67 objects)
[4294014.675690] free_memtype request 0x77fde000-0x77fdf000
[4294014.675729] Overlap at 0x77fde000-0x77fdf000
[4294014.675765] reserve_memtype added 0x77fde000-0x77fdf000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.677976] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 6 Wake, Enabled 11 Runtime GPEs in this block
[4294014.678092] ACPI: Interpreter enabled
[4294014.678127] ACPI: (supports S0 S5)
[4294014.678226] ACPI: Using IOAPIC for interrupt routing
[4294014.678305] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.681514] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[4294014.682497] Overlap at 0xe00a0000-0xe00a2000
[4294014.682534] reserve_memtype added 0xe0000000-0xf0000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.688313] PCI: Using MMCONFIG at e0000000 - efffffff
[4294014.696229] ACPI: PCI Root Bridge [PCI0] (0000:00)
[4294014.699211] PCI: Transparent bridge - 0000:00:14.4
[4294014.699229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[4294014.699229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[4294014.699229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[4294014.699229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[4294014.703228] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 10 11 12 14 15)
[4294014.703228] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 7 10 11 12 14 15)
[4294014.703689] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *10 11 12 14 15)
[4294014.704228] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
[4294014.704308] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[4294014.705228] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[4294014.705752] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 *11 12 14 15)
[4294014.706228] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[4294014.706720] Overlap at 0x77fd0000-0x77fd1000
[4294014.706758] reserve_memtype added 0x77fd0000-0x77fd1000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.706811] Overlap at 0x77fd0000-0x77fd1000
[4294014.706847] reserve_memtype added 0x77fd0000-0x77fd1000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.706897] Overlap at 0x77fde000-0x77fdf000
[4294014.706933] reserve_memtype added 0x77fde000-0x77fdf000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.706981] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - FE, should be F2 [20080321]
[4294014.707583] Overlap at 0x77fd0000-0x77fd5000
[4294014.707619] reserve_memtype added 0x77fd4000-0x77fd5000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.708003] ACPI: WMI: Mapper loaded
[4294014.708038] Linux Plug and Play Support v0.97 (c) Adam Belay
[4294014.708216] pnp: PnP ACPI init
[4294014.708216] ACPI: bus type pnp registered
[4294014.712216] pnp: PnP ACPI: found 16 devices
[4294014.712216] ACPI: ACPI bus type pnp unregistered
[4294014.712216] SCSI subsystem initialized
[4294014.712216] libata version 3.00 loaded.
[4294014.712216] usbcore: registered new interface driver usbfs
[4294014.712216] usbcore: registered new interface driver hub
[4294014.713216] usbcore: registered new device driver usb
[4294014.713216] PCI: Using ACPI for IRQ routing
[4294014.717545] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[4294014.717545] hpet0: 4 32-bit timers, 14318180 Hz
[4294014.718545] ACPI: RTC can wake from S4
[4294014.718928] Switched to high resolution mode on CPU 0
[4294014.719892] Switched to high resolution mode on CPU 1
[4294014.723965] system 00:01: iomem range 0x78000000-0x7fffffff has been reserved
[4294014.724011] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[4294014.724051] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[4294014.724097] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[4294014.724134] system 00:0a: ioport range 0x40b-0x40b has been reserved
[4294014.724171] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[4294014.724882] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[4294014.724919] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[4294014.724955] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[4294014.724992] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[4294014.725029] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[4294014.725066] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[4294014.725103] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[4294014.725139] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[4294014.725176] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[4294014.725213] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[4294014.725222] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[4294014.725222] system 00:0a: ioport range 0x800-0x89f has been reserved
[4294014.725222] system 00:0a: ioport range 0xb10-0xb1f has been reserved
[4294014.725222] system 00:0a: ioport range 0x900-0x90f has been reserved
[4294014.725222] system 00:0a: ioport range 0x910-0x91f has been reserved
[4294014.725222] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[4294014.725222] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[4294014.725222] system 00:0a: iomem range 0xfff80000-0xffffffff could not be reserved
[4294014.725222] system 00:0d: ioport range 0x600-0x6df has been reserved
[4294014.725266] system 00:0d: ioport range 0xae0-0xaef has been reserved
[4294014.725306] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[4294014.725348] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[4294014.725880] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[4294014.725918] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[4294014.725954] system 00:0f: iomem range 0x100000-0x77ffffff could not be reserved
[4294014.725995] system 00:0f: iomem range 0xfec00000-0xffffffff could not be reserved
[4294014.726261] PCI: Bridge: 0000:00:01.0
[4294014.726298]   IO window: d000-dfff
[4294014.726335]   MEM window: 0xfe900000-0xfeafffff
[4294014.726372]   PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
[4294014.726411] PCI: Bridge: 0000:00:07.0
[4294014.726447]   IO window: e000-efff
[4294014.726484]   MEM window: 0xfeb00000-0xfebfffff
[4294014.726523]   PREFETCH window: disabled.
[4294014.727098] PCI: Bridge: 0000:00:14.4
[4294014.727134]   IO window: disabled.
[4294014.727174]   MEM window: disabled.
[4294014.727212]   PREFETCH window: disabled.
[4294014.727267] PCI: Setting latency timer of device 0000:00:07.0 to 64
[4294014.727282] NET: Registered protocol family 2
[4294014.737854] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[4294014.738513] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[4294014.740849] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[4294014.742271] TCP: Hash tables configured (established 262144 bind 65536)
[4294014.742312] TCP reno registered
[4294014.744836] NET: Registered protocol family 1
[4294014.750760] msgmni has been set to 3768 for ipc namespace ffffffff807d29c0
[4294014.750760] io scheduler noop registered
[4294014.750760] io scheduler anticipatory registered
[4294014.750760] io scheduler deadline registered
[4294014.750760] io scheduler cfq registered (default)
[4294014.750760] New Entry
[4294014.750803] reserve_memtype added 0xfe8fe000-0xfe8ff000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.771771] free_memtype request 0xfe8fe000-0xfe8ff000
[4294014.771819] New Entry
[4294014.771855] reserve_memtype added 0xfe8fd000-0xfe8fe000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.792769] free_memtype request 0xfe8fd000-0xfe8fe000
[4294014.792816] New Entry
[4294014.792851] reserve_memtype added 0xfe8fc000-0xfe8fd000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.804391] free_memtype request 0xfe8fc000-0xfe8fd000
[4294014.804435] New Entry
[4294014.804471] reserve_memtype added 0xfe8fb000-0xfe8fc000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.815486] free_memtype request 0xfe8fb000-0xfe8fc000
[4294014.815531] New Entry
[4294014.815567] reserve_memtype added 0xfe8fa000-0xfe8fb000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.840245] free_memtype request 0xfe8fa000-0xfe8fb000
[4294014.840289] Overlap at 0xfe8ff000-0xfe901000
[4294014.840326] reserve_memtype added 0xfe8ff000-0xfe900000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.840376] free_memtype request 0xfe8ff000-0xfe900000
[4294014.840425] pci 0000:01:05.0: Boot video device
[4294014.840608] PCI: Setting latency timer of device 0000:00:07.0 to 64
[4294014.840608] assign_interrupt_mode Found MSI capability
[4294014.840608] Allocate Port Service[0000:00:07.0:pcie00]
[4294014.840608] Allocate Port Service[0000:00:07.0:pcie03]
[4294014.840608] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[4294014.840608] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[4294014.843485] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[4294014.843485] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[4294014.846497] New Entry
[4294014.846497] reserve_memtype added 0xfed00000-0xfed01000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.846497] hpet_resources: 0xfed00000 is busy
[4294014.846497] free_memtype request 0xfed00000-0xfed01000
[4294014.846497] Non-volatile memory driver v1.2
[4294014.846497] Linux agpgart interface v0.103
[4294014.847517] [drm] Initialized drm 1.1.0 20060810
[4294014.847898] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 18 (level, low) -> IRQ 18
[4294014.847898] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[4294014.848486] New Entry
[4294014.848486] reserve_memtype added 0x0-0x1000, track write-back, req write-back, ret write-back
[4294014.848585] uvesafb: (C) 1988-2005, ATI Technologies Inc. RS69001.00, RS69001.00, 01.00, OEM: ATI ATOMBIOS(C) 1988-2005, ATI Technologies Inc. RS69001.00, VBE v3.0
[4294014.865942] uvesafb: VBIOS/hardware supports DDC2 transfers
[4294014.924035] uvesafb: monitor limits: vf = 75 Hz, hf = 83 kHz, clk = 140 MHz
[4294014.924168] uvesafb: scrolling: redraw
[4294014.924267] New Entry
[4294014.924303] reserve_memtype added 0xf0000000-0xf1000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.926629] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294015.177558] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294015.414633] Console: switching to colour frame buffer device 160x64
[4294015.414687] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294015.649340] uvesafb: framebuffer at 0xf0000000, mapped to 0xffffc20010a80000, using 16384k, total 16384k
[4294015.649340] fb0: VESA VGA frame buffer device
[4294015.649340] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[4294015.654897] ACPI: Power Button (FF) [PWRF]
[4294015.655340] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[4294015.660202] ACPI: Power Button (CM) [PWRB]
[4294015.660339] ACPI: duty_cycle spans bit 4
[4294015.660339] ACPI: ACPI0007:00 is registered as cooling_device0
[4294015.660339] ACPI: ACPI0007:01 is registered as cooling_device1
[4294015.662338] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[4294015.663338] loop: module loaded
[4294015.663349] r8169 Gigabit Ethernet driver 2.2LK loaded
[4294015.663349] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[4294015.663349] PCI: Setting latency timer of device 0000:02:00.0 to 64
[4294015.663349] New Entry
[4294015.663349] reserve_memtype added 0xfebff000-0xfec00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294015.663368] r8169 0000:02:00.0: no MSI. Back to INTx.
[4294015.664056] eth0: RTL8101e at 0xffffc20000332000, 00:19:db:86:af:87, XID 34000000 IRQ 19
[4294015.665481] Linux video capture interface: v2.00
[4294015.665481] pwc: Philips webcam module version 10.0.13 loaded.
[4294015.665481] pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
[4294015.665481] pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
[4294015.665481] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
[4294015.665481] usbcore: registered new interface driver Philips webcam
[4294015.665481] Driver 'sd' needs updating - please use bus_type methods
[4294015.665481] Driver 'sr' needs updating - please use bus_type methods
[4294015.665481] ahci 0000:00:12.0: version 3.0
[4294015.665481] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
[4294015.665481] Overlap at 0xfe8ff000-0xfe901000
[4294015.665481] reserve_memtype added 0xfe8ff000-0xfe900000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294015.665536] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[4294015.665536] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_PMP
[4294016.666442] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[4294016.666473] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part 
[4294016.667643] scsi0 : ahci
[4294016.667643] scsi1 : ahci
[4294016.667643] scsi2 : ahci
[4294016.667643] scsi3 : ahci
[4294016.669202] ata1: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff900 irq 22
[4294016.670278] ata2: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff980 irq 22
[4294016.671349] ata3: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa00 irq 22
[4294016.672425] ata4: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa80 irq 22
[4294016.978122] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[4294016.997674] ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
[4294016.999042] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[4294017.001046] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[4294017.004056] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[4294017.004460] ata1.00: configured for UDMA/133
[4294017.310215] ata2: SATA link down (SStatus 0 SControl 300)
[4294017.616215] ata3: SATA link down (SStatus 0 SControl 300)
[4294017.922215] ata4: SATA link down (SStatus 0 SControl 300)
[4294017.924065] isa bounce pool size: 16 pages
[4294017.925353] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[4294017.927604] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[4294017.928899] sd 0:0:0:0: [sda] Write Protect is off
[4294017.930051] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.930072] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.931401] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[4294017.932732] sd 0:0:0:0: [sda] Write Protect is off
[4294017.934056] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.934076] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.935408]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
[4294018.010047] sd 0:0:0:0: [sda] Attached SCSI disk
[4294018.011722] sd 0:0:0:0: Attached scsi generic sg0 type 0
[4294018.013115] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[4294018.014571] PCI: Setting latency timer of device 0000:00:14.1 to 64
[4294018.014974] scsi4 : pata_atiixp
[4294018.016471] scsi5 : pata_atiixp
[4294018.018539] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[4294018.019542] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[4294018.175004] ata5.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB05, max UDMA/33
[4294018.186490] ata5.00: configured for UDMA/33
[4294018.339936] scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB05 PQ: 0 ANSI: 5
[4294018.347355] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[4294018.349575] Uniform CD-ROM driver Revision: 3.20
[4294018.351908] sr 4:0:0:0: Attached scsi CD-ROM sr0
[4294018.351924] sr 4:0:0:0: Attached scsi generic sg1 type 5
[4294018.353432] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
[4294018.354440] Overlap at 0xfe8ff000-0xfe900000
[4294018.356203] reserve_memtype added 0xfe8ff000-0xfe900000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294018.357539] ehci_hcd 0000:00:13.5: EHCI Host Controller
[4294018.359196] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[4294018.360551] ehci_hcd 0000:00:13.5: debug port 1
[4294018.361595] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe8ff000
[4294018.367714] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[4294018.369756] usb usb1: configuration #1 chosen from 1 choice
[4294018.371227] hub 1-0:1.0: USB hub found
[4294018.372513] hub 1-0:1.0: 10 ports detected
[4294018.474460] 116x: driver isp116x-hcd, 03 Nov 2005
[4294018.475844] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[4294018.475844] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
[4294018.476849] New Entry
[4294018.478200] reserve_memtype added 0xfe8fe000-0xfe8ff000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294018.480041] ohci_hcd 0000:00:13.0: OHCI Host Controller
[4294018.481646] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[4294018.482664] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe8fe000
[4294018.539968] usb usb2: configuration #1 chosen from 1 choice
[4294018.541071] hub 2-0:1.0: USB hub found
[4294018.542167] hub 2-0:1.0: 2 ports detected
[4294018.644720] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
[4294018.645726] New Entry
[4294018.647083] reserve_memtype added 0xfe8fd000-0xfe8fe000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294018.648489] ohci_hcd 0000:00:13.1: OHCI Host Controller
[4294018.650479] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[4294018.651919] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe8fd000
[4294018.681535] hub 1-0:1.0: unable to enumerate USB device on port 1
[4294018.708519] usb usb3: configuration #1 chosen from 1 choice
[4294018.709835] hub 3-0:1.0: USB hub found
[4294018.711279] hub 3-0:1.0: 2 ports detected
[4294018.813271] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 18
[4294018.814279] New Entry
[4294018.815742] reserve_memtype added 0xfe8fc000-0xfe8fd000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294018.817273] ohci_hcd 0000:00:13.2: OHCI Host Controller
[4294018.818910] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[4294018.820752] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe8fc000
[4294018.878289] usb usb4: configuration #1 chosen from 1 choice
[4294018.879688] hub 4-0:1.0: USB hub found
[4294018.881215] hub 4-0:1.0: 2 ports detected
[4294018.889052] usb 1-9: new high speed USB device using ehci_hcd and address 3
[4294018.983356] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
[4294018.984361] New Entry
[4294018.985950] reserve_memtype added 0xfe8fb000-0xfe8fc000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294018.987479] ohci_hcd 0000:00:13.3: OHCI Host Controller
[4294018.989574] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[4294018.990634] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe8fb000
[4294019.005941] usb 1-9: configuration #1 chosen from 1 choice
[4294019.047931] usb usb5: configuration #1 chosen from 1 choice
[4294019.049320] hub 5-0:1.0: USB hub found
[4294019.050846] hub 5-0:1.0: 2 ports detected
[4294019.152683] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -> IRQ 18
[4294019.153688] New Entry
[4294019.155279] reserve_memtype added 0xfe8fa000-0xfe8fb000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294019.156999] ohci_hcd 0000:00:13.4: OHCI Host Controller
[4294019.159106] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[4294019.160132] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe8fa000
[4294019.217535] usb usb6: configuration #1 chosen from 1 choice
[4294019.218952] hub 6-0:1.0: USB hub found
[4294019.220492] hub 6-0:1.0: 2 ports detected
[4294019.226294] usb 2-1: new full speed USB device using ohci_hcd and address 2
[4294019.322287] sl811: driver sl811-hcd, 19 May 2005
[4294019.323877] driver u132_hcd built at 23:31:24 on May  6 2008
[4294019.325420] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
[4294019.327429] Initializing USB Mass Storage driver...
[4294019.431737] usb 2-1: configuration #1 chosen from 1 choice
[4294019.435878] pwc: Logitech QuickCam Pro 3000 USB webcam detected.
[4294019.438118] pwc: Registered as /dev/video0.
[4294019.711806] scsi6 : SCSI emulation for USB Mass Storage devices
[4294019.712806] usb-storage: device found at 3
[4294019.712806] usb-storage: waiting for device to settle before scanning
[4294019.713404] usbcore: registered new interface driver usb-storage
[4294019.714896] USB Mass Storage support registered.
[4294019.716064] driver ftdi-elan built at 23:31:26 on May  6 2008
[4294019.718018] usbcore: registered new interface driver ftdi-elan
[4294019.719592] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[4294019.722853] serio: i8042 KBD port at 0x60,0x64 irq 1
[4294019.724307] serio: i8042 AUX port at 0x60,0x64 irq 12
[4294019.726392] mice: PS/2 mouse device common for all mice
[4294019.744858] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[4294019.761106] input: PC Speaker as /devices/platform/pcspkr/input/input3
[4294019.894548] logips2pp: Detected unknown logitech mouse model 127
[4294020.361539] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[4294020.373540] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[4294020.374811] rtc0: alarms up to one month, y3k
[4294020.377214] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[4294020.378674] EDAC MC: Ver: 2.1.0 May  6 2008
[4294020.380263] cpuidle: using governor ladder
[4294020.381670] cpuidle: using governor menu
[4294020.383252] usbcore: registered new interface driver hiddev
[4294020.384717] usbcore: registered new interface driver usbhid
[4294020.385721] usbhid: v2.6:USB HID core driver
[4294020.387491] Advanced Linux Sound Architecture Driver Version 1.0.16.
[4294020.388892] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
[4294020.389905] New Entry
[4294020.391900] reserve_memtype added 0xfe8f4000-0xfe8f8000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294020.469275] usbcore: registered new interface driver snd-usb-audio
[4294020.470288] ALSA device list:
[4294020.471788]   #0: HDA ATI SB at 0xfe8f4000 irq 16
[4294020.473278]   #1: USB Device 0x46d:0x8b0 at usb-0000:00:13.0-1, full speed
[4294020.474718] Netfilter messages via NETLINK v0.30.
[4294020.476152] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[4294020.477911] TCP cubic registered
[4294020.479255] Initializing XFRM netlink socket
[4294020.480590] NET: Registered protocol family 17
[4294020.482009] NET: Registered protocol family 15
[4294020.483615] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[4294020.484615] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x8
[4294020.485828] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0xa
[4294020.487827] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xc
[4294020.489147] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xe
[4294020.490460] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0x10
[4294020.491807] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[4294020.493080] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[4294020.494319] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[4294020.541719] kjournald starting.  Commit interval 5 seconds
[4294020.543854] EXT3-fs: mounted filesystem with ordered data mode.
[4294020.545086] VFS: Mounted root (ext3 filesystem) readonly.
[4294020.546307] Freeing unused kernel memory: 508k freed
[4294020.548517] Write protecting the kernel read-only data: 5844k
[4294022.066367] Clocksource tsc unstable (delta = -333999701 ns)
[4294022.515645] parport_pc 00:07: reported by Plug and Play ACPI
[4294022.515657] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[4294024.747663] usb-storage: device scan complete
[4294024.747683] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[4294024.748665] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[4294024.748681] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[4294024.749667] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[4294024.751780] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[4294024.751780] sd 6:0:0:0: Attached scsi generic sg2 type 0
[4294024.752734] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[4294024.752734] sd 6:0:0:1: Attached scsi generic sg3 type 0
[4294024.753735] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[4294024.753735] sd 6:0:0:2: Attached scsi generic sg4 type 0
[4294024.754747] sd 6:0:0:3: [sde] Attached SCSI removable disk
[4294024.754770] sd 6:0:0:3: Attached scsi generic sg5 type 0
[4294051.744523] EXT3 FS on sda3, internal journal
[4294051.885513] kjournald starting.  Commit interval 5 seconds
[4294051.885513] EXT3 FS on sda5, internal journal
[4294051.885513] EXT3-fs: mounted filesystem with ordered data mode.
[4294051.970510] kjournald starting.  Commit interval 5 seconds
[4294051.968502] EXT3 FS on sda6, internal journal
[4294051.968502] EXT3-fs: mounted filesystem with ordered data mode.
[4294051.997259] kjournald starting.  Commit interval 5 seconds
[4294051.997264] EXT3 FS on sda7, internal journal
[4294051.997264] EXT3-fs: mounted filesystem with ordered data mode.
[4294052.023995] kjournald starting.  Commit interval 5 seconds
[4294052.023995] EXT3 FS on sda8, internal journal
[4294052.023995] EXT3-fs: mounted filesystem with ordered data mode.
[4294052.035519] kjournald starting.  Commit interval 5 seconds
[4294052.035519] EXT3 FS on sda9, internal journal
[4294052.035519] EXT3-fs: mounted filesystem with ordered data mode.
[4294052.057525] kjournald starting.  Commit interval 5 seconds
[4294052.057525] EXT3 FS on sda10, internal journal
[4294052.057525] EXT3-fs: mounted filesystem with ordered data mode.
[4294052.148520] ReiserFS: sda11: found reiserfs format "3.6" with standard journal
[4294052.148520] ReiserFS: sda11: using ordered data mode
[4294052.151520] ReiserFS: sda11: journal params: device sda11, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[4294052.159791] ReiserFS: sda11: checking transaction log (sda11)
[4294052.169541] ReiserFS: sda11: Using r5 hash to sort names
[4294053.445442] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294054.818944] r8169: eth0: link up
[4294054.819004] r8169: eth0: link up
[4294057.366623] Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
[4294064.014047] New Entry
[4294064.014052] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294064.190933] ip_tables: (C) 2000-2006 Netfilter Core Team
[4294064.248169] free_memtype request 0xfeaf0000-0xfeb00000
[4294064.249233] New Entry
[4294064.249235] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294065.575420] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294065.899378] free_memtype request 0xfeaf0000-0xfeb00000
[4294067.515182] ctnetlink v0.93: registering with nfnetlink.
[4294067.624256] ClusterIP Version 0.8 loaded successfully
[4294070.337147] New Entry
[4294070.337150] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294070.393934] free_memtype request 0xfeaf0000-0xfeb00000
[4294070.395162] New Entry
[4294070.395165] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294071.752279] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294072.085279] free_memtype request 0xfeaf0000-0xfeb00000
[4294076.532310] New Entry
[4294076.532316] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294076.587640] free_memtype request 0xfeaf0000-0xfeb00000
[4294076.589519] New Entry
[4294076.589523] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294077.913589] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294078.233589] free_memtype request 0xfeaf0000-0xfeb00000
[4294081.669129] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.

--------------030508050600030404030703--
