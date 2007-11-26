Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXKZVUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXKZVUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbXKZVUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:20:47 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47061 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbXKZVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:20:45 -0500
Date: Mon, 26 Nov 2007 22:20:33 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS
Message-ID: <20071126212033.GC917@stusta.de>
References: <200711252157.10212.rjw@sisk.pl> <200711260104.25911.rjw@sisk.pl> <20071126000644.GA6538@stusta.de> <200711260151.38572.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711260151.38572.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 01:51:37AM +0100, Rafael J. Wysocki wrote:
> On Monday, 26 of November 2007, Adrian Bunk wrote:
> > On Mon, Nov 26, 2007 at 01:04:25AM +0100, Rafael J. Wysocki wrote:
>...
> > > No, it doesn't, as long as the bug reports reach the right place.  Now, the
> > > question is what's that.
> > > 
> > > IMO, ideally, for each subsystem there should be a mailing list to send bug
> > > reports to.  The Bugzilla should forward the reports to these lists.  On every
> > > such list there should be (at least) one person responsible for responding to
> > > the bug reports, if no one else responds first, and for forwarding the reports
> > > to the appropriate developers.  This person should also be responsible for
> > > monitoring the status of each bug report sent to his/her list.
> > 
> > After all discussions about crazy bug tracker features we are back at 
> > the real problem:
> 
> We started to discuss them, because you argued that the Bugzilla in its current
> shape was sufficient, which I didn't agree with and tried to give some
> arguments.

The only real problem with the Bugzilla in it's current shape is that 
some developers do not use it.

> > Where do we find the tree these people grow on?
> 
> That's a good question, but either we find these people, or we'll start losing
> users at growing rates.
> 
> I'm afraid that's already happening ...

Agreed.  :-(

> > > _Every_ bug report sent (including invalid ones) should be recorded in a bug
> > > tracking system (be it the Bugzilla or whatever else) along with all of it's
> > > history (at least, refernces to the bug's history should be stored), no matter
> > > how it's been handled.  Moreover, a bug can only be resolved as "fixed" if
> > > there's a pointer to the exact commit fixing it in the bug's history.
> > 
> > And back we are at crazy bug tracker features...
> 
> No, they are not bug tracker features, but parts of a process that I think we
> should have in place.

The only real problem in our process is how to get reported bugs fixed.

Trying to define some peripheral process things when _the_ central part 
of the process is missing simply doesn't make much sense.

> > > > The only thing that matters is that we get bug reports resolved within a 
> > > > reasonable amount of time.
> > > 
> > > I'm not sure if that's generally possible:
> > > - What about the bugs that take 2 weeks or more to reproduce?
> > > - What about the bugs that we _don't_ _know_ how to fix?
> > 
> > We will never get 100% of all bugs fixed.
> > 
> > Let's get back to the fact that we have many bug reports that could be 
> > fixed within a reasonable amount of time but are not.
> 
> Do you have specific examples?

Take e.g. #3938 or #4039 as examples.

Both are quite different, but both should be fixable within < 1 month. [1]

> Rafael

cu
Adrian

[1] bugs like #4039 might be easier to debug now that git has been 
    written, but even without biseting it should be solvable

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

