Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZABNCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZABNCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbZABNBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:01:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbZABNBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:01:52 -0500
Date: Fri, 2 Jan 2009 14:01:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ingo Brueckl <ib@wupperonline.de>
Cc: Jesper Juhl <jj@chaosbits.net>, Tom Spink <tspink@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compile time warnings
Message-ID: <20090102130140.GA30190@elte.hu>
References: <20090102095727.GH1975@elte.hu> <495e0d52@wupperonline.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495e0d52@wupperonline.de>
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


* Ingo Brueckl <ib@wupperonline.de> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
>  > Would you mind to send a patch for that that we could push to Linus?
> 
> Do you mean something like:
> 
> fix compiler warning in arch/x86/mm/init_32.c

yes, with a small nit:
> 
> +static inline void permanent_kmaps_init(pgd_t *pgd_base)
> +{
> +	(void) pgd_base;

there's no need for this line - this is not a macro, so the function 
parameter does not have to be 'used'.

	Ingo
