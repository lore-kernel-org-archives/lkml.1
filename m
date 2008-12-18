Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751481AbYLRGTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbYLRGTW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYLRGTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:19:11 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46805 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbYLRGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:19:10 -0500
Date: Thu, 18 Dec 2008 17:19:08 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/8] crypto: compress - Add pcomp interface
Message-ID: <20081218061908.GB27951@gondor.apana.org.au>
References: <20081217163634.998961917@vixen.sonytel.be> <20081217164036.539681327@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217164036.539681327@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 05:36:37PM +0100, Geert Uytterhoeven wrote:
>
> @@ -3,7 +3,7 @@
>  #
>  
>  obj-$(CONFIG_CRYPTO) += crypto.o
> -crypto-objs := api.o cipher.o digest.o compress.o
> +crypto-objs := api.o cipher.o digest.o compress.o pcompress.o

Sorry, you modelled it on the wrong type.  These are the original
and obsolete types.  You should model it on one of the others.  I
recommend the crypto_shash type which is most recent.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
