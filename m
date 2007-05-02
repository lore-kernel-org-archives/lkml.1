Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXEBTMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXEBTMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXEBTMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:12:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37641 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXEBTMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:12:45 -0400
Date: Wed, 2 May 2007 21:12:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ting Yang <tingy@cs.umass.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502191235.GA2455@elte.hu>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com> <20070502174829.GX19966@holomorphy.com> <20070502181533.GA19479@elte.hu> <20070502185613.GU31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502185613.GU31925@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* William Lee Irwin III <wli@holomorphy.com> wrote:

> The coincidental aspect would be that at the time it was written, the 
> formal notion of lag was not being used particularly with respect to 
> priorities and load weights. [...]

(nice levels for SCHED_OTHER are 'just' an add-on concept to the core of 
CFS, in fact i had two wildly different approaches that both did the 
trick for users, so i fail to see the relevance of priorities to the 
core concept of measuring how much a task is waiting to get on the 
runqueue via the 'fair clock' ... but lets move on.)

> Things are moving in good directions on all this as far as I'm 
> concerned. Moving according to Ting Yang's analysis should wrap up the 
> soundness concerns about intra-queue policy I've had. OTOH load 
> balancing I know much less about (not that I was ever any sort of an 
> expert on single queue affairs). [...]

the whole move to ->load_weight based calculations was to make CFS 
integrate better with load-balancing and to bring the smpnice 
infrastructure even more into the scheduler mainstream. [ There's a 
small smpnice related buglet i fixed in -v9-to-be (based on Balbir 
Singh's feedback), but otherwise it behaves quite well on SMP and that's 
not a big surprise: i left the load-balancer largely intact. ]

	Ingo
