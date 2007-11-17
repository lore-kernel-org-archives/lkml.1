Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbXKQIo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbXKQIo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 03:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXKQIoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 03:44:19 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:53604 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXKQIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 03:44:18 -0500
Date: Sat, 17 Nov 2007 09:44:14 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Michael Gerdau <mgerdau@tiscali.de>, Philippe Elie <phil.el@wanadoo.fr>,
       Russell Leighton <russ@elegant-software.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: OT: Does Linux have any "Perfect Code"
In-Reply-To: <Pine.LNX.4.64.0711150940560.12193@iabervon.org>
Message-ID: <Pine.LNX.4.64.0711170941340.32153@anakin>
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
 <20071115082746.GA2885@zaniah> <200711151416.54570.mgerdau@tiscali.de>
 <Pine.LNX.4.64.0711150940560.12193@iabervon.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Daniel Barkalow wrote:
> On Thu, 15 Nov 2007, Michael Gerdau wrote:
> > > This code is far to be perfect, some part is outdated, bcopy() use instead
> > > of memcpy() for example. More annoying are the comment, the file is 3306
> > > lines while there is only 1640 line of code, nothing bad per se but looking
> > > some comments:
> > > 
> > >  		/*
> > >  		 * Before we begin this operation, disable kernel preemption.
> > >  		 */
> > >  		kpreempt_disable();
> > 
> > <disclaimer>
> > I'm not a kernel developer.
> > </disclaimer>
> > 
> > That having said:
> > I really do like such obvious (as in: for those knowing the stuff anyway)
> > comments when looking at code and probably concepts I'm not familiar with.
> >
> > ...
> > 
> > I mean, isn't the whole purpose of comments to help those not familiar
> > with the code to understand it's purpose and possibly the intention of
> > the author (just in case the author had coded a bug) ?
> 
> That's the problem with really obvious comments. In the example above, 
> that function had better disable kernel preemption with a name like that, 
> and, assuming it's before the code begins the operation in sequence, we 
> know when we're doing it. But the comment fails to explain why we need to 
> disable kernel preemption before beginning the operation, just that we are 
> doing so. Having the comment merely distracts the reader from the fact 
> that the purpose of the code and the intention of the author are 
> completely undocumented. And there's a realy chance that this comment or 
> ones like it cause this statement and the place in the code where things 
> would go wrong if preemption weren't disabled to not fit on the reader's 
> screen together, so it is not only unclear what the author's intention 
> was, but it is harder to figure out from looking at the code than it would 
> be without comments, because fewer clues are actually visible at the same 
> time, since each of them takes up extra screen space.
> 
> The code itself should be written to tell the reader everything there is 
> to know about what it does, and the comments in code should only tell the 
> reader why it does that.

Agreed!

At work we used to have a contractor who documented _every_ single statement
with a literal C/C++-to-English translation. Nobody liked it, except
him. It was completely unreadable.
Of course a few of these comments went out-of-sync with the actual
code...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
