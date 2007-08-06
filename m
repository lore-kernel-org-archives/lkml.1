Return-Path: <linux-kernel-owner+w=401wt.eu-S1760489AbXHFHqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489AbXHFHqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbXHFHqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:46:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbXHFHqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:46:20 -0400
Date: Mon, 6 Aug 2007 09:46:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: convert mm_context_t semaphore to a mutex
Message-ID: <20070806074608.GA12415@elte.hu>
References: <20070803105540.4f85ae09@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803105540.4f85ae09@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  typedef struct { 
>  	int size;
> -	struct semaphore sem;
> +	struct mutex lock;

hm, looks good to me but i'm wondering why this was a holdout for such a 
long time :-) Did you manage to test actual LDT functionality with this 
patch applied?

	Ingo
