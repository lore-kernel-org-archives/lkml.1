Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbYA2NOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbYA2NOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762901AbYA2NOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:14:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38702 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762745AbYA2NN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:13:58 -0500
Date: Tue, 29 Jan 2008 05:15:00 -0800
From: Greg KH <greg@kroah.com>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt
Message-ID: <20080129131500.GA10761@kroah.com>
References: <20080128230959.AA1A32BC98@zakalwe.fi> <20080129044805.GA1718@kroah.com> <20080129104018.GF12172@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129104018.GF12172@zakalwe.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 12:40:18PM +0200, Heikki Orsila wrote:
> CC'ing Andi as he commented also..
> 
> On Mon, Jan 28, 2008 at 08:48:05PM -0800, Greg KH wrote:
> > On Tue, Jan 29, 2008 at 01:09:59AM +0200, Heikki Orsila wrote:
> > > * Make a remark about avoiding unnecessary changes in interfaces
> > > * Improve wording
> > 
> > Well, "improve" is a bit judgemental :)
> 
> The places I corrected were somewhat unreadable English in my opinion.
> The problem with this text is mostly 
> style that breaks common sense rules how to write simple sentences.
> Documentation should not try to represent its writer but convey 
> the idea as well as possible.

I strongly disagree with this.  If you are reading documentation, you
should at least be intertained a bit, and if you take the "flavor" of
the writer out of it entirely, it becomes quite boring and dry.

> > > @@ -68,11 +68,11 @@ consider the following facts about the Linux kernel:
> > >      There is no way that binary drivers from one architecture will run
> > >      on another architecture properly.
> > >  
> > > -Now a number of these issues can be addressed by simply compiling your
> > > -module for the exact specific kernel configuration, using the same exact
> > > +Now, a number of these issues can be addressed by simply compiling your
> > > +module for the same kernel configuration, using the same
> > 
> > No, I want to emphasize the word "exact" here.  It has to be the same.
> 
> Do you want preserve both "exact specific" and "same exact"?

Both.

> Imo,
> "same exact C compiler" is just bad language, because C compilers are 
> always "exact". "exactly same C compiler" would do.

No, "exactly same C compiler" doesn't parse well in English.

> > >  C compiler that the kernel was built with.  This is sufficient if you
> > >  want to provide a module for a specific release version of a specific
> > > -Linux distribution.  But multiply that single build by the number of
> > > +Linux distribution. However, multiply that single build by the number of
> > 
> > You messed with the "two space" rule, and changed the word unecessarily
> > in my opinion.
> > 
> > >  different Linux distributions and the number of different supported
> > >  releases of the Linux distribution and you quickly have a nightmare of
> > >  different build options on different releases.  Also realize that each
> > > @@ -93,7 +93,7 @@ keep a Linux kernel driver that is not in the main kernel tree up to
> > >  date over time.
> > >  
> > >  Linux kernel development is continuous and at a rapid pace, never
> > > -stopping to slow down.  As such, the kernel developers find bugs in
> > > +slowing down.  As such, the kernel developers find bugs in
> > 
> > No, they never stop, I say leave it as is.
> 
> Imo, that statement is very odd. The meaning of it has to be guessed.
> "never slowing down" is very simple and conveys the essential idea.

Hm, but you understood the idea conveyed here, right?  That's the
important issue, we can argue about the exact structure of words all
day, which will get us no where.

> > > @@ -116,7 +116,7 @@ issues:
> > >  
> > >  This is in stark contrast to a number of closed source operating systems
> > >  which have had to maintain their older USB interfaces over time.  This
> > > -provides the ability for new developers to accidentally use the old
> > > +has the risk for new developers to accidentally use the old
> > 
> > It's not so much as a "risk" as it is what always seems to happen.  So I
> > don't like this change either.
> 
> No, it's definitely more "risk" than "ability" because "ability" should 
> refer to a positive property. Here "ability" is used to refer to a
> "negative outcome".

Ok, fair enough, I can agree with that.

> > > @@ -145,6 +145,10 @@ as small as possible, and that all potential interfaces are tested as
> > >  well as they can be (unused interfaces are pretty much impossible to
> > >  test for validity.)
> > >  
> > > +Some complain that kernel interfaces change too often for out-of-the-tree
> > > +modules, but this claim is false. Changing an interface can be delicate work,
> > > +and it can take significant amount of developer effort. Therefore, interfaces
> > > +are not changed without a good reason.
> > 
> > No, their claim is a valid one, it's not "false".  However we are not
> > going to do anything about it, and as such, we don't need this kind of
> > wording to get people worried about it even more.
> 
> How about this (scrap the whole paragraph):
> 
> Changing an interface can be delicate work and it can take significant 
> amount of developer effort. Therefore, an interface is not changed
> unless the change is regarded as very important by the developers.

Why do you feel this paragraph is needed at all?

thanks,

greg k-h
