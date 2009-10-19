Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZJSCxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZJSCxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 22:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbZJSCxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 22:53:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:53014 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755706AbZJSCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 22:53:31 -0400
Date: Mon, 19 Oct 2009 11:53:33 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Message-ID: <20091019025332.GA26624@gondor.apana.org.au>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 09:35:46AM +0800, Huang Ying wrote:
> PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> carry-less multiplication. More information about PCLMULQDQ can be
> found at:
> 
> http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> 
> Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> kernel_fpu_begin/end, which can be used only in process context, the
> acceleration is implemented as crypto_ahash. That is, request in soft
> IRQ context will be defered to the cryptd kernel thread.
> 
> v4:
>  - Fix some style issues.
> 
> v3:
>  - Revise GHASH implementation, performance increase about 2x.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
