Return-Path: <linux-kernel-owner+w=401wt.eu-S1030997AbXD2Rf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030997AbXD2Rf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030951AbXD2RfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:35:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58910 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030792AbXD2RfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:35:07 -0400
Date: Sun, 29 Apr 2007 19:35:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@stusta.de>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429173500.GA30248@one.firstfloor.org>
References: <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:07:43AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 29 Apr 2007, Andi Kleen wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > > 
> > > The thing is, bugzilla is totally broken because it's designed to help 
> > > track bugs, but it's *not* designed to actually handle the much harder 
> > > problem, which is to actually get the *right* developers to be aware 
> > > of the *right* bugs!
> > 
> > This means we need people who figure out who to assign bugs too.
> > Aka bugmasters.
> 
> Yes. But not using bugzilla.

And what would you use instead? 

> 
> I don't know if you've noticed already, but I'm not the only one that 
> doesn't have a very high opinon of bugzilla ;)

Sure, but do you have alternatives? 

> What works is somebody who is a bugmaster, and it doesn't really matter 
> *what* bug tracker he points to (bugzilla being one of the possibilities, 
> although not necessarily the best, and absolutely NOT the only choice), 
> and turn them into emails. Once they are emails, bugzilla can track them.

So you want to do the work that should be done by a computer in
a database done by a human.  Does not sound particularly efficient.

> > In theory it could be nearly automated. Figure out what files related
> > to the bug and assign to the last 5 people who submitted patches
> > for them and/or signed off. 
> 
> I do think you're pretty optimistic. I think it's true for trivial driver 
> bugs, but even for trivial driver bugs the initial report is often not 
> enough to pinpoint the driver. 
> 
> Let's take the sis900 bug as an example (not because I want to rag on that 
> being a problem, but it happened to be a _trivial_ bug in 2.6.21, so it's 
> a good case of something really really easy - and if that easy case isn't 
> handled trivially and obviously, then the bug-reporting doesn't work).
> 
> In that case, the initial report was (condensed version, but fairly 
> accurate): "system hangs on boot at random points. 2.6.21-rc7 worked 
> well".
> 
> Now, realistically, if that entry had been in bugzilla, what would you do?

You need a few people in bugzilla that ask the questions to narrow it
down (= bugmasters). e.g. the opensuse bugzilla works this way :- 
everything new gets assigned to a few screening people who 
ask some questions and then reassign to the right people.

> Would bugzilla have helped? HELL NO. It would have been a disaster. It 
> would have wasted reporter time, it would have wasted developer time, and

An unmaintained bugzilla yes. A well maintained one would have someone
asking them the (often quite repetive questions) to narrow it down
to a subsystem or a driver. And then it could have been assigned.

> I think both of these are good ideas, but I don't think it's enough. There 
> must be some better form of bug tracking than bugzilla. Some relly 
> distributed way of letting people work together, *without* having to 
> congregate on some central web-site kind of thing. A "git for bugs", where 
> you can track bugs locally and without a web interface.
> 
> And I think it would be something much closer to "distributed email mbox 
> with status tracking facilities", _not_ a web clicky interface.

There have been a couple of email thread trackers; like jitterbug -- 
in fact bugzilla can do that with an email interfaces. But in my experience 
they don't work well because a bug tracking system has slightly different
requirements than normal emails (e.g. it wants you to roughly
stay on topic for the current bug). With email people always
forget that and in the end you end up with lots of stuff in there
not related to the bug at all.

Also with distributed solutions it would be hard to get
a global "how many regressions do we really have right now" statistic,
which is fairly important.

The web interface is slow and ugly but at least it puts
the people in the right mind set for this unlike email.
And it gives you a central point to get an overview of the bugs.

Anyways I'm sure bugzilla could be improved, I just don't know
of anything better currently.

-Andi

