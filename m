Return-Path: <linux-kernel-owner+w=401wt.eu-S1946588AbXBIPl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946588AbXBIPl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946559AbXBIPku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:40:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946547AbXBIPe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OPZ7kDrPFqdBuvhr09cusF3DFhiDQJIn0eHBgsBtH7E9bDapbACfgsUaG79nc8Ufcxp4ZguOU8VZxOg09iSflauGBu4m7ZzHShaw/zEq9CVVk95+xgbjKOUE4VoySmvPTfOte4j9CDPztyzRF4X1GGdD1uF/J/6DXQs5yAaBILc=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, herbert@gondor.apana.org.au,
       davem@davemloft.net
Subject: [PATCH 21/34] __initdata cleanup - aes
Date: Fri, 9 Feb 2007 17:25:58 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091725.58885.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/crypto/aes.c linux-2.6.20-rc6-mm3/crypto/aes.c
--- linux-2.6.20-rc6-mm3.org/crypto/aes.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/crypto/aes.c	2007-01-31 22:19:30.000000000 +0200
@@ -81,10 +81,10 @@ struct aes_ctx {
 #define E_KEY (&ctx->buf[0])
 #define D_KEY (&ctx->buf[60])
 
-static u8 pow_tab[256] __initdata;
-static u8 log_tab[256] __initdata;
-static u8 sbx_tab[256] __initdata;
-static u8 isb_tab[256] __initdata;
+static u8 pow_tab[256] __initdata = {0};
+static u8 log_tab[256] __initdata = {0};
+static u8 sbx_tab[256] __initdata = {0};
+static u8 isb_tab[256] __initdata = {0};
 static u32 rco_tab[10];
 static u32 ft_tab[4][256];
 static u32 it_tab[4][256];
