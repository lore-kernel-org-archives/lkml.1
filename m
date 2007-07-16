Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXGPWaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXGPWaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXGPW3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:29:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbXGPW3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:29:47 -0400
Date: Tue, 17 Jul 2007 00:29:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070716222909.GA30906@elte.hu>
References: <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org> <20070716211851.GB18661@elte.hu> <Pine.LNX.4.64.0707162351030.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707162351030.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Mon, 16 Jul 2007, Ingo Molnar wrote:
> 
> > and note that even on the old scheduler, nice-0 was "3200% more 
> > powerful" than nice +19 (with CONFIG_HZ=300),
> 
> How did you get that value? At any HZ the ratio should be around 1:10 
> (+- rounding error).

you are wrong again. I sent you the numbers earlier today already:

|   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
|  2332 mingo     25   0  1580  248  196 R 95.1  0.0   0:11.84 loop
|  2335 mingo     39  19  1576  244  196 R  3.1  0.0   0:00.39 loop

3.1% is 3067% more than 95.1%, and the ratio is 1:30.67. You again deny 
above that this is the case, and there's nothing i can do about your 
denial of facts - that is your own private problem.

	Ingo
