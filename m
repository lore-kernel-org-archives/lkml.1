Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbYBMVhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbYBMVhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbYBMVaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:22 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50788 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763468AbYBMVaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:16 -0500
Date: Wed, 13 Feb 2008 23:30:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: =?utf-8?B?w4lyaWM=?= Piel <Eric.Piel@tremplin-utc.net>,
       Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make acpi_no_initrd_override_setup() static
Message-ID: <20080213213000.GS3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_no_initrd_override_setup() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
1778953a9751288a9bee1d4f6a8b4f3d22e37f52 diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 0c37c65..b72a7f1 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -419,7 +419,7 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 }
 
 #ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
-int __init acpi_no_initrd_override_setup(char *s)
+static int __init acpi_no_initrd_override_setup(char *s)
 {
 	acpi_no_initrd_override = 1;
 	return 1;

