Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZEDKxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZEDKxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZEDKwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:52:49 -0400
Received: from h155.mvista.com ([63.81.120.155]:37372 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753010AbZEDKwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:52:47 -0400
Message-ID: <49FEC950.7020606@ru.mvista.com>
Date: Mon, 04 May 2009 14:54:08 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: petkovbb@gmail.com, TJ <tj.trevelyan@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Kernel Panic 2.6.29.6 AMD Geode (in CS5536 IDE ?)
References: <6849c8890905040053jdf71a23u746706b2b7cc798e@mail.gmail.com> <20090504080951.GA21501@liondog.tnic> <200905041047.33781.bzolnier@gmail.com>
In-Reply-To: <200905041047.33781.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>I'm not on the mailing list, so please cc me. If needed I can provide
>>>further information.

>>>I am trying to build purpose built 2.6.29.2 kernel for my ALIX.2
>>>[http://www.pcengines.ch/alix2d2.htm] instead of the generic all
>>>modular 2.6.26 kernel in Debian.
>>>The idea being is to have a slimmer kernel, no initrd*, and to include
>>>ALIX specific features that the Debian kernel does not have.

>>>(*support is enabled, but everything needed for boot should be built-in)

>>>It is not my first kernel build, I tend to do this for all my
>>>machines. Although it is the first time I have tried to build for this
>>>system.

>>>My build environment is as follows:
>>>The host is a 64bit Debian (testing) MacBook pro. However I have a
>>>100% 32bit Debian (stable) chroot install, which I also used for this.
>>>I explicitly set ARCH=i386 otherwise my 64bit CPU is detected. This is
>>>in effect a cross build, but not for an alien architecture and using
>>>the normal host gcc.
>>>(gcc (Debian 4.3.2-1.1) 4.3.2)

>>>sudo chroot /blah
>>>cd /usr/src/linux-source
>>>make ARCH=i386 clean
>>>make ARCH=i386 menuconfig
>>>make-kpkg --us -uc --arch i386 binary-arch

>>>scp, install the package and then boot.

>>>(console seems to be repeated because it is given via grub and complied in)

>>>   [Linux-bzImage, setup=0x2e00, size=0x1b0010]
>>>Probing EDD (edd=off to disable)... ok
>>>Linux version 2.6.29 (2.6.29) (root@vorchan) (gcc version 4.3.2
>>>(Debian 4.3.2-1.1) ) #1 Fri May 1 19:19:04 CEST 2009
>>>KERNEL supported cpus:
>>>  Intel GenuineIntel
>>>  AMD AuthenticAMD
>>>  NSC Geode by NSC
>>>  Cyrix CyrixInstead
>>>  Centaur CentaurHauls
>>>  Transmeta GenuineTMx86
>>>  Transmeta TransmetaCPU
>>>  UMC UMC UMC UMC
>>>PAT not supported by CPU.
>>>BIOS-provided physical RAM map:
>>> BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
>>> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>>> BIOS-e820: 0000000000100000 - 0000000010000000 (usable)
>>> BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
>>>DMI not present or invalid.
>>>last_pfn = 0x10000 max_arch_pfn = 0x100000
>>>Scanning 1 areas for low memory corruption
>>>modified physical RAM map:
>>> modified: 0000000000000000 - 0000000000001000 (usable)
>>> modified: 0000000000001000 - 0000000000010000 (reserved)
>>> modified: 0000000000010000 - 0000000000091000 (usable)
>>> modified: 00000000000f0000 - 0000000000100000 (reserved)
>>> modified: 0000000000100000 - 0000000010000000 (usable)
>>> modified: 00000000fff00000 - 0000000100000000 (reserved)
>>>ACPI Error (tbxfroot-0219): A valid RSDP was not found [20081204]
>>>0MB HIGHMEM available.
>>>256MB LOWMEM available.
>>>  mapped low ram: 0 - 10000000
>>>  low ram: 00000000 - 10000000
>>>  bootmap 00010000 - 00012000
>>>(6 early reservations) ==> bootmem [0000000000 - 0010000000]
>>>  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
>>>0000001000]
>>>  #1 [0000200000 - 000058c8f8]    TEXT DATA BSS ==> [0000200000 -
>>>000058c8f8]
>>>  #2 [000058d000 - 0000590000]    INIT_PG_TABLE ==> [000058d000 -
>>>0000590000]
>>>  #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 -
>>>0000100000]
>>>  #4 [0000010000 - 0000010000]          PGTABLE
>>>  #5 [0000010000 - 0000012000]          BOOTMAP ==> [0000010000 -
>>>0000012000]
>>>Zone PFN ranges:
>>>  DMA      0x00000000 -> 0x00001000
>>>  Normal   0x00001000 -> 0x00010000
>>>  HighMem  0x00010000 -> 0x00010000
>>>Movable zone start PFN for each node
>>>early_node_map[3] active PFN ranges
>>>    0: 0x00000000 -> 0x00000001
>>>    0: 0x00000010 -> 0x00000091
>>>    0: 0x00000100 -> 0x00010000
>>>No local APIC present or hardware disabled
>>>PM: Registered nosave memory: 0000000000001000 - 0000000000010000
>>>PM: Registered nosave memory: 0000000000091000 - 00000000000f0000
>>>PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
>>>Allocating PCI resources starting at 20000000 (gap: 10000000:eff00000)
>>>Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
>>>64898
>>>Kernel command line: console=ttyS0,38400
>>>BOOT_IMAGE=/boot/vmlinuz-2.6.29 root=/dev/hda2 ro console=ttyS0,38400
>>>Initializing CPU#0
>>>PID hash table entries: 1024 (order: 10, 4096 bytes)
>>>Fast TSC calibration using PIT
>>>Detected 498.050 MHz processor.
>>>console [ttyS0] enabled
>>>Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
>>>Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
>>>Memory: 255536k/262144k available (2129k kernel code, 5924k reserved,
>>>878k data, 300k init, 0k highmem)
>>>virtual kernel memory layout:
>>>    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
>>>    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>>>    vmalloc : 0xd0800000 - 0xff7fe000   ( 751 MB)
>>>    lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
>>>      .init : 0xc04f4000 - 0xc053f000   ( 300 kB)
>>>      .data : 0xc0414513 - 0xc04f00d8   ( 878 kB)
>>>      .text : 0xc0200000 - 0xc0414513   (2129 kB)
>>>Checking if this processor honours the WP bit even in supervisor
>>>mode...Ok.
>>>SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1,
>>>Nodes=1
>>>Calibrating delay loop (skipped), value calculated using timer
>>>frequency.. 996.10 BogoMIPS (lpj=1992200)
>>>Mount-cache hash table entries: 512
>>>CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
>>>CPU: L2 Cache: 128K (32 bytes/line)
>>>CPU: Geode(TM) Integrated Processor by AMD PCS stepping 02
>>>Checking 'hlt' instruction... OK.
>>>Freeing SMP alternatives: 0k freed
>>>net_namespace: 940 bytes
>>>regulator: core version 0.5
>>>NET: Registered protocol family 16
>>>geode-mfgpt:  8 MFGPT timers available.
>>>geode-mfgpt:  Registered timer 0
>>>mfgpt-timer:  Registering MFGPT timer 0 as a clock event, using IRQ 7
>>>EISA bus registered
>>>PCI: PCI BIOS revision 2.10 entry at 0xfced9, last bus=0
>>>PCI: Using configuration type 1 for base access
>>>bio: create slab <bio-0> at 0
>>>ACPI: Interpreter disabled.
>>>SCSI subsystem initialized
>>>usbcore: registered new interface driver usbfs
>>>usbcore: registered new interface driver hub
>>>usbcore: registered new device driver usb
>>>PCI: Probing PCI hardware
>>>pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
>>>pci 0000:00:09.0: PME# disabled
>>>pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
>>>pci 0000:00:0b.0: PME# disabled
>>>pci 0000:00:0f.4: PME# supported from D0 D3hot D3cold
>>>pci 0000:00:0f.4: PME# disabled
>>>pci 0000:00:0f.5: PME# supported from D0 D3hot D3cold
>>>pci 0000:00:0f.5: PME# disabled
>>>pnp: PnP ACPI: disabled
>>>NET: Registered protocol family 2
>>>IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
>>>TCP established hash table entries: 8192 (order: 4, 65536 bytes)
>>>TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
>>>TCP: Hash tables configured (established 8192 bind 8192)
>>>TCP reno registered
>>>NET: Registered protocol family 1
>>>platform rtc_cmos: registered platform RTC device (no PNP device
>>>found)
>>>Scanning for low memory corruption every 60 seconds
>>>squashfs: version 4.0 (2009/01/31) Phillip Lougher
>>>JFFS2 version 2.2. (NAND) (SUMMARY)  �© 2001-2006 Red Hat, Inc.
>>>msgmni has been set to 499
>>>alg: No test for stdrng (krng)
>>>io scheduler noop registered
>>>io scheduler deadline registered (default)
>>>AMD Geode RNG detected
>>>Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin
>>>is 60 seconds).
>>>Hangcheck: Using get_cycles().
>>>Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>>�serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
>>>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
>>>loop: module loaded
>>>via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
>>>eth0: VIA Rhine III (Management Adapter) at 0xe0000000,
>>>00:0d:b9:18:2d:0c, IRQ 10.
>>>eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link c5e1.
>>>eth1: VIA Rhine III (Management Adapter) at 0xe0040000,
>>>00:0d:b9:18:2d:0d, IRQ 15.
>>>eth1: MII PHY found at address 1, status 0x7849 advertising 05e1 Link 0000.
>>>Uniform Multi-Platform E-IDE driver
>>>cs5536 0000:00:0f.2: IDE controller (0x1022:0x209a rev 0x01)
>>>cs5536 0000:00:0f.2: not 100% native mode: will probe irqs later
>>>BUG: unable to handle kernel NULL pointer dereference at (null)
>>>IP: [<(null)>] (null)
>>>*pde = 00000000
>>>Oops: 0000 [#1]
>>>last sysfs file:
>>>Modules linked in:
>>>
>>>Pid: 1, comm: swapper Not tainted (2.6.29 #1)
>>>EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
>>>EIP is at 0x0
>>>EAX: cf948000 EBX: cf948000 ECX: cf948000 EDX: c042d248
>>>ESI: c042d178 EDI: cf819c58 EBP: cf819c00 ESP: cf81dd5c
>>> DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>>>Process swapper (pid: 1, ti=cf81c000 task=cf81a000 task.ti=cf81c000)
>>>Stack:
>>> c035faab cf948000 c042d178 0000ff00 c03602bf cf948000 00000000 cf94803c
>>> c042d178 c035e4fd cf81deb4 cf83ac00 cf948000 00000000 cf819cc0 01819c00
>>> 00000000 cf819c00 cf83ac00 c042d178 c036024a 00000000 000001f0 000001f1
>>>Call Trace:
>>> [<c035faab>] ide_pci_check_simplex+0x4a/0x7b
>>> [<c03602bf>] ide_hwif_setup_dma+0x5b/0xc4
>>> [<c035e4fd>] ide_host_register+0x150/0x50b
>>> [<c036024a>] ide_pci_init_one+0xa2/0xbc
>>> [<c030833f>] idr_get_empty_slot+0x14d/0x234
>>> [<c03084e1>] ida_get_new_above+0xbb/0x172
>>> [<c03aa179>] raw_pci_read+0x4d/0x55
>>> [<c03aa1f3>] pci_read+0x1c/0x21
>>> [<c031679d>] pci_bus_read_config_dword+0x28/0x3f
>>> [<c0360d97>] cs5536_init_one+0x4b/0x4e
>>> [<c031ab56>] local_pci_probe+0xb/0xc
>>> [<c031b378>] pci_device_probe+0x44/0x66
>>> [<c0352add>] driver_probe_device+0x98/0x126
>>> [<c0352bb4>] __driver_attach+0x49/0x67
>>> [<c0352598>] bus_for_each_dev+0x31/0x56
>>> [<c0352995>] driver_attach+0x11/0x13
>>> [<c0352b6b>] __driver_attach+0x0/0x67
>>> [<c0352075>] bus_add_driver+0x91/0x1a1
>>> [<c050bb55>] cs5536_init+0x0/0x11
>>> [<c0352d35>] driver_register+0x7d/0xd3
>>> [<c050bb55>] cs5536_init+0x0/0x11
>>> [<c031b534>] __pci_register_driver+0x2b/0x57
>>> [<c020112b>] _stext+0x43/0x107
>>> [<c028253d>] create_proc_entry+0x73/0x85
>>> [<c02388a8>] register_irq_proc+0x61/0x7a
>>> [<c04f445d>] kernel_init+0x6f/0xbb
>>> [<c04f43ee>] kernel_init+0x0/0xbb
>>> [<c020328f>] kernel_thread_helper+0x7/0x10
>>>Code:  Bad EIP value.
>>>EIP: [<00000000>] 0x0 SS:ESP 0068:cf81dd5c
>>>---[ end trace 1ed52fe562beb9cc ]---
>>>Kernel panic - not syncing: Attempted to kill init!

>>>I have tried to tweak the config some more since I captured that dump,
>>>but they all die before reaching init as above.
>>>I've attached my latest config, which still gives the same error but
>>>is not the exact one for the dump above.

>>>Would be grateful for help, advice or a patch. If you need anything
>>>further from me please let me know.

> This problem is already fixed in Linus' tree -- somebody just needs to
> port it to 2.6.29 and then post it to stable@kernel.org for inclusion.

    I have CC'ed stable@kernel.org on the original patch. There was no mail 
from the stable kernel team since (unlike for the hpt366 patch posted at once).

MBR, Sergei
