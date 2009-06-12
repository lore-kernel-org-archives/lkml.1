Return-Path: <linux-kernel-owner+w=401wt.eu-S1763928AbZFLBWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763928AbZFLBWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbZFLBWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:22:11 -0400
Received: from relais.videotron.ca ([24.201.245.36]:15173 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZFLBWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:22:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 11 Jun 2009 21:21:42 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
In-reply-to: <4A3175AC.9070100@bluewatersys.com>
Message-id: <alpine.LFD.2.00.0906112105220.31536@xanadu.home>
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
 <20090611.042226.28424489.davem@davemloft.net>
 <20090611114911.GL795@n2100.arm.linux.org.uk>
 <20090611.050030.169859977.davem@davemloft.net>
 <20090611123852.GM795@n2100.arm.linux.org.uk>
 <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
 <20090611132134.GA11199@atomide.com>
 <20090611133736.GP795@n2100.arm.linux.org.uk>
 <20090611140038.GB11199@atomide.com>
 <20090611140624.GS795@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
 <4A3175AC.9070100@bluewatersys.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Ryan Mallon wrote:

> Nicolas Pitre wrote:
> > On Thu, 11 Jun 2009, Russell King - ARM Linux wrote:
> >
> > I think that you, as the ARM maintainer, should continue gathering all 
> > the ARM subarchitectures into a coherent ARM tree and arbitrate 
> > conflicts when they occur.  You should especially keep a tight control 
> > on the very core ARM code.  But everything under arch/arm/mach-* you 
> > should let people maintaining those have control of that themselves and 
> > free yourself from that responsibility as much as possible.  The current 
> > directory structure is quite indicative of where the boundaries are 
> > already.  This way, if I make a mess of arch/arm/mach-orion5x/* then you 
> > just need to pass the blame straight to me.
> > 
> 
> That works okay for the more popular sub-architectures like pxa, etc,
> where there are a lot of people to review code and sort out issues
> between themselves. However, for the architecture I do most of my work
> on, ep93xx, there are basically two of us, Hartley and myself, doing
> active work.
> 
> It seems a bit dodgy if all the patches to ep93xx are written by one of
> us and acked by the other with no input from anybody else. It would be
> very easy for the ep93xx code to become and complete mess, and lack any
> coherency with the other sub-archs. I prefer having Russell, or somebody
> else, at least have a glance at the patches before they get applied.

This is all fine.  If you prefer some external help to judge your 
patches that's OK.  In fact I'm not advocating for people to stop 
posting their patches to linux-arm-kernel at all.  It is a good thing 
for patches to be aired on the mailing list for everyone to see and 
comment.

However if you start gathering more developers around the ep93xx then 
someone should take charge and be responsible for it.  And this must not 
necessarily be Russell as his cycles are not infinite.


Nicolas
