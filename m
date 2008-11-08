Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYKHJRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYKHJRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYKHJRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:17:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYKHJRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:17:38 -0500
Date: Sat, 8 Nov 2008 10:17:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: signal: cosmetic unification of setup_sigcontext()
Message-ID: <20081108091725.GD18215@elte.hu>
References: <491506B0.5030503@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491506B0.5030503@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Make setup_sigcontext() same.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/signal_32.c |   32 ++++++++++++++++++++++++++++----
>  arch/x86/kernel/signal_64.c |   33 ++++++++++++++++++++++++++++-----
>  2 files changed, 56 insertions(+), 9 deletions(-)

applied to tip/x86/signal, thanks!

(the 10 patches of yours that are already in tip/x86/signal are 
working perfectly)

	Ingo
