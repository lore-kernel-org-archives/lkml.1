Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYGRKVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYGRKVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYGRKVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:21:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbYGRKVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:21:07 -0400
Date: Fri, 18 Jul 2008 12:20:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use cpu_clear in remove_cpu_from_maps
Message-ID: <20080718102053.GU6875@elte.hu>
References: <200807172150.23463.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807172150.23463.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> --- linux-2.6.orig/arch/x86/kernel/smpboot.c
> +++ linux-2.6/arch/x86/kernel/smpboot.c
> @@ -1310,7 +1310,7 @@ static void __ref remove_cpu_from_maps(i
>  	cpu_clear(cpu, cpu_callout_map);
>  	cpu_clear(cpu, cpu_callin_map);
>  	/* was set by cpu_init() */
> -	clear_bit(cpu, (unsigned long *)&cpu_initialized);
> +	cpu_clear(cpu, cpu_initialized);

applied, thanks Yinghai.

	Ingo
