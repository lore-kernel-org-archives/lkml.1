Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbXHVJqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbXHVJqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXHVJqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:46:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48870 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbXHVJqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:46:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ACPI: Clean up acpi_enter_sleep_state_prep
Date: Wed, 22 Aug 2007 11:56:35 +0200
User-Agent: KMail/1.9.5
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221156.36235.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove some redundant code from acpi_enter_sleep_state_prep() and clean up
a comment in there.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/hardware/hwsleep.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6.23-rc3/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/acpi/hardware/hwsleep.c	2007-08-22 11:40:30.000000000 +0200
+++ linux-2.6.23-rc3/drivers/acpi/hardware/hwsleep.c	2007-08-22 11:40:53.000000000 +0200
@@ -234,15 +234,11 @@ acpi_status acpi_enter_sleep_state_prep(
 				"While executing method _SST"));
 	}
 
-	/*
-	 * 1) Disable/Clear all GPEs
-	 */
+	/* Disable/Clear all GPEs */
+
 	status = acpi_hw_disable_all_gpes();
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
 
-	return_ACPI_STATUS(AE_OK);
+	return_ACPI_STATUS(status);
 }
 
 ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
