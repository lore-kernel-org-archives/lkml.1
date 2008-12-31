Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYLaK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYLaK5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYLaKwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:47 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:46751 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbYLaKw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:27 -0500
Date: Wed, 31 Dec 2008 05:52:03 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 13/15] ACPICA: acresrc.h, amlresrc.h are private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <6166df27a7cc54d89194ca9c76ed14a73c6aee38.1230719806.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/acresrc.h  |    0 
 {include/acpi => kernel/acpi/acpica}/amlresrc.h |    0 
 kernel/acpi/acpica/exmisc.c                     |    2 +-
 kernel/acpi/acpica/rsaddr.c                     |    2 +-
 kernel/acpi/acpica/rscalc.c                     |    2 +-
 kernel/acpi/acpica/rscreate.c                   |    2 +-
 kernel/acpi/acpica/rsdump.c                     |    2 +-
 kernel/acpi/acpica/rsinfo.c                     |    2 +-
 kernel/acpi/acpica/rsio.c                       |    2 +-
 kernel/acpi/acpica/rsirq.c                      |    2 +-
 kernel/acpi/acpica/rslist.c                     |    2 +-
 kernel/acpi/acpica/rsmemory.c                   |    2 +-
 kernel/acpi/acpica/rsmisc.c                     |    2 +-
 kernel/acpi/acpica/rsutils.c                    |    2 +-
 kernel/acpi/acpica/rsxface.c                    |    2 +-
 kernel/acpi/acpica/utresrc.c                    |    2 +-
 16 files changed, 14 insertions(+), 14 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acresrc.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/amlresrc.h (100%)

diff --git a/include/acpi/acresrc.h b/kernel/acpi/acpica/acresrc.h
similarity index 100%
rename from include/acpi/acresrc.h
rename to kernel/acpi/acpica/acresrc.h
diff --git a/include/acpi/amlresrc.h b/kernel/acpi/acpica/amlresrc.h
similarity index 100%
rename from include/acpi/amlresrc.h
rename to kernel/acpi/acpica/amlresrc.h
diff --git a/kernel/acpi/acpica/exmisc.c b/kernel/acpi/acpica/exmisc.c
index 9c8c622..7498f36 100644
--- a/kernel/acpi/acpica/exmisc.c
+++ b/kernel/acpi/acpica/exmisc.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
-#include <acpi/amlresrc.h>
+#include "amlresrc.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exmisc")
diff --git a/kernel/acpi/acpica/rsaddr.c b/kernel/acpi/acpica/rsaddr.c
index c8b9350..1e437bf 100644
--- a/kernel/acpi/acpica/rsaddr.c
+++ b/kernel/acpi/acpica/rsaddr.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsaddr")
diff --git a/kernel/acpi/acpica/rscalc.c b/kernel/acpi/acpica/rscalc.c
index 4d44f58..52865ee 100644
--- a/kernel/acpi/acpica/rscalc.c
+++ b/kernel/acpi/acpica/rscalc.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rscreate.c b/kernel/acpi/acpica/rscreate.c
index 0998933..9eb3a2a 100644
--- a/kernel/acpi/acpica/rscreate.c
+++ b/kernel/acpi/acpica/rscreate.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsdump.c b/kernel/acpi/acpica/rsdump.c
index 5dee59d..3f0ca5a 100644
--- a/kernel/acpi/acpica/rsdump.c
+++ b/kernel/acpi/acpica/rsdump.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsdump")
diff --git a/kernel/acpi/acpica/rsinfo.c b/kernel/acpi/acpica/rsinfo.c
index 8cb1ef6..77b25fd 100644
--- a/kernel/acpi/acpica/rsinfo.c
+++ b/kernel/acpi/acpica/rsinfo.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsinfo")
diff --git a/kernel/acpi/acpica/rsio.c b/kernel/acpi/acpica/rsio.c
index 7f8c205..35a49aa 100644
--- a/kernel/acpi/acpica/rsio.c
+++ b/kernel/acpi/acpica/rsio.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsio")
diff --git a/kernel/acpi/acpica/rsirq.c b/kernel/acpi/acpica/rsirq.c
index b73b1ee..2e02569 100644
--- a/kernel/acpi/acpica/rsirq.c
+++ b/kernel/acpi/acpica/rsirq.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsirq")
diff --git a/kernel/acpi/acpica/rslist.c b/kernel/acpi/acpica/rslist.c
index e253f37..1b1dbc6 100644
--- a/kernel/acpi/acpica/rslist.c
+++ b/kernel/acpi/acpica/rslist.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rslist")
diff --git a/kernel/acpi/acpica/rsmemory.c b/kernel/acpi/acpica/rsmemory.c
index ac48921..ddc76ce 100644
--- a/kernel/acpi/acpica/rsmemory.c
+++ b/kernel/acpi/acpica/rsmemory.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsmemory")
diff --git a/kernel/acpi/acpica/rsmisc.c b/kernel/acpi/acpica/rsmisc.c
index 375c275..5bc49a5 100644
--- a/kernel/acpi/acpica/rsmisc.c
+++ b/kernel/acpi/acpica/rsmisc.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsmisc")
diff --git a/kernel/acpi/acpica/rsutils.c b/kernel/acpi/acpica/rsutils.c
index 6c30ea3..bc03d59 100644
--- a/kernel/acpi/acpica/rsutils.c
+++ b/kernel/acpi/acpica/rsutils.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acnamesp.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsutils")
diff --git a/kernel/acpi/acpica/rsxface.c b/kernel/acpi/acpica/rsxface.c
index f9f94a0..69a2aa5 100644
--- a/kernel/acpi/acpica/rsxface.c
+++ b/kernel/acpi/acpica/rsxface.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acresrc.h>
+#include "acresrc.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/utresrc.c b/kernel/acpi/acpica/utresrc.c
index 118ae85..91b7c00 100644
--- a/kernel/acpi/acpica/utresrc.c
+++ b/kernel/acpi/acpica/utresrc.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/amlresrc.h>
+#include "amlresrc.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utresrc")
-- 
1.5.6.6

