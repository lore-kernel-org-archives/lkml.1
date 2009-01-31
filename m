Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZAaDSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZAaDSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZAaDSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:18:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZAaDSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:18:23 -0500
Date: Sat, 31 Jan 2009 04:18:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: move default_ipi_xx back to ipi.c
Message-ID: <20090131031811.GA541@elte.hu>
References: <4983A977.5050208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4983A977.5050208@kernel.org>
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

> Impact: cleanup
> 
> only leave _default_ipi_xx etc in .h
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/hw_irq.h |    6 --
>  arch/x86/include/asm/ipi.h    |  123 +++---------------------------------------
>  arch/x86/kernel/ipi.c         |  108 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 117 insertions(+), 120 deletions(-)

Applied to tip/x86/apic, thanks Yinghai!

	Ingo
