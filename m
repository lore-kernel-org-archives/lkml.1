Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZIUJfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZIUJfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZIUJfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:35:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbZIUJfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:35:19 -0400
Date: Mon, 21 Sep 2009 11:34:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2]: mm: Make vmalloc_user() align base kernel virtual
	address to SHMLBA.
Message-ID: <20090921093458.GA14664@elte.hu>
References: <20090908.051046.141535022.davem@davemloft.net> <20090918121709.GB19165@elte.hu> <20090918105240.13d74dab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918105240.13d74dab.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 18 Sep 2009 14:17:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ( Andrew, this patch has mm/* effects - any objections? Would still like
> >   to get this into v2.6.32. )
> 
> I queued this a week ago, along with
> perf-allocate-mmap-buffer-using-vmalloc_user.patch.
> 
> If the latter gets quitably acked I can merge it, otherwise I'll spray
> it at you guys.
> 
> Merging
> mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba.patch
> via another tree will cause a teeny reject at my end, not a problem.

Please dont send this one yet, the fallout is still being discussed.

	Ingo
