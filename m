Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZCIIUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZCIIUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZCIIUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:20:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:37079 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZCIIUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:20:23 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 1/8] EDAC: AMD8111 driver Kconfig & Makefile
Date: Mon,  9 Mar 2009 16:08:10 +0800
Message-Id: <1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
References: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 09 Mar 2009 08:20:17.0463 (UTC) FILETIME=[E121DC70:01C9A08F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce Kconfig and Makefile options for AMD8111 EDAC driver.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/Kconfig  |    7 +++++++
 drivers/edac/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index eee47fd..46f8e77 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -174,4 +174,11 @@ config EDAC_CELL
 	  Cell Broadband Engine internal memory controller
 	  on platform without a hypervisor
 
+config EDAC_AMD8111
+	tristate "AMD8111 HyperTransport I/O Hub"
+	depends on EDAC_MM_EDAC && PCI
+	help
+	  Support for error detection and correction on the
+	  AMD8111 HyperTransport I/O Hub chip.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index b751969..c324956 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -34,4 +34,5 @@ obj-$(CONFIG_EDAC_PASEMI)		+= pasemi_edac.o
 obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
+obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
 
-- 
1.5.6.2

