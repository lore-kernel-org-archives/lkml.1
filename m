Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYBOUNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYBOUNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbYBOUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:13:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826AbYBOUNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:13:21 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.grover@intel.com,
       paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH] remove is_processor_present prototype
Date: Fri, 15 Feb 2008 18:07:00 -0200
Message-Id: <1203106021-11038-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function itself is defined just below,
so this prototype is not really useful.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 drivers/acpi/processor_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 75ccf5d..923fddb 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -826,8 +826,6 @@ #ifdef CONFIG_ACPI_HOTPLUG_CPU
  * 	Acpi processor hotplug support 				       	    *
  ****************************************************************************/
 
-static int is_processor_present(acpi_handle handle);
-
 static int is_processor_present(acpi_handle handle)
 {
 	acpi_status status;
-- 
1.4.2

