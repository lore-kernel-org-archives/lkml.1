Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYLaKyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYLaKyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbYLaKw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:26 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:40391 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbYLaKwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:11 -0500
Date: Wed, 31 Dec 2008 05:51:57 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 07/15] ACPICA: acevents.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <71e8ca1e69f7f0bcec1f02863e95e253bee55ec8.1230719803.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/acevents.h |    0 
 kernel/acpi/acpica/dsopcode.c                   |    2 +-
 kernel/acpi/acpica/dswload.c                    |    2 +-
 kernel/acpi/acpica/evevent.c                    |    2 +-
 kernel/acpi/acpica/evgpe.c                      |    2 +-
 kernel/acpi/acpica/evgpeblk.c                   |    2 +-
 kernel/acpi/acpica/evmisc.c                     |    2 +-
 kernel/acpi/acpica/evregion.c                   |    2 +-
 kernel/acpi/acpica/evrgnini.c                   |    2 +-
 kernel/acpi/acpica/evsci.c                      |    2 +-
 kernel/acpi/acpica/evxface.c                    |    2 +-
 kernel/acpi/acpica/evxfevnt.c                   |    2 +-
 kernel/acpi/acpica/evxfregn.c                   |    2 +-
 kernel/acpi/acpica/exfldio.c                    |    2 +-
 kernel/acpi/acpica/exmutex.c                    |    2 +-
 kernel/acpi/acpica/exoparg2.c                   |    2 +-
 kernel/acpi/acpica/hwgpe.c                      |    2 +-
 kernel/acpi/acpica/hwregs.c                     |    2 +-
 kernel/acpi/acpica/utdelete.c                   |    2 +-
 kernel/acpi/acpica/utinit.c                     |    2 +-
 kernel/acpi/acpica/utxface.c                    |    2 +-
 21 files changed, 20 insertions(+), 20 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acevents.h (100%)

diff --git a/include/acpi/acevents.h b/kernel/acpi/acpica/acevents.h
similarity index 100%
rename from include/acpi/acevents.h
rename to kernel/acpi/acpica/acevents.h
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index ed85e8c..ab7ff9a 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -49,7 +49,7 @@
 #include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dswload.c b/kernel/acpi/acpica/dswload.c
index c885c89..32d9d4f 100644
--- a/kernel/acpi/acpica/dswload.c
+++ b/kernel/acpi/acpica/dswload.c
@@ -48,7 +48,7 @@
 #include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #ifdef ACPI_ASL_COMPILER
 #include <acpi/acdisasm.h>
diff --git a/kernel/acpi/acpica/evevent.c b/kernel/acpi/acpica/evevent.c
index d42d26c..803edd9 100644
--- a/kernel/acpi/acpica/evevent.c
+++ b/kernel/acpi/acpica/evevent.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evevent")
diff --git a/kernel/acpi/acpica/evgpe.c b/kernel/acpi/acpica/evgpe.c
index c1b2e71..83079e9 100644
--- a/kernel/acpi/acpica/evgpe.c
+++ b/kernel/acpi/acpica/evgpe.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evgpeblk.c b/kernel/acpi/acpica/evgpeblk.c
index bdc53d4..638b3a8 100644
--- a/kernel/acpi/acpica/evgpeblk.c
+++ b/kernel/acpi/acpica/evgpeblk.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evmisc.c b/kernel/acpi/acpica/evmisc.c
index da0e220..2f94a40 100644
--- a/kernel/acpi/acpica/evmisc.c
+++ b/kernel/acpi/acpica/evmisc.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
 
diff --git a/kernel/acpi/acpica/evregion.c b/kernel/acpi/acpica/evregion.c
index 10859f0..24628d3 100644
--- a/kernel/acpi/acpica/evregion.c
+++ b/kernel/acpi/acpica/evregion.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
 
diff --git a/kernel/acpi/acpica/evrgnini.c b/kernel/acpi/acpica/evrgnini.c
index 5348a9e..7dae903 100644
--- a/kernel/acpi/acpica/evrgnini.c
+++ b/kernel/acpi/acpica/evrgnini.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evsci.c b/kernel/acpi/acpica/evsci.c
index a0e5800..567b356 100644
--- a/kernel/acpi/acpica/evsci.c
+++ b/kernel/acpi/acpica/evsci.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evsci")
diff --git a/kernel/acpi/acpica/evxface.c b/kernel/acpi/acpica/evxface.c
index 5577671..fb1f13a 100644
--- a/kernel/acpi/acpica/evxface.c
+++ b/kernel/acpi/acpica/evxface.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acinterp.h>
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evxfevnt.c b/kernel/acpi/acpica/evxfevnt.c
index 11b79a3..feb7eb9 100644
--- a/kernel/acpi/acpica/evxfevnt.c
+++ b/kernel/acpi/acpica/evxfevnt.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/evxfregn.c b/kernel/acpi/acpica/evxfregn.c
index 6e5e277..7a9348a 100644
--- a/kernel/acpi/acpica/evxfregn.c
+++ b/kernel/acpi/acpica/evxfregn.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evxfregn")
diff --git a/kernel/acpi/acpica/exfldio.c b/kernel/acpi/acpica/exfldio.c
index 6a1ba49..09812be 100644
--- a/kernel/acpi/acpica/exfldio.c
+++ b/kernel/acpi/acpica/exfldio.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include "acdispat.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exmutex.c b/kernel/acpi/acpica/exmutex.c
index eac86c0..5919c8a 100644
--- a/kernel/acpi/acpica/exmutex.c
+++ b/kernel/acpi/acpica/exmutex.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acinterp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exmutex")
diff --git a/kernel/acpi/acpica/exoparg2.c b/kernel/acpi/acpica/exoparg2.c
index 83b2e59..a63ab5d 100644
--- a/kernel/acpi/acpica/exoparg2.c
+++ b/kernel/acpi/acpica/exoparg2.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acinterp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/hwgpe.c b/kernel/acpi/acpica/hwgpe.c
index 04feb50..2013b66 100644
--- a/kernel/acpi/acpica/hwgpe.c
+++ b/kernel/acpi/acpica/hwgpe.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwgpe")
diff --git a/kernel/acpi/acpica/hwregs.c b/kernel/acpi/acpica/hwregs.c
index 27fd268..73fefc1 100644
--- a/kernel/acpi/acpica/hwregs.c
+++ b/kernel/acpi/acpica/hwregs.c
@@ -46,7 +46,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwregs")
diff --git a/kernel/acpi/acpica/utdelete.c b/kernel/acpi/acpica/utdelete.c
index c26e1bd..5b57fea 100644
--- a/kernel/acpi/acpica/utdelete.c
+++ b/kernel/acpi/acpica/utdelete.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utdelete")
diff --git a/kernel/acpi/acpica/utinit.c b/kernel/acpi/acpica/utinit.c
index 4d07002..97d9305 100644
--- a/kernel/acpi/acpica/utinit.c
+++ b/kernel/acpi/acpica/utinit.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utxface.c b/kernel/acpi/acpica/utxface.c
index 8e2dfab..57b0c02 100644
--- a/kernel/acpi/acpica/utxface.c
+++ b/kernel/acpi/acpica/utxface.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acevents.h>
+#include "acevents.h"
 #include <acpi/acnamesp.h>
 #include "acdebug.h"
 #include <acpi/actables.h>
-- 
1.5.6.6

