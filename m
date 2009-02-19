Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbZBSBr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbZBSBr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZBSBrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:47:17 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:46113 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZBSBrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:47:16 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] w1: add missing Kconfig/Makefile entries for DS2431 slave driver
Date: Wed, 18 Feb 2009 22:47:12 -0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-desktop-0.rc5.0mnb; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182247.12494.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/w1/slaves/Kconfig  |    6 ++++++
 drivers/w1/slaves/Makefile |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index 8d0b1fb..1f51366 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -16,6 +16,12 @@ config W1_SLAVE_SMEM
 	  Say Y here if you want to connect 1-wire
 	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
 
+config W1_SLAVE_DS2431
+	tristate "1kb EEPROM family support (DS2431)"
+	help
+	  Say Y here if you want to use a 1-wire
+	  1kb EEPROM family device (DS2431)
+
 config W1_SLAVE_DS2433
 	tristate "4kb EEPROM family support (DS2433)"
 	help
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index 990f400..f1f51f1 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
+obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
 obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
-- 
1.6.1.3

