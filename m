Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXKTBxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXKTBxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbXKTBtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:14 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2058 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378AbXKTBs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH 10/59] drivers/acpi: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:02 -0800
Message-Id: <1195523331-15303-11-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-10-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
Message-Id: <07a846daef42aa7262f9e08a8be5c3ed8684ed77.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/acpi/ec.c             |    4 ++--
 drivers/acpi/processor_core.c |    2 +-
 drivers/acpi/tables/tbutils.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 06b78e5..cb09e5e 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -175,12 +175,12 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
 		if (acpi_ec_check_status(ec, event)) {
 			if (event == ACPI_EC_EVENT_OBF_1) {
 				/* miss OBF = 1 GPE, don't expect it anymore */
-				printk(KERN_INFO PREFIX "missing OBF_1 confirmation,"
+				printk(KERN_INFO PREFIX "missing OBF_1 confirmation, "
 					"switching to degraded mode.\n");
 				set_bit(EC_FLAGS_ONLY_IBF_GPE, &ec->flags);
 			} else {
 				/* missing GPEs, switch back to poll mode */
-				printk(KERN_INFO PREFIX "missing IBF_1 confirmations,"
+				printk(KERN_INFO PREFIX "missing IBF_1 confirmations, "
 					"switch off interrupt mode.\n");
 				clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
 			}
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 235a51e..44156e7 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -647,7 +647,7 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
 	 */
 	if (processor_device_array[pr->id] != NULL &&
 	    processor_device_array[pr->id] != device) {
-		printk(KERN_WARNING "BIOS reported wrong ACPI id"
+		printk(KERN_WARNING "BIOS reported wrong ACPI id "
 			"for the processor\n");
 		return -ENODEV;
 	}
diff --git a/drivers/acpi/tables/tbutils.c b/drivers/acpi/tables/tbutils.c
index 5f1d85f..010f196 100644
--- a/drivers/acpi/tables/tbutils.c
+++ b/drivers/acpi/tables/tbutils.c
@@ -449,7 +449,7 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address, u8 flags)
 			/* XSDT has NULL entry, RSDT is used */
 			address = rsdt_address;
 			table_entry_size = sizeof(u32);
-			ACPI_WARNING((AE_INFO, "BIOS XSDT has NULL entry,"
+			ACPI_WARNING((AE_INFO, "BIOS XSDT has NULL entry, "
 					"using RSDT"));
 		}
 	}
-- 
1.5.3.5.652.gf192c

