Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZIGU5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZIGU5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZIGU5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:57:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37255 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZIGU5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:57:10 -0400
Date: Mon, 7 Sep 2009 22:57:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907205701.GA8590@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909072051.13748.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Michael Buesch <mb@bu3sch.de> wrote:

> On Monday 07 September 2009 20:26:29 Ingo Molnar wrote:
> > Could you profile it please? Also, what's the context-switch rate?
> 
> As far as I can tell, the broadcom mips architecture does not have 
> profiling support. It does only have some proprietary profiling 
> registers that nobody wrote kernel support for, yet.

Well, what does 'vmstat 1' show - how many context switches are 
there per second on the iperf server? In theory if it's a truly 
saturated box, there shouldnt be many - just a single iperf task 
running at 100% CPU utilization or so.

(Also, if there's hrtimer support for that board then perfcounters 
could be used to profile it.)

	Ingo
