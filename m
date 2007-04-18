Return-Path: <linux-kernel-owner+w=401wt.eu-S2992754AbXDRPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992754AbXDRPRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992758AbXDRPRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:17:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992754AbXDRPRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:17:19 -0400
Date: Wed, 18 Apr 2007 17:17:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ankita Garg <ankita@in.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PREEMPT_RT] [PATCH] Fix BUG: using smp_processor_id() in preemptible [00000000] code: nfsd/2852
Message-ID: <20070418151707.GB8546@elte.hu>
References: <20070418132632.GC10065@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418132632.GC10065@in.ibm.com>
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


* Ankita Garg <ankita@in.ibm.com> wrote:

> While running some tests on 2.6.20-rt8 with DEBUG_PREEMPT on, I hit 
> the following BUG:

> This patch fixes the above issue which arises due to the call to 
> smp_processor_id in drain_array() from mm/slab.c. smp_processor_id() 
> invocation is redundant here, as the call to slab_spin_lock_irq() 
> already fills the value of this_cpu using raw_smp_processor_id().

thanks, applied!

	Ingo
