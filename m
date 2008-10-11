Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYJKHk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYJKHk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYJKHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:20 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:48122 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYJKHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:19 -0400
Date: Sat, 11 Oct 2008 02:36:17 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 57/85] ACPI: acpi_driver_data could only be applied to
 acpi_device
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Hannes Reinecke <hare@suse.de>, Len Brown <len.brown@intel.com>
Message-id: <4b5fcb353ba46adfa2f98546e3d34e7dc65221cb.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Hannes Reinecke <hare@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f6f52c1..e7b8853 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -384,7 +384,7 @@ static int acpi_device_remove(struct device * dev)
 			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
 	}
 	acpi_dev->driver = NULL;
-	acpi_driver_data(dev) = NULL;
+	acpi_driver_data(acpi_dev) = NULL;
 
 	put_device(dev);
 	return 0;
-- 
1.5.5.1

