Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbXJGHSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbXJGHSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 03:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXJGHSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 03:18:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbXJGHSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 03:18:15 -0400
Date: Sun, 7 Oct 2007 09:18:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071007071811.GA31302@elte.hu>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu> <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu> <20071003095057.GD1726@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003095057.GD1726@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> > [...] The timeslices of tasks (i.e. the time they spend on a CPU 
> > without scheduling away) is _not_ maintained directly in CFS as a 
> > per-task variable that can be "cleared", it's not the metric that 
> > drives scheduling. Yes, of course CFS too "slices up CPU time", but 
> > those slices are not the per-task variables of traditional 
> > schedulers and cannot be 'cleared'.
> 
> It's not about this comment alone, but this comment plus "no notion" 
> comment, which appears in sched-design-CFS.txt too.

ok - i've re-read it and it indeed is somewhat confusing without 
additional context. I'll improve the wording. (sched-design-CFS.txt 
needs an update anyway)

	Ingo
