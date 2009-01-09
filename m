Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZAIG0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZAIG0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZAIG0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:26:08 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47277 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752760AbZAIG0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:26:06 -0500
Date: Fri, 9 Jan 2009 17:26:00 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH crypto 2/4] AES-NI: Export x86 AES encrypt/decrypt
	functions
Message-ID: <20090109062600.GA3133@gondor.apana.org.au>
References: <1231120935.5937.29.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231120935.5937.29.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:02:15AM +0800, Huang Ying wrote:
> Export x86 AES encrypt/decrypt functions
> 
> Intel AES-NI AES acceleration instructions touch XMM state, to use
> that in soft_irq context, general x86 AES implementation is used as
> fallback. The first parameter is changed from struct crypto_tfm * to
> struct crypto_aes_ctx * to make it easier to deal with 16 bytes
> alignment requirement of AES-NI implementation.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Also applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
