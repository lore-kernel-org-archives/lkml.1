Return-Path: <linux-kernel-owner+w=401wt.eu-S965320AbXC0Hdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320AbXC0Hdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965316AbXC0Hdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:33:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965310AbXC0HdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:33:17 -0400
Date: Tue, 27 Mar 2007 09:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] genirq: do not mask interrupts by default
Message-ID: <20070327073227.GA26457@elte.hu>
References: <200702161759.l1GHxsO8010669@hera.kernel.org> <1174972037.5329.5.camel@localhost.localdomain> <1174972685.5329.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174972685.5329.12.camel@localhost.localdomain>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Note that I'm not opposed to the change at all, I think it's a good 
> idea, I'm just worried I'm discovering it a bit late and I've seen 
> PICs broken in some many colorful ways that I'm a bit worried... Oh 
> well...

This change does not really change irq-flow semantics, what it does is 
that disable_irq()'s effect is delayed. The irq controller does not have 
to re-assert the irq, we've got the soft-resend mechanism. What am i 
missing? Are you worried about this change causing actual breakage? (and 
i'm sorry about not having Cc:-ed you explicitly, i could have sworn you 
were included in that discussion but apparently not!)

	Ingo
