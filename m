Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbXFKTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbXFKTks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbXFKTk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:40:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbXFKTkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:40:25 -0400
Date: Mon, 11 Jun 2007 21:39:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de, kernel@kolivas.org,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com,
       Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 0/6] Add group fairness to CFS - v1
Message-ID: <20070611193931.GA26489@elte.hu>
References: <20070611154724.GA32435@in.ibm.com> <20070611193735.GA22152@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611193735.GA22152@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Patch 4 fixes some bad interaction between SCHED_RT and SCHED_NORMAL 
> > tasks in current CFS.
> 
> btw., the plan here is to turn off 'bit 0' in sched_features: i.e. to 
> use the precise statistics to calculate lrq->cpu_load[], not the 
> timer-irq-sampled imprecise statistics. [...]

i mean bit 6, value 64. I flipped around its meaning in -v17-rc4, so the 
new precise stats code there is now default-enabled - making SMP 
load-balancing more accurate.

	Ingo
