Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbYEAQgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbYEAQgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYEAQgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:36:47 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:53559 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbYEAQgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:36:46 -0400
Date: Thu, 01 May 2008 18:36:45 +0200
Message-Id: <261683298@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: RFC: starting a kernel-testers group for newbies
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19AxM8PxOYKUd0/aNyWI/AohBNXovMZfwS0iGSbSyKoQdnAf
 DpgpQ3HiXZx3vTW9x6UYIBX7dEldegBsSIklt6QtQrhI5I5eVs=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>And why can't they work on the bug?  Usually, because they found a
>workaround.  People aren't going to spend months sitting in front of a
>non-functional computer waiting for kernel developers to decide if their
>machine is important enough to fix.  They will find a workaround.  They
>will buy new hardware.  They will discover "noapic" (234000 google hits and
>rising!).  They will swap it with a different machine.  They will switch to
>a different distro which for some reason doesn't trigger the bug.  They
>will use an older kernel.  They will switch to Solaris.  Etcetera.  People
>are clever - they will find a way to get around it.
>
>I figure that after a bug is reported we have maybe 24 to 48 hours to send
>a good response before our chances of _ever_ fixing it have begun to
>decline sharply due to the clever minds at the other end.

yes, this is absolutely true !



List:       linux-kernel
Subject:    Re: RFC: starting a kernel-testers group for newbies
From:       Andrew Morton <akpm () linux-foundation ! org>
Date:       2008-05-01 15:49:19
Message-ID: 20080501084919.8ac6dbdd.akpm () linux-foundation ! org
[Download message RAW]

On Thu, 1 May 2008 16:21:59 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> > > But our current status quo is not OK:
> > > 
> > > Check Rafael's regressions lists asking yourself
> > > "How many regressions are older than two weeks?" 
> > 
> > "ext4 doesn't compile on m68k".
> > YAWN.
> >  
> > Wrong question...
> > "How many bugs that a sizable portion of users will hit in reality are there?"
> > is the right question to ask...
> >...
> 
> "Kernel oops while running kernbench and tbench on powerpc" took more 
> than 2 months to get resolved, and we ship 2.6.25 with this regression.

Precisely.  Cherry-picking a single example such as the 68k thing and then
claiming that it reflects the general is known as a "fallacy".

> Granted that compared to x86 there's not a sizable portion of users 
> crazy enough to run Linux on powerpc machines...

Another fallacy which Arjan is pushing (even though he doesn't appear to
have realised it) is "all hardware is the same".

Well, it isn't.  And most of our bugs are hardware-specific.  So, I'd
venture, most of our bugs don't affect most people.  So, over time, by
Arjan's "important to enough people" observation we just get more and more
and more unfixed bugs.

And I believe this effect has been occurring.

And please stop regaling us with this kerneloops.org stuff.  It just isn't
very interesting, useful or representative when considering the whole
problem.  Very few kernel bugs result in a trace, and when they do they are
usually easy to fix and, because of this, they will get fixed, often
quickly.  I expect netdevwatchdogeth0transmittimedout.org would tell a
different story.

One thing which muddies all this up is that bug reporters vanish.  Over the
years I have sent thousands and thousands of ping emails to people who have
reported bugs via email, three to six months after the fact.  Some were
solved - maybe a fifth.  About the same proportion of reporters reply and
give some reason why they cannot work on the bug.  In the majorty of cases
people don't reply at all and I suspect they're in the same category of
cannot-work-on-the-bug.

And why can't they work on the bug?  Usually, because they found a
workaround.  People aren't going to spend months sitting in front of a
non-functional computer waiting for kernel developers to decide if their
machine is important enough to fix.  They will find a workaround.  They
will buy new hardware.  They will discover "noapic" (234000 google hits and
rising!).  They will swap it with a different machine.  They will switch to
a different distro which for some reason doesn't trigger the bug.  They
will use an older kernel.  They will switch to Solaris.  Etcetera.  People
are clever - they will find a way to get around it.

I figure that after a bug is reported we have maybe 24 to 48 hours to send
a good response before our chances of _ever_ fixing it have begun to
decline sharply due to the clever minds at the other end.

Which leads us to Arjan's third fallacy:

   "How many bugs that a sizable portion of users will hit in reality
   are there?" is the right question to ask...

well no, it isn't.  Because approximately zero of the hardware bugs affect
a sizeable portion of users.  With this logic we will end up with more and
more and more and more bugs each of which affect a tiny number of users. 
Hundreds of different bugs.  You know where this process ends up.

Arjan's fourth fallacy: "We don't make (effective) prioritization
decisions." lol.  This implies that someone somewhere once sat down and
wondered which bug he should most effectively work on.  Well, we don't do
that.  We ignore _all_ the bugs in favour of busily writing new ones.

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
[prev in list] [next in list] [prev in thread] [next in thread] 




Configure | About | News | Donate | Add a list | Sponsors: 10East, KoreLogic, Terra-International 
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

