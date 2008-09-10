Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYIJHZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYIJHZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYIJHZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:25:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44766 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYIJHZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:25:05 -0400
Date: Wed, 10 Sep 2008 09:24:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: heukelum@fastmail.fm, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] i386: handle all exceptions with interrupts off
	initially
Message-ID: <20080910072455.GA12108@elte.hu>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm> <48C73EB8.8020405@zytor.com> <20080910055337.GA9765@elte.hu> <48C76243.5010206@zytor.com> <20080910070014.GB31059@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910070014.GB31059@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> great - i'll check which topic this fits in best. I suspect it will 
> get its own topic - but there could be interactions as traps*.c is a 
> central (and hence popular) file [...]

i've put Alexander's patches into a new -git based topic: tip/x86/traps 
- and git sorted the merge into tip/master out automatically, so this 
will be ok logistically. The commits are below.

	Ingo

------------------------>
71d6990: i386: trace_hardirqs_fixup should now not be necessary: irqs are off.
0dbf58b: i386: add TRACE_IRQS_OFF for the exception 3 (int3)
340f725: i386: add TRACE_IRQS_OFF for the nmi
c320a17: i386: add TRACE_IRQS_OFF for exception 1 (debug)
b51f1c3: i386: add TRACE_IRQS_OFF to entry_32.S in 'error_code'
d7af1f9: i386: remove temporary DO_TRAP macros, expanding the last one used
8915399: i386: convert hardware exception 19 to an interrupt gate
cc0302d: i386: convert hardware exception 18 to an interrupt gate
ed530ad: i386: convert hardware exception 17 to an interrupt gate
97082d7: i386: convert hardware exception 16 to an interrupt gate
d2ac8fa: i386: convert hardware exception 15 to an interrupt gate
0fdfcc7: i386: convert hardware exception 13 to an interrupt gate
f490c71: i386: convert hardware exception 12 to an interrupt gate
c4781f3: i386: convert hardware exception 11 to an interrupt gate
22d09d5: i386: convert hardware exception 10 to an interrupt gate
00f28ef: i386: convert hardware exception 9 to an interrupt gate
3a08e35: i386: convert hardware exception 7 to an interrupt gate
1fb2f60: i386: convert hardware exception 6 to an interrupt gate
4b00f5f: i386: convert hardware exception 5 to an interrupt gate
118ab1a: i386: convert hardware exception 4 to an interrupt gate
376de73: i386: expand exception 3 DO_TRAP macro
bec6f72: i386: convert hardware exception 0 to an interrupt gate
d72fa10: i386: prepare to convert exceptions to interrupts
b5721fe9: i386: remove kprobes' restore_interrupts in favour of conditional_sti
