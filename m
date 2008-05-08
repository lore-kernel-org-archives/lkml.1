Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbYEHNJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbYEHNJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761240AbYEHNJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:09:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33057 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbYEHNJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:09:05 -0400
Date: Thu, 8 May 2008 15:08:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for
	PAT support
Message-ID: <20080508130838.GA13162@elte.hu>
References: <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org> <48226569.7010906@zytor.com> <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Subject: x86: cleanup PAT cpu validation
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 08 May 2008 09:18:43 +0200
> 
> Move the scattered checks for PAT support to a single function. Its 
> moved to addon_cpuid_features.c as this file is shared between 32 and 
> 64 bit.

thanks Thomas, i have applied your cleanup patch - looks good here too 
and it booted fine on a few boxes.

(i did a small cleanup: changed the define to static const int)

Peter, what are your plans for a more general cleanup and 32-bit/64-bit 
unification for the x86 CPU detection code - do you have any specific 
ideas already? I suspect we want it all to end up unified under 
arch/x86/kernel/cpu/, by moving the relevant bits of 
arch/x86/kernel/setup_64.c there, right? It is no small task for sure.

	Ingo
