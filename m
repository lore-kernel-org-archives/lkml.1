Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZE2Hhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZE2Hhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZE2Hhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:37:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51484 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZE2Hhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:37:45 -0400
Date: Fri, 29 May 2009 09:37:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Remove masking and unmasking of
	LVT error register.
Message-ID: <20090529073739.GA24543@elte.hu>
References: <20090528071655.GA21039@ywang-moblin2.bj.intel.com> <20090528083340.GA7530@elte.hu> <20090529053701.GB13657@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529053701.GB13657@ywang-moblin2.bj.intel.com>
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Thu, May 28, 2009 at 10:33:40AM +0200, Ingo Molnar wrote:
> > i'd suggest to remove the 'nmi' parameter as well to this function. 
> 
> Thanks for the comment. Just resubmitted a new patch removing the 
> 'nmi' parameter.

applied, thanks!

> > (and any other dynamic flags that deal with nmi/irq 
> > distinctions)
> 
> Just wanna make sure before moving on. You want to remove things 
> like the 'nmi' field in perf_counter_hw_event and hw_perf_counter 
> structs and the 'nmi' parameter of perf_counter_overflow and 
> perf_swcounter_event functions, etc. Right?

yes, that too.

	Ingo
