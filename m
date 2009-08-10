Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbZHJS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbZHJS5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZHJS5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:57:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbZHJS5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:57:44 -0400
Date: Mon, 10 Aug 2009 20:56:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>, Li Ming Chun <macli@brc.ubc.ca>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 0/6] Add some trace events for the page allocator v6
Message-ID: <20090810185633.GA1130@elte.hu>
References: <1249918915-16061-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249918915-16061-1-git-send-email-mel@csn.ul.ie>
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> This is V6 of a patchset to add some tracepoints of interest when analysing
> the page allocator. The only changes since the last revision were to fix a
> minor error in the post-processing script and to add a reviewed-by to one
> of the patches.
> 
> Can we get a yey/nay on whether these should be merged or not?

It's up to Andrew - from an instrumentation POV it all looks fine to 
me:

   Reviewed-by: Ingo Molnar <mingo@elte.hu>

With the highlight of the patchset being the very low cross section 
it has to regular MM code/hacking:

>  mm/page_alloc.c                                    |   13 +-

	Ingo
