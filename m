Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbXD2Qpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbXD2Qpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXD2Qph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:45:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbXD2QpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:45:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21
Date: Sun, 29 Apr 2007 18:49:22 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@stusta.de>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291849.23197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 18:07, Linus Torvalds wrote:
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
> 
> I don't know if you've noticed already, but I'm not the only one that 
> doesn't have a very high opinon of bugzilla ;)
> 
> What works is somebody who is a bugmaster, and it doesn't really matter 
> *what* bug tracker he points to (bugzilla being one of the possibilities, 
> although not necessarily the best, and absolutely NOT the only choice), 
> and turn them into emails. Once they are emails, bugzilla can track them.
> 
> Andrew does this, and yes, Adrian did it.
> 
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
> 
> Equally realistically, let's ignore bugzilla for a moment, and ask what 
> the best method for handling something like this would be? Have an open 
> mind, no rules on "have to use bug tracker XYZ". 
> 
> You know what? The report went to me and the kernel mailing list as email. 
> And that was the *right* thing in that case. There was no good sign of who 
> it should go to, and while there wasn't a whole lot of information there, 
> there *was* a very tight timeframe (ie it could pinpoint to within about a 
> week when it started). But the only thing I could really ask for was for 
> the person to bisect it.
> 
> Would bugzilla have helped? HELL NO. It would have been a disaster. It 
> would have wasted reporter time, it would have wasted developer time, and 
> it would likely have been ignored because the bug report wasn't specific 
> enough to really trigger any good queries or trigger a maintainer.
> 
> So bugzilla wouldn't have helped even for a _trivial_ bug. 
> 
> I personally suspect that bugzilla helps more if a bug actually has a real 
> history, and people want to actually save that history because they are 
> stumped. But I think it should come in *then*, not immediately. Because it 
> is actually too intrustive for the simple stuff - and most bugs actually 
> are simple, it's just that they also get resolved so simply that people 
> don't even think of them as bugs (ie we have a lot of "duh" kind of fixes 
> too).

I completely agree.

My personal experience with bugzilla is that it's very unfriendly to
reporters.  IMHO it's suitable for tracking unresolved problems along with
debug patches, system information etc., but not for _reporting_ new ones.

Greetings,
Rafael
