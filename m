Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbZEaBam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbZEaBam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 21:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZEaBae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 21:30:34 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47992 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754148AbZEaBae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 21:30:34 -0400
Date: Sun, 31 May 2009 11:30:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver
Message-ID: <20090531013022.GA27930@gondor.apana.org.au>
References: <1243350141-883-1-git-send-email-anemo@mba.ocn.ne.jp> <20090529162907.9cb1bba2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529162907.9cb1bba2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 04:29:07PM -0700, Andrew Morton wrote:
>
> > +static u64 read_rng(void __iomem *base, unsigned int offset)
> > +{
> > +	/* Caller must disable interrupts */
> > +	return ____raw_readq(base + offset);
> > +}
> 
> What is the reasoning behind the local_irq_disable() requirement?
> 
> Because I'm wondering whether this is safe on SMP?

Yes I'd like to see this fixed before adding this patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
