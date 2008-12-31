Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYLaK4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYLaK4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbYLaKwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:38 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:36237 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbYLaKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:14 -0500
Date: Wed, 31 Dec 2008 05:52:04 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 14/15] ACPICA: actables.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <a1de2c84894204e238bbfc9547c3042a3d00996e.1230719806.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/actables.h |    0 
 kernel/acpi/acpica/dsinit.c                     |    2 +-
 kernel/acpi/acpica/dsopcode.c                   |    2 +-
 kernel/acpi/acpica/evxfevnt.c                   |    2 +-
 kernel/acpi/acpica/exconfig.c                   |    2 +-
 kernel/acpi/acpica/hwsleep.c                    |    2 +-
 kernel/acpi/acpica/nsload.c                     |    2 +-
 kernel/acpi/acpica/nsparse.c                    |    2 +-
 kernel/acpi/acpica/nsutils.c                    |    2 +-
 kernel/acpi/acpica/tbfadt.c                     |    2 +-
 kernel/acpi/acpica/tbfind.c                     |    2 +-
 kernel/acpi/acpica/tbinstal.c                   |    2 +-
 kernel/acpi/acpica/tbutils.c                    |    2 +-
 kernel/acpi/acpica/tbxface.c                    |    2 +-
 kernel/acpi/acpica/tbxfroot.c                   |    2 +-
 kernel/acpi/acpica/utinit.c                     |    2 +-
 kernel/acpi/acpica/utxface.c                    |    2 +-
 17 files changed, 16 insertions(+), 16 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/actables.h (100%)

diff --git a/include/acpi/actables.h b/kernel/acpi/acpica/actables.h
similarity index 100%
rename from include/acpi/actables.h
rename to kernel/acpi/acpica/actables.h
diff --git a/kernel/acpi/acpica/dsinit.c b/kernel/acpi/acpica/dsinit.c
index c063e81..eb144b1 100644
--- a/kernel/acpi/acpica/dsinit.c
+++ b/kernel/acpi/acpica/dsinit.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acdispat.h"
 #include "acnamesp.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dsinit")
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index 4c99739..20b8005 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -50,7 +50,7 @@
 #include "acinterp.h"
 #include "acnamesp.h"
 #include "acevents.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dsopcode")
diff --git a/kernel/acpi/acpica/evxfevnt.c b/kernel/acpi/acpica/evxfevnt.c
index b3f8caa..35485e4 100644
--- a/kernel/acpi/acpica/evxfevnt.c
+++ b/kernel/acpi/acpica/evxfevnt.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acevents.h"
 #include "acnamesp.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evxfevnt")
diff --git a/kernel/acpi/acpica/exconfig.c b/kernel/acpi/acpica/exconfig.c
index fb8e36d..932bbc2 100644
--- a/kernel/acpi/acpica/exconfig.c
+++ b/kernel/acpi/acpica/exconfig.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acinterp.h"
 #include "acnamesp.h"
-#include <acpi/actables.h>
+#include "actables.h"
 #include "acdispat.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/hwsleep.c b/kernel/acpi/acpica/hwsleep.c
index f290376..a2af2a4 100644
--- a/kernel/acpi/acpica/hwsleep.c
+++ b/kernel/acpi/acpica/hwsleep.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
diff --git a/kernel/acpi/acpica/nsload.c b/kernel/acpi/acpica/nsload.c
index 32e530d..a0ba9e1 100644
--- a/kernel/acpi/acpica/nsload.c
+++ b/kernel/acpi/acpica/nsload.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acnamesp.h"
 #include "acdispat.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsload")
diff --git a/kernel/acpi/acpica/nsparse.c b/kernel/acpi/acpica/nsparse.c
index b7dd8cd..b9e8d00 100644
--- a/kernel/acpi/acpica/nsparse.c
+++ b/kernel/acpi/acpica/nsparse.c
@@ -46,7 +46,7 @@
 #include "acnamesp.h"
 #include "acparser.h"
 #include "acdispat.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsparse")
diff --git a/kernel/acpi/acpica/nsutils.c b/kernel/acpi/acpica/nsutils.c
index ac83061..b285ed7 100644
--- a/kernel/acpi/acpica/nsutils.c
+++ b/kernel/acpi/acpica/nsutils.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include "acnamesp.h"
 #include <acpi/amlcode.h>
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsutils")
diff --git a/kernel/acpi/acpica/tbfadt.c b/kernel/acpi/acpica/tbfadt.c
index 9c6769e..3636e4f 100644
--- a/kernel/acpi/acpica/tbfadt.c
+++ b/kernel/acpi/acpica/tbfadt.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_TABLES
 ACPI_MODULE_NAME("tbfadt")
diff --git a/kernel/acpi/acpica/tbfind.c b/kernel/acpi/acpica/tbfind.c
index 941e38c..1054dfd 100644
--- a/kernel/acpi/acpica/tbfind.c
+++ b/kernel/acpi/acpica/tbfind.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_TABLES
 ACPI_MODULE_NAME("tbfind")
diff --git a/kernel/acpi/acpica/tbinstal.c b/kernel/acpi/acpica/tbinstal.c
index 94fe615..37374b2 100644
--- a/kernel/acpi/acpica/tbinstal.c
+++ b/kernel/acpi/acpica/tbinstal.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acnamesp.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_TABLES
 ACPI_MODULE_NAME("tbinstal")
diff --git a/kernel/acpi/acpica/tbutils.c b/kernel/acpi/acpica/tbutils.c
index 55627ee..3a8d8d2 100644
--- a/kernel/acpi/acpica/tbutils.c
+++ b/kernel/acpi/acpica/tbutils.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_TABLES
 ACPI_MODULE_NAME("tbutils")
diff --git a/kernel/acpi/acpica/tbxface.c b/kernel/acpi/acpica/tbxface.c
index ef5954f..c3e841f 100644
--- a/kernel/acpi/acpica/tbxface.c
+++ b/kernel/acpi/acpica/tbxface.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acnamesp.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_TABLES
 ACPI_MODULE_NAME("tbxface")
diff --git a/kernel/acpi/acpica/tbxfroot.c b/kernel/acpi/acpica/tbxfroot.c
index 8954e01..b7fc8dd 100644
--- a/kernel/acpi/acpica/tbxfroot.c
+++ b/kernel/acpi/acpica/tbxfroot.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_TABLES
 ACPI_MODULE_NAME("tbxfroot")
diff --git a/kernel/acpi/acpica/utinit.c b/kernel/acpi/acpica/utinit.c
index 10fb977..a54ca84 100644
--- a/kernel/acpi/acpica/utinit.c
+++ b/kernel/acpi/acpica/utinit.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acnamesp.h"
 #include "acevents.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utinit")
diff --git a/kernel/acpi/acpica/utxface.c b/kernel/acpi/acpica/utxface.c
index 0edc8fb..078a227 100644
--- a/kernel/acpi/acpica/utxface.c
+++ b/kernel/acpi/acpica/utxface.c
@@ -46,7 +46,7 @@
 #include "acevents.h"
 #include "acnamesp.h"
 #include "acdebug.h"
-#include <acpi/actables.h>
+#include "actables.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utxface")
-- 
1.5.6.6

