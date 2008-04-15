Return-Path: <linux-kernel-owner+w=401wt.eu-S1765249AbYDOOF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765249AbYDOOF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762835AbYDOOFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:05:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760759AbYDOOFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:05:12 -0400
Date: Tue, 15 Apr 2008 16:04:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415140430.GA6576@elte.hu>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415134705.GB22351@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > See, these tracer tools are my nightmare as member of an 
> > > enterprise linux team. They'll make an already hard job even 
> > > harder, no thanks!
> > 
> > i'm clearly NAK-ing all futex trace hooks until the true impact of 
> > the whole marker facility is better understood. I've tried them for 
> > the scheduler and they were a clear failure: too bloated and too 
> > persistent.
> 
> I have not seen any counter argument for the in-depth analysis of the 
> instruction cache impact of the optimized markers I've done. Arguing 
> that the markers are "bloated" based only on "size kernel/sched.o" 
> output is a bit misleading.

uhm, i'm not sure what you mean - how else would you quantify bloat than 
to look at the size of the affected subsystem?

	Ingo
