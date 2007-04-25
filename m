Return-Path: <linux-kernel-owner+w=401wt.eu-S2992464AbXDYJ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992464AbXDYJ06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992481AbXDYJ06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:26:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992464AbXDYJ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:26:57 -0400
Date: Wed, 25 Apr 2007 11:25:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070425092544.GA498@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <200704241854.47269.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704241854.47269.mail@earthworm.de>
User-Agent: Mutt/1.4.2.2i
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


* Christian Hesse <mail@earthworm.de> wrote:

> On Monday 23 April 2007, Ingo Molnar wrote:
> > i'm pleased to announce release -v5 of the CFS scheduler patchset.
> 
> Hi Ingo,
> 
> I just noticed that with cfs all processes (except some kernel 
> threads) run on cpu 0. I don't think this is expected cpu affinity for 
> an smp system? I remember about half of the processes running on each 
> core with mainline.

i've got several SMP systems with CFS and all distribute the load 
properly to all CPUs, so it would be nice if you could tell me more 
about how the problem manifests itself on your system.

for example, if you start two infinite loops:

    for (( N=0; N < 2; N++ )); do ( while :; do :; done ) & done

do they end up on the same CPU?

Or do you mean that the default placement of single tasks starts at 
CPU#0, while with mainline they were alternating?

	Ingo
