Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZBIIPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZBIIPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZBIIPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:15:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52912 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZBIIPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:15:03 -0500
Date: Mon, 9 Feb 2009 09:14:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use NR_IRQS_LEGACY to replace 16
Message-ID: <20090209081453.GE24420@elte.hu>
References: <498CCEDB.8050708@kernel.org> <498E319C.6070005@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498E319C.6070005@kernel.org>
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
> also could kill platform_legacy_irq
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/hw_irq.h |    4 +---
>  arch/x86/kernel/io_apic.c     |    8 ++++----
>  2 files changed, 5 insertions(+), 7 deletions(-)

Applied to tip/x86/apic, thanks Yinghai!

	Ingo
