Return-Path: <linux-kernel-owner+w=401wt.eu-S937759AbXFHHLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937759AbXFHHLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762819AbXFHHLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:11:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815AbXFHHL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:11:29 -0400
Date: Fri, 8 Jun 2007 09:10:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 4/4] FUTEX: Tidy up the code
Message-ID: <20070608071045.GA30226@elte.hu>
References: <20070607235106.387346000@linutronix.de> <20070607235801.624243000@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607235801.624243000@linutronix.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The recent PRIVATE and REQUEUE_PI changes to the futex code made it hard to read.
> Tidy it up.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

looks good to me:

  Acked-by: Ingo Molnar <mingo@elte.hu>

> -		if (!pi) {
> -			if (uval & FUTEX_WAITERS)
> +		if (!pi && (uval & FUTEX_WAITERS))
>  				futex_wake(uaddr, &curr->mm->mmap_sem, 1);
> -		}

one too much tab left in the futex_wake line i guess?

	Ingo
