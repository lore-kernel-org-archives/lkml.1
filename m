Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYGILhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYGILhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYGILhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:37:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbYGILhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:37:18 -0400
Date: Wed, 9 Jul 2008 13:37:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/17] Series to introduce WARN()... a WARN_ON() variant
	that takes printk arguments
Message-ID: <20080709113703.GA11191@elte.hu>
References: <20080708093800.274504ba@infradead.org> <20080709101348.GA30005@elte.hu> <20080709041956.0c52b2d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709041956.0c52b2d9.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > The first few patches have been in -mm for a long time; the later 
> > > ones are newer and introduce more users of WARN().
> > 
> > i've created a new -git based topic branch in tip/core/warn-API and 
> > picked up your patches:
> 
> um, why?
> 
> If you merge this into linux-next then it will trash already-merged 
> patches in -mm and, more particularly, it will trash other trees which 
> you aren't looking at, causing Stephen problems.

no, i didnt plan to push this towards linux-next - given the broad 
consensus and given the wide spread of the changes.

I wanted to wait with this until the end of the merge window and keep it 
tested and merged up nicely. I.e. zero maintenance overhead to 
subsystems.

> The way to merge this code is to get the base patches into mainline 
> and then trickle the dependent patches into subsystem trees, or direct 
> into mainline after the subsystem trees have merged, and with suitable 
> acks.
> 
> You aren't set up to do that?

i think it's better to just go through the merge window i believe, and 
then do this atomically in one correct and tested step, when all 
subsystem trees are at their minimum size and there's virtually no 
collisions.

Note that this situation is special: this is a patchset that has 
virtually no functionality side-effects, and hence can be done 100% 
correctly, i thought the atomic step was the right approach.

For anything semantically meaningful i too would do the spread-out 
gradual approach (and i'm presently doing that for a number of topics).

But if you'd like to do this the spread-out way then sure, and i will 
drop this tree. ( if you do that then please import the commits from 
tip/core/warn-API, i fixed a couple of of typos in the commit messages 
and did some merging and extensions as well. The tree also passed a fair 
amount of testing meanwhile as well. )

Anyway, your call.

	Ingo
