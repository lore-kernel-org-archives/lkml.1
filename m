Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYGQQt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYGQQt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYGQQtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:49:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:31485 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbYGQQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hFBpQNvwauxrHz92WeVave0zVcWvxRVKFmj+xVvCAtYS6XvyBe1orT7qWhSPvc2Jvi
         /tfV95OgrXROGMA1/G7McuOqQ4g7xL0Xa7rrdJsE7h5LYHrBqI2yQaHRMfUyM1+X7Mfp
         d7iYkiWnHchNVvjMjEKHMyZx6fCb6RCyBegEY=
Message-ID: <487F85C6.9@gmail.com>
Date: Thu, 17 Jul 2008 17:47:50 +0000
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
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de> <487F33F2.2060202@gmail.com> <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de> <487F39AC.3060805@gmail.com> <alpine.LFD.1.10.0807171400090.4316@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807171400090.4316@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 17 Jul 2008, Richard wrote:
>   
>> Prepare to be spammed.... I am using a Sabayon build, but all distros I have
>> tried exibit the same behavior to me. the nohz=off options also works quite
>> well. (I have a 2.6.26 vanilla that behaves the same)
>>
>> but for now, I am off to read and setup the netconsole.
>>     
>
> Thanks for the boot log. That looks familiar:
>
>   
>> Jul 14 11:12:23 localhost [ 0.098984] ..MP-BIOS bug: 8254 timer not connected
>> to IO-APIC
>>     
>
> We have a fix for that in Linus tree. Any chance to give current
> mainline a test ride ?
>
> Thanks,
>
> 	tglx
>
>   

Here you go.. a 2.6.26-tip dmesg  (the top seems to be missing for some 
reason!) .. just shout if you need the bits on the top.


Richard



n DSDT
[    0.074620] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.338551] ACPI: Interpreter enabled
[    0.338594] ACPI: (supports S0 S3 S4 S5)
[    0.338762] ACPI: Using IOAPIC for interrupt routing
[    0.349915] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.349980] ACPI: EC: driver started in interrupt mode
[    0.350114] ACPI: PCI Root Bridge [C08B] (0000:00)
[    0.350352] PCI: 0000:00:12.0 reg 10 io port: [9000, 9007]
[    0.350395] PCI: 0000:00:12.0 reg 14 io port: [9008, 900b]
[    0.350438] PCI: 0000:00:12.0 reg 18 io port: [9010, 9017]
[    0.350481] PCI: 0000:00:12.0 reg 1c io port: [5018, 501b]
[    0.350524] PCI: 0000:00:12.0 reg 20 io port: [5020, 502f]
[    0.350568] PCI: 0000:00:12.0 reg 24 32bit mmio: [d0609000, d06093ff]
[    0.350627] pci 0000:00:12.0: set SATA to AHCI mode
[    0.350682] PCI: 0000:00:13.0 reg 10 32bit mmio: [d0601000, d0601fff]
[    0.350771] PCI: 0000:00:13.1 reg 10 32bit mmio: [d0602000, d0602fff]
[    0.350860] PCI: 0000:00:13.2 reg 10 32bit mmio: [d0603000, d0603fff]
[    0.350953] PCI: 0000:00:13.3 reg 10 32bit mmio: [d0604000, d0604fff]
[    0.351043] PCI: 0000:00:13.4 reg 10 32bit mmio: [d0605000, d0605fff]
[    0.351152] PCI: 0000:00:13.5 reg 10 32bit mmio: [d0606000, d06060ff]
[    0.351260] PCI: 0000:00:14.0 reg 10 io port: [8200, 820f]
[    0.351352] PCI: 0000:00:14.1 reg 10 io port: [0, 7]
[    0.351395] PCI: 0000:00:14.1 reg 14 io port: [0, 3]
[    0.351439] PCI: 0000:00:14.1 reg 18 io port: [0, 7]
[    0.351482] PCI: 0000:00:14.1 reg 1c io port: [0, 3]
[    0.351526] PCI: 0000:00:14.1 reg 20 io port: [5040, 504f]
[    0.351617] PCI: 0000:00:14.2 reg 10 64bit mmio: [d0608000, d060bfff]
[    0.351856] PCI: 0000:01:05.0 reg 10 64bit mmio: [c0000000, c7ffffff]
[    0.351898] PCI: 0000:01:05.0 reg 18 64bit mmio: [d0400000, d040ffff]
[    0.351939] PCI: 0000:01:05.0 reg 20 io port: [4000, 40ff]
[    0.352018] PCI: 0000:01:05.0 reg 24 32bit mmio: [d0500000, d05fffff]
[    0.352074] PCI: bridge 0000:00:01.0 io port: [4000, 4fff]
[    0.352112] PCI: bridge 0000:00:01.0 32bit mmio: [d0400000, d05fffff]
[    0.352151] PCI: bridge 0000:00:01.0 64bit mmio pref: [c0000000, 
c7ffffff]
[    0.352272] PCI: 0000:10:00.0 reg 10 64bit mmio: [d0000000, d000ffff]
[    0.352384] PCI: bridge 0000:00:04.0 32bit mmio: [d0000000, d00fffff]
[    0.352464] PCI: bridge 0000:00:05.0 io port: [2000, 3fff]
[    0.352502] PCI: bridge 0000:00:05.0 32bit mmio: [cc000000, cfffffff]
[    0.352582] PCI: 0000:30:00.0 reg 10 64bit mmio: [c8000000, c8003fff]
[    0.352696] PCI: bridge 0000:00:06.0 32bit mmio: [c8000000, c80fffff]
[    0.352783] PCI: 0000:02:04.0 reg 10 32bit mmio: [d0100000, d0100fff]
[    0.352864] PCI: 0000:02:04.1 reg 10 32bit mmio: [d0101000, d01017ff]
[    0.353004] PCI: Transparent bridge - 0000:00:14.4
[    0.354945] PCI: bridge 0000:00:14.4 32bit mmio: [d0100000, d03fffff]
[    0.354945] ACPI: PCI Interrupt Routing Table [\_SB_.C08B._PRT]
[    0.354945] ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C08C._PRT]
[    0.354945] ACPI: PCI Interrupt Routing Table [\_SB_.C08B.C0FC._PRT]
[    0.377286] ACPI: PCI Interrupt Link [C145] (IRQs 10 11) *0, disabled.
[    0.377681] ACPI: PCI Interrupt Link [C146] (IRQs 10 11) *0, disabled.
[    0.378076] ACPI: PCI Interrupt Link [C147] (IRQs 10 11) *0, disabled.
[    0.378466] ACPI: PCI Interrupt Link [C148] (IRQs 10 11) *0, disabled.
[    0.378855] ACPI: PCI Interrupt Link [C149] (IRQs 10 11) *0, disabled.
[    0.379263] ACPI: PCI Interrupt Link [C14A] (IRQs 9) *0, disabled.
[    0.379617] ACPI: PCI Interrupt Link [C14B] (IRQs 10 11) *0, disabled.
[    0.380005] ACPI: PCI Interrupt Link [C14C] (IRQs 10 11) *0, disabled.
[    0.380399] ACPI: Power Resource [C171] (off)
[    0.380637] ACPI: Power Resource [C230] (off)
[    0.380727] ACPI: Power Resource [C24C] (on)
[    0.380894] ACPI: Power Resource [C395] (off)
[    0.381032] ACPI: Power Resource [C396] (off)
[    0.381163] ACPI: Power Resource [C397] (off)
[    0.381294] ACPI: Power Resource [C398] (off)
[    0.381629] ACPI: WMI: Mapper loaded
[    0.381671] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.381743] pnp: PnP ACPI init
[    0.381790] ACPI: bus type pnp registered
[    0.392418] pnp: PnP ACPI: found 14 devices
[    0.392463] ACPI: ACPI bus type pnp unregistered
[    0.392750] SCSI subsystem initialized
[    0.392820] libata version 3.00 loaded.
[    0.393028] usbcore: registered new interface driver usbfs
[    0.393133] usbcore: registered new interface driver hub
[    0.393214] usbcore: registered new device driver usb
[    0.393470] PCI: Using ACPI for IRQ routing
[    0.393549] PCI: Cannot allocate resource region 0 of device 0000:00:14.2
[    0.398952] NetLabel: Initializing
[    0.398994] NetLabel:  domain hash size = 128
[    0.399030] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.399083] NetLabel:  unlabeled traffic allowed by default
[    0.399252] ACPI: RTC can wake from S4
[    0.401956] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.401999] system 00:00: iomem range 0xe0000-0xfffff could not be 
reserved
[    0.402038] system 00:00: iomem range 0x100000-0xffffffff could not 
be reserved
[    0.402092] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.402130] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.402168] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.402207] system 00:0a: ioport range 0x500-0x51f has been reserved
[    0.402245] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.402283] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.402322] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.402360] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.402399] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.402437] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.402476] system 00:0a: ioport range 0xcd0-0xcdf has been reserved
[    0.402516] system 00:0a: iomem range 0xffb00000-0xffbfffff could not 
be reserved
[    0.402559] system 00:0a: iomem range 0xfff00000-0xffffffff could not 
be reserved
[    0.402607] system 00:0c: ioport range 0x8000-0x802f has been reserved
[    0.402645] system 00:0c: ioport range 0x8100-0x811f has been reserved
[    0.402685] system 00:0c: iomem range 0xe0000000-0xefffffff could not 
be reserved
[    0.402727] system 00:0c: iomem range 0xfec00000-0xfec000ff could not 
be reserved
[    0.402770] system 00:0c: iomem range 0xfed45000-0xfed8ffff has been 
reserved
[    0.402816] system 00:0d: iomem range 0xcd400-0xcffff has been reserved
[    0.402856] system 00:0d: iomem range 0xd2a00-0xd2fff has been reserved
[    0.402894] system 00:0d: iomem range 0x0-0x7ffffff could not be reserved
[    0.402933] system 00:0d: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.403431] PCI: region 0000:02:04.0/9 too large: 
0x0000000000000000-0x0000000003ffffff
[    0.403487] PCI: Bridge: 0000:00:01.0
[    0.403523]   IO window: 4000-4fff
[    0.403560]   MEM window: 0xd0400000-0xd05fffff
[    0.403597]   PREFETCH window: 0x00000000c0000000-0x00000000c7ffffff
[    0.403636] PCI: Bridge: 0000:00:04.0
[    0.403671]   IO window: disabled.
[    0.403708]   MEM window: 0xd0000000-0xd00fffff
[    0.403744]   PREFETCH window: disabled.
[    0.403781] PCI: Bridge: 0000:00:05.0
[    0.403817]   IO window: 2000-3fff
[    0.403853]   MEM window: 0xcc000000-0xcfffffff
[    0.403890]   PREFETCH window: disabled.
[    0.403948] Switched to high resolution mode on CPU 0
[    0.403953] PCI: Bridge: 0000:00:06.0
[    0.403990]   IO window: disabled.
[    0.404036]   MEM window: 0xc8000000-0xc80fffff
[    0.404074]   PREFETCH window: disabled.
[    0.404115] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[    0.404152]   IO window: 0x00001000-0x000010ff
[    0.404193]   IO window: 0x00001400-0x000014ff
[    0.404232]   MEM window: 0x8c000000-0x8fffffff
[    0.404273] PCI: Bridge: 0000:00:14.4
[    0.404311]   IO window: 1000-1fff
[    0.404351]   MEM window: 0xd0100000-0xd03fffff
[    0.404391]   PREFETCH window: disabled.
[    0.404448] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.404456] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    0.404463] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.404485] vendor=1002 device=4384
[    0.404525] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, 
low) -> IRQ 20
[    0.404603] bus: 00 index 0 io port: [0, ffff]
[    0.404641] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.404679] bus: 01 index 0 io port: [4000, 4fff]
[    0.404716] bus: 01 index 1 mmio: [d0400000, d05fffff]
[    0.404754] bus: 01 index 2 mmio: [c0000000, c7ffffff]
[    0.404792] bus: 01 index 3 mmio: [0, 0]
[    0.404829] bus: 10 index 0 mmio: [0, 0]
[    0.404866] bus: 10 index 1 mmio: [d0000000, d00fffff]
[    0.404904] bus: 10 index 2 mmio: [0, 0]
[    0.404940] bus: 10 index 3 mmio: [0, 0]
[    0.404978] bus: 20 index 0 io port: [2000, 3fff]
[    0.405024] bus: 20 index 1 mmio: [cc000000, cfffffff]
[    0.405063] bus: 20 index 2 mmio: [0, 0]
[    0.405099] bus: 20 index 3 mmio: [0, 0]
[    0.405137] bus: 30 index 0 mmio: [0, 0]
[    0.405174] bus: 30 index 1 mmio: [c8000000, c80fffff]
[    0.405212] bus: 30 index 2 mmio: [0, 0]
[    0.405249] bus: 30 index 3 mmio: [0, 0]
[    0.405286] bus: 02 index 0 io port: [1000, 1fff]
[    0.405323] bus: 02 index 1 mmio: [d0100000, d03fffff]
[    0.405361] bus: 02 index 2 mmio: [0, 0]
[    0.405398] bus: 02 index 3 io port: [0, ffff]
[    0.405435] bus: 02 index 4 mmio: [0, ffffffffffffffff]
[    0.405473] bus: 03 index 0 io port: [1000, 10ff]
[    0.405510] bus: 03 index 1 io port: [1400, 14ff]
[    0.405549] bus: 03 index 2 mmio: [0, 3ffffff]
[    0.405586] bus: 03 index 3 mmio: [8c000000, 8fffffff]
[    0.405635] NET: Registered protocol family 2
[    0.415123] IP route cache hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.416256] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.418411] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.418905] TCP: Hash tables configured (established 262144 bind 65536)
[    0.418949] TCP reno registered
[    0.422086] NET: Registered protocol family 1
[    0.422228] checking if image is initramfs... it is
[    0.656268] Freeing initrd memory: 4264k freed
[    0.659311] audit: initializing netlink socket (disabled)
[    0.659364] type=2000 audit(1216316121.658:1): initialized
[    0.659640] Total HugeTLB memory allocated, 0
[    0.663226] VFS: Disk quotas dquot_6.5.1
[    0.663372] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.665729] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.666854] NTFS driver 2.1.29 [Flags: R/W].
[    0.667311] QNX4 filesystem 0.2.3 registered.
[    0.667351] fuse init (API version 7.9)
[    0.667840] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.670878] SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
[    0.671883] SGI XFS Quota Management subsystem
[    0.671936] msgmni has been set to 3761
[    0.672209] async_tx: api initialized (async)
[    0.672342] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.672385] io scheduler noop registered
[    0.672422] io scheduler anticipatory registered
[    0.672459] io scheduler deadline registered
[    0.672672] io scheduler cfq registered (default)
[    0.672781] pci 0000:01:05.0: Boot video device
[    0.672933] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.672953] assign_interrupt_mode Found MSI capability
[    0.673031] Allocate Port Service[0000:00:04.0:pcie00]
[    0.673101] Allocate Port Service[0000:00:04.0:pcie03]
[    0.673184] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    0.673202] assign_interrupt_mode Found MSI capability
[    0.673260] Allocate Port Service[0000:00:05.0:pcie00]
[    0.673318] Allocate Port Service[0000:00:05.0:pcie03]
[    0.673401] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.673418] assign_interrupt_mode Found MSI capability
[    0.673475] Allocate Port Service[0000:00:06.0:pcie00]
[    0.673534] Allocate Port Service[0000:00:06.0:pcie03]
[    0.675061] ACPI: AC Adapter [C1EB] (off-line)
[    0.736752] ACPI: Battery Slot [C1ED] (battery present)
[    0.737036] ACPI: Battery Slot [C1EC] (battery absent)
[    0.737277] input: Power Button (FF) as /class/input/input0
[    0.737316] ACPI: Power Button (FF) [PWRF]
[    0.737503] input: Sleep Button (CM) as /class/input/input1
[    0.737541] ACPI: Sleep Button (CM) [C28D]
[    0.737680] input: Lid Switch as /class/input/input2
[    0.737798] ACPI: Lid Switch [C265]
[    0.738159] ACPI: Transitioning device [C399] to D3
[    0.738271] ACPI: PNP0C0B:00 is registered as cooling_device0
[    0.738313] ACPI: Fan [C399] (off)
[    0.738533] ACPI: Transitioning device [C39A] to D3
[    0.738631] ACPI: PNP0C0B:01 is registered as cooling_device1
[    0.738672] ACPI: Fan [C39A] (off)
[    0.738890] ACPI: Transitioning device [C39B] to D3
[    0.738999] ACPI: PNP0C0B:02 is registered as cooling_device2
[    0.739040] ACPI: Fan [C39B] (off)
[    0.739263] ACPI: Transitioning device [C39C] to D3
[    0.739361] ACPI: PNP0C0B:03 is registered as cooling_device3
[    0.739404] ACPI: Fan [C39C] (off)
[    0.739690] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.739909] ACPI: ACPI0007:00 is registered as cooling_device4
[    0.739949] ACPI: Processor [C000] (supports 8 throttling states)
[    0.752713] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.757844] ACPI: Thermal Zone [TZ1] (45 C)
[    0.813424] lp: driver loaded but no devices found
[    0.825644] ppdev: user-space parallel port driver
[    0.825693] Linux agpgart interface v0.103
[    0.825747] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[    0.830562] parport_pc 00:02: activated
[    0.830611] parport_pc 00:02: reported by Plug and Play ACPI
[    0.831964] parport_pc 00:02: disabled
[    0.832721] Floppy drive(s): fd0 is 1.44M
[    3.842993] floppy0: no floppy controllers found
[    3.845070] brd: module loaded
[    3.846157] loop: module loaded
[    3.846202] Compaq SMART2 Driver (v 2.6.0)
[    3.846333] HP CISS Driver (v 3.6.20)
[    3.846748] MM: desc_per_page = 128
[    3.846958] input: Macintosh mouse button emulation as 
/class/input/input3
[    3.847366] Loading iSCSI transport class v2.0-870.
[    3.848240] iscsi: registered transport (tcp)
[    3.848652] Adaptec aacraid driver 1.1-5[2456]-ms
[    3.848876] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    3.849412] QLogic Fibre Channel HBA Driver: 8.02.01-k4
[    3.849630] iscsi: registered transport (qla4xxx)
[    3.849763] QLogic iSCSI HBA Driver
[    3.849813] Emulex LightPulse Fibre Channel SCSI driver 8.2.7
[    3.849857] Copyright(c) 2004-2008 Emulex.  All rights reserved.
[    3.850303] DC390: clustering now enabled by default. If you get 
problems load
[    3.850305]     with "disable_clustering=1" and report to maintainers
[    3.850576] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 
EST 2006)
[    3.850703] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 
2006)
[    3.850867] megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
[    3.851092] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    3.851361] 3ware Storage Controller device driver for Linux 
v1.26.02.002.
[    3.851487] 3ware 9000 Storage Controller device driver for Linux 
v2.26.02.010.
[    3.851607] ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 
(April 24, 2007)
[    3.851738] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[    3.851860] stex: Promise SuperTrak EX Driver version: 3.6.0000.1
[    3.852092] st: Version 20080224, fixed bufsize 32768, s/g segs 256
[    3.852204] Driver 'st' needs updating - please use bus_type methods
[    3.852320] osst :I: Tape driver with OnStream support version 0.99.4
[    3.852321] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    3.852476] Driver 'osst' needs updating - please use bus_type methods
[    3.852644] Driver 'sd' needs updating - please use bus_type methods
[    3.852752] Driver 'sr' needs updating - please use bus_type methods
[    3.852946] ahci 0000:00:12.0: version 3.0
[    3.852992] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    3.853112] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 
32bit
[    3.853238] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 
0x1 impl SATA mode
[    3.853288] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio 
slum part
[    3.853521] scsi0 : ahci
[    3.853817] scsi1 : ahci
[    3.854056] scsi2 : ahci
[    3.854236] scsi3 : ahci
[    3.854429] ata1: SATA max UDMA/133 abar m1024@0xd0609000 port 
0xd0609100 irq 16
[    3.854485] ata2: DUMMY
[    3.854527] ata3: DUMMY
[    3.854569] ata4: DUMMY
[    4.159002] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.159449] ata1.00: ATA-7: FUJITSU MHW2080BH PL, 891F, max UDMA/100
[    4.159493] ata1.00: 156301488 sectors, multi 16: LBA48
[    4.159550] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.160129] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.160175] ata1.00: configured for UDMA/100
[    4.160298] isa bounce pool size: 16 pages
[    4.160433] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2080B 
891F PQ: 0 ANSI: 5
[    4.160724] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    4.160791] sd 0:0:0:0: [sda] Write Protect is off
[    4.160835] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.160869] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.161016] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    4.161081] sd 0:0:0:0: [sda] Write Protect is off
[    4.161125] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.161160] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.161216]  sda: sda1 sda2 < sda5 sda6 >
[    4.277514] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.277687] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.279082] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, 
low) -> IRQ 16
[    4.279302] scsi4 : pata_atiixp
[    4.279498] scsi5 : pata_atiixp
[    4.280281] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5040 
irq 14
[    4.280334] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5048 
irq 15
[    4.469539] ata5.00: ATAPI: TSSTcorpCD/DVDW TS-L632D, HH17, max MWDMA2
[    4.510480] ata5.00: configured for MWDMA2
[    4.667387] scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-L632D 
HH17 PQ: 0 ANSI: 5
[    4.696182] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    4.696239] Uniform CD-ROM driver Revision: 3.20
[    4.696490] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    4.696605] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    4.699033] I2O subsystem v1.325
[    4.699088] i2o: max drivers = 8
[    4.699360] I2O Configuration OSM v1.323
[    4.699545] I2O Bus Adapter OSM v1.317
[    4.699653] I2O Block Device OSM v1.325
[    4.699951] I2O SCSI Peripheral OSM v1.316
[    4.700078] I2O ProcFS OSM v1.316
[    4.700199] Fusion MPT base driver 3.04.07
[    4.700242] Copyright (c) 1999-2008 LSI Corporation
[    4.700289] Fusion MPT SPI Host driver 3.04.07
[    4.700443] Fusion MPT FC Host driver 3.04.07
[    4.700578] Fusion MPT SAS Host driver 3.04.07
[    4.700713] Fusion MPT misc device (ioctl) driver 3.04.07
[    4.700835] mptctl: Registered with Fusion MPT base driver
[    4.700879] mptctl: /dev/mptctl @ (major,minor=10,220)
[    4.700930] Fusion MPT LAN driver 3.04.07
[    4.701517] vendor=1002 device=4384
[    4.701567] ACPI: PCI Interrupt 0000:02:04.1[B] -> GSI 21 (level, 
low) -> IRQ 21
[    4.754060] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  
MMIO=[d0101000-d01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    4.758617] usbcore: registered new interface driver usblp
[    4.758664] Initializing USB Mass Storage driver...
[    4.758778] usbcore: registered new interface driver usb-storage
[    4.758824] USB Mass Storage support registered.
[    4.758941] usbcore: registered new interface driver libusual
[    4.759158] PNP: PS/2 Controller [PNP0303:C249,PNP0f13:C24A] at 
0x60,0x64 irq 1,12
[    4.761160] i8042.c: Detected active multiplexing controller, rev 1.1.
[    4.761938] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.762015] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    4.762060] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    4.762110] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    4.762154] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    4.770860] parkbd: no such parport
[    4.775084] mice: PS/2 mouse device common for all mice
[    4.787583] md: linear personality registered for level -1
[    4.787635] md: raid0 personality registered for level 0
[    4.787679] md: raid1 personality registered for level 1
[    4.787729] md: raid10 personality registered for level 10
[    4.803982] raid6: int64x1   1464 MB/s
[    4.820996] raid6: int64x2   1984 MB/s
[    4.837971] raid6: int64x4   1839 MB/s
[    4.854999] raid6: int64x8   1589 MB/s
[    4.871982] raid6: sse2x1    2261 MB/s
[    4.888988] raid6: sse2x2    3000 MB/s
[    4.905987] raid6: sse2x4    3140 MB/s
[    4.906036] raid6: using algorithm sse2x4 (3140 MB/s)
[    4.906080] md: raid6 personality registered for level 6
[    4.906125] md: raid5 personality registered for level 5
[    4.906174] md: raid4 personality registered for level 4
[    4.906219] md: multipath personality registered for level -4
[    4.906269] md: faulty personality registered for level -5
[    4.906543] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) 
initialised: dm-devel@redhat.com
[    4.907132] cpuidle: using governor ladder
[    4.907668] cpuidle: using governor menu
[    4.927044] input: AT Translated Set 2 keyboard as /class/input/input4
[    4.931757] dcdbas dcdbas: Dell Systems Management Base Driver 
(version 5.6.0-3.2)
[    4.931951] usbcore: registered new interface driver hiddev
[    4.932067] usbcore: registered new interface driver usbhid
[    4.932118] usbhid: v2.6:USB HID core driver
[    4.932882] TCP bic registered
[    4.932928] NET: Registered protocol family 17
[    4.933231] RPC: Registered udp transport module.
[    4.933282] RPC: Registered tcp transport module.
[    4.933335] powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 
3600+ processors (1 cpu cores) (version 2.20.00)
[    4.933445] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x10
[    4.933490] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x12
[    4.933553] powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x14
[    4.933597] powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x18
[    4.933677] powernow-k8: ph2 null fid transition 0xc
[    4.934029] registered taskstats version 1
[    4.934246] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    4.934344] Freeing unused kernel memory: 484k freed
[    4.964679] ata1: hard resetting link
[    5.269550] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.269935] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    5.270437] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    5.270446] ata1.00: configured for UDMA/100
[    5.270518] ata1: EH complete
[    5.270591] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    5.270617] sd 0:0:0:0: [sda] Write Protect is off
[    5.270619] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.270658] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    5.329031] ehci_hcd: disagrees about version of symbol struct_module
[    5.369905] uhci_hcd: disagrees about version of symbol struct_module
[    5.392288] ohci_hcd: disagrees about version of symbol struct_module
[    5.423797] sl811_hcd: disagrees about version of symbol struct_module
[    5.558415] pata_pcmcia: disagrees about version of symbol struct_module
[    5.596909] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, 
caps: 0xa04793/0x300000
[    5.596915] serio: Synaptics pass-through port at isa0060/serio4/input0
[    5.641282] input: SynPS/2 Synaptics TouchPad as /class/input/input5
[    5.749709] scsi_wait_scan: disagrees about version of symbol 
struct_module
[    5.825889] e1000: disagrees about version of symbol struct_module
[    5.850784] tg3: disagrees about version of symbol struct_module
[    6.014804] ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[00023f99295d2f0e]
[   11.401531] Clocksource tsc unstable (delta = -99824559 ns)
[   17.316892] EXT3-fs: INFO: recovery required on readonly filesystem.
[   17.316896] EXT3-fs: write access will be enabled during recovery.
[   17.435953] kjournald starting.  Commit interval 5 seconds
[   17.435972] EXT3-fs: recovery complete.
[   17.436517] EXT3-fs: mounted filesystem with ordered data mode.
[   22.793073] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   22.830548] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   22.952962] tg3.c:v3.92.1 (June 9, 2008)
[   22.953037] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[   22.953053] PCI: Setting latency timer of device 0000:10:00.0 to 64
[   23.174804] eth0: Tigon3 [partno(none) rev b002 PHY(5787)] (PCI 
Express) 10/100/1000Base-T Ethernet 00:1a:4b:58:56:fe
[   23.174819] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] 
WireSpeed[1] TSOcap[1]
[   23.174825] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   23.792903] ACPI: device:03 is registered as cooling_device5
[   23.794864] input: Video Bus as /class/input/input6
[   23.803636] ACPI: Video Device [C08D] (multi-head: yes  rom: no  
post: no)
[   24.564953] ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, 
low) -> IRQ 18
[   24.564976] PCI: Setting latency timer of device 0000:30:00.0 to 64
[   24.572564] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 
0x4243)
[   24.572576] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0D, 
vendor 0x4243)
[   24.572592] ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x04, 
vendor 0x4243)
[   24.572601] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x05, vendor 0x4243)
[   24.582529] ssb: SPROM revision 3 detected.
[   24.590681] ssb: Sonics Silicon Backplane found on PCI device 
0000:30:00.0
[   24.709772] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller 
(OHCI) Driver
[   24.709877] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 23 (level, 
low) -> IRQ 23
[   24.709910] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   24.711051] ohci_hcd 0000:00:13.0: new USB bus registered, assigned 
bus number 1
[   24.711108] ohci_hcd 0000:00:13.0: irq 23, io mem 0xd0601000
[   24.778766] usb usb1: configuration #1 chosen from 1 choice
[   24.778860] hub 1-0:1.0: USB hub found
[   24.778885] hub 1-0:1.0: 2 ports detected
[   24.879913] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, 
low) -> IRQ 17
[   24.879960] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   24.880100] ohci_hcd 0000:00:13.1: new USB bus registered, assigned 
bus number 2
[   24.880150] ohci_hcd 0000:00:13.1: irq 17, io mem 0xd0602000
[   24.934815] usb usb2: configuration #1 chosen from 1 choice
[   24.934896] hub 2-0:1.0: USB hub found
[   24.934920] hub 2-0:1.0: 2 ports detected
[   25.035919] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 17 (level, 
low) -> IRQ 17
[   25.035961] ohci_hcd 0000:00:13.2: OHCI Host Controller
[   25.036100] ohci_hcd 0000:00:13.2: new USB bus registered, assigned 
bus number 3
[   25.036133] ohci_hcd 0000:00:13.2: irq 17, io mem 0xd0603000
[   25.090771] usb usb3: configuration #1 chosen from 1 choice
[   25.090863] hub 3-0:1.0: USB hub found
[   25.090890] hub 3-0:1.0: 2 ports detected
[   25.191958] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, 
low) -> IRQ 17
[   25.191997] ohci_hcd 0000:00:13.3: OHCI Host Controller
[   25.192147] ohci_hcd 0000:00:13.3: new USB bus registered, assigned 
bus number 4
[   25.192182] ohci_hcd 0000:00:13.3: irq 17, io mem 0xd0604000
[   25.246773] usb usb4: configuration #1 chosen from 1 choice
[   25.246854] hub 4-0:1.0: USB hub found
[   25.246879] hub 4-0:1.0: 2 ports detected
[   25.347928] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 17 (level, 
low) -> IRQ 17
[   25.347964] ohci_hcd 0000:00:13.4: OHCI Host Controller
[   25.348114] ohci_hcd 0000:00:13.4: new USB bus registered, assigned 
bus number 5
[   25.348149] ohci_hcd 0000:00:13.4: irq 17, io mem 0xd0605000
[   25.402755] usb usb5: configuration #1 chosen from 1 choice
[   25.402854] hub 5-0:1.0: USB hub found
[   25.402880] hub 5-0:1.0: 2 ports detected
[   25.421594] usb 3-1: new full speed USB device using ohci_hcd and 
address 2
[   25.504214] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 23 (level, 
low) -> IRQ 23
[   25.504256] ehci_hcd 0000:00:13.5: EHCI Host Controller
[   25.504636] ehci_hcd 0000:00:13.5: new USB bus registered, assigned 
bus number 6
[   25.504715] ehci_hcd 0000:00:13.5: debug port 1
[   25.504736] ehci_hcd 0000:00:13.5: irq 23, io mem 0xd0606000
[   25.551577] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[   25.551831] usb usb6: configuration #1 chosen from 1 choice
[   25.551914] hub 6-0:1.0: USB hub found
[   25.551937] hub 6-0:1.0: 10 ports detected
[   25.653213] piix4_smbus 0000:00:14.0: SMBus Host Controller at 
0x8200, revision 0
[   25.787046] input: PC Speaker as /class/input/input7
[   25.891022] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, 
low) -> IRQ 16
[   25.949534] usb 3-1: device not accepting address 2, error -62
[   25.972182] Yenta: CardBus bridge found at 0000:02:04.0 [103c:30c2]
[   25.972223] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   25.972228]   IO window: 0x00001000-0x000010ff
[   25.972235]   IO window: 0x00001400-0x000014ff
[   25.972248]   PREFETCH window: 0x88400000-0x887fffff
[   25.972255]   MEM window: 0x8c000000-0x8fffffff
[   26.000581] hub 3-0:1.0: unable to enumerate USB device on port 1
[   26.095297] Yenta: ISA IRQ mask 0x0cb8, PCI irq 20
[   26.095310] Socket status: 30000006
[   26.095520] Yenta: Raising subordinate bus# of parent bus (#02) from 
#03 to #06
[   26.095529] pcmcia: parent PCI bridge I/O window: 0x1000 - 0x1fff
[   26.095535] pcmcia: parent PCI bridge Memory window: 0xd0100000 - 
0xd03fffff
[   26.274801] tpm_inf_pnp 00:03: Found C231 with ID IFX0102
[   26.274862] tpm_inf_pnp 00:03: TPM found: config base 0x520, data 
base 0x530, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 
0x000b (SLB 9635 TT 1.2)
[   26.680580] usb 3-1: new full speed USB device using ohci_hcd and 
address 4
[   26.826743] usb 3-1: configuration #1 chosen from 1 choice
[   26.863651] b43-phy0: Broadcom 4311 WLAN found
[   26.897885] phy0: Selected rate control algorithm 'pid'
[   27.164882] Broadcom 43xx driver loaded [ Features: PMLR, 
Firmware-ID: FW13 ]
[   59.379874] EXT3 FS on sda5, internal journal
[   62.372667] kjournald starting.  Commit interval 5 seconds
[   62.373549] EXT3 FS on sda1, internal journal
[   62.373562] EXT3-fs: mounted filesystem with ordered data mode.
[  138.575037] Adding 1397612k swap on /dev/sda6.  Priority:-1 extents:1 
across:1397612k

