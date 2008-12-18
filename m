Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752822AbYLRKaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYLRKaA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYLRK3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:29:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYLRK3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:29:49 -0500
Date: Thu, 18 Dec 2008 11:29:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: signal: move ia32 func declarations into
	arch/x86/kernel/signal.c
Message-ID: <20081218102934.GC10513@elte.hu>
References: <4949B9B5.2050701@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4949B9B5.2050701@ct.jp.nec.com>
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


I have applied your patches to tip/x86/signal:

 d98f9d8: x86: ia32_signal: use sigframe.h
 3b0d29e: x86: ia32_signal: rename struct sigframe and rt_sigframe
 c85c2ff: x86: signal: prepare to include from ia32_signal.c
 41af86f: x86: signal: move sigframe.h to arch/x86/include/asm
 a5c56eb: x86: signal: rename sigframe and rt_sigframe on 32-bit
 f522376: x86: signal: move ia32 func declarations into arch/x86/kernel/signal.c

they are nice cleanups! Thanks,

	Ingo
