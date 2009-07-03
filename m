Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZGCNRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZGCNRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZGCNRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:17:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54155 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZGCNRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:17:34 -0400
Date: Fri, 3 Jul 2009 15:17:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703131727.GA3207@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk> <20090703064518.GA30674@elte.hu> <20090703100834.6cb241b6@lxorguk.ukuu.org.uk> <20090703091655.GB3902@elte.hu> <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk> <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk> <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703114431.37abd528@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Which is a cut and paste of code from the originals into the 
> > > helper.
> > 
> > and this changes my points how? It's not like it's hard to fix, 
> > and the code is moved non-trivially anyway, it's better to have 
> > it nicer if we touch it anyway.
> 
> Its called engineering and good practice. The old code was 
> correct. The paste of it is therefore most likely to be correct. 
> Furthermore patches shouldn't mix clean up with other changes. So 
> doing it as one is most definitely bad practice.

So you cannot do such trivial cleanups safely and validate the 
result?

> > > > Also note the inconsistent printk-ing lines, mutiliated by 
> > > > line warps. The use of pr_warning() would solve it:
> > > 
> > > Send patches if it bugs you that much. [...]
> > 
> > I find that a rather flippant attitude to kernel code quality 
> > issues.
> 
> I have better uses for my time than fiddling with pr_warning(). 
> Fixing real bugs for example, bugs that crash your system, broken 
> locking that goes back to Linux 2.2 and DaveM's original push of 
> lock_kernel out of IRQ paths

That does not make you exempt from the rules everyone else seems to 
be able to follow though ...

> > Also, isnt it a double standard: why should newbies be held to 
> > higher standards than you hold yourself to?
> 
> Why should anyone be held up to bogus standards ?

I came across this patch of yours on lkml and noticed a few problems 
- checkpatch noticed a few more. Is the reviewing of patches and the 
commenting on unclean patches a 'bogus standard'? Do we have some 
separate standard just for you?

> To bend an appropriate metaphor Ingo - you are trying to criticize 
> the paint finish of the bike shed while some of us are still 
> replacing the rusted and corroded beams.
> [...]

That metaphor is quite inapposite: type safety and clean coding 
standards are way more relevant than just 'paint finish'.

To use a car analogy: if you ever open an engine, regardless of how 
corroded it is on the outside, the first thing you will learn is to 
work extremely cleanly - otherwise the pistons might get stuck and 
the engine blows pretty quickly - or even if you are lucky you've 
got a lot more wear and more fuel consumption.

Or to advance your bike-shed metaphor some more: today's rusty and 
corroded items are the result of missing anti-corrosion efforts in 
the past ...

> If it was a new bike shed you might be in order, but at the moment 
> the tty layer is rescue archaeology and I'm spending my time doing 
> useful things like fixing the real bugs and getting from where we 
> are now to somewhere useful without causing too much carnage on 
> the way. pr_warning is an end of the journey polishing job.
> 
> The x86 experience doesn't translate here - Andi left you a well 
> maintained, well polished starting point. Nobody has been 
> maintaining tty for years.

Well, you might not have that experience because you did not take 
part in it, but in my first hand experience the x86 situation and 
unification translates pretty well to this situation: it was left in 
quite a mess and one of the things we learned along the way is that 
'temporary crap' is all but temporary and that the sanest 
engineering choice is to just produce clean patches.

You might discover that yourself with the TTY layer ... or you might 
come to a different conclusion. We'll see.

Anyway ... all i did was to comment on a somewhat deficient patch 
that you submitted to lkml. If you dont want review feedback and if 
you feel embarrased and defensive by getting it then please dont 
send out slightly-messy signed-off patches to lkml, it's simple as 
that.

	Ingo
