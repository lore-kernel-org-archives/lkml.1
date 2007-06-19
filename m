Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbXFSWwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbXFSWwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbXFSWwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:52:13 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:10122 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761119AbXFSWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:52:10 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 00:52:25 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 12/12] acpi: select ACPI_EC for SONY_LAPTOP
Message-ID: <20070619225225.GN5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:51:29.0374 (UTC)
 FILETIME=[5FC9BFE0:01C7B2C4]
X-WSS-ID: 6A6681851S4852509-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kernel build problem as SONY_LAPTOP depends on ACPI_EC.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0d6f369..463fa41 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -119,6 +119,7 @@ config MSI_LAPTOP
 config SONY_LAPTOP
 	tristate "Sony Laptop Extras"
 	depends on X86 && ACPI
+	select ACPI_EC
 	select BACKLIGHT_CLASS_DEVICE
 	  ---help---
 	  This mini-driver drives the SNC and SPIC devices present in the ACPI
-- 
1.5.0.7




