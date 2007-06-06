Return-Path: <linux-kernel-owner+w=401wt.eu-S965129AbXFFV2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965129AbXFFV2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964865AbXFFV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:28:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1100 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964845AbXFFV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:28:40 -0400
Date: Thu, 7 Jun 2007 07:28:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@gmx.de>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070606212831.GA1534@gondor.apana.org.au>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <200706062132.37430.m.kozlowski@tuxland.pl> <20070606132439.3f59f0cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606132439.3f59f0cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 01:24:39PM -0700, Andrew Morton wrote:
>
> > And for some reason the whole Cryptographic API is under the main level of menu 
> > (please find .config and menu.png attached).
> 
> err, yes.  git-cryptodev.patch did that.  Herbert is being immodest ;)

Is it this patch? If so then you sent to it me :)

Should I drop it?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
commit a85e40c4a0d4fd87e3f9449faac98db0d7d6ac78
Author: Jan Engelhardt <jengelh@gmx.de>
Date:   Fri May 18 15:11:01 2007 +1000

    [CRYPTO] Kconfig: Use menuconfig objects

    Use menuconfigs instead of menus, so the whole menu can be disabled at once
    instead of going through all options.

    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

a85e40c4a0d4fd87e3f9449faac98db0d7d6ac78
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4ca0ab3..935301e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -2,9 +2,7 @@
 # Cryptographic API Configuration
 #
 
-menu "Cryptographic options"
-
-config CRYPTO
+menuconfig CRYPTO
 	bool "Cryptographic API"
 	help
 	  This option provides the core Cryptographic API.
@@ -463,5 +461,3 @@ config CRYPTO_TEST
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
-
-endmenu
