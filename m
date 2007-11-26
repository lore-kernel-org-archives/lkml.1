Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXKZAdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXKZAdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 19:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbXKZAd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 19:33:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbXKZAd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 19:33:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS
Date: Mon, 26 Nov 2007 01:51:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200711252157.10212.rjw@sisk.pl> <200711260104.25911.rjw@sisk.pl> <20071126000644.GA6538@stusta.de>
In-Reply-To: <20071126000644.GA6538@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711260151.38572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 of November 2007, Adrian Bunk wrote:
> On Mon, Nov 26, 2007 at 01:04:25AM +0100, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, Adrian Bunk wrote:
> > > On Mon, Nov 26, 2007 at 12:00:28AM +0100, Rafael J. Wysocki wrote:
> > > > On Sunday, 25 of November 2007, Adrian Bunk wrote:
> > > >...
> > > > > I don't care whether that's done with Bugzilla, some email based bug 
> > > > > tracker like the Debian bug tracker, someone putting emails manually 
> > > > > into some bug tracker like you are doing, or whatever else.
> > > > 
> > > > That last solution doesn't scale very well ...
> > > > 
> > > > How about using the system in which it's possible to report bugs using both
> > > > email and a web interface?
> > > > 
> > > > We can request that the address of the bug tracker be added to the Cc lists of
> > > > bug reports sent by email and we can make it resend reports filed with it to
> > > > the appropriate mailing lists and with the appropriate email headers.  This is
> > > > technically doable.
> > > 
> > > You are trying to solve something that is not a problem.
> > 
> > It _is_ a problem, because many bug are reported using email and not really
> > tracked.  The ones that I manually put into the Bugzilla are the tip of the
> > iceberg (and BTW I'd prefer not to have to do that manually).
> > 
> > Every bug reported by email and not responded to by the right people, that is
> > not a recent regression, is currently lost.  I'd like to avoid that, if possible.
> 
> This is solved by many other projects by asking the submitter to open a 
> bug for the issue when he sends it in an email.
> 
> The submitter then simply copies the information from his email to his 
> newly opened bug in the bug tracker.
> 
> -> no problem
> 
> > > It does not matter which medium we choose for getting bug reports.
> > 
> > [Well, you said that we should use a web interface for that. ;-)]
> 
> I said a web interface is not worse than via email.
> And it's enough.
> 
> (And I e.g. wouldn't oppose using the Debian bug tracker where the web 
>  interface only allows reading and everything has to be done via email
>  if all kernel maintainers would agree to use this.)
> 
> > No, it doesn't, as long as the bug reports reach the right place.  Now, the
> > question is what's that.
> > 
> > IMO, ideally, for each subsystem there should be a mailing list to send bug
> > reports to.  The Bugzilla should forward the reports to these lists.  On every
> > such list there should be (at least) one person responsible for responding to
> > the bug reports, if no one else responds first, and for forwarding the reports
> > to the appropriate developers.  This person should also be responsible for
> > monitoring the status of each bug report sent to his/her list.
> 
> After all discussions about crazy bug tracker features we are back at 
> the real problem:

We started to discuss them, because you argued that the Bugzilla in its current
shape was sufficient, which I didn't agree with and tried to give some
arguments.

> Where do we find the tree these people grow on?

That's a good question, but either we find these people, or we'll start losing
users at growing rates.

I'm afraid that's already happening ...

> > _Every_ bug report sent (including invalid ones) should be recorded in a bug
> > tracking system (be it the Bugzilla or whatever else) along with all of it's
> > history (at least, refernces to the bug's history should be stored), no matter
> > how it's been handled.  Moreover, a bug can only be resolved as "fixed" if
> > there's a pointer to the exact commit fixing it in the bug's history.
> 
> And back we are at crazy bug tracker features...

No, they are not bug tracker features, but parts of a process that I think we
should have in place.

> > > The only thing that matters is that we get bug reports resolved within a 
> > > reasonable amount of time.
> > 
> > I'm not sure if that's generally possible:
> > - What about the bugs that take 2 weeks or more to reproduce?
> > - What about the bugs that we _don't_ _know_ how to fix?
> 
> We will never get 100% of all bugs fixed.
> 
> Let's get back to the fact that we have many bug reports that could be 
> fixed within a reasonable amount of time but are not.

Do you have specific examples?

Rafael
