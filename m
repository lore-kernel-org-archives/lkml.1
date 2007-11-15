Return-Path: <linux-kernel-owner+w=401wt.eu-S933081AbXKOV6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbXKOV6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbXKOV5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:57:37 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:32992 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765788AbXKOV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:57:35 -0500
Message-ID: <1618816c0711151357g56d4ab4q8b9d8c6a4c5bfd51@mail.gmail.com>
Date: Thu, 15 Nov 2007 14:57:34 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: [2.6.23-1] [USB Mass Storage] [USB_PERSIST] Losing mounted USB storage after resume
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <473C7B59.7030601@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1618816c0711150657p35744001ic6d4ea22d5651a63@mail.gmail.com>
	 <473C7B59.7030601@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The scenario that you've described is exactly what I have in mind as
well. The lack of this feature, which worked fine in 2.6.21, is
holding us back on updating the kernel in our LiveUSB distribution. I
think that this is a feature that would be more and more needed as
portable storage devices start growing in capacity and speed and start
getting smaller in physical size.

Please advise us on how to accomplish this. Kernel boot option; patch;
anything! We'll take anything.

Thanks
Raymano G.

On 11/15/07, Mark Lord <lkml@rtr.ca> wrote:
> Raymano Garibaldi wrote:
> > Hi,
> >
> > Is there a way/patch that would revert the USB mass storage
> > suspend/resume behavior to the way things worked on and prior to
> > kernel 2.6.21?
> >
> > The problem is mounting a usb drive, suspending while mounted,
> > detaching the usb drive during suspend, reattaching usb drive during
> > suspend before resume, and resuming.
> >
> > In this case the mount is lost and the drive has to be remounted after
> > resume. If the device remains attached while the computer is
> > suspended, USB_PERSIST works as expected and the device remains
> > mounted when the computer resumes. Kernel 2.6.21-x would leave the
> > mount point intact whether the device was left attached or was
> > detached and reattached while the computer was suspend.
> >
> > We need this functionality particularly in read-only live USB distros.
> > In this case the USB device is read-only and can not change while the
> > computer is suspended even if it gets detached and is reattached
> > before resume.
> ..
>
> Some kind of boot flag would cure this one nicely.
>
> I have the same issue here:  boot/run notebook from USB stick,
> eventually suspend the notebook and unplug the stick so it can
> be packed into the case for travel.
>
> Unpack at the other end, replug the stick, and resume from suspend.
> This should be doable, perhaps with a boot parameter override or something.
>
> ???
>
