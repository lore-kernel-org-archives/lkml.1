Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXFSWtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXFSWtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXFSWtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:49:04 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:56152 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372AbXFSWtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:49:00 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 00:49:32 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 4/12] acpi: select ACPI_EC for MSI_LAPTOP
Message-ID: <20070619224932.GF5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:48:36.0667 (UTC)
 FILETIME=[F8D8C0B0:01C7B2C3]
X-WSS-ID: 6A6682D923K845633-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kernel build problem as MSI_LAPTOP depends on ACPI_EC.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/misc/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 72774c9..0d6f369 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -99,8 +99,8 @@ config ASUS_LAPTOP
 
 config MSI_LAPTOP
         tristate "MSI Laptop Extras"
-        depends on X86
-        depends on ACPI_EC
+        depends on X86 && ACPI
+        select ACPI_EC
         depends on BACKLIGHT_CLASS_DEVICE
         ---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
-- 
1.5.0.7




