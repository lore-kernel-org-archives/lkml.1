Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYJBHY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYJBHY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYJBHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:24:21 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59332 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYJBHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:24:20 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183zJRl2pNwpQ6AhuwMF6zw
Date: Thu, 2 Oct 2008 10:27:09 +0300
From: Tony Lindgren <tony@atomide.com>
To: David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@openedhand.com>, lkml <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc8 1/2] drivers/mfd/twl4030-core.c
Message-ID: <20081002072704.GC7942@atomide.com>
References: <200810011144.20510.david-b@pacbell.net> <200810011453.26699.david-b@pacbell.net> <20081002060521.GA7942@atomide.com> <200810012353.57753.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810012353.57753.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Brownell <david-b@pacbell.net> [081002 09:54]:
> On Wednesday 01 October 2008, Tony Lindgren wrote:
> > * David Brownell <david-b@pacbell.net> [081002 00:53]:
> > > On Wednesday 01 October 2008, David Brownell wrote:
> > > 
> > > > NOTE: this is the current code from the linux-omap tree.
> > > 
> > > This chip being used on a whole bunch of boards:
> > > 
> > >  - Gumstix Overo
> > >  - BeagleBoard.org
> > >  - Omap ZOOM (Labrador)
> > >  - OMAP 2430 and 3430 SDP,
> > >  - OMAP2 and OMAP3 EVM
> > >  - ... more (openpandora.org ?)
> 
> My bad.  Openpandora just opened for preorders *today* (PST)
> and sold out all 3000 units.  I'm sure I mentioned it well
> after most of them were sold, so it's not my fault their
> server was killed.  Really ...
> 
> 
> > > 
> > > which will get much closer to "usable with mainline kernels"
> > > when their power management chip works in mainline!  :)
> > 
> > Cool. I'll post some patches against mainline kernel
> > for booting minimal omap3 boards within next few days.
> > So we should get at least beagle and overo booting
> > to some extent, maybe with serial and musb.
> 
> Sounds like it *should* be a nice, modest, achievable
> goal, right?  Something tells me it won't be that easy!
> More power to you.

Hmm, well it's really the rest of the already posted omap2-upstream
that RMK already commented on, plus one patch for sram for 34xx,
then just the board files. So it should be doable yeah.

Tony
