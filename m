Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbXECPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbXECPyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162140AbXECPyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:54:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbXECPyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:54:22 -0400
Date: Thu, 3 May 2007 17:54:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
Message-ID: <20070503155407.GA7536@elte.hu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> - If replying, please be sure to cc the appropriate individuals.  
>   Please also consider rewriting the Subject: to something 
>   appropriate.

i'm wondering about swap-prefetch:

  mm-implement-swap-prefetching.patch
  swap-prefetch-avoid-repeating-entry.patch
  add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch

The swap-prefetch feature is relatively compact:

   10 files changed, 745 insertions(+), 1 deletion(-)

it is contained mostly to itself:

   mm/swap_prefetch.c            |  581 ++++++++++++++++++++++++++++++++

i've reviewed it once again and in the !CONFIG_SWAP_PREFETCH case it's a 
clear NOP, while in the CONFIG_SWAP_PREFETCH=y case all the feedback 
i've seen so far was positive. Time to have this upstream and time for a 
desktop-oriented distro to pick it up.

I think this has been held back way too long. It's .config selectable 
and it is as ready for integration as it ever is going to be. So it's a 
win/win scenario.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
