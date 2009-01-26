Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbZAZMmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbZAZMmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZAZMmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:42:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZAZMmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:42:07 -0500
Date: Mon, 26 Jan 2009 13:41:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make irqinit_32.c more like irqoinit_64.c
Message-ID: <20090126124140.GA5812@elte.hu>
References: <497C4111.8030904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497C4111.8030904@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: cleanup
> 
> 1. add smp_intr_init and apic_intr_init for 32bit the same as 64bit
> 2. move apic_intr_init() calling before set gate with interrupt[i]
> 3. for 64bit, if ia32_emulation is not used, will make per_cpu to use 0x80 vector.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/irqinit_32.c |   56 +++++++++++++++++++++++++------------------
>  arch/x86/kernel/irqinit_64.c |    7 +++--
>  arch/x86/kernel/traps.c      |   15 ++++-------
>  3 files changed, 43 insertions(+), 35 deletions(-)

applied, thanks Yinghai!

Are you aiming for a full unification of them as well? The two files are 
very close to each other now.

	Ingo
