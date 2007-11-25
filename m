Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbXKYWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbXKYWmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXKYWmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:42:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXKYWmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:42:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS
Date: Mon, 26 Nov 2007 00:00:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200711252157.10212.rjw@sisk.pl> <200711252251.15623.rjw@sisk.pl> <20071125215158.GD18284@stusta.de>
In-Reply-To: <20071125215158.GD18284@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711260000.28972.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Adrian Bunk wrote:
> On Sun, Nov 25, 2007 at 10:51:14PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 25 of November 2007, Adrian Bunk wrote:
> > > On Sun, Nov 25, 2007 at 09:57:09PM +0100, Rafael J. Wysocki wrote:
[--snip--]
> > > 
> > > How should a newbie find the correct mailing list?
> > 
> > Read MAINTAINERS?  Ok, I should have said about that.
> > 
> > > Benchmark:
> > > Easier than the "some more work" when using Bugzilla.
> > 
> > Nope.  Please try to file a report against libata/PATA using the Bugzilla.
> > Good luck. ;-)
> 
> $ grep PATA MAINTAINERS
> $ 

Too bad (and this is a bug BTW).

> > > >...
> > > > +It also is a good idea to notify the maintainer of the affected subsystem and
> > > > +the maintainer of the tree in which the bug is present by adding their email
> > > > +addresses to the Cc list of the bug report message.  The email addresses of
> > > > +maintainers of the majority of kernel subsystems can be found in the MAINTAINERS
> > > > +file, but you should not worry too much about getting a wrong person.
> > > 
> > > If you don't already know MAINTAINERS well then finding the right 
> > > component in Bugzilla is much easier.
> > 
> > I disagree.  How a newbie is supposed to know what AIO and DIO mean and WTH is
> > the difference between LVM2/DM and MD? 
> > 
> > I took only the IO/Storage submenu as an example, but there are other things
> > like that.  For instance, what is the difference between "Flash/Memory
> > Technology Devices" and MMC/SD?  Why "Hotplug" is under "Drivers" and WTH
> > does it *mean*?  What "W1" means for that matter??  Etc.
> 
> Then let's get that improved.

OK

Who's supposed to be responsible for that?

[--snip--]
> > > 
> > > Really, we must define _one_ way for people to report a bug, and how 
> > > developers are reminded is _our_ job.
> > 
> > Well, who's "we" in that context?  IOW, who's job exactly it's supposed to be?
> 
> "we" = "we kernel developers"
> 
> And Natalie seems to be the person being paid for doing such stuff...
> 
> > > >...
> > > > +Generally, the following things are appreciated in a bug report:
> > > >...
> > > 
> > > If you expect people to read and follow this, wouldn't it be easier to
> > > simply point them to open the bug in Bugzilla where we already have a
> > > template asking these questions?
> > 
> > I don't think so and please refer to the examples above.
> > 
> > > You could replace the whole contents of this file with:
> > > Go to http://bugzilla.kernel.org/ and click on "Enter a new bug report".
> > > 
> > > It's a pity that we manage to add/change an average of 100.000 bugs^Wlines
> > > of code each month, but do not have one generally accepted and working 
> > > process for bug reports.
> > 
> > It's a pity that we do not have one, indeed, and so perhaps it's a good idea
> > to try to create one?  Not necessarily focusing on the Bugzilla for a little
> > while. ;-)
> 
> I'm not focussed on Bugzilla.
> 
> But a submitter should send a bug report _once_ through one well-defined 
> medium, this should result in the bug report not being lost, and every 
> other communication of the submitter should be triggered by developers 
> requesting additional information.

I don't think that have to be only *one* medium as long as we're able to track
the bugs (see my last reply in the other thread).

> I don't care whether that's done with Bugzilla, some email based bug 
> tracker like the Debian bug tracker, someone putting emails manually 
> into some bug tracker like you are doing, or whatever else.

That last solution doesn't scale very well ...

How about using the system in which it's possible to report bugs using both
email and a web interface?

We can request that the address of the bug tracker be added to the Cc lists of
bug reports sent by email and we can make it resend reports filed with it to
the appropriate mailing lists and with the appropriate email headers.  This is
technically doable.

Greetings,
Rafael
