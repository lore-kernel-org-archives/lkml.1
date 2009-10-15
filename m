Return-Path: <linux-kernel-owner+w=401wt.eu-S1763022AbZJOUT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763022AbZJOUT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763005AbZJOUT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:19:26 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:39614
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761537AbZJOUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:19:25 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 8/8] trivial: typo and grammar fixes in comments
Date: Thu, 15 Oct 2009 17:18:39 -0300
Message-Id: <1255637919-6178-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/acpi/video_detect.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 575593a..27c7772 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -7,7 +7,7 @@
  * video_detect.c:
  * Provides acpi_is_video_device() for early scanning of ACPI devices in scan.c
  * There a Linux specific (Spec does not provide a HID for video devices) is
- * assinged
+ * assigned
  *
  * After PCI devices are glued with ACPI devices
  * acpi_get_pci_dev() can be called to identify ACPI graphics
@@ -83,16 +83,16 @@ long acpi_is_video_device(struct acpi_device *device)
 	if (!device)
 		return 0;
 
-	/* Does this device able to support video switching ? */
+	/* Is this device able to support video switching ? */
 	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOD", &h_dummy)) ||
 	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOS", &h_dummy)))
 		video_caps |= ACPI_VIDEO_OUTPUT_SWITCHING;
 
-	/* Does this device able to retrieve a video ROM ? */
+	/* Is this device able to retrieve a video ROM ? */
 	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_ROM", &h_dummy)))
 		video_caps |= ACPI_VIDEO_ROM_AVAILABLE;
 
-	/* Does this device able to configure which video head to be POSTed ? */
+	/* Is this device able to configure which video head to be POSTed ? */
 	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_VPO", &h_dummy)) &&
 	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_GPD", &h_dummy)) &&
 	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_SPD", &h_dummy)))
@@ -137,7 +137,7 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
  *
  * if NULL is passed as argument all ACPI devices are enumerated and
  * all graphics capabilities of physically present devices are
- * summerized and returned. This is cached and done only once.
+ * summarized and returned. This is cached and done only once.
  */
 long acpi_video_get_capabilities(acpi_handle graphics_handle)
 {
-- 
1.6.3.3

