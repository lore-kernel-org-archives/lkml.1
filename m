Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYANLU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYANLU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYANLUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:20:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbYANLUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:20:17 -0500
Date: Mon, 14 Jan 2008 12:20:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for git-x86] Export native_read_tsc
Message-ID: <20080114112005.GA1729@elte.hu>
References: <20080114111056.GA1659@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114111056.GA1659@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Otherwise modular tcrypt, kvm-intel have unresolved symbols.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux/arch/x86/kernel/rtc.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/rtc.c
> +++ linux/arch/x86/kernel/rtc.c
> @@ -200,3 +200,5 @@ unsigned long long native_read_tsc(void)
>  {
>  	return __native_read_tsc();
>  }
> +EXPORT_SYMBOL(native_read_tsc);

thanks, applied.

	Ingo
