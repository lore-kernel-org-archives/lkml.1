Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYFXAMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYFXAMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYFXAMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:12:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46108 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbYFXAMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:12:41 -0400
Date: Tue, 24 Jun 2008 02:12:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -rt] serial: 8250: fix shared interrupts issues under
	RT kernels
Message-ID: <20080624001221.GA20685@elte.hu>
References: <20080623232957.GA5111@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623232957.GA5111@polina.dev.rtsoft.ru>
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


* Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> 8250's initialization routines relies on the fact that _irqsave 
> spinlock will disable local hardirqs, so that the driver can issue 
> IRQ-triggering operations before registering the port in the IRQ 
> chain.
> 
> With RT kernels and preemptable hardirqs this isn't true, _irqsave 
> spinlock does not disable local hardirqs, and this causes following 
> trace:

again, please let the -rt maintainers sort out which patches need to be 
propagated to upstream maintainers.

	Ingo
