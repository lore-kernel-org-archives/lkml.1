Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbXI2JWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbXI2JWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbXI2JWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:22:17 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3058 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXI2JWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:22:16 -0400
Date: Sat, 29 Sep 2007 10:22:03 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070929092203.GB13737@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org> <20070928104935.GA606@elte.hu> <20070928132138.GG18163@shadowen.org> <20070928104642.0f3a4573.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928104642.0f3a4573.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 10:46:42AM -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 14:21:38 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > On Fri, Sep 28, 2007 at 12:49:35PM +0200, Ingo Molnar wrote:
> > > 
> > > * Andy Whitcroft <apw@shadowen.org> wrote:
> > > 
> > > > On Fri, Sep 28, 2007 at 11:39:02AM +0200, Ingo Molnar wrote:
> > > >
> >
> > [bunfight]
> >
> 
> oy, knock it off.

Really not trying to have a bunfight, honest.

> > Anyhow.  I have already added a --check/--no-check option which controls
> 
> -strict?
> 
> > the more subjective tests which will be in the next release; though its
> > likely the option name will be something more useful by then.
> > 
> > The only question is whether this should default to on.  You are voting
> > off.  I personally think on.
> > 
> > Andrew?  Randy?  Joel?
> > 
> 
> off, I'd say.  That way people are more likely to use it.  Or, more
> accurately, will have less excuses to not use it.

Ok, then I think thats 2 for on and 3 for off.  So off it is.

I was tending towards --subjective for the tests which are err more
subjective.  --strict is good too.  Perhaps I'll put both of those in as
aliases.

I will also review the tests which are warnings and checks (subjective)
and see if any are now miss-categorised.

-apw
