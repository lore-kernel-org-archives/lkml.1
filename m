Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYKFV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYKFV0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKFVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:25:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYKFVZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:25:50 -0500
Date: Thu, 6 Nov 2008 22:25:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] enable wchan config menu item for x86-64
Message-ID: <20081106212540.GE24579@elte.hu>
References: <b040c32a0811061110g69b6cc6cta88774b72e5b9163@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811061110g69b6cc6cta88774b72e5b9163@mail.gmail.com>
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


* Ken Chen <kenchen@google.com> wrote:

> Ingo,
> 
> I don't know when will you phase out /proc/pid/wchan.  Can we enable the
> wchan config menu item for now on x86-64 arch?  This will at least allow
> people to enable/disable frame pointers on scheduler functions.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e60c59b..38f9fb9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -367,7 +367,7 @@ config X86_RDC321X
>  config SCHED_NO_NO_OMIT_FRAME_POINTER
>  	def_bool y
>  	prompt "Single-depth WCHAN output"
> -	depends on X86_32
> +	depends on X86

makes sense, i've added it to tip/sched/core, thanks Ken!

This will need some testing as we never did this on 64-bit, so it's 
definitely a v2.6.29 item.

	Ingo
