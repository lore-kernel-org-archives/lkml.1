Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbXFKS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbXFKS6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXFKS6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:58:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbXFKS6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:58:22 -0400
Date: Mon, 11 Jun 2007 20:56:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de,
       kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com
Subject: Re: [RFC][PATCH 1/6] Introduce struct sched_entity and struct lrq
Message-ID: <20070611185658.GA19095@elte.hu>
References: <20070611154724.GA32435@in.ibm.com> <20070611155046.GA2109@in.ibm.com> <alpine.LFD.0.98.0706111146220.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706111146220.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 11 Jun 2007, Srivatsa Vaddagiri wrote:
> > 
> > struct sched_entity
> >         stores essential attributes/execution-history used by CFS core
> >         to drive fairness between 'schedulable entities' (tasks, users etc)
> 
> Wouldn't this be sensible to integrate into CFS _regardless_ of 
> anything else?

yeah, that's what i asked Srivatsa to do, and his currently patchset 
largely achieves that. I'm looking now into applying the core bits and 
checking that it's in essence a NOP when this isnt used. (that makes the 
later merging of group fairness and container scheduling a lot less 
contentious)

	Ingo
