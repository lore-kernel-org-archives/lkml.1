Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYL0PCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYL0PCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 10:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYL0PCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 10:02:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbYL0PCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 10:02:45 -0500
Date: Sat, 27 Dec 2008 16:02:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [PATCH] x86: perf_counter remove unwanted hw_perf_enable_all
Message-ID: <20081227150229.GA19595@elte.hu>
References: <1230385543.3373.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230385543.3373.5.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: clean, reduce kernel size a bit, avoid sparse warnings
> 
> Fixes sparse warnings:
> 
> arch/x86/kernel/cpu/perf_counter.c:153:6: warning: symbol 'hw_perf_enable_all' was not declared. Should it be static?
> arch/x86/kernel/cpu/perf_counter.c:279:3: warning: returning void-valued expression
> arch/x86/kernel/cpu/perf_counter.c:206:3: warning: returning void-valued expression
> arch/x86/kernel/cpu/perf_counter.c:206:3: warning: returning void-valued expression
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   24 +++++++-----------------
>  1 files changed, 7 insertions(+), 17 deletions(-)

applied to tip/perfcounters/core, thanks!

	Ingo
