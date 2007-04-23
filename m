Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbXDWVFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbXDWVFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXDWVFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:05:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbXDWVFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:05:01 -0400
Date: Mon, 23 Apr 2007 23:03:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070423210341.GA7675@elte.hu>
References: <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu> <20070423204431.GA1240@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423204431.GA1240@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> sorry, i was a bit imprecise here. There is a case where CFS can give 
> out a 'loan' to tasks. The scheduler tick has a low resolution, so it 
> is fundamentally inevitable [*] that tasks will run a bit more than 
> they should, and at a heavy context-switching rates these errors can 
> add up significantly. Furthermore, we want to batch up workloads.
> 
> So CFS has a "no loans larger than sched_granularity_ns" policy (which 
> defaults to 5msec), and it captures these sub-granularity 'loans' with 
> nanosec accounting. This too is a very sane economic policy and is 
> anti-infationary :-)

at which point i guess i should rename CFS to 'EFS' (the Economic Fair 
Scheduler)? =B-)

	Ingo
