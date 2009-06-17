Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbZFQMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbZFQMZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZFQMZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:25:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbZFQMZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:25:11 -0400
Date: Wed, 17 Jun 2009 14:24:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, efault@gmx.de, arjan@infradead.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: [tip:perfcounters/core] perf record/report: Add call graph /
	call chain profiling
Message-ID: <20090617122455.GC13316@elte.hu>
References: <tip-3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea@git.kernel.org> <20090616025750.GB6057@nowhere> <20090616080924.GB16229@elte.hu> <1245224279.13761.21585.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245224279.13761.21585.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > The context IDs would occupy some rare and 
> > unlikely-to-be-allocated-soon corner of the address space - say 
> > startig at 0x8765432112345000. (and real RIPs would be filtered 
> > and nudged just outside that space of a handful IDs.)
> 
> Right, that works too, but should we use (u64)-1..-4095 for that? 
> We already use that range for things like ERR_PTR() so its very 
> unlikely we have something sensible mapped there.

Makes sense. It's also an easier (and more natural) enumeration 
method.

	Ingo
