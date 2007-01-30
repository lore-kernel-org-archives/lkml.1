Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXA3TLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXA3TLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXA3TLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:11:23 -0500
Received: from mx1.suse.de ([195.135.220.2]:57363 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbXA3TLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:11:21 -0500
Date: Tue, 30 Jan 2007 11:10:20 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130191020.GF20642@kroah.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada8xfks90x.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 09:45:50AM -0800, Roland Dreier wrote:
>  > All that is needed is some kind of specification that describes how your
>  > device works, or the email address of an engineer that is willing to
>  > answer questions every once in a while.  A few sample devices might be
>  > good to have so that debugging doesn't have to be done by email, but if
>  > necessary, that can be done.
> 
>  > This driver will work with all[1] of the different
>  > CPU types supported by Linux, the largest number of CPU types supported
>  > by any operating system ever before in the history of computing.
> 
>  > As for support, the driver will be supported through email by the
>  > original developers, when they can help out, and by the "enterprise"
>  > Linux distributors as part of their service agreements with their
>  > customers.
> 
> I'm all for openness of device programming specs, but I think it's a
> bit disingenous to suggest that all a company has to do to get a
> driver written and supported is throw some documentation over the
> wall.  And it's crazy to suggest that the driver will work on every
> platform and be supported by enterprise distros.

Why is that crazy, we do that already today with the majority of drivers
in Linux.

> Just look at the in-tree drivers: there are tons of them that don't
> work on big-endian platforms, or have 64-bit problems, or have no SMP
> support.  And that doesn't even count drivers that are so bitrotted
> they won't even build any more.

Like Jeff said, many of these are quite old.

> And there are plenty of documented devices that no one cares enough
> about to submit a driver for.

Any specific examples?  I have a long list of people who wish to write
new drivers but just don't know which hardware is not yet supported.

> In the real world, a vendor that wants to make sure a device is
> supported by Linux had better pay someone to write the driver and keep
> it working.  Of course, if the device is popular enough or simple
> enough, docs are all that's needed, but in many cases no one competent
> to write the driver is going to volunteer to do it.

That's not true at all.  We have a whole raft of drivers in the kernel
that are supported only by the community (like the whole USB stack for
example) that vendors rely on working properly.

And again, I have a whole list of people who are competent to write
drivers wanting to do so (myself included), yet do not have any new
devices with specs to do it.

thanks,

greg k-h
