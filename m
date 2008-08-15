Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYHOPhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYHOPhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYHOPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:37:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39177 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbYHOPh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:37:26 -0400
Date: Fri, 15 Aug 2008 17:37:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Message-ID: <20080815153704.GB27955@elte.hu>
References: <1217489463.25608.157.camel@ymzhang> <1217489949.8157.78.camel@twins> <1217490560.25608.168.camel@ymzhang> <1217551154.25608.169.camel@ymzhang> <20080801051407.GA5232@linux.vnet.ibm.com> <1217826278.25608.198.camel@ymzhang> <20080804052228.GA5444@linux.vnet.ibm.com> <1217828278.25608.206.camel@ymzhang> <20080804055339.GB5444@linux.vnet.ibm.com> <1217832866.9016.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217832866.9016.45.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2008-08-04 at 11:23 +0530, Dhaval Giani wrote:
> 
> > Peter, vatsa, any ideas?
> 
> ---
> Subject: sched: scale sysctl_sched_shares_ratelimit with nr_cpus
> 
> David reported that his Niagra spend a little too much time in
> tg_shares_up(), which considering he has a large cpu count makes sense.
> 
> So scale the ratelimit value with the number of cpus like we do for
> other controls as well.

i've queued this up in tip/sched/urgent as it makes sense - but i'm also 
wondering, does this impact the volano numbers?

	Ingo
