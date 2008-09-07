Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYIGPqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYIGPqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 11:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYIGPpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 11:45:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbYIGPpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 11:45:54 -0400
Date: Sun, 7 Sep 2008 17:45:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/kernel/smpboot.c: Clarify when irq processing
	begins.
Message-ID: <20080907154543.GB31025@elte.hu>
References: <200809070952.m879qXHi012439@mail.q-ag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809070952.m879qXHi012439@mail.q-ag.de>
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


* Manfred Spraul <manfred@colorfullife.com> wrote:

> Secondary cpus start with local interrupts disabled.
> start_secondary() first initializes the new cpu, then it enables the
> local interrupts. (although interrupts are enabled within smp_callin()
> as well).
> Right now, the local interrupts are enabled as a side effect of calling
> ipi_call_lock_irq().
> 
> The attached patch clarifies when local interrupts are enabled.

applied to tip/x86/core, thanks Manfred.

[ btw., i fixed this typo:

  > Signed-of-By: Manfred Spraul <manfred@colorfullife.com>
    Signed-off-by

  "git commit -s" will add your signoff automatically. ]

	Ingo
