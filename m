Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYKJJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYKJJyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYKJJxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:53:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbYKJJxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:53:49 -0500
Date: Mon, 10 Nov 2008 10:53:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparse_irq aka dyn_irq v10
Message-ID: <20081110095331.GC15237@elte.hu>
References: <20081107081249.GB4435@elte.hu> <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <49180418.1050306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49180418.1050306@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0498]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> +#ifdef CONFIG_SPARSE_IRQ
> +static void uv_ack_apic_wrapper(unsigned int irq, struct irq_desc **descp)
> +#else
> +static void uv_ack_apic_wrapper(unsigned int irq)
> +#endif

hm, why not change it to the new prototype unconditionally? (just pass 
in NULL or so)

	Ingo
