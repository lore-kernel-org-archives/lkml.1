Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbXKMW33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbXKMW33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbXKMW3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:29:13 -0500
Received: from rtr.ca ([76.10.145.34]:1672 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779AbXKMW3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:29:11 -0500
Message-ID: <473A2535.7080304@rtr.ca>
Date: Tue, 13 Nov 2007 17:29:09 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113193750.GD1356@flint.arm.linux.org.uk> <473A067F.3090007@rtr.ca> <20071113213358.GC20167@lazybastard.org>
In-Reply-To: <20071113213358.GC20167@lazybastard.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Tue, 13 November 2007 15:18:07 -0500, Mark Lord wrote:
>> I just find it weird that something can be known broken for several -rc*
>> kernels before I happen to install it, discover it's broken on my own machine,
>> and then I track it down, fix it, and submit the patch, generally all within a
>> couple of hours.  Where the heck was the dude(ess) that broke it ??  AWOL.
>>
>> And when I receive hostility from the "maintainers" of said code for fixing
>> their bugs, well.. that really motivates me to continue reporting new ones..
> 
> Given a decent bug report, I agree that having the bug not looked at is
> shameful.  But what can a developer do if a bug report effectively reads
> "there is some bug somewhere in recent kernels"?  How can I know that in
> this particular case it is my bug that I introduced?  It could just as
> easily be 50 other people and none of them are eager to debug it unless
> they suspect it to be their bug.
..

Most of the regressions we have are easily identifiable and not of the type
where there could "50 other people" touching the relevant code.  As a developer
(and former subsystem maintainer) I look hard at my own code when there's a
bug reported that could have come from recent updates there.  Usually there are
not that many updates to consider, and tracking it down is just a matter of
being willing to do so.

Of late, I've given up on other developers fixing the stuff they break on my
own machines, and I generally just dive into totally unfamiliar code, and find
and fix it myself.  Quite quickly, usually.  And the bugs are often very apparent
just from looking at the source code diffs (patches) from recent history in
the code that's not working.  This is not rocket science, and it doesn't require
a log2 download/rebuild/reboot process.

But yes, there are more difficult ones, like when my machine crashed yesterday
with some form of corruption showing up during JBD filesystem I/O.  That's one
where the problem isn't going to be obvious to anyone, and I don't actually
expect anyone to go looking for it right away.  If more such events happen,
then it will get more attention.

But things like broken drivers, in almost every case those are trivial
to track down and fix, even for people not familar with that specific code.

> This is a common problem and fairly unrelated to linux in general or the
> kernel in particular.  Who is going to be the sucker that figures out
> which developer the bug belongs to?  And I have yet to find a project,
> commercial or opensource, where volunteers flock to become such a
> sucker.
> 
> One option is to push this role to the bug reporter.  Another is to
> strong-arm some developers into this role, by whatever means.  A third
> would be for $LARGE_COMPANY to hire some people.  If you have a better
> idea or would volunteer your time, I'd be grateful.  Simply blaming one
> side, whether bug reporter or a random developer, for not being the
> sucker doesn't help anyone.
..

Nobody's blaming anyone here.  I'm just asking that developers here do more
like our Top Penguin does, and actually look at problems and try to understand
them and suggest fixes to try.  And not rely solely on the git-bisect crutch.
It's a good crutch, provided the reporter is a kernel developer, or has a lot
of time on their hands.  But we debugged Linux here for a long time without it.

And I already volunteer my time here, thanks, BIG TIME, since 1992 or so.

Cheers

