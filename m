Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068Ab0AZOT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0AZOT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012Ab0AZOT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:19:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41727 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab0AZOT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F8/ZC2l1uJsYsu2Y5Uk+cUfPFJqAgOQoP3E0nQj1JmXxcu8NGEMsQLJb52kzD4ma8w
         aEoc5zRsYQPH6Bjggq0nBQLrvIVYSm5aMlr9nOangiPWWekDjHUnF2YVw2yWGz1a+41L
         rw7eNuyWXXHdNuHvS/huTY4gpsLRXKu4LxceQ=
MIME-Version: 1.0
In-Reply-To: <520f0cf11001260610g7380e4c0y4496554e5700564f@mail.gmail.com>
References: <alpine.LFD.2.00.1001151538500.5514@localhost.localdomain>
	 <alpine.LFD.2.00.1001151546350.5514@localhost.localdomain>
	 <20100115153852.GA13297@localhost.localdomain>
	 <alpine.LFD.2.00.1001261417220.9499@localhost.localdomain>
	 <a728f9f91001260559h3bd86e28sc6b76c327d5fc84d@mail.gmail.com>
	 <520f0cf11001260610g7380e4c0y4496554e5700564f@mail.gmail.com>
Date: Tue, 26 Jan 2010 09:19:54 -0500
Message-ID: <a728f9f91001260619n2c22d14vcbfc676d771e13b9@mail.gmail.com>
Subject: Re: [OOPS] radeon kms
From: Alex Deucher <alexdeucher@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Jerome Glisse <glisse@freedesktop.org>, Jerome Glisse <jglisse@redhat.com>,
       Dave Airlie <airlied@redhat.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 9:10 AM, John Kacur <jkacur@redhat.com> wrote:
> On Tue, Jan 26, 2010 at 2:59 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Tue, Jan 26, 2010 at 8:21 AM, John Kacur <jkacur@redhat.com> wrote:
>>>
>>>
>>> On Fri, 15 Jan 2010, Jerome Glisse wrote:
>>>
>>>> On Fri, Jan 15, 2010 at 03:47:19PM +0100, John Kacur wrote:
>>>> >
>>>> >
>>>> > On Fri, 15 Jan 2010, John Kacur wrote:
>>>> >
>>>> > > The oops is triggered because I am missing the firmware for
>>>> > > radeon/R700_rlc.bin and
>>>> > > radeon/R600_rlc.bin
>>>> > >
>>>> > > However, I think it should be able to deal with this more gracefully.
>>>> > >
>>>> > > ATOM BIOS: 9498.11.22.6.0.AS03
>>>> > > [drm] Clocks initialized !
>>>> > > [drm] Detected VRAM RAM=256M, BAR=256M
>>>> > > [drm] RAM width 128bits DDR
>>>> > > [TTM] Zone  kernel: Available graphics memory: 3050912 kiB.
>>>> > > [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
>>>> > > [drm] radeon: 256M of VRAM memory ready
>>>> > > [drm] radeon: 512M of GTT memory ready.
>>>> > >   alloc irq_desc for 33 on node -1
>>>> > >   alloc kstat_irqs on node -1
>>>> > > radeon 0000:02:00.0: irq 33 for MSI/MSI-X
>>>> > > [drm] radeon: using MSI.
>>>> > > [drm] radeon: irq initialized.
>>>> > > [drm] GART: num cpu pages 131072, num gpu pages 131072
>>>> > > [drm] Loading RV730 Microcode
>>>> > > platform radeon_cp.0: firmware: requesting radeon/RV730_pfp.bin
>>>> > > platform radeon_cp.0: firmware: requesting radeon/RV730_me.bin
>>>> > > platform radeon_cp.0: firmware: requesting radeon/R700_rlc.bin
>>>> > > r600_cp: Failed to load firmware "radeon/R700_rlc.bin"
>>>> > > [drm:rv770_startup] *ERROR* Failed to load firmware!
>>>> > > radeon 0000:02:00.0: ffff8801a20b5400 unpin not necessary
>>>> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
>>>> > > IP: [<ffffffffa0061034>] ttm_bo_reserve+0x16/0xf8 [ttm]
>>>> > > PGD 1a1a74067 PUD 1a19b8067 PMD 0
>>>> > > Oops: 0000 [#1] SMP
>>>> > > last sysfs file: /sys/devices/platform/radeon_cp.0/firmware/radeon_cp.0/loading
>>>> > > CPU 4
>>>> > > Pid: 168, comm: modprobe Not tainted 2.6.33-rc4 #3 EX58-UD3R/EX58-UD3R
>>>> > > RIP: 0010:[<ffffffffa0061034>]  [<ffffffffa0061034>] ttm_bo_reserve+0x16/0xf8 [t
>>>> > > tm]
>>>> > > RSP: 0018:ffff8801a1a8fb68  EFLAGS: 00010292
>>>> > > RAX: ffff880100000000 RBX: 0000000000000000 RCX: 0000000000000000
>>>> > > RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000048
>>>> > > RBP: ffff8801a1a8fba8 R08: 0000000000000000 R09: 0000000000000000
>>>> > > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>>>> > > R13: ffff8801a8838000 R14: 0000000000000024 R15: 0000000000002000
>>>> > > FS:  00007f0f9c6dc700(0000) GS:ffff88002e400000(0000) knlGS:0000000000000000
>>>> > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> > > CR2: 0000000000000048 CR3: 00000001a195d000 CR4: 00000000000006e0
>>>> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> > > Process modprobe (pid: 168, threadinfo ffff8801a1a8e000, task ffff8801a22c0000)
>>>> > > Stack:
>>>> > >  ffff880100000000 ffff8801a27e2900 ffff8801a1a8fb88 0000000000000000
>>>> > > <0> 0000000000000000 ffff8801a8838000 0000000000000024 0000000000002000
>>>> > > <0> ffff8801a1a8fbd8 ffffffffa00ba05b ffff8801a1a8fbd8 ffff8801a27f4000
>>>> > > Call Trace:
>>>> > >  [<ffffffffa00ba05b>] radeon_bo_reserve.clone.0+0x2a/0x6d [radeon]
>>>> > >  [<ffffffffa00bb441>] rv770_suspend+0x43/0x69 [radeon]
>>>> > >  [<ffffffffa00bb6cf>] rv770_init+0x1a4/0x22d [radeon]
>>>> > >  [<ffffffffa0089593>] radeon_device_init+0x27f/0x300 [radeon]
>>>> > >  [<ffffffffa008a0fb>] radeon_driver_load_kms+0xff/0x184 [radeon]
>>>> > >  [<ffffffffa001e1a6>] drm_get_dev+0x3c4/0x4c5 [drm]
>>>> > >  [<ffffffff8122ea73>] ? pci_match_device+0x22/0xd0
>>>> > >  [<ffffffffa00c3bb8>] radeon_pci_probe+0x15/0x268 [radeon]
>>>> > >  [<ffffffff8122e941>] local_pci_probe+0x17/0x1b
>>>> > >  [<ffffffff8122f721>] pci_device_probe+0xcd/0xfd
>>>> > >  [<ffffffff812ce793>] ? driver_sysfs_add+0x4c/0x71
>>>> > >  [<ffffffff812ce95c>] driver_probe_device+0xde/0x1fe
>>>> > >  [<ffffffff812cead9>] __driver_attach+0x5d/0x81
>>>> > >  [<ffffffff812cea7c>] ? __driver_attach+0x0/0x81
>>>> > >  [<ffffffff812cdded>] bus_for_each_dev+0x59/0x8e
>>>> > >  [<ffffffff812ce6f2>] driver_attach+0x1e/0x20
>>>> > >  [<ffffffff812ce330>] bus_add_driver+0xd8/0x240
>>>> > >  [<ffffffff812cedcb>] driver_register+0x9d/0x10e
>>>> > >  [<ffffffff8122f969>] __pci_register_driver+0x68/0xd8
>>>> > >  [<ffffffff81439aa2>] ? printk+0x41/0x47
>>>> > >  [<ffffffffa00f7000>] ? radeon_init+0x0/0xc1 [radeon]
>>>> > >  [<ffffffffa0018eb3>] drm_init+0x75/0xdb [drm]
>>>> > >  [<ffffffffa00f7000>] ? radeon_init+0x0/0xc1 [radeon]
>>>> > >  [<ffffffffa00f70bf>] radeon_init+0xbf/0xc1 [radeon]
>>>> > >  [<ffffffff81002069>] do_one_initcall+0x5e/0x15e
>>>> > >  [<ffffffff81087788>] sys_init_module+0xd8/0x23a
>>>> > >  [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
>>>> > > Code: 01 00 00 00 31 c0 48 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5
>>>> > >  41 57 41 56 41 55 41 54 53 48 83 ec 18 0f 1f 44 00 00 <4c> 8b 27 48 89 fb 41 88
>>>> > >  f5 41 88 d6 41 88 cf 44 89 45 c8 49 81
>>>> > > RIP  [<ffffffffa0061034>] ttm_bo_reserve+0x16/0xf8 [ttm]
>>>> > >  RSP <ffff8801a1a8fb68>
>>>> > > CR2: 0000000000000048
>>>> > > ---[ end trace 604e2e318733e108 ]---
>>>> > > udevd-work[166]: '/sbin/modprobe -b pci:v00001002d00009498sv00001043sd00000300bc
>>>> > > 03sc00i00' unexpected exit with status 0x0009
>>>> > >
>>>> > >
>>>> >
>>>> > I forgot to mention that this is kernel version 2.6.33-rc4.
>>>> >
>>>> > Thanks.
>>>>
>>>> Yes, we didn't paid enough attention to failure path :( Sorry for that
>>>> Fix should be in next rc, patch is:
>>>> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=30d2d9a54d48e4fefede0389ded1b6fc2d44a522
>>>>
>>>
>>> I think your fix didn't make it to 2.6.33-rc5 because I'm still oopsing
>>> when I don't grab the firmware from the internet. (instead of merely
>>> reverting to vga mode).
>>>
>>> Furthermore, why is the firmware not shipped with the kernel?
>>> I never needed to fetch firmware for the 2.6.31 kernels and my graphic
>>> card worked fine.
>>>
>>> Am I right to conclude that the license is a problem?
>>> http://people.freedesktop.org/~agd5f/radeon_ucode/LICENSE.radeon
>>>
>>> This is a huge step backwards if we are exchanging a working driver with
>>> what shipped with the linux kernel to one that only works with blobs that
>>> don't ship with the kernel.
>>
>> In general, microcode is slowly being moved out of the kernel and into
>> the Linux firmware tree:
>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=tree
>> Eventually all of the radeon microcode will end up out up in that tree.
>>
>
> Okay, but why are R600_rlc.bin  R700_rlc.bin in particular missing
> from the firmware?
>

Missing from where?  We aren't adding any new microcode to the kernel
source and they haven't made it into the firmware tree yet.  Until
they end up in the firmware tree, you need to grab them from:
http://people.freedesktop.org/~agd5f/radeon_ucode

Alex
