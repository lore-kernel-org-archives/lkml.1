Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbYKSNkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYKSNkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYKSNkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:40:08 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:24603 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYKSNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vDTWoBpZqVzaGDoNwcJN24deMq0l4WxhEo3BzuFyEaeVnWC/psYFBxN6L6zdJKPa8v
         Xutt9QkTXgSbVao0qA+pUvfAW3wwpODX0DUKlQ+YRVwxhLyyjMIygku74wPuv9bnni+6
         GoEzRBp6N1fYMQRC9BO/9ZGZ3It4XMdbUk4pI=
Message-ID: <ea3b75ed0811190540t2c39bce4taca8d227caad84c8@mail.gmail.com>
Date: Wed, 19 Nov 2008 08:40:02 -0500
From: "Brian Phelps" <lm317t@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at mm/slab.c:601
In-Reply-To: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another crash, different output

[ 2128.370238] monitor: Corrupted page table at address 82a4468
[ 2128.370257] PGD 10869067 PUD 23232323 BAD
[ 2128.370271] Bad pagetable: 000d [1] SMP
[ 2128.370276] CPU 2
[ 2128.370281] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
dm_log dm_mod coretemp w83627ehf hwmon_vid bttv ir_common
compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_i801 shpchp
pci_hotplug rng_core i2c_core iTCO_wdt ftdi_sio usbserial video output
button snd_pcsp intel_agp snd_hda_intel snd_pcm snd_timer snd
soundcore snd_page_alloc evdev ext2 mbcache sd_mod usbhid hid
ff_memless ata_piix ata_generic libata scsi_mod dock piix floppy
ide_pci_generic ide_core ehci_hcd r8169 mii uhci_hcd thermal processor
fan thermal_sys
[ 2128.370401] Pid: 2867, comm: monitor Not tainted 2.6.27.6 #3
[ 2128.370403] RIP: 0023:[<00000000f715f2a0>]  [<00000000f715f2a0>] 0xf715f2a0
[ 2128.370419] RSP: 002b:00000000ffb3aaa0  EFLAGS: 00010292
[ 2128.370421] RAX: 0000000000000b33 RBX: 00000000f716cff4 RCX: 00000000ffb3abdc
[ 2128.370423] RDX: 00000000082a445c RSI: 00000000082a4450 RDI: 00000000ffb3ab5c
[ 2128.370424] RBP: 00000000ffb3aae8 R08: ffffffffffffff10 R09: 00000000082a4450
[ 2128.370426] R10: 0000000000000000 R11: 0000000000001000 R12: 0000000000000000
[ 2128.370428] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2128.370430] FS:  0000000000000000(0000) GS:ffff88001e93f1c0(0063)
knlGS:00000000f7015aa0
[ 2128.370432] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 2128.370434] CR2: ffff880023232208 CR3: 000000001209f000 CR4: 00000000000006e0
[ 2128.370435] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2128.370437] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2128.370439] Process monitor (pid: 2867, threadinfo
ffff8800108da000, task ffff88001ed5e700)
[ 2128.370441]
[ 2128.370442] RIP  [<00000000f715f2a0>] 0xf715f2a0
[ 2128.370445]  RSP <00000000ffb3aaa0>
[ 2128.370451] ---[ end trace ed9f32be6ace5f07 ]---
[ 2128.370572] mm/memory.c:124: bad pud ffff880010869000(0000000023232323).
[ 2128.458293] ------------[ cut here ]------------
[ 2128.458306] kernel BUG at mm/mmap.c:2088!
[ 2128.458308] invalid opcode: 0000 [2] SMP
[ 2128.458311] CPU 2
[ 2128.458315] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
dm_log dm_mod coretemp w83627ehf hwmon_vid bttv ir_common
compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_i801 shpchp
pci_hotplug rng_core i2c_core iTCO_wdt ftdi_sio usbserial video output
button snd_pcsp intel_agp snd_hda_intel snd_pcm snd_timer snd
soundcore snd_page_alloc evdev ext2 mbcache sd_mod usbhid hid
ff_memless ata_piix ata_generic libata scsi_mod dock piix floppy
ide_pci_generic ide_core ehci_hcd r8169 mii uhci_hcd thermal processor
fan thermal_sys
[ 2128.458352] Pid: 2867, comm: monitor Tainted: G      D   2.6.27.6 #3
[ 2128.458353] RIP: 0010:[<ffffffff80288a5c>]  [<ffffffff80288a5c>]
exit_mmap+0xe9/0xf4
[ 2128.458363] RSP: 0000:ffff8800108dbd38  EFLAGS: 00010202
[ 2128.458364] RAX: 0000000000000000 RBX: ffff880001023380 RCX: 000000000000028b
[ 2128.458366] RDX: ffff88001ccf62e0 RSI: ffff88001e079e48 RDI: ffff88001e822380
[ 2128.458368] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88001e9b3200
[ 2128.458370] R10: 0000000000000002 R11: ffffffff802faf6a R12: ffff88001ccf6280
[ 2128.458372] R13: ffff88001ccf62e0 R14: ffff88001ed5e700 R15: ffff88001ccf62e0
[ 2128.458374] FS:  0000000000000000(0000) GS:ffff88001e93f1c0(0000)
knlGS:0000000000000000
[ 2128.458376] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 2128.458377] CR2: ffff880023232208 CR3: 000000001192b000 CR4: 00000000000006e0
[ 2128.458379] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2128.458381] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2128.458383] Process monitor (pid: 2867, threadinfo
ffff8800108da000, task ffff88001ed5e700)
[ 2128.458384] Stack:  0000000000000d39 ffff880001023380
ffff88001ccf6280 ffff88001ed5e700
[ 2128.458389]  ffff88001ccf6280 ffffffff802347a8 0000000000000000
ffffffff80237c8f
[ 2128.458392]  0000000000000282 ffff88001ed5e700 0000000000000001
ffff88001ed5e700
[ 2128.458394] Call Trace:
[ 2128.458399]  [<ffffffff802347a8>] mmput+0x20/0x9e
[ 2128.458402]  [<ffffffff80237c8f>] exit_mm+0xfd/0x108
[ 2128.458405]  [<ffffffff802399e5>] do_exit+0x208/0x318
[ 2128.458408]  [<ffffffff8020d4e9>] oops_begin+0x0/0x86
[ 2128.458413]  [<ffffffff80221bc3>] do_page_fault+0x1a9/0x68e
[ 2128.458417]  [<ffffffff802cdafd>] compat_do_readv_writev+0x238/0x259
[ 2128.458419]  [<ffffffff802cd360>] compat_sys_select+0x9e/0x13d
[ 2128.458423]  [<ffffffff8043d209>] error_exit+0x0/0x51
[ 2128.458424]
[ 2128.458425]
[ 2128.458426] Code: 7b 18 e8 80 64 00 00 c7 43 08 00 00 00 00 eb 0b
48 89 ef e8 c0 fe ff ff 48 89 c5 48 85 ed 75 f0 49 83 bc 24 e8 00 00
00 00 74 04 <0f> 0b eb fe 59 5e 5b 5d 41 5c c3 41 56 41 be f4 ff ff ff
41 55
[ 2128.458449] RIP  [<ffffffff80288a5c>] exit_mmap+0xe9/0xf4
[ 2128.458451]  RSP <ffff8800108dbd38>
[ 2128.458471] ---[ end trace ed9f32be6ace5f07 ]---
[ 2128.458473] Fixing recursive fault but reboot is needed!
[ 2207.781696] BUG: unable to handle kernel paging request at ffffe3a407000000
[ 2207.781712] IP: [<ffffffff8029c3c2>] free_block+0x48/0x11f
[ 2207.781727] PGD 0
[ 2207.781729] Oops: 0000 [3] SMP
[ 2207.781732] CPU 3
[ 2207.781734] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
dm_log dm_mod coretemp w83627ehf hwmon_vid bttv ir_common
compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_i801 shpchp
pci_hotplug rng_core i2c_core iTCO_wdt ftdi_sio usbserial video output
button snd_pcsp intel_agp snd_hda_intel snd_pcm snd_timer snd
soundcore snd_page_alloc evdev ext2 mbcache sd_mod usbhid hid
ff_memless ata_piix ata_generic libata scsi_mod dock piix floppy
ide_pci_generic ide_core ehci_hcd r8169 mii uhci_hcd thermal processor
fan thermal_sys
[ 2207.781770] Pid: 18, comm: events/3 Tainted: G      D   2.6.27.6 #3
[ 2207.781772] RIP: 0010:[<ffffffff8029c3c2>]  [<ffffffff8029c3c2>]
free_block+0x48/0x11f
[ 2207.781776] RSP: 0000:ffff88001ea2ddd0  EFLAGS: 00010016
[ 2207.781777] RAX: 000001a407000000 RBX: ffff88001ea78500 RCX: ffffe20000000000
[ 2207.781779] RDX: ffffe3a407000000 RSI: ffff88001e00e018 RDI: 0000000200000000
[ 2207.781781] RBP: 0000000200000000 R08: 0000000000000000 R09: ffff880001034e20
[ 2207.781783] R10: 0000000000000000 R11: 0000000200000000 R12: 0000000000000000
[ 2207.781784] R13: ffff88001e00e018 R14: 000000000000002c R15: 0000000000000060
[ 2207.781786] FS:  0000000000000000(0000) GS:ffff88001e9d5940(0000)
knlGS:0000000000000000
[ 2207.781788] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 2207.781790] CR2: ffffe3a407000000 CR3: 00000000105ae000 CR4: 00000000000006e0
[ 2207.781792] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2207.781794] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2207.781796] Process events/3 (pid: 18, threadinfo ffff88001ea2c000,
task ffff88001ea2b500)
[ 2207.781797] Stack:  0000000000000000 ffff88001e00e018
0000000000000060 ffff88001e00e000
[ 2207.781801]  ffff88001e04ea40 0000000000000000 ffff88001ea78500
ffffffff8029c651
[ 2207.781804]  0000000000000000 ffffffff805f61d0 ffff88001e04ea40
ffff88001ea78500
[ 2207.781807] Call Trace:
[ 2207.781810]  [<ffffffff8029c651>] ? drain_array+0x89/0xbb
[ 2207.781813]  [<ffffffff8029d323>] ? cache_reap+0x105/0x205
[ 2207.781815]  [<ffffffff8029d21e>] ? cache_reap+0x0/0x205
[ 2207.781818]  [<ffffffff80244f04>] ? run_workqueue+0x79/0xfe
[ 2207.781820]  [<ffffffff80245061>] ? worker_thread+0xd8/0xe7
[ 2207.781824]  [<ffffffff8024839a>] ? autoremove_wake_function+0x0/0x2e
[ 2207.781826]  [<ffffffff80244f89>] ? worker_thread+0x0/0xe7
[ 2207.781829]  [<ffffffff80248076>] ? kthread+0x47/0x73
[ 2207.781834]  [<ffffffff80233bd8>] ? schedule_tail+0x27/0x5f
[ 2207.781839]  [<ffffffff8020ce69>] ? child_rip+0xa/0x11
[ 2207.781841]  [<ffffffff8024802f>] ? kthread+0x0/0x73
[ 2207.781843]  [<ffffffff8020ce5f>] ? child_rip+0x0/0x11
[ 2207.781844]
[ 2207.781845]
[ 2207.781846] Code: 48 83 ec 08 e9 e3 00 00 00 49 8b 6d 00 48 89 ef
e8 fc 5c f8 ff 48 c1 e8 0c 48 b9 00 00 00 00 00 e2 ff ff 48 6b c0 38
48 8d 14 08 <48> 8b 02 f6 c4 40 74 04 48 8b 52 10 80 3a 00 78 04 0f 0b
eb fe
[ 2207.781869] RIP  [<ffffffff8029c3c2>] free_block+0x48/0x11f
[ 2207.781871]  RSP <ffff88001ea2ddd0>
[ 2207.781873] CR2: ffffe3a407000000
[ 2207.781875] ---[ end trace ed9f32be6ace5f07 ]---


On Tue, Nov 18, 2008 at 6:24 PM, Brian Phelps <lm317t@gmail.com> wrote:
> This possible kernel bug (see bottom) is very reproducible when the
> pci bus gets loaded with traffic, specifically video data.
> It has been reproduced on 2 identical machines.
>
> Please let me know if you need more information
>
> # uname -r
> 2.6.27.6
>
> # free -m
>             total       used       free     shared    buffers     cached
> Mem:           487        139        347          0          2         24
> -/+ buffers/cache:        113        374
> Swap:            0          0          0
>
> #gcc -v
> Using built-in specs.
> Target: i486-linux-gnu
> Configured with: ../src/configure -v --with-pkgversion='Debian
> 4.3.2-1' --with-bugurl=file:///usr/share/doc/gcc-4.3/README.Bugs
> --enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
> --enable-shared --with-system-zlib --libexecdir=/usr/lib
> --without-included-gettext --enable-threads=posix --enable-nls
> --with-gxx-include-dir=/usr/include/c++/4.3 --program-suffix=-4.3
> --enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc
> --enable-mpfr --enable-targets=all --enable-cld
> --enable-checking=release --build=i486-linux-gnu --host=i486-linux-gnu
> --target=i486-linux-gnu
> Thread model: posix
> gcc version 4.3.2 (Debian 4.3.2-1)
>
>
>
> # lspci -v
> 00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
> Controller (rev 10)
>        Flags: bus master, fast devsel, latency 0
>        Capabilities: [e0] Vendor Specific Information <?>
>        Kernel driver in use: agpgart-intel
>        Kernel modules: intel-agp
>
> 00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI
> Express Root Port (rev 10) (prog-if 00 [Normal decode])
>        Flags: bus master, fast devsel, latency 0
>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>        Capabilities: [88] Subsystem: Intel Corporation Device 0000
>        Capabilities: [80] Power Management version 3
>        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable+
>        Capabilities: [a0] Express Root Port (Slot+), MSI 00
>        Capabilities: [100] Virtual Channel <?>
>        Capabilities: [140] Root Complex Link <?>
>        Kernel driver in use: pcieport-driver
>        Kernel modules: shpchp
>
> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
> Integrated Graphics Controller (rev 10) (prog-if 00 [VGA controller])
>        Subsystem: Intel Corporation 82G33/G31 Express Integrated
> Graphics Controller
>        Flags: bus master, fast devsel, latency 0, IRQ 16
>        Memory at feb00000 (32-bit, non-prefetchable) [size=512K]
>        I/O ports at e140 [size=8]
>        Memory at c0000000 (32-bit, prefetchable) [size=256M]
>        Memory at fe900000 (32-bit, non-prefetchable) [size=1M]
>        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable-
>        Capabilities: [d0] Power Management version 2
>
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
> Definition Audio Controller (rev 01)
>        Subsystem: Intel Corporation Device d608
>        Flags: bus master, fast devsel, latency 0, IRQ 16
>        Memory at feb80000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [50] Power Management version 2
>        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>        Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
>        Capabilities: [100] Virtual Channel <?>
>        Capabilities: [130] Root Complex Link <?>
>        Kernel driver in use: HDA Intel
>        Kernel modules: snd-hda-intel
>
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 1 (rev 01) (prog-if 00 [Normal decode])
>        Flags: bus master, fast devsel, latency 0
>        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>        Capabilities: [40] Express Root Port (Slot+), MSI 00
>        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable+
>        Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7
> Family) PCI Express Port 1
>        Capabilities: [a0] Power Management version 2
>        Capabilities: [100] Virtual Channel <?>
>        Capabilities: [180] Root Complex Link <?>
>        Kernel driver in use: pcieport-driver
>        Kernel modules: shpchp
>
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 2 (rev 01) (prog-if 00 [Normal decode])
>        Flags: bus master, fast devsel, latency 0
>        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>        I/O behind bridge: 0000d000-0000dfff
>        Memory behind bridge: fea00000-feafffff
>        Capabilities: [40] Express Root Port (Slot+), MSI 00
>        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable+
>        Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7
> Family) PCI Express Port 2
>        Capabilities: [a0] Power Management version 2
>        Capabilities: [100] Virtual Channel <?>
>        Capabilities: [180] Root Complex Link <?>
>        Kernel driver in use: pcieport-driver
>        Kernel modules: shpchp
>
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1
>        Flags: bus master, medium devsel, latency 0, IRQ 23
>        I/O ports at e080 [size=32]
>        Kernel driver in use: uhci_hcd
>        Kernel modules: uhci-hcd
>
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2
>        Flags: bus master, medium devsel, latency 0, IRQ 19
>        I/O ports at e060 [size=32]
>        Kernel driver in use: uhci_hcd
>        Kernel modules: uhci-hcd
>
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3
>        Flags: bus master, medium devsel, latency 0, IRQ 18
>        I/O ports at e040 [size=32]
>        Kernel driver in use: uhci_hcd
>        Kernel modules: uhci-hcd
>
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4
>        Flags: bus master, medium devsel, latency 0, IRQ 16
>        I/O ports at e020 [size=32]
>        Kernel driver in use: uhci_hcd
>        Kernel modules: uhci-hcd
>
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
> EHCI Controller (rev 01) (prog-if 20 [EHCI])
>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller
>        Flags: bus master, medium devsel, latency 0, IRQ 23
>        Memory at feb84000 (32-bit, non-prefetchable) [size=1K]
>        Capabilities: [50] Power Management version 2
>        Capabilities: [58] Debug port: BAR=1 offset=00a0
>        Kernel driver in use: ehci_hcd
>        Kernel modules: ehci-hcd
>
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
> (prog-if 01 [Subtractive decode])
>        Flags: bus master, fast devsel, latency 0
>        Bus: primary=00, secondary=04, subordinate=06, sec-latency=248
>        Prefetchable memory behind bridge: 00000000d0000000-00000000d01fffff
>        Capabilities: [50] Subsystem: Gammagraphx, Inc. Device 0000
>
> 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
> Interface Bridge (rev 01)
>        Subsystem: Intel Corporation DeskTop Board D945GTP
>        Flags: bus master, medium devsel, latency 0
>        Capabilities: [e0] Vendor Specific Information <?>
>        Kernel modules: intel-rng, iTCO_wdt
>
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
> Controller (rev 01) (prog-if 8a [Master SecP PriP])
>        Subsystem: Intel Corporation 82801G (ICH7 Family) IDE Controller
>        Flags: bus master, medium devsel, latency 0, IRQ 18
>        I/O ports at 01f0 [size=8]
>        I/O ports at 03f4 [size=1]
>        I/O ports at 0170 [size=8]
>        I/O ports at 0374 [size=1]
>        I/O ports at e0f0 [size=16]
>        Kernel driver in use: PIIX_IDE
>        Kernel modules: ata_piix, piix
>
> 00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
> SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
>        Subsystem: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA
> IDE Controller
>        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
>        I/O ports at e0e0 [size=8]
>        I/O ports at e0d0 [size=4]
>        I/O ports at e0c0 [size=8]
>        I/O ports at e0b0 [size=4]
>        I/O ports at e0a0 [size=16]
>        Capabilities: [70] Power Management version 2
>        Kernel driver in use: ata_piix
>        Kernel modules: ata_piix
>
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
>        Subsystem: Intel Corporation Device d608
>        Flags: medium devsel, IRQ 19
>        I/O ports at e000 [size=32]
>        Kernel driver in use: i801_smbus
>        Kernel modules: i2c-i801
>
> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
>        Subsystem: Intel Corporation Device d608
>        Flags: bus master, fast devsel, latency 0, IRQ 1276
>        I/O ports at d000 [size=256]
>        Memory at fea20000 (64-bit, non-prefetchable) [size=4K]
>        Expansion ROM at fea00000 [disabled] [size=128K]
>        Capabilities: [40] Power Management version 2
>        Capabilities: [48] Vital Product Data <?>
>        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/1 Enable+
>        Capabilities: [60] Express Endpoint, MSI 00
>        Capabilities: [84] Vendor Specific Information <?>
>        Capabilities: [100] Advanced Error Reporting <?>
>        Capabilities: [12c] Virtual Channel <?>
>        Capabilities: [148] Device Serial Number 68-81-ec-00-00-00-00-00
>        Capabilities: [154] Power Budgeting <?>
>        Kernel driver in use: r8169
>        Kernel modules: r8169
>
> 04:05.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge
> (non-transparent mode) (rev 11) (prog-if 00 [Normal decode])
>        Flags: bus master, medium devsel, latency 248
>        Bus: primary=04, secondary=05, subordinate=05, sec-latency=248
>        Prefetchable memory behind bridge: d0100000-d01fffff
>        Capabilities: [80] Power Management version 2
>        Capabilities: [90] CompactPCI hot-swap <?>
>        Kernel modules: shpchp
>
> 04:06.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge
> (non-transparent mode) (rev 11) (prog-if 00 [Normal decode])
>        Flags: bus master, medium devsel, latency 248
>        Bus: primary=04, secondary=06, subordinate=06, sec-latency=248
>        Prefetchable memory behind bridge: d0000000-d00fffff
>        Capabilities: [80] Power Management version 2
>        Capabilities: [90] CompactPCI hot-swap <?>
>        Kernel modules: shpchp
>
> 05:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa00:1460
>        Flags: bus master, medium devsel, latency 248, IRQ 20
>        Memory at d0107000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 05:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa00:1460
>        Flags: bus master, medium devsel, latency 248, IRQ 11
>        Memory at d0106000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
> 05:09.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa01:1461
>        Flags: bus master, medium devsel, latency 248, IRQ 21
>        Memory at d0105000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 05:09.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa01:1461
>        Flags: bus master, medium devsel, latency 248, IRQ 10
>        Memory at d0104000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
> 05:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa02:1462
>        Flags: bus master, medium devsel, latency 248, IRQ 22
>        Memory at d0103000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 05:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa02:1462
>        Flags: bus master, medium devsel, latency 248, IRQ 5
>        Memory at d0102000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
> 05:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa03:1463
>        Flags: bus master, medium devsel, latency 248, IRQ 23
>        Memory at d0101000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 05:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa03:1463
>        Flags: bus master, medium devsel, latency 248, IRQ 5
>        Memory at d0100000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
> 06:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa00:1460
>        Flags: bus master, medium devsel, latency 248, IRQ 21
>        Memory at d0007000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 06:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa00:1460
>        Flags: bus master, medium devsel, latency 248, IRQ 10
>        Memory at d0006000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
> 06:09.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa01:1461
>        Flags: bus master, medium devsel, latency 248, IRQ 22
>        Memory at d0005000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 06:09.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa01:1461
>        Flags: bus master, medium devsel, latency 248, IRQ 5
>        Memory at d0004000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
> 06:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa02:1462
>        Flags: bus master, medium devsel, latency 248, IRQ 23
>        Memory at d0003000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 06:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa02:1462
>        Flags: bus master, medium devsel, latency 248, IRQ 5
>        Memory at d0002000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
> 06:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
>        Subsystem: Device aa03:1463
>        Flags: bus master, medium devsel, latency 248, IRQ 20
>        Memory at d0001000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: bttv
>        Kernel modules: bttv
>
> 06:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>        Subsystem: Device aa03:1463
>        Flags: bus master, medium devsel, latency 248, IRQ 11
>        Memory at d0000000 (32-bit, prefetchable) [size=4K]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>
>
> My processor is:
>
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
> stepping        : 11
> cpu MHz         : 2399.941
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4799.88
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
> stepping        : 11
> cpu MHz         : 2399.941
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 4
> apicid          : 1
> initial apicid  : 1
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4799.94
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> processor       : 2
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
> stepping        : 11
> cpu MHz         : 2399.941
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 2
> cpu cores       : 4
> apicid          : 2
> initial apicid  : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4799.97
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> processor       : 3
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
> stepping        : 11
> cpu MHz         : 2399.941
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 3
> cpu cores       : 4
> apicid          : 3
> initial apicid  : 3
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4799.95
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> [  213.780055] ------------[ cut here ]------------
> [  213.780060] kernel BUG at mm/slab.c:601!
> [  213.780063] invalid opcode: 0000 [1] SMP
> [  213.780066] CPU 3
> [  213.780068] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
> dm_log dm_mod coretemp w83627ehf hwmon_vid bttv ir_common
> compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
> videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_i801 rng_core
> i2c_core ftdi_sio video snd_pcsp snd_hda_intel shpchp pci_hotplug
> iTCO_wdt output usbserial button snd_pcm intel_agp snd_timer snd
> soundcore snd_page_alloc evdev ext2 mbcache sd_mod ata_piix usbhid hid
> ff_memless ata_generic piix libata scsi_mod dock floppy
> ide_pci_generic ide_core ehci_hcd r8169 mii uhci_hcd thermal processor
> fan thermal_sys
> [  213.780117] Pid: 18, comm: events/3 Not tainted 2.6.27.6 #3
> [  213.780119] RIP: 0010:[<ffffffff8029c3d3>]  [<ffffffff8029c3d3>]
> free_block+0x59/0x11f
> [  213.780128] RSP: 0000:ffff88001ea2ddd0  EFLAGS: 00010002
> [  213.780131] RAX: 0100000000010068 RBX: ffff88001c8043c0 RCX: ffffe20000000000
> [  213.780134] RDX: ffffe200005e5830 RSI: ffff88001cc0c018 RDI: ffff88001af4a580
> [  213.780136] RBP: ffff88001af4a580 R08: 0000000000000000 R09: ffff88001eefba18
> [  213.780139] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  213.780141] R13: ffff88001cc0c018 R14: 000000000000002c R15: 000000000000002c
> [  213.780144] FS:  0000000000000000(0000) GS:ffff88001e9d5940(0000)
> knlGS:0000000000000000
> [  213.780147] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [  213.780150] CR2: 00000000f7efff05 CR3: 000000000612c000 CR4: 00000000000006e0
> [  213.780152] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  213.780155] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  213.780158] Process events/3 (pid: 18, threadinfo ffff88001ea2c000,
> task ffff88001ea2b500)
> [  213.780160] Stack:  0000000000000000 ffff88001cc0c018
> 000000000000002c ffff88001cc0c000
> [  213.780166]  ffff88001cc9ac40 0000000000000000 ffff88001c8043c0
> ffffffff8029c651
> [  213.780171]  0000000000000000 ffffffff805f61d0 ffff88001cc9ac40
> ffff88001c8043c0
> [  213.780175] Call Trace:
> [  213.780179]  [<ffffffff8029c651>] ? drain_array+0x89/0xbb
> [  213.780182]  [<ffffffff8029d323>] ? cache_reap+0x105/0x205
> [  213.780186]  [<ffffffff8029d21e>] ? cache_reap+0x0/0x205
> [  213.780190]  [<ffffffff80244f04>] ? run_workqueue+0x79/0xfe
> [  213.780193]  [<ffffffff80245061>] ? worker_thread+0xd8/0xe7
> [  213.780197]  [<ffffffff8024839a>] ? autoremove_wake_function+0x0/0x2e
> [  213.780200]  [<ffffffff80244f89>] ? worker_thread+0x0/0xe7
> [  213.780203]  [<ffffffff80248076>] ? kthread+0x47/0x73
> [  213.780207]  [<ffffffff80233bd8>] ? schedule_tail+0x27/0x5f
> [  213.780211]  [<ffffffff8020ce69>] ? child_rip+0xa/0x11
> [  213.780215]  [<ffffffff8024802f>] ? kthread+0x0/0x73
> [  213.780218]  [<ffffffff8020ce5f>] ? child_rip+0x0/0x11
> [  213.780219]
> [  213.780220]
> [  213.780222] Code: fc 5c f8 ff 48 c1 e8 0c 48 b9 00 00 00 00 00 e2
> ff ff 48 6b c0 38 48 8d 14 08 48 8b 02 f6 c4 40 74 04 48 8b 52 10 80
> 3a 00 78 04 <0f> 0b eb fe 48 8b 72 30 4a 8b 4c f3 08 48 8b 16 48 8b 46
> 08 48
> [  213.780256] RIP  [<ffffffff8029c3d3>] free_block+0x59/0x11f
> [  213.780260]  RSP <ffff88001ea2ddd0>
> [  213.780263] ---[ end trace 9ddcc7899ba6622f ]---
>
