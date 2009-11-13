Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZKMIRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZKMIRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbZKMIR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:17:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZKMIR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:17:28 -0500
Date: Fri, 13 Nov 2009 09:17:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Message-ID: <20091113081722.GA14009@elte.hu>
References: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp>
 <20091112073909.GB31719@elte.hu>
 <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
> Date: Thu, 12 Nov 2009 08:39:09 +0100
> 
> > 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > * Description
> > > 
> > > This patch makes the file spinlock_stats on top of the debugfs.
> > > When user reads this file, some statistical data related to
> > > spinlocks are printed.
> > 
> > hm, are you aware of the lockstat tracepoints? They do something 
> > like this - and it utilizes perf events to report these events. See 
> > include/trace/events/lockdep.h. Needs CONFIG_LOCK_STAT enabled.
> >
> 
> Wow, I didn't know that. I'll try it.

Btw., i think we should rename that tracepoint category from 'lockdep' 
to 'lock'. It's possible to enable them without CONFIG_PROVE_LOCKING, 
and they arent high-overhead in that case.

	Ingo
