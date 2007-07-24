Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbXGXLW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbXGXLW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbXGXLWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:22:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44360 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbXGXLWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:22:18 -0400
Date: Tue, 24 Jul 2007 13:22:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
Message-ID: <20070724112200.GA4912@elte.hu>
References: <20070724083855.GA858@elte.hu> <20070724015441.8604d85d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724015441.8604d85d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> What a truly putrid patch.  I am suspecting that this was a quick 
> get-you-out-of-trouble thing, which then got forgotten about.
> 
> We have two months to do the "right fix".  Please?

sure. Just wanted to bring attention to this issue - the regression got 
introduced in v2.6.15. I'd be happy to test-drive Ben's patch in -rt.

	Ingo
