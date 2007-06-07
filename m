Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbXFGG4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbXFGG4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXFGG4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:56:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43806 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbXFGG4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:56:45 -0400
Date: Thu, 7 Jun 2007 08:54:50 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
In-Reply-To: <20070606164202.a3dcd176.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
 <200706062132.37430.m.kozlowski@tuxland.pl> <20070606132439.3f59f0cf.akpm@linux-foundation.org>
 <20070606212831.GA1534@gondor.apana.org.au> <20070606164202.a3dcd176.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6 2007 16:42, Andrew Morton wrote:

>> If so then you sent to it me :)
>
>You merged it ;)
>
>> Should I drop it?
>
>Sure, Jan will fix it up, I assume.  I might have broken it while repairing
>the reject storm which occurred when that durned HAS_IOMEM thing went in
>all over the tree.

/me points at Herbert
Andrew would not add options between the "menuconfig CRYPTO" and
the "if CRYPTO" line... :)


	Jan


===

Unbreak the crypto menu breakage.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 crypto/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4/crypto/Kconfig
===================================================================
--- linux-2.6.22-rc4.orig/crypto/Kconfig
+++ linux-2.6.22-rc4/crypto/Kconfig
@@ -7,6 +7,8 @@ menuconfig CRYPTO
 	help
 	  This option provides the core Cryptographic API.
 
+if CRYPTO
+
 #
 # Generic algorithms support
 #
@@ -18,8 +20,6 @@ config XOR_BLOCKS
 #
 source "crypto/async_tx/Kconfig"
 
-if CRYPTO
-
 config CRYPTO_ALGAPI
 	tristate
 	help
