Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZI3U62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZI3U62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZI3U62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:58:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48153 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZI3U61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:58:27 -0400
Date: Wed, 30 Sep 2009 22:58:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, johnstul@us.ibm.com,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, arjan@infradead.org,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] x86: Provide an alternative() based
	cmpxchg64()
Message-ID: <20090930205808.GC24862@elte.hu>
References: <20090930170754.0886ff2e@infradead.org> <tip-e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c@git.kernel.org>
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


* tip-bot for Arjan van de Ven <arjan@infradead.org> wrote:

> Commit-ID:  e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c
> Gitweb:     http://git.kernel.org/tip/e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c
> Author:     Arjan van de Ven <arjan@infradead.org>
> AuthorDate: Wed, 30 Sep 2009 17:07:54 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 30 Sep 2009 22:35:44 +0200
> 
> x86: Provide an alternative() based cmpxchg64()
> 
> cmpxchg64() today generates, to quote Linus, "barf bag" code.
> 
> cmpxchg64() is about to get used in the scheduler to a bug there,
> but it's a prerequisite that cmpxchg64() first be made non-sucking.
> 
> This patch turns cmpxchg64() into an efficient implementation that
> uses the alternative() mechanism to just use the raw instruction on
> all modern systens

The changelog above has 3 typos so i fixed that. The push will generate 
the hopefully-final version of these patches.

Note, i slightly updated Linus's version of the old-CPU emu code with 
Eric's micro-optimization.

	Ingo
