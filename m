Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbYA1WK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbYA1WK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYA1WJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:09:46 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47952 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759596AbYA1WJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:09:45 -0500
Date: Tue, 29 Jan 2008 00:10:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make acpi_dmi_dump() static
Message-ID: <20080128221012.GL8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_dmi_dump() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
34e88971f02980a37695e73ed121fca32edc8519 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e53fb51..db074f5 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1213,7 +1213,7 @@ acpi_status acpi_os_release_object(acpi_cache_t * cache, void *object)
  *
  *	Returns 0 on success
  */
-int acpi_dmi_dump(void)
+static int acpi_dmi_dump(void)
 {
 
 	if (!dmi_available)

