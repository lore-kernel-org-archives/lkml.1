Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZKCRYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZKCRYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZKCRYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:24:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZKCRYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:24:21 -0500
Date: Tue, 3 Nov 2009 18:24:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [RFC][PATCH 7/7] Adding general performance benchmarking
	subsystem to perf.
Message-ID: <20091103172407.GA11535@elte.hu>
References: <20091103.133927.580735811043340004.mitake@dcl.info.waseda.ac.jp> <20091103074648.GG19928@elte.hu> <20091103.195335.229420428319821713.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.195335.229420428319821713.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> > There will be a handful of more details i'm sure but once there's a 
> > good base we can commit it - would you / will you be interested in 
> > extending it further and adding more benchmark modules as well?
> > 
> > There's quite a few useful small benchmarks that people are using to 
> > measure the kernel. Having a good collection of them in one place, 
> > with standardized options and standardized output would be very 
> > useful.
> 
> Yes, of course! Unified benchmarking utilities will be big help for 
> Linux users including me.
> 
> e.g. I think that copybench (http://code.google.com/p/copybench/) will 
> be good benchmark for I/O, memory and file system. I'll work on this 
> after that the patch series I'll send later is merged.

copybench is listed as 'new BSD license'. Might need the pinging of its 
author whether he considers it GPLv2 compatible.

> Do you know any other good candidates to include?

Frederic suggested dbench - although that's quite large as it includes a 
complete trace of a benchmark run.

We might want to do similar measurements to lmbench.

One nice thing would be to have a 'system call benchmark' set - one that 
measures _all_ system calls, and could thus be used to find regressions 
on a 'broad' basis. Syscall usage could be gleaned from the LTP project.

	Ingo
