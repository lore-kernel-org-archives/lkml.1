Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYJSDfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYJSDfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 23:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYJSDfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 23:35:46 -0400
Received: from 1wt.eu ([62.212.114.60]:4851 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbYJSDfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 23:35:45 -0400
Date: Sun, 19 Oct 2008 05:35:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081019033521.GA3700@1wt.eu>
References: <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <20081018084504.GQ24654@1wt.eu> <alpine.LRH.1.10.0810190114420.2000@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0810190114420.2000@twin.jikos.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 01:17:19AM +0200, Jiri Kosina wrote:
> On Sat, 18 Oct 2008, Willy Tarreau wrote:
> 
> > confusion between 2.4.37 and 2.6.27. I have already tagged kernels with 
> > wrong versions, having to fix by hand afterwards. It's really cumbersome 
> > some times.
> 
> But this is only because you are maintaining a source code that is several 
> years old, right?

It has nothing to do with age, but with the number of digits. Having 4 series
of digits is not easy, especially when some of them are two-digits large.
2.6.26.25-rc1 and 2.6.25.26-rc1 are obviously confusing and not old (not
even released).

> Would maintaining a series numbered 2002.x.y make your 
> situation a lot better? Do you think you'd never make typo '2002 instead 
> of 2006' any more?

Yes I probably would, and I already said I would not like such a numbering
which is even worse IMHO. I'm for small number of digits, X.Y[.Z] with both
X and Y < 10, and Z the stable release. In 22 years, X will go to 10 which
is still not a problem.

> Or how would you distingiush the kernel tree you are maintaing from the 
> one Linus is maintaining?

Another reason why I don't like dates. It makes forked versions more
confusing. Assuming that in 10 years we get 40 versions further, we
might be at version 6.8 and maybe I would have switched to maintain
"old" version 4.2. There is no confusion here.

BTW, speaking about dates, I noticed that others have experimented
with dates and finally changed their mind. Even microsoft. Remember
windows 3.1/3.11 ? In parallel, you had NT 3.5. After that you got
windows 95 (year of predicted release), then 98 (idem). In parallel,
NT went to 4.0. Then they merged all of them into windows 2000,
dropping the versions. Then they started inventing stupid names
like ME, Xp, Vista, ... and now they're talking about windows 7,
which should take its version from the kernel, because the kernel
has kept being versionned "normally" (no marketting involved in
this area). So they might have noticed that using years makes the
whole thing more complex for everyone in the long term. They get
laughed at when releases are delayed, people don't really know if
their seemingly old "2003" is really old or the last one, etc...

Probably that using dates in packaged products such as distros
based on whatever is available at the given date and meant to
evolve quickly and not being supported for long is good however.
It's just a snapshot at a given date and nothing more.

Willy

