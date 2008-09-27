Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYI0QR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYI0QR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYI0QRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:17:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYI0QRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:17:19 -0400
Date: Sat, 27 Sep 2008 18:17:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/4] futex: get_user_pages_fast() for shared futexes
Message-ID: <20080927161712.GA1525@elte.hu>
References: <20080926173219.885155151@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926173219.885155151@twins.programming.kicks-ass.net>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Since get_user_pages_fast() made it in, I thought to give this another 
> try. Lightly tested by disabling the private futexes and running some 
> java proglets.

hm, very interesting. Since this is an important futex usecase i started 
testing it in tip/core/futexes:

 cd33272: futex: cleanup fshared
 a135356: futex: use fast_gup()
 39ce77b: futex: reduce mmap_sem usage
 0d7a336: futex: rely on get_user_pages() for shared futexes

Nick, it would be nice to get an Acked-by/Reviewed-by from you, before 
we think about whether it should go upstream.

	Ingo
