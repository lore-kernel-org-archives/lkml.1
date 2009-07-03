Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZGCKdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZGCKdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZGCKdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:33:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZGCKdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:33:31 -0400
Date: Fri, 3 Jul 2009 12:33:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2 -tip] perf_counter: Add generalized hardware
	interrupt support for AMD and Intel Corei7/Nehalem, Core2 and Atom
Message-ID: <20090703103304.GG32128@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam> <1246440909.3403.5.camel@hpdv5.satnam> <1246440977.3403.7.camel@hpdv5.satnam> <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu> <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam> <20090701114928.GI15958@elte.hu> <1246527872.13659.2.camel@hpdv5.satnam> <1246527951.13659.4.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246527951.13659.4.camel@hpdv5.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> $ ./perf stat -e interrupts -e masked -e int-pending-mask-cycles -- ls -lR /usr/include/ > /dev/null
> 
>  Performance counter stats for 'ls -lR /usr/include/':
> 
>             377  interrupts
>        53429936  int-mask-cycles
>            1119  int-pending-mask-cycles

What's your take on my review feedback:

> We could and should probably add a software counter for hardirqs 
> as well. That would allow the vector/irqnr information to be 
> passed in, and it would allow architectures without irq metrics in 
> the PMU to have this counter too.
>
> This way we could profile based on a specific interrupt source 
> only - say based on the networking card.

Why did you resend the patch while there was still unanswered review 
feedback?

	Ingo
