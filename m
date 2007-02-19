Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbXBSSeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbXBSSeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbXBSSd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:33:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54688 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbXBSSd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:33:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2
Date: Mon, 19 Feb 2007 19:28:28 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702190032.09052.rjw@sisk.pl> <20070218162822.3fd10212.akpm@linux-foundation.org>
In-Reply-To: <20070218162822.3fd10212.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702191928.29446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 February 2007 01:28, Andrew Morton wrote:
> On Mon, 19 Feb 2007 00:32:08 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> > > 
> > > Temporarily at
> > > 
> > >   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > > 
> > > Will appear later at
> > > 
> > >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> > 
> > One more thing:
> > 
> > rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> > Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP: 
> >  [<ffffffff804032c3>] rtc_sysfs_remove_device+0x23/0x50
> > PGD 5e10c067 PUD 5dd58067 PMD 0 
> > Oops: 0000 [1] PREEMPT 
> > last sysfs file: /devices/pnp0/00:04/id
> > CPU 0 
> > Modules linked in: cdrom rtc_cmos snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore i2c_nforce2 i2c_core snd_page_alloc ohci_hcd ehci_hcd evdev parport_pc lp parport fan thermal processor
> > Pid: 2960, comm: modprobe Not tainted 2.6.20-mm2 #1
> > RIP: 0010:[<ffffffff804032c3>]  [<ffffffff804032c3>] rtc_sysfs_remove_device+0x23/0x50
> > RSP: 0018:ffff81005e3f9c18  EFLAGS: 00010202
> > RAX: 0000000000000000 RBX: ffff81005dabeea0 RCX: 0000000000000000
> > RDX: ffffffff804032a0 RSI: ffffffff805cfba0 RDI: ffff81005dabeea0
> > RBP: ffff81005e3f9c28 R08: 0000000000000001 R09: 0000000000000000
> > R10: 2222222222222222 R11: 2222222222222222 R12: ffff81005dabeea0
> > R13: ffff810002890258 R14: ffff810002890268 R15: ffff810002890098
> > FS:  00002ac610b906f0(0000) GS:ffffffff805db000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000030 CR3: 000000005e16d000 CR4: 00000000000006e0
> > Process modprobe (pid: 2960, threadinfo ffff81005e3f8000, task ffff81005e6a7140)
> > Stack:  ffff81005fe244e8 ffffffff805cfba0 ffff81005e3f9c68 ffffffff803c5786
> >  0000000000000000 ffff81005dabeea0 ffff81005dabf008 0000000000000008
> >  ffff81005fe244e8 0000000000000008 ffff81005e3f9c88 ffffffff803c5891
> > Call Trace:
> >  [<ffffffff803c5786>] class_device_del+0x86/0x180
> >  [<ffffffff803c5891>] class_device_unregister+0x11/0x20
> >  [<ffffffff8040280e>] rtc_device_unregister+0x3e/0x50
> >  [<ffffffff880cd789>] :rtc_cmos:cmos_pnp_probe+0x219/0x240
> >  [<ffffffff803988a1>] pnp_device_probe+0xa1/0xe0
> >  [<ffffffff803c4d20>] __driver_attach+0x0/0xa0
> >  [<ffffffff803c4bb5>] driver_probe_device+0x115/0x1c0
> >  [<ffffffff803c4d20>] __driver_attach+0x0/0xa0
> >  [<ffffffff803c4d83>] __driver_attach+0x63/0xa0
> >  [<ffffffff803c3e1f>] bus_for_each_dev+0x4f/0x80
> >  [<ffffffff803c497c>] driver_attach+0x1c/0x20
> >  [<ffffffff803c4233>] bus_add_driver+0x83/0x1d0
> >  [<ffffffff803c50d9>] driver_register+0x89/0x90
> >  [<ffffffff803985cc>] pnp_register_driver+0x1c/0x20
> >  [<ffffffff880d1010>] :rtc_cmos:cmos_init+0x10/0x12
> >  [<ffffffff8025199b>] sys_init_module+0x158b/0x16f0
> >  [<ffffffff802d09da>] dnotify_parent+0x7a/0x90
> >  [<ffffffff80268b80>] file_read_actor+0x0/0x170
> >  [<ffffffff80209a0e>] system_call+0x7e/0x83
> > 
> > 
> > Code: 48 83 78 30 00 74 0c 48 c7 c6 60 e1 4a 80 e8 aa 23 fc ff 48 
> > RIP  [<ffffffff804032c3>] rtc_sysfs_remove_device+0x23/0x50
> >  RSP <ffff81005e3f9c18>
> > CR2: 0000000000000030
> 
> How did you provoke that?  modprobe rtc-cmos?

I've just booted OpenSUSE 10.2 with this kernel.
