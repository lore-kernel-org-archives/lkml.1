Return-Path: <linux-kernel-owner+w=401wt.eu-S932720AbZE3Rrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbZE3Rrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 13:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbZE3RrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 13:47:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38993 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbZE3RrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 13:47:23 -0400
Date: Sat, 30 May 2009 19:46:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Larry H." <research@subreption.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530174644.GC20013@elte.hu>
References: <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com> <4A20E6CF.8070003@cs.helsinki.fi> <20090530090513.GO29711@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530090513.GO29711@oblivion.subreption.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Larry H. <research@subreption.com> wrote:

> On 10:57 Sat 30 May     , Pekka Enberg wrote:
> > Larry H. wrote:
> >> Furthermore, selective clearing doesn't solve the roots of the problem.
> >> It's just adding bandages to a wound which never stops bleeding. I
> >> proposed an initial page flag because we could use it later for
> >> unconditional page clearing doing a one line change in a header file.
> >> I see a lot of speculation on what works and what doesn't, but
> >> there isn't much on the practical side of things, yet. I provided test
> >> results that proved some of the comments wrong, and I've referenced
> >> literature which shows the reasoning behind all this. What else can I do
> >> to make you understand you are missing the point here?
> >
> > Hey, if you want to add a CONFIG_ZERO_ALL_MEMORY_PARANOIA thing that can be 
> > disabled, go for it! But you have to find someone else to take the merge 
> > the SLAB bits because, quite frankly, I am not convinced it's worth it. And 
> > the hand waving you're doing here isn't really helping your case, sorry.
> 
> For a second I thought it was Ingo who was writing this e-mail. 
> Apologies about the confusion.

btw., i find this is rather hillarious: you thought it was me 
writing the reply and you answered Pekka's arguments with contempt 
and hand-waving.

Now that you realized that it's the SLAB maintainer you replied to, 
whom you cannot just hand-wave away, you apologize not for the 
bogosity of your argument and not for the concept - but you 
apologize for _thinking it was the wrong person_.

That is a rather dishonest style of discussion.

	Ingo
