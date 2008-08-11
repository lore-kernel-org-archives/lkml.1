Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYHKOV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYHKOV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYHKOVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:21:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48300 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYHKOVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:21:20 -0400
Date: Mon, 11 Aug 2008 16:20:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Message-ID: <20080811142041.GA15185@elte.hu>
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com> <200808082303.41068.rjw@sisk.pl> <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com> <20080811123020.GB10082@elte.hu> <6453C3CB8E2B3646B0D020C112613273C5AC5C@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC5C@sausexmb4.amd.com>
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


* Langsdorf, Mark <mark.langsdorf@amd.com> wrote:

> > > does it help?
> > > 
> > > (the explanation is also available in this thread).
> > 
> > i've queued up the fix below in tip/sched/urgent.
> 
> Sorry for the delay in response - we had some building power
> issues this weekend.
> 
> Yes, that fixed the issue.

thanks Mark - i've added your Tested-by line to the commit.

	Ingo
