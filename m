Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZCKDj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZCKDj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 23:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZCKDin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 23:38:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:40110 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbZCKDim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 23:38:42 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v2 PATCH 3/7] EDAC: AMD8111 driver Kconfig and Makefile
Date: Wed, 11 Mar 2009 11:25:53 +0800
Message-Id: <1236741957-3570-4-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1236741957-3570-3-git-send-email-qingtao.cao@windriver.com>
References: <1236741957-3570-1-git-send-email-qingtao.cao@windriver.com>
 <1236741957-3570-2-git-send-email-qingtao.cao@windriver.com>
 <1236741957-3570-3-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 11 Mar 2009 03:38:29.0163 (UTC) FILETIME=[D7D387B0:01C9A1FA]
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

