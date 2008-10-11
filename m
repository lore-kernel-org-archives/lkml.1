Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYJKGpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYJKGpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbYJKGiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:14 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:32774 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYJKGhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:33 -0400
Date: Sat, 11 Oct 2008 02:36:34 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 74/85] ACPI memhotplug: Debug interface used for error message
 cleanup
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <89ec3a9afe0ca884c6f7fba566c983746ebf983d.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

AK: Added missing printk prefix

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpi_memhotplug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 5f1127a..ce0763d 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -454,8 +454,8 @@ static int acpi_memory_device_start (struct acpi_device *device)
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
 		if (result)
-			ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				"Error in acpi_memory_enable_device\n"));
+			printk(KERN_ERR "Error in acpi_memory_enable_device [%d]\n",
+			       result);
 	}
 	return result;
 }
-- 
1.5.5.1

