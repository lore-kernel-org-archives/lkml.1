Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbZJOVAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbZJOVAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbZJOVAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:00:10 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:57606 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbZJOVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GSJV07tWVUTioM19e4aoXdP6vi5mFhZw9QpBzNV5Wf3PQu6FDWmcDUgoYYfdMHc2UJ
         Q/r152QswjmBVzr5PflLA3wspYcds1TmzVHym8cPjThqoL5usZSmricOhJYKXKQjWCjc
         KC0VAhQZfUmUT55CRDiOQVUpjbHz2+mffJBoQ=
From: Tim Hoppen <timhoppen@gmail.com>
Cc: lenb@kernel.org, rui.zhang@intel.com, jgarzik@redhat.com, tj@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Hoppen <timhoppen@gmail.com>
Subject: [PATCH 2/2] Patch for bug with ACPI for Sony VGN-FW351 to acpi_osi_dmi_table Similar to bug http://bugzilla.kernel.org/show_bug.cgi?id=12904 (same video controller)
Date: Thu, 15 Oct 2009 13:56:31 -0700
Message-Id: <1255640191-14807-1-git-send-email-timhoppen@gmail.com>
X-Mailer: git-send-email 1.6.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tim Hoppen <timhoppen@gmail.com>
---
 drivers/acpi/blacklist.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 01cca5f..782f330 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -212,13 +212,13 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		},
 	},
 	{
-        .callback = dmi_disable_osi_vista,
-        .ident = "Sony VGN-FW351J",
-        .matches = {
-                     DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-                     DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW351J"),
-                },
-        },
+	.callback = dmi_disable_osi_vista,
+	.ident = "Sony VGN-FW351J",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW351J"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
-- 
1.6.5

