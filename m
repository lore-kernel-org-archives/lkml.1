Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbYJKGud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbYJKGud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYJKGi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:59 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:52519 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYJKGhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:18 -0400
Date: Sat, 11 Oct 2008 02:36:40 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 80/85] ACPI thermal: Debug interface used for error message
 cleanup
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <c3866cdb44370df3fd5ac8bd8856a4bc62136e39.1223706853.git.len.brown@intel.com>
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
 drivers/acpi/thermal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 9127036..6f2c5e9 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1213,8 +1213,8 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 				  acpi_bus_private_data_handler,
 				  tz->thermal_zone);
 	if (ACPI_FAILURE(status)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				"Error attaching device data\n"));
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Error attaching device data"));
 		return -ENODEV;
 	}
 
-- 
1.5.5.1

