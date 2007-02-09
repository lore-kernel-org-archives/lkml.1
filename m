Return-Path: <linux-kernel-owner+w=401wt.eu-S1946586AbXBIPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946586AbXBIPha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946577AbXBIPfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946568AbXBIPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nz7DfetFNFp9dcDnf333w4/qJk89WDIu5nhm1jazHUBCMwcMN1L/f7a14AC4+ju42E5baxAzd4SMznQxcRLgWxzpisVOYrH/R7NRfUWbrisezzuLXCRq8aAY6PsFI31oKWRplg1fsziUbHBVXXitv2UJbGXHOHXVHy6ujBPWHDU=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, dwmw2@infradead.org
Subject: [PATCH 28/34] __initdata cleanup - mtd
Date: Fri, 9 Feb 2007 17:32:32 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091732.32854.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/mtd/devices/block2mtd.c linux-2.6.20-rc6-mm3/drivers/mtd/devices/block2mtd.c
--- linux-2.6.20-rc6-mm3.org/drivers/mtd/devices/block2mtd.c	2007-01-31 22:15:40.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/mtd/devices/block2mtd.c	2007-01-31 22:19:30.000000000 +0200
@@ -424,7 +424,7 @@ static inline void kill_final_newline(ch
 
 #ifndef MODULE
 static int block2mtd_init_called = 0;
-static __initdata char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
+static __initdata char block2mtd_paramline[80 + 12] = {0}; /* 80 for device, 12 for erase size */
 #endif
 
 
