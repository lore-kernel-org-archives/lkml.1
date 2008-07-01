Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYGAUY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYGAUY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYGAUYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:24:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54408 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbYGAUYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:24:18 -0400
Date: Tue, 1 Jul 2008 22:24:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] kmemcheck updates for -tip
Message-ID: <20080701202407.GC4896@elte.hu>
References: <20080701201855.GA22686@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701201855.GA22686@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi Ingo,
> 
> Please pull the 'for-tip' branch of
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip
> 
> to receive the following changes:
> 
> Vegard Nossum (3):
>       kmemcheck: fix sparse warnings
>       softirq: raise the right softirq
>       kmemcheck: use the proper comment style

pulled into tip/kmemcheck, thanks Vegard!

btw:

> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -399,7 +399,7 @@ void __tasklet_hi_schedule_first(struct tasklet_struct *t)
>  
>  	t->next = __get_cpu_var(tasklet_hi_vec).head;
>  	__get_cpu_var(tasklet_hi_vec).head = t;
> -	__raise_softirq_irqoff(TASKLET_SOFTIRQ);
> +	__raise_softirq_irqoff(HI_SOFTIRQ);
>  }

i think i'll put this one into core/softirqs as well.

	Ingo
