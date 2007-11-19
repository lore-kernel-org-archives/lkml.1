Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbXKSTB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbXKSTB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbXKSTBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:01:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbXKSTBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:01:19 -0500
Date: Mon, 19 Nov 2007 20:00:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 2/2] sched: Improve fairness of cpu allocation for task
	groups
Message-ID: <20071119190057.GA12650@elte.hu>
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119160647.GV3359@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> > ok, as long as it's NOP for the CONFIG_FAIR_GROUP_SCHED, we could 
> > try it.
> 
> Ok ..thx. I was begining to make changes to avoid even the above minor 
> changes for !CONFIG_FAIR_GROUP_SCHED case, but it doesn't look neat, 
> hence will drop that effort.

well please try it nevertheless, if the changes are not a NOP for the 
!FAIR_GROUP_SCHED case it's harder to determine that they are indeed 
harmless for the !FAIR_GROUP_SCHED case.

	Ingo
