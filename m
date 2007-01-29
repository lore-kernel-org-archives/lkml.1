Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXA2Xou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXA2Xou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXA2Xot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:44:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964937AbXA2Xoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:44:46 -0500
Date: Mon, 29 Jan 2007 15:43:40 -0800
From: Greg KH <greg@kroah.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Rainer Weikusat <rainer.weikusat@sncag.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
Message-ID: <20070129234340.GA6881@kroah.com>
References: <877ivb2kvc.fsf@semtex.sncag.com> <20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com> <20070126174828.GA28890@kroah.com> <87d54z1dhb.fsf@semtex.sncag.com> <slrnerqjit.f71.olecom@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnerqjit.f71.olecom@flower.upol.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 01:31:09AM +0000, Oleg Verych wrote:
> 
> > From: Rainer Weikusat
> > Newsgroups: gmane.linux.kernel
> > Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
> > Date: Sun, 28 Jan 2007 14:34:56 +0100
> 
> Hallo.
> 
> > Greg KH <greg@kroah.com> writes:
> []
> >> Please work to see what is wrong with the existing patch.  Is there
> >> anything that I can do to help you out?
> >
> > This thing has consumed something like sixteen hours of my life in
> > total, with a gain-to-be-expected of exactly zero (I don't need to run
> > 'current' kernels on my work machine, I have just grown into the habit
> > of doing so) and those sixteen hours cannot come back (and I even have
> > had these type of discussions around 'should it rather look like math
> > or rather like text' in sufficent quantities :->), so, except that I
> > would be very much obliged to you if a fix for this issue could go
> > into the 'official' tree rather sooner than later, no.
> 
> It's hot here.
> 
> I'm in similar situation (even *usb-serial* driver [TI USB] led me there;)

No, not at all.  Your situation is you object to the current way the USB
subsystem binds devices to drivers (well, interfaces), and wish to rip
the firmware out of a usb-serial driver that is working just fine right
now.

I still don't understand why you wish to take the firmware out and move
it to userspace, why do you want to do this?

Rainer's problem is a real bug in the USB driver code, which we need to
work on getting fixed, vastly different from your objections.

thanks,

greg k-h
