Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYKJHmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYKJHmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYKJHmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:42:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYKJHmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:42:15 -0500
Date: Mon, 10 Nov 2008 08:42:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: x86_32 has its own irq_regs definition
Message-ID: <20081110074201.GA2093@elte.hu>
References: <1226294895.5478.5.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226294895.5478.5.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Impact: prevent second percpu define of unused irq_regs
> 
> Arches that have their own irq_regs definition are expected to
> define ARCH_HAS_OWN_IRQ_REGS or else a generic (unused) set
> will also be defined in lib/irq_regs.c
> 
> Sparse noticed the unused generic one had no prototype:
> lib/irq_regs.c:15:1: warning: symbol 'per_cpu____irq_regs' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/x86/include/asm/irq_regs_32.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

applied to tip/x86/cleanups, thanks Harvey!

	Ingo
