Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbYIESoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbYIESoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYIESoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:44:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40467 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYIESoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:44:13 -0400
Date: Fri, 5 Sep 2008 20:43:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux@sandersweb.net,
       Andi Kleen <andi-suse@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080905184353.GA29496@elte.hu>
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org> <200809051138.20615.linux@sandersweb.net> <48C17754.76E4.0078.0@novell.com> <alpine.LFD.1.10.0809050931340.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809050931340.3117@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  - Move the optimized nop definitions (K7_NOPx etc) to the only place that 
>    cares - asm/x86/kernel/alternative.c. When we do things _dynamically_, 
>    it can actually make sense to pick a nop more precisely, but for this 
>    whole static thing it's just a pain.
> 
> IOW, if it actually _worked_ reasonably, I wouldn't care. But clearly 
> it doesn't. And once it's not working reasonably, it should be fixed.

yes - we had 3-4 tries already and while it looked worthwile initially 
it's clearly not showing signs of getting more robust and whatever 
benefits there might be slightly better NOPs is dwarved by all these 
robustness problems. Peter?

	Ingo
