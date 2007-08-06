Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXHFHVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXHFHVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbXHFHVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:21:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbXHFHVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:21:21 -0400
Date: Mon, 6 Aug 2007 09:20:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [RESEND] [BUG] futex_unlock_pi() hurts my brain and may cause
	application deadlock
Message-ID: <20070806072012.GF5359@elte.hu>
References: <1180572567.6126.44.camel@localhost.localdomain> <1185926019.8850.198.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185926019.8850.198.camel@localhost>
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


* john stultz <johnstul@us.ibm.com> wrote:

> Hey Ingo,
> 	I sent this fix for this back in the 2.6.21-rt9 era, and I thought to
> picked it up, but I think it arrived amid some futex churn and
> apparently has been dropped or was just lost.
> 
> Some of our testers have been reporting futex deadlocks and this fix 
> resolves it, so I believe it to still be needed.

hmm ... so the many rounds of pi-futex fixes from Alexey and Thomas did 
not resolve that deadlock?

	Ingo
