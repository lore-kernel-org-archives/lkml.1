Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYDXAwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYDXAwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYDXAwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:52:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41769 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753142AbYDXAwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:52:09 -0400
Date: Thu, 24 Apr 2008 08:51:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Message-ID: <20080424005152.GB5154@gondor.apana.org.au>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <20080416184016.GA21365@Chamillionaire.breakpoint.cc> <1208397123.4322.21.camel@caritas-dev.intel.com> <20080417033402.GB3394@gondor.apana.org.au> <20080423222843.GA16683@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423222843.GA16683@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 12:28:43AM +0200, Sebastian Siewior wrote:
> >> __crt_ctx in crypto_tfm is aligned in CRYPTO_MINALIGN. So I think adding
> >> a pad is sufficient for x86_64 implementation.
> >
> >It should be sufficient but it would be better to use an align
> Doesn't this imply that kmalloc() returns memory that is always pointer
> aligned what isn't the case AFAIK?

Parse error :)

kmalloc returns memory that should always be aligned to
CRYPTO_MINALIGN and in particular it's always pointer aligned.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
