Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbZBIIOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbZBIIOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZBIIOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:14:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56054 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZBIIOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:14:35 -0500
Date: Mon, 9 Feb 2009 09:14:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: optimizing nr_irqs -v2
Message-ID: <20090209081421.GD24420@elte.hu>
References: <498CCEDB.8050708@kernel.org> <498CCF28.3050207@kernel.org> <498EA964.2070902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498EA964.2070902@kernel.org>
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
> Impact: more depend on cards to be used
> 
> depend on nr_irq_gsi more, and have a ratio for MSI
> 
> v2: make nr_irqs shoule less than NR_VECTORS * nr_cpu_ids
>    aka if only one cpu, we only can support nr_irqs = NR_VECTORS
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/io_apic.c |   16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)

Applied to tip/x86/apic, thanks Yinghai!

	Ingo
