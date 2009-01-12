Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZALDHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZALDHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZALDGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:06:54 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46183 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071AbZALDGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:06:53 -0500
Date: Mon, 12 Jan 2009 14:06:45 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Message-ID: <20090112030645.GA2651@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com> <20090109070144.GA7358@gondor.apana.org.au> <1231491273.5937.94.camel@yhuang-dev.sh.intel.com> <20090109091814.GA10881@gondor.apana.org.au> <20090110100823.GA22352@gondor.apana.org.au> <1231727423.5937.101.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231727423.5937.101.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 10:30:23AM +0800, Huang Ying wrote:
>
> With this method, we can allocate only one cryptd tfm internally,
> without dedicated blkcipher tfm. If kernel is using FPU, crypd tfm is
> used, otherwise, the underlying blkcipher tfm is used directly.

I'm not sure what you're saying here.  But the blkcipher object
is reentrant.  Meaning that it can be used simultaneously on two
CPUs as long as you don't change the key under it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
