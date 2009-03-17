Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbZCQDkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbZCQDkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757077AbZCQDj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:39:57 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:36115 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZCQDj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:39:56 -0400
Date: Tue, 17 Mar 2009 00:39:49 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org, galak@kernel.crashing.org
Subject: [PATCH] powerpc: mention that standard Kuroboxes are actively
	tested
Message-ID: <20090317033948.GA31544@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update the documentation regarding the Kurobox'es to mention
that they are also tested on the Standard Kurobox (not only on
the Kurobox HG).


Signed-off By: Rogério Brito <rbrito@ime.usp.br>

---

--- linux/arch/powerpc/platforms/embedded6xx/Kconfig~	2008-12-29 15:25:41.000000000 -0200
+++ linux/arch/powerpc/platforms/embedded6xx/Kconfig	2009-03-17 00:11:31.000000000 -0300
@@ -3,7 +3,7 @@ config EMBEDDED6xx
 	depends on PPC32 && BROKEN_ON_SMP && PPC_MULTIPLATFORM
 
 config LINKSTATION
-	bool "Linkstation / Kurobox(HG) from Buffalo"
+	bool "Linkstation / Kurobox (HD/HG) from Buffalo"
 	depends on EMBEDDED6xx
 	select MPIC
 	select FSL_SOC
@@ -14,9 +14,10 @@ config LINKSTATION
 	help
 	  Select LINKSTATION if configuring for one of PPC- (MPC8241)
 	  based NAS systems from Buffalo Technology. So far only
-	  KuroboxHG has been tested. In the future classical Kurobox,
-	  Linkstation-I HD-HLAN and HD-HGLAN versions, and PPC-based
-	  Terastation systems should be supported too.
+	  the standard Kurobox (Kurobox HD) and the Kurobox HG has
+	  been tested. In the future, Linkstation-I HD-HLAN and
+	  HD-HGLAN versions, and PPC-based Terastation systems should
+	  be supported too.
 
 config STORCENTER
 	bool "IOMEGA StorCenter"
