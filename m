Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYG2RDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYG2RDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYG2RDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:03:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYG2RDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:03:14 -0400
Date: Tue, 29 Jul 2008 09:59:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Linux v2.6.27-rc1
In-Reply-To: <200807290927.12101.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0807290945030.3334@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807290927.12101.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Jesse Barnes wrote:
> 
> I think linux-next has been a *huge* help.  It's been great at catching merge 
> conflicts and build bugs (though not so much when you don't use it[1]!), and 
> Stephen is really easy to work with.  So I, for one, would love to see it 
> continue.

I don't think anybody wants it to go away. The question in my mind is more 
along the way of how/whether it should be changed. There was some 
bickering about patches that weren't there, and some about how _partial_ 
series were there but then the finishing touches broke things.

I don't personally really think that it's reasonable to expect everything 
to be in -next (but hey, I'm willing to be convinced otherwise). And don't 
get me wrong - it certainly wouldn't bother _me_ to have everything go 
through next, since it just makes it likelier that I have less to worry 
about.

BUT. I do think 'next' as it is has a few issues that either need to be 
fixed (unlikely - it's not the point of next) or just need to be aired as 
issues and understood:

 - I don't think it does 'quality control', and I think that's pretty 
   fundamental.

   Now, admittedly I don't look much at the patches of people I trust 
   either (that's what the whole point of that 'trust' is, after all - to 
   make me not be the part that limits development speed), but that's 
   still different from 'largely automated merging'.

   So I _do_ check the things that aren't obvious "maintainer works on his 
   own subsystem" or are so core that I really feel like I need to know 
   what's up. I seldom actually say "that's so broken that I refuse to 
   pull it", but I tend to do that a couple of times per release.

   That may not sound like much, but it's enough to make me worry about 
   'next'. I worry that 'it has been in next' has become a code-word for 
   "pull this, because it's good", and I'm not at all convinced that 
   'next' sees any real critical checking.

 - I don't think the 'next' thing works as well for the occasional 
   developer that just has a few patches pending as it works for subsystem 
   maintainers that are used to it.

   IOW, I think 'next' needs enough infrastructure setup from the 
   developer side that I don't think it's reasonable for _everything_ to 
   go through next. And that in turn means that I'm not entirely thrilled 
   when people then complain "that wasn't in next". I think people should 
   accept that not everything will be in next.

But I don't think either of the above issues is a 'problem' - I just think 
they should be acknowledged. I think 'next' is a good way for the big 
subsystem developers to be able to see problems early, but I really hope 
that nobody will _ever_ see next as a "that's the way into Linus' tree", 
because for the above two reasons I do not think it can really work that 
way.

			Linus
