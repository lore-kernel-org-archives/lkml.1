Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbXGUMbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbXGUMbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762340AbXGUMa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:30:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762057AbXGUMaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:30:55 -0400
Date: Sat, 21 Jul 2007 14:30:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <bgerst@didntduck.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721123032.GA1769@elte.hu>
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de> <1185005750.4012.100.camel@chaos> <46A1EF57.2020304@didntduck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A1EF57.2020304@didntduck.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Gerst <bgerst@didntduck.org> wrote:

> > And there is more of that, when you take the time and look closely 
> > at the _32.[ch] _64.[ch] files which are created by the merge.
> 
> Looking at the include files, many more are near-identical in trivial 
> ways, such as whitespace, comments, local variable names, or guard 
> #ifdefs.

yeah. And by moving them next to each other, people actually have the 
real incentive to look and ponder: "these two files do similar things 
but they look so different. Does it _have_ to be so?". Often the answer 
is: no, it could really be shared.

And even when things will continue to be different, it's nice to have 
them side by side for documentation purposes as well. "we do this 
differently on 64-bit, because ...".

Key to starting all these cleanups is to create plain and simple 
physical proximity - and our transition arch/x86 and include/asm-x86 
achieves that - nothing more, nothing less.

	Ingo
