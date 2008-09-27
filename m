Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYI0Qa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYI0Qa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYI0QaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:30:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYI0QaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:30:16 -0400
Date: Sat, 27 Sep 2008 18:30:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/7] traps: x86: irqtrace cleanup and some traps.c
	unification
Message-ID: <20080927163000.GB4600@elte.hu>
References: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Aparantly the conversion of exceptions from traps to interrupts and 
> the changes to the irq-tracer on i386 have not given any trouble, yet? 
> (tip/x86/traps)

Correct.

Generally you'll hear from the -tip maintainers if there's any trouble 
with a topic. If you see it integrated into tip/master and if you see no 
comments then it means that they work just fine.

> This is a small set of patches removing trace_hardirqs_fixup 
> completely from the code. TRACE_IRQS_OFF is added to the assembly code 
> instead, where needed.
>
> 7/7 is a small unification step between traps_32.c and traps_64.c

cool! Any plans on finishing the unification? ;-)

> Patches were generated against tip/x86/traps.

applied to tip/x86/traps, thanks.

	Ingo
