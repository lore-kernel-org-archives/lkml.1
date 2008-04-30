Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbYD3Sgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbYD3Sgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYD3Sgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:36:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41826 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935AbYD3Sgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:36:38 -0400
Date: Wed, 30 Apr 2008 20:36:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: ioremap ram check fix
Message-ID: <20080430183622.GC3008@elte.hu>
References: <20080430113024.43aa3935@ephemeral> <20080430181015.GB31726@elte.hu> <20080430141741.132b3a00@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430141741.132b3a00@ephemeral>
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


* Andres Salomon <dilinger@queued.net> wrote:

> > that breakage has been reported independently as well and the revert 
> > has been pushed to Linus yesterday - it's not upstream yet. See this 
> > commit in x86.git:
> 
> Sure, either way.  FWIW, Vegard reported that the PAGE_MASK change 
> made the 150s delay disappear.

sorry, i forgot to mention that your fix is the right one [it actually 
fixes the problem instead of reverting the change] so i've queued that 
up too :-) Thanks for fixing this!

	Ingo
