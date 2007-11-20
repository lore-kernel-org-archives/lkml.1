Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbXKTWBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbXKTWBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762341AbXKTWB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:01:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758986AbXKTWB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:01:28 -0500
Date: Tue, 20 Nov 2007 23:01:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Mark Lord <lkml@rtr.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071120220110.GF24156@elte.hu>
References: <47425EA5.7000607@rtr.ca> <200711201517.16171.nickpiggin@yahoo.com.au> <20071119213727.16d5917b@laptopd505.fenrus.org> <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120064747.2a8036cd@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> kernel or kernel source? If there was a good place in the kernel 
> source I'd not be against moving irqbalance there. [...]

would this be a good case study to use klibc and start up irqbalanced 
automatically? I'd love it if we moved more of the 'system support' 
userspace into the kernel proper, to keep it under control. (and to 
simplify the compatibility and QA matrix)

	Ingo
