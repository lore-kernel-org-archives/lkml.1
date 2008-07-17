Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYGQLY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYGQLY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYGQLYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:24:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:43733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYGQLYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aiqTBSC7z4kW5GzWXzJO/w1vNt2ZlKMpKfbEMZkmagpUgUePMrY/9EE3VjwcHuW79E
         +ZQfNJhoe4UFVAQO2cLFSc5sed8LQlnZALZpPXYFz0qZm+kCtUT3riSiz1Crt7BEcTN9
         i/lJLjsf4ijPRNH8WNUa9pwlbSO/FTF+UfK2I=
Message-ID: <487F39AC.3060805@gmail.com>
Date: Thu, 17 Jul 2008 12:23:08 +0000
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
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de> <487F33F2.2060202@gmail.com> <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 17 Jul 2008, Richard wrote:
>   
>> The Short story... it was a dark and rainy night :-P oops, wrong mailing
>> list.... so here goes
>>     
>
> Hehe
>
>   
>> The kernel boots and when init.d starts, the screen switches off, the CPU fan
>> goes to Max speed, and a few minutes later all goes quiet and it appears to
>> have powered off.
>>
>> I usually boot with noapictimer and if I disable ACPI totally, the clock
>> references don't work and the timebase goes wrong. (Playing a MP3 is quite an
>> entertaining event as it sounds like an old vinyl record player with a
>> slipping drive belt)
>>     
>
> That's with 2.6.25 vanilla, right ? 
>
> Can you provide a bootlog from that kernel with noapictimer on the
> kernel command line ?
>
> Also as it reaches at least init it would be great to get a bootlog
> for a boot w/o any command line options via netconsole (see
> Documentation/networking/netconsole.txt)
>
> Thanks,
>
> 	tglx
>
>   
Prepare to be spammed.... I am using a Sabayon build, but all distros I 
have tried exibit the same behavior to me. the nohz=off options also 
works quite well. (I have a 2.6.26 vanilla that behaves the same)

but for now, I am off to read and setup the netconsole.

Richard



--------------- WITH Noapic timer ------------


Jul 14 11:12:23 localhost syslog-ng[11073]: syslog-ng starting up; 
version='2.0.6'
Jul 14 11:12:23 localhost plash=silent,theme:sabayon vga=791 
CONSOLE=/dev/tty1 noapictimer resume=swap:/dev/sda6
Jul 14 11:12:23 localhost [ 0.000000] Initializing CPU#0
Jul 14 11:12:23 localhost [ 0.000000] PID hash table entries: 4096 
(order: 12, 32768 bytes)
Jul 14 11:12:23 localhost [ 0.000000] Extended CMOS year: 2000
Jul 14 11:12:23 localhost [ 0.000000] TSC calibrated against PM_TIMER
Jul 14 11:12:23 localhost [ 0.000001] time.c: Detected 1994.901 MHz 
processor.
Jul 14 11:12:23 localhost [ 0.000056] Console: colour dummy device 80x25
Jul 14 11:12:23 localhost [ 0.000059] console [tty0] enabled
Jul 14 11:12:23 localhost [ 0.000123] Checking aperture...
Jul 14 11:12:23 localhost [ 0.000126] Node 0: aperture @ 915a000000 size 
32 MB
Jul 14 11:12:23 localhost [ 0.000127] Aperture beyond 4GB. Ignoring.
Jul 14 11:12:23 localhost [ 0.000999] No AGP bridge found
Jul 14 11:12:23 localhost [ 0.000999] Memory: 1921588k/1965760k 
available (6515k kernel code, 43784k reserved, 2917k data, 428k init)
Jul 14 11:12:23 localhost [ 0.000999] CPA: page pool initialized 1 of 1 
pages preallocated
Jul 14 11:12:23 localhost [ 0.000999] SLUB: Genslabs=13, HWalign=64, 
Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Jul 14 11:12:23 localhost [ 0.060993] Calibrating delay using timer 
specific routine.. 3996.13 BogoMIPS (lpj=1998065)
Jul 14 11:12:23 localhost [ 0.061057] Security Framework initialized
Jul 14 11:12:23 localhost [ 0.061062] SELinux: Disabled at boot.
Jul 14 11:12:23 localhost [ 0.061065] Capability LSM initialized
Jul 14 11:12:23 localhost [ 0.061453] Dentry cache hash table entries: 
262144 (order: 9, 2097152 bytes)
Jul 14 11:12:23 localhost [ 0.063811] Inode-cache hash table entries: 
131072 (order: 8, 1048576 bytes)
Jul 14 11:12:23 localhost [ 0.064903] Mount-cache hash table entries: 256
Jul 14 11:12:23 localhost [ 0.065226] Initializing cgroup subsys debug
Jul 14 11:12:23 localhost [ 0.065246] Initializing cgroup subsys ns
Jul 14 11:12:23 localhost [ 0.065249] Initializing cgroup subsys cpuacct
Jul 14 11:12:23 localhost [ 0.065277] CPU: L1 I Cache: 64K (64 
bytes/line), D cache 64K (64 bytes/line)
Jul 14 11:12:23 localhost [ 0.065279] CPU: L2 Cache: 256K (64 bytes/line)
Jul 14 11:12:23 localhost [ 0.065281] CPU 0/0 -> Node 0
Jul 14 11:12:23 localhost [ 0.065319] ACPI: Core revision 20070126
Jul 14 11:12:23 localhost [ 0.098984] ..MP-BIOS bug: 8254 timer not 
connected to IO-APIC
Jul 14 11:12:23 localhost [ 0.109426] Disabling APIC timer
Jul 14 11:12:23 localhost [ 0.109482] Brought up 1 CPUs
Jul 14 11:12:23 localhost [ 0.109743] net_namespace: 1016 bytes
Jul 14 11:12:23 localhost [ 0.109912] xor: automatically using best 
checksumming function: generic_sse
Jul 14 11:12:23 localhost [ 0.113984] generic_sse: 6144.000 MB/sec
Jul 14 11:12:23 localhost [ 0.113986] xor: using function: generic_sse 
(6144.000 MB/sec)
Jul 14 11:12:23 localhost [ 0.114017] NET: Registered protocol family 16
Jul 14 11:12:23 localhost [ 0.114272] No dock devices found.
Jul 14 11:12:23 localhost [ 0.114630] ACPI: bus type pci registered
Jul 14 11:12:23 localhost [ 0.126265] PCI: Using MMCONFIG at e0000000 - 
efffffff
Jul 14 11:12:23 localhost [ 0.126269] PCI: Using configuration type 1
Jul 14 11:12:23 localhost [ 0.129856] ACPI: EC: Look up EC in DSDT
Jul 14 11:12:23 localhost [ 0.131069] ACPI: EC: non-query interrupt 
received, switching to interrupt mode
Jul 14 11:12:23 localhost [ 0.389921] ACPI: Interpreter enabled
Jul 14 11:12:23 localhost [ 0.389926] ACPI: (supports S0 S3 S4 S5)
Jul 14 11:12:23 localhost [ 0.389939] ACPI: Using IOAPIC for interrupt 
routing
Jul 14 11:12:23 localhost [ 0.399925] ACPI: EC: GPE = 0x11, I/O: 
command/status = 0x66, data = 0x62
Jul 14 11:12:23 localhost [ 0.399929] ACPI: EC: driver started in 
interrupt mode
Jul 14 11:12:23 localhost [ 0.400022] ACPI: PCI Root Bridge [C08B] (0000:00)
Jul 14 11:12:23 localhost [ 0.400241] pci 0000:00:12.0: set SATA to AHCI 
mode
Jul 14 11:12:23 localhost [ 0.401413] PCI: Transparent bridge - 0000:00:14.4
Jul 14 11:12:23 localhost [ 0.401460] ACPI: PCI Interrupt Routing Table 
[\_SB_.C08B._PRT]
Jul 14 11:12:23 localhost [ 0.401855] ACPI: PCI Interrupt Routing Table 
[\_SB_.C08B.C08C._PRT]
Jul 14 11:12:23 localhost [ 0.401988] ACPI: PCI Interrupt Routing Table 
[\_SB_.C08B.C0FC._PRT]
Jul 14 11:12:23 localhost [ 0.422527] ACPI: PCI Interrupt Link [C145] 
(IRQs 10 11) *0, disabled.
Jul 14 11:12:23 localhost [ 0.422695] ACPI: PCI Interrupt Link [C146] 
(IRQs 10 11) *0, disabled.
Jul 14 11:12:23 localhost [ 0.422860] ACPI: PCI Interrupt Link [C147] 
(IRQs 10 11) *0, disabled.
Jul 14 11:12:23 localhost [ 0.423042] ACPI: PCI Interrupt Link [C148] 
(IRQs 10 11) *0, disabled.
Jul 14 11:12:23 localhost [ 0.423205] ACPI: PCI Interrupt Link [C149] 
(IRQs 10 11) *0, disabled.
Jul 14 11:12:23 localhost [ 0.423368] ACPI: PCI Interrupt Link [C14A] 
(IRQs 9) *0, disabled.
Jul 14 11:12:23 localhost [ 0.423531] ACPI: PCI Interrupt Link [C14B] 
(IRQs 10 11) *0, disabled.
Jul 14 11:12:23 localhost [ 0.423699] ACPI: PCI Interrupt Link [C14C] 
(IRQs 10 11) *0, disabled.
Jul 14 11:12:23 localhost [ 0.423857] ACPI: Power Resource [C171] (off)
Jul 14 11:12:23 localhost [ 0.424053] ACPI: Power Resource [C230] (off)
Jul 14 11:12:23 localhost [ 0.424100] ACPI: Power Resource [C24C] (on)
Jul 14 11:12:23 localhost [ 0.424211] ACPI: Power Resource [C395] (off)
Jul 14 11:12:23 localhost [ 0.424300] ACPI: Power Resource [C396] (off)
Jul 14 11:12:23 localhost [ 0.424388] ACPI: Power Resource [C397] (off)
Jul 14 11:12:23 localhost [ 0.424476] ACPI: Power Resource [C398] (off)
Jul 14 11:12:23 localhost [ 0.424731] ACPI: WMI: Mapper loaded
Jul 14 11:12:23 localhost [ 0.424734] Linux Plug and Play Support v0.97 
(c) Adam Belay
Jul 14 11:12:23 localhost [ 0.424766] pnp: PnP ACPI init
Jul 14 11:12:23 localhost [ 0.424776] ACPI: bus type pnp registered
Jul 14 11:12:23 localhost [ 0.433729] pnp: PnP ACPI: found 14 devices
Jul 14 11:12:23 localhost [ 0.433733] ACPI: ACPI bus type pnp unregistered
Jul 14 11:12:23 localhost [ 0.433949] SCSI subsystem initialized
Jul 14 11:12:23 localhost [ 0.433979] libata version 3.00 loaded.
Jul 14 11:12:23 localhost [ 0.434162] usbcore: registered new interface 
driver usbfs
Jul 14 11:12:23 localhost [ 0.434225] usbcore: registered new interface 
driver hub
Jul 14 11:12:23 localhost [ 0.434267] usbcore: registered new device 
driver usb
Jul 14 11:12:23 localhost [ 0.434463] PCI: Using ACPI for IRQ routing
Jul 14 11:12:23 localhost [ 0.434467] PCI: If a device doesn't work, try 
"pci=routeirq". If it helps, post a report
Jul 14 11:12:23 localhost [ 0.434505] PCI: Cannot allocate resource 
region 0 of device 0000:00:14.2
Jul 14 11:12:23 localhost [ 0.440968] NetLabel: Initializing
Jul 14 11:12:23 localhost [ 0.440968] NetLabel: domain hash size = 128
Jul 14 11:12:23 localhost [ 0.440968] NetLabel: protocols = UNLABELED 
CIPSOv4
Jul 14 11:12:23 localhost [ 0.440968] NetLabel: unlabeled traffic 
allowed by default
Jul 14 11:12:23 localhost [ 0.440969] ACPI: RTC can wake from S4
Jul 14 11:12:23 localhost [ 0.444000] system 00:00: iomem range 
0x0-0x9ffff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:00: iomem range 
0xe0000-0xfffff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:00: iomem range 
0x100000-0xffffffff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0x40b-0x40b has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0x4d0-0x4d1 has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0x4d6-0x4d6 has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0x500-0x51f has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0xc00-0xc01 has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0xc14-0xc14 has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0xc50-0xc51 has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0xc52-0xc52 has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0xc6c-0xc6c has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0xc6f-0xc6f has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: ioport range 
0xcd0-0xcdf has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: iomem range 
0xffb00000-0xffbfffff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0a: iomem range 
0xfff00000-0xffffffff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0c: ioport range 
0x8000-0x802f has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0c: ioport range 
0x8100-0x811f has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0c: iomem range 
0xe0000000-0xefffffff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0c: iomem range 
0xfec00000-0xfec000ff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0c: iomem range 
0xfed45000-0xfed8ffff has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0d: iomem range 
0xcd400-0xcffff has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0d: iomem range 
0xd2a00-0xd2fff has been reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0d: iomem range 
0x0-0x7ffffff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] system 00:0d: iomem range 
0xfee00000-0xfee00fff could not be reserved
Jul 14 11:12:23 localhost [ 0.444000] PCI: Bridge: 0000:00:01.0
Jul 14 11:12:23 localhost [ 0.444000] IO window: 4000-4fff
Jul 14 11:12:23 localhost [ 0.444000] MEM window: 0xd0400000-0xd05fffff
Jul 14 11:12:23 localhost [ 0.444000] PREFETCH window: 
0x00000000c0000000-0x00000000c7ffffff
Jul 14 11:12:23 localhost [ 0.444000] PCI: Bridge: 0000:00:04.0
Jul 14 11:12:23 localhost [ 0.444000] IO window: disabled.
Jul 14 11:12:23 localhost [ 0.444000] MEM window: 0xd0000000-0xd00fffff
Jul 14 11:12:23 localhost [ 0.444000] PREFETCH window: disabled.
Jul 14 11:12:23 localhost [ 0.444000] PCI: Bridge: 0000:00:05.0
Jul 14 11:12:23 localhost [ 0.444000] IO window: 2000-3fff
Jul 14 11:12:23 localhost [ 0.444000] MEM window: 0xcc000000-0xcfffffff
Jul 14 11:12:23 localhost [ 0.444000] PREFETCH window: disabled.
Jul 14 11:12:23 localhost [ 0.444000] PCI: Bridge: 0000:00:06.0
Jul 14 11:12:23 localhost [ 0.444000] IO window: disabled.
Jul 14 11:12:23 localhost [ 0.444000] MEM window: 0xc8000000-0xc80fffff
Jul 14 11:12:23 localhost [ 0.444000] PREFETCH window: disabled.
Jul 14 11:12:23 localhost [ 0.444000] PCI: Bus 3, cardbus bridge: 
0000:02:04.0
Jul 14 11:12:23 localhost [ 0.444000] IO window: 0x00001000-0x000010ff
Jul 14 11:12:23 localhost [ 0.444000] IO window: 0x00001400-0x000014ff
Jul 14 11:12:23 localhost [ 0.444000] PREFETCH window: 0x88000000-0x8bffffff
Jul 14 11:12:23 localhost [ 0.444000] MEM window: 0x90000000-0x93ffffff
Jul 14 11:12:23 localhost [ 0.444000] PCI: Bridge: 0000:00:14.4
Jul 14 11:12:23 localhost [ 0.444000] IO window: 1000-1fff
Jul 14 11:12:23 localhost [ 0.444000] MEM window: 0xd0100000-0xd03fffff
Jul 14 11:12:23 localhost [ 0.444000] PREFETCH window: 
0x0000000088000000-0x000000008bffffff
Jul 14 11:12:23 localhost [ 0.444000] PCI: Setting latency timer of 
device 0000:00:04.0 to 64
Jul 14 11:12:23 localhost [ 0.444000] PCI: Setting latency timer of 
device 0000:00:05.0 to 64
Jul 14 11:12:23 localhost [ 0.444000] PCI: Setting latency timer of 
device 0000:00:06.0 to 64
Jul 14 11:12:23 localhost [ 0.444000] ACPI: PCI Interrupt 
0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
Jul 14 11:12:23 localhost [ 0.444000] NET: Registered protocol family 2
Jul 14 11:12:23 localhost [ 0.453011] IP route cache hash table entries: 
65536 (order: 7, 524288 bytes)
Jul 14 11:12:23 localhost [ 0.453029] TCP established hash table 
entries: 262144 (order: 10, 4194304 bytes)
Jul 14 11:12:23 localhost [ 0.454874] TCP bind hash table entries: 65536 
(order: 8, 1048576 bytes)
Jul 14 11:12:23 localhost [ 0.455337] TCP: Hash tables configured 
(established 262144 bind 65536)
Jul 14 11:12:23 localhost [ 0.455341] TCP reno registered
Jul 14 11:12:23 localhost [ 0.459013] checking if image is initramfs... 
it is
Jul 14 11:12:23 localhost [ 0.696353] Freeing initrd memory: 4264k freed
Jul 14 11:12:23 localhost [ 0.699093] audit: initializing netlink socket 
(disabled)
Jul 14 11:12:23 localhost [ 0.699106] type=2000 audit(1216033886.698:1): 
initialized
Jul 14 11:12:23 localhost [ 0.699296] Total HugeTLB memory allocated, 0
Jul 14 11:12:23 localhost [ 0.701520] VFS: Disk quotas dquot_6.5.1
Jul 14 11:12:23 localhost [ 0.701610] Dquot-cache hash table entries: 
512 (order 0, 4096 bytes)
Jul 14 11:12:23 localhost [ 0.702534] squashfs: version 3.3 (2007/10/31) 
Phillip Lougher
Jul 14 11:12:23 localhost [ 0.703472] Installing knfsd (copyright (C) 
1996 okir@monad.swb.de).
Jul 14 11:12:23 localhost [ 0.704181] NTFS driver 2.1.29 [Flags: R/W].
Jul 14 11:12:23 localhost [ 0.704474] QNX4 filesystem 0.2.3 registered.
Jul 14 11:12:23 localhost [ 0.704719] aufs 20080609
Jul 14 11:12:23 localhost [ 0.704721] fuse init (API version 7.9)
Jul 14 11:12:23 localhost [ 0.705033] JFS: nTxBlock = 8192, nTxLock = 65536
Jul 14 11:12:23 localhost [ 0.707785] SGI XFS with ACLs, security 
attributes, realtime, large block/inode numbers, no debug enabled
Jul 14 11:12:23 localhost [ 0.708440] SGI XFS Quota Management subsystem
Jul 14 11:12:23 localhost [ 0.708453] Registering unionfs 2.3.3 (for 2.6.25)
Jul 14 11:12:23 localhost [ 0.708739] async_tx: api initialized (async)
Jul 14 11:12:23 localhost [ 0.708797] Block layer SCSI generic (bsg) 
driver version 0.4 loaded (major 253)
Jul 14 11:12:23 localhost [ 0.708800] io scheduler noop registered
Jul 14 11:12:23 localhost [ 0.708802] io scheduler anticipatory registered
Jul 14 11:12:23 localhost [ 0.708805] io scheduler deadline registered
Jul 14 11:12:23 localhost [ 0.708926] io scheduler cfq registered (default)
Jul 14 11:12:23 localhost [ 0.709058] pci 0000:01:05.0: Boot video device
Jul 14 11:12:23 localhost [ 0.709167] PCI: Setting latency timer of 
device 0000:00:04.0 to 64
Jul 14 11:12:23 localhost [ 0.709187] assign_interrupt_mode Found MSI 
capability
Jul 14 11:12:23 localhost [ 0.709211] Allocate Port 
Service[0000:00:04.0:pcie00]
Jul 14 11:12:23 localhost [ 0.709251] Allocate Port 
Service[0000:00:04.0:pcie03]
Jul 14 11:12:23 localhost [ 0.709315] PCI: Setting latency timer of 
device 0000:00:05.0 to 64
Jul 14 11:12:23 localhost [ 0.709334] assign_interrupt_mode Found MSI 
capability
Jul 14 11:12:23 localhost [ 0.709353] Allocate Port 
Service[0000:00:05.0:pcie00]
Jul 14 11:12:23 localhost [ 0.709387] Allocate Port 
Service[0000:00:05.0:pcie03]
Jul 14 11:12:23 localhost [ 0.709448] PCI: Setting latency timer of 
device 0000:00:06.0 to 64
Jul 14 11:12:23 localhost [ 0.709466] assign_interrupt_mode Found MSI 
capability
Jul 14 11:12:23 localhost [ 0.709485] Allocate Port 
Service[0000:00:06.0:pcie00]
Jul 14 11:12:23 localhost [ 0.709520] Allocate Port 
Service[0000:00:06.0:pcie03]
Jul 14 11:12:23 localhost [ 0.741416] lp: driver loaded but no devices found
Jul 14 11:12:23 localhost [ 0.741535] Real Time Clock Driver v1.12ac
Jul 14 11:12:23 localhost [ 0.748283] ppdev: user-space parallel port driver
Jul 14 11:12:23 localhost [ 0.748287] Linux agpgart interface v0.103
Jul 14 11:12:23 localhost [ 0.748576] vesafb: framebuffer at 0xc0000000, 
mapped to 0xffffc20010f00000, using 3072k, total 16384k
Jul 14 11:12:23 localhost [ 0.748580] vesafb: mode is 1024x768x16, 
linelength=2048, pages=9
Jul 14 11:12:23 localhost [ 0.748582] vesafb: scrolling: redraw
Jul 14 11:12:23 localhost [ 0.748585] vesafb: Truecolor: size=0:5:6:5, 
shift=0:11:5:0
Jul 14 11:12:23 localhost [ 0.796629] Console: switching to colour frame 
buffer device 128x48
Jul 14 11:12:23 localhost [ 0.920823] fbcondecor: console 0 using theme 
'sabayon'
Jul 14 11:12:23 localhost [ 0.943942] Clockevents: could not switch to 
one-shot mode: lapic is not functional.
Jul 14 11:12:23 localhost [ 0.943946] Could not switch to high 
resolution mode on CPU 0
Jul 14 11:12:23 localhost [ 1.183263] fbcondecor: switched decor state 
to 'on' on console 0
Jul 14 11:12:23 localhost [ 1.183986] fb0: VESA VGA frame buffer device
Jul 14 11:12:23 localhost [ 1.184427] ACPI: AC Adapter [C1EB] (on-line)
Jul 14 11:12:23 localhost [ 1.284830] ACPI: Battery Slot [C1ED] (battery 
present)
Jul 14 11:12:23 localhost [ 1.285049] ACPI: Battery Slot [C1EC] (battery 
absent)
Jul 14 11:12:23 localhost [ 1.285614] input: Power Button (FF) as 
/class/input/input0
Jul 14 11:12:23 localhost [ 1.290516] ACPI: Power Button (FF) [PWRF]
Jul 14 11:12:23 localhost [ 1.290516] input: Sleep Button (CM) as 
/class/input/input1
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Sleep Button (CM) [C28D]
Jul 14 11:12:23 localhost [ 1.293520] input: Lid Switch as 
/class/input/input2
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Lid Switch [C265]
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Transitioning device [C399] 
to D3
Jul 14 11:12:23 localhost [ 1.293520] ACPI: PNP0C0B:00 is registered as 
cooling_device0
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Fan [C399] (off)
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Transitioning device [C39A] 
to D3
Jul 14 11:12:23 localhost [ 1.293520] ACPI: PNP0C0B:01 is registered as 
cooling_device1
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Fan [C39A] (off)
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Transitioning device [C39B] 
to D3
Jul 14 11:12:23 localhost [ 1.293520] ACPI: PNP0C0B:02 is registered as 
cooling_device2
Jul 14 11:12:23 localhost [ 1.293520] ACPI: Fan [C39B] (off)
Jul 14 11:12:23 localhost [ 1.293605] ACPI: Transitioning device [C39C] 
to D3
Jul 14 11:12:23 localhost [ 1.293643] ACPI: PNP0C0B:03 is registered as 
cooling_device3
Jul 14 11:12:23 localhost [ 1.293648] ACPI: Fan [C39C] (off)
Jul 14 11:12:23 localhost [ 1.293810] ACPI: CPU0 (power states: C1[C1] 
C2[C2] C3[C3])
Jul 14 11:12:23 localhost [ 1.293848] ACPI: ACPI0007:00 is registered as 
cooling_device4
Jul 14 11:12:23 localhost [ 1.293852] ACPI: Processor [C000] (supports 8 
throttling states)
Jul 14 11:12:23 localhost [ 1.304825] ACPI: LNXTHERM:01 is registered as 
thermal_zone0
Jul 14 11:12:23 localhost [ 1.307922] ACPI: Thermal Zone [TZ1] (66 C)
Jul 14 11:12:23 localhost [ 1.308079] Serial: 8250/16550 driver 
$Revision: 1.90 $ 4 ports, IRQ sharing enabled
Jul 14 11:12:23 localhost [ 1.311644] parport_pc 00:02: activated
Jul 14 11:12:23 localhost [ 1.311649] parport_pc 00:02: reported by Plug 
and Play ACPI
Jul 14 11:12:23 localhost [ 1.312639] parport_pc 00:02: disabled
Jul 14 11:12:23 localhost [ 1.313101] Floppy drive(s): fd0 is 1.44M
Jul 14 11:12:23 localhost [ 4.324136] floppy0: no floppy controllers found
Jul 14 11:12:23 localhost [ 4.324136] brd: module loaded
Jul 14 11:12:23 localhost [ 4.324162] loop: module loaded
Jul 14 11:12:23 localhost [ 4.324164] Compaq SMART2 Driver (v 2.6.0)
Jul 14 11:12:23 localhost [ 4.324218] HP CISS Driver (v 3.6.20)
Jul 14 11:12:23 localhost [ 4.324459] MM: desc_per_page = 128
Jul 14 11:12:23 localhost [ 4.324571] input: Macintosh mouse button 
emulation as /class/input/input3
Jul 14 11:12:23 localhost [ 4.324765] Loading iSCSI transport class 
v2.0-869.
Jul 14 11:12:23 localhost [ 4.325111] iscsi: registered transport (tcp)
Jul 14 11:12:23 localhost [ 4.325320] Adaptec aacraid driver 1.1-5[2455]-ms
Jul 14 11:12:23 localhost [ 4.325376] aic94xx: Adaptec aic94xx SAS/SATA 
driver version 1.0.3 loaded
Jul 14 11:12:23 localhost [ 4.325579] QLogic Fibre Channel HBA Driver
Jul 14 11:12:23 localhost [ 4.325674] iscsi: registered transport (qla4xxx)
Jul 14 11:12:23 localhost [ 4.325714] QLogic iSCSI HBA Driver
Jul 14 11:12:23 localhost [ 4.325716] Emulex LightPulse Fibre Channel 
SCSI driver 8.2.5
Jul 14 11:12:23 localhost [ 4.325718] Copyright(c) 2004-2008 Emulex. All 
rights reserved.
Jul 14 11:12:23 localhost [ 4.325875] DC390: clustering now enabled by 
default. If you get problems load
Jul 14 11:12:23 localhost [ 4.325877] with "disable_clustering=1" and 
report to maintainers
Jul 14 11:12:23 localhost [ 4.325969] megaraid cmm: 2.20.2.7 (Release 
Date: Sun Jul 16 00:01:03 EST 2006)
Jul 14 11:12:23 localhost [ 4.326010] megaraid: 2.20.5.1 (Release Date: 
Thu Nov 16 15:32:35 EST 2006)
Jul 14 11:12:23 localhost [ 4.326051] megasas: 00.00.03.16-rc1 Thu. Nov. 
07 10:09:32 PDT 2007
Jul 14 11:12:23 localhost [ 4.326284] GDT-HA: Storage RAID Controller 
Driver. Version: 3.05
Jul 14 11:12:23 localhost [ 4.326392] GDT-HA: Found 0 PCI Storage RAID 
Controllers
Jul 14 11:12:23 localhost [ 4.326474] 3ware Storage Controller device 
driver for Linux v1.26.02.002.
Jul 14 11:12:23 localhost [ 4.326509] 3ware 9000 Storage Controller 
device driver for Linux v2.26.02.010.
Jul 14 11:12:23 localhost [ 4.326544] ipr: IBM Power RAID SCSI Device 
Driver version: 2.4.1 (April 24, 2007)
Jul 14 11:12:23 localhost [ 4.326583] RocketRAID 3xxx/4xxx Controller 
driver v1.3 (071203)
Jul 14 11:12:23 localhost [ 4.326618] stex: Promise SuperTrak EX Driver 
version: 3.6.0000.1
Jul 14 11:12:23 localhost [ 4.326692] st: Version 20080221, fixed 
bufsize 32768, s/g segs 256
Jul 14 11:12:23 localhost [ 4.326729] Driver 'st' needs updating - 
please use bus_type methods
Jul 14 11:12:23 localhost [ 4.326765] osst :I: Tape driver with OnStream 
support version 0.99.4
Jul 14 11:12:23 localhost [ 4.326766] osst :I: $Id: osst.c,v 1.73 
2005/01/01 21:13:34 wriede Exp $
Jul 14 11:12:23 localhost [ 4.326798] Driver 'osst' needs updating - 
please use bus_type methods
Jul 14 11:12:23 localhost [ 4.326860] Driver 'sd' needs updating - 
please use bus_type methods
Jul 14 11:12:23 localhost [ 4.326888] Driver 'sr' needs updating - 
please use bus_type methods
Jul 14 11:12:23 localhost [ 4.326966] ahci 0000:00:12.0: version 3.0
Jul 14 11:12:23 localhost [ 4.326996] ACPI: PCI Interrupt 
0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
Jul 14 11:12:23 localhost [ 4.327028] ahci 0000:00:12.0: controller 
can't do 64bit DMA, forcing 32bit
Jul 14 11:12:23 localhost [ 5.328030] ahci 0000:00:12.0: AHCI 0001.0100 
32 slots 4 ports 3 Gbps 0x1 impl SATA mode
Jul 14 11:12:23 localhost [ 5.328030] ahci 0000:00:12.0: flags: ncq sntf 
ilck pm led clo pio slum part
Jul 14 11:12:23 localhost [ 5.328030] scsi0 : ahci
Jul 14 11:12:23 localhost [ 5.328030] scsi1 : ahci
Jul 14 11:12:23 localhost [ 5.328030] scsi2 : ahci
Jul 14 11:12:23 localhost [ 5.328030] scsi3 : ahci
Jul 14 11:12:23 localhost [ 5.328030] ata1: SATA max UDMA/133 abar 
m1024@0xd0609000 port 0xd0609100 irq 16
Jul 14 11:12:23 localhost [ 5.328030] ata2: DUMMY
Jul 14 11:12:23 localhost [ 5.328030] ata3: DUMMY
Jul 14 11:12:23 localhost [ 5.328030] ata4: DUMMY
Jul 14 11:12:23 localhost [ 5.783987] ata1: SATA link up 1.5 Gbps 
(SStatus 113 SControl 300)
Jul 14 11:12:23 localhost [ 5.784357] ata1.00: ATA-7: FUJITSU MHW2080BH 
PL, 891F, max UDMA/100
Jul 14 11:12:23 localhost [ 5.784357] ata1.00: 156301488 sectors, multi 
16: LBA48
Jul 14 11:12:23 localhost [ 5.784357] ata1.00: SB600 AHCI: limiting to 
255 sectors per cmd
Jul 14 11:12:23 localhost [ 5.784849] ata1.00: SB600 AHCI: limiting to 
255 sectors per cmd
Jul 14 11:12:23 localhost [ 5.784849] ata1.00: configured for UDMA/100
Jul 14 11:12:23 localhost [ 5.784959] scsi 0:0:0:0: Direct-Access ATA 
FUJITSU MHW2080B 891F PQ: 0 ANSI: 5
Jul 14 11:12:23 localhost [ 5.785113] sd 0:0:0:0: [sda] 156301488 
512-byte hardware sectors (80026 MB)
Jul 14 11:12:23 localhost [ 5.785126] sd 0:0:0:0: [sda] Write Protect is off
Jul 14 11:12:23 localhost [ 5.785129] sd 0:0:0:0: [sda] Mode Sense: 00 
3a 00 00
Jul 14 11:12:23 localhost [ 5.785147] sd 0:0:0:0: [sda] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Jul 14 11:12:23 localhost [ 5.785197] sd 0:0:0:0: [sda] 156301488 
512-byte hardware sectors (80026 MB)
Jul 14 11:12:23 localhost [ 5.785207] sd 0:0:0:0: [sda] Write Protect is off
Jul 14 11:12:23 localhost [ 5.785210] sd 0:0:0:0: [sda] Mode Sense: 00 
3a 00 00
Jul 14 11:12:23 localhost [ 5.785227] sd 0:0:0:0: [sda] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Jul 14 11:12:23 localhost [ 5.785231] sda: sda1 sda2 < sda5 sda6 >
Jul 14 11:12:23 localhost [ 5.903658] sd 0:0:0:0: [sda] Attached SCSI disk
Jul 14 11:12:23 localhost [ 5.903678] sd 0:0:0:0: Attached scsi generic 
sg0 type 0
Jul 14 11:12:23 localhost [ 5.904537] ACPI: PCI Interrupt 
0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
Jul 14 11:12:23 localhost [ 5.904629] scsi4 : pata_atiixp
Jul 14 11:12:23 localhost [ 5.904722] scsi5 : pata_atiixp
Jul 14 11:12:23 localhost [ 5.905213] ata5: PATA max UDMA/100 cmd 0x1f0 
ctl 0x3f6 bmdma 0x5040 irq 14
Jul 14 11:12:23 localhost [ 5.905216] ata6: PATA max UDMA/100 cmd 0x170 
ctl 0x376 bmdma 0x5048 irq 15
Jul 14 11:12:23 localhost [ 6.245700] ata5.00: ATAPI: TSSTcorpCD/DVDW 
TS-L632D, HH17, max MWDMA2
Jul 14 11:12:23 localhost [ 6.437678] ata5.00: configured for MWDMA2
Jul 14 11:12:23 localhost [ 6.595751] scsi 4:0:0:0: CD-ROM TSSTcorp 
CD/DVDW TS-L632D HH17 PQ: 0 ANSI: 5
Jul 14 11:12:23 localhost [ 6.624413] sr0: scsi3-mmc drive: 24x/24x 
writer dvd-ram cd/rw xa/form2 cdda tray
Jul 14 11:12:23 localhost [ 6.624413] Uniform CD-ROM driver Revision: 3.20
Jul 14 11:12:23 localhost [ 6.624413] sr 4:0:0:0: Attached scsi CD-ROM sr0
Jul 14 11:12:23 localhost [ 6.624413] sr 4:0:0:0: Attached scsi generic 
sg1 type 5
Jul 14 11:12:23 localhost [ 6.625563] I2O subsystem v1.325
Jul 14 11:12:23 localhost [ 6.625567] i2o: max drivers = 8
Jul 14 11:12:23 localhost [ 6.625692] I2O Configuration OSM v1.323
Jul 14 11:12:23 localhost [ 6.625761] I2O Bus Adapter OSM v1.317
Jul 14 11:12:23 localhost [ 6.625792] I2O Block Device OSM v1.325
Jul 14 11:12:23 localhost [ 6.625951] I2O SCSI Peripheral OSM v1.316
Jul 14 11:12:23 localhost [ 6.625978] I2O ProcFS OSM v1.316
Jul 14 11:12:23 localhost [ 6.626017] Fusion MPT base driver 3.04.06
Jul 14 11:12:23 localhost [ 6.626019] Copyright (c) 1999-2007 LSI 
Corporation
Jul 14 11:12:23 localhost [ 6.626024] Fusion MPT SPI Host driver 3.04.06
Jul 14 11:12:23 localhost [ 6.626079] Fusion MPT FC Host driver 3.04.06
Jul 14 11:12:23 localhost [ 6.626129] Fusion MPT SAS Host driver 3.04.06
Jul 14 11:12:23 localhost [ 6.626175] Fusion MPT misc device (ioctl) 
driver 3.04.06
Jul 14 11:12:23 localhost [ 6.626213] mptctl: Registered with Fusion MPT 
base driver
Jul 14 11:12:23 localhost [ 6.626216] mptctl: /dev/mptctl @ 
(major,minor=10,220)
Jul 14 11:12:23 localhost [ 6.626218] Fusion MPT LAN driver 3.04.06
Jul 14 11:12:23 localhost [ 6.626480] ACPI: PCI Interrupt 
0000:02:04.1[B] -> GSI 21 (level, low) -> IRQ 21
Jul 14 11:12:23 localhost [ 6.678422] ohci1394: fw-host0: OHCI-1394 1.1 
(PCI): IRQ=[21] MMIO=[d0101000-d01017ff] Max Packet=[2048] IR/IT 
contexts=[4/4]
Jul 14 11:12:23 localhost [ 6.682657] usbcore: registered new interface 
driver usblp
Jul 14 11:12:23 localhost [ 6.682661] Initializing USB Mass Storage 
driver...
Jul 14 11:12:23 localhost [ 6.682694] usbcore: registered new interface 
driver usb-storage
Jul 14 11:12:23 localhost [ 6.682697] USB Mass Storage support registered.
Jul 14 11:12:23 localhost [ 6.682734] usbcore: registered new interface 
driver libusual
Jul 14 11:12:23 localhost [ 6.682821] PNP: PS/2 Controller 
[PNP0303:C249,PNP0f13:C24A] at 0x60,0x64 irq 1,12
Jul 14 11:12:23 localhost [ 6.685170] i8042.c: Detected active 
multiplexing controller, rev 1.1.
Jul 14 11:12:23 localhost [ 6.685993] serio: i8042 KBD port at 0x60,0x64 
irq 1
Jul 14 11:12:23 localhost [ 6.685997] serio: i8042 AUX0 port at 
0x60,0x64 irq 12
Jul 14 11:12:23 localhost [ 6.686000] serio: i8042 AUX1 port at 
0x60,0x64 irq 12
Jul 14 11:12:23 localhost [ 6.686003] serio: i8042 AUX2 port at 
0x60,0x64 irq 12
Jul 14 11:12:23 localhost [ 6.686005] serio: i8042 AUX3 port at 
0x60,0x64 irq 12
Jul 14 11:12:23 localhost [ 6.693230] parkbd: no such parport
Jul 14 11:12:23 localhost [ 6.696492] mice: PS/2 mouse device common for 
all mice
Jul 14 11:12:23 localhost [ 6.731963] input: AT Translated Set 2 
keyboard as /class/input/input4
Jul 14 11:12:23 localhost [ 6.750185] md: linear personality registered 
for level -1
Jul 14 11:12:23 localhost [ 6.750185] md: raid0 personality registered 
for level 0
Jul 14 11:12:23 localhost [ 6.750185] md: raid1 personality registered 
for level 1
Jul 14 11:12:23 localhost [ 6.750185] md: raid10 personality registered 
for level 10
Jul 14 11:12:23 localhost [ 6.766206] raid6: int64x1 1820 MB/s
Jul 14 11:12:23 localhost [ 6.783200] raid6: int64x2 2390 MB/s
Jul 14 11:12:23 localhost [ 6.800193] raid6: int64x4 2222 MB/s
Jul 14 11:12:23 localhost [ 6.817196] raid6: int64x8 1996 MB/s
Jul 14 11:12:23 localhost [ 6.834174] raid6: sse2x1 2789 MB/s
Jul 14 11:12:23 localhost [ 6.851172] raid6: sse2x2 3730 MB/s
Jul 14 11:12:23 localhost [ 6.868175] raid6: sse2x4 3796 MB/s
Jul 14 11:12:23 localhost [ 6.868177] raid6: using algorithm sse2x4 
(3796 MB/s)
Jul 14 11:12:23 localhost [ 6.868181] md: raid6 personality registered 
for level 6
Jul 14 11:12:23 localhost [ 6.868183] md: raid5 personality registered 
for level 5
Jul 14 11:12:23 localhost [ 6.868185] md: raid4 personality registered 
for level 4
Jul 14 11:12:23 localhost [ 6.868187] md: multipath personality 
registered for level -4
Jul 14 11:12:23 localhost [ 6.868189] md: faulty personality registered 
for level -5
Jul 14 11:12:23 localhost [ 6.868389] device-mapper: ioctl: 4.13.0-ioctl 
(2007-10-18) initialised: dm-devel@redhat.com
Jul 14 11:12:23 localhost [ 6.868651] cpuidle: using governor ladder
Jul 14 11:12:23 localhost [ 6.868949] cpuidle: using governor menu
Jul 14 11:12:23 localhost [ 7.490268] Synaptics Touchpad, model: 1, fw: 
6.2, id: 0x2580b1, caps: 0xa04793/0x300000
Jul 14 11:12:23 localhost [ 7.490273] serio: Synaptics pass-through port 
at isa0060/serio4/input0
Jul 14 11:12:23 localhost [ 7.530585] input: SynPS/2 Synaptics TouchPad 
as /class/input/input5
Jul 14 11:12:23 localhost [ 7.539273] dcdbas dcdbas: Dell Systems 
Management Base Driver (version 5.6.0-3.2)
Jul 14 11:12:23 localhost [ 7.539349] usbcore: registered new interface 
driver hiddev
Jul 14 11:12:23 localhost [ 7.539381] usbcore: registered new interface 
driver usbhid
Jul 14 11:12:23 localhost [ 7.539384] drivers/hid/usbhid/hid-core.c: 
v2.6:USB HID core driver
Jul 14 11:12:23 localhost [ 7.539975] TCP bic registered
Jul 14 11:12:23 localhost [ 7.539991] NET: Registered protocol family 1
Jul 14 11:12:23 localhost [ 7.540005] NET: Registered protocol family 17
Jul 14 11:12:23 localhost [ 7.540181] RPC: Registered udp transport module.
Jul 14 11:12:23 localhost [ 7.540183] RPC: Registered tcp transport module.
Jul 14 11:12:23 localhost [ 7.540196] powernow-k8: Found 1 Mobile AMD 
Sempron(tm) Processor 3600+ processors (1 cpu cores) (version 2.20.00)
Jul 14 11:12:23 localhost [ 7.540233] powernow-k8: 0 : fid 0xc (2000 
MHz), vid 0x10
Jul 14 11:12:23 localhost [ 7.540236] powernow-k8: 1 : fid 0xa (1800 
MHz), vid 0x12
Jul 14 11:12:23 localhost [ 7.540238] powernow-k8: 2 : fid 0x8 (1600 
MHz), vid 0x14
Jul 14 11:12:23 localhost [ 7.540240] powernow-k8: 3 : fid 0x0 (800 
MHz), vid 0x18
Jul 14 11:12:23 localhost [ 7.540266] powernow-k8: ph2 null fid 
transition 0xc
Jul 14 11:12:23 localhost [ 7.540491] registered taskstats version 1
Jul 14 11:12:23 localhost [ 7.540620] drivers/rtc/hctosys.c: unable to 
open rtc device (rtc0)
Jul 14 11:12:23 localhost [ 7.540635] Freeing unused kernel memory: 428k 
freed
Jul 14 11:12:23 localhost [ 7.945187] ieee1394: Host added: 
ID:BUS[0-00:1023] GUID[00023f99295d2f0e]
Jul 14 11:12:23 localhost [ 8.171975] ata1: soft resetting link
Jul 14 11:12:23 localhost [ 8.324961] ata1: SATA link up 1.5 Gbps 
(SStatus 113 SControl 300)
Jul 14 11:12:23 localhost [ 8.325393] ata1.00: SB600 AHCI: limiting to 
255 sectors per cmd
Jul 14 11:12:23 localhost [ 8.325929] ata1.00: SB600 AHCI: limiting to 
255 sectors per cmd
Jul 14 11:12:23 localhost [ 8.325932] ata1.00: configured for UDMA/100
Jul 14 11:12:23 localhost [ 8.325936] ata1: EH complete
Jul 14 11:12:23 localhost [ 8.325978] sd 0:0:0:0: [sda] 156301488 
512-byte hardware sectors (80026 MB)
Jul 14 11:12:23 localhost [ 8.325991] sd 0:0:0:0: [sda] Write Protect is off
Jul 14 11:12:23 localhost [ 8.325993] sd 0:0:0:0: [sda] Mode Sense: 00 
3a 00 00
Jul 14 11:12:23 localhost [ 8.326011] sd 0:0:0:0: [sda] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Jul 14 11:12:23 localhost [ 8.541019] ACPI: PCI Interrupt 
0000:00:13.5[D] -> GSI 23 (level, low) -> IRQ 23
Jul 14 11:12:23 localhost [ 8.541035] ehci_hcd 0000:00:13.5: EHCI Host 
Controller
Jul 14 11:12:23 localhost [ 8.541168] ehci_hcd 0000:00:13.5: new USB bus 
registered, assigned bus number 1
Jul 14 11:12:23 localhost [ 8.541216] ehci_hcd 0000:00:13.5: debug port 1
Jul 14 11:12:23 localhost [ 8.541232] ehci_hcd 0000:00:13.5: irq 23, io 
mem 0xd0606000
Jul 14 11:12:23 localhost [ 8.546919] ehci_hcd 0000:00:13.5: USB 2.0 
started, EHCI 1.00, driver 10 Dec 2004
Jul 14 11:12:23 localhost [ 8.547108] usb usb1: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 8.547153] hub 1-0:1.0: USB hub found
Jul 14 11:12:23 localhost [ 8.547162] hub 1-0:1.0: 10 ports detected
Jul 14 11:12:23 localhost [ 8.688424] USB Universal Host Controller 
Interface driver v3.0
Jul 14 11:12:23 localhost [ 8.788190] sl811: driver sl811-hcd, 19 May 2005
Jul 14 11:12:23 localhost [ 8.802923] hub 1-0:1.0: unable to enumerate 
USB device on port 3
Jul 14 11:12:23 localhost [ 9.008884] hub 1-0:1.0: unable to enumerate 
USB device on port 5
Jul 14 11:12:23 localhost [ 9.148467] Intel(R) PRO/1000 Network Driver - 
version 7.3.20-k2
Jul 14 11:12:23 localhost [ 9.148471] Copyright (c) 1999-2006 Intel 
Corporation.
Jul 14 11:12:23 localhost [ 9.177026] tg3.c:v3.91 (April 18, 2008)
Jul 14 11:12:23 localhost [ 9.177086] ACPI: PCI Interrupt 
0000:10:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Jul 14 11:12:23 localhost [ 9.177096] PCI: Setting latency timer of 
device 0000:10:00.0 to 64
Jul 14 11:12:23 localhost [ 9.384458] eth0: Tigon3 [partno(none) rev 
b002 PHY(5787)] (PCI Express) 10/100/1000Base-T Ethernet 00:1a:4b:58:56:fe
Jul 14 11:12:23 localhost [ 9.384463] eth0: RXcsums[1] LinkChgREG[0] 
MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
Jul 14 11:12:23 localhost [ 9.384467] eth0: dma_rwctrl[76180000] 
dma_mask[64-bit]
Jul 14 11:12:23 localhost [ 20.472144] fbcondecor: console 0 using theme 
'sabayon'
Jul 14 11:12:23 localhost [ 20.566664] fbcondecor: switched decor state 
to 'on' on console 0
Jul 14 11:12:23 localhost [ 22.737510] TuxOnIce: Normal swapspace found.
Jul 14 11:12:23 localhost [ 22.745947] TuxOnIce: Failed to initialise 
the lzf compression transform.
Jul 14 11:12:23 localhost [ 22.801255] kjournald starting. Commit 
interval 5 seconds
Jul 14 11:12:23 localhost [ 22.801266] EXT3-fs: mounted filesystem with 
ordered data mode.
Jul 14 11:12:23 localhost [ 26.177341] pci_hotplug: PCI Hot Plug PCI 
Core version: 0.5
Jul 14 11:12:23 localhost [ 26.198376] shpchp: Standard Hot Plug PCI 
Controller Driver version: 0.4
Jul 14 11:12:23 localhost [ 26.434516] ACPI: device:03 is registered as 
cooling_device5
Jul 14 11:12:23 localhost [ 26.435581] input: Video Bus as 
/class/input/input6
Jul 14 11:12:23 localhost [ 26.443355] ACPI: Video Device [C08D] 
(multi-head: yes rom: no post: no)
Jul 14 11:12:23 localhost [ 26.817183] fglrx: no version for 
"struct_module" found: kernel tainted.
Jul 14 11:12:23 localhost [ 26.820396] fglrx: module license 
'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints 
kernel.
Jul 14 11:12:23 localhost [ 26.844750] [fglrx] vendor: 1002 device: 791f 
count: 1
Jul 14 11:12:23 localhost [ 26.844841] [fglrx] Maximum main memory to 
use for locked dma buffers: 1760 MBytes.
Jul 14 11:12:23 localhost [ 26.844999] [fglrx] PAT is enabled successfully!
Jul 14 11:12:23 localhost [ 26.845031] [fglrx] module loaded - fglrx 
8.50.3 [Jun 2 2008] with 1 minors
Jul 14 11:12:23 localhost [ 26.845282] ACPI: PCI Interrupt 
0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
Jul 14 11:12:23 localhost [ 26.845292] PCI: Setting latency timer of 
device 0000:30:00.0 to 64
Jul 14 11:12:23 localhost [ 26.853175] ssb: Core 0 found: ChipCommon (cc 
0x800, rev 0x13, vendor 0x4243)
Jul 14 11:12:23 localhost [ 26.853184] ssb: Core 1 found: IEEE 802.11 
(cc 0x812, rev 0x0D, vendor 0x4243)
Jul 14 11:12:23 localhost [ 26.853192] ssb: Core 2 found: USB 1.1 Host 
(cc 0x817, rev 0x04, vendor 0x4243)
Jul 14 11:12:23 localhost [ 26.853201] ssb: Core 3 found: PCI-E (cc 
0x820, rev 0x05, vendor 0x4243)
Jul 14 11:12:23 localhost [ 26.862907] ssb: SPROM revision 3 detected.
Jul 14 11:12:23 localhost [ 26.870213] ssb: Sonics Silicon Backplane 
found on PCI device 0000:30:00.0
Jul 14 11:12:23 localhost [ 26.907282] ohci_hcd: 2006 August 04 USB 1.1 
'Open' Host Controller (OHCI) Driver
Jul 14 11:12:23 localhost [ 26.907322] ACPI: PCI Interrupt 
0000:00:13.0[A] -> GSI 23 (level, low) -> IRQ 23
Jul 14 11:12:23 localhost [ 26.907338] ohci_hcd 0000:00:13.0: OHCI Host 
Controller
Jul 14 11:12:23 localhost [ 26.907406] ohci_hcd 0000:00:13.0: new USB 
bus registered, assigned bus number 2
Jul 14 11:12:23 localhost [ 26.907428] ohci_hcd 0000:00:13.0: irq 23, io 
mem 0xd0601000
Jul 14 11:12:23 localhost [ 26.962276] usb usb2: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 26.962306] hub 2-0:1.0: USB hub found
Jul 14 11:12:23 localhost [ 26.962322] hub 2-0:1.0: 2 ports detected
Jul 14 11:12:23 localhost [ 27.063239] piix4_smbus 0000:00:14.0: Found 
0000:00:14.0 device
Jul 14 11:12:23 localhost [ 27.063335] ACPI: PCI Interrupt 
0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
Jul 14 11:12:23 localhost [ 27.063354] ohci_hcd 0000:00:13.1: OHCI Host 
Controller
Jul 14 11:12:23 localhost [ 27.063411] ohci_hcd 0000:00:13.1: new USB 
bus registered, assigned bus number 3
Jul 14 11:12:23 localhost [ 27.063439] ohci_hcd 0000:00:13.1: irq 17, io 
mem 0xd0602000
Jul 14 11:12:23 localhost [ 27.119439] usb usb3: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 27.119470] hub 3-0:1.0: USB hub found
Jul 14 11:12:23 localhost [ 27.119486] hub 3-0:1.0: 2 ports detected
Jul 14 11:12:23 localhost [ 27.212536] input: PC Speaker as 
/class/input/input7
Jul 14 11:12:23 localhost [ 27.220235] ACPI: PCI Interrupt 
0000:00:13.2[C] -> GSI 17 (level, low) -> IRQ 17
Jul 14 11:12:23 localhost [ 27.220255] ohci_hcd 0000:00:13.2: OHCI Host 
Controller
Jul 14 11:12:23 localhost [ 27.220315] ohci_hcd 0000:00:13.2: new USB 
bus registered, assigned bus number 4
Jul 14 11:12:23 localhost [ 27.220337] ohci_hcd 0000:00:13.2: irq 17, io 
mem 0xd0603000
Jul 14 11:12:23 localhost [ 27.275288] usb usb4: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 27.275322] hub 4-0:1.0: USB hub found
Jul 14 11:12:23 localhost [ 27.275338] hub 4-0:1.0: 2 ports detected
Jul 14 11:12:23 localhost [ 27.285095] hub 1-0:1.0: unable to enumerate 
USB device on port 3
Jul 14 11:12:23 localhost [ 27.384360] ACPI: PCI Interrupt 
0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
Jul 14 11:12:23 localhost [ 27.385289] tpm_inf_pnp 00:03: Found C231 
with ID IFX0102
Jul 14 11:12:23 localhost [ 27.385343] tpm_inf_pnp 00:03: TPM found: 
config base 0x520, data base 0x530, chip version 0x000b, vendor id 
0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
Jul 14 11:12:23 localhost [ 27.455295] ACPI: PCI Interrupt 
0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
Jul 14 11:12:23 localhost [ 27.455316] ohci_hcd 0000:00:13.3: OHCI Host 
Controller
Jul 14 11:12:23 localhost [ 27.455384] ohci_hcd 0000:00:13.3: new USB 
bus registered, assigned bus number 5
Jul 14 11:12:23 localhost [ 27.455406] ohci_hcd 0000:00:13.3: irq 17, io 
mem 0xd0604000
Jul 14 11:12:23 localhost [ 27.491062] hub 1-0:1.0: unable to enumerate 
USB device on port 5
Jul 14 11:12:23 localhost [ 27.510213] usb usb5: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 27.510244] hub 5-0:1.0: USB hub found
Jul 14 11:12:23 localhost [ 27.510260] hub 5-0:1.0: 2 ports detected
Jul 14 11:12:23 localhost [ 27.625434] ACPI: PCI Interrupt 
0000:00:13.4[C] -> GSI 17 (level, low) -> IRQ 17
Jul 14 11:12:23 localhost [ 27.625454] ohci_hcd 0000:00:13.4: OHCI Host 
Controller
Jul 14 11:12:23 localhost [ 27.625519] ohci_hcd 0000:00:13.4: new USB 
bus registered, assigned bus number 6
Jul 14 11:12:23 localhost [ 27.625541] ohci_hcd 0000:00:13.4: irq 17, io 
mem 0xd0605000
Jul 14 11:12:23 localhost [ 27.665929] b43-phy0: Broadcom 4311 WLAN found
Jul 14 11:12:23 localhost [ 27.680198] usb usb6: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 27.680233] hub 6-0:1.0: USB hub found
Jul 14 11:12:23 localhost [ 27.680249] hub 6-0:1.0: 2 ports detected
Jul 14 11:12:23 localhost [ 27.691825] phy0: Selected rate control 
algorithm 'pid'
Jul 14 11:12:23 localhost [ 27.714970] Broadcom 43xx driver loaded [ 
Features: PMLR, Firmware-ID: FW13 ]
Jul 14 11:12:23 localhost [ 27.768012] usb 3-1: new low speed USB device 
using ohci_hcd and address 2
Jul 14 11:12:23 localhost [ 27.800454] Yenta: CardBus bridge found at 
0000:02:04.0 [103c:30c2]
Jul 14 11:12:23 localhost [ 27.930862] Yenta: ISA IRQ mask 0x0cb8, PCI 
irq 20
Jul 14 11:12:23 localhost [ 27.930867] Socket status: 30000006
Jul 14 11:12:23 localhost [ 27.930870] Yenta: Raising subordinate bus# 
of parent bus (#02) from #03 to #06
Jul 14 11:12:23 localhost [ 27.930876] pcmcia: parent PCI bridge I/O 
window: 0x1000 - 0x1fff
Jul 14 11:12:23 localhost [ 27.930880] pcmcia: parent PCI bridge Memory 
window: 0xd0100000 - 0xd03fffff
Jul 14 11:12:23 localhost [ 27.930884] pcmcia: parent PCI bridge Memory 
window: 0x88000000 - 0x8bffffff
Jul 14 11:12:23 localhost [ 27.968265] usb 3-1: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 27.975373] input: Microsoft Microsoft 
5-Button Mouse with IntelliEye(TM) as /class/input/input8
Jul 14 11:12:23 localhost [ 27.984034] input,hidraw0: USB HID v1.10 
Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on 
usb-0000:00:13.1-1
Jul 14 11:12:23 localhost [ 28.260930] usb 4-1: new full speed USB 
device using ohci_hcd and address 2
Jul 14 11:12:23 localhost [ 28.463250] usb 4-1: configuration #1 chosen 
from 1 choice
Jul 14 11:12:23 localhost [ 37.887605] EXT3 FS on sda5, internal journal
Jul 14 11:12:23 localhost [ 38.384389] kjournald starting. Commit 
interval 5 seconds
Jul 14 11:12:23 localhost [ 38.384892] EXT3 FS on sda1, internal journal
Jul 14 11:12:23 localhost [ 38.384897] EXT3-fs: mounted filesystem with 
ordered data mode.
Jul 14 11:12:23 localhost [ 46.201074] Adding 1397612k swap on 
/dev/sda6. Priority:-1 extents:1 across:1397612k
Jul 14 11:12:23 localhost [ 49.022502] ACPI: PCI Interrupt 
0000:01:05.0[B] -> GSI 19 (level, low) -> IRQ 19
Jul 14 11:12:23 localhost [ 51.539994] [fglrx] GART Table is not in 
FRAME_BUFFER range
Jul 14 11:12:23 localhost [ 51.546717] [fglrx] Reserved FB block: Shared 
offset:0, size:1000000
Jul 14 11:12:23 localhost [ 51.546722] [fglrx] Reserved FB block: 
Unshared offset:7ffb000, size:5000
Jul 14 11:12:24 localhost NetworkManager: <info> starting...
Jul 14 11:12:25 localhost NetworkManager: <info> New VPN service 
'openvpn' (org.freedesktop.NetworkManager.openvpn).
Jul 14 11:12:25 localhost NetworkManager: <info> New VPN service 'vpnc' 
(org.freedesktop.NetworkManager.vpnc).
Jul 14 11:12:25 localhost [ 58.144095] input: b43-phy0 as 
/class/input/input9
Jul 14 11:12:25 localhost [ 58.510340] b43-phy0: Loading firmware 
version 410.2160 (2007-05-26 15:32:10)
Jul 14 11:12:26 localhost rpc.statd[11155]: Version 1.1.2 Starting
Jul 14 11:12:26 localhost rpc.statd[11155]: Flags:
Jul 14 11:12:27 localhost [ 60.105033] Registered led device: b43-phy0::tx
Jul 14 11:12:27 localhost [ 60.105245] Registered led device: b43-phy0::rx
Jul 14 11:12:27 localhost [ 60.105337] Registered led device: 
b43-phy0::radio
Jul 14 11:12:27 localhost [ 60.105408] b43-phy0 ERROR: PHY transmission 
error
Jul 14 11:12:27 localhost NetworkManager: <debug> [1216033947.243399] 
GentooReadConfig(): Enabling DHCP for device wlan0.
Jul 14 11:12:27 localhost NetworkManager: <debug> [1216033947.243537] 
GentooReadConfig(): Found hostname.
Jul 14 11:12:27 localhost NetworkManager: nm_ip4_config_set_hostname: 
assertion `config != NULL' failed
Jul 14 11:12:27 localhost NetworkManager: <info> wlan0: Device is 
fully-supported using driver '(null)'.
Jul 14 11:12:27 localhost NetworkManager: <info> wlan0: driver supports 
SSID scans (scan_capa 0x01).
Jul 14 11:12:27 localhost NetworkManager: <info> nm_device_init(): 
waiting for device's worker thread to start
Jul 14 11:12:27 localhost NetworkManager: <info> nm_device_init(): 
device's worker thread started, continuing.
Jul 14 11:12:27 localhost NetworkManager: <info> Now managing wireless 
(802.11) device 'wlan0'.
Jul 14 11:12:27 localhost NetworkManager: <info> Deactivating device wlan0.
Jul 14 11:12:27 localhost [ 60.497877] warning: `avahi-daemon' uses 
32-bit capabilities (legacy support in use)
Jul 14 11:12:27 localhost avahi-daemon[11181]: Found user 'avahi' (UID 
108) and group 'avahi' (GID 444).
Jul 14 11:12:27 localhost avahi-daemon[11181]: Successfully dropped root 
privileges.
Jul 14 11:12:27 localhost avahi-daemon[11181]: avahi-daemon 0.6.22 
starting up.
Jul 14 11:12:27 localhost avahi-daemon[11181]: Successfully called chroot().
Jul 14 11:12:27 localhost avahi-daemon[11181]: Successfully dropped 
remaining capabilities.
Jul 14 11:12:28 localhost avahi-daemon[11182]: chroot.c: open() failed: 
No such file or directory
Jul 14 11:12:28 localhost avahi-daemon[11181]: Failed to open 
/etc/resolv.conf: Invalid argument
Jul 14 11:12:28 localhost avahi-daemon[11181]: Loading service file 
/services/sftp-ssh.service.
Jul 14 11:12:28 localhost avahi-daemon[11181]: Loading service file 
/services/ssh.service.
Jul 14 11:12:28 localhost [ 61.152777] NET: Registered protocol family 10
Jul 14 11:12:28 localhost [ 61.153792] lo: Disabled Privacy Extensions
Jul 14 11:12:28 localhost [ 61.155452] ADDRCONF(NETDEV_UP): wlan0: link 
is not ready
Jul 14 11:12:28 localhost avahi-daemon[11181]: System host name is set 
to 'localhost'. This is not a suitable mDNS host name, looking for 
alternatives.
Jul 14 11:12:28 localhost avahi-daemon[11181]: Network interface 
enumeration completed.
Jul 14 11:12:28 localhost avahi-daemon[11181]: Registering HINFO record 
with values 'X86_64'/'LINUX'.
Jul 14 11:12:28 localhost avahi-daemon[11181]: Server startup complete. 
Host name is linux.local. Local service cookie is 1695439168.
Jul 14 11:12:28 localhost avahi-daemon[11181]: Service "linux" 
(/services/ssh.service) successfully established.
Jul 14 11:12:28 localhost avahi-daemon[11181]: Service "SFTP File 
Transfer on linux" (/services/sftp-ssh.service) successfully established.
Jul 14 11:12:29 localhost [ 62.225181] ADDRCONF(NETDEV_UP): eth0: link 
is not ready
Jul 14 11:12:29 localhost NetworkManager: <debug> [1216033949.332147] 
GentooReadConfig(): Enabling DHCP for device eth0.
Jul 14 11:12:29 localhost NetworkManager: <debug> [1216033949.332401] 
GentooReadConfig(): Found hostname.
Jul 14 11:12:29 localhost NetworkManager: nm_ip4_config_set_hostname: 
assertion `config != NULL' failed
Jul 14 11:12:29 localhost NetworkManager: <info> eth0: Device is 
fully-supported using driver '(null)'.
Jul 14 11:12:29 localhost NetworkManager: <info> nm_device_init(): 
waiting for device's worker thread to start
Jul 14 11:12:29 localhost NetworkManager: <info> nm_device_init(): 
device's worker thread started, continuing.
Jul 14 11:12:29 localhost NetworkManager: <info> Now managing wired 
Ethernet (802.3) device 'eth0'.
Jul 14 11:12:29 localhost NetworkManager: <info> Deactivating device eth0.
Jul 14 11:12:29 localhost NetworkManager: <info> Will activate wired 
connection 'eth0' because it now has a link.
Jul 14 11:12:29 localhost NetworkManager: <debug> [1216033949.341104] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/computer_logicaldev_input_4').
Jul 14 11:12:29 localhost [ 62.680557] NFSD: Using 
/var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Jul 14 11:12:29 localhost [ 62.680743] NFSD: starting 90-second grace period
Jul 14 11:12:30 localhost [ 63.778053] tg3: eth0: Link is up at 100 
Mbps, full duplex.
Jul 14 11:12:30 localhost [ 63.778058] tg3: eth0: Flow control is on for 
TX and on for RX.
Jul 14 11:12:30 localhost [ 63.778668] ADDRCONF(NETDEV_CHANGE): eth0: 
link becomes ready
Jul 14 11:12:30 localhost NetworkManager: <info> Will activate wired 
connection 'eth0' because it now has a link.
Jul 14 11:12:30 localhost NetworkManager: <info> SWITCH: no current 
connection, found better connection 'eth0'.
Jul 14 11:12:30 localhost NetworkManager: <info> Will activate 
connection 'eth0'.
Jul 14 11:12:30 localhost NetworkManager: <info> Device eth0 activation 
scheduled...
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) 
started...
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
1 of 5 (Device Prepare) scheduled...
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
1 of 5 (Device Prepare) started...
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
2 of 5 (Device Configure) scheduled...
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
1 of 5 (Device Prepare) complete.
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
2 of 5 (Device Configure) starting...
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
2 of 5 (Device Configure) successful.
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
3 of 5 (IP Configure Start) scheduled.
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
2 of 5 (Device Configure) complete.
Jul 14 11:12:30 localhost NetworkManager: <info> Activation (eth0) Stage 
3 of 5 (IP Configure Start) started...
Jul 14 11:12:30 localhost dhcdbd: message_handler: message handler not 
found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
Jul 14 11:12:31 localhost [ 64.537597] fbcondecor: console 1 using theme 
'sabayon'
Jul 14 11:12:31 localhost [ 64.725655] fbcondecor: switched decor state 
to 'on' on console 1
Jul 14 11:12:31 localhost NetworkManager: <info> Activation (eth0) 
Beginning DHCP transaction.
Jul 14 11:12:31 localhost avahi-daemon[11181]: Joining mDNS multicast 
group on interface eth0.IPv6 with address fe80::21a:4bff:fe58:56fe.
Jul 14 11:12:31 localhost avahi-daemon[11181]: New relevant interface 
eth0.IPv6 for mDNS.
Jul 14 11:12:31 localhost avahi-daemon[11181]: Registering new address 
record for fe80::21a:4bff:fe58:56fe on eth0.*.
Jul 14 11:12:31 localhost NetworkManager: <info> Activation (eth0) Stage 
3 of 5 (IP Configure Start) complete.
Jul 14 11:12:31 localhost NetworkManager: <info> DHCP daemon state is 
now 12 (successfully started) for interface eth0
Jul 14 11:12:31 localhost dhclient: wmaster0: unknown hardware address 
type 801
Jul 14 11:12:31 localhost [ 64.887052] fbcondecor: console 2 using theme 
'sabayon'
Jul 14 11:12:32 localhost [ 65.066425] fbcondecor: switched decor state 
to 'on' on console 2
Jul 14 11:12:32 localhost [ 65.303157] fbcondecor: console 3 using theme 
'sabayon'
Jul 14 11:12:32 localhost [ 65.501345] fbcondecor: switched decor state 
to 'on' on console 3
Jul 14 11:12:32 localhost [ 65.749552] fbcondecor: console 4 using theme 
'sabayon'
Jul 14 11:12:33 localhost [ 65.930928] fbcondecor: switched decor state 
to 'on' on console 4
Jul 14 11:12:33 localhost NetworkManager: <info> DHCP daemon state is 
now 1 (starting) for interface eth0
Jul 14 11:12:33 localhost dhclient: wmaster0: unknown hardware address 
type 801
Jul 14 11:12:33 localhost [ 66.130474] fbcondecor: console 5 using theme 
'sabayon'
Jul 14 11:12:33 localhost [ 66.315604] fbcondecor: switched decor state 
to 'on' on console 5
Jul 14 11:12:33 localhost /etc/init.d/alsasound[11375]: No mixer config 
in /var/lib/alsa/asound.state, you have to unmute your card!
Jul 14 11:12:36 localhost dhclient: option_space_encapsulate: option 
space agent does not exist, but is configured.
Jul 14 11:12:36 localhost dhclient: DHCPDISCOVER on eth0 to 
255.255.255.255 port 67 interval 8
Jul 14 11:12:36 localhost dhclient: DHCPOFFER from 10.0.0.6
Jul 14 11:12:36 localhost dhclient: option_space_encapsulate: option 
space agent does not exist, but is configured.
Jul 14 11:12:36 localhost dhclient: DHCPREQUEST on eth0 to 
255.255.255.255 port 67
Jul 14 11:12:36 localhost dhclient: DHCPACK from 10.0.0.6
Jul 14 11:12:36 localhost avahi-daemon[11181]: Joining mDNS multicast 
group on interface eth0.IPv4 with address 10.0.5.203.
Jul 14 11:12:36 localhost avahi-daemon[11181]: New relevant interface 
eth0.IPv4 for mDNS.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Registering new address 
record for 10.0.5.203 on eth0.IPv4.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Withdrawing address 
record for 10.0.5.203 on eth0.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Leaving mDNS multicast 
group on interface eth0.IPv4 with address 10.0.5.203.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Interface eth0.IPv4 no 
longer relevant for mDNS.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Joining mDNS multicast 
group on interface eth0.IPv4 with address 10.0.5.203.
Jul 14 11:12:36 localhost avahi-daemon[11181]: New relevant interface 
eth0.IPv4 for mDNS.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Registering new address 
record for 10.0.5.203 on eth0.IPv4.
Jul 14 11:12:36 localhost NetworkManager: <info> DHCP daemon state is 
now 2 (bound) for interface eth0
Jul 14 11:12:36 localhost NetworkManager: <info> Activation (eth0) Stage 
4 of 5 (IP Configure Get) scheduled...
Jul 14 11:12:36 localhost NetworkManager: <info> Activation (eth0) Stage 
4 of 5 (IP Configure Get) started...
Jul 14 11:12:36 localhost dhclient: bound to 10.0.5.203 -- renewal in 
3403 seconds.
Jul 14 11:12:36 localhost dhcdbd: message_handler: message handler not 
found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_domain
Jul 14 11:12:36 localhost dhcdbd: message_handler: message handler not 
found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_servers
Jul 14 11:12:36 localhost NetworkManager: <info> Retrieved the following 
IP4 configuration from the DHCP daemon:
Jul 14 11:12:36 localhost NetworkManager: <info> address 10.0.5.203
Jul 14 11:12:36 localhost NetworkManager: <info> netmask 255.255.0.0
Jul 14 11:12:36 localhost NetworkManager: <info> broadcast 10.0.255.255
Jul 14 11:12:36 localhost NetworkManager: <info> gateway 10.0.0.1
Jul 14 11:12:36 localhost NetworkManager: <info> nameserver 10.0.0.192
Jul 14 11:12:36 localhost NetworkManager: <info> nameserver 10.0.0.14
Jul 14 11:12:36 localhost NetworkManager: <info> nameserver 10.0.0.250
Jul 14 11:12:36 localhost NetworkManager: <info> hostname 'localhost'
Jul 14 11:12:36 localhost NetworkManager: <info> domain name 
'cambridgebroadband.com'
Jul 14 11:12:36 localhost dhcdbd: message_handler: message handler not 
found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.interface_mtu
Jul 14 11:12:36 localhost NetworkManager: <info> Activation (eth0) Stage 
5 of 5 (IP Configure Commit) scheduled...
Jul 14 11:12:36 localhost NetworkManager: <info> Activation (eth0) Stage 
4 of 5 (IP Configure Get) complete.
Jul 14 11:12:36 localhost NetworkManager: <info> Activation (eth0) Stage 
5 of 5 (IP Configure Commit) started...
Jul 14 11:12:36 localhost avahi-daemon[11181]: Withdrawing address 
record for 10.0.5.203 on eth0.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Leaving mDNS multicast 
group on interface eth0.IPv4 with address 10.0.5.203.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Interface eth0.IPv4 no 
longer relevant for mDNS.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Withdrawing address 
record for fe80::21a:4bff:fe58:56fe on eth0.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Leaving mDNS multicast 
group on interface eth0.IPv6 with address fe80::21a:4bff:fe58:56fe.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Interface eth0.IPv6 no 
longer relevant for mDNS.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Joining mDNS multicast 
group on interface eth0.IPv4 with address 10.0.5.203.
Jul 14 11:12:36 localhost avahi-daemon[11181]: New relevant interface 
eth0.IPv4 for mDNS.
Jul 14 11:12:36 localhost avahi-daemon[11181]: Registering new address 
record for 10.0.5.203 on eth0.IPv4.
Jul 14 11:12:37 localhost sshd[11500]: Server listening on :: port 22.
Jul 14 11:12:37 localhost sshd[11500]: Server listening on 0.0.0.0 port 22.
Jul 14 11:12:37 localhost cron[11536]: (CRON) STARTUP (V5.0)
Jul 14 11:12:37 localhost NetworkManager: <info> Old device 'eth0' 
activating, won't change.
Jul 14 11:12:37 localhost NetworkManager: <info> Activation (eth0) 
successful, device activated.
Jul 14 11:12:37 localhost NetworkManager: <info> Activation (eth0) 
Finish handler scheduled.
Jul 14 11:12:37 localhost NetworkManager: <info> Activation (eth0) Stage 
5 of 5 (IP Configure Commit) complete.

