Return-Path: <linux-kernel-owner+w=401wt.eu-S1767068AbXEBSPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767068AbXEBSPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767112AbXEBSPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:15:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767068AbXEBSPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:15:39 -0400
Date: Wed, 2 May 2007 20:15:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ting Yang <tingy@cs.umass.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502181533.GA19479@elte.hu>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com> <20070502174829.GX19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502174829.GX19966@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> > There is also p->wait_runtime which is taken into account when 
> > calculating p->fair_key. So if p3 had waiting in runqueue for long 
> > before, it can get to run quicker than 10ms later.
> 
> Virtual time is time from the task's point of view, which it has spent 
> executing. ->wait_runtime is a device to subtract out time spent on 
> the runqueue but not running from what would otherwise be virtual time 
> to express lag, whether deliberately or coincidentally. [...]

CFS is in fact _built around_ the ->wait_runtime metric (which, as its 
name suggests already, expresses the precise lag a task observes 
relative to 'ideal' fair execution), so what exactly makes you suspect 
that this property of the ->wait_runtime metric might be 'coincidental'? 
;-)

	Ingo
