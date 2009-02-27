Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbZB0KP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbZB0KP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZB0KPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:15:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35705 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZB0KPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:15:46 -0500
Date: Fri, 27 Feb 2009 11:18:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227101818.GH4582@elf.ucw.cz>
References: <200902191356.53584.rjw@sisk.pl> <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org> <20090222140311.GF1387@ucw.cz> <200902231504.27879.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231504.27879.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-02-23 15:04:22, Oliver Neukum wrote:
> Am Sonntag 22 Februar 2009 15:03:11 schrieb Pavel Machek:
> > Hi!
> >
> > > > Again, the decision to trigger automatic suspend has to be based on
> > > > some well defined criteria and the (in)activity of devices seems to be
> > > > one of them.
> > >
> > > I don't know what criteria the system monitor would use.  It might have
> > > to be platform-specific.  The Android people seem to have a pretty good
> > > idea of what criteria will work for them.
> > >
> > > Inactivity of devices isn't always a good criterion.  There might be a
> > > background task which wakes up every few seconds to do something as
> > > long as the system is awake, thereby keeping some device always active.
> > > The activity from this background task shouldn't prevent an auto-sleep.
> >
> > Then we'd need a interface to mark such background task... and what is
> > reasonable use for such task, anyway? Either its job is neccessary, or
> > it should not waste power.
> 
> Why? We have decided that some tasks are more important than
> other tasks, to the point of starving some tasks. Posix real time
> already does that.
> 
> We can just as well have a class of tasks less important than power
> saving. They'd just run when power saving is not active for some other
> reason. Just like other such schemes we end up with the problem
> of priority inversion with locking.

Ok, I guess this could be interesting in some cases... maybe. What are
real examples of such tasks?

Note that this will be fairly hard to implement due to all the
priority inversions; so it better be pretty important.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
