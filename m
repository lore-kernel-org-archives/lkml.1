Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYGULEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYGULEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758342AbYGULEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:04:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280AbYGULEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:04:06 -0400
Date: Mon, 21 Jul 2008 13:03:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove extra calling to get ext cpuid level
Message-ID: <20080721110352.GB10782@elte.hu>
References: <200807210138.15054.yhlu.kernel@gmail.com> <200807210139.03635.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807210139.03635.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> --- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
> +++ linux-2.6/arch/x86/kernel/cpu/common_64.c
> @@ -303,7 +303,6 @@ static void __cpuinit early_identify_cpu
>  			c->x86_capability[2] = cpuid_edx(0x80860001);
>  	}
>  
> -	c->extended_cpuid_level = cpuid_eax(0x80000000);
>  	if (c->extended_cpuid_level >= 0x80000007)
>  		c->x86_power = cpuid_edx(0x80000007);

applied to tip/x86/core, thanks.

	Ingo
