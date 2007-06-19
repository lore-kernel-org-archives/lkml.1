Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbXFSWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbXFSWte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760094AbXFSWtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:49:14 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:11366 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759584AbXFSWtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:49:11 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 00:48:58 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 3/12] acpi: fix compile error with ACPI && !ACPI_POWER
Message-ID: <20070619224858.GE5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:48:01.0728 (UTC)
 FILETIME=[E4057C00:01C7B2C3]
X-WSS-ID: 6A6682D31S4852267-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error with ACPI && !ACPI_POWER as bus.c
depends on power.c

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/acpi/Kconfig  |    4 ----
 drivers/acpi/Makefile |    2 +-
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 139f41f..9d6baab 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -288,10 +288,6 @@ config ACPI_EC
 	  the battery and thermal drivers.  If you are compiling for a 
 	  mobile system, say Y.
 
-config ACPI_POWER
-	bool
-	default y
-
 config ACPI_SYSTEM
 	bool
 	default y
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index d4336f1..9485cc3 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -48,7 +48,7 @@ obj-$(CONFIG_ACPI_DOCK)		+= dock.o
 obj-$(CONFIG_ACPI_BAY)		+= bay.o
 obj-$(CONFIG_ACPI_VIDEO)	+= video.o
 obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
-obj-$(CONFIG_ACPI_POWER)	+= power.o
+obj-y				+= power.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-- 
1.5.0.7




