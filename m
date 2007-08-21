Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbXHULQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbXHULQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbXHULQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:16:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbXHULQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:16:00 -0400
Date: Tue, 21 Aug 2007 13:15:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821111544.GA32064@elte.hu>
References: <20070812163225.GA11996@elte.hu> <1187687476.7623.8.camel@localhost> <20070821093434.GB12025@elte.hu> <200708211243.15223.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211243.15223.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.0.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3750]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Dienstag, 21. August 2007 schrieb Ingo Molnar:
> > the 'invariant' i mentioned only covers scheduler behavior, not 
> > accounting behavior. Accounting is separate in theory, but coupled in 
> > practice now via sum_exec_runtime.
> 
> Forgot to answer about that: That means that the current design does 
> not cover our requirement of showing process real time, even if we 
> implement sched_clock? In that case I would suggest to merge my patch 
> as a quick but correct solution and do it properly for 2.6.24. Of 
> course better solutions are welcome :-)

you mean to revert b27f03d4bd? I'd really like to see this fixed for 
real for s390 + CONFIG_VIRT_CPU_ACCOUNTING=y. (which seems to be the 
only case affected)

	Ingo
