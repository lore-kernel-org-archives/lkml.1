Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbZCYM1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbZCYM1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZCYM1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:27:07 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:33711 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758033AbZCYM1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:27:05 -0400
Date: Wed, 25 Mar 2009 20:26:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325122635.GA6489@gondor.apana.org.au>
References: <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au> <20090324.191134.05205089.davem@davemloft.net> <20090325073349.GF25833@elte.hu> <20090325120840.GA6351@gondor.apana.org.au> <20090325122046.GD11571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325122046.GD11571@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 01:20:46PM +0100, Ingo Molnar wrote:
> 
> ok - i have started testing the delta below, on top of the plain 
> revert.

Thanks! BTW Ingo, any chance you could help us identify the problem
with the previous patch? I don't have a forcedeth machine here
and the hang you had with my patch that open-coded __napi_complete
appears intimately connected to forcedeth (with NAPI enabled).

The simplest thing to try would be to build forcedeth.c with DEBUG
and see what it prints out after it locks up.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
