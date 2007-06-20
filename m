Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbXFTVyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbXFTVyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXFTVyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:54:41 -0400
Received: from smtp.ono.com ([62.42.230.12]:39577 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751620AbXFTVyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:54:40 -0400
Date: Wed, 20 Jun 2007 23:54:28 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070620235428.54d749bb@werewolf-wl>
In-Reply-To: <4678D5DB.40609@gmail.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070619155357.0741dd22@werewolf-wl>
	<20070619163400.3c51ac1e@werewolf-wl>
	<4678D5DB.40609@gmail.com>
X-Mailer: Claws Mail 2.9.2cvs70 (GTK+ 2.11.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 09:23:07 +0200, Jiri Slaby <jirislaby@gmail.com> wrote:

> J.A. Magallón napsal(a):
> > On Tue, 19 Jun 2007 15:53:57 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:
> > 
> >> On Wed, 6 Jun 2007 22:03:13 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> >>>
> >>> - Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
> >>>   trees were repulled, several bad patches were dropped, a few were fixed.
> >>>
> >> I get this warning when I plug a USB stick:
> >>
> > 
> > Oops, forgot to say that this is not plain -rc4-mm2, but with CFS scheduler v17.
> > CC'ing Ingo for if it is related...
> > 
> >> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new high speed USB device using ehci_hcd and address 4
> >> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new device found, idVendor=090c, idProduct=1000
> >> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new device strings: Mfr=1, Product=2, SerialNumber=3
> >> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: Product: USBDrive
> >> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: Manufacturer: LG
> >> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: SerialNumber: AA04012700012034
> >> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: configuration #1 chosen from 1 choice
> >> Jun 19 15:50:53 werewolf-wl kernel: scsi7 : SCSI emulation for USB Mass Storage devices
> >> Jun 19 15:50:53 werewolf-wl kernel: usb-storage: device found at 4
> >> Jun 19 15:50:53 werewolf-wl kernel: usb-storage: waiting for device to settle before scanning
> >> Jun 19 15:50:58 werewolf-wl kernel: WARNING: at drivers/usb/core/urb.c:293 usb_submit_urb()
> 
> Does this help?
> http://lkml.org/lkml/2007/6/7/197
> 
> regards,

Yep, thanks !!! Oops gone.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.21-jam08 (gcc 4.1.2 20070302 (4.1.2-1mdv2007.1)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
