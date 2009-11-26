Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbZKZJLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbZKZJLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760066AbZKZJLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:11:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36977 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760058AbZKZJK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:10:58 -0500
Date: Thu, 26 Nov 2009 10:10:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091126091052.GF1389@elte.hu>
References: <20091124200127.GA5751@redhat.com>
 <20091125214818.GA4916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125214818.GA4916@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> [...]  Given that's it's pretty much too later for the 2.6.33 cycle 
> anyway I'd suggest you make sure the remaining two major architectures 
> (arm and mips) get converted, and if the remaining minor architectures 
> don't manage to get their homework done they're left without ptrace.

I suspect the opinion of the ptrace maintainers matters heavily whether 
it's appropriate for v2.6.33. You are not going to maintain this, they 
are.

Regarding porting it to even more architectures - that's pretty much the 
worst idea possible. It increases maintenance and testing overhead by 
exploding the test matrix, while giving little to end result. Plus the 
worst effect of it is that it becomes even more intrusive and even 
harder (and riskier) to merge.

So dont do that.

The best strategy is to concentrate on just one or two well-tested 
architectures, and then grow to other architectures gradually. Like 
we've done it for basically all big kernel features in the past 10 years 
(that had non-trivial arch dependencies), with no exception that i can 
remember.

Thanks,

	Ingo
