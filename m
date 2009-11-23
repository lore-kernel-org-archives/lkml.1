Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZKWM0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZKWM0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbZKWM0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:26:20 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:57074 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756997AbZKWM0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:26:19 -0500
Date: Mon, 23 Nov 2009 20:26:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Jarod Wilson <jarod@redhat.com>, David Miller <davem@davemloft.net>,
       linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: move fips_cprng_get_random and
	fips_cprng_reset to CONFIG_CRYPTO_FIPS
Message-ID: <20091123122609.GF6424@gondor.apana.org.au>
References: <1258725019.3562.3.camel@ht.satnam> <20091120153801.GB21197@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091120153801.GB21197@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:38:01AM -0500, Neil Horman wrote:
> On Fri, Nov 20, 2009 at 07:20:19PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > fips_cprng_get_random and fips_cprng_reset is used only by
> > CONFIG_CRYPTO_FIPS. This also fixes compilation warnings:
> > 
> >  crypto/ansi_cprng.c:360: warning: ‘fips_cprng_get_random’ defined but not used
> >  crypto/ansi_cprng.c:393: warning: ‘fips_cprng_reset’ defined but not used
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Yeah, looks good to me, thanks!
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
