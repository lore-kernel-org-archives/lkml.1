Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZJFMY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZJFMY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932373AbZJFMY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:24:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59741 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbZJFMY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:24:57 -0400
Date: Tue, 6 Oct 2009 14:23:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       "jens.axboe" <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_event: Provide vmalloc() based mmap() backing
Message-ID: <20091006122359.GA7614@elte.hu>
References: <1254830228.21044.272.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254830228.21044.272.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> OK, so I rewrote it a few more times, does the below make everybody 
> feel warm and fuzzy?

Yeah, looks perfect to me - applied to tip:perf/urgent, thanks Peter!

Dave, could you please test it on Sparc too? The Git coordinates are at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/urgent

	Ingo
