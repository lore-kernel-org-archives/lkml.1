Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbXFSWsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbXFSWsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759798AbXFSWrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:47:51 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:43504 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759621AbXFSWrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:47:48 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 00:48:36 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 2/12] acpi: select ACPI_EC for THINKPAD_ACPI
Message-ID: <20070619224836.GD5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:47:40.0118 (UTC)
 FILETIME=[D7240F60:01C7B2C3]
X-WSS-ID: 6A66828423K845538-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kernel build problem:

 thinkpad_acpi.c:(.text+0x7486a): undefined reference to `ec_write'

(as THINKPAD_ACPI depends on ACPI_EC)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2f2fbff..72774c9 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -139,6 +139,7 @@ config SONYPI_COMPAT
 config THINKPAD_ACPI
 	tristate "ThinkPad ACPI Laptop Extras"
 	depends on X86 && ACPI
+	select ACPI_EC
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	---help---
-- 
1.5.0.7




