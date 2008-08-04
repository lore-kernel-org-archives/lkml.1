Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYHDOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYHDOTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYHDOTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:19:21 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60722 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754294AbYHDOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:19:20 -0400
Date: Mon, 4 Aug 2008 22:19:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Message-ID: <20080804141916.GC11415@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217842507.20845.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 05:35:07AM -0400, Austin Zhang wrote:
>
> +config CRYPTO_CRC32C_INTEL
> +        tristate "CRC32c INTEL hardware acceleration"
> +        select CRYPTO_HASH

You need some sort of a dependency here.  See what the other
assembly algorithms do it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
