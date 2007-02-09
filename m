Return-Path: <linux-kernel-owner+w=401wt.eu-S1946575AbXBIPnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946575AbXBIPnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946546AbXBIPer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946553AbXBIPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s//uzXXcpveDeQbvORVqhOQs6RR1sbTVjageKYdGqpmp0vubw8OU0xPbiJYxUYT6ZFoAv3i9iuRwVGvTPMOVqRxqFz++oAzzaAi1G6bxHVIq6ItmnZMlTQ+60Og5zapFfgeMfPVcnFezsHl7WGiGIL5a+h+Qqu7/R4/vo7VvwkY=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, paulus@samba.org
Subject: [PATCH 13/34] __initdata cleanup - ppc
Date: Fri, 9 Feb 2007 17:21:41 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091721.41777.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

**NOT TESTED***

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/bamboo.c linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/bamboo.c
--- linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/bamboo.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/bamboo.c	2007-01-31 22:19:30.000000000 +0200
@@ -50,7 +50,7 @@
 
 extern bd_t __res;
 
-static struct ibm44x_clocks clocks __initdata;
+static struct ibm44x_clocks clocks __initdata = {0};
 
 /*
  * Bamboo external IRQ triggering/polarity settings
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/ebony.c linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/ebony.c
--- linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/ebony.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/ebony.c	2007-01-31 22:19:30.000000000 +0200
@@ -53,7 +53,7 @@
 
 extern bd_t __res;
 
-static struct ibm44x_clocks clocks __initdata;
+static struct ibm44x_clocks clocks __initdata = {0};
 
 /*
  * Ebony external IRQ triggering/polarity settings
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/luan.c linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/luan.c
--- linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/luan.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/luan.c	2007-01-31 22:19:30.000000000 +0200
@@ -51,7 +51,7 @@
 
 extern bd_t __res;
 
-static struct ibm44x_clocks clocks __initdata;
+static struct ibm44x_clocks clocks __initdata = {0};
 
 static void __init
 luan_calibrate_decr(void)
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/ocotea.c linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/ocotea.c
--- linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/ocotea.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/ocotea.c	2007-01-31 22:19:30.000000000 +0200
@@ -51,7 +51,7 @@
 
 extern bd_t __res;
 
-static struct ibm44x_clocks clocks __initdata;
+static struct ibm44x_clocks clocks __initdata = {0};
 
 static void __init
 ocotea_calibrate_decr(void)
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/yucca.c linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/yucca.c
--- linux-2.6.20-rc6-mm3.org/arch/ppc/platforms/4xx/yucca.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ppc/platforms/4xx/yucca.c	2007-01-31 22:19:30.000000000 +0200
@@ -53,7 +53,7 @@
 
 extern bd_t __res;
 
-static struct ibm44x_clocks clocks __initdata;
+static struct ibm44x_clocks clocks __initdata = {0};
 
 static void __init
 yucca_calibrate_decr(void)
