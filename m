Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYAPNBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYAPNBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYAPNAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:00:42 -0500
Received: from saeurebad.de ([85.214.36.134]:54851 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbYAPNAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:00:41 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi@hmh.eng.br, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] thinkpad_acpi: Remove superfluous prototypes from internal header
Date: Wed, 16 Jan 2008 14:01:43 +0100
Message-Id: <1200488504-6789-2-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1200488504-6789-1-git-send-email-hannes@saeurebad.de>
References: <1200488504-6789-1-git-send-email-hannes@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper functions are defined at the top of the C file so they are
known within the definition of the callsites below anyway.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 drivers/misc/thinkpad_acpi.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/thinkpad_acpi.h b/drivers/misc/thinkpad_acpi.h
index 8fba2bb..afaeb82 100644
--- a/drivers/misc/thinkpad_acpi.h
+++ b/drivers/misc/thinkpad_acpi.h
@@ -115,13 +115,6 @@ static const char *str_supported(int is_supported);
 /* ACPI HIDs */
 #define IBM_HKEY_HID    "IBM0068"
 
-/* ACPI helpers */
-static int __must_check acpi_evalf(acpi_handle handle,
-		      void *res, char *method, char *fmt, ...);
-static int __must_check acpi_ec_read(int i, u8 * p);
-static int __must_check acpi_ec_write(int i, u8 v);
-static int __must_check _sta(acpi_handle handle);
-
 /* ACPI handles */
 static acpi_handle root_handle;			/* root namespace */
 static acpi_handle ec_handle;			/* EC */
@@ -135,9 +128,6 @@ static void drv_acpi_handle_init(char *name,
 	drv_acpi_handle_init(#object, &object##_handle, *object##_parent,	\
 		object##_paths, ARRAY_SIZE(object##_paths), &object##_path)
 
-/* ThinkPad ACPI helpers */
-static int issue_thinkpad_cmos_command(int cmos_cmd);
-
 /* procfs support */
 static struct proc_dir_entry *proc_dir;
 
-- 
1.5.3.8

