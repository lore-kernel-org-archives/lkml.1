Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbXKORBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbXKORBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXKORBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:01:15 -0500
Received: from rtr.ca ([76.10.145.34]:3334 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbXKORBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:01:15 -0500
Message-ID: <473C7B59.7030601@rtr.ca>
Date: Thu, 15 Nov 2007 12:01:13 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Raymano Garibaldi <raymano@faunos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-1] [USB Mass Storage] [USB_PERSIST] Losing mounted USB
 storage after resume
References: <1618816c0711150657p35744001ic6d4ea22d5651a63@mail.gmail.com>
In-Reply-To: <1618816c0711150657p35744001ic6d4ea22d5651a63@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Raymano Garibaldi wrote:
> Hi,
> 
> Is there a way/patch that would revert the USB mass storage
> suspend/resume behavior to the way things worked on and prior to
> kernel 2.6.21?
> 
> The problem is mounting a usb drive, suspending while mounted,
> detaching the usb drive during suspend, reattaching usb drive during
> suspend before resume, and resuming.
> 
> In this case the mount is lost and the drive has to be remounted after
> resume. If the device remains attached while the computer is
> suspended, USB_PERSIST works as expected and the device remains
> mounted when the computer resumes. Kernel 2.6.21-x would leave the
> mount point intact whether the device was left attached or was
> detached and reattached while the computer was suspend.
> 
> We need this functionality particularly in read-only live USB distros.
> In this case the USB device is read-only and can not change while the
> computer is suspended even if it gets detached and is reattached
> before resume.
..

Some kind of boot flag would cure this one nicely.

I have the same issue here:  boot/run notebook from USB stick,
eventually suspend the notebook and unplug the stick so it can
be packed into the case for travel.

Unpack at the other end, replug the stick, and resume from suspend.
This should be doable, perhaps with a boot parameter override or something.

???
