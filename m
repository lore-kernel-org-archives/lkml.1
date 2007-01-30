Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbXA3Tzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbXA3Tzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXA3Tzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:55:45 -0500
Received: from ns1.suse.de ([195.135.220.2]:60560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbXA3Tzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:55:44 -0500
Date: Tue, 30 Jan 2007 11:54:45 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130195445.GE22022@kroah.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaodogqpmx.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 11:29:58AM -0800, Roland Dreier wrote:
>  > > I'm all for openness of device programming specs, but I think it's a
>  > > bit disingenous to suggest that all a company has to do to get a
>  > > driver written and supported is throw some documentation over the
>  > > wall.  And it's crazy to suggest that the driver will work on every
>  > > platform and be supported by enterprise distros.
>  > 
>  > Why is that crazy, we do that already today with the majority of drivers
>  > in Linux.
> 
> Well, we can disagree about the majority of drivers.  My feeling is
> that most of the drivers that are really used by lots of people get
> support beyond just a dump of docs -- in fact often vendors are
> maintaining them, eg e1000, tg3, cciss, etc., to pick some running on
> the boxes I have around here.

If you recal, tg3 was created by the community because the vendor
refused to open their driver up.  They only reluctantly now support it
because it went into the main kernel tree and the distros then refused
to accept the closed driver.

So there's a perfict example of what I'm talking about :)

Also, look at the rest of the system (ide, SATA, USB, firewire, driver
core, PCI, etc.)  None of that was done by a vendor, but by the
community.

>  > > Just look at the in-tree drivers: there are tons of them that don't
>  > > work on big-endian platforms, or have 64-bit problems, or have no SMP
>  > > support.  And that doesn't even count drivers that are so bitrotted
>  > > they won't even build any more.
>  > 
>  > Like Jeff said, many of these are quite old.
> 
> OK, but why isn't your army of volunteers fixing them?

They don't know about them, or they don't have the hardware to test?
Seriously, let the kernel-janitor's project know about any issues you
have and they will be glad to jump on it.  Those people are just
chomping a the bit to do something a bit bigger than "compiler warning
cleanups" :)

>  > > And there are plenty of documented devices that no one cares enough
>  > > about to submit a driver for.
>  > 
>  > Any specific examples?  I have a long list of people who wish to write
>  > new drivers but just don't know which hardware is not yet supported.
> 
> I have a Cisco USB webcam that supposedly conforms to the "USB Video
> Device Class", but nothing happens when I plug it into my Linux box.
> I assume the device class is specified as part of the USB spec...

Are you sure?  That spec just came out not so long ago and I haven't
seen any real devices support it just yet.  That said, I do know of a
few people who are working on implementing the standard, try asking on
the linux-usb-devel mailing list to find out what their status is.

> And I seem to recall there's more SATA chipset documentation than Jeff
> Garzik has time to implement support for.

If so, he should let people know :)

> I'm disagreeing with a stronger assertion -- your original email said
> that if a vendor just dumps out hardware documentation and donates a
> few devices, then that vendor will definitely get a driver that will
> be picked up by enterprise distros and run on every Linux platform.
> And that just isn't true, or at least experience shows it hasn't been
> true until now.

Um, that's how Linux has gotten to where it is today and continues to
grow. Just because none of us wanted to do IB drivers, doesn't mean that
the model doesn't work for devices that are actually sane :)

thanks,

greg k-h
