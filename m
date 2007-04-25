Return-Path: <linux-kernel-owner+w=401wt.eu-S2992458AbXDYJdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992458AbXDYJdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992477AbXDYJdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:33:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35896 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992458AbXDYJc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:32:59 -0400
Date: Wed, 25 Apr 2007 11:32:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: ray-gmail@madrabbit.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425093228.GC498@elte.hu>
References: <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <2c0942db0704240808p5b97bb31u42da4db298821809@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0704240808p5b97bb31u42da4db298821809@mail.gmail.com>
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


* Ray Lee <madrabbit@gmail.com> wrote:

> It would seem like there should be a penalty associated with sending 
> those points as well, so that two processes communicating quickly with 
> each other won't get into a mutual love-fest that'll capture the 
> scheduler's attention.

it's not really "points", but "nanoseconds you are allowed to execute on 
the CPU". And thus two processes communicating with each other quickly 
and sending around this resource does get the attention of CFS: the 
resource is gradually consumed because the two processes are running on 
the CPU while they are communicating with each other. So it all works 
out fine.

	Ingo
