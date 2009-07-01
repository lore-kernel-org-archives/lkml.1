Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZGAKRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZGAKRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZGAKRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:17:44 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:34921 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZGAKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to:cc
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=FLzEtvEtC2XiCq0FDhdSL8vc2I3DT4QSD5jZA1K1ko5NkmaIua/shW2jDHrh9P2ROv
         M+Qkq1nz6MaXKbP6/uAkVModFIxujx/v77X+P9ZYFXCVEJCbv8zNM1DvMcXkOBpyO9IQ
         6PdTUY1GpLvRCDTm1sbbaQZS3oZq/DUO1Fpio=
From: Florian Fainelli <florian@openwrt.org>
Date: Wed, 1 Jul 2009 12:17:44 +0200
Subject: [PATCH 2/2] VLYNQ: fix typo in Kconfig to enable debugging
MIME-Version: 1.0
X-Length: 1294
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011217.44807.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo in the VLYNQ bus driver Kconfig
which prevented to turn on VLYNQ bus debugging.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/vlynq/Kconfig b/drivers/vlynq/Kconfig
index f654221..a9efb16 100644
--- a/drivers/vlynq/Kconfig
+++ b/drivers/vlynq/Kconfig
@@ -13,7 +13,7 @@ config VLYNQ
 
 config VLYNQ_DEBUG
 	bool "VLYNQ bus debug"
-	depends on VLYNQ && KERNEL_DEBUG
+	depends on VLYNQ && DEBUG_KERNEL
 	help
 	  Turn on VLYNQ bus debugging.
 
