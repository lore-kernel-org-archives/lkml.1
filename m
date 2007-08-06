Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbXHFPZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbXHFPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764148AbXHFPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:25:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831AbXHFPZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:25:13 -0400
Date: Mon, 6 Aug 2007 17:25:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: convert mm_context_t semaphore to a mutex
Message-ID: <20070806152502.GA6988@elte.hu>
References: <20070803105540.4f85ae09@localhost> <20070806074608.GA12415@elte.hu> <20070806103615.4be4670f@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806103615.4be4670f@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br> wrote:

> | hm, looks good to me but i'm wondering why this was a holdout for 
> | such a long time :-) Did you manage to test actual LDT functionality 
> | with this patch applied?
> 
>  No, I didn't. The only test I did was to run the kernel with this 
> patch applied.
> 
>  I'll manage to test it then. Do you have a test-case or has any 
> suggestion?

i think try any pthread program with:

   export LD_ASSUME_KERNEL=2.4.0

should trigger the LDT code. Try stracing the code and modify_ldt calls 
should show up.

>  Oh, btw, I forgot to 'quilt add arch/i386/mm/fault.c' [...]

heh. After a dozen of such incidents i scripted my editor command to 
automatically do the quilt add :)

	Ingo
