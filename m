Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZGESWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZGESWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZGESWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:22:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55139 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbZGESWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:22:17 -0400
Date: Sun, 5 Jul 2009 20:21:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL -tip][PATCH 0/9] MTRR fix trivial style patches
Message-ID: <20090705182151.GA7668@elte.hu>
References: <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk> <20090703144754.GA13246@elte.hu> <20090703160230.093e422c@lxorguk.ukuu.org.uk> <20090703155809.GA20121@elte.hu> <20090703172651.619162fd@lxorguk.ukuu.org.uk> <20090703164225.GA21447@elte.hu> <1246673939.2642.5.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246673939.2642.5.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> > I think even the MTRR code (which is indeed one of the few x86 
> > places still not fully cleaned up) supports my arguments.
> > 
> > Look at the averages:
> > 
> >                                       errors   lines of code   errors/KLOC
> > arch/x86/kernel/cpu/mtrr/amd.c             2             120          16.6
> > arch/x86/kernel/cpu/mtrr/centaur.c         8             225          35.5
> > arch/x86/kernel/cpu/mtrr/cleanup.c         0            1102             0
> > arch/x86/kernel/cpu/mtrr/cyrix.c          10             275          36.3
> > arch/x86/kernel/cpu/mtrr/generic.c        16             730          21.9
> > arch/x86/kernel/cpu/mtrr/if.c             11             428          25.7
> > arch/x86/kernel/cpu/mtrr/main.c           50             751          66.5
> > arch/x86/kernel/cpu/mtrr/state.c           0              83             0
> > 
> 
> By these trivial mtrr cleanup patches:
>                                       errors
> arch/x86/kernel/cpu/mtrr/amd.c             0
> arch/x86/kernel/cpu/mtrr/centaur.c         0
> arch/x86/kernel/cpu/mtrr/cleanup.c         0
> arch/x86/kernel/cpu/mtrr/cyrix.c           0
> arch/x86/kernel/cpu/mtrr/generic.c         0
> arch/x86/kernel/cpu/mtrr/if.c              0
> arch/x86/kernel/cpu/mtrr/main.c            0
> arch/x86/kernel/cpu/mtrr/state.c           0
> 
> The following changes since commit 2137f10fd78ce8540ec4305f4dcd559039444544:
>   Ingo Molnar (1):
>         Merge branch 'perfcounters/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-top.git master
> 
> Jaswinder Singh Rajput (9):
>       x86: mtrr/amd.c fix trivial style problems
>       x86: mtrr/centaur.c fix style problems
>       x86: mtrr/cleanup.c fix trivial style problems
>       x86: mtrr/cyrix.c fix trivial style problems
>       x86: mtrr/generic.c fix style problems
>       x86: mtrr/if.c fix trivial style problems
>       x86: mtrr/mtrr.h fix trivial style problems
>       x86: mtrr/state.c fix trivial style problems
>       x86: mtrr/main.c fix style problems
> 
>  arch/x86/kernel/cpu/mtrr/amd.c     |    7 +-
>  arch/x86/kernel/cpu/mtrr/centaur.c |  127 +++----------------------
>  arch/x86/kernel/cpu/mtrr/cleanup.c |   18 ++--
>  arch/x86/kernel/cpu/mtrr/cyrix.c   |   30 +++---
>  arch/x86/kernel/cpu/mtrr/generic.c |  147 +++++++++++++++-------------
>  arch/x86/kernel/cpu/mtrr/if.c      |   51 +++++++----
>  arch/x86/kernel/cpu/mtrr/main.c    |  185 +++++++++++++++++++-----------------
>  arch/x86/kernel/cpu/mtrr/mtrr.h    |    7 +-
>  arch/x86/kernel/cpu/mtrr/state.c   |   20 +++--
>  9 files changed, 263 insertions(+), 329 deletions(-)

Jaswinder, i'm going to ignore such pull requests from you in the 
future, because your changes are exceedingly painful and you just 
dont seem to learn.

This is the Nth incident, and there were a countless number of prior 
incidents where i warned you about various classes of avoidable 
problems, and you are not showing signs of significant improvements.

To get more specific: in this case too it's the same old problem of 
low quality of patches from you again:

 - You managed to put _3_ separate bugs into these 'trivial'
   cleanups. That is not acceptable. If you cannot make trivial
   patches be truly trivial, you should not be doing them really. 

 - i had to remove/undo/fix some bogus 'fixes' you did in those
   patches where you just blindly followed checkpatch instead of
   thinking about it for a minute. We dont want checkpatch warriors 
   - we want people with taste who use it as a tool to keep their
   new patches tidy, or who use it as a tool to aid cleanups.

 - i had to complete the patches and do all the cleanups you missed
   - sometimes on the next time to a change you did. You apparently 
   only checked checkpatch output - you didnt even look at all the 
   files for how it all looks like and whether there are other 
   things in those files that checkpatch missed. You made the files
   'checkpatch clean' - but you didnt actually look at whether the 
   files got cleaned up for good really. You left a half-done 
   jumbled mess behind you with files that still had inconsistent 
   looking style in them. Check the deltas of the patches i
   committed versus the ones you sent to see the countless cases you
   missed. And you cannot even claim to have done the 'trivial' 
   ones safely - because you did it in a buggy way and because the 
   final cleanups i did are all trivial too and can be validated.

 - i had to double check each commit on the assembly level to prove 
   that the patches are true cleanups. The new commit logs, size 
   checks, md5 sums are proof of that due diligence process. You 
   obviously didnt do any of that - you'd have noticed the bugs you 
   have put in had you done that.

 - i had to edit _all_ your changelogs. Again. You _still_ dont 
   think about your changelogs, they still suck 90% of the time.

All things considered it took me 6 hours to fix up and complete your 
'trivial' patches into which you have put only 3 hours of work:

 - your buggy and incomplete cleanups did:

      9 files changed, 263 insertions(+), 329 deletions(-)

 - the proper, fixed, rounded up, checked, validated and working 
   cleanups i committed with 6 extra hours of work:

      9 files changed, 868 insertions(+), 862 deletions(-)

The MTRR code is a highly critical piece of x86 code and i had to 
check assembly dumps manually and compared them to make sure the 
changes dont introduce subtle regressions.

The fact is, there is no other way to establish the trust level of 
trivial cleanups but to invest this depth of review and this level 
of testing and checking. I cannot just review until i find the first 
bug or problem and bounce it back to you as a review failure - i 
cannot know whether i can trust your next version of the patch and i 
cannot check the same trivial cleanups again and again as a machine, 
until you manage to submit the correct one.

So i've tested the trustworthyness of your changes for a final time 
and you failed this test.

I still committed it all under your name because i kept a fair 
amount of your changes so it's all v2 versions of your original 
patches - and per kernel convention i noted it in the changelog that 
i modified it further (and i didnt want to create 9 more commits, 
especially as some of your patches were broken so not bisection 
safe) - but this was the last time i went through such an effort 
with your patches.

As i warned you _repeatedly_ in the past that you should insert a 
lot more effort into patches before sending any patches and before 
sending any pull request. Other x86 maintainers warned you about 
that too. You seem to prefer five patches a day (a few of which are 
inevitably broken) instead of one good patch every five days.

This low level of patch quality just does not scale for maintainers 
of a busy tree which has more than a hundred contributors in every 
cycle. If i cannot trust a contributor i cannot apply such patches 
directly.

All in one, you were making the same kinds of mistakes again and 
again, over a many month time-span, and you are causing a 
considerable amount of maintainer overhead that is just not 
sustainable really.

So this simply does not work in this form. I can work with pretty 
much anyone, but there's a final limit to the energy i can invest 
into this. Please find some other Linux maintainer who can work with 
you and who is willing to apply your patches. If you want to work on 
x86 bits please find an x86 developer or maintainer who is willing 
to apply your patches or who is willing to give you Reviewed-by tags 
before sending them to me.

Thanks,

	Ingo
