Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZCIIWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZCIIWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZCIIUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:20:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:37109 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZCIIUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:20:32 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 8/8] EDAC: AMD8131 driver Kconfig & Makefile
Date: Mon,  9 Mar 2009 16:08:17 +0800
Message-Id: <1236586097-3830-9-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1236586097-3830-8-git-send-email-qingtao.cao@windriver.com>
References: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-3-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-4-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-5-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-6-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-7-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-8-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 09 Mar 2009 08:20:29.0572 (UTC) FILETIME=[E8598C40:01C9A08F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce Kconfig and Makefile options for AMD8131 EDAC driver.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/Kconfig  |    7 +++++++
 drivers/edac/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 46f8e77..13ccec6 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -181,4 +181,11 @@ config EDAC_AMD8111
 	  Support for error detection and correction on the
 	  AMD8111 HyperTransport I/O Hub chip.
 
+config EDAC_AMD8131
+	tristate "AMD8131 HyperTransport PCI-X Tunnel"
+	depends on EDAC_MM_EDAC && PCI
+	help
+	  Support for error detection and correction on the
+	  AMD8131 HyperTransport PCI-X Tunnel chip.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index c324956..407601f 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -35,4 +35,5 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
+obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
 
-- 
1.5.6.2

