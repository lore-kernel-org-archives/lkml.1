Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXDQGuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXDQGuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXDQGuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:50:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXDQGuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:50:23 -0400
Date: Tue, 17 Apr 2007 08:49:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417064934.GA22110@elte.hu>
References: <20070416220715.GA4071@elte.hu> <462447E0.20806@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462447E0.20806@bigpond.net.au>
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


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> Can I make a suggestion?
> 
> Would it be possible (from now on) to publish changes relevant to the 
> previous patch (eventually leading to a series of patches that 
> describes the evolution of the new scheduler) so that it's easier for 
> us reviewers/critics to see the latest changes.  E.g. if import such 
> changes into something like quilt (using my gquilt GUI wrapper, of 
> course :-)) I can then use meld (or similar) to follow what's going as 
> suggestions get folded in and bugs get fixed etc.

the v1 patch is still downloadable so you can do a delta by first 
applying the v1 patch to a quilt queue, doing a 'quilt snapshot', then 
'quilt pop', add the v2 patch to the series file, do a 'quilt push', 
then doing a "quilt diff --snapshot". (I just posted the delta patch in 
this thread so you can pick it from there too.)

	Ingo
