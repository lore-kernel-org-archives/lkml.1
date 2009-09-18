Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZIRLZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZIRLZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZIRLZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:25:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56023 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZIRLZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:25:01 -0400
Date: Fri, 18 Sep 2009 13:24:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090918112454.GE9930@elte.hu>
References: <20090906205952.GA6516@elte.hu> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu> <200909081645.18505.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909081645.18505.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0466]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Buesch <mb@bu3sch.de> wrote:

> On Tuesday 08 September 2009 09:48:25 Ingo Molnar wrote:
> > Mind poking on this one to figure out whether it's all repeatable 
> > and why that slowdown happens?
> 
> I repeated the test several times, because I couldn't really believe 
> that there's such a big difference for me, but the results were the 
> same. I don't really know what's going on nor how to find out what's 
> going on.

Well that's a really memory constrained MIPS device with like 16 MB of 
RAM or so? So having effects from small things like changing details in 
a kernel image is entirely plausible.

	Ingo
