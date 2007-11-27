Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbXK0LJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbXK0LJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 06:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXK0LJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 06:09:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33831 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbXK0LJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 06:09:46 -0500
Date: Tue, 27 Nov 2007 12:09:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: [Patch 0/5] sched: group scheduler related patches (V4)
Message-ID: <20071127110910.GB16273@elte.hu>
References: <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com> <20071126202836.GA17012@elte.hu> <20071127050652.GA20083@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127050652.GA20083@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Mon, Nov 26, 2007 at 09:28:36PM +0100, Ingo Molnar wrote:
> > the first SCHED_RR priority is 1, not 0 - so this call will always fail.
> 
> Thanks for spotting this bug and rest of your review comments.
> 
> Here's V4 of the patchset, aimed at improving fairness of cpu 
> bandwidth allocation for task groups.

thanks, it looks good - but the fact that we are at v4 of the patchset 
underlines the point that this is more of a v2.6.25 patchset than a 
v2.6.24 one. Group fairness certainly works fine enough in most setups 
and we are late into the v2.6.24 -rc stage. We'll merge this patchset 
(or any later versions of it) into v2.6.25 for sure, so distros that 
happen to base things off v2.6.24 can pick up your patches just fine.

	Ingo
