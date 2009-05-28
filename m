Return-Path: <linux-kernel-owner+w=401wt.eu-S1762051AbZE1JJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbZE1JJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbZE1JJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:09:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbZE1JJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:09:25 -0400
Date: Thu, 28 May 2009 11:08:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090528090836.GB6715@elte.hu>
References: <20090520183045.GB10547@oblivion.subreption.com> <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528072702.796622b6@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > As for being swapped out - I do not believe that kernel stacks can 
> > > ever be swapped out in Linux.
> > 
> > yes, i referred to that as an undesirable option - because it slows 
> > down pthread_create() quite substantially.
> > 
> > This needs before/after pthread_create() benchmark results.
> 
> kernel stacks can end up places you don't expect on hypervisor 
> based systems.
> 
> In most respects the benchmarks are pretty irrelevant - wiping 
> stuff has a performance cost, but its the sort of thing you only 
> want to do when you have a security requirement that needs it. At 
> that point the performance is secondary.

Bechmarks, of course, are not irrelevant _at all_.

So i'm asking for this "clear kernel stacks on freeing" aspect to be 
benchmarked thoroughly, as i expect it to have a negative impact - 
otherwise i'm NAK-ing this. Please Cc: me to measurements results.

Thanks,

	Ingo
