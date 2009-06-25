Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZFYJNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZFYJNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZFYJNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:13:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFYJNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:13:32 -0400
Date: Thu, 25 Jun 2009 11:13:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vince@deater.net>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter 20% error finding retired instruction count
Message-ID: <20090625091324.GA16860@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906242200000.12718@pianoman.cluster.toy> <1245912600.31755.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245912600.31755.21.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-06-24 at 22:12 -0400, Vince Weaver wrote:
> > 
> > It's also nice to be able to skip the loader overhead, as the 
> > loader can change from system to system and makes it hard to 
> > compare counters across various machines.  Though it sounds like 
> > the perf utility isn't going to be supporting this anytime soon.
> 
> Feel free to contribute such if you think its important.

I'd be glad to review and test any resulting patches from Vince - 
and/or help out with pointers where to start and help out there's 
any roadblocks along the way.

The kernel side bits can be found in v2.6.31-rc1, in 
kernel/perf_counter.c, include/linux/perf_counter.h and 
arch/x86/kernel/cpu/perf_counter.c. We tried to keep the code as 
hackable as possible.

The tooling bits can be found in tools/perf/ in the kernel repo. 
builtin-stat.c contains the 'perf stat' bits.

Thanks,

	Ingo
