Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbXDZVNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbXDZVNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXDZVNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:13:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111AbXDZVN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:13:28 -0400
Date: Thu, 26 Apr 2007 14:13:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070426224148.69b91b2e.diegocg@gmail.com>
Message-ID: <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
 <20070426224148.69b91b2e.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Diego Calleja wrote:
> 
> Bugzilla sucks quite a lot at email, but you can answer emails and they get
> into the bugzilla database; and there're two mailing lists (listed in
> Documentation/HOWTO) that send notifications about every new bug
> added/modified- I know it's not the perfect email interface every hacker
> wants, but it's better than nothing.

No, it's *not* better than nothing.

The thing is, these reports MUST NOT go to "everybody". If they do, that 
is actually *worse* than nothing, because people will just ignore them 
entirely, since they aren't "directed".

The emails need to be directed to the appropriate parties, not go to 
everybody. There is nobody who is interested in seeing all regressions, 
except perhaps me and Andrew. Most *real* developers (as opposed to people 
like me, who are integrators, not "real developers") want to be notified 
about problems in *their* area, and if it's just automation that sends out 
everything, it just dilutes the value of the thing, to the point where 
people will ignore it even for the cases when they happen to be related to 
what they do.

> I suggested some time ago that it'd be useful to send every new bug
> notification from bugme-new to the LKML (and/or other lists).

I don't know a lot of developers who actually read LKML. I know a lot of 
people who look for interesting subject lines and interesting people, but 
read LKML in the sense of reading everything? Not likely.

That's why I think Adrian did a great job: he took the "noise" and made it 
somethng worth looking at! And part of that is very much to make it 
directred to only relevant parties (yes, they *also* got cc'd to 
linux-kernel, but people would get them in their personal mailboxes and 
*not* feel like it was just noise that didn't matter to them!)

> I can understand Adrian's resign. Bugzilla is crap, but there're users
> reporting bugs there and willing to cooperate to fix them, and they're
> not getting listened.

I personally refuse to have anything at all with bugzilla. The interface 
is so horrible that it's just not worth my time. I know there are a few 
people who use it productively, but I'm always amazed that they can do 
that.

The *big* problem with bugzilla is that it's such a "detail-oriented" 
thing. It's fine if you have *one* bug that you're tracking. But whenever 
that's not the case, it's almost totally useless.

Let me put it another way: I would never use a source control system that 
forces me to look at my 22,000 files one at a time. I think such a system 
is fundamentally broken, because it makes it impossible to get the big 
picture ("what changed in the last week" kind of thing). The same is true 
of bugzilla: if you *know* which bug you're looking at, it's good. For 
anythign else, it's almost worse than useless, exactly because there is no 
way to get an overview.

> There're even a few description of patches (ie: "line
> 6 in foo.c is wrong and it breaks our testing, it should read like this:")
> that have been sitting there for *years* and not getting merged.

.. and you claim that this shows that developers don't listen. I'd say it 
shows the exact *opposite*: the users don't listen. There's a lot mroe 
users than developers, and bugzilla is pretty much designed to let the 
users "report and forget", which is exactly the *wrong* thing to do, 
because it puts the onus on the developer.

(I've said this before, but I'll say it again: one thing that would 
already make bugzilla better is to just always drop any bug reports that 
are more than a week old and haven't been touched. It wouldn't need *much* 
touching, but if a reporter cannot be bothered to say "still true with 
current snapshot" once a week, then it shouldn't be seen as being somehow 
up to those scare resources we call "developers" to have to go through 
it).

So there are probably things that bugzilla could do to become more useful, 
but I don't see that happening. We'd need either a smarter/better 
bugzilla, or somebody who actually turns noise into real information. 
Adrian did that (although in fairness to others, other people definitely 
do it too. Dave Jones, for example. Very useful).

> So I, or anyone else, could try to do Adrian's job. But if Adrian (a guy
> that sends patches to make global functions static 8) got tired
> of doing that job, I suspect that I, or anyone else would also got 
> tired of it even sooner.

I do agree - one of the problems with the job is not that it's thankless 
(I think we've had at least ten kernel developers, very much including me, 
talking about how _useful_ it is), but there is definitely a lack of 
glamour and probably interest.

I think it could be more interesting if part of the job was doing the 
tools. Tools *are* important. Most of my actual _development_ for the last 
couple of years has been on "git", not the kernel, but I think I was more 
productive that way, so I don't think that's wasted time at all.

So yes, automation would be a good idea, but I don't think bugzilla is it. 

> There're other big projects with probably more bug reports than linux, 
> they don't work this way, and they look more succesful in their bug 
> handling.

Well, one thing to keep in mind is that the kernel really does have a 
*lot* more development going on that most other projects.

I don't think you'll find another project that has about six megabytes of 
diffs every release (every two months). That's really one of the 
fundamental issues - things really *happen* in the kernel. A *lot* of 
things. You can't take a breather - I can do "stabilization releases" 
every once in a while, and Andrew can kick out patches he decides aren't 
ready to be merged rather than maintain them in his tree (and he does do 
that), but the kernel simply tends to have a different *scale* than other 
projects.

And almost all hard bugs are about hardware interactions. Drivers. Big 
iron. Things like that - ie unlike something like a compiler, you can 
seldom say "this test-case crashes". Yes, that does happen for the kernel 
too, but those are the *easy* bugs. Those generally get fixed in a day or 
two.

So I really don't think you can compare to "other projects". They simply 
don't have these issues.

		Limis
