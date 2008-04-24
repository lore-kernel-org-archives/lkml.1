Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYDXUi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYDXUi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbYDXUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:38:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:54808 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756808AbYDXUhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:37:53 -0400
Cc: linux-kernel@vger.kernel.org, airlied@gmail.com, g.liakhovetski@gmx.de
Content-Type: multipart/mixed; boundary="========GMX76921209069470827897"
Date: Thu, 24 Apr 2008 22:37:50 +0200
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <6101e8c40804240940p7960378ak4e563f3c24be06e8@mail.gmail.com>
Message-ID: <20080424203750.76920@gmx.net>
MIME-Version: 1.0
References: <47E82D68.5070305@imap.cc>	
 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>	
 <47E83D14.8070800@imap.cc>	
 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>	
 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>	
 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>	
 <20080406143434.106940@gmx.net>	
 <21d7e9970804071527g14402783j26bfdbd2beb1b026@mail.gmail.com>	
 <Pine.LNX.4.64.0804082256270.4987@axis700.grange>	
 <20080409085435.232570@gmx.net>
 <6101e8c40804240940p7960378ak4e563f3c24be06e8@mail.gmail.com>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
To: "Oliver Pinter" <oliver.pntr@gmail.com>
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18bv8MmlZobC9NuQAy1gIORDbEwNUmgl62TBSw5oW
 UNO/G4901lYm3W5no+aod7TE/0vdIu4HaFAw== 
X-GMX-UID: qNoicDstPjl+GBs+azU2t3c7MTE2NcmC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX76921209069470827897
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

-------- Original-Nachricht --------
> Datum: Thu, 24 Apr 2008 18:40:02 +0200
> Von: "Oliver Pinter" <oliver.pntr@gmail.com>
> An: "Gerhard Pircher" <gerhard_pircher@gmx.net>
> CC: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>, airlied@gmail.com,
> linux-kernel@vger.kernel.org
> Betreff: Re: [2.6.25-rc6] possible regression: X server dying

> On 4/9/08, Gerhard Pircher <gerhard_pircher@gmx.net> wrote:
> >
> > -------- Original-Nachricht --------
> > > Datum: Tue, 8 Apr 2008 23:01:26 +0200 (CEST)
> > > Von: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > An: Dave Airlie <airlied@gmail.com>
> > > CC: Gerhard Pircher <gerhard_pircher@gmx.net>,
> > > linux-kernel@vger.kernel.org
> > > Betreff: Re: [2.6.25-rc6] possible regression: X server dying
> >
> > > On Tue, 8 Apr 2008, Dave Airlie wrote:
> > >
> > > > On Mon, Apr 7, 2008 at 12:34 AM, Gerhard Pircher
> > > > <gerhard_pircher@gmx.net> wrote:
> > > > >
> > > > >  Sorry for hijacking this thread, but I have a similar problem
> > > > >  with the Xorg X server. I'm using kernel 2.6.25-rc8 on my
> > > > >  AmigaOne (PowerPC) and the X server dies right on startup, but
> > > > >  only if DRI/DRM is enabled. I tested this with both Xorg 7.1
> > > > >  (Debian Etch version) and Xorg 7.2 (Lenny). The X server was
> > > > >  working fine with kernel 2.6.25-rc6. I have to mention that the
> > > > >  AmigaOne uses uncached memory for DMA operations. Benjamin
> > > > >  Herrenschmidt fixed DRI recently for non cache coherent systems
> > > > >  and his patches are working fine (I applied them to kernel
> > > > >  2.6.25-rc6).
> > > > >  Please take a look at the attached Xorg.0.log file or at the
> > > > >  excerpt below:
> > >
> > > Hm, so looks like I'm not seeing some ghosts on mine either.
> > > 2.6.25-rc8 xorg runs under etch, but enters a tight (no syscalls)
> > > loop woth 100% CPU load under lenny. A 2.6.24 based kernel works
> > > under both etch and lenny...
> > Strange! I guess I should recompile the kernel and test again. :(
> > I also experienced a high load under Lenny, but IIRC this showed up
> > under an older kernel (2.6.18), too (after X server is started,
> > standard installation, no additional packages).
> 
> i have too this problem, the Xserver is dieing, but undependent from
> kernel version, i think it is a xserver problem
> 
> Package: xserver-xorg-video-ati
> Priority: optional
> Section: x11
> Installed-Size: 880
> <>
> Architecture: i386
> Version: 1:6.6.3-2
> 
> under etch and 2.6.22.22 and 2.6.24.y kernel is ok
> under lenny and 2.6.22.22 or 2.6.24.y or 2.6.25, in first start the
> xserver crashed
It looks like one of these patches fixes the crash of the X server on my
machine (applied on v2.6.25 release):
http://lkml.org/lkml/2008/4/19/244
http://lkml.org/lkml/2008/4/19/243

Also system load seems to be lower. The only problem is that the X server
heavily crashes on shutdown (resp. when executing /etc/init.d/gdm stop)
now. Even the console gets corrupted. I attached the kernel log file that
shows the kernel oopses.

regards,

Gerhard
-- 
GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/?mc=sv_ext_mf@gmx

--========GMX76921209069470827897
Content-Type: text/x-log; charset="iso-8859-15"; name="xorg_crash.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="xorg_crash.log"

 -> early_init_devtree(c0bef300)
search "chosen", depth: 0, uname: 
search "chosen", depth: 1, uname: cpus
search "chosen", depth: 2, uname: cpu@0
search "chosen", depth: 1, uname: memory
search "chosen", depth: 1, uname: pci@80000000
search "chosen", depth: 2, uname: host@0
search "chosen", depth: 2, uname: isa@7
search "chosen", depth: 3, uname: dma-controller@0
search "chosen", depth: 3, uname: interrupt-controller@20
search "chosen", depth: 3, uname: timer@40
search "chosen", depth: 3, uname: 8042@60
search "chosen", depth: 4, uname: keyboard@0
search "chosen", depth: 4, uname: mouse@1
search "chosen", depth: 3, uname: rtc@70
search "chosen", depth: 3, uname: serial@3f8
search "chosen", depth: 3, uname: serial@2f8
search "chosen", depth: 3, uname: parallel@378
search "chosen", depth: 3, uname: fdc@3f0
search "chosen", depth: 4, uname: disk@0
search "chosen", depth: 2, uname: ide@7,1
search "chosen", depth: 1, uname: chosen
Looking for initrd properties... <3>initrd_start=0x0  initrd_end=0x0
Command line is: initcall_debug driver_debug debug root=/dev/hda12 console=tty0 ide0=ata66 ide1=ata66
dt_root_size_cells = 1
dt_root_addr_cells = 1
memory scan node memory, reg size 8, data: 0 60000000 2 1,
 - 0 ,  60000000
Phys. mem: 60000000
-> move_device_tree
<- move_device_tree
Scanning CPUs ...
boot cpu: logical 0 physical 0
 <- early_init_devtree()
Using AmigaOne machine description
Total memory = 1536MB; using 4096kB for hash table (at cfc00000)
Linux version 2.6.25 (geri@earth) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #99 Thu Apr 24 20:26:20 CEST 2008
 -> unflatten_device_tree()
  size is 10c4, allocating...
  unflattening efffef38...
fixed up name for  -> 
fixed up name for cpus -> cpus
fixed up name for cpu@0 -> cpu
fixed up name for memory -> memory
fixed up name for pci@80000000 -> pci
fixed up name for host@0 -> host
fixed up name for isa@7 -> isa
fixed up name for dma-controller@0 -> dma-controller
fixed up name for interrupt-controller@20 -> interrupt-controller
fixed up name for timer@40 -> timer
fixed up name for 8042@60 -> 8042
fixed up name for keyboard@0 -> keyboard
fixed up name for mouse@1 -> mouse
fixed up name for rtc@70 -> rtc
fixed up name for serial@3f8 -> serial
fixed up name for serial@2f8 -> serial
fixed up name for parallel@378 -> parallel
fixed up name for fdc@3f0 -> fdc
fixed up name for disk@0 -> disk
fixed up name for ide@7,1 -> ide
fixed up name for chosen -> chosen
 <- unflatten_device_tree()
 -> find_legacy_serial_port()
stdout is /pci@80000000/isa@7/serial@3f8
 -> add_legacy_isa_port(/pci@80000000/isa@7/serial@3f8)
OF: ** translation for device /pci@80000000/isa@7/serial@3f8 **
OF: bus is isa (na=2, ns=1) on /pci@80000000/isa@7
OF: translating address: 00000001 000003f8
OF: parent bus is pci (na=3, ns=2) on /pci@80000000
OF: walking ranges...
OF: ISA map, cp=0, s=10000, da=3f8
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 3f8
OF: one level translation: 01000000 00000000 000003f8
OF: parent bus is default (na=1, ns=1) on /
OF: walking ranges...
OF: PCI map, cp=0, s=c00000, da=3f8
OF: parent translation for: fe000000
OF: with offset: 3f8
OF: one level translation: fe0003f8
OF: reached root node
Found legacy serial port 0 for /pci@80000000/isa@7/serial@3f8
  port=3f8, taddr=fe0003f8, irq=0, clk=1843200, speed=115200
 -> add_legacy_isa_port(/pci@80000000/isa@7/serial@2f8)
OF: ** translation for device /pci@80000000/isa@7/serial@2f8 **
OF: bus is isa (na=2, ns=1) on /pci@80000000/isa@7
OF: translating address: 00000001 000002f8
OF: parent bus is pci (na=3, ns=2) on /pci@80000000
OF: walking ranges...
OF: ISA map, cp=0, s=10000, da=2f8
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 2f8
OF: one level translation: 01000000 00000000 000002f8
OF: parent bus is default (na=1, ns=1) on /
OF: walking ranges...
OF: PCI map, cp=0, s=c00000, da=2f8
OF: parent translation for: fe000000
OF: with offset: 2f8
OF: one level translation: fe0002f8
OF: reached root node
Found legacy serial port 1 for /pci@80000000/isa@7/serial@2f8
  port=2f8, taddr=fe0002f8, irq=0, clk=1843200, speed=115200
legacy_serial_console = 0
default console speed = 115200
 <- find_legacy_serial_port()
console [udbg0] enabled
Entering add_active_range(0, 0, 393216) 0 entries of 256 used
AmigaOne l2cr : L2 cache was not active, activating.
PCI bus 0 controlled by /pci@80000000
PCI host bridge /pci@80000000 (primary) ranges:
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: fe000000
OF: reached root node
  IO 0x00000000fe000000..0x00000000febfffff -> 0x0000000000000000
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: 80000000
OF: reached root node
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: fd000000
OF: reached root node
 MEM 0x0000000080000000..0x00000000fcffffff -> 0x0000000080000000 
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: fd000000
OF: reached root node
 MEM 0x00000000fd000000..0x00000000fdffffff -> 0x0000000000000000 
Top of RAM: 0x60000000, Total RAM: 0x60000000
Memory hole size: 0MB
Zone PFN ranges:
  DMA             0 ->   196608
  Normal     196608 ->   196608
  HighMem    196608 ->   393216
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   393216
On node 0 totalpages: 393216
  DMA zone: 1536 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 195072 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  HighMem zone: 1536 pages used for memmap
  HighMem zone: 195072 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 390144
Kernel command line: initcall_debug driver_debug debug root=/dev/hda12 console=tty0 ide0=ata66 ide1=ata66
ide_setup: ide0=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
ide_setup: ide1=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
irq: Allocated host of type 0 @0xc040f180
i8259 legacy interrupt controller initialized
irq: Default host set to @0xc040f180
PID hash table entries: 4096 (order: 12, 16384 bytes)
time_init: decrementer frequency = 33.333333 MHz
time_init: processor frequency   = 933.333376 MHz
clocksource: timebase mult[7800001] shift[22] registered
clockevent: decrementer mult[888] shift[16] cpu[0]
 -> check_legacy_serial_console()
 console was specified !
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
High memory: 786432k
Memory: 1550204k/1572864k available (3648k kernel code, 21608k reserved, 144k data, 295k bss, 172k init)
SLUB: Genslabs=10, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay loop... 66.56 BogoMIPS (lpj=133120)
Mount-cache hash table entries: 512
Calling initcall 0xc0381270: init_cpufreq_transition_notifier_list+0x0/0x2c()
initcall 0xc0381270: init_cpufreq_transition_notifier_list+0x0/0x2c() returned 0.
initcall 0xc0381270 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x2c()
Calling initcall 0xc03814a0: net_ns_init+0x0/0x188()
net_namespace: 540 bytes
initcall 0xc03814a0: net_ns_init+0x0/0x188() returned 0.
initcall 0xc03814a0 ran for 0 msecs: net_ns_init+0x0/0x188()
Calling initcall 0xc0372904: dma_alloc_init+0x0/0xac()
initcall 0xc0372904: dma_alloc_init+0x0/0xac() returned 0.
initcall 0xc0372904 ran for 0 msecs: dma_alloc_init+0x0/0xac()
Calling initcall 0xc0373a20: sysctl_init+0x0/0x48()
initcall 0xc0373a20: sysctl_init+0x0/0x48() returned 0.
initcall 0xc0373a20 ran for 0 msecs: sysctl_init+0x0/0x48()
Calling initcall 0xc03743fc: ksysfs_init+0x0/0xec()
initcall 0xc03743fc: ksysfs_init+0x0/0xec() returned 0.
initcall 0xc03743fc ran for 0 msecs: ksysfs_init+0x0/0xec()
Calling initcall 0xc03748c0: init_jiffies_clocksource+0x0/0x28()
initcall 0xc03748c0: init_jiffies_clocksource+0x0/0x28() returned 0.
initcall 0xc03748c0 ran for 0 msecs: init_jiffies_clocksource+0x0/0x28()
Calling initcall 0xc0374b2c: pm_init+0x0/0x54()
initcall 0xc0374b2c: pm_init+0x0/0x54() returned 0.
initcall 0xc0374b2c ran for 0 msecs: pm_init+0x0/0x54()
Calling initcall 0xc0377584: filelock_init+0x0/0x48()
initcall 0xc0377584: filelock_init+0x0/0x48() returned 0.
initcall 0xc0377584 ran for 0 msecs: filelock_init+0x0/0x48()
Calling initcall 0xc0378144: init_script_binfmt+0x0/0x28()
initcall 0xc0378144: init_script_binfmt+0x0/0x28() returned 0.
initcall 0xc0378144 ran for 0 msecs: init_script_binfmt+0x0/0x28()
Calling initcall 0xc037816c: init_elf_binfmt+0x0/0x28()
initcall 0xc037816c: init_elf_binfmt+0x0/0x28() returned 0.
initcall 0xc037816c ran for 0 msecs: init_elf_binfmt+0x0/0x28()
Calling initcall 0xc0378e88: debugfs_init+0x0/0x70()
initcall 0xc0378e88: debugfs_init+0x0/0x70() returned 0.
initcall 0xc0378e88 ran for 0 msecs: debugfs_init+0x0/0x70()
Calling initcall 0xc0379abc: random32_init+0x0/0x34()
initcall 0xc0379abc: random32_init+0x0/0x34() returned 0.
initcall 0xc0379abc ran for 0 msecs: random32_init+0x0/0x34()
Calling initcall 0xc0381240: cpufreq_core_init+0x0/0x30()
initcall 0xc0381240: cpufreq_core_init+0x0/0x30() returned 0.
initcall 0xc0381240 ran for 0 msecs: cpufreq_core_init+0x0/0x30()
Calling initcall 0xc0381300: sock_init+0x0/0x84()
initcall 0xc0381300: sock_init+0x0/0x84() returned 0.
initcall 0xc0381300 ran for 0 msecs: sock_init+0x0/0x84()
Calling initcall 0xc0381ec0: netpoll_init+0x0/0x20()
initcall 0xc0381ec0: netpoll_init+0x0/0x20() returned 0.
initcall 0xc0381ec0 ran for 0 msecs: netpoll_init+0x0/0x20()
Calling initcall 0xc03821f8: netlink_proto_init+0x0/0x158()
NET: Registered protocol family 16
initcall 0xc03821f8: netlink_proto_init+0x0/0x158() returned 0.
initcall 0xc03821f8 ran for 0 msecs: netlink_proto_init+0x0/0x158()
Calling initcall 0xc036be84: of_bus_driver_init+0x0/0x30()
initcall 0xc036be84: of_bus_driver_init+0x0/0x30() returned 0.
initcall 0xc036be84 ran for 0 msecs: of_bus_driver_init+0x0/0x30()
Calling initcall 0xc0379958: kobject_uevent_init+0x0/0x68()
initcall 0xc0379958: kobject_uevent_init+0x0/0x68() returned 0.
initcall 0xc0379958 ran for 0 msecs: kobject_uevent_init+0x0/0x68()
Calling initcall 0xc0379b2c: pcibus_class_init+0x0/0x28()
initcall 0xc0379b2c: pcibus_class_init+0x0/0x28() returned 0.
initcall 0xc0379b2c ran for 0 msecs: pcibus_class_init+0x0/0x28()
Calling initcall 0xc037a1c0: pci_driver_init+0x0/0x28()
initcall 0xc037a1c0: pci_driver_init+0x0/0x28() returned 0.
initcall 0xc037a1c0 ran for 0 msecs: pci_driver_init+0x0/0x28()
Calling initcall 0xc037aae0: backlight_class_init+0x0/0x74()
initcall 0xc037aae0: backlight_class_init+0x0/0x74() returned 0.
initcall 0xc037aae0 ran for 0 msecs: backlight_class_init+0x0/0x74()
Calling initcall 0xc037b104: tty_class_init+0x0/0x44()
initcall 0xc037b104: tty_class_init+0x0/0x44() returned 0.
initcall 0xc037b104 ran for 0 msecs: tty_class_init+0x0/0x44()
Calling initcall 0xc037bb2c: vtconsole_class_init+0x0/0xf0()
initcall 0xc037bb2c: vtconsole_class_init+0x0/0xf0() returned 0.
initcall 0xc037bb2c ran for 0 msecs: vtconsole_class_init+0x0/0xf0()
Calling initcall 0xc0006998: irq_late_init+0x0/0x88()
initcall 0xc0006998: irq_late_init+0x0/0x88() returned 0.
initcall 0xc0006998 ran for 0 msecs: irq_late_init+0x0/0x88()
Calling initcall 0xc036ba08: vdso_init+0x0/0x43c()
initcall 0xc036ba08: vdso_init+0x0/0x43c() returned 0.
initcall 0xc036ba08 ran for 0 msecs: vdso_init+0x0/0x43c()
Calling initcall 0xc000fb7c: powerpc_debugfs_init+0x0/0x40()
initcall 0xc000fb7c: powerpc_debugfs_init+0x0/0x40() returned 0.
initcall 0xc000fb7c ran for 0 msecs: powerpc_debugfs_init+0x0/0x40()
Calling initcall 0xc036df0c: ppc_init+0x0/0x84()
initcall 0xc036df0c: ppc_init+0x0/0x84() returned 0.
initcall 0xc036df0c ran for 0 msecs: ppc_init+0x0/0x84()
Calling initcall 0xc0371048: pcibios_init+0x0/0x138()
PCI: Probing PCI hardware
PCI: Scanning bus 0000:00
PCI: Found 0000:00:00.0 [10cc/0660] 000600 00
pci 0000:00:00.0: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:01.0 [10cc/0661] 000604 01
pci 0000:00:01.0: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:06.0 [10b7/9200] 000200 00
pci 0000:00:06.0: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:07.0 [1106/0686] 000601 00
pci 0000:00:07.0: calling quirk 0xc02add6c: 0xc02add6c()
pci 0000:00:07.0: calling quirk 0xc01271b0: quirk_via_bridge+0x0/0x98()
PCI: Found 0000:00:07.1 [1106/0571] 000101 00
pci 0000:00:07.1: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:07.2 [1106/3038] 000c03 00
pci 0000:00:07.2: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:07.3 [1106/3038] 000c03 00
pci 0000:00:07.3: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:07.4 [1106/3057] 000000 00
pci 0000:00:07.4: calling quirk 0xc02add6c: 0xc02add6c()
pci 0000:00:07.4: calling quirk 0xc02af7ac: 0xc02af7ac()
pci 0000:00:07.4: calling quirk 0xc02aee10: 0xc02aee10()
PCI: Found 0000:00:07.5 [1106/3058] 000401 00
pci 0000:00:07.5: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:07.6 [1106/3068] 000780 00
pci 0000:00:07.6: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:08.0 [10ec/8139] 000200 00
pci 0000:00:08.0: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:09.0 [1102/0002] 000401 00
pci 0000:00:09.0: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:09.1 [1102/7002] 000980 00
pci 0000:00:09.1: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:0a.0 [10b9/5237] 000c03 00
pci 0000:00:0a.0: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:0a.1 [10b9/5237] 000c03 00
pci 0000:00:0a.1: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:0a.2 [10b9/5237] 000c03 00
pci 0000:00:0a.2: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:0a.3 [10b9/5239] 000c03 00
pci 0000:00:0a.3: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:00:0a.4 [10b9/5253] 000c00 00
pci 0000:00:0a.4: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Fixups for bus 0000:00
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00000000...],ointsize=1
 -> no parent found !
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00003000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c040f180
irq: -> existing mapping on virq 7
of_irq_map_one: dev=/pci@80000000/ide@7,1, index=0
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000004 0x00003a00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x5)
irq: -> using host @c040f180
irq: -> existing mapping on virq 5
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000004 0x00003b00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x5)
irq: -> using host @c040f180
irq: -> existing mapping on virq 5
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00003d00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c040f180
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00003e00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c040f180
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c040f180
irq: -> existing mapping on virq 9
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004800...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xa)
irq: -> using host @c040f180
irq: -> existing mapping on virq 10
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c040f180
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005100...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c040f180
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005200...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c040f180
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00005300...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c040f180
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00005400...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c040f180
irq: -> existing mapping on virq 9
PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0
PCI: Scanning bus 0000:01
PCI: Found 0000:01:00.0 [1002/5961] 000300 00
pci 0000:01:00.0: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Found 0000:01:00.1 [1002/5941] 000380 00
pci 0000:01:00.1: calling quirk 0xc02add6c: 0xc02add6c()
PCI: Fixups for bus 0000:01
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00000800...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c040f180
irq: -> existing mapping on virq 11
PCI: Bus scan for 0000:01 returning with max=01
PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 1
PCI: Bus scan for 0000:00 returning with max=01
PCI: Cannot allocate resource region 0 of device 0000:01:00.1, will remap
PCI: Cannot allocate resource region 1 of device 0000:01:00.1, will remap
  got res [88100000:8811ffff] bus [88100000:8811ffff] flags 20007200 for BAR 6 of 0000:00:06.0
  got res [88120000:8812ffff] bus [88120000:8812ffff] flags 20007200 for BAR 6 of 0000:00:0a.4
PCI: Failed to allocate mem resource #0:8000000@88000000 for 0000:01:00.1
  got res [88020000:8803ffff] bus [88020000:8803ffff] flags 20007200 for BAR 6 of 0000:01:00.0
  got res [88010000:8801ffff] bus [88010000:8801ffff] flags 20000200 for BAR 1 of 0000:01:00.1
PCI: moved device 0000:01:00.1 resource 1 (200) to 88010000
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: 0x88000000-0x880fffff
  PREFETCH window: 0x0000000080000000-0x0000000087ffffff
initcall 0xc0371048: pcibios_init+0x0/0x138() returned 0.
initcall 0xc0371048 ran for 3 msecs: pcibios_init+0x0/0x138()
Calling initcall 0xc0373f94: param_sysfs_init+0x0/0x1b8()
initcall 0xc0373f94: param_sysfs_init+0x0/0x1b8() returned 0.
initcall 0xc0373f94 ran for 3 msecs: param_sysfs_init+0x0/0x1b8()
Calling initcall 0xc00436c8: pm_sysrq_init+0x0/0x30()
initcall 0xc00436c8: pm_sysrq_init+0x0/0x30() returned 0.
initcall 0xc00436c8 ran for 0 msecs: pm_sysrq_init+0x0/0x30()
Calling initcall 0xc0376c80: readahead_init+0x0/0x28()
initcall 0xc0376c80: readahead_init+0x0/0x28() returned 0.
initcall 0xc0376c80 ran for 0 msecs: readahead_init+0x0/0x28()
Calling initcall 0xc0377cec: init_bio+0x0/0xf0()
initcall 0xc0377cec: init_bio+0x0/0xf0() returned 0.
initcall 0xc0377cec ran for 0 msecs: init_bio+0x0/0xf0()
Calling initcall 0xc0379590: blk_settings_init+0x0/0x30()
initcall 0xc0379590: blk_settings_init+0x0/0x30() returned 0.
initcall 0xc0379590 ran for 0 msecs: blk_settings_init+0x0/0x30()
Calling initcall 0xc03795c0: blk_ioc_init+0x0/0x44()
initcall 0xc03795c0: blk_ioc_init+0x0/0x44() returned 0.
initcall 0xc03795c0 ran for 0 msecs: blk_ioc_init+0x0/0x44()
Calling initcall 0xc0379604: genhd_device_init+0x0/0x5c()
initcall 0xc0379604: genhd_device_init+0x0/0x5c() returned 0.
initcall 0xc0379604 ran for 0 msecs: genhd_device_init+0x0/0x5c()
Calling initcall 0xc037a5e0: fbmem_init+0x0/0xc8()
initcall 0xc037a5e0: fbmem_init+0x0/0xc8() returned 0.
initcall 0xc037a5e0 ran for 0 msecs: fbmem_init+0x0/0xc8()
Calling initcall 0xc037b504: misc_init+0x0/0xb8()
initcall 0xc037b504: misc_init+0x0/0xb8() returned 0.
initcall 0xc037b504 ran for 0 msecs: misc_init+0x0/0xb8()
Calling initcall 0xc037f6d8: init_scsi+0x0/0xa8()
SCSI subsystem initialized
initcall 0xc037f6d8: init_scsi+0x0/0xa8() returned 0.
initcall 0xc037f6d8 ran for 0 msecs: init_scsi+0x0/0xa8()
Calling initcall 0xc037fd68: usb_init+0x0/0x148()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xc037fd68: usb_init+0x0/0x148() returned 0.
initcall 0xc037fd68 ran for 0 msecs: usb_init+0x0/0x148()
Calling initcall 0xc03803e0: serio_init+0x0/0xa4()
initcall 0xc03803e0: serio_init+0x0/0xa4() returned 0.
initcall 0xc03803e0 ran for 0 msecs: serio_init+0x0/0xa4()
Calling initcall 0xc0380590: input_init+0x0/0x13c()
initcall 0xc0380590: input_init+0x0/0x13c() returned 0.
initcall 0xc0380590 ran for 0 msecs: input_init+0x0/0x13c()
Calling initcall 0xc03809ec: rtc_init+0x0/0x94()
initcall 0xc03809ec: rtc_init+0x0/0x94() returned 0.
initcall 0xc03809ec ran for 0 msecs: rtc_init+0x0/0x94()
Calling initcall 0xc0381050: i2c_init+0x0/0x7c()
initcall 0xc0381050: i2c_init+0x0/0x7c() returned 0.
initcall 0xc0381050 ran for 0 msecs: i2c_init+0x0/0x7c()
Calling initcall 0xc0381188: hwmon_init+0x0/0x64()
initcall 0xc0381188: hwmon_init+0x0/0x64() returned 0.
initcall 0xc0381188 ran for 0 msecs: hwmon_init+0x0/0x64()
Calling initcall 0xc03811ec: thermal_init+0x0/0x54()
initcall 0xc03811ec: thermal_init+0x0/0x54() returned 0.
initcall 0xc03811ec ran for 0 msecs: thermal_init+0x0/0x54()
Calling initcall 0xc03813e0: proto_init+0x0/0x54()
initcall 0xc03813e0: proto_init+0x0/0x54() returned 0.
initcall 0xc03813e0 ran for 0 msecs: proto_init+0x0/0x54()
Calling initcall 0xc03819c0: net_dev_init+0x0/0x12c()
initcall 0xc03819c0: net_dev_init+0x0/0x12c() returned 0.
initcall 0xc03819c0 ran for 0 msecs: net_dev_init+0x0/0x12c()
Calling initcall 0xc0381b88: neigh_init+0x0/0x98()
initcall 0xc0381b88: neigh_init+0x0/0x98() returned 0.
initcall 0xc0381b88 ran for 0 msecs: neigh_init+0x0/0x98()
Calling initcall 0xc0381ee0: fib_rules_init+0x0/0xd0()
initcall 0xc0381ee0: fib_rules_init+0x0/0xd0() returned 0.
initcall 0xc0381ee0 ran for 0 msecs: fib_rules_init+0x0/0xd0()
Calling initcall 0xc0381fb0: pktsched_init+0x0/0xf4()
initcall 0xc0381fb0: pktsched_init+0x0/0xf4() returned 0.
initcall 0xc0381fb0 ran for 0 msecs: pktsched_init+0x0/0xf4()
Calling initcall 0xc03820cc: tc_filter_init+0x0/0x70()
initcall 0xc03820cc: tc_filter_init+0x0/0x70() returned 0.
initcall 0xc03820cc ran for 0 msecs: tc_filter_init+0x0/0x70()
Calling initcall 0xc038213c: tc_action_init+0x0/0x70()
initcall 0xc038213c: tc_action_init+0x0/0x70() returned 0.
initcall 0xc038213c ran for 0 msecs: tc_action_init+0x0/0x70()
Calling initcall 0xc0382350: genl_init+0x0/0xf8()
initcall 0xc0382350: genl_init+0x0/0xf8() returned 0.
initcall 0xc0382350 ran for 3 msecs: genl_init+0x0/0xf8()
Calling initcall 0xc0383f5c: atm_init+0x0/0xd4()
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall 0xc0383f5c: atm_init+0x0/0xd4() returned 0.
initcall 0xc0383f5c ran for 0 msecs: atm_init+0x0/0xd4()
Calling initcall 0xc03841e0: wireless_nlevent_init+0x0/0x20()
initcall 0xc03841e0: wireless_nlevent_init+0x0/0x20() returned 0.
initcall 0xc03841e0 ran for 0 msecs: wireless_nlevent_init+0x0/0x20()
Calling initcall 0xc0384200: sysctl_init+0x0/0x48()
initcall 0xc0384200: sysctl_init+0x0/0x48() returned 0.
initcall 0xc0384200 ran for 0 msecs: sysctl_init+0x0/0x48()
Calling initcall 0xc03729b0: add_rtc+0x0/0xcc()
OF: ** translation for device /pci@80000000/isa@7/rtc@70 **
OF: bus is isa (na=2, ns=1) on /pci@80000000/isa@7
OF: translating address: 00000001 00000070
OF: parent bus is pci (na=3, ns=2) on /pci@80000000
OF: walking ranges...
OF: ISA map, cp=0, s=10000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 01000000 00000000 00000070
OF: parent bus is default (na=1, ns=1) on /
OF: walking ranges...
OF: PCI map, cp=0, s=c00000, da=70
OF: parent translation for: fe000000
OF: with offset: 70
OF: one level translation: fe000070
OF: reached root node
initcall 0xc03729b0: add_rtc+0x0/0xcc() returned 0.
initcall 0xc03729b0 ran for 0 msecs: add_rtc+0x0/0xcc()
Calling initcall 0xc0374774: clocksource_done_booting+0x0/0x14()
initcall 0xc0374774: clocksource_done_booting+0x0/0x14() returned 0.
initcall 0xc0374774 ran for 0 msecs: clocksource_done_booting+0x0/0x14()
Calling initcall 0xc03774d0: init_pipe_fs+0x0/0x70()
initcall 0xc03774d0: init_pipe_fs+0x0/0x70() returned 0.
initcall 0xc03774d0 ran for 0 msecs: init_pipe_fs+0x0/0x70()
Calling initcall 0xc0377f84: eventpoll_init+0x0/0x98()
initcall 0xc0377f84: eventpoll_init+0x0/0x98() returned 0.
initcall 0xc0377f84 ran for 0 msecs: eventpoll_init+0x0/0x98()
Calling initcall 0xc037801c: anon_inode_init+0x0/0x128()
initcall 0xc037801c: anon_inode_init+0x0/0x128() returned 0.
initcall 0xc037801c ran for 0 msecs: anon_inode_init+0x0/0x128()
Calling initcall 0xc037ad74: chr_dev_init+0x0/0xbc()
initcall 0xc037ad74: chr_dev_init+0x0/0xbc() returned 0.
initcall 0xc037ad74 ran for 0 msecs: chr_dev_init+0x0/0xbc()
Calling initcall 0xc037d468: firmware_class_init+0x0/0x8c()
initcall 0xc037d468: firmware_class_init+0x0/0x8c() returned 0.
initcall 0xc037d468 ran for 0 msecs: firmware_class_init+0x0/0x8c()
Calling initcall 0xc037eca8: loopback_init+0x0/0x28()
initcall 0xc037eca8: loopback_init+0x0/0x28() returned 0.
initcall 0xc037eca8 ran for 0 msecs: loopback_init+0x0/0x28()
Calling initcall 0xc038129c: cpufreq_gov_performance_init+0x0/0x28()
initcall 0xc038129c: cpufreq_gov_performance_init+0x0/0x28() returned 0.
initcall 0xc038129c ran for 0 msecs: cpufreq_gov_performance_init+0x0/0x28()
Calling initcall 0xc03832fc: inet_init+0x0/0x344()
NET: Registered protocol family 2
Switched to high resolution mode on CPU 0
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xc03832fc: inet_init+0x0/0x344() returned 0.
initcall 0xc03832fc ran for 49 msecs: inet_init+0x0/0x344()
Calling initcall 0xc036b4e4: populate_rootfs+0x0/0xf8()
initcall 0xc036b4e4: populate_rootfs+0x0/0xf8() returned 0.
initcall 0xc036b4e4 ran for 0 msecs: populate_rootfs+0x0/0xf8()
Calling initcall 0xc036b800: irq_debugfs_init+0x0/0x50()
initcall 0xc036b800: irq_debugfs_init+0x0/0x50() returned -12.
initcall 0xc036b800 ran for 0 msecs: irq_debugfs_init+0x0/0x50()
initcall at 0xc036b800: irq_debugfs_init+0x0/0x50(): returned with error code -12
Calling initcall 0xc036be58: register_powersave_nap_sysctl+0x0/0x2c()
initcall 0xc036be58: register_powersave_nap_sysctl+0x0/0x2c() returned 0.
initcall 0xc036be58 ran for 0 msecs: register_powersave_nap_sysctl+0x0/0x2c()
Calling initcall 0xc036bed4: TAU_init+0x0/0xf4()
Thermal assist unit not available
initcall 0xc036bed4: TAU_init+0x0/0xf4() returned 1.
initcall 0xc036bed4 ran for 0 msecs: TAU_init+0x0/0xf4()
initcall at 0xc036bed4: TAU_init+0x0/0xf4(): returned with error code 1
Calling initcall 0xc036c7f0: export_flat_device_tree+0x0/0x60()
initcall 0xc036c7f0: export_flat_device_tree+0x0/0x60() returned 0.
initcall 0xc036c7f0 ran for 0 msecs: export_flat_device_tree+0x0/0x60()
Calling initcall 0xc036dc2c: add_pcspkr+0x0/0x80()
initcall 0xc036dc2c: add_pcspkr+0x0/0x80() returned 0.
initcall 0xc036dc2c ran for 0 msecs: add_pcspkr+0x0/0x80()
Calling initcall 0xc037051c: serial_dev_init+0x0/0x194()
Fixing serial ports interrupts and IO ports ...
fixup_port_irq(0)
enter irq_of_parse_and_map()
of_irq_map_one: dev=/pci@80000000/isa@7/serial@3f8, index=0
 intsize=2 intlen=2
of_irq_map_raw: par=/pci@80000000/isa@7,intspec=[0x00000004 0x00000003...],ointsize=2
of_irq_map_raw: ipar=/pci@80000000/isa@7, size=2
 -> addrsize=2
 -> no map, getting parent
 -> new parent: /pci@80000000/isa@7/interrupt-controller@20
 -> got it !
calling irq_create_of_mapping()
irq: controller = /pci@80000000/isa@7/interrupt-controller@20, intspec = 4, intsize = 2
irq: find host controller
irq: host = 0xc040f180
irq: irq_create_mapping(0xc040f180, 0x4)
irq: -> using host @c040f180
irq: -> existing mapping on virq 4
irq: created irq mapping, virq = 4
irq: created irq mapping, virq = 4
fixup_port_pio(0)
port 0, IO 3f8 -> 3f8
fixup_port_irq(1)
enter irq_of_parse_and_map()
of_irq_map_one: dev=/pci@80000000/isa@7/serial@2f8, index=0
 intsize=2 intlen=2
of_irq_map_raw: par=/pci@80000000/isa@7,intspec=[0x00000003 0x00000003...],ointsize=2
of_irq_map_raw: ipar=/pci@80000000/isa@7, size=2
 -> addrsize=2
 -> no map, getting parent
 -> new parent: /pci@80000000/isa@7/interrupt-controller@20
 -> got it !
calling irq_create_of_mapping()
irq: controller = /pci@80000000/isa@7/interrupt-controller@20, intspec = 3, intsize = 2
irq: find host controller
irq: host = 0xc040f180
irq: irq_create_mapping(0xc040f180, 0x3)
irq: -> using host @c040f180
irq: -> existing mapping on virq 3
irq: created irq mapping, virq = 3
irq: created irq mapping, virq = 3
fixup_port_pio(1)
port 1, IO 2f8 -> 2f8
Registering platform serial ports
initcall 0xc037051c: serial_dev_init+0x0/0x194() returned 0.
initcall 0xc037051c ran for 0 msecs: serial_dev_init+0x0/0x194()
Calling initcall 0xc0371534: audit_classes_init+0x0/0x70()
initcall 0xc0371534: audit_classes_init+0x0/0x70() returned 0.
initcall 0xc0371534 ran for 0 msecs: audit_classes_init+0x0/0x70()
Calling initcall 0xc0372078: setup_kcore+0x0/0xe0()
setup_kcore: restrict size=3fffffff
initcall 0xc0372078: setup_kcore+0x0/0xe0() returned 0.
initcall 0xc0372078 ran for 0 msecs: setup_kcore+0x0/0xe0()
Calling initcall 0xc03735b0: create_proc_profile+0x0/0x74()
initcall 0xc03735b0: create_proc_profile+0x0/0x74() returned 0.
initcall 0xc03735b0 ran for 0 msecs: create_proc_profile+0x0/0x74()
Calling initcall 0xc03739b0: ioresources_init+0x0/0x70()
initcall 0xc03739b0: ioresources_init+0x0/0x70() returned 0.
initcall 0xc03739b0 ran for 0 msecs: ioresources_init+0x0/0x70()
Calling initcall 0xc0373abc: uid_cache_init+0x0/0x94()
initcall 0xc0373abc: uid_cache_init+0x0/0x94() returned 0.
initcall 0xc0373abc ran for 0 msecs: uid_cache_init+0x0/0x94()
Calling initcall 0xc037414c: init_posix_timers+0x0/0xc0()
initcall 0xc037414c: init_posix_timers+0x0/0xc0() returned 0.
initcall 0xc037414c ran for 0 msecs: init_posix_timers+0x0/0xc0()
Calling initcall 0xc037420c: init_posix_cpu_timers+0x0/0xf0()
initcall 0xc037420c: init_posix_cpu_timers+0x0/0xf0() returned 0.
initcall 0xc037420c ran for 0 msecs: init_posix_cpu_timers+0x0/0xf0()
Calling initcall 0xc03743b8: nsproxy_cache_init+0x0/0x44()
initcall 0xc03743b8: nsproxy_cache_init+0x0/0x44() returned 0.
initcall 0xc03743b8 ran for 0 msecs: nsproxy_cache_init+0x0/0x44()
Calling initcall 0xc0374570: timekeeping_init_device+0x0/0x44()
initcall 0xc0374570: timekeeping_init_device+0x0/0x44() returned 0.
initcall 0xc0374570 ran for 0 msecs: timekeeping_init_device+0x0/0x44()
Calling initcall 0xc0374840: init_clocksource_sysfs+0x0/0x80()
initcall 0xc0374840: init_clocksource_sysfs+0x0/0x80() returned 0.
initcall 0xc0374840 ran for 0 msecs: init_clocksource_sysfs+0x0/0x80()
Calling initcall 0xc03748e8: init_timer_list_procfs+0x0/0x4c()
initcall 0xc03748e8: init_timer_list_procfs+0x0/0x4c() returned 0.
initcall 0xc03748e8 ran for 0 msecs: init_timer_list_procfs+0x0/0x4c()
Calling initcall 0xc03749d4: futex_init+0x0/0xc8()
initcall 0xc03749d4: futex_init+0x0/0xc8() returned 0.
initcall 0xc03749d4 ran for 0 msecs: futex_init+0x0/0xc8()
Calling initcall 0xc0374a9c: proc_dma_init+0x0/0x48()
initcall 0xc0374a9c: proc_dma_init+0x0/0x48() returned 0.
initcall 0xc0374a9c ran for 0 msecs: proc_dma_init+0x0/0x48()
Calling initcall 0xc0374ae4: kallsyms_init+0x0/0x48()
initcall 0xc0374ae4: kallsyms_init+0x0/0x48() returned 0.
initcall 0xc0374ae4 ran for 0 msecs: kallsyms_init+0x0/0x48()
Calling initcall 0xc0374c38: audit_init+0x0/0x158()
audit: initializing netlink socket (disabled)
type=2000 audit(0.376:1): initialized
initcall 0xc0374c38: audit_init+0x0/0x158() returned 0.
initcall 0xc0374c38 ran for 0 msecs: audit_init+0x0/0x158()
Calling initcall 0xc0374e54: audit_tree_init+0x0/0x6c()
initcall 0xc0374e54: audit_tree_init+0x0/0x6c() returned 0.
initcall 0xc0374e54 ran for 0 msecs: audit_tree_init+0x0/0x6c()
Calling initcall 0xc037508c: relay_init+0x0/0x8()
initcall 0xc037508c: relay_init+0x0/0x8() returned 0.
initcall 0xc037508c ran for 0 msecs: relay_init+0x0/0x8()
Calling initcall 0xc0375094: utsname_sysctl_init+0x0/0x2c()
initcall 0xc0375094: utsname_sysctl_init+0x0/0x2c() returned 0.
initcall 0xc0375094 ran for 0 msecs: utsname_sysctl_init+0x0/0x2c()
Calling initcall 0xc0375fb4: init_per_zone_pages_min+0x0/0x5c()
initcall 0xc0375fb4: init_per_zone_pages_min+0x0/0x5c() returned 0.
initcall 0xc0375fb4 ran for 0 msecs: init_per_zone_pages_min+0x0/0x5c()
Calling initcall 0xc0376c44: pdflush_init+0x0/0x3c()
initcall 0xc0376c44: pdflush_init+0x0/0x3c() returned 0.
initcall 0xc0376c44 ran for 0 msecs: pdflush_init+0x0/0x3c()
Calling initcall 0xc0376d00: kswapd_init+0x0/0x2c()
initcall 0xc0376d00: kswapd_init+0x0/0x2c() returned 0.
initcall 0xc0376d00 ran for 0 msecs: kswapd_init+0x0/0x2c()
Calling initcall 0xc0376dfc: init_emergency_pool+0x0/0x88()
highmem bounce pool size: 64 pages
initcall 0xc0376dfc: init_emergency_pool+0x0/0x88() returned 0.
initcall 0xc0376dfc ran for 0 msecs: init_emergency_pool+0x0/0x88()
Calling initcall 0xc0376e84: procswaps_init+0x0/0x48()
initcall 0xc0376e84: procswaps_init+0x0/0x48() returned 0.
initcall 0xc0376e84 ran for 0 msecs: procswaps_init+0x0/0x48()
Calling initcall 0xc0376ecc: init_tmpfs+0x0/0xf0()
initcall 0xc0376ecc: init_tmpfs+0x0/0xf0() returned 0.
initcall 0xc0376ecc ran for 0 msecs: init_tmpfs+0x0/0xf0()
Calling initcall 0xc03771b4: slab_sysfs_init+0x0/0x118()
initcall 0xc03771b4: slab_sysfs_init+0x0/0x118() returned 0.
initcall 0xc03771b4 ran for 5 msecs: slab_sysfs_init+0x0/0x118()
Calling initcall 0xc0377540: fasync_init+0x0/0x44()
initcall 0xc0377540: fasync_init+0x0/0x44() returned 0.
initcall 0xc0377540 ran for 0 msecs: fasync_init+0x0/0x44()
Calling initcall 0xc0377bf8: aio_setup+0x0/0x94()
initcall 0xc0377bf8: aio_setup+0x0/0x94() returned 0.
initcall 0xc0377bf8 ran for 0 msecs: aio_setup+0x0/0x94()
Calling initcall 0xc0377e88: inotify_setup+0x0/0x14()
initcall 0xc0377e88: inotify_setup+0x0/0x14() returned 0.
initcall 0xc0377e88 ran for 0 msecs: inotify_setup+0x0/0x14()
Calling initcall 0xc0377e9c: inotify_user_setup+0x0/0xe8()
initcall 0xc0377e9c: inotify_user_setup+0x0/0xe8() returned 0.
initcall 0xc0377e9c ran for 0 msecs: inotify_user_setup+0x0/0xe8()
Calling initcall 0xc0378194: init_mbcache+0x0/0x2c()
initcall 0xc0378194: init_mbcache+0x0/0x2c() returned 0.
initcall 0xc0378194 ran for 0 msecs: init_mbcache+0x0/0x2c()
Calling initcall 0xc03781c0: dquot_init+0x0/0x114()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall 0xc03781c0: dquot_init+0x0/0x114() returned 0.
initcall 0xc03781c0 ran for 0 msecs: dquot_init+0x0/0x114()
Calling initcall 0xc03782d4: dnotify_init+0x0/0x44()
initcall 0xc03782d4: dnotify_init+0x0/0x44() returned 0.
initcall 0xc03782d4 ran for 0 msecs: dnotify_init+0x0/0x44()
Calling initcall 0xc037899c: init_devpts_fs+0x0/0x64()
initcall 0xc037899c: init_devpts_fs+0x0/0x64() returned 0.
initcall 0xc037899c ran for 0 msecs: init_devpts_fs+0x0/0x64()
Calling initcall 0xc0378a00: init_ext3_fs+0x0/0x8c()
initcall 0xc0378a00: init_ext3_fs+0x0/0x8c() returned 0.
initcall 0xc0378a00 ran for 0 msecs: init_ext3_fs+0x0/0x8c()
Calling initcall 0xc0378b8c: journal_init+0x0/0xc8()
initcall 0xc0378b8c: journal_init+0x0/0xc8() returned 0.
initcall 0xc0378b8c ran for 0 msecs: journal_init+0x0/0xc8()
Calling initcall 0xc0378c54: init_ext2_fs+0x0/0x8c()
initcall 0xc0378c54: init_ext2_fs+0x0/0x8c() returned 0.
initcall 0xc0378c54 ran for 0 msecs: init_ext2_fs+0x0/0x8c()
Calling initcall 0xc0378d3c: init_cramfs_fs+0x0/0x4c()
initcall 0xc0378d3c: init_cramfs_fs+0x0/0x4c() returned 0.
initcall 0xc0378d3c ran for 0 msecs: init_cramfs_fs+0x0/0x4c()
Calling initcall 0xc0378d88: init_ramfs_fs+0x0/0x28()
initcall 0xc0378d88: init_ramfs_fs+0x0/0x28() returned 0.
initcall 0xc0378d88 ran for 0 msecs: init_ramfs_fs+0x0/0x28()
Calling initcall 0xc0378e0c: init_affs_fs+0x0/0x7c()
initcall 0xc0378e0c: init_affs_fs+0x0/0x7c() returned 0.
initcall 0xc0378e0c ran for 0 msecs: init_affs_fs+0x0/0x7c()
Calling initcall 0xc0378ef8: ipc_init+0x0/0x2c()
initcall 0xc0378ef8: ipc_init+0x0/0x2c() returned 0.
initcall 0xc0378ef8 ran for 0 msecs: ipc_init+0x0/0x2c()
Calling initcall 0xc037908c: ipc_sysctl_init+0x0/0x2c()
initcall 0xc037908c: ipc_sysctl_init+0x0/0x2c() returned 0.
initcall 0xc037908c ran for 0 msecs: ipc_sysctl_init+0x0/0x2c()
Calling initcall 0xc03790b8: init_mqueue_fs+0x0/0xe8()
initcall 0xc03790b8: init_mqueue_fs+0x0/0xe8() returned 0.
initcall 0xc03790b8 ran for 0 msecs: init_mqueue_fs+0x0/0xe8()
Calling initcall 0xc0379330: key_proc_init+0x0/0x54()
initcall 0xc0379330: key_proc_init+0x0/0x54() returned 0.
initcall 0xc0379330 ran for 0 msecs: key_proc_init+0x0/0x54()
Calling initcall 0xc0379384: crypto_algapi_init+0x0/0x24()
initcall 0xc0379384: crypto_algapi_init+0x0/0x24() returned 0.
initcall 0xc0379384 ran for 0 msecs: crypto_algapi_init+0x0/0x24()
Calling initcall 0xc03793ec: cryptomgr_init+0x0/0x28()
initcall 0xc03793ec: cryptomgr_init+0x0/0x28() returned 0.
initcall 0xc03793ec ran for 0 msecs: cryptomgr_init+0x0/0x28()
Calling initcall 0xc0379414: hmac_module_init+0x0/0x28()
initcall 0xc0379414: hmac_module_init+0x0/0x28() returned 0.
initcall 0xc0379414 ran for 0 msecs: hmac_module_init+0x0/0x28()
Calling initcall 0xc037943c: init+0x0/0x28()
initcall 0xc037943c: init+0x0/0x28() returned 0.
initcall 0xc037943c ran for 0 msecs: init+0x0/0x28()
Calling initcall 0xc037980c: noop_init+0x0/0x2c()
io scheduler noop registered
initcall 0xc037980c: noop_init+0x0/0x2c() returned 0.
initcall 0xc037980c ran for 0 msecs: noop_init+0x0/0x2c()
Calling initcall 0xc0379838: as_init+0x0/0x2c()
io scheduler anticipatory registered
initcall 0xc0379838: as_init+0x0/0x2c() returned 0.
initcall 0xc0379838 ran for 0 msecs: as_init+0x0/0x2c()
Calling initcall 0xc0379864: deadline_init+0x0/0x2c()
io scheduler deadline registered
initcall 0xc0379864: deadline_init+0x0/0x2c() returned 0.
initcall 0xc0379864 ran for 0 msecs: deadline_init+0x0/0x2c()
Calling initcall 0xc0379890: cfq_init+0x0/0xc8()
io scheduler cfq registered (default)
initcall 0xc0379890: cfq_init+0x0/0xc8() returned 0.
initcall 0xc0379890 ran for 0 msecs: cfq_init+0x0/0xc8()
Calling initcall 0xc02ae604: 0xc02ae604()
pci 0000:00:00.0: calling quirk 0xc00168f8: amigaone_pci_fixup_articias+0x0/0xac()
Fixing host bridge settings
pci 0000:00:00.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:00.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:01.0: calling quirk 0xc0016898: amigaone_pci_fixup_articias_agp+0x0/0x60()
Fixing AGP/PCI bus 1 bridge settings
pci 0000:00:01.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:01.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:06.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:06.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:07.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:07.1: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.1: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:07.2: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.2: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:07.3: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.3: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:07.4: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.4: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:07.5: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.5: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:07.6: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.6: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:08.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:08.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:09.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:09.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:09.1: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:09.1: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:0a.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:0a.1: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.1: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:0a.2: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.2: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:0a.3: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.3: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:00:0a.4: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.4: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:01:00.0: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:01:00.0: calling quirk 0xc02b6fe0: 0xc02b6fe0()
pci 0000:01:00.1: calling quirk 0xc0127c50: quirk_cardbus_legacy+0x0/0x44()
pci 0000:01:00.1: calling quirk 0xc02b6fe0: 0xc02b6fe0()
initcall 0xc02ae604: 0xc02ae604() returned 0.
initcall 0xc02ae604 ran for 0 msecs: 0xc02ae604()
Calling initcall 0xc037a258: pci_proc_init+0x0/0x9c()
initcall 0xc037a258: pci_proc_init+0x0/0x9c() returned 0.
initcall 0xc037a258 ran for 0 msecs: pci_proc_init+0x0/0x9c()
Calling initcall 0xc037a2f4: pcie_portdrv_init+0x0/0x6c()
initcall 0xc037a2f4: pcie_portdrv_init+0x0/0x6c() returned 0.
initcall 0xc037a2f4 ran for 0 msecs: pcie_portdrv_init+0x0/0x6c()
Calling initcall 0xc037a360: aer_service_init+0x0/0x44()
initcall 0xc037a360: aer_service_init+0x0/0x44() returned 0.
initcall 0xc037a360 ran for 0 msecs: aer_service_init+0x0/0x44()
Calling initcall 0xc037a6c4: fb_console_init+0x0/0x184()
initcall 0xc037a6c4: fb_console_init+0x0/0x184() returned 0.
initcall 0xc037a6c4 ran for 0 msecs: fb_console_init+0x0/0x184()
Calling initcall 0xc037ab54: radeonfb_init+0x0/0x220()
radeonfb (0000:01:00.0): Cannot match card to OF node !
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=250.00 Mhz, System=200.00 MHz
radeonfb: PLL min 20000 max 40000
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type CRT found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 200x75
radeonfb (0000:01:00.0): ATI Radeon Ya 
initcall 0xc037ab54: radeonfb_init+0x0/0x220() returned 0.
initcall 0xc037ab54 ran for 4490 msecs: radeonfb_init+0x0/0x220()
Calling initcall 0xc037ae58: rand_initialize+0x0/0x44()
initcall 0xc037ae58: rand_initialize+0x0/0x44() returned 0.
initcall 0xc037ae58 ran for 0 msecs: rand_initialize+0x0/0x44()
Calling initcall 0xc037aefc: tty_init+0x0/0x208()
initcall 0xc037aefc: tty_init+0x0/0x208() returned 0.
initcall 0xc037aefc ran for 5 msecs: tty_init+0x0/0x208()
Calling initcall 0xc037b148: pty_init+0x0/0x3bc()
initcall 0xc037b148: pty_init+0x0/0x3bc() returned 0.
initcall 0xc037b148 ran for 2 msecs: pty_init+0x0/0x3bc()
Calling initcall 0xc037bc54: drm_core_init+0x0/0x168()
[drm] Initialized drm 1.1.0 20060810
initcall 0xc037bc54: drm_core_init+0x0/0x168() returned 0.
initcall 0xc037bc54 ran for 0 msecs: drm_core_init+0x0/0x168()
Calling initcall 0xc037bdbc: radeon_init+0x0/0x38()
[drm] Initialized radeon 1.28.0 20060524 on minor 0
initcall 0xc037bdbc: radeon_init+0x0/0x38() returned 0.
initcall 0xc037bdbc ran for 0 msecs: radeon_init+0x0/0x38()
Calling initcall 0xc037c240: serial8250_init+0x0/0x138()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250.0: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250.0: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
initcall 0xc037c240: serial8250_init+0x0/0x138() returned 0.
initcall 0xc037c240 ran for 1 msecs: serial8250_init+0x0/0x138()
Calling initcall 0xc037c3a8: serial8250_pci_init+0x0/0x34()
initcall 0xc037c3a8: serial8250_pci_init+0x0/0x34() returned 0.
initcall 0xc037c3a8 ran for 0 msecs: serial8250_pci_init+0x0/0x34()
Calling initcall 0xc037c8cc: parport_default_proc_register+0x0/0x3c()
initcall 0xc037c8cc: parport_default_proc_register+0x0/0x3c() returned 0.
initcall 0xc037c8cc ran for 0 msecs: parport_default_proc_register+0x0/0x3c()
Calling initcall 0xc037cca4: parport_pc_init+0x0/0x4ec()
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
parport_pc: VIA parallel port: io=0x378
initcall 0xc037cca4: parport_pc_init+0x0/0x4ec() returned 0.
initcall 0xc037cca4 ran for 92 msecs: parport_pc_init+0x0/0x4ec()
Calling initcall 0xc037d190: parport_serial_init+0x0/0x34()
initcall 0xc037d190: parport_serial_init+0x0/0x34() returned 0.
initcall 0xc037d190 ran for 0 msecs: parport_serial_init+0x0/0x34()
Calling initcall 0xc037d834: floppy_init+0x0/0x1050()
Floppy drive(s): fd0 is 2.88M
FDC 0 is a post-1991 82077
initcall 0xc037d834: floppy_init+0x0/0x1050() returned 0.
initcall 0xc037d834 ran for 27 msecs: floppy_init+0x0/0x1050()
Calling initcall 0xc037e884: brd_init+0x0/0x198()
brd: module loaded
initcall 0xc037e884: brd_init+0x0/0x198() returned 0.
initcall 0xc037e884 ran for 7 msecs: brd_init+0x0/0x198()
Calling initcall 0xc037ea54: vortex_init+0x0/0xe0()
3c59x: Donald Becker and others.
0000:00:06.0: 3Com PCI 3c905C Tornado at f100c000.
initcall 0xc037ea54: vortex_init+0x0/0xe0() returned 0.
initcall 0xc037ea54 ran for 31 msecs: vortex_init+0x0/0xe0()
Calling initcall 0xc037ebc8: net_olddevs_init+0x0/0xe0()
initcall 0xc037ebc8: net_olddevs_init+0x0/0xe0() returned 0.
initcall 0xc037ebc8 ran for 0 msecs: net_olddevs_init+0x0/0xe0()
Calling initcall 0xc037ed64: cp_init+0x0/0x34()
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:00:08.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
8139cp 0000:00:08.0: Try the "8139too" driver instead.
initcall 0xc037ed64: cp_init+0x0/0x34() returned 0.
initcall 0xc037ed64 ran for 16 msecs: cp_init+0x0/0x34()
Calling initcall 0xc037efb0: ide_init+0x0/0xd4()
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
initcall 0xc037efb0: ide_init+0x0/0xd4() returned 0.
initcall 0xc037efb0 ran for 11 msecs: ide_init+0x0/0xd4()
Calling initcall 0xc037f620: siimage_ide_init+0x0/0x34()
initcall 0xc037f620: siimage_ide_init+0x0/0x34() returned 0.
initcall 0xc037f620 ran for 0 msecs: siimage_ide_init+0x0/0x34()
Calling initcall 0xc037f654: via_ide_init+0x0/0x34()
VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:07.1
VIA_IDE 0000:00:07.1: calling quirk 0xc0127788: quirk_via_vlink+0x0/0xd4()
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xcc00-0xcc07, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0xcc08-0xcc0f, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
hda: ST380011A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: TOSHIBA ODD-DVD SD-M1802, ATAPI CD/DVD-ROM drive
hdd: LITE-ON LTR-52327S, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
initcall 0xc037f654: via_ide_init+0x0/0x34() returned 0.
initcall 0xc037f654 ran for 8816 msecs: via_ide_init+0x0/0x34()
Calling initcall 0xc037f688: idedisk_init+0x0/0x28()
hda: max request size: 512KiB
hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: RDSK (512) hda1 (SFS^@)(res 2 spb 1) hda2 (LNX^@)(res 2 spb 2) hda3 (LNX^@)(res 2 spb 2) hda4 (LNX^@)(res 2 spb 2) hda5 (LNX^@)(res 2 spb 2) hda6 (SWP^@)(res 2 spb 2) hda7 (LNX^@)(res 2 spb 2) hda8 (DOS^C)(res 2 spb 2) hda9 (SFS^@)(res 2 spb 1) hda10 (SFS^@)(res 2 spb 1) hda11 (EXT^C)(res 2 spb 2) hda12 (LNX^@)(res 2 spb 2) hda13 (LNX^@)(res 2 spb 2) hda14 (LNX^@)(res 2 spb 2)
initcall 0xc037f688: idedisk_init+0x0/0x28() returned 0.
initcall 0xc037f688 ran for 36 msecs: idedisk_init+0x0/0x28()
Calling initcall 0xc037f6b0: ide_cdrom_init+0x0/0x28()
hdc: ATAPI 48X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
initcall 0xc037f6b0: ide_cdrom_init+0x0/0x28() returned 0.
initcall 0xc037f6b0 ran for 580 msecs: ide_cdrom_init+0x0/0x28()
Calling initcall 0xc037fac4: ieee1394_init+0x0/0x280()
initcall 0xc037fac4: ieee1394_init+0x0/0x280() returned 0.
initcall 0xc037fac4 ran for 0 msecs: ieee1394_init+0x0/0x280()
Calling initcall 0xc037fd44: cdrom_init+0x0/0x24()
initcall 0xc037fd44: cdrom_init+0x0/0x24() returned 0.
initcall 0xc037fd44 ran for 0 msecs: cdrom_init+0x0/0x24()
Calling initcall 0xc0380024: mon_init+0x0/0x114()
initcall 0xc0380024: mon_init+0x0/0x114() returned 0.
initcall 0xc0380024 ran for 0 msecs: mon_init+0x0/0x114()
Calling initcall 0xc0380274: ohci_hcd_mod_init+0x0/0x94()
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:0a.0: OHCI Host Controller
ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0a.0: irq 7, io mem 0x98101000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd 0000:00:0a.1: OHCI Host Controller
ohci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0a.1: irq 7, io mem 0x98102000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd 0000:00:0a.2: OHCI Host Controller
ohci_hcd 0000:00:0a.2: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:0a.2: irq 7, io mem 0x98103000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
initcall 0xc0380274: ohci_hcd_mod_init+0x0/0x94() returned 0.
initcall 0xc0380274 ran for 580 msecs: ohci_hcd_mod_init+0x0/0x94()
Calling initcall 0xc0380308: uhci_hcd_init+0x0/0xd8()
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:07.2: calling quirk 0xc0127788: quirk_via_vlink+0x0/0xd4()
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:07.2: irq 5, io base 0x00802080
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:07.3: calling quirk 0xc0127788: quirk_via_vlink+0x0/0xd4()
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:07.3: irq 5, io base 0x008020a0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
initcall 0xc0380308: uhci_hcd_init+0x0/0xd8() returned 0.
initcall 0xc0380308 ran for 290 msecs: uhci_hcd_init+0x0/0xd8()
Calling initcall 0xc0380484: i8042_init+0x0/0x10c()
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xc0380484: i8042_init+0x0/0x10c() returned 0.
initcall 0xc0380484 ran for 13 msecs: i8042_init+0x0/0x10c()
Calling initcall 0xc03806cc: mousedev_init+0x0/0xb4()
mice: PS/2 mouse device common for all mice
initcall 0xc03806cc: mousedev_init+0x0/0xb4() returned 0.
initcall 0xc03806cc ran for 6 msecs: mousedev_init+0x0/0xb4()
Calling initcall 0xc0380780: evdev_init+0x0/0x28()
initcall 0xc0380780: evdev_init+0x0/0x28() returned 0.
initcall 0xc0380780 ran for 0 msecs: evdev_init+0x0/0x28()
Calling initcall 0xc03807bc: atkbd_init+0x0/0x34()
initcall 0xc03807bc: atkbd_init+0x0/0x34() returned 0.
initcall 0xc03807bc ran for 0 msecs: atkbd_init+0x0/0x34()
Calling initcall 0xc03807f0: psmouse_init+0x0/0x94()
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xc03807f0: psmouse_init+0x0/0x94() returned 0.
initcall 0xc03807f0 ran for 937 msecs: psmouse_init+0x0/0x94()
Calling initcall 0xc0380884: pcspkr_init+0x0/0x28()
input: PC Speaker as /class/input/input1
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
initcall 0xc0380884: pcspkr_init+0x0/0x28() returned 0.
initcall 0xc0380884 ran for 637 msecs: pcspkr_init+0x0/0x28()
Calling initcall 0xc0380ae4: cmos_init+0x0/0x30()
rtc_cmos: dev (254:0)
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day
initcall 0xc0380ae4: cmos_init+0x0/0x30() returned 0.
initcall 0xc0380ae4 ran for 16 msecs: cmos_init+0x0/0x30()
Calling initcall 0xc03810cc: i2c_dev_init+0x0/0xbc()
i2c /dev entries driver
initcall 0xc03810cc: i2c_dev_init+0x0/0xbc() returned 0.
initcall 0xc03810cc ran for 5 msecs: i2c_dev_init+0x0/0xbc()
Calling initcall 0xc03812c4: ledtrig_ide_init+0x0/0x34()
initcall 0xc03812c4: ledtrig_ide_init+0x0/0x34() returned 0.
initcall 0xc03812c4 ran for 0 msecs: ledtrig_ide_init+0x0/0x34()
Calling initcall 0xc03812f8: hid_init+0x0/0x8()
initcall 0xc03812f8: hid_init+0x0/0x8() returned 0.
initcall 0xc03812f8 ran for 0 msecs: hid_init+0x0/0x8()
Calling initcall 0xc0381628: sysctl_core_init+0x0/0x28()
initcall 0xc0381628: sysctl_core_init+0x0/0x28() returned 0.
initcall 0xc0381628 ran for 0 msecs: sysctl_core_init+0x0/0x28()
Calling initcall 0xc0381d70: flow_cache_init+0x0/0x150()
initcall 0xc0381d70: flow_cache_init+0x0/0x150() returned 0.
initcall 0xc0381d70 ran for 0 msecs: flow_cache_init+0x0/0x150()
Calling initcall 0xc03820a4: blackhole_module_init+0x0/0x28()
initcall 0xc03820a4: blackhole_module_init+0x0/0x28() returned 0.
initcall 0xc03820a4 ran for 0 msecs: blackhole_module_init+0x0/0x28()
Calling initcall 0xc038380c: sysctl_ipv4_init+0x0/0x48()
initcall 0xc038380c: sysctl_ipv4_init+0x0/0x48() returned 0.
initcall 0xc038380c ran for 0 msecs: sysctl_ipv4_init+0x0/0x48()
Calling initcall 0xc0383b5c: init_syncookies+0x0/0x30()
initcall 0xc0383b5c: init_syncookies+0x0/0x30() returned 0.
initcall 0xc0383b5c ran for 0 msecs: init_syncookies+0x0/0x30()
Calling initcall 0xc0383b8c: xfrm4_beet_init+0x0/0x2c()
initcall 0xc0383b8c: xfrm4_beet_init+0x0/0x2c() returned 0.
initcall 0xc0383b8c ran for 0 msecs: xfrm4_beet_init+0x0/0x2c()
Calling initcall 0xc028f274: ipv4_netfilter_init+0x0/0x28()
initcall 0xc028f274: ipv4_netfilter_init+0x0/0x28() returned 0.
initcall 0xc028f274 ran for 0 msecs: ipv4_netfilter_init+0x0/0x28()
Calling initcall 0xc0383bb8: bictcp_register+0x0/0x28()
TCP bic registered
initcall 0xc0383bb8: bictcp_register+0x0/0x28() returned 0.
initcall 0xc0383bb8 ran for 5 msecs: bictcp_register+0x0/0x28()
Calling initcall 0xc0383e38: af_unix_init+0x0/0x70()
NET: Registered protocol family 1
initcall 0xc0383e38: af_unix_init+0x0/0x70() returned 0.
initcall 0xc0383e38 ran for 6 msecs: af_unix_init+0x0/0x70()
Calling initcall 0xc0383ea8: packet_init+0x0/0x64()
NET: Registered protocol family 17
initcall 0xc0383ea8: packet_init+0x0/0x64() returned 0.
initcall 0xc0383ea8 ran for 5 msecs: packet_init+0x0/0x64()
Calling initcall 0xc0384118: atm_clip_init+0x0/0xc8()
initcall 0xc0384118: atm_clip_init+0x0/0xc8() returned 0.
initcall 0xc0384118 ran for 0 msecs: atm_clip_init+0x0/0xc8()
Calling initcall 0xc036db30: check_cache_coherency+0x0/0x80()
initcall 0xc036db30: check_cache_coherency+0x0/0x80() returned 0.
initcall 0xc036db30 ran for 0 msecs: check_cache_coherency+0x0/0x80()
Calling initcall 0xc001cd9c: init_oops_id+0x0/0x40()
initcall 0xc001cd9c: init_oops_id+0x0/0x40() returned 0.
initcall 0xc001cd9c ran for 0 msecs: init_oops_id+0x0/0x40()
Calling initcall 0xc03733d0: disable_boot_consoles+0x0/0x6c()
initcall 0xc03733d0: disable_boot_consoles+0x0/0x6c() returned 0.
initcall 0xc03733d0 ran for 0 msecs: disable_boot_consoles+0x0/0x6c()
Calling initcall 0xc03744e8: pm_qos_power_init+0x0/0x88()
initcall 0xc03744e8: pm_qos_power_init+0x0/0x88() returned 0.
initcall 0xc03744e8 ran for 0 msecs: pm_qos_power_init+0x0/0x88()
Calling initcall 0xc0379af0: random32_reseed+0x0/0x3c()
initcall 0xc0379af0: random32_reseed+0x0/0x3c() returned 0.
initcall 0xc0379af0 ran for 0 msecs: random32_reseed+0x0/0x3c()
Calling initcall 0xc037a1e8: pci_sysfs_init+0x0/0x70()
initcall 0xc037a1e8: pci_sysfs_init+0x0/0x70() returned 0.
initcall 0xc037a1e8 ran for 0 msecs: pci_sysfs_init+0x0/0x70()
Calling initcall 0xc037ae30: seqgen_init+0x0/0x28()
initcall 0xc037ae30: seqgen_init+0x0/0x28() returned 0.
initcall 0xc037ae30 ran for 0 msecs: seqgen_init+0x0/0x28()
Calling initcall 0xc01d0f10: scsi_complete_async_scans+0x0/0xf0()
initcall 0xc01d0f10: scsi_complete_async_scans+0x0/0xf0() returned 0.
initcall 0xc01d0f10 ran for 0 msecs: scsi_complete_async_scans+0x0/0xf0()
Calling initcall 0xc03808ac: rtc_hctosys+0x0/0x140()
rtc_cmos rtc_cmos: setting system clock to 2008-04-24 19:46:15 UTC (1209066375)
initcall 0xc03808ac: rtc_hctosys+0x0/0x140() returned 0.
initcall 0xc03808ac ran for 6 msecs: rtc_hctosys+0x0/0x140()
Calling initcall 0xc0382de4: tcp_congestion_default+0x0/0xc()
initcall 0xc0382de4: tcp_congestion_default+0x0/0xc() returned 0.
initcall 0xc0382de4 ran for 0 msecs: tcp_congestion_default+0x0/0xc()
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 172k init
Adding 1572880k swap on /dev/hda6.  Priority:-1 extents:1 across:1572880k
EXT3 FS on hda12, internal journal
eth0:  setting full-duplex.
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
Warning: /proc/ide/hd?/settings interface is obsolete, and will be removed soon!
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
Bad page state in process 'Xorg'
page:c0e8b200 flags:0x00004000 mapping:00000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Call Trace:
[d54a9de0] [c0008758] show_stack+0x50/0x184 (unreliable)
[d54a9e00] [c0057e04] bad_page+0x74/0xb8
[d54a9e10] [c0057e94] destroy_compound_page+0x4c/0xe8
[d54a9e30] [c0058378] free_pages_bulk+0xc0/0x254
[d54a9e60] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d54a9e80] [c006c178] __vunmap+0x90/0xd8
[d54a9ea0] [c0177e50] drm_sg_cleanup+0x5c/0x88
[d54a9eb0] [c0173b34] drm_lastclose+0x150/0x2d8
[d54a9ed0] [c0174ca0] drm_release+0x418/0x448
[d54a9ef0] [c007ce34] __fput+0xc0/0x190
[d54a9f10] [c0079b54] filp_close+0x80/0x98
[d54a9f30] [c0079be8] sys_close+0x7c/0xb8
[d54a9f40] [c0010d50] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfcf9e5c
    LR = 0xfa37eb8
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0057dd4
Oops: Kernel access of bad area, sig: 11 [#1]
AmigaOne
Modules linked in:
NIP: c0057dd4 LR: c0057eb4 CTR: 00000000
REGS: d54a9d50 TRAP: 0300   Tainted: G    B     (2.6.25)
MSR: 00001032 <ME,IR,DR>  CR: 48000422  XER: 00000000
DAR: 00000004, DSISR: 40000000
TASK = d5454ca0[2709] 'Xorg' THREAD: d54a8000
GPR00: 00024000 d54a9e00 d5454ca0 c0e8b220 d5454ca0 00000002 00000000 00024000 
GPR08: 00000000 00000000 00000000 ffffffff 00100100 101dd518 101d5548 101d5824 
GPR16: 101d5544 101d5828 101d56f0 00000000 101d57bc 101e2824 c039cfc4 00000000 
GPR24: 00000001 00000000 00000015 00000000 00000001 c039cf9c c0e8b228 c0e8b220 
NIP [c0057dd4] bad_page+0x44/0xb8
LR [c0057eb4] destroy_compound_page+0x6c/0xe8
Call Trace:
[d54a9e00] [c0057e04] bad_page+0x74/0xb8 (unreliable)
[d54a9e10] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d54a9e30] [c0058378] free_pages_bulk+0xc0/0x254
[d54a9e60] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d54a9e80] [c006c178] __vunmap+0x90/0xd8
[d54a9ea0] [c0177e50] drm_sg_cleanup+0x5c/0x88
[d54a9eb0] [c0173b34] drm_lastclose+0x150/0x2d8
[d54a9ed0] [c0174ca0] drm_release+0x418/0x448
[d54a9ef0] [c007ce34] __fput+0xc0/0x190
[d54a9f10] [c0079b54] filp_close+0x80/0x98
[d54a9f30] [c0079be8] sys_close+0x7c/0xb8
[d54a9f40] [c0010d50] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfcf9e5c
    LR = 0xfa37eb8
Instruction dump:
3bc30008 90010014 80e30000 81030010 81630008 3c000002 60004000 7ce90038 
7f890000 7c691b78 40be0008 8123000c <81490004> 3c60c031 392b0001 38840205 
---[ end trace 3439a91ac2314edd ]---
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0057dd4
Oops: Kernel access of bad area, sig: 11 [#2]
AmigaOne
Modules linked in:
NIP: c0057dd4 LR: c0057eb4 CTR: 00000000
REGS: d5e3bdb0 TRAP: 0300   Tainted: G    B D   (2.6.25)
MSR: 00001032 <ME,IR,DR>  CR: 44002422  XER: 00000000
DAR: 00000004, DSISR: 40000000
TASK = ef8e2ca0[2125] 'klogd' THREAD: d5e3a000
GPR00: 00024000 d5e3be60 ef8e2ca0 c0e8b240 ef8e2ca0 00000002 00000000 00024000 
GPR08: 00000000 00000000 00000000 ffffffff 00000000 1001d41c 22204422 00000000 
GPR16: 100da2c8 100d0000 100b0000 00000000 00000000 10010000 c039cfc4 00000000 
GPR24: 00000016 c00114b8 0000001e 00000000 00000001 c039cf9c c0e8b248 c0e8b240 
NIP [c0057dd4] bad_page+0x44/0xb8
LR [c0057eb4] destroy_compound_page+0x6c/0xe8
Call Trace:
[d5e3be70] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d5e3be90] [c0058378] free_pages_bulk+0xc0/0x254
[d5e3bec0] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d5e3bee0] [c0014554] pgd_free+0x18/0x28
[d5e3bef0] [c001b424] __mmdrop+0x34/0xa4
[d5e3bf00] [c001971c] finish_task_switch+0x5c/0x9c
[d5e3bf10] [c02a9f28] schedule+0x2b4/0x2e4
[d5e3bf40] [c00114b8] recheck+0x0/0x20
--- Exception: c01 at 0xff51f54
    LR = 0x10002930
Instruction dump:
3bc30008 90010014 80e30000 81030010 81630008 3c000002 60004000 7ce90038 
7f890000 7c691b78 40be0008 8123000c <81490004> 3c60c031 392b0001 38840205 
---[ end trace 3439a91ac2314edd ]---
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0057dd4
Oops: Kernel access of bad area, sig: 11 [#3]
AmigaOne
Modules linked in:
NIP: c0057dd4 LR: c0057eb4 CTR: 00000006
REGS: d5e3bb30 TRAP: 0300   Tainted: G    B D   (2.6.25)
MSR: 00001032 <ME,IR,DR>  CR: 42004422  XER: 00000000
DAR: 00000004, DSISR: 40000000
TASK = ef8e2ca0[2125] 'klogd' THREAD: d5e3a000
GPR00: 00024000 d5e3bbe0 ef8e2ca0 c0e8b260 ef8e2ca0 00000002 00000000 00024000 
GPR08: 00000000 00000000 00000000 ffffffff 00100100 1001d41c 22204422 00000000 
GPR16: 100da2c8 100d0000 100b0000 00000000 00000000 10010000 c039cfc4 00000000 
GPR24: d5e3bcd8 10037fff 0000001e 00000000 00000001 c039cf9c c0e8b268 c0e8b260 
NIP [c0057dd4] bad_page+0x44/0xb8
LR [c0057eb4] destroy_compound_page+0x6c/0xe8
Call Trace:
[d5e3bbe0] [0000000a] 0xa (unreliable)
[d5e3bbf0] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d5e3bc10] [c0058378] free_pages_bulk+0xc0/0x254
[d5e3bc40] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d5e3bc60] [c0014504] pte_free+0x5c/0x6c
[d5e3bc70] [c006422c] free_pgd_range+0x12c/0x154
[d5e3bca0] [c0064438] free_pgtables+0x90/0xac
[d5e3bcd0] [c0067468] exit_mmap+0x98/0xec
[d5e3bd00] [c001b4d0] mmput+0x3c/0xd0
[d5e3bd10] [c001f06c] exit_mm+0xc4/0xd8
[d5e3bd30] [c0020864] do_exit+0x1fc/0x630
[d5e3bd70] [c000ed58] kernel_bad_stack+0x0/0x4c
[d5e3bd90] [c00134c0] bad_page_fault+0xb8/0xcc
[d5e3bda0] [c00111f0] handle_page_fault+0x7c/0x80
--- Exception: 300 at bad_page+0x44/0xb8
    LR = destroy_compound_page+0x6c/0xe8
[d5e3be60] [00000000] 0x0 (unreliable)
[d5e3be70] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d5e3be90] [c0058378] free_pages_bulk+0xc0/0x254
[d5e3bec0] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d5e3bee0] [c0014554] pgd_free+0x18/0x28
[d5e3bef0] [c001b424] __mmdrop+0x34/0xa4
[d5e3bf00] [c001971c] finish_task_switch+0x5c/0x9c
[d5e3bf10] [c02a9f28] schedule+0x2b4/0x2e4
[d5e3bf40] [c00114b8] recheck+0x0/0x20
--- Exception: c01 at 0xff51f54
    LR = 0x10002930
Instruction dump:
3bc30008 90010014 80e30000 81030010 81630008 3c000002 60004000 7ce90038 
7f890000 7c691b78 40be0008 8123000c <81490004> 3c60c031 392b0001 38840205 
---[ end trace 3439a91ac2314edd ]---
Fixing recursive fault but reboot is needed!
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0057dd4
Oops: Kernel access of bad area, sig: 11 [#4]
AmigaOne
Modules linked in:
NIP: c0057dd4 LR: c0057eb4 CTR: 00000006
REGS: d54a9ad0 TRAP: 0300   Tainted: G    B D   (2.6.25)
MSR: 00001032 <ME,IR,DR>  CR: 42004422  XER: 00000000
DAR: 00000004, DSISR: 40000000
TASK = d5454ca0[2709] 'Xorg' THREAD: d54a8000
GPR00: 00024000 d54a9b80 d5454ca0 c0e8b280 d5454ca0 00000002 00000000 00024000 
GPR08: 00000000 00000000 00000000 ffffffff 0fddc408 101dd518 101d5548 101d5824 
GPR16: 101d5544 101d5828 101d56f0 00000000 101d57bc 101e2824 c039cfc4 00000000 
GPR24: d54a9c78 00102fff 0000001e 00000000 00000001 c039cf9c c0e8b288 c0e8b280 
NIP [c0057dd4] bad_page+0x44/0xb8
LR [c0057eb4] destroy_compound_page+0x6c/0xe8
Call Trace:
[d54a9b80] [c0017bb8] set_next_entity+0x28/0x64 (unreliable)
[d54a9b90] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d54a9bb0] [c0058378] free_pages_bulk+0xc0/0x254
[d54a9be0] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d54a9c00] [c0014504] pte_free+0x5c/0x6c
[d54a9c10] [c006422c] free_pgd_range+0x12c/0x154
[d54a9c40] [c0064438] free_pgtables+0x90/0xac
[d54a9c70] [c0067468] exit_mmap+0x98/0xec
[d54a9ca0] [c001b4d0] mmput+0x3c/0xd0
[d54a9cb0] [c001f06c] exit_mm+0xc4/0xd8
[d54a9cd0] [c0020864] do_exit+0x1fc/0x630
[d54a9d10] [c000ed58] kernel_bad_stack+0x0/0x4c
[d54a9d30] [c00134c0] bad_page_fault+0xb8/0xcc
[d54a9d40] [c00111f0] handle_page_fault+0x7c/0x80
--- Exception: 300 at bad_page+0x44/0xb8
    LR = destroy_compound_page+0x6c/0xe8
[d54a9e00] [c0057e04] bad_page+0x74/0xb8 (unreliable)
[d54a9e10] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d54a9e30] [c0058378] free_pages_bulk+0xc0/0x254
[d54a9e60] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d54a9e80] [c006c178] __vunmap+0x90/0xd8
[d54a9ea0] [c0177e50] drm_sg_cleanup+0x5c/0x88
[d54a9eb0] [c0173b34] drm_lastclose+0x150/0x2d8
[d54a9ed0] [c0174ca0] drm_release+0x418/0x448
[d54a9ef0] [c007ce34] __fput+0xc0/0x190
[d54a9f10] [c0079b54] filp_close+0x80/0x98
[d54a9f30] [c0079be8] sys_close+0x7c/0xb8
[d54a9f40] [c0010d50] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfcf9e5c
    LR = 0xfa37eb8
Instruction dump:
3bc30008 90010014 80e30000 81030010 81630008 3c000002 60004000 7ce90038 
7f890000 7c691b78 40be0008 8123000c <81490004> 3c60c031 392b0001 38840205 
---[ end trace 3439a91ac2314edd ]---
Fixing recursive fault but reboot is needed!
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0057dd4
Oops: Kernel access of bad area, sig: 11 [#5]
AmigaOne
Modules linked in:
NIP: c0057dd4 LR: c0057eb4 CTR: 00000000
REGS: d5ec7a50 TRAP: 0300   Tainted: G    B D   (2.6.25)
MSR: 00001032 <ME,IR,DR>  CR: 44042422  XER: 00000000
DAR: 00000004, DSISR: 40000000
TASK = ef8f4ca0[2285] 'hald-addon-stor' THREAD: d5ec6000
GPR00: 00024000 d5ec7b00 ef8f4ca0 c0e8b2a0 ef8f4ca0 00000002 00000000 00024000 
GPR08: 00000000 00000000 00000000 ffffffff 00000000 1001c2f0 bf952e14 10000000 
GPR16: 10000000 10000000 10000000 10000000 10015c34 00000000 c039cfc4 00000000 
GPR24: ef876450 00000000 0000001e 00000000 00000001 c039cf9c c0e8b2a8 c0e8b2a0 
NIP [c0057dd4] bad_page+0x44/0xb8
LR [c0057eb4] destroy_compound_page+0x6c/0xe8
Call Trace:
[d5ec7b00] [c02a9b1c] wait_for_common+0xf8/0x1a0 (unreliable)
[d5ec7b10] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d5ec7b30] [c0058378] free_pages_bulk+0xc0/0x254
[d5ec7b60] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d5ec7b80] [c00a5ecc] bio_uncopy_user+0xd0/0x12c
[d5ec7bb0] [c010d754] __blk_rq_unmap_user+0x34/0x4c
[d5ec7bc0] [c010d79c] blk_rq_unmap_user+0x30/0x74
[d5ec7be0] [c0110da4] sg_io+0x3fc/0x41c
[d5ec7c70] [c0111064] scsi_cmd_ioctl+0x2a0/0x568
[d5ec7d10] [c01e38fc] cdrom_ioctl+0x30/0x11cc
[d5ec7d70] [c01c4f9c] idecd_ioctl+0x1a0/0x1f0
[d5ec7dd0] [c010eba8] blkdev_driver_ioctl+0x58/0x70
[d5ec7de0] [c010f38c] blkdev_ioctl+0x7cc/0x850
[d5ec7ec0] [c00a7328] block_ioctl+0x2c/0x3c
[d5ec7ed0] [c008932c] vfs_ioctl+0x38/0x84
[d5ec7ee0] [c00896c8] do_vfs_ioctl+0x350/0x38c
[d5ec7f10] [c0089744] sys_ioctl+0x40/0x70
[d5ec7f40] [c0010d50] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfed158c
    LR = 0xfed14f0
Instruction dump:
3bc30008 90010014 80e30000 81030010 81630008 3c000002 60004000 7ce90038 
7f890000 7c691b78 40be0008 8123000c <81490004> 3c60c031 392b0001 38840205 
---[ end trace 3439a91ac2314edd ]---
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0057dd4
Oops: Kernel access of bad area, sig: 11 [#6]
AmigaOne
Modules linked in:
NIP: c0057dd4 LR: c0057eb4 CTR: 00000006
REGS: d5ec77d0 TRAP: 0300   Tainted: G    B D   (2.6.25)
MSR: 00001032 <ME,IR,DR>  CR: 42044422  XER: 00000000
DAR: 00000004, DSISR: 40000000
TASK = ef8f4ca0[2285] 'hald-addon-stor' THREAD: d5ec6000
GPR00: 00024000 d5ec7880 ef8f4ca0 c0e8b2c0 ef8f4ca0 00000002 00000000 00024000 
GPR08: 00000000 00000000 00000000 ffffffff 0fe99608 1001c2f0 bf952e14 10000000 
GPR16: 10000000 10000000 10000000 10000000 10015c34 00000000 c039cfc4 00000000 
GPR24: d5ec7978 00102fff 0000001e 00000000 00000001 c039cf9c c0e8b2c8 c0e8b2c0 
NIP [c0057dd4] bad_page+0x44/0xb8
LR [c0057eb4] destroy_compound_page+0x6c/0xe8
Call Trace:
[d5ec7880] [0000000a] 0xa (unreliable)
[d5ec7890] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d5ec78b0] [c0058378] free_pages_bulk+0xc0/0x254
[d5ec78e0] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d5ec7900] [c0014504] pte_free+0x5c/0x6c
[d5ec7910] [c006422c] free_pgd_range+0x12c/0x154
[d5ec7940] [c0064438] free_pgtables+0x90/0xac
[d5ec7970] [c0067468] exit_mmap+0x98/0xec
[d5ec79a0] [c001b4d0] mmput+0x3c/0xd0
[d5ec79b0] [c001f06c] exit_mm+0xc4/0xd8
[d5ec79d0] [c0020864] do_exit+0x1fc/0x630
[d5ec7a10] [c000ed58] kernel_bad_stack+0x0/0x4c
[d5ec7a30] [c00134c0] bad_page_fault+0xb8/0xcc
[d5ec7a40] [c00111f0] handle_page_fault+0x7c/0x80
--- Exception: 300 at bad_page+0x44/0xb8
    LR = destroy_compound_page+0x6c/0xe8
[d5ec7b00] [c02a9b1c] wait_for_common+0xf8/0x1a0 (unreliable)
[d5ec7b10] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d5ec7b30] [c0058378] free_pages_bulk+0xc0/0x254
[d5ec7b60] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d5ec7b80] [c00a5ecc] bio_uncopy_user+0xd0/0x12c
[d5ec7bb0] [c010d754] __blk_rq_unmap_user+0x34/0x4c
[d5ec7bc0] [c010d79c] blk_rq_unmap_user+0x30/0x74
[d5ec7be0] [c0110da4] sg_io+0x3fc/0x41c
[d5ec7c70] [c0111064] scsi_cmd_ioctl+0x2a0/0x568
[d5ec7d10] [c01e38fc] cdrom_ioctl+0x30/0x11cc
[d5ec7d70] [c01c4f9c] idecd_ioctl+0x1a0/0x1f0
[d5ec7dd0] [c010eba8] blkdev_driver_ioctl+0x58/0x70
[d5ec7de0] [c010f38c] blkdev_ioctl+0x7cc/0x850
[d5ec7ec0] [c00a7328] block_ioctl+0x2c/0x3c
[d5ec7ed0] [c008932c] vfs_ioctl+0x38/0x84
[d5ec7ee0] [c00896c8] do_vfs_ioctl+0x350/0x38c
[d5ec7f10] [c0089744] sys_ioctl+0x40/0x70
[d5ec7f40] [c0010d50] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfed158c
    LR = 0xfed14f0
Instruction dump:
3bc30008 90010014 80e30000 81030010 81630008 3c000002 60004000 7ce90038 
7f890000 7c691b78 40be0008 8123000c <81490004> 3c60c031 392b0001 38840205 
---[ end trace 3439a91ac2314edd ]---
Fixing recursive fault but reboot is needed!
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0057dd4
Oops: Kernel access of bad area, sig: 11 [#7]
AmigaOne
Modules linked in:
NIP: c0057dd4 LR: c0057eb4 CTR: c00c3bbc
REGS: d5fc7db0 TRAP: 0300   Tainted: G    B D   (2.6.25)
MSR: 00001032 <ME,IR,DR>  CR: 48004422  XER: 00000000
DAR: 00000004, DSISR: 40000000
TASK = d5fa2000[2306] 'NetworkManager' THREAD: d5fc6000
GPR00: 00024000 d5fc7e60 d5fa2000 c0e8b2e0 d5fa2000 00000002 00000000 00024000 
GPR08: 00000000 00000000 00000000 ffffffff 00000000 1005fc0c 22224422 00000000 
GPR16: 10065720 10065700 10058bf0 10058c00 00000000 10066ee0 c039cfc4 00000000 
GPR24: 4882fc18 0000000c 0000001e 00000000 00000001 c039cf9c c0e8b2e8 c0e8b2e0 
NIP [c0057dd4] bad_page+0x44/0xb8
LR [c0057eb4] destroy_compound_page+0x6c/0xe8
Call Trace:
[d5fc7e60] [efb64ea0] 0xefb64ea0 (unreliable)
[d5fc7e70] [c0057eb4] destroy_compound_page+0x6c/0xe8
[d5fc7e90] [c0058378] free_pages_bulk+0xc0/0x254
[d5fc7ec0] [c00586e0] free_hot_cold_page+0x1d4/0x20c
[d5fc7ee0] [c00c3c44] sysfs_release+0x88/0xa8
[d5fc7ef0] [c007ce34] __fput+0xc0/0x190
[d5fc7f10] [c0079b54] filp_close+0x80/0x98
[d5fc7f30] [c0079be8] sys_close+0x7c/0xb8
[d5fc7f40] [c0010d50] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfefe1b0
    LR = 0xfefe1a0
Instruction dump:
3bc30008 90010014 80e30000 81030010 81630008 3c000002 60004000 7ce90038 
7f890000 7c691b78 40be0008 8123000c <81490004> 3c60c031 392b0001 38840205 
---[ end trace 3439a91ac2314edd ]---

--========GMX76921209069470827897--
