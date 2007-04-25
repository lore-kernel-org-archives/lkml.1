Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXDYMxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXDYMxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXDYMxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:53:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965650AbXDYMxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:53:07 -0400
Date: Wed, 25 Apr 2007 14:51:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070425125104.GA11914@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423051659.GA3929@gentoox2.trippelsdorf.de> <20070423052728.GB3929@gentoox2.trippelsdorf.de> <20070423062116.GB4518@elte.hu> <20070425114318.GA7328@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425114318.GA7328@in.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> +#define __NR_yield_to          280
> +__SYSCALL(__NR_move_pages, sys_sched_yield_to)
> 
> s/__NR_move_pages/__NR_yield_to in the above line?

yeah, thanks.

	Ingo
