Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXDRKWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXDRKWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXDRKWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:22:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXDRKWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:22:48 -0400
Date: Wed, 18 Apr 2007 12:22:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418102225.GA32478@elte.hu>
References: <20070413202100.GA9957@elte.hu> <46247DAB.1060808@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46247DAB.1060808@shadowen.org>
User-Agent: Mutt/1.4.2.2i
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


* Andy Whitcroft <apw@shadowen.org> wrote:

> > as usual, any sort of feedback, bugreports, fixes and suggestions 
> > are more than welcome,
> 
> Pushed this through the test.kernel.org and nothing new blew up. 
> Notably the kernbench figures are within expectations even on the 
> bigger numa systems, commonly badly affected by balancing problems in 
> the schedular.

thanks! Given the really low preemption latency/granularity default 
(roughly equivalent to 'timeslice length'), and that basically all of my 
focus was on interactivity characteristics, this is a pretty good 
result. I suspect it will be necessary to increase the default to 10 
msecs (or more) to be on the safe side. (Nick has reported a 4% 
kernbench drop so for his kernbench workload it's needed.)

	Ingo
