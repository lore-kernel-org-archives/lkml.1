Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZFUNva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZFUNva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZFUNvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:51:21 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58748 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751916AbZFUNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:51:20 -0400
Date: Sun, 21 Jun 2009 21:51:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Message-ID: <20090621135121.GA3153@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244704280.5320.131.camel@yhuang-dev.sh.intel.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> wrote:
> PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> carry-less multiplication. More information about PCLMULQDQ can be
> found at:
> 
> http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> 
> Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> kernel_fpu_begin/end, which can be used only in process context, the
> acceleration is implemented as crypto_ahash. That is, request in soft
> IRQ context will be deferred to the cryptd kernel thread.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

All good.

So once we fully convert everything to shash, this series can
go in with the minor changes mentioned in this thread.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
