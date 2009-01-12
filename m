Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZALQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZALQLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZALQLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:11:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37190 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZALQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:11:38 -0500
Date: Mon, 12 Jan 2009 17:11:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: Linas Vepstas <linasvepstas@gmail.com>
Cc: david@lang.hm, Nick Andrew <nick@nick-andrew.net>,
       David Newall <davidn@davidnewall.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net,
       mills@udel.edu, Brian Haberman <brian@innovationslab.net>,
       "Karen O'Donoghue" <karen.odonoghue@navy.mil>, ntpwg@lists.ntp.isc.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
	2008-2009
Message-ID: <20090112161115.GA1474@ucw.cz>
References: <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com> <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm> <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-05 11:42:35, Linas Vepstas wrote:
> 2009/1/5  <david@lang.hm>:
> > On Mon, 5 Jan 2009, Linas Vepstas wrote:
> >
> >>> Arguably the kernel's responsibility should be to keep track of the
> >>> most fundamental representation of time possible for a machine (that's
> >>> probably TAI) and it is a userspace responsibility to map from that
> >>> value to other time standards including UTC,
> >>
> >> Yes, this really does seem like the right solution.
> >>
> >>> using control files
> >>> which are updated as leap seconds are declared.
> >>
> >> Lets be clear on what "control files" means.  This does
> >> *NOT* mean some config file shipped by some distro
> >> for some package. That would be a horrid solution.
> >> People don't install updates, patches, etc.  Distros
> >> ship them late, or never, if the distro is old enough.
> >>
> >> A more appropriate solution would be to have
> >> either the kernel or ntpd track the leap seconds
> >> automatically.  First, the ntp protocol already provides
> >> the needed notification of a leap second to anyone
> >> who cares about it (i.e. there is no point in getting a
> >> Linux distro involved in this -- a distribution mechanism
> >> already exists, and works *better* than having a distro
> >> do it).
> >
> > I disagree with this. NTP will only know about leap seconds if it was
> > running and connected to a server that advertised the leap seconds during
> > that month.
> >
> > for example, if you installed a new server today, how would it ever know
> > that there was a leap second a couple of days ago?
> 
> OK, good point.  Unless your distro was less
> than a few days old (unlikely), you are faced with the
> same problem.  Sure, eventually, the distro will publish
> an update (which will add to the existing list of 36 leap
> seconds -- which is needed in any case, since no one
> has a server that's been up since 1958),  but this is
> unlikely to happen during this install window.
> 
> The long term solution would be write an RFC to extend
> NTP to also provide TAI information -- e.g. to add a
> message that indicates the current leap-second offset
> between UTC and TAI.

Offset is not enough; you'd have to provide list of all previous leap
seconds with 'when it happened' timestamps.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
