Return-Path: <linux-kernel-owner+w=401wt.eu-S1764632AbYA2OOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764632AbYA2OOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763769AbYA2OOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:14:21 -0500
Received: from zakalwe.fi ([80.83.5.154]:41917 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763760AbYA2OOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:14:20 -0500
Date: Tue, 29 Jan 2008 16:14:19 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt
Message-ID: <20080129141419.GG12172@zakalwe.fi>
References: <20080128230959.AA1A32BC98@zakalwe.fi> <20080129044805.GA1718@kroah.com> <20080129104018.GF12172@zakalwe.fi> <20080129131500.GA10761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080129131500.GA10761@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my last counter argument. Based on this I'll submit a new patch
that is less intrusive.

On Tue, Jan 29, 2008 at 05:15:00AM -0800, Greg KH wrote:
> I strongly disagree with this.  If you are reading documentation, you
> should at least be intertained a bit, and if you take the "flavor" of
> the writer out of it entirely, it becomes quite boring and dry.

I hope we agree that by definition the success of documentation is 
measured by its ability to convey ideas. So the basic disagreement is 
"simple English" versus "some flavor of English".
"entertainment value" is there only to keep the person reading, but 
"complicated" sentences harm readability.

> > > > @@ -68,11 +68,11 @@ consider the following facts about the Linux kernel:
> > > >      There is no way that binary drivers from one architecture will run
> > > >      on another architecture properly.
> > > >  
> > > > -Now a number of these issues can be addressed by simply compiling your
> > > > -module for the exact specific kernel configuration, using the same exact
> > > > +Now, a number of these issues can be addressed by simply compiling your
> > > > +module for the same kernel configuration, using the same
> > > 
> > > No, I want to emphasize the word "exact" here.  It has to be the same.
> > 
> > Do you want preserve both "exact specific" and "same exact"?
> 
> Both.
> 
> > Imo,
> > "same exact C compiler" is just bad language, because C compilers are 
> > always "exact". "exactly same C compiler" would do.
> 
> No, "exactly same C compiler" doesn't parse well in English.

"Same exact C compiler" does not mean what you try to say.

> > > >  C compiler that the kernel was built with.  This is sufficient if you
> > > >  want to provide a module for a specific release version of a specific
> > > > -Linux distribution.  But multiply that single build by the number of
> > > > +Linux distribution. However, multiply that single build by the number of
> > > 
> > > You messed with the "two space" rule, and changed the word unecessarily
> > > in my opinion.
> > > 
> > > >  different Linux distributions and the number of different supported
> > > >  releases of the Linux distribution and you quickly have a nightmare of
> > > >  different build options on different releases.  Also realize that each
> > > > @@ -93,7 +93,7 @@ keep a Linux kernel driver that is not in the main kernel tree up to
> > > >  date over time.
> > > >  
> > > >  Linux kernel development is continuous and at a rapid pace, never
> > > > -stopping to slow down.  As such, the kernel developers find bugs in
> > > > +slowing down.  As such, the kernel developers find bugs in
> > > 
> > > No, they never stop, I say leave it as is.
> > 
> > Imo, that statement is very odd. The meaning of it has to be guessed.
> > "never slowing down" is very simple and conveys the essential idea.
> 
> Hm, but you understood the idea conveyed here, right?  That's the
> important issue, we can argue about the exact structure of words all
> day, which will get us no where.

Right, this argument can't continue without other people's perspectives.

> Ok, fair enough, I can agree with that.

Good :)

> > > > @@ -145,6 +145,10 @@ as small as possible, and that all potential interfaces are tested as
> > > >  well as they can be (unused interfaces are pretty much impossible to
> > > >  test for validity.)
> > > >  
> > > > +Some complain that kernel interfaces change too often for out-of-the-tree
> > > > +modules, but this claim is false. Changing an interface can be delicate work,
> > > > +and it can take significant amount of developer effort. Therefore, interfaces
> > > > +are not changed without a good reason.
> > > 
> > > No, their claim is a valid one, it's not "false".  However we are not
> > > going to do anything about it, and as such, we don't need this kind of
> > > wording to get people worried about it even more.
> > 
> > How about this (scrap the whole paragraph):
> > 
> > Changing an interface can be delicate work and it can take significant 
> > amount of developer effort. Therefore, an interface is not changed
> > unless the change is regarded as very important by the developers.
> 
> Why do you feel this paragraph is needed at all?

Some people may feel there is nothing to prevent constant changes. This 
paragraph tries to assure it is not the case. Actually, the whole point 
of this documentation is to comfort others.

PS. Off topic: I think documentation is a very important topic for Linux 
systems in general (there is lot to be improved!). I wonder how many 
bugs in programs could be avoided by writing good man pages. For 
example, many people tend to get select() wrong, and I suspect it's 
partly because the man page is not as good as it could be. An example 
of good man page would Davide Libenzi's epoll that has an FAQ for common 
questions and an example of suggested usage. Good examples drive 
developers for solutions that are known to work in practice.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
