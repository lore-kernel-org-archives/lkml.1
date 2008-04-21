Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYDULOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYDULOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYDULOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:14:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbYDULOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:14:37 -0400
Date: Mon, 21 Apr 2008 13:14:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
	latest -git
Message-ID: <20080421111417.GA16781@elte.hu>
References: <20080419103942.GA13599@elte.hu> <20080419.040945.13369499.davem@davemloft.net> <20080421082254.GA2522@elte.hu> <20080421.015837.35795810.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421.015837.35795810.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 21 Apr 2008 10:22:54 +0200
> 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > > You haven't cared about how I push my trees to Linus for years, 
> > > why is it a problem all of a sudden?
> > 
> > the answer is simple, and it has nothing to do with you or with 
> > networking at all: i'm maintaining about 10 times more code (and 
> > more commits) than before.

<complete quote>
> > That means i'm signing off on more than 1000 commits per release, 
> > and i'm exposed in a magnified way to other people's trees. [...]
</complete quote>

> Then, I can only conclude what several others have also concluded, 
> that you've taken on x86 maintainence purely so that you can berate 
> other subsystem maintainers who don't do things up to your 
> specifications and standards.
> 
> And frankly Ingo, that sucks.
> 
> Instead of discussing things with people, you get up every morning and 
> shoot off your randconfig nuclear bombs at your targets.  It's what 
> you've done all weekend long and it's very much NOT appreciated.

David, your argument is getting rather surreal and unjust.

in case you havent been following us on lkml lately, we've been doing 
these randconfig tests (and have been reporting failures) for the last 
6+ months almost non-stop. Initially it was rather hard to do - i 
carried dozens of patches at times to keep the test humping along.

That shrunk within 1-2 months and these days this test generally works 
fine day over day, night over night - with the merge window being an 
(expected) small hickup. There's nothing new about it and if there's 
anything nuclear here it's your accusations :-(

in hindsight i'm particularly happy that the test creates a random 
sample because that way i can have no influence _at all_ about what kind 
of bug gets found, so it is plain obvious that:

 - its not about berating other maintainers
 - its not about proving i do a better job

if you got 5 networking bugreports from me in short succession that is 
simply so because they triggered in such short succession!

Also, because it's a random sample, we can make reliable observations 
about the bug patterns - like it or not. That is _good_, because it 
gives a metric without much (or any) subjective bias. Do you regard it 
inappropriate to make any observations about the patterns of bugs we 
find and report?

So IMO there's absolutely no objective reason for you to be upset about 
_me_ - i'm just running a test that generates random kernels and i 
report failures as i get them and observe patterns and annoyances while 
doing so.

And i dont even understand your argument that basing and testing our 
trees against latest -git is somehow wrong and that we should base our 
trees against linux-next or -mm - you dont base your trees against them 
either, and for similarly obvious reasons i suspect, right?

> The build failure knowledge is appreciated, however the reason you are 
> reporting them is not.  Why do we need to know that your automated 
> tools have found 5 networking build failures "so far" over the 
> weekend?  That number is relative to what, exactly?  [...]

My "so far" comment was based on the simple fact that these tests are 
running non-stop and are continuously finding new bugs - and that the 
last 5 bugs that triggered were networking. In my experience, if 5 build 
bugs trigger in relatively short succession in a random sample, in 2500 
new commits (out of which ~1000 are networking), then more might be 
there as well - just harder to trigger.

[ btw., today seems to be a better day finally: after excluding that
  minor SCTP complication from the test space, 116 kernels built and
  booted up fine in a row, so far. ]

	Ingo
