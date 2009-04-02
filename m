Return-Path: <linux-kernel-owner+w=401wt.eu-S934779AbZDBGKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934779AbZDBGKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZDBGJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:09:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:41532 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZDBGJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:09:48 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v0 PATCH 3/5] EDAC: Add CPC925 driver Kconfig & Makefile
Date: Thu,  2 Apr 2009 14:07:18 +0800
Message-Id: <1238652440-9224-4-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com>
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-2-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 02 Apr 2009 06:09:44.0790 (UTC) FILETIME=[9E68CF60:01C9B359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce Kconfig and Makefile options for CPC925 EDAC driver.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/Kconfig  |    9 +++++++++
 drivers/edac/Makefile |    1 +
 2 files changed, 10 insertions(+)

--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -188,4 +188,13 @@ config EDAC_AMD8131
 	  Support for error detection and correction on the
 	  AMD8131 HyperTransport PCI-X Tunnel chip.
 
+config EDAC_CPC925
+	tristate "IBM CPC925 Memory Controller (PPC970FX)"
+	depends on EDAC_MM_EDAC
+	help
+	  Support for error detection and correction on the
+	  IBM CPC925 Bridge and Memory Controller, which is
+	  a companion chip to the PowerPC 970 family of
+	  processors.
+
 endif # EDAC
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -36,4 +36,5 @@ obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_e
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
 obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
+obj-$(CONFIG_EDAC_CPC925)		+= cpc925_edac.o
 
