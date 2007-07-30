Return-Path: <linux-kernel-owner+w=401wt.eu-S939052AbXG3J2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939052AbXG3J2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934937AbXG3J2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:28:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839AbXG3J2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:28:04 -0400
Date: Mon, 30 Jul 2007 11:27:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 4/9] ifdef raise_softirq_irqoff wakeup
Message-ID: <20070730092751.GD25640@elte.hu>
References: <20070730024534.369897977@mvista.com> <20070730024719.782847315@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024719.782847315@mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> @@ -508,7 +508,9 @@ inline fastcall void raise_softirq_irqof
>  {
>  	__do_raise_softirq_irqoff(nr);
>  
> +#ifdef CONFIG_PREEMPT_SOFTIRQS
>  	wakeup_softirqd(nr);
> +#endif

thanks, applied. People rarely run the -rt kernel just to turn off 
PREEMPT_RT, that's why this bug was there ;-)

	Ingo
