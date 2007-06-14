Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbXFNNvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbXFNNvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXFNNvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:51:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbXFNNvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:51:16 -0400
Date: Thu, 14 Jun 2007 15:51:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] sched: fix SysRq-N (normalize RT tasks)
Message-ID: <20070614135106.GA8325@elte.hu>
References: <20070614094830.GA494@elte.hu> <200706140948.48005.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706140948.48005.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Gene Heskett <gene.heskett@gmail.com> wrote:

> Ingo: I appended this patch to the cfs-v16 patch for 2.6.22-rc4, and 
> got this while applying it:
> 
> patching file kernel/sched.c
> Hunk #1 FAILED at 7071.
> Hunk #2 FAILED at 7095.
> 2 out of 2 hunks FAILED -- saving rejects to file kernel/sched.c.rej

yep, this fix is already included in CFS. (in fact in CFS i also changed 
this function to renormalizing negative-nice tasks to nice-0 - but this 
is not something upstream has to pick up for .22.)

	Ingo
