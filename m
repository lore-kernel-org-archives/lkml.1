Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbYLaK4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbYLaK4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYLaKwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:36 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:43075 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYLaKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:14 -0500
Date: Wed, 31 Dec 2008 05:51:52 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 02/15] ACPI: delete include/acpi/platform/
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <e97c80d0943fcf43cf92aeca4600d3379e0b8c34.1230719800.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.1.28.gc32f76
References: <1230720725-9376-1-git-send-email-lenb@kernel.org>
References: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The ACPICA tree has some additional non-Linux files in this dir,
but Linux doesn't bother with those, so keep things simple...

Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/{platform => }/acenv.h   |    0 
 include/acpi/{platform => }/acgcc.h   |    0 
 include/acpi/{platform => }/aclinux.h |    0 
 include/acpi/acpi.h                   |    2 +-
 include/acpi/acpiosxf.h               |    2 +-
 5 files changed, 2 insertions(+), 2 deletions(-)
 rename include/acpi/{platform => }/acenv.h (100%)
 rename include/acpi/{platform => }/acgcc.h (100%)
 rename include/acpi/{platform => }/aclinux.h (100%)

diff --git a/include/acpi/platform/acenv.h b/include/acpi/acenv.h
similarity index 100%
rename from include/acpi/platform/acenv.h
rename to include/acpi/acenv.h
diff --git a/include/acpi/platform/acgcc.h b/include/acpi/acgcc.h
similarity index 100%
rename from include/acpi/platform/acgcc.h
rename to include/acpi/acgcc.h
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/aclinux.h
similarity index 100%
rename from include/acpi/platform/aclinux.h
rename to include/acpi/aclinux.h
diff --git a/include/acpi/acpi.h b/include/acpi/acpi.h
index 472b7bf..508a26b 100644
--- a/include/acpi/acpi.h
+++ b/include/acpi/acpi.h
@@ -53,7 +53,7 @@
  *
  * Note: The order of these include files is important.
  */
-#include "platform/acenv.h"	/* Environment-specific items */
+#include "acenv.h"		/* Environment-specific items */
 #include "acnames.h"		/* Common ACPI names and strings */
 #include "actypes.h"		/* ACPICA data types and structures */
 #include "acexcep.h"		/* ACPICA exceptions */
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index a62720a..a65f5a6 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -47,7 +47,7 @@
 #ifndef __ACPIOSXF_H__
 #define __ACPIOSXF_H__
 
-#include "platform/acenv.h"
+#include "acenv.h"
 #include "actypes.h"
 
 /* Types for acpi_os_execute */
-- 
1.5.6.6

