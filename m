Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbYBMVgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbYBMVgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYBMVaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:21 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47485 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYBMVaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:14 -0500
Date: Wed, 13 Feb 2008 23:29:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Markus Gaugusch <dsdt@gaugusch.at>, Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make acpi_find_dsdt_initrd() static
Message-ID: <20080213212958.GR3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_find_dsdt_initrd() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
98cd5a55aff78aaacc3f8615164e2247f3bbed70 diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 34b3386..0c37c65 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -325,7 +325,7 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
 }
 
 #ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
-struct acpi_table_header *acpi_find_dsdt_initrd(void)
+static struct acpi_table_header *acpi_find_dsdt_initrd(void)
 {
 	struct file *firmware_file;
 	mm_segment_t oldfs;

