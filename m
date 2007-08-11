Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXHKSJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXHKSJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbXHKSJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:09:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53504 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbXHKSJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:09:36 -0400
Date: Sat, 11 Aug 2007 20:09:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Josh Triplett <josh@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-ID: <20070811180909.GC24717@elte.hu>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070810013146.GD18938@stusta.de> <20070810020040.GK8424@linux.vnet.ibm.com> <20070809190623.f60dcf70.akpm@linux-foundation.org> <20070810151208.GC8511@linux.vnet.ibm.com> <20070810101212.d59ce24a.akpm@linux-foundation.org> <20070810203055.GE8511@linux.vnet.ibm.com> <20070811002949.GA7918@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811002949.GA7918@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Add an EXPORT_SYMBOL_GPL() for cpu_clock() and make rcutorture.c use it.
> Compiles, but not yet tested.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> --- linux-2.6.23-rc2/kernel/sched.c	2007-08-03 19:49:55.000000000 -0700
> +++ linux-2.6.23-rc2-rcutorturesched/kernel/sched.c	2007-08-10 17:22:57.000000000 -0700
> @@ -394,6 +394,8 @@ unsigned long long cpu_clock(int cpu)
>  	return now;
>  }
>  
> +EXPORT_SYMBOL_GPL(cpu_clock);

sure enough,

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
