Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYA2Kks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYA2Kks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYA2Kki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:40:38 -0500
Received: from zakalwe.fi ([80.83.5.154]:38373 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbYA2KkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:40:20 -0500
Date: Tue, 29 Jan 2008 12:40:18 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt
Message-ID: <20080129104018.GF12172@zakalwe.fi>
References: <20080128230959.AA1A32BC98@zakalwe.fi> <20080129044805.GA1718@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080129044805.GA1718@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Andi as he commented also..

On Mon, Jan 28, 2008 at 08:48:05PM -0800, Greg KH wrote:
> On Tue, Jan 29, 2008 at 01:09:59AM +0200, Heikki Orsila wrote:
> > * Make a remark about avoiding unnecessary changes in interfaces
> > * Improve wording
> 
> Well, "improve" is a bit judgemental :)

The places I corrected were somewhat unreadable English in my opinion.
The problem with this text is mostly 
style that breaks common sense rules how to write simple sentences.
Documentation should not try to represent its writer but convey 
the idea as well as possible.

> > @@ -68,11 +68,11 @@ consider the following facts about the Linux kernel:
> >      There is no way that binary drivers from one architecture will run
> >      on another architecture properly.
> >  
> > -Now a number of these issues can be addressed by simply compiling your
> > -module for the exact specific kernel configuration, using the same exact
> > +Now, a number of these issues can be addressed by simply compiling your
> > +module for the same kernel configuration, using the same
> 
> No, I want to emphasize the word "exact" here.  It has to be the same.

Do you want preserve both "exact specific" and "same exact"? Imo,
"same exact C compiler" is just bad language, because C compilers are 
always "exact". "exactly same C compiler" would do.

> >  C compiler that the kernel was built with.  This is sufficient if you
> >  want to provide a module for a specific release version of a specific
> > -Linux distribution.  But multiply that single build by the number of
> > +Linux distribution. However, multiply that single build by the number of
> 
> You messed with the "two space" rule, and changed the word unecessarily
> in my opinion.
> 
> >  different Linux distributions and the number of different supported
> >  releases of the Linux distribution and you quickly have a nightmare of
> >  different build options on different releases.  Also realize that each
> > @@ -93,7 +93,7 @@ keep a Linux kernel driver that is not in the main kernel tree up to
> >  date over time.
> >  
> >  Linux kernel development is continuous and at a rapid pace, never
> > -stopping to slow down.  As such, the kernel developers find bugs in
> > +slowing down.  As such, the kernel developers find bugs in
> 
> No, they never stop, I say leave it as is.

Imo, that statement is very odd. The meaning of it has to be guessed.
"never slowing down" is very simple and conveys the essential idea.

> > @@ -116,7 +116,7 @@ issues:
> >  
> >  This is in stark contrast to a number of closed source operating systems
> >  which have had to maintain their older USB interfaces over time.  This
> > -provides the ability for new developers to accidentally use the old
> > +has the risk for new developers to accidentally use the old
> 
> It's not so much as a "risk" as it is what always seems to happen.  So I
> don't like this change either.

No, it's definitely more "risk" than "ability" because "ability" should 
refer to a positive property. Here "ability" is used to refer to a
"negative outcome".

> > @@ -145,6 +145,10 @@ as small as possible, and that all potential interfaces are tested as
> >  well as they can be (unused interfaces are pretty much impossible to
> >  test for validity.)
> >  
> > +Some complain that kernel interfaces change too often for out-of-the-tree
> > +modules, but this claim is false. Changing an interface can be delicate work,
> > +and it can take significant amount of developer effort. Therefore, interfaces
> > +are not changed without a good reason.
> 
> No, their claim is a valid one, it's not "false".  However we are not
> going to do anything about it, and as such, we don't need this kind of
> wording to get people worried about it even more.

How about this (scrap the whole paragraph):

Changing an interface can be delicate work and it can take significant 
amount of developer effort. Therefore, an interface is not changed
unless the change is regarded as very important by the developers.

> So, care to redo the patch?

Will try..

> Also note, there are other translations of this text already, so if you
> want to change phrases like this, you might want to cc: those
> maintainers as well to get their input.

OK.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
