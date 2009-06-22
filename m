Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZFVBlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZFVBlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 21:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZFVBlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 21:41:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:57299 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZFVBlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 21:41:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,264,1243839600"; 
   d="scan'208";a="424137832"
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090621134635.GA2980@gondor.apana.org.au>
References: <20090621134635.GA2980@gondor.apana.org.au>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 09:41:16 +0800
Message-Id: <1245634876.22246.320.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 21:46 +0800, Herbert Xu wrote:
> Huang Ying <ying.huang@intel.com> wrote:
> >
> > +       ghash = crypto_alloc_ahash("ghash", 0, 0);
> > +       if (IS_ERR(ghash))
> > +               return PTR_ERR(ghash);
> 
> We should add this as an extra parameter to gcm_base.  This is
> so that the user can select an alternative ghash implementation.

Can crypto_alloc_ahash("ghash",...) select among different ghash
implementation automatically based on priority? I think
crypto_alloc_ablkcipher("cbc(aes)",...) can select among different AES
implementation automatically. They are different?

Best Regards,
Huang Ying


