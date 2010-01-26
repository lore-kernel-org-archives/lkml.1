Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597Ab0AZRXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0AZRXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533Ab0AZRXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:23:23 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43660 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0AZRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:23:22 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: John Kacur <jkacur@redhat.com>
Subject: Re: [OOPS] radeon kms
Date: Tue, 26 Jan 2010 12:23:03 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc5; KDE/4.3.3; i686; ; )
Cc: Jerome Glisse <glisse@freedesktop.org>, Dave Airlie <airlied@redhat.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.00.1001151538500.5514@localhost.localdomain>
 <201001261140.11601.gene.heskett@verizon.net>
 <alpine.LFD.2.00.1001261808080.9499@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1001261808080.9499@localhost.localdomain>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Message-id: <201001261223.03157.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, John Kacur wrote:
>On Tue, 26 Jan 2010, Gene Heskett wrote:
>> On Tuesday 26 January 2010, John Kacur wrote:
>> >On Tue, Jan 26, 2010 at 2:59 PM, Alex Deucher <alexdeucher@gmail.com> 
wrote:
>> >> On Tue, Jan 26, 2010 at 8:21 AM, John Kacur <jkacur@redhat.com> wrote:
>> >>> On Fri, 15 Jan 2010, Jerome Glisse wrote:
>> >>>> On Fri, Jan 15, 2010 at 03:47:19PM +0100, John Kacur wrote:
>> >>>> > On Fri, 15 Jan 2010, John Kacur wrote:
>> >>>> > > The oops is triggered because I am missing the firmware for
>> >>>> > > radeon/R700_rlc.bin and
>> >>>> > > radeon/R600_rlc.bin
>> >>>> > >
>> >>>> > > However, I think it should be able to deal with this more
>> >>>> > > gracefully.
>> >>>> > >
>> >>>> > > ATOM BIOS: 9498.11.22.6.0.AS03
>> >>>> > > [drm] Clocks initialized !
>> >>>> > > [drm] Detected VRAM RAM=256M, BAR=256M
>> >>>> > > [drm] RAM width 128bits DDR
>> >>>> > > [TTM] Zone  kernel: Available graphics memory: 3050912 kiB.
>> >>>> > > [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
>> >>>> > > [drm] radeon: 256M of VRAM memory ready
>> >>>> > > [drm] radeon: 512M of GTT memory ready.
>> >>>> > >   alloc irq_desc for 33 on node -1
>> >>>> > >   alloc kstat_irqs on node -1
>> >>>> > > radeon 0000:02:00.0: irq 33 for MSI/MSI-X
>> >>>> > > [drm] radeon: using MSI.
>> >>>> > > [drm] radeon: irq initialized.
>> >>>> > > [drm] GART: num cpu pages 131072, num gpu pages 131072
>> >>>> > > [drm] Loading RV730 Microcode
>> >>>> > > platform radeon_cp.0: firmware: requesting radeon/RV730_pfp.bin
>> >>>> > > platform radeon_cp.0: firmware: requesting radeon/RV730_me.bin
>> >>>> > > platform radeon_cp.0: firmware: requesting radeon/R700_rlc.bin
>> >>>> > > r600_cp: Failed to load firmware "radeon/R700_rlc.bin"
>> >>>> > > [drm:rv770_startup] *ERROR* Failed to load firmware!
>> >>>> > > radeon 0000:02:00.0: ffff8801a20b5400 unpin not necessary
>> >>>> > > BUG: unable to handle kernel NULL pointer dereference at
>> >>>> > > 0000000000000048 IP: [<ffffffffa0061034>]
>> >>>> > > ttm_bo_reserve+0x16/0xf8 [ttm]
>> >>>> > > PGD 1a1a74067 PUD 1a19b8067 PMD 0
>> >>>> > > Oops: 0000 [#1] SMP
>> >>>> > > last sysfs file:
>> >>>> > > /sys/devices/platform/radeon_cp.0/firmware/radeon_cp.0/loading
>> >>>> > > CPU 4
>> >>>> > > Pid: 168, comm: modprobe Not tainted 2.6.33-rc4 #3
>> >>>> > > EX58-UD3R/EX58-UD3R RIP: 0010:[<ffffffffa0061034>]
>> >>>> > >  [<ffffffffa0061034>] ttm_bo_reserve+0x16/0xf8 [t tm]
>> >>>> > > RSP: 0018:ffff8801a1a8fb68  EFLAGS: 00010292
>> >>>> > > RAX: ffff880100000000 RBX: 0000000000000000 RCX:
>> >>>> > > 0000000000000000 RDX: 0000000000000000 RSI: 0000000000000001
>> >>>> > > RDI: 0000000000000048 RBP: ffff8801a1a8fba8 R08:
>> >>>> > > 0000000000000000 R09: 0000000000000000 R10: 0000000000000000
>> >>>> > > R11: 0000000000000000 R12: 0000000000000000 R13:
>> >>>> > > ffff8801a8838000 R14: 0000000000000024 R15: 0000000000002000 FS:
>> >>>> > >  00007f0f9c6dc700(0000) GS:ffff88002e400000(0000)
>> >>>> > > knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0:
>> >>>> > > 000000008005003b
>> >>>> > > CR2: 0000000000000048 CR3: 00000001a195d000 CR4:
>> >>>> > > 00000000000006e0 DR0: 0000000000000000 DR1: 0000000000000000
>> >>>> > > DR2: 0000000000000000 DR3: 0000000000000000 DR6:
>> >>>> > > 00000000ffff0ff0 DR7: 0000000000000400 Process modprobe (pid:
>> >>>> > > 168, threadinfo ffff8801a1a8e000, task ffff8801a22c0000) Stack:
>> >>>> > >  ffff880100000000 ffff8801a27e2900 ffff8801a1a8fb88
>> >>>> > > 0000000000000000 <0> 0000000000000000 ffff8801a8838000
>> >>>> > > 0000000000000024 0000000000002000 <0> ffff8801a1a8fbd8
>> >>>> > > ffffffffa00ba05b ffff8801a1a8fbd8 ffff8801a27f4000 Call Trace:
>> >>>> > >  [<ffffffffa00ba05b>] radeon_bo_reserve.clone.0+0x2a/0x6d
>> >>>> > > [radeon] [<ffffffffa00bb441>] rv770_suspend+0x43/0x69 [radeon]
>> >>>> > >  [<ffffffffa00bb6cf>] rv770_init+0x1a4/0x22d [radeon]
>> >>>> > >  [<ffffffffa0089593>] radeon_device_init+0x27f/0x300 [radeon]
>> >>>> > >  [<ffffffffa008a0fb>] radeon_driver_load_kms+0xff/0x184 [radeon]
>> >>>> > >  [<ffffffffa001e1a6>] drm_get_dev+0x3c4/0x4c5 [drm]
>> >>>> > >  [<ffffffff8122ea73>] ? pci_match_device+0x22/0xd0
>> >>>> > >  [<ffffffffa00c3bb8>] radeon_pci_probe+0x15/0x268 [radeon]
>> >>>> > >  [<ffffffff8122e941>] local_pci_probe+0x17/0x1b
>> >>>> > >  [<ffffffff8122f721>] pci_device_probe+0xcd/0xfd
>> >>>> > >  [<ffffffff812ce793>] ? driver_sysfs_add+0x4c/0x71
>> >>>> > >  [<ffffffff812ce95c>] driver_probe_device+0xde/0x1fe
>> >>>> > >  [<ffffffff812cead9>] __driver_attach+0x5d/0x81
>> >>>> > >  [<ffffffff812cea7c>] ? __driver_attach+0x0/0x81
>> >>>> > >  [<ffffffff812cdded>] bus_for_each_dev+0x59/0x8e
>> >>>> > >  [<ffffffff812ce6f2>] driver_attach+0x1e/0x20
>> >>>> > >  [<ffffffff812ce330>] bus_add_driver+0xd8/0x240
>> >>>> > >  [<ffffffff812cedcb>] driver_register+0x9d/0x10e
>> >>>> > >  [<ffffffff8122f969>] __pci_register_driver+0x68/0xd8
>> >>>> > >  [<ffffffff81439aa2>] ? printk+0x41/0x47
>> >>>> > >  [<ffffffffa00f7000>] ? radeon_init+0x0/0xc1 [radeon]
>> >>>> > >  [<ffffffffa0018eb3>] drm_init+0x75/0xdb [drm]
>> >>>> > >  [<ffffffffa00f7000>] ? radeon_init+0x0/0xc1 [radeon]
>> >>>> > >  [<ffffffffa00f70bf>] radeon_init+0xbf/0xc1 [radeon]
>> >>>> > >  [<ffffffff81002069>] do_one_initcall+0x5e/0x15e
>> >>>> > >  [<ffffffff81087788>] sys_init_module+0xd8/0x23a
>> >>>> > >  [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
>> >>>> > > Code: 01 00 00 00 31 c0 48 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f
>> >>>> > > c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 0f 1f
>> >>>> > > 44 00 00 <4c> 8b 27 48 89 fb 41 88 f5 41 88 d6 41 88 cf 44 89 45
>> >>>> > > c8 49 81 RIP  [<ffffffffa0061034>] ttm_bo_reserve+0x16/0xf8
>> >>>> > > [ttm] RSP <ffff8801a1a8fb68>
>> >>>> > > CR2: 0000000000000048
>> >>>> > > ---[ end trace 604e2e318733e108 ]---
>> >>>> > > udevd-work[166]: '/sbin/modprobe -b
>> >>>> > > pci:v00001002d00009498sv00001043sd00000300bc 03sc00i00'
>> >>>> > > unexpected exit with status 0x0009
>> >>>> >
>> >>>> > I forgot to mention that this is kernel version 2.6.33-rc4.
>> >>>> >
>> >>>> > Thanks.
>> >>>>
>> >>>> Yes, we didn't paid enough attention to failure path :( Sorry for
>> >>>> that Fix should be in next rc, patch is:
>> >>>> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=comm
>> >>>>it; h=30d2d9a54d48e4fefede0389ded1b6fc2d44a522
>> >>>
>> >>> I think your fix didn't make it to 2.6.33-rc5 because I'm still
>> >>> oopsing when I don't grab the firmware from the internet. (instead of
>> >>> merely reverting to vga mode).
>> >>>
>> >>> Furthermore, why is the firmware not shipped with the kernel?
>> >>> I never needed to fetch firmware for the 2.6.31 kernels and my
>> >>> graphic card worked fine.
>> >>>
>> >>> Am I right to conclude that the license is a problem?
>> >>> http://people.freedesktop.org/~agd5f/radeon_ucode/LICENSE.radeon
>> >>>
>> >>> This is a huge step backwards if we are exchanging a working driver
>> >>> with what shipped with the linux kernel to one that only works with
>> >>> blobs that don't ship with the kernel.
>> >>
>> >> In general, microcode is slowly being moved out of the kernel and into
>> >> the Linux firmware tree:
>> >> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=t
>> >>ree Eventually all of the radeon microcode will end up out up in that
>> >> tree.
>> >
>> >Okay, but why are R600_rlc.bin  R700_rlc.bin in particular missing
>> >from the firmware?
>>
>> They are not missing, IF you captured and saved them when they were
>> announced on this list, circa about a year ago I believe. According to an
>> ls -l in the /lib/firmware/radeon directory that was late in 2008 when
>> the originals were transmitted, but I see that many of mine, including
>> the first of those 2 files is now carrying a Dec 25, 2009 date.
>>
>> However, I don't have the R700_rlc.bin as mine is an HD2400 Pro, an
>> rv610, for which development seems to be frozen.  Its working, _most_ of
>> the time but its not a speed demon either...  Biggest problem is
>> un-controllable screen blanking occasionally, and only a reboot will fix
>> it.
>>
>> Rafael is tracking that bug.
>>
>> My kernel building scripts have been copying /lib/firmware/radeon into
>> the kernel tree, and include a make firmware-install stage.  I have NDI
>> how a normal 'make install' handles that.  My way seems to work. :)
>
>Hi Gene.
>
>Thank you for your reponses, but please don't drop everyone from the cc
>list. Forwarding this with the original cc list.
>
>John
>
My bad. I don't normally use the reply-all button cuz it just floods 
everybody on the CC: list with 2 copies of my message, and its not 100% 
intuitive I should when there is a lengthy CC: list.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

The only reward of virtue is virtue.
		-- Ralph Waldo Emerson
