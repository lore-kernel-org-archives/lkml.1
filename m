Return-Path: <linux-kernel-owner+w=401wt.eu-S1764239AbXEWLmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764239AbXEWLmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbXEWLmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:42:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758938AbXEWLmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:42:04 -0400
Date: Wed, 23 May 2007 13:40:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Patrick McHardy <kaber@trash.net>, Anant Nitya <kernel@prachanda.info>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070523114021.GA21880@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705221147.56571.kernel@prachanda.hub> <20070522062233.GA20002@elte.hu> <200705231110.44526.kernel@prachanda.hub> <20070523063052.GB26814@elte.hu> <46541DC4.4090501@trash.net> <20070523112559.GA24604@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523112559.GA24604@gondor.apana.org.au>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> [NET_SCHED]: Fix qdisc_restart return value when dequeue is empty
> 
> My previous patch that changed the return value of qdisc_restart 
> incorrectly made the case where dequeue returns empty continue 
> processing packets.
> 
> This patch is based on diagnosis and fix by Patrick McHardy.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

also:

  Reported-and-debugged-by: Anant Nitya <kernel@prachanda.info>

...

i gave your patch a quick test-boot and networking still works fine.

	Ingo
