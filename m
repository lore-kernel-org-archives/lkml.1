Return-Path: <linux-kernel-owner+w=401wt.eu-S1161110AbXDNK41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161110AbXDNK41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 06:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161162AbXDNK41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 06:56:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161110AbXDNK41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 06:56:27 -0400
Date: Sat, 14 Apr 2007 12:55:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414105556.GC19454@elte.hu>
References: <20070413202100.GA9957@elte.hu> <1176502546.3129.79.camel@imap.mvista.com> <20070413223017.GA8961@elte.hu> <1176508785.3129.89.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176508785.3129.89.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> One other thing, what happens in the case of slow, frequency changing, 
> are/or inaccurate clocks .. Is the old sched_clock behavior still 
> tolerated?

yeah, good question. Yesterday i did a quick testboot with that too, and 
it seemed to behave pretty OK with the low-res [jiffies based] 
sched_clock() too. Although in that case things are much more of an 
approximation and rounding/arithmetics artifacts are possible. CFS works 
best with a high-resolution cycle counter.

	Ingo
