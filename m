Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbXFGHBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbXFGHBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbXFGHBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:01:22 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3093 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203AbXFGHBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:01:21 -0400
Date: Thu, 7 Jun 2007 17:01:08 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607070108.GA8013@gondor.apana.org.au>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <200706062132.37430.m.kozlowski@tuxland.pl> <20070606132439.3f59f0cf.akpm@linux-foundation.org> <20070606212831.GA1534@gondor.apana.org.au> <20070606164202.a3dcd176.akpm@linux-foundation.org> <Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 08:54:50AM +0200, Jan Engelhardt wrote:
> 
> /me points at Herbert
> Andrew would not add options between the "menuconfig CRYPTO" and
> the "if CRYPTO" line... :)

Actually this patch is not even in my tree :)

> Index: linux-2.6.22-rc4/crypto/Kconfig
> ===================================================================
> --- linux-2.6.22-rc4.orig/crypto/Kconfig
> +++ linux-2.6.22-rc4/crypto/Kconfig
> @@ -7,6 +7,8 @@ menuconfig CRYPTO
>  	help
>  	  This option provides the core Cryptographic API.
>  
> +if CRYPTO
> +
>  #
>  # Generic algorithms support
>  #
> @@ -18,8 +20,6 @@ config XOR_BLOCKS
>  #
>  source "crypto/async_tx/Kconfig"

Andrew, do you want me to pick the async_tx stuff up instead?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
