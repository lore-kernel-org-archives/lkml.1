Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbYJKHlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbYJKHlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYJKHhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:37 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:48129 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbYJKHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:27 -0400
Date: Sat, 11 Oct 2008 02:36:38 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 78/85] ACPI fan: Debug interface used for error message cleanup
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <669daa218a371be4a1e52907f62410948a318a30.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/fan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 2655bc1..393934e 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -327,8 +327,8 @@ static int acpi_fan_resume(struct acpi_device *device)
 
 	result = acpi_bus_get_power(device->handle, &power_state);
 	if (result) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				  "Error reading fan power state\n"));
+		printk(KERN_ERR "Error reading fan power state [%d]\n",
+		       result);
 		return result;
 	}
 
-- 
1.5.5.1

