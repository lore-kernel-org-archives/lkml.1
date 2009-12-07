Return-Path: <linux-kernel-owner+w=401wt.eu-S1751377AbZLGFZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbZLGFZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZLGFZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:25:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZLGFZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:25:20 -0500
Date: Mon, 7 Dec 2009 06:25:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] perf: Make location of kernel source configurable
Message-ID: <20091207052521.GA21422@elte.hu>
References: <20091206307.542816612@firstfloor.org>
 <20091207013339.GC4966@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207013339.GC4966@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sun, Dec 06, 2009 at 03:07:30PM +0100, Andi Kleen wrote:
> > 
> > tools/perf has no support for separate object directories
> > and lots of hard coded paths assuming that the kernel source
> > is always in ../..
> > 
> > As a first step of compiling it separately without messing
> > up clean source trees allow to configure the kernel source
> > location using a KERNELSRC variable 
> > 
> > This allows at least to copy the whole tools/perf
> > directory elsewhere and build it separately.
> > 
> > The default is still ../.., so for a standard build
> > nothing changes
> > 
> > This also removes a lot of ugly ../.. from the source.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> 
> It worry about that too.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Frederic, mind queueing Andi's fix up in your tree and testing it there, 
before pushing it to me via the regular route?

Thanks,

	Ingo
