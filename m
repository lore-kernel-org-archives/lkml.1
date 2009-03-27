Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZC0Icj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZC0Icj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZC0IcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:32:20 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48534 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbZC0IcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:32:18 -0400
Date: Fri, 27 Mar 2009 16:32:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: Fix tfm allocation in
	cryptd_alloc_ablkcipher
Message-ID: <20090327083212.GA27903@gondor.apana.org.au>
References: <1236219920.24215.37.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236219920.24215.37.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 10:25:20AM +0800, Huang Ying wrote:
> Use crypto_alloc_base() instead of crypto_alloc_ablkcipher() to
> allocate underlying tfm in cryptd_alloc_ablkcipher. Because
> crypto_alloc_ablkcipher() prefer GENIV encapsulated crypto instead of
> raw one, while cryptd_alloc_ablkcipher needed the raw one.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Could you tell me why it has to be raw?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
