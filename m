Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbXGCXFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbXGCXFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXGCXFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:05:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbXGCXFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=flzz1ZZtrFWz50IXIVCN2Nhpp0pvw69ityZPBHkHaii8tifJKAwKdHb3jV1jQx/XlMtUIg57qBk3KlpoT5/xVYHQuE4XaoPnPXgUvFWmHAfUHy+tbYKmUAOw3fsG22h3xIF9TAIeVT6Y20X0wOKsJCt4yvmXgf3ygb/qQv9cJ2o=
Message-ID: <468AD636.2020308@googlemail.com>
Date: Wed, 04 Jul 2007 01:05:26 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: spock@gentoo.org
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH v2 0/5] uvesafb: a general description
References: <20070630163101.GA3838@spock.one.pl> <4686C187.3090308@googlemail.com>
In-Reply-To: <4686C187.3090308@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------070800010807020605010409"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800010807020605010409
Content-Type: text/plain; charset=utf8; format=flowed
Content-Transfer-Encoding: 7bit

Gabriel C wrote:
> Michal Januszewski wrote:
>   
>> uvesafb is a generic driver for VBE2+ compliant video cards; an enhanced
>> version of vesafb and a direct successor of vesafb-tng [1].
>>
>>   
>>     

[ .. ]
>> I've just tested uvesafb on my workstation ( which has a really old 
>> GeForce2 MX 400 Nvidia card ) and it didn't worked here.
>>
>> If I remember right vesafb-ntg worked here and vesafb works for sure :)
>>
>> Here the error from dmesg :
>>
>> ....
>>
>>
>> [   37.397298] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-3)
>> [   37.397358] uvesafb: vbe_init() failed with -22
>> [   37.397411] uvesafb: probe of uvesafb.0 failed with error -22
>>
>>
>> ....
>>     


Got it to work today with an 2.6.22-rc6-git4 kernel build-in and as 
module and I like it really . good work.

For some reason 2.6.22-rc6 didn't worked here it may have some bug with 
my harware or something ( anyway 2.6.22-rc6-git4 is just fine )

Dmesg from working kernel attached.


Regards,

Gabriel C

--------------070800010807020605010409
Content-Type: text/plain;
 name="dmesg_working_uvesafb.2.6.22-rc6-git4"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_working_uvesafb.2.6.22-rc6-git4"

[    0.000000] Linux version 2.6.22-rc6-git4 (root@lara) (gcc version 4.2.1 20070627 (prerelease)) #1 SMP PREEMPT Wed Jul 4 00:37:17 CEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000027f77000 (usable)
[    0.000000]  BIOS-e820: 0000000027f77000 - 0000000027f79000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000027f79000 - 0000000028000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 639MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fe710
[    0.000000] Entering add_active_range(0, 0, 163703) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   163703
[    0.000000]   HighMem    163703 ->   163703
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   163703
[    0.000000] On node 0 totalpages: 163703
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1246 pages used for memmap
[    0.000000]   Normal zone: 158361 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FD550, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT 000FD564, 0034 (r1 DELL    WS 530         8 ASL        61)
[    0.000000] ACPI: FACP 000FD598, 0074 (r1 DELL    WS 530         8 ASL        61)
[    0.000000] ACPI: DSDT FFFE3C22, 2696 (r1   DELL    dt_ex     1000 MSFT  100000D)
[    0.000000] ACPI: FACS 27F77000, 0040
[    0.000000] ACPI: SSDT FFFE635F, 0096 (r1   DELL    st_ex     1000 MSFT  100000D)
[    0.000000] ACPI: APIC 000FD60C, 006C (r1 DELL    WS 530         8 ASL        61)
[    0.000000] ACPI: BOOT 000FD678, 0028 (r1 DELL    WS 530         8 ASL        61)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] Processor #2 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3 15:2 APIC version 20
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 28000000:d6c00000)
[    0.000000] Built 1 zonelists.  Total pages: 162425
[    0.000000] Kernel command line: root=/dev/sda1 ro clocksource=acpi_pm video=uvesafb:1280x1024-32,mtrr:3,ywrap nosplashy quiet
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1994.094 MHz processor.
[   30.941323] Console: colour VGA+ 80x25
[   30.942115] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   30.943095] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   30.959793] Memory: 644668k/654812k available (2013k kernel code, 9552k reserved, 832k data, 272k init, 0k highmem)
[   30.959809] virtual kernel memory layout:
[   30.959811]     fixmap  : 0xfff50000 - 0xfffff000   ( 700 kB)
[   30.959812]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   30.959815]     vmalloc : 0xe8800000 - 0xff7fe000   ( 367 MB)
[   30.959816]     lowmem  : 0xc0000000 - 0xe7f77000   ( 639 MB)
[   30.959818]       .init : 0xc03cd000 - 0xc0411000   ( 272 kB)
[   30.959820]       .data : 0xc02f7537 - 0xc03c75bc   ( 832 kB)
[   30.959822]       .text : 0xc0100000 - 0xc02f7537   (2013 kB)
[   30.959826] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   30.959879] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[   31.019829] Calibrating delay using timer specific routine.. 3990.38 BogoMIPS (lpj=1995190)
[   31.019861] Security Framework v1.0.0 initialized
[   31.019881] Mount-cache hash table entries: 512
[   31.020051] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
[   31.020068] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   31.020072] CPU: L2 cache: 512K
[   31.020075] CPU: Physical Processor ID: 0
[   31.020078] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000
[   31.020090] Intel machine check architecture supported.
[   31.020097] Intel machine check reporting enabled on CPU#0.
[   31.020100] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[   31.020105] CPU0: Thermal monitoring enabled
[   31.020113] Compat vDSO mapped to ffffe000.
[   31.020130] Checking 'hlt' instruction... OK.
[   31.024027] Freeing SMP alternatives: 10k freed
[   31.024031] ACPI: Core revision 20070126
[   31.064834] CPU0: Intel(R) Xeon(TM) CPU 2.00GHz stepping 07
[   31.064859] Booting processor 1/1 eip 2000
[   31.075111] Initializing CPU#1
[   31.135684] Calibrating delay using timer specific routine.. 3987.34 BogoMIPS (lpj=1993670)
[   31.135697] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
[   31.135713] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   31.135717] CPU: L2 cache: 512K
[   31.135720] CPU: Physical Processor ID: 0
[   31.135724] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000
[   31.135735] Intel machine check architecture supported.
[   31.135743] Intel machine check reporting enabled on CPU#1.
[   31.135747] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
[   31.135752] CPU1: Thermal monitoring enabled
[   31.135928] CPU1: Intel(R) Xeon(TM) CPU 2.00GHz stepping 07
[   31.135969] Booting processor 2/2 eip 2000
[   31.146183] Initializing CPU#2
[   31.206596] Calibrating delay using timer specific routine.. 3987.41 BogoMIPS (lpj=1993707)
[   31.206606] CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
[   31.206619] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   31.206622] CPU: L2 cache: 512K
[   31.206625] CPU: Physical Processor ID: 3
[   31.206628] CPU: After all inits, caps: 3febfbff 00000000 00000000 0000b080 00000000 00000000 00000000
[   31.206636] Intel machine check architecture supported.
[   31.206643] Intel machine check reporting enabled on CPU#2.
[   31.206646] CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
[   31.206650] CPU2: Thermal monitoring enabled
[   31.206851] CPU2: Intel(R) XEON(TM) CPU 2.00GHz stepping 04
[   31.206872] Booting processor 3/3 eip 2000
[   31.217086] Initializing CPU#3
[   31.277508] Calibrating delay using timer specific routine.. 3987.40 BogoMIPS (lpj=1993702)
[   31.277520] CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
[   31.277536] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   31.277541] CPU: L2 cache: 512K
[   31.277544] CPU: Physical Processor ID: 3
[   31.277548] CPU: After all inits, caps: 3febfbff 00000000 00000000 0000b080 00000000 00000000 00000000
[   31.277558] Intel machine check architecture supported.
[   31.277567] Intel machine check reporting enabled on CPU#3.
[   31.277571] CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
[   31.277577] CPU3: Thermal monitoring enabled
[   31.277856] CPU3: Intel(R) XEON(TM) CPU 2.00GHz stepping 04
[   31.277915] Total of 4 processors activated (15952.53 BogoMIPS).
[   31.278065] ENABLING IO-APIC IRQs
[   31.278272] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   31.389486] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   31.409519] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[   31.429559] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[   31.449556] Brought up 4 CPUs
[   31.595953] migration_cost=127,862
[   31.596326] NET: Registered protocol family 16
[   31.596477] ACPI: bus type pci registered
[   31.596487] PCI: Using configuration type 1
[   31.596490] Setting up standard PCI resources
[   31.612621] ACPI: Interpreter enabled
[   31.612626] ACPI: Using IOAPIC for interrupt routing
[   31.651095] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   31.651121] PCI: Probing PCI hardware (bus 00)
[   31.651421] PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
[   31.651428] PCI quirk: region 0880-08bf claimed by ICH4 GPIO
[   31.652671] PCI: Transparent bridge - 0000:00:1e.0
[   31.652711] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   31.653318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[   31.653877] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[   31.654189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2.PCI3._PRT]
[   31.759770] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[   31.760141] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[   31.760498] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[   31.760859] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[   31.761218] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[   31.761576] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[   31.761935] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[   31.762297] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[   31.762497] Linux Plug and Play Support v0.97 (c) Adam Belay
[   31.762514] pnp: PnP ACPI init
[   31.762530] ACPI: bus type pnp registered
[   31.789377] pnp: PnP ACPI: found 12 devices
[   31.789382] ACPI: ACPI bus type pnp unregistered
[   31.789389] PnPBIOS: Disabled by ACPI PNP
[   31.789666] SCSI subsystem initialized
[   31.789778] PCI: Using ACPI for IRQ routing
[   31.789784] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   31.789917] NetLabel: Initializing
[   31.789921] NetLabel:  domain hash size = 128
[   31.789923] NetLabel:  protocols = UNLABELED CIPSOv4
[   31.789950] NetLabel:  unlabeled traffic allowed by default
[   31.789994] ACPI: RTC can wake from S4
[   31.790069] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   31.790074] pnp: 00:00: iomem range 0x100000-0xffffff could not be reserved
[   31.790079] pnp: 00:00: iomem range 0x1000000-0x27f76fff could not be reserved
[   31.790084] pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
[   31.790102] pnp: 00:0b: ioport range 0x800-0x85f has been reserved
[   31.790107] pnp: 00:0b: ioport range 0xc00-0xc7f has been reserved
[   31.790112] pnp: 00:0b: ioport range 0x860-0x8ff could not be reserved
[   31.790892] Time: tsc clocksource has been installed.
[   31.820636] PCI: Bridge: 0000:00:01.0
[   31.820639]   IO window: disabled.
[   31.820645]   MEM window: fc000000-fdffffff
[   31.820651]   PREFETCH window: e8000000-efffffff
[   31.820658] PCI: Bridge: 0000:02:1f.0
[   31.820663]   IO window: e000-efff
[   31.820670]   MEM window: fe400000-fe5fffff
[   31.820675]   PREFETCH window: disabled.
[   31.820682] PCI: Bridge: 0000:00:02.0
[   31.820685]   IO window: e000-efff
[   31.820691]   MEM window: fe300000-fe5fffff
[   31.820695]   PREFETCH window: disabled.
[   31.820702] PCI: Bridge: 0000:00:1e.0
[   31.820707]   IO window: d000-dfff
[   31.820714]   MEM window: fe100000-fe2fffff
[   31.820720]   PREFETCH window: 30000000-300fffff
[   31.820744] PCI: Setting latency timer of device 0000:02:1f.0 to 64
[   31.820756] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   31.820775] NET: Registered protocol family 2
[   31.820852] Time: acpi_pm clocksource has been installed.
[   31.820878] Switched to high resolution mode on CPU 0
[   31.820973] Switched to high resolution mode on CPU 1
[   31.821033] Switched to high resolution mode on CPU 2
[   31.821091] Switched to high resolution mode on CPU 3
[   31.832029] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   31.832218] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   31.834905] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[   31.835817] TCP: Hash tables configured (established 131072 bind 65536)
[   31.835825] TCP reno registered
[   31.840410] Simple Boot Flag at 0x7a set to 0x1
[   31.840494] Machine check exception polling timer started.
[   31.841297] audit: initializing netlink socket (disabled)
[   31.841315] audit(1183510137.703:1): initialized
[   31.845490] VFS: Disk quotas dquot_6.5.1
[   31.845588] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   31.846021] io scheduler noop registered
[   31.846025] io scheduler anticipatory registered
[   31.846029] io scheduler deadline registered
[   31.846055] io scheduler cfq registered (default)
[   31.846130] Boot video device is 0000:01:00.0
[   31.847346] uvesafb: NVidia Corporation, NV10 Reference Board, Chip Rev A1, OEM: NVidia, VBE v3.0
[   31.849920] uvesafb: protected mode interface info at c000:0f3c
[   31.849925] uvesafb: pmi: set display start = c00c0f75, set palette = c00c0feb
[   31.849929] uvesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
[   31.917197] uvesafb: VBIOS/hardware supports DDC2 transfers
[   31.973714] uvesafb: monitor limits: vf = 75 Hz, hf = 83 kHz, clk = 140 MHz
[   31.973850] uvesafb: scrolling: ywrap using protected mode interface, yres_virtual=3000
[   32.151279] Console: switching to colour frame buffer device 160x64
[   32.168390] uvesafb: framebuffer at 0xe8000000, mapped to 0xe8880000, using 7500k, total 65536k
[   32.168394] fb0: VESA VGA frame buffer device
[   32.168643] input: Power Button (FF) as /class/input/input0
[   32.168647] ACPI: Power Button (FF) [PWRF]
[   32.168764] input: Power Button (CM) as /class/input/input1
[   32.168774] ACPI: Power Button (CM) [VBTN]
[   32.195304] isapnp: Scanning for PnP cards...
[   32.508243] isapnp: No Plug & Play device found
[   32.512859] Intel 82802 RNG detected
[   32.512942] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   32.512946] Hangcheck: Using get_cycles().
[   32.512954] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   32.513653] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   32.513873] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   32.515235] RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
[   32.515990] ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 22 (level, low) -> IRQ 16
[   47.712259] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   47.712262]         <Adaptec aic7892 Ultra160 SCSI adapter>
[   47.712264]         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   47.712266] 
[   47.712858] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   47.714816] serio: i8042 KBD port at 0x60,0x64 irq 1
[   47.714825] serio: i8042 AUX port at 0x60,0x64 irq 12
[   47.715031] mice: PS/2 mouse device common for all mice
[   47.716630] scsi 0:0:0:0: Direct-Access     SEAGATE  ST318406LW       0109 PQ: 0 ANSI: 3
[   47.716642] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[   47.716658]  target0:0:0: Beginning Domain Validation
[   47.725702]  target0:0:0: wide asynchronous
[   47.732522]  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
[   47.743826]  target0:0:0: Ending Domain Validation
[   47.747351] input: AT Translated Set 2 keyboard as /class/input/input2
[   47.749009] scsi 0:0:1:0: Direct-Access     FUJITSU  MAH3182MP        0114 PQ: 0 ANSI: 4
[   47.749017] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[   47.749026]  target0:0:1: Beginning Domain Validation
[   47.751270]  target0:0:1: wide asynchronous
[   47.752982]  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   47.948142]  target0:0:1: Ending Domain Validation
[   48.401552] input: ImPS/2 Generic Wheel Mouse as /class/input/input3
[   48.404313] input: PC Speaker as /class/input/input4
[   48.404557] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   48.404590] rtc0: alarms up to one day
[   48.404601] i2c /dev entries driver
[   48.404818] pc87360: Device 0x0e not activated
[   48.405169] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   48.405198] Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
[   48.405364] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17
[   48.405385] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   49.015881] intel8x0_measure_ac97_clock: measured 50162 usecs
[   49.015886] intel8x0: clocking to 41129
[   49.016327] ALSA device list:
[   49.016331]   #0: Intel 82801BA-ICH2 with AD1885 at irq 17
[   49.016479] TCP cubic registered
[   49.016482] TCP hybla registered
[   49.016501] NET: Registered protocol family 1
[   49.016507] NET: Registered protocol family 17
[   49.016683] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
[   49.016697] Starting balanced_irq
[   49.016730] Using IPI Shortcut mode
[   49.017001] scsi: waiting for bus probes to complete ...
[   51.280350] sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
[   51.281463] sd 0:0:0:0: [sda] Write Protect is off
[   51.281468] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[   51.283113] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   51.283937] sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
[   51.285059] sd 0:0:0:0: [sda] Write Protect is off
[   51.285064] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[   51.286707] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   51.286712]  sda: sda1
[   51.291618] sd 0:0:0:0: [sda] Attached SCSI disk
[   51.291785] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   51.292373] sd 0:0:1:0: [sdb] 35701260 512-byte hardware sectors (18279 MB)
[   51.295226] sd 0:0:1:0: [sdb] Write Protect is off
[   51.295231] sd 0:0:1:0: [sdb] Mode Sense: ab 00 10 08
[   51.296651] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   51.297100] sd 0:0:1:0: [sdb] 35701260 512-byte hardware sectors (18279 MB)
[   51.299712] sd 0:0:1:0: [sdb] Write Protect is off
[   51.299717] sd 0:0:1:0: [sdb] Mode Sense: ab 00 10 08
[   51.301156] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   51.301162]  sdb: sdb1
[   51.309337] sd 0:0:1:0: [sdb] Attached SCSI disk
[   51.309461] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   51.309571] rtc_cmos 00:05: setting the system clock to 2007-07-04 00:49:17 (1183510157)
[   51.309576] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[   51.314626] EXT3-fs: INFO: recovery required on readonly filesystem.
[   51.314631] EXT3-fs: write access will be enabled during recovery.
[   51.339307] kjournald starting.  Commit interval 5 seconds
[   51.339328] EXT3-fs: recovery complete.
[   51.349355] EXT3-fs: mounted filesystem with ordered data mode.
[   51.349377] VFS: Mounted root (ext3 filesystem) readonly.
[   51.349767] Freeing unused kernel memory: 272k freed
[   52.760904] EXT3 FS on sda1, internal journal
[   53.766011] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
[   53.778642] Linux agpgart interface v0.102 (c) Dave Jones
[   53.792119] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   53.795139] iTCO_vendor_support: vendor-support=0
[   53.800971] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   53.801077] iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
[   53.801091] iTCO_wdt: No card detected
[   53.815620] libata version 2.21 loaded.
[   53.823126] usbcore: registered new interface driver usbfs
[   53.823175] usbcore: registered new interface driver hub
[   53.823233] usbcore: registered new device driver usb
[   53.830204] USB Universal Host Controller Interface driver v3.0
[   53.848441] agpgart: Detected an Intel i860 Chipset.
[   53.855397] agpgart: AGP aperture is 64M @ 0xf0000000
[   53.855609] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   53.858634] ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 18
[   53.858665] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   53.858675] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[   53.858920] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
[   53.858981] uhci_hcd 0000:00:1f.2: irq 18, io base 0x0000ff80
[   53.859249] usb usb1: configuration #1 chosen from 1 choice
[   53.859309] hub 1-0:1.0: USB hub found
[   53.859323] hub 1-0:1.0: 2 ports detected
[   53.865457] EDAC MC: Ver: 2.0.1 Jul  4 2007
[   53.953933] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   53.959460] ACPI: PCI Interrupt 0000:00:1f.4[C] -> GSI 23 (level, low) -> IRQ 19
[   53.959484] PCI: Setting latency timer of device 0000:00:1f.4 to 64
[   53.959491] uhci_hcd 0000:00:1f.4: UHCI Host Controller
[   53.959531] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
[   53.959569] uhci_hcd 0000:00:1f.4: irq 19, io base 0x0000ff60
[   53.959724] usb usb2: configuration #1 chosen from 1 choice
[   53.959770] hub 2-0:1.0: USB hub found
[   53.959787] hub 2-0:1.0: 2 ports detected
[   54.060344] ata_piix 0000:00:1f.1: version 2.11
[   54.060448] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   54.061863] scsi1 : ata_piix
[   54.061958] scsi2 : ata_piix
[   54.062007] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
[   54.062012] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
[   54.215381] ata1.00: ATA-7: SAMSUNG SP1203N, TL100-23, max UDMA/100
[   54.215388] ata1.00: 234493056 sectors, multi 8: LBA48 
[   54.218365] ata1.00: configured for UDMA/100
[   54.522996] ata2.00: ATAPI: 50X CD-ROM, VER 4.2B, max UDMA/33
[   54.676852] ata2.00: configured for UDMA/33
[   54.677038] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SP1203N  TL10 PQ: 0 ANSI: 5
[   54.677179] sd 1:0:0:0: [sdc] 234493056 512-byte hardware sectors (120060 MB)
[   54.677212] sd 1:0:0:0: [sdc] Write Protect is off
[   54.677218] sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   54.677270] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   54.677385] sd 1:0:0:0: [sdc] 234493056 512-byte hardware sectors (120060 MB)
[   54.677416] sd 1:0:0:0: [sdc] Write Protect is off
[   54.677422] sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   54.677471] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   54.677479]  sdc: sdc1 sdc2 sdc3 sdc4
[   54.681376] sd 1:0:0:0: [sdc] Attached SCSI disk
[   54.681461] sd 1:0:0:0: Attached scsi generic sg2 type 0
[   54.681848] scsi 2:0:0:0: CD-ROM                     50X CD-ROM       4.2B PQ: 0 ANSI: 5
[   54.681986] scsi 2:0:0:0: Attached scsi generic sg3 type 5
[   54.682468] EDAC i82860: i82860 init one
[   54.682514] ACPI: PCI Interrupt 0000:04:0f.0[A] -> GSI 19 (level, low) -> IRQ 18
[   54.682542] ohci_hcd 0000:04:0f.0: OHCI Host Controller
[   54.682639] ohci_hcd 0000:04:0f.0: new USB bus registered, assigned bus number 3
[   54.682658] EDAC MC0: Giving out device to i82860_edac i82860: DEV 0000:00:00.0
[   54.682670] ohci_hcd 0000:04:0f.0: irq 18, io mem 0xfe1fe000
[   54.741399] sr0: scsi3-mmc drive: 1x/40x cd/rw xa/form2 cdda tray
[   54.741406] Uniform CD-ROM driver Revision: 3.20
[   54.741512] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   55.243269] usb usb3: configuration #1 chosen from 1 choice
[   55.243316] hub 3-0:1.0: USB hub found
[   55.243330] hub 3-0:1.0: 3 ports detected
[   55.753736] ACPI: PCI Interrupt 0000:04:0f.1[B] -> GSI 16 (level, low) -> IRQ 20
[   55.753759] ohci_hcd 0000:04:0f.1: OHCI Host Controller
[   55.753803] ohci_hcd 0000:04:0f.1: new USB bus registered, assigned bus number 4
[   55.753828] ohci_hcd 0000:04:0f.1: irq 20, io mem 0xfe1fd000
[   56.314199] usb usb4: configuration #1 chosen from 1 choice
[   56.314239] hub 4-0:1.0: USB hub found
[   56.314253] hub 4-0:1.0: 2 ports detected
[   56.824920] ACPI: PCI Interrupt 0000:04:0b.0[A] -> GSI 23 (level, low) -> IRQ 19
[   56.824939] 3c59x: Donald Becker and others.
[   56.824947] 0000:04:0b.0: 3Com PCI 3c905C Tornado at e8834c00.
[   56.847283] ACPI: PCI Interrupt 0000:04:0f.2[C] -> GSI 17 (level, low) -> IRQ 17
[   56.847315] ehci_hcd 0000:04:0f.2: EHCI Host Controller
[   56.848620] ehci_hcd 0000:04:0f.2: new USB bus registered, assigned bus number 5
[   56.869591] ehci_hcd 0000:04:0f.2: irq 17, io mem 0xfe1ff800
[   56.869608] ehci_hcd 0000:04:0f.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
[   56.869850] usb usb5: configuration #1 chosen from 1 choice
[   56.869913] hub 5-0:1.0: USB hub found
[   56.869933] hub 5-0:1.0: 5 ports detected
[   57.187269] usb 5-2: new high speed USB device using ehci_hcd and address 2
[   57.313553] usb 5-2: configuration #1 chosen from 1 choice
[   57.330818] Adding 1951856k swap on /dev/sdc1.  Priority:-1 extents:1 across:1951856k
[   57.503666] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   57.503679] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   57.701208] Initializing USB Mass Storage driver...
[   57.701356] scsi3 : SCSI emulation for USB Mass Storage devices
[   57.701461] usb-storage: device found at 2
[   57.701466] usb-storage: waiting for device to settle before scanning
[   57.701499] usbcore: registered new interface driver usb-storage
[   57.701507] USB Mass Storage support registered.
[   57.854335] EXT3 FS on sda1, internal journal
[   62.696911] usb-storage: device scan complete
[   62.697500] scsi 3:0:0:0: Direct-Access     Maxtor 6 Y080L0           0811 PQ: 0 ANSI: 0
[   62.699110] sd 3:0:0:0: [sdd] 160086528 512-byte hardware sectors (81964 MB)
[   62.700355] sd 3:0:0:0: [sdd] Test WP failed, assume Write Enabled
[   62.700361] sd 3:0:0:0: [sdd] Assuming drive cache: write through
[   62.701480] sd 3:0:0:0: [sdd] 160086528 512-byte hardware sectors (81964 MB)
[   62.703104] sd 3:0:0:0: [sdd] Test WP failed, assume Write Enabled
[   62.703138] sd 3:0:0:0: [sdd] Assuming drive cache: write through
[   62.703152]  sdd: sdd1 sdd2 sdd3
[   62.705945] sd 3:0:0:0: [sdd] Attached SCSI disk
[   62.706037] sd 3:0:0:0: Attached scsi generic sg4 type 0
[   83.447190] kjournald starting.  Commit interval 5 seconds
[   83.455372] EXT3 FS on sdb1, internal journal
[   83.455380] EXT3-fs: mounted filesystem with ordered data mode.
[   83.485453] kjournald starting.  Commit interval 5 seconds
[   83.485671] EXT3 FS on sdc4, internal journal
[   83.485679] EXT3-fs: mounted filesystem with writeback data mode.
[   83.531413] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
[   83.532247] SGI XFS Quota Management subsystem
[   83.631945] XFS mounting filesystem sdc3
[   83.725630] Ending clean XFS mount for filesystem: sdc3
[   83.752785] kjournald starting.  Commit interval 120 seconds
[   83.752997] EXT3 FS on sdc2, internal journal
[   83.753005] EXT3-fs: mounted filesystem with writeback data mode.
[   84.098612] parport_pc 00:0a: reported by Plug and Play ACPI
[   84.098732] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,EPP,ECP]
[   84.237455] lp0: using parport0 (interrupt-driven).
[   84.237463] lp0: console ready
[   84.265257] loop: module loaded
[   84.335523] Capability LSM initialized
[   86.580363] eth0:  setting full-duplex.
[  118.511074] NET: Registered protocol family 10
[  118.511752] lo: Disabled Privacy Extensions
[  123.122881] kjournald starting.  Commit interval 5 seconds
[  123.130956] EXT3 FS on sdd1, internal journal
[  123.130980] EXT3-fs: mounted filesystem with ordered data mode.
[  123.260282] kjournald starting.  Commit interval 5 seconds
[  123.268774] EXT3 FS on sdd3, internal journal
[  123.268800] EXT3-fs: mounted filesystem with ordered data mode.
[  128.760558] eth0: no IPv6 routers present

--------------070800010807020605010409--
