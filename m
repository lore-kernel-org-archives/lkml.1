Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZKTPiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZKTPiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZKTPiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:38:22 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50400 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZKTPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:38:21 -0500
Date: Fri, 20 Nov 2009 10:38:01 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Jarod Wilson <jarod@redhat.com>,
       David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: move fips_cprng_get_random and
	fips_cprng_reset to CONFIG_CRYPTO_FIPS
Message-ID: <20091120153801.GB21197@hmsreliant.think-freely.org>
References: <1258725019.3562.3.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1258725019.3562.3.camel@ht.satnam>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.6 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 07:20:19PM +0530, Jaswinder Singh Rajput wrote:
> 
> fips_cprng_get_random and fips_cprng_reset is used only by
> CONFIG_CRYPTO_FIPS. This also fixes compilation warnings:
> 
>  crypto/ansi_cprng.c:360: warning: ‘fips_cprng_get_random’ defined but not used
>  crypto/ansi_cprng.c:393: warning: ‘fips_cprng_reset’ defined but not used
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Yeah, looks good to me, thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
