Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbXKMJi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbXKMJi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 04:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXKMJiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 04:38:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXKMJiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 04:38:16 -0500
Date: Tue, 13 Nov 2007 10:34:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-ID: <20071113093414.GA5270@elte.hu>
References: <200711091136.20051.david-b@pacbell.net> <200711121432.54307.david-b@pacbell.net> <20071112152857.a60643b0.akpm@linux-foundation.org> <200711121726.39263.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711121726.39263.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Brownell <david-b@pacbell.net> wrote:

> > > I speculate that either the design has changed (without fanfare), 
> > > or else that stuff is in RT kernels and has not yet gone upstream.
> > 
> > Well whatever.  We shouldn't have to resort to caller-side party 
> > tricks like this to get acceptable performance.
> 
> I'd be happy if, as originally presented, it were possible to just 
> pass a raw_spinlock_t to spin_lock_irqsave() and friends.

that's a spinlock type abstraction of PREEMPT_RT, not of mainline. In 
mainline there's basically almost never any valid reason to use a raw 
spinlock - please use spinlock_t instead. Why do you want to use 
raw_spinlock_t?

	Ingo
