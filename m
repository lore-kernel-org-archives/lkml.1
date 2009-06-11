Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbZFKVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbZFKVkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbZFKVkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:40:09 -0400
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:53371 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757685AbZFKVkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:40:08 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: HTC Dream aka. t-mobile g1 support
Date: Thu, 11 Jun 2009 17:40:06 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909019177CF@mi8nycmail19.Mi8.com>
In-Reply-To: <4A3175AC.9070100@bluewatersys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: HTC Dream aka. t-mobile g1 support
Thread-Index: Acnq213KFkV3GTPbRwqaqRk9eBlnVAAAPbTQ
References: <20090611111821.GK795@n2100.arm.linux.org.uk>	<20090611.042226.28424489.davem@davemloft.net>	<20090611114911.GL795@n2100.arm.linux.org.uk>	<20090611.050030.169859977.davem@davemloft.net>	<20090611123852.GM795@n2100.arm.linux.org.uk>	<20090611135442.6b9ab315@lxorguk.ukuu.org.uk>	<20090611132134.GA11199@atomide.com>	<20090611133736.GP795@n2100.arm.linux.org.uk>	<20090611140038.GB11199@atomide.com>	<20090611140624.GS795@n2100.arm.linux.org.uk><alpine.LFD.2.00.0906111314510.31536@xanadu.home> <4A3175AC.9070100@bluewatersys.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Ryan Mallon" <ryan@bluewatersys.com>, "Nicolas Pitre" <nico@cam.org>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Tony Lindgren" <tony@atomide.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Miller" <davem@davemloft.net>, <swetland@google.com>,
       <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>, <san@android.com>,
       <rlove@google.com>
X-OriginalArrivalTime: 11 Jun 2009 21:40:08.0207 (UTC) FILETIME=[30ACC1F0:01C9EADD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 11, 2009 2:23 PM, Ryan Mallon wrote:
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

I agree with Ryan.

I review everything Ryan (or others) submit for ep93xx and add my Sign-off-by
or Tested-by as appropriate, I don't think I have every actually added an
Acked-by to any patch (I could be wrong).  Ryan does similar for my patches.

Before anything actually gets applied I am much more comfortable with an ok
from Russell and then going through his patch system.  The third party makes
sure that we don't do anything silly (or stupid).

Regards,
Hartley
