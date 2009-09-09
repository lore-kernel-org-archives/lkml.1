Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZIIGAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZIIGAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 02:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZIIGAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 02:00:05 -0400
Received: from lo.gmane.org ([80.91.229.12]:51958 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZIIGAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 02:00:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Tornqvist <mjt@nysv.org>
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks =?utf-8?b?YW5kCW1lYXN1cmVtZW50cw==?=
Date: Wed, 9 Sep 2009 05:54:17 +0000 (UTC)
Message-ID: <loom.20090909T072632-553@post.gmane.org>
References: <20090906205952.GA6516@elte.hu> <200909070405.23936.elendil@planet.nl> <20090907121613.GA32097@elte.hu> <20090907131905.GP28624@nysv.org> <20090907135926.GA24507@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 88.112.189.238 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's test gmane's followup feature ;)

Ingo Molnar <mingo <at> elte.hu> writes:

> > Please Cc me as I'm not a subscriber.
> > >  kernel build performance on quad:
> > >     http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild-quad.jpg
> > [...]
> > >
> > >It shows similar curves and behavior to the 8-core results i posted 
> > >- BFS is slower than mainline in virtually every measurement. The 
> > >ratios are different for different parts of the graphs - but the 
> > >trend is similar.
> > 
> > Dude, not cool.
> > 
> > 1. Quad HT is not the same as a 4-core desktop, you're doing it with 8 cores
> 
> No, it's 4 cores. HyperThreading adds two 'siblings' per core, which 
> are not 'cores'.

Like Serge Belyshev says in
http://article.gmane.org/gmane.linux.kernel/886881
and Con thanks you inthe FAQ for confiming it:
"h/w threads" - My Sempron II X4 lists four of those, and it seems
to be a common setup.
 
> > 2. You just proved BFS is better on the job_count == core_count case, as BFS
> >    says it is, if you look at the graph
> 
> I pointed that out too. I think the graphs speak for themselves:
> 
>      http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild-quad.jpg
>      http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild.jpg

Those are in alignment with the FAQ, for the hardware threads.

Mr Belyshev's benchmarks are closer to a common desktop and they rock
over CFS.

That's also something that IMO "we" forgot here: it doesn't really matter!

BFS is not up for merging, it feels way better than CFS on the desktop
and it does not scale.

This thread can be about improving CFS, I do not care personally, and
will stay out of that discussion.

> There's bfs-209 out there today. These tests take 8+ hours to 
> complete and validate. I'll re-test BFS in the future too, and as i 
> said it in the first mail i'll test it on a .31 base as well once 
> BFS has been ported to it:

Apropos your tests, under which circumstances would I have a million
piped messages on my desktop?

Would you care to comment on the relevance of your other tests from
a desktop point of view?

Fortunately you got help from the community as posted on the list.

> > Also, you said on http://article.gmane.org/gmane.linux.kernel/886319
> > "I also tried to configure the kernel in a BFS friendly way, i used 
> > HZ=1000 as recommended, turned off all debug options, etc. The 
> > kernel config i used can be found here:
> > http://redhat.com/~mingo/misc/config
> > "
> > 
> > Quickly looking at the conf you have
> > CONFIG_HZ_250=y
> > CONFIG_PREEMPT_NONE=y
> > # CONFIG_PREEMPT_VOLUNTARY is not set
> > # CONFIG_PREEMPT is not set
> 
> Indeed. HZ does not seem to matter according to what i see in my 
> measurements. Can you measure such sensitivity?

Hardly the point - You said one thing and got caught with something else,
which doesn't give a credible image.

Can I measure it? IANAKH, and I think there are people more passionate
here to run benchmark scripts and endless analyses.

All I can "measure" is that my desktop experience isn't stuttery and jittery
with basic stuff like scrolling over Firefox tabs with my mouse wheel
while watching pr0n.
 
> > CONFIG_ARCH_WANT_FRAME_POINTERS=y
> > CONFIG_FRAME_POINTER=y
> > 
> > And other DEBUG.
> 
> These are the defaults and they dont make a measurable difference to 
> these results. What other debug options do you mean and do they make 
> a difference?

Don't care as long as your kernel comparisons truly were with equivalent
settings to each other.

Köszönöm.

-- 
mjt


