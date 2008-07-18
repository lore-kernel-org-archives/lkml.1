Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYGRWRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYGRWRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYGRWRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:17:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYGRWRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:17:36 -0400
Date: Sat, 19 Jul 2008 00:16:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, herbert@gondor.apana.org.au
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
Message-ID: <20080718221614.GA31073@elte.hu>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715.134407.150543177.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 15 Jul 2008 13:33:04 +0200
> 
> > i have just triggered this crash too. Please, when you know about bootup 
> > crashes in your code send a patch to the lkml thread so that people can 
> > apply it and have a working system.
> > 
> > Note that the new crypto/prng.c driver has very bad quality:
> > 
> >   total: 45 errors, 21 warnings, 1 checks, 410 lines checked
> > 
> > It has tons of completely unacceptable code mistakes in it.
> 
> I think we should merge new drivers as aggressively as possible.

Correct.

	Ingo
