Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYKZG77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYKZG77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKZG7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:59:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYKZG7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:59:50 -0500
Date: Wed, 26 Nov 2008 07:59:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask conversion patches for sched
Message-ID: <20081126065937.GB26036@elte.hu>
References: <200811250238.53883.rusty@rustcorp.com.au> <20081124171749.GB27851@elte.hu> <20081124172343.GB11971@elte.hu> <200811250957.07332.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811250957.07332.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 25 November 2008 03:53:43 Ingo Molnar wrote:
> > plus there's a build failure as well on 32-bit:
> >
> > kernel/sched_rt.c:1561: error: 'per_cpu__local_cpu_mask' undeclared
> 
> Ah, CONFIG_SMP=n.  Problems in several patches; I split fix for easier
> rebasing if you want to later.

applied to tip/cpus4096:

 1224e37: sched: avoid stack var in move_task_off_dead_cpu, fix
 3d8cbdf: sched: convert local_cpu_mask to cpumask_var_t, fix
 bf4d83f: sched: convert nohz struct to cpumask_var_t, fix

thanks Rusty! (I folded back Mike's warning fix into 1224e37.)

I've started testing them again - they are looking good so far!

	Ingo
