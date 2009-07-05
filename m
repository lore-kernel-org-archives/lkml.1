Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZGEWTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZGEWTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 18:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZGEWTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 18:19:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:56296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbZGEWTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 18:19:23 -0400
Subject: Re: [GIT PULL -tip][PATCH 0/9] MTRR fix trivial style patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090705182151.GA7668@elte.hu>
References: <20090703102234.GA32128@elte.hu>
	 <20090703114431.37abd528@lxorguk.ukuu.org.uk>
	 <20090703131727.GA3207@elte.hu>
	 <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	 <20090703144754.GA13246@elte.hu>
	 <20090703160230.093e422c@lxorguk.ukuu.org.uk>
	 <20090703155809.GA20121@elte.hu>
	 <20090703172651.619162fd@lxorguk.ukuu.org.uk>
	 <20090703164225.GA21447@elte.hu> <1246673939.2642.5.camel@ht.satnam>
	 <20090705182151.GA7668@elte.hu>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 03:39:52 +0530
Message-Id: <1246831792.2398.37.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-05 at 20:21 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 

>  - You managed to put _3_ separate bugs into these 'trivial'
>    cleanups. That is not acceptable. If you cannot make trivial
>    patches be truly trivial, you should not be doing them really. 
> 

Where is the list of _3_ bugs. If there was bugs you should report to
me. If there are bugs show to me, why are you hiding the details.

So it is your mistake.

>  - i had to remove/undo/fix some bogus 'fixes' you did in those
>    patches where you just blindly followed checkpatch instead of
>    thinking about it for a minute. We dont want checkpatch warriors 
>    - we want people with taste who use it as a tool to keep their
>    new patches tidy, or who use it as a tool to aid cleanups.
> 

If there was bogus 'fixes', then you should ignore that patch. Or let me
know I will fix that.

So it is your mistake.

>  - i had to complete the patches and do all the cleanups you missed
>    - sometimes on the next time to a change you did. You apparently 
>    only checked checkpatch output - you didnt even look at all the 
>    files for how it all looks like and whether there are other 
>    things in those files that checkpatch missed. You made the files
>    'checkpatch clean' - but you didnt actually look at whether the 
>    files got cleaned up for good really. You left a half-done 
>    jumbled mess behind you with files that still had inconsistent 
>    looking style in them. Check the deltas of the patches i
>    committed versus the ones you sent to see the countless cases you
>    missed. And you cannot even claim to have done the 'trivial' 
>    ones safely - because you did it in a buggy way and because the 
>    final cleanups i did are all trivial too and can be validated.
> 

If you want more cleanup, you should do in separate patch, why you keep
on changing my patch.

This is a never ending task I can do further clean-ups on your patches
also.

So again it is your mistake.

>  - i had to double check each commit on the assembly level to prove 
>    that the patches are true cleanups. The new commit logs, size 
>    checks, md5 sums are proof of that due diligence process. You 
>    obviously didnt do any of that - you'd have noticed the bugs you 
>    have put in had you done that.
> 

Why you did this, you never told me to do so.

So again it is your mistake.

>  - i had to edit _all_ your changelogs. Again. You _still_ dont 
>    think about your changelogs, they still suck 90% of the time.
> 

Again this is never ending task, even Linus and Andrew can further
change changelog made by you, it is a personnel flavor.


> All things considered it took me 6 hours to fix up and complete your 
> 'trivial' patches into which you have put only 3 hours of work:
> 
>  - your buggy and incomplete cleanups did:
> 
>       9 files changed, 263 insertions(+), 329 deletions(-)
> 
>  - the proper, fixed, rounded up, checked, validated and working 
>    cleanups i committed with 6 extra hours of work:
> 
>       9 files changed, 868 insertions(+), 862 deletions(-)
> 
> The MTRR code is a highly critical piece of x86 code and i had to 
> check assembly dumps manually and compared them to make sure the 
> changes dont introduce subtle regressions.
> 


If you want to do it, you should do in separate patches.

It is again your mistake.

> The fact is, there is no other way to establish the trust level of 
> trivial cleanups but to invest this depth of review and this level 
> of testing and checking. I cannot just review until i find the first 
> bug or problem and bounce it back to you as a review failure - i 
> cannot know whether i can trust your next version of the patch and i 
> cannot check the same trivial cleanups again and again as a machine, 
> until you manage to submit the correct one.
> 
> So i've tested the trustworthyness of your changes for a final time 
> and you failed this test.
> 

You never told me to test in this manner.

> I still committed it all under your name because i kept a fair 
> amount of your changes so it's all v2 versions of your original 
> patches - and per kernel convention i noted it in the changelog that 
> i modified it further (and i didnt want to create 9 more commits, 
> especially as some of your patches were broken so not bisection 
> safe) - but this was the last time i went through such an effort 
> with your patches.
> 

Why you committed under my name, I do not need your such help if you
again shout at me.

If there was issue then you should ignore my patches and start from
scratch.

This is again your mistake.

> As i warned you _repeatedly_ in the past that you should insert a 
> lot more effort into patches before sending any patches and before 
> sending any pull request. Other x86 maintainers warned you about 
> that too. You seem to prefer five patches a day (a few of which are 
> inevitably broken) instead of one good patch every five days.
>
> This low level of patch quality just does not scale for maintainers 
> of a busy tree which has more than a hundred contributors in every 
> cycle. If i cannot trust a contributor i cannot apply such patches 
> directly.
>
> All in one, you were making the same kinds of mistakes again and 
> again, over a many month time-span, and you are causing a 
> considerable amount of maintainer overhead that is just not 
> sustainable really.
> 

If I can spend 10-16 hours in a day and no one is paying to me, I am
spending from my pocket. And I send 5 patches in a day.

For you it will not take more than 5-10 minutes to review my 5 patches.

This is your job, and your are getting salary for it.

You should be thankful to me instead of blaming me.

So again it is your fault.

> So this simply does not work in this form. I can work with pretty 
> much anyone, but there's a final limit to the energy i can invest 
> into this. Please find some other Linux maintainer who can work with 
> you and who is willing to apply your patches. If you want to work on 
> x86 bits please find an x86 developer or maintainer who is willing 
> to apply your patches or who is willing to give you Reviewed-by tags 
> before sending them to me.
> 

So you are blaming me for your faults.

I am contributing to open-source from my pocket, because I thought that
open-source people are open-heart (big heart), but now it seems I was
wrong. You are having very little heart and very low tolerance.

Thanks,
--
JSR

