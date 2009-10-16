Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZJPJqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZJPJqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbZJPJqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:46:44 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50555 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136AbZJPJqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:46:43 -0400
From: amit.kucheria@canonical.com
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: len.brown@intel.com, Amit Kucheria <amit.kucheria@canonical.com>
Subject: [PATCH] acpi: thermal: [TRIVIAL] Add EOL to the trip_point_N_type strings
Date: Fri, 16 Oct 2009 12:46:02 +0300
Message-Id: <1255686362-30022-1-git-send-email-amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@canonical.com>

Make the trip_point_N_type sysfs files return a string ending in EOL for
consistency with other sysfs files.

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 drivers/thermal/thermal_sys.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 4e83c29..6f8d8f9 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -180,15 +180,15 @@ trip_point_type_show(struct device *dev, struct device_attribute *attr,
 
 	switch (type) {
 	case THERMAL_TRIP_CRITICAL:
-		return sprintf(buf, "critical");
+		return sprintf(buf, "critical\n");
 	case THERMAL_TRIP_HOT:
-		return sprintf(buf, "hot");
+		return sprintf(buf, "hot\n");
 	case THERMAL_TRIP_PASSIVE:
-		return sprintf(buf, "passive");
+		return sprintf(buf, "passive\n");
 	case THERMAL_TRIP_ACTIVE:
-		return sprintf(buf, "active");
+		return sprintf(buf, "active\n");
 	default:
-		return sprintf(buf, "unknown");
+		return sprintf(buf, "unknown\n");
 	}
 }
 
-- 
1.6.3.3

