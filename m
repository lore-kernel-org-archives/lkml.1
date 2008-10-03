Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYJCIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYJCIKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYJCIKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:10:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49782 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbYJCIKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:10:00 -0400
Date: Fri, 3 Oct 2008 10:09:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: signal: move macros out from
	restore_sigcontext()
Message-ID: <20081003080944.GA32195@elte.hu>
References: <48E5A900.6090308@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E5A900.6090308@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> move macros, COPY, COPY_SEG*, GET_SEG, out from restore_sigcontext().
> x86_64: introduce COPY_SEG_STRICT for cs.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/signal_32.c |   38 +++++++++++++++++++++-----------------
>  arch/x86/kernel/signal_64.c |   18 +++++++++++-------
>  2 files changed, 32 insertions(+), 24 deletions(-)

applied to tip/x86/signal, thanks Hiroshi!

	Ingo
