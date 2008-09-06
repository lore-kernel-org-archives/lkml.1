Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYIFNRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYIFNRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 09:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYIFNRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 09:17:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYIFNRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 09:17:44 -0400
Date: Sat, 6 Sep 2008 15:17:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.27-rc5-mm1 compilation fix with gcc 3.4.6
Message-ID: <20080906131727.GB4910@elte.hu>
References: <20080905234619.2e95ae92.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905234619.2e95ae92.krzysztof.h1@poczta.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> Hi Andrew,
> 
> I found that 2.6.27-rc5-mm1 does not compile with gcc 3.4.6.
> The error is:
>   CC      kernel/sched.o
> kernel/sched.c: In function `start_rt_bandwidth':
> kernel/sched.c:208: sorry, unimplemented: inlining failed in call to 'rt_bandwidth_enabled': function body not available
> kernel/sched.c:214: sorry, unimplemented: called from here
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 
> It seems that the gcc 3.4.6 requires full inline definition before 
> first usage. The patch below fixes the compilation problem.

applied to tip/sched/rt, thanks Krzysztof!

	Ingo
