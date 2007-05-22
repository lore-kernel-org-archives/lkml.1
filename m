Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbXEVLOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbXEVLOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXEVLN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:13:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbXEVLN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:13:56 -0400
Date: Tue, 22 May 2007 13:12:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-ID: <20070522111230.GA15616@elte.hu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705222054.46488.kernel@kolivas.org> <20070522105710.GA12833@elte.hu> <200705222104.20580.kernel@kolivas.org> <20070522111104.GA14950@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522111104.GA14950@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:
 
> > hm, what do you call 'journal writeout' here that would be happening 
> > on my system?
> 
> Not really sure what you have in terms of fs, but here even with 
> nothing going on, ext3 writes to disk every 5 seconds with kjournald.

i have ext3, but it doesnt do that on my box. Also, i would have noticed 
any IO activity in the 'swap prefetch off' case. When i said completely 
idle, i really meant it ;-)

so swap-prefetch stops for 5 seconds for no apparent reason.
 
	Ingo
