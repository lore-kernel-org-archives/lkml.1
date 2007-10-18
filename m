Return-Path: <linux-kernel-owner+w=401wt.eu-S1765464AbXJROgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765464AbXJROgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbXJROgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:36:31 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4785 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755955AbXJROg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:36:29 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: benh@kernel.crashing.org
Subject: Re: [PATCH] synchronize_irq needs a barrier
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Organization: Core
In-Reply-To: <1192675254.12879.29.camel@pasglop>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IiWTY-0000jx-00@gondolin.me.apana.org.au>
Date: Thu, 18 Oct 2007 22:35:52 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> Note that some kind of read barrier or compiler barrier should be needed
> regardless, or we are just not sync'ing with anything at all (we may
> have loaded the value ages ago and thus operate on a totally stale
> value). I prefer a full barrier to also ensure all previous stores are
> pushed out.

We already have a compiler barrier there in the form of cpu_relax.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
