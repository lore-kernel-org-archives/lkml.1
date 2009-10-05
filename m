Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbZJEKCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbZJEKCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbZJEKCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:02:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475AbZJEKCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:02:50 -0400
Date: Mon, 5 Oct 2009 12:02:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Jayson R. King" <dev@jaysonking.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Remove obsolete comment in sched_init()
Message-ID: <20091005100203.GA3211@elte.hu>
References: <4AC98F4A.7070303@jaysonking.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC98F4A.7070303@jaysonking.com>
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


* Jayson R. King <dev@jaysonking.com> wrote:

> Remove the comment about calling alloc_bootmem() as it is not called
> here since commit 36b7b6d465489c4754c4fd66fcec6086eba87896.
>
> Signed-off-by: Jayson R. King <dev@jaysonking.com>
> ---
>  kernel/sched.c |    4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1535f38..d68ac0e 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9334,10 +9334,6 @@ void __init sched_init(void)
>  #ifdef CONFIG_CPUMASK_OFFSTACK
>         alloc_size += num_possible_cpus() * cpumask_size();
>  #endif
> -       /*
> -        * As sched_init() is called before page_alloc is setup,
> -        * we use alloc_bootmem().
> -        */
>         if (alloc_size) {
>                 ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);

Looks good. The patch is whitespace damaged though (all tabs are spaces) 
- please consult Documentation/email-clients.txt and resend the patch.

Thanks,

	Ingo
