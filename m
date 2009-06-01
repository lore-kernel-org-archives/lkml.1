Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZFAT4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZFAT4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbZFAT4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:56:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZFAT43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:56:29 -0400
Date: Mon, 1 Jun 2009 21:56:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-fsdevel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] hrtimer: export ktime_add_safe
Message-ID: <20090601195600.GF29610@elte.hu>
References: <20090529150929.8912.33879.sendpatchset@localhost.localdomain> <20090529150938.8912.3443.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529150938.8912.3443.sendpatchset@localhost.localdomain>
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


* Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Subject: [PATCH 1/2] hrtimer: export ktime_add_safe
> 
> We want to use hrtimers in UBIFS (for write-buffer write-back timer).
> We need the 'hrtimer_set_expires_range_ns()', which is an in-line
> function which uses 'ktime_add_safe()'.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
>  kernel/hrtimer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index cb8a15c..18f6906 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -332,6 +332,8 @@ ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
>  	return res;
>  }
>  
> +EXPORT_SYMBOL_GPL(ktime_add_safe);
> +

Feel free to queue this up in your tree - it's trivial enough.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
