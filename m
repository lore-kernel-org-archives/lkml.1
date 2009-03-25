Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZCYWCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZCYWCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbZCYWCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:02:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35390 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZCYWCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:02:19 -0400
Date: Wed, 25 Mar 2009 23:01:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325220149.GB21111@elte.hu>
References: <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au> <20090324.191134.05205089.davem@davemloft.net> <20090325073349.GF25833@elte.hu> <20090325120840.GA6351@gondor.apana.org.au> <20090325122046.GD11571@elte.hu> <20090325122635.GA6489@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325122635.GA6489@gondor.apana.org.au>
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


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Mar 25, 2009 at 01:20:46PM +0100, Ingo Molnar wrote:
> > 
> > ok - i have started testing the delta below, on top of the plain 
> > revert.

it's still fine btw, so:

Tested-by: Ingo Molnar <mingo@elte.hu>

> Thanks! BTW Ingo, any chance you could help us identify the 
> problem with the previous patch? I don't have a forcedeth machine 
> here and the hang you had with my patch that open-coded 
> __napi_complete appears intimately connected to forcedeth (with 
> NAPI enabled).
> 
> The simplest thing to try would be to build forcedeth.c with DEBUG
> and see what it prints out after it locks up.

Sure, can try that. Probably the best would be if you sent me a 
combo patch with the precise patch you meant me to try (there were 
several patches, i'm not sure which one is the 'previous' one) plus 
the forcedeth debug enable change as well.

Thanks,

	Ingo
