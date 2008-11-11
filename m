Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYKKK6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYKKK6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYKKK6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:58:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYKKK6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:58:12 -0500
Date: Tue, 11 Nov 2008 11:57:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Miao Xie <miaox@cn.fujitsu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: release buddies on yield
Message-ID: <20081111105743.GC15645@elte.hu>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera> <4B0Eqx89uNG.A.w2E.Ee1FJB@chimera> <1226343293.5498.5.camel@marge.simson.net> <1226366822.2866.19.camel@ymzhang> <1226394669.30025.72.camel@minggr.sh.intel.com> <1226395210.7685.1324.camel@twins> <1226395937.7685.1340.camel@twins> <1226397807.30025.79.camel@minggr.sh.intel.com> <1226400753.7685.1506.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226400753.7685.1506.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Clear buddies on yield, so that the buddy rules don't schedule them
> despite them being placed right-most.
> 
> This fixed a performance regression with yield-happy binary JVMs.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Tested-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  kernel/sched_fair.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)

applied to tip/sched/urgent, thanks guys!

	Ingo
