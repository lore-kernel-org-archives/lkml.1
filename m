Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZCZJ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZCZJ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZCZJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:26:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZCZJ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:26:08 -0400
Date: Thu, 26 Mar 2009 10:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326092543.GC9369@elte.hu>
References: <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au> <20090324.191134.05205089.davem@davemloft.net> <20090325073349.GF25833@elte.hu> <20090325120840.GA6351@gondor.apana.org.au> <20090325122046.GD11571@elte.hu> <20090325122635.GA6489@gondor.apana.org.au> <20090325220149.GB21111@elte.hu> <20090326090744.GA16665@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326090744.GA16665@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Mar 25, 2009 at 11:01:49PM +0100, Ingo Molnar wrote:
> > 
> > Sure, can try that. Probably the best would be if you sent me a 
> > combo patch with the precise patch you meant me to try (there were 
> > several patches, i'm not sure which one is the 'previous' one) plus 
> > the forcedeth debug enable change as well.
> 
> Sure, here's the patch to do both.

> diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> index b8251e8..101e552 100644
> --- a/drivers/net/forcedeth.c
> +++ b/drivers/net/forcedeth.c
> @@ -64,7 +64,7 @@
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
>  
> -#if 0
> +#if 1
>  #define dprintk			printk
>  #else
>  #define dprintk(x...)		do { } while (0)

The box is not even able to boot up, so many messages are printed.

	Ingo
