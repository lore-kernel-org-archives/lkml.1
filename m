Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbXFSOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbXFSOeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbXFSOeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:34:12 -0400
Received: from smtp.ono.com ([62.42.230.12]:2623 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754720AbXFSOeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:34:11 -0400
Date: Tue, 19 Jun 2007 16:34:00 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070619163400.3c51ac1e@werewolf-wl>
In-Reply-To: <20070619155357.0741dd22@werewolf-wl>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070619155357.0741dd22@werewolf-wl>
X-Mailer: Claws Mail 2.9.2cvs70 (GTK+ 2.11.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 15:53:57 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Wed, 6 Jun 2007 22:03:13 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> > 
> > - Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
> >   trees were repulled, several bad patches were dropped, a few were fixed.
> > 
> 
> I get this warning when I plug a USB stick:
> 

Oops, forgot to say that this is not plain -rc4-mm2, but with CFS scheduler v17.
CC'ing Ingo for if it is related...

> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new high speed USB device using ehci_hcd and address 4
> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new device found, idVendor=090c, idProduct=1000
> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new device strings: Mfr=1, Product=2, SerialNumber=3
> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: Product: USBDrive
> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: Manufacturer: LG
> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: SerialNumber: AA04012700012034
> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: configuration #1 chosen from 1 choice
> Jun 19 15:50:53 werewolf-wl kernel: scsi7 : SCSI emulation for USB Mass Storage devices
> Jun 19 15:50:53 werewolf-wl kernel: usb-storage: device found at 4
> Jun 19 15:50:53 werewolf-wl kernel: usb-storage: waiting for device to settle before scanning
> Jun 19 15:50:58 werewolf-wl kernel: WARNING: at drivers/usb/core/urb.c:293 usb_submit_urb()
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_submit_urb+491/513] usb_submit_urb+0x1eb/0x201
> Jun 19 15:50:58 werewolf-wl kernel:  [<c02724be>] usb_submit_urb+0x1eb/0x201
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_sg_init+580/609] usb_sg_init+0x244/0x261
> Jun 19 15:50:58 werewolf-wl kernel:  [<c027408b>] usb_sg_init+0x244/0x261
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_sg_wait+175/326] usb_sg_wait+0xaf/0x146
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0273c12>] usb_sg_wait+0xaf/0x146
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_bulk_transfer_sg+149/220] usb_stor_bulk_transfer_sg+0x95/0xdc
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_bulk_transfer_buf+71/114] usb_stor_bulk_transfer_buf+0x47/0x72
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0285afe>] usb_stor_bulk_transfer_buf+0x47/0x72
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_Bulk_transport+293/617] usb_stor_Bulk_transport+0x125/0x269
> Jun 19 15:50:58 werewolf-wl kernel:  [<c02860a9>] usb_stor_Bulk_transport+0x125/0x269
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_control_thread+0/425] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0286d5f>] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_invoke_transport+21/659] usb_stor_invoke_transport+0x15/0x293
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0286202>] usb_stor_invoke_transport+0x15/0x293
> Jun 19 15:50:58 werewolf-wl kernel:  [__wake_up_locked+31/33] __wake_up_locked+0x1f/0x21
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0113a23>] __wake_up_locked+0x1f/0x21
> Jun 19 15:50:58 werewolf-wl kernel:  [__down_interruptible+236/270] __down_interruptible+0xec/0x10e
> Jun 19 15:50:58 werewolf-wl kernel:  [<c02f682a>] __down_interruptible+0xec/0x10e
> Jun 19 15:50:58 werewolf-wl kernel:  [default_wake_function+0/12] default_wake_function+0x0/0xc
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0116d65>] default_wake_function+0x0/0xc
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_control_thread+0/425] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0286d5f>] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_control_thread+0/425] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0286d5f>] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_control_thread+315/425] usb_stor_control_thread+0x13b/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0286e9a>] usb_stor_control_thread+0x13b/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [kthread+0/86] kthread+0x0/0x56
> Jun 19 15:50:58 werewolf-wl kernel:  [<c012de72>] kthread+0x0/0x56
> Jun 19 15:50:58 werewolf-wl kernel:  [usb_stor_control_thread+0/425] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [<c0286d5f>] usb_stor_control_thread+0x0/0x1a9
> Jun 19 15:50:58 werewolf-wl kernel:  [kthread+52/86] kthread+0x34/0x56
> Jun 19 15:50:58 werewolf-wl kernel:  [<c012dea6>] kthread+0x34/0x56
> Jun 19 15:50:58 werewolf-wl kernel:  [kthread+0/86] kthread+0x0/0x56
> Jun 19 15:50:58 werewolf-wl kernel:  [<c012de72>] kthread+0x0/0x56
> Jun 19 15:50:58 werewolf-wl kernel:  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
> Jun 19 15:50:58 werewolf-wl kernel:  [<c01033e3>] kernel_thread_helper+0x7/0x14
> Jun 19 15:50:58 werewolf-wl kernel:  =======================
> 

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.21-jam07 (gcc 4.1.2 20070302 (4.1.2-1mdv2007.1)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
