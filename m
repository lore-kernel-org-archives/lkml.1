Return-Path: <linux-kernel-owner+w=401wt.eu-S1030819AbXDMVvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819AbXDMVvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030855AbXDMVvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:51:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030819AbXDMVvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:51:06 -0400
Date: Fri, 13 Apr 2007 23:50:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413215059.GA32666@elte.hu>
References: <20070413202100.GA9957@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413202100.GA9957@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> and even adding all the scheduling modules, the total size impact is 
> relatively small:
> 
>  18 files changed, 1454 insertions(+), 1133 deletions(-)
> 
> most of the increase is due to extensive comments. The kernel size 
> impact is in fact a small negative:
> 
>    text    data     bss     dec     hex filename
>   23366    4001      24   27391    6aff kernel/sched.o.vanilla
>   24159    2705      56   26920    6928 kernel/sched.o.CFS

update: these were older numbers, here are the stats redone with the 
latest patch:

     text    data     bss     dec     hex filename
    23366    4001      24   27391    6aff kernel/sched.o.vanilla
    23671    4548      24   28243    6e53 kernel/sched.o.sd.v40
    23349    2705      24   26078    65de kernel/sched.o.cfs

so CFS is now a win both for text and for data size :)

	Ingo
