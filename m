Return-Path: <linux-kernel-owner+w=401wt.eu-S936535AbXG2VSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936535AbXG2VSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935497AbXG2VSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:18:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXG2VSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:18:00 -0400
Date: Sun, 29 Jul 2007 23:17:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: make cpu_clock() not use the rq clock
Message-ID: <20070729211752.GA8134@elte.hu>
References: <20070726090012.GA5287@elte.hu> <46AC2D9C.3080307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AC2D9C.3080307@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > Subject: sched: make cpu_clock() not use the rq clock
> >   
> 
> This subject doesn't make much sense to me.  All this patch does is get
> the rq's current time under irq_disable rather than spinlock, right?

i typoed it: s/clock/lock

	Ingo
