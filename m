Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZFDSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZFDSOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZFDSN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:13:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZFDSN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A9iwUN5TZqeauS37VRLom4aXWfkYxlOC56dh56gEW+Gsgwg0aqd3xA1EMq6r025/kx
         n226Y6GtrT4KctJuME8JTNy84VQatydxc+osNK8g4phueJMvPslpzLrSbkA1qsMGztM8
         DqkyZU1PDEow6wLrgm9gCeLEJI5BJwIX2RQy4=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Philipp Zabel <philipp.zabel@gmail.com>, Ian Molton <spyro@f2s.com>
Subject: [PATCH 7/7] mmc: tmio_mmc: allow compilation for ASIC3
Date: Thu,  4 Jun 2009 20:12:37 +0200
Message-Id: <1244139157-16404-8-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now tmio_mmc is able to drive the MMC/SD cell in ASIC3.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ian Molton <spyro@f2s.com>
---
 drivers/mmc/host/Kconfig    |    4 ++--
 drivers/mmc/host/tmio_mmc.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index b4cf691..9aae7f5 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -237,7 +237,7 @@ config MMC_SDRICOH_CS
 
 config MMC_TMIO
 	tristate "Toshiba Mobile IO Controller (TMIO) MMC/SD function support"
-	depends on MFD_TMIO
+	depends on MFD_TMIO || MFD_ASIC3
 	help
 	  This provides support for the SD/MMC cell found in TC6393XB,
-	  T7L66XB and also ipaq ASIC3
+	  T7L66XB and also HTC ASIC3.
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 9f6e180..9f68c2f 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -10,7 +10,7 @@
  *
  * Driver for the MMC / SD / SDIO cell found in:
  *
- * TC6393XB TC6391XB TC6387XB T7L66XB
+ * TC6393XB TC6391XB TC6387XB T7L66XB ASIC3
  *
  * This driver draws mainly on scattered spec sheets, Reverse engineering
  * of the toshiba e800  SD driver and some parts of the 2.4 ASIC3 driver (4 bit
-- 
1.6.3.1

