Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbXKULql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbXKULql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbXKULqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:46:33 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:52992 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbXKULqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:46:32 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: USB deadlock after resume
Date: Wed, 21 Nov 2007 12:46:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com> <d9def9db0711202132q2c5a9b46k79c00da68250db3b@mail.gmail.com> <d9def9db0711210259v5d06590w7754aeb508632c77@mail.gmail.com>
In-Reply-To: <d9def9db0711210259v5d06590w7754aeb508632c77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711211246.39441.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 November 2007 schrieb Markus Rechberger:
> On 11/21/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > On 11/21/07, Mark Lord <lkml@rtr.ca> wrote:
> > > Markus Rechberger wrote:
> > > > Hi,
> > > >
> > > > I'm looking at the linux uvc driver, and noticed after resuming my
> > > ..
> > >
> > > Pardon me.. what is the "uvc" driver?  Which module/source file is that?
> > >
> >
> > http://linux-uvc.berlios.de/ it's not yet included in the kernel
> > sources although many distributions already ship it.
> > A "dry" run putting the device into sleep mode works fine (I added a
> > proc interface for calling those suspend/resume function).
> >
> 
> it's not just usb_set_interface that hangs actually.
> It seems to hang at
> 
> wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> 
> in drivers/usb/core/urb.c after resuming. I disabled access to the usb
> subsystem in the uvc driver, although connecting any other usb storage
> fails too, just at the same point.

Which URB is usb_kill_urb() called for?

	Regards
		Oliver

