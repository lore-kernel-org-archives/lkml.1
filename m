Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbXHZQja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbXHZQja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXHZQjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:39:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXHZQjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:39:20 -0400
Date: Sun, 26 Aug 2007 18:39:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070826163907.GB12453@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708260127.32238.a1426z@gawab.com> <20070825231525.GA334@elte.hu> <200708261927.07040.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708261927.07040.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4754]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> > and could you also check 20.4 on 2.6.22.5 perhaps, or very latest 
> > -git? (Peter has experienced smaller spikes with that.)
> 
> Ok, I tried all your suggestions, but nothing works as smooth as 
> removing __update_curr.

could you send the exact patch that shows what you did? And could you 
also please describe it exactly which aspect of the workload you call 
'smooth'. Could it be made quantitative somehow?

	Ingo
