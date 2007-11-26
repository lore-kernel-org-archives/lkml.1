Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXKZW0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXKZW0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbXKZW0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:26:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963AbXKZW0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:26:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS
Date: Mon, 26 Nov 2007 23:44:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200711252157.10212.rjw@sisk.pl> <200711260151.38572.rjw@sisk.pl> <20071126212033.GC917@stusta.de>
In-Reply-To: <20071126212033.GC917@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711262344.25223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 of November 2007, Adrian Bunk wrote:
> On Mon, Nov 26, 2007 at 01:51:37AM +0100, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, Adrian Bunk wrote:
> > > On Mon, Nov 26, 2007 at 01:04:25AM +0100, Rafael J. Wysocki wrote:
> >...
> > > > No, it doesn't, as long as the bug reports reach the right place.  Now, the
> > > > question is what's that.
> > > > 
> > > > IMO, ideally, for each subsystem there should be a mailing list to send bug
> > > > reports to.  The Bugzilla should forward the reports to these lists.  On every
> > > > such list there should be (at least) one person responsible for responding to
> > > > the bug reports, if no one else responds first, and for forwarding the reports
> > > > to the appropriate developers.  This person should also be responsible for
> > > > monitoring the status of each bug report sent to his/her list.
> > > 
> > > After all discussions about crazy bug tracker features we are back at 
> > > the real problem:
> > 
> > We started to discuss them, because you argued that the Bugzilla in its current
> > shape was sufficient, which I didn't agree with and tried to give some
> > arguments.
> 
> The only real problem with the Bugzilla in it's current shape is that 
> some developers do not use it.

I disagree.

For example, I can't find the appropriate product/component combinations for
some bugs that I put in there while registering recent regressions.  Also, for
some product/component combinations the notifications sent by the Bugzilla
actually go to nowhere.

[Speaking of which, what should I do to make all of the bugs in the
"Power management"->Hibernation/Suspend category go to
linux-pm@lists.linux-foundation.org ?]

I'm not saying that the Bugzilla isn't useful (otherwise I wouldn't have used
it), but IMO there are some problems with it.

Still, as you said, this isn't the real problem we have with handling bugs.

> > > Where do we find the tree these people grow on?
> > 
> > That's a good question, but either we find these people, or we'll start losing
> > users at growing rates.
> > 
> > I'm afraid that's already happening ...
> 
> Agreed.  :-(
> 
> > > > _Every_ bug report sent (including invalid ones) should be recorded in a bug
> > > > tracking system (be it the Bugzilla or whatever else) along with all of it's
> > > > history (at least, refernces to the bug's history should be stored), no matter
> > > > how it's been handled.  Moreover, a bug can only be resolved as "fixed" if
> > > > there's a pointer to the exact commit fixing it in the bug's history.
> > > 
> > > And back we are at crazy bug tracker features...
> > 
> > No, they are not bug tracker features, but parts of a process that I think we
> > should have in place.
> 
> The only real problem in our process is how to get reported bugs fixed.
> 
> Trying to define some peripheral process things when _the_ central part 
> of the process is missing simply doesn't make much sense.

The only realistic way in which we can *try* to improve things is by increasing
the pressure on developers who don't fix bugs timely, although they could.

To this end, we could, for example, periodically publish per-subsystem
statistics of reported / handled / resolved bugs .  That also would give us an
idea of which subsystems are not sufficiently supported.

However, for this purpose we need to make sure that bug reports actually have
a chance to be read by the appropriate people and we need some tools to monitor
their activity without disturbing them too much (like some kind of passive
tracking).  I also realize that some people won't use the Bugzilla and there's
no way to make them use it, so I'm trying to suggest some general albeit well
defined rules for handling kernel bugs that can be followed by everyone
regardless of whether or not he's using the Bugzilla.

Apart from this, I think that some kinds of bugs are fixed faster if they are
reported by email and in many cases email is just a more convenient way of
exchainging information between bug reporters and developers, so I don't think
that ruling it out as a way of reporting bugs, just becuase we have the
Bugzilla, would be the best idea.

The Bugzilla is useful to me and I think it might be useful to many people, but
that doesn't necessarily mean that it'll be useful to everyone in any case.

> > > > > The only thing that matters is that we get bug reports resolved within a 
> > > > > reasonable amount of time.
> > > > 
> > > > I'm not sure if that's generally possible:
> > > > - What about the bugs that take 2 weeks or more to reproduce?
> > > > - What about the bugs that we _don't_ _know_ how to fix?
> > > 
> > > We will never get 100% of all bugs fixed.
> > > 
> > > Let's get back to the fact that we have many bug reports that could be 
> > > fixed within a reasonable amount of time but are not.
> > 
> > Do you have specific examples?
> 
> Take e.g. #3938

Are you sure that this one hasn't been fixed?  The reporter doesn't seem to be
responsive ...

> or #4039

Same here.

> as examples.  

Greetings,
Rafael
