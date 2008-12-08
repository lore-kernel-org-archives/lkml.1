Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYLHPt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYLHPt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYLHPts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:49:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYLHPtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:49:47 -0500
Date: Mon, 8 Dec 2008 16:49:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] idle_balance() does not call load_balance_newidle()
Message-ID: <20081208154939.GA405@elte.hu>
References: <20081208152249.GI5457@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208152249.GI5457@dirshya.in.ibm.com>
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> Hi,
> 
> load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE is
> set at higher level domain (3-CPU) and not in low level domain (2-MC).
> 
> pulled_task is initialised to -1 and checked for non-zero which is
> always true if the lowest level sched_domain does not have
> SD_BALANCE_NEWIDLE flag set.
> 
> Trivial fix to initialise pulled_task to zero.
> Patch against 2.6.28-rc7

applied to tip/sched/core, thanks! (Not for v2.6.28 because this could 
affect performance.)

	Ingo
