Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXEJOwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXEJOwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXEJOws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:52:48 -0400
Received: from relais.videotron.ca ([24.201.245.36]:29814 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXEJOwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:52:47 -0400
Date: Thu, 10 May 2007 10:52:43 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: [GIT PULL] MMC updates
In-reply-to: <46432502.4050901@drzeus.cx>
X-X-Sender: nico@xanadu.home
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.0.99.0705101037220.24220@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <46375B18.4080802@drzeus.cx>
 <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx>
 <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx>
 <46432502.4050901@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Pierre Ossman wrote:

> You seem to be the source of this workaround, and also the maintainer of
> PXA.

Well... I used to.

But the only MMC capable PXA hardware in working conditions I have 
access to at the moment is PXA255 based which doesn't suffer from this 
erratum.

> Pierre Ossman wrote:
> > Russell King wrote:
> >   
> >> See the comments immediately above and below its use.
> >>
> >> Welcome to buggy hardware.
> >>
> >>   
> >>     
> >
> > I've read through the erratum, and to me it seems like the bug affects
> > all long replies, not just these codes. So I think the code should be
> > fixed to look at the response flag, not the opcode.
> >
> > Do you have hardware so that you can test such a change?
> >
> >   
> 
> I guess the same question goes to you. :)

People in better position than I currently do to test a fix are most 
likely to be found on lak.


Nicolas
