Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZCXKO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZCXKO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZCXKOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:14:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZCXKOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:14:46 -0400
Date: Tue, 24 Mar 2009 11:14:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
Subject: Re: [tip:perfcounters/core] perf_counter tools: remove glib
	dependency and fix bugs in kerneltop.c
Message-ID: <20090324101423.GA19065@elte.hu>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com> <tip-6357003d6c8bc0056d79768692955da6d151880f@git.kernel.org> <20090324093817.GA1772@elte.hu> <18888.45586.544707.554429@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18888.45586.544707.554429@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > btw.,:
> > 
> > | Performance counter stats for 'ls':
> > |
> > |        1915281  task clock ticks     (events)
> > |
> > |              6  CPU migrations       (events)
> > |              6  CPU migrations       (events)
> > |            284  pagefaults           (events)
> > |       4.333761  CPU cycles           (msecs)
> > |       1.544153  instructions         (msecs)
> > |         620030  cache references     (events)
> > |          17632  cache misses         (events)
> > |
> > | Wall-clock time elapsed:     1.868138 msecs
> > 
> > the 'instructions' field is weird - it should not be millisecs but 
> > 'events'.
> 
> Is that with my patch applied?  That was one of the things I fixed, or
> at least intended to fix :).

ah. no. It was indeed with an ancient kernel 6 hours old or so :)

	Ingo
