Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYLPRsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYLPRsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYLPRrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:47:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55839 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbYLPRrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:47:53 -0500
Date: Tue, 16 Dec 2008 18:47:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: improve lazy TLB handling code
Message-ID: <20081216174739.GK11683@elte.hu>
References: <4947A342.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4947A342.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Use the faster x86_{read,write}_percpu() accessors here.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/include/asm/mmu_context_32.h |   13 ++++++-------
>  arch/x86/kernel/tlb_32.c              |   11 +++++------
>  2 files changed, 11 insertions(+), 13 deletions(-)

applied to tip/x86/mm - thanks,

	Ingo
