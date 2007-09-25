Return-Path: <linux-kernel-owner+w=401wt.eu-S1752405AbXIYJSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752405AbXIYJSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXIYJRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:17:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXIYJRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:17:48 -0400
Date: Tue, 25 Sep 2007 11:17:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925091727.GB22905@elte.hu>
References: <20070924214537.GA18980@elte.hu> <200709250950.59861.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200709250950.59861.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> Seems like following trivial change needed to compile without 
> CONFIG_SCHEDSTATS
> 
> caglar@zangetsu linux-2.6 $ LC_ALL=C make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      kernel/sched.o
> In file included from kernel/sched.c:853:
> kernel/sched_debug.c: In function `print_cfs_rq':
> kernel/sched_debug.c:139: error: structure has no member named `bkl_cnt'
> kernel/sched_debug.c:139: error: structure has no member named `bkl_cnt'
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

thanks, applied!

	Ingo
