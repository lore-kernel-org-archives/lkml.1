Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZCFKtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZCFKtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZCFKti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:49:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49604 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZCFKti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:49:38 -0500
Date: Fri, 6 Mar 2009 11:49:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip] sched: use need_resched
Message-ID: <20090306104925.GA21168@elte.hu>
References: <49B0F9C2.8060200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B0F9C2.8060200@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> Impact: cleanup
> 
> use need_resched() instead of unlikely(test_thread_flag(TIF_NEED_RESCHED))
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

looks good - but it does not apply cleanly to the latest 
scheduler tree:

   http://people.redhat.com/mingo/tip.git/README

Could you please send a merged up patch and also make sure 
there's no other TIF_NEED_RESCHED usage in kernel/sched.c that 
could be converted to need_resched()?

Thanks,

	Ingo
