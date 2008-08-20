Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYHTNrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYHTNrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYHTNrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:47:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34907 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYHTNre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:47:34 -0400
Date: Wed, 20 Aug 2008 15:47:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Message-ID: <20080820134708.GA20648@elte.hu>
References: <1912217169.25608.228.camel@ymzhang> <1218180605.8625.64.camel@twins> <20080811185008.GA29291@linux.vnet.ibm.com> <1912726331.25608.235.camel@ymzhang> <20080817115035.GA32223@linux.vnet.ibm.com> <20080818052155.GA5063@linux.vnet.ibm.com> <1219217089.8781.27.camel@ymzhang> <1219218089.10800.404.camel@twins> <20080820105141.GA18226@elte.hu> <1219239137.8651.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219239137.8651.52.camel@twins>
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

> Just realized my brainfart..
> 
> ---
> Subject: sched: load-balance bias fixes
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Aug 20 15:28:51 CEST 2008
> 
> Yanmin spotted a regression with my patch that introduces LB_BIAS:

ok, i've applied this one to tip/sched/urgent instead of the 
feature-disabling patchlet. Yanmin, could you please check whether this 
one does the trick?

	Ingo
