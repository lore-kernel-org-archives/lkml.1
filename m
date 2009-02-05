Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbZBEANF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbZBEANF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZBEAMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:12:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbZBEAMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:12:53 -0500
Date: Thu, 5 Feb 2009 01:12:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090205001242.GC15680@elte.hu>
References: <20090130230936.GA7549@elte.hu> <1233421901.4787.27.camel@laptop> <1233422632.4787.31.camel@laptop> <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com> <1233568333.4787.110.camel@laptop> <f19298770902041428m6a23846fud8cfba8bb3deab4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770902041428m6a23846fud8cfba8bb3deab4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> On Mon, Feb 2, 2009 at 12:52, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Sat, 2009-01-31 at 20:49 +0300, Alexey Zaytsev wrote:
> >> And answering an earlier question, this happens only on i386 and only
> >> with 4K stacks because x86_64 dosn't have a separate softirq stack,
> >> so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.
> >
> > Which suggests that an initial preempt_count offset of 1 should suffice
> > to fix this issue and not confuse the softirq tracing, hmm?
> 
> Can't we just copy the preempt count when switching stacks?

that always has a dynamic cost and the thing is that after-switch we are 
fine with a constant count.

	Ingo
