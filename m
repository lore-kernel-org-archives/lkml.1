Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbXLNIx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbXLNIx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXLNIxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:53:18 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1082 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762799AbXLNIxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:53:17 -0500
Date: Fri, 14 Dec 2007 16:53:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: bbpetkov@yahoo.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: (was Re: 2.6.24-rc5-mm1) crypto/authenc.c select symbol in Kconfig
Message-ID: <20071214085312.GA15864@gondor.apana.org.au>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <20071213174636.GA30228@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213174636.GA30228@gollum.tnic>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 06:46:37PM +0100, Borislav Petkov wrote:
>
> which fails because crypto_hash_type is declared in crypto/hash.c. You might wanna
> fix it like so:
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

Patch applied.  Thanks for picking this up.

> --- crypto/Kconfig.orig	2007-12-13 18:44:19.000000000 +0100
> +++ crypto/Kconfig	2007-12-13 18:39:00.000000000 +0100

BTW please generate patch -p1 patches in future.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
