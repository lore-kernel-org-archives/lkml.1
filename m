Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYG1OEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYG1OEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYG1OEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:04:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48003 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYG1OEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:04:34 -0400
Date: Mon, 28 Jul 2008 16:04:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: roel kluin <roel.kluin@gmail.com>, rml@tech9.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Test runtime rather than period in
	global_rt_runtime()
Message-ID: <20080728140423.GA18144@elte.hu>
References: <488529B2.1080609@gmail.com> <1216717739.7257.94.camel@twins> <48864843.6030808@gmail.com> <1216794328.7257.123.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216794328.7257.123.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2008-07-22 at 16:51 -0400, roel kluin wrote:
> > Peter Zijlstra wrote:
> > > On Mon, 2008-07-21 at 20:28 -0400, roel kluin wrote:
> > >> Peter, you added the test in global_rt_runtime(), in commit
> > >> d0b27fa77854b149ad4af08b0fe47fe712a47ade
> > >> could you take a look at it and tell whether this test should
> > >> be replaced by something else?
> > 
> > >> -	if (sysctl_sched_rt_period < 0)
> > 
> > > Gah, I'm a moron. That should read:
> > > 
> > >   if (sysctl_sched_rt_runtime < 0)
> 
> Thanks!
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/urgent - thanks!

	Ingo
