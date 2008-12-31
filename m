Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYLaKzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYLaKzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYLaKwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:34 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:36608 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbYLaKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:16 -0500
Date: Wed, 31 Dec 2008 05:52:02 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 12/15] ACPICA: acpredef.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <37edd3ac6769a831b018577ef760edd4d298ebfd.1230719806.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.1.28.gc32f76
References: <1230720725-9376-1-git-send-email-lenb@kernel.org>
References: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
 {include/acpi => kernel/acpi/acpica}/acpredef.h |    0 
 kernel/acpi/acpica/nspredef.c                   |    2 +-
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acpredef.h (100%)

diff --git a/include/acpi/acpredef.h b/kernel/acpi/acpica/acpredef.h
similarity index 100%
rename from include/acpi/acpredef.h
rename to kernel/acpi/acpica/acpredef.h
diff --git a/kernel/acpi/acpica/nspredef.c b/kernel/acpi/acpica/nspredef.c
index b03a27b..4527032 100644
--- a/kernel/acpi/acpica/nspredef.c
+++ b/kernel/acpi/acpica/nspredef.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acnamesp.h"
-#include <acpi/acpredef.h>
+#include "acpredef.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nspredef")
-- 
1.5.6.6

