Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYKGJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYKGJbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYKGJa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:30:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYKGJa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:30:58 -0500
Date: Fri, 7 Nov 2008 10:30:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rewrite SCHED_CPUMASK_ALLOC
Message-ID: <20081107093050.GC7787@elte.hu>
References: <4911341C.7020207@cn.fujitsu.com> <20081106080057.GF8459@elte.hu> <4913EB8C.8010003@cn.fujitsu.com> <20081107081627.GC4435@elte.hu> <49140456.8020400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49140456.8020400@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

>  Sorry, you are right - keep the SCHED_CPUMASK_DECLARE() macro please. 
> > 
> > But the other macros can become an inline function just fine, correct?
> > 
> 
> Yes, but sched_cpumask_alloc() should be declared this way:
> 	void sched_cpumask_alloc(struct **allmasks)
> but not:
> 	struct *allmasks sched_cpumask_alloc(void)
> 
> Because the latter is not workable for <128 CPUs case.
> 
> (patch is based on [PATCH] sched: fix memory leak in a failing path)

applied to tip/sched/core, thanks!

	Ingo
