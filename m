Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbYHEKoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbYHEKoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYHEKoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:44:14 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41970 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752226AbYHEKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:44:14 -0400
Date: Tue, 5 Aug 2008 18:44:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Message-ID: <20080805104409.GA21786@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain> <20080804141916.GC11415@gondor.apana.org.au> <1217930351.1613.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217930351.1613.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 05:59:11AM -0400, Austin Zhang wrote:
>
> How about:
> +config CRYPTO_CRC32C_INTEL
> +        tristate "CRC32c INTEL hardware acceleration"
> +       depends on X86
> +        select CRYPTO_ALGAPI
> +        help
> +          In Intel processor with SSE4.2 supported, the processor will
> ......
> 
> It should only depend on X86.

Yes that looks good.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
