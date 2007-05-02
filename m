Return-Path: <linux-kernel-owner+w=401wt.eu-S2993002AbXEBK1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993002AbXEBK1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993003AbXEBK1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:27:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993002AbXEBK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:27:18 -0400
Date: Wed, 2 May 2007 12:27:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ting Yang <tingy@cs.umass.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502102712.GA8893@elte.hu>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637FE0A.7090405@cs.umass.edu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ting Yang <tingy@cs.umass.edu> wrote:

>  My name is Ting Yang, a graduate student from UMASS. I am currently 
> studying the linux scheduler and virtual memory manager to solve some 
> page swapping problems. I am very excited with the new scheduler CFS. 
> After I read through your code, I think that you might be interested 
> in reading this paper:

thanks for your detailed analysis - it was very interesting!

>  Based on my understanding, adopting something like EEVDF in CFS 
> should not be very difficult given their similarities, although I do 
> not have any idea on how this impacts the load balancing for SMP. Does 
> this worth a try?

It would definitely be interesting to try! I dont think it should 
negatively impact load balancing on SMP. The current fork-time behavior 
of CFS is really just a first-approximation thing, and what you propose 
seems to make more sense to me too because it preserves the fluidity of 
fairness. (I'd probably apply your patch even if there was no directly 
measurable impact on workloads, because the more natural approaches tend 
to be more maintainable in the long run.)

So by all means, please feel free to do a patch for this.

>  Sorry for such a long email :-)

it made alot of sense and was very useful :-)

	Ingo
