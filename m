Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbYBFV3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbYBFV3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbYBFV3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:29:40 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:49390 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbYBFV3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:29:38 -0500
Date: Wed, 6 Feb 2008 22:29:37 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Diego Zuccato <diego@otello.alma.unibo.it>,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080206222937.2aa69a2e@weinigel.se>
In-Reply-To: <1202331345.15090.235.camel@violet.holtmann.net>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D895.20300@davidnewall.com>
	<47A6E742.80408@otello.alma.unibo.it>
	<47A764ED.8030605@weinigel.se>
	<1202161091.15090.84.camel@violet>
	<20080206213449.6614efea@weinigel.se>
	<1202331345.15090.235.camel@violet.holtmann.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 21:55:45 +0100
Marcel Holtmann <marcel@holtmann.org> wrote:

> > So how does that invalidate my point?  Intel did jump through a lot
> > of hoops to avoid giving away the code that controls their radio.
> > When the regulatory daemon stuff got too much complaints, they
> > finally redid their firmware to avoid the daemon.  But they still
> > have not exposed the details on how to control their radio.
> 
> find an Intel engineer that worked on it. There is a bigger story
> behind it and I am not telling it.
> 
> And btw. it is perfectly fine that Intel is not giving full access to
> their radios. Why should they?

I think it is perfectly within their rights to do so.  I think it's
kind of silly to try to hide it, if someone wants to boost the maximum
transmit power, they're going to hack the firmware anyway.  But if it
makes Intel happy, well... :-)
 
> > Yes, that is a nice solution.  Provided that you have any firmware
> > at all.  But price is everything, chips become dumber and dumber
> > and more control functions are pushed to the host.  If you want to
> > sell a device in Korea, price is everything; if you can shave off
> > 30 cents by putting the firmware in ROM, or by using 1.5 mbits of
> > flash instead of 2 mbits, that means an increase in market share or
> > profit margins.  
> 
> I heard this all before and I don't buy it anymore. At some point the
> companies in Asia will understand that the whole picture looks
> different and that not always cheap, cheap, cheap is best for their
> margins.

I've been hoping that they will understand that too.  So far it has
been a futile hope.  It is soo fun to write a design spec saying
"Whatever you do, do not use this chip, it sucks.  Yes, I know it is 50
cents cheaper than the competition, but it is not worth it." just too
see exactly that chip being put into the product.

> And btw. the fully supported Linux hardware is in a lot of cases not
> more expensive than the other ones.

Mmm.  I've actually put consulting on the shelf for a while and have
become employed by CSR instead.  They have a really nice, and as far as
I've understood, fairly good and price competitive WIFI chip for low
power systems such as mobile phones or PDAs.  I've gotten a
preliminary go ahead from the bosses to provide documentation under an
NDA to Linux developers that would like to write GPL drivers for it.  I
just haven't had time to do anything more about it yet.  And since I'm
fairly new to CSR and are located at a remote office, it takes time to
find the right people to talk to.
 
> > > Remember that nobody inside the community ever asked for any kind
> > > of IP or trade secrets. We only want specifications so we can
> > > write the drivers under an appropriate open source license. If the
> > > specification describes an API exposed via firmware then that is
> > > perfectly fine.
> > 
> > I definitely agree.  I think it's stupid of companies to hide away
> > their documentation out of fear of, well, something.  I find it
> > extremely frustrating when I bought a device touted as "the first
> > open Linux mobile", just to find out that it used a binary-only
> > kernel module for the M-Systems DiskOnChip.  A quite nice phone,
> > but due to that one module, it was completely impossible to use
> > anything but the ancient 2.4 kernel it came with.
> 
> You got one of the Greenphones ;)

How could you guess?  :-)  Actually, I got three of them, and all of
them lie unused in a box at work.

And the OpenMoko sucks.  Or actually, it doesn't suck at all, I'm
thinking of buying one just for fun, it's just that I like buttons on
a phone, and really don't want a touch screen.  So I like the OpenMoko
project in every way, it's just not the right phone for me.

  /Christer
