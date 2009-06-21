Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZFUNqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZFUNqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZFUNqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:46:37 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41723 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259AbZFUNqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:46:37 -0400
Date: Sun, 21 Jun 2009 21:46:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
Message-ID: <20090621134635.GA2980@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244704228.5320.125.camel@yhuang-dev.sh.intel.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> wrote:
>
> +       ghash = crypto_alloc_ahash("ghash", 0, 0);
> +       if (IS_ERR(ghash))
> +               return PTR_ERR(ghash);

We should add this as an extra parameter to gcm_base.  This is
so that the user can select an alternative ghash implementation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
