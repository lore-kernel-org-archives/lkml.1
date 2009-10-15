Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbZJOBEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbZJOBEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 21:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762352AbZJOBEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 21:04:21 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:61552 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762349AbZJOBEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 21:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gvTlwwbKHDuK5dCcb9UQi4RQL+sNqGvcKd5DlPK15HNi1wwLUVomOc0s9lTkRM7EVQ
         TU1BBgkBzkic4aRpLXSDl80Y7sQHqDO+LIIOoPnXqQGQYxKqIP4EyMxpccVbpnWZeXYF
         TopbwPaQuo2zXOeb5m54BqmTiX62ohD+VPI2E=
From: Tim Hoppen <timhoppen@gmail.com>
Cc: lenb@kernel.org, rui.zhang@intel.com, jgarzik@redhat.com, tj@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Hoppen <timhoppen@gmail.com>
Subject: [PATCH 1/1] Added an additional Sony laptop to acpi_osi_dmi_table
Date: Wed, 14 Oct 2009 17:59:51 -0700
Message-Id: <1255568391-8400-1-git-send-email-timhoppen@gmail.com>
X-Mailer: git-send-email 1.6.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tim Hoppen <timhoppen@gmail.com>
---
 drivers/acpi/blacklist.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index e56b2a7..01cca5f 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -211,6 +211,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "Sony VGN-SR290J"),
 		},
 	},
+	{
+        .callback = dmi_disable_osi_vista,
+        .ident = "Sony VGN-FW351J",
+        .matches = {
+                     DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+                     DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW351J"),
+                },
+        },
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
-- 
1.6.5

