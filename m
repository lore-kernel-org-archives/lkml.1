Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYLaK5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYLaK5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYLaKwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:43 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:46751 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbYLaKw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:26 -0500
Date: Wed, 31 Dec 2008 05:51:58 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 08/15] ACPICA: acinterp.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <b329da9de969f9dabab7c33febea4da398fc2f0d.1230719804.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/acinterp.h |    0 
 kernel/acpi/acpica/dsfield.c                    |    2 +-
 kernel/acpi/acpica/dsmethod.c                   |    2 +-
 kernel/acpi/acpica/dsmthdat.c                   |    2 +-
 kernel/acpi/acpica/dsobject.c                   |    2 +-
 kernel/acpi/acpica/dsopcode.c                   |    2 +-
 kernel/acpi/acpica/dsutils.c                    |    2 +-
 kernel/acpi/acpica/dswexec.c                    |    2 +-
 kernel/acpi/acpica/dswload.c                    |    2 +-
 kernel/acpi/acpica/evmisc.c                     |    2 +-
 kernel/acpi/acpica/evregion.c                   |    2 +-
 kernel/acpi/acpica/evxface.c                    |    2 +-
 kernel/acpi/acpica/exconfig.c                   |    2 +-
 kernel/acpi/acpica/exconvrt.c                   |    2 +-
 kernel/acpi/acpica/excreate.c                   |    2 +-
 kernel/acpi/acpica/exdump.c                     |    2 +-
 kernel/acpi/acpica/exfield.c                    |    2 +-
 kernel/acpi/acpica/exfldio.c                    |    2 +-
 kernel/acpi/acpica/exmisc.c                     |    2 +-
 kernel/acpi/acpica/exmutex.c                    |    2 +-
 kernel/acpi/acpica/exnames.c                    |    2 +-
 kernel/acpi/acpica/exoparg1.c                   |    2 +-
 kernel/acpi/acpica/exoparg2.c                   |    2 +-
 kernel/acpi/acpica/exoparg3.c                   |    2 +-
 kernel/acpi/acpica/exoparg6.c                   |    2 +-
 kernel/acpi/acpica/exprep.c                     |    2 +-
 kernel/acpi/acpica/exregion.c                   |    2 +-
 kernel/acpi/acpica/exresnte.c                   |    2 +-
 kernel/acpi/acpica/exresolv.c                   |    2 +-
 kernel/acpi/acpica/exresop.c                    |    2 +-
 kernel/acpi/acpica/exstore.c                    |    2 +-
 kernel/acpi/acpica/exstoren.c                   |    2 +-
 kernel/acpi/acpica/exstorob.c                   |    2 +-
 kernel/acpi/acpica/exsystem.c                   |    2 +-
 kernel/acpi/acpica/exutils.c                    |    2 +-
 kernel/acpi/acpica/nseval.c                     |    2 +-
 kernel/acpi/acpica/nsinit.c                     |    2 +-
 kernel/acpi/acpica/nsxfeval.c                   |    2 +-
 kernel/acpi/acpica/psparse.c                    |    2 +-
 kernel/acpi/acpica/psxface.c                    |    2 +-
 kernel/acpi/acpica/utdelete.c                   |    2 +-
 kernel/acpi/acpica/uteval.c                     |    2 +-
 42 files changed, 41 insertions(+), 41 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acinterp.h (100%)

diff --git a/include/acpi/acinterp.h b/kernel/acpi/acpica/acinterp.h
similarity index 100%
rename from include/acpi/acinterp.h
rename to kernel/acpi/acpica/acinterp.h
diff --git a/kernel/acpi/acpica/dsfield.c b/kernel/acpi/acpica/dsfield.c
index 7da22b0..02e90dd 100644
--- a/kernel/acpi/acpica/dsfield.c
+++ b/kernel/acpi/acpica/dsfield.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acparser.h>
 
diff --git a/kernel/acpi/acpica/dsmethod.c b/kernel/acpi/acpica/dsmethod.c
index 3dc6def..7172036 100644
--- a/kernel/acpi/acpica/dsmethod.c
+++ b/kernel/acpi/acpica/dsmethod.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #ifdef ACPI_DISASSEMBLER
 #include <acpi/acdisasm.h>
diff --git a/kernel/acpi/acpica/dsmthdat.c b/kernel/acpi/acpica/dsmthdat.c
index e485f63..ce677b7 100644
--- a/kernel/acpi/acpica/dsmthdat.c
+++ b/kernel/acpi/acpica/dsmthdat.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acdispat.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dsmthdat")
diff --git a/kernel/acpi/acpica/dsobject.c b/kernel/acpi/acpica/dsobject.c
index e0194d9..77faceb 100644
--- a/kernel/acpi/acpica/dsobject.c
+++ b/kernel/acpi/acpica/dsobject.c
@@ -47,7 +47,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dsobject")
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index ab7ff9a..30f02d5 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -47,7 +47,7 @@
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #include "acevents.h"
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/dsutils.c b/kernel/acpi/acpica/dsutils.c
index 07419d2..f763142 100644
--- a/kernel/acpi/acpica/dsutils.c
+++ b/kernel/acpi/acpica/dsutils.c
@@ -46,7 +46,7 @@
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #include "acdebug.h"
 
diff --git a/kernel/acpi/acpica/dswexec.c b/kernel/acpi/acpica/dswexec.c
index 9be469b..94dfc1d 100644
--- a/kernel/acpi/acpica/dswexec.c
+++ b/kernel/acpi/acpica/dswexec.c
@@ -47,7 +47,7 @@
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #include "acdebug.h"
 
diff --git a/kernel/acpi/acpica/dswload.c b/kernel/acpi/acpica/dswload.c
index 32d9d4f..0a1c260 100644
--- a/kernel/acpi/acpica/dswload.c
+++ b/kernel/acpi/acpica/dswload.c
@@ -46,7 +46,7 @@
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #include "acevents.h"
 
diff --git a/kernel/acpi/acpica/evmisc.c b/kernel/acpi/acpica/evmisc.c
index 2f94a40..b864c73 100644
--- a/kernel/acpi/acpica/evmisc.c
+++ b/kernel/acpi/acpica/evmisc.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acevents.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evmisc")
diff --git a/kernel/acpi/acpica/evregion.c b/kernel/acpi/acpica/evregion.c
index 24628d3..ee9ee30 100644
--- a/kernel/acpi/acpica/evregion.c
+++ b/kernel/acpi/acpica/evregion.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acevents.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evregion")
diff --git a/kernel/acpi/acpica/evxface.c b/kernel/acpi/acpica/evxface.c
index fb1f13a..5b1d72d 100644
--- a/kernel/acpi/acpica/evxface.c
+++ b/kernel/acpi/acpica/evxface.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acnamesp.h>
 #include "acevents.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evxface")
diff --git a/kernel/acpi/acpica/exconfig.c b/kernel/acpi/acpica/exconfig.c
index 9970930..05727e6 100644
--- a/kernel/acpi/acpica/exconfig.c
+++ b/kernel/acpi/acpica/exconfig.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
 #include "acdispat.h"
diff --git a/kernel/acpi/acpica/exconvrt.c b/kernel/acpi/acpica/exconvrt.c
index 0f1dffd..49dd801 100644
--- a/kernel/acpi/acpica/exconvrt.c
+++ b/kernel/acpi/acpica/exconvrt.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/excreate.c b/kernel/acpi/acpica/excreate.c
index 4f26a8a..fc50a93 100644
--- a/kernel/acpi/acpica/excreate.c
+++ b/kernel/acpi/acpica/excreate.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/exdump.c b/kernel/acpi/acpica/exdump.c
index b2b8fd2..34b105c 100644
--- a/kernel/acpi/acpica/exdump.c
+++ b/kernel/acpi/acpica/exdump.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/exfield.c b/kernel/acpi/acpica/exfield.c
index 9ed3bd7..a352d02 100644
--- a/kernel/acpi/acpica/exfield.c
+++ b/kernel/acpi/acpica/exfield.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exfield")
diff --git a/kernel/acpi/acpica/exfldio.c b/kernel/acpi/acpica/exfldio.c
index 09812be..d66cd4c 100644
--- a/kernel/acpi/acpica/exfldio.c
+++ b/kernel/acpi/acpica/exfldio.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 #include "acevents.h"
 #include "acdispat.h"
diff --git a/kernel/acpi/acpica/exmisc.c b/kernel/acpi/acpica/exmisc.c
index 28d09e6..9c8c622 100644
--- a/kernel/acpi/acpica/exmisc.c
+++ b/kernel/acpi/acpica/exmisc.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 #include <acpi/amlresrc.h>
 
diff --git a/kernel/acpi/acpica/exmutex.c b/kernel/acpi/acpica/exmutex.c
index 5919c8a..d301c1f 100644
--- a/kernel/acpi/acpica/exmutex.c
+++ b/kernel/acpi/acpica/exmutex.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include "acevents.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exnames.c b/kernel/acpi/acpica/exnames.c
index c1dee3b..918fbac 100644
--- a/kernel/acpi/acpica/exnames.c
+++ b/kernel/acpi/acpica/exnames.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exoparg1.c b/kernel/acpi/acpica/exoparg1.c
index 872f7dd..cfeafa7 100644
--- a/kernel/acpi/acpica/exoparg1.c
+++ b/kernel/acpi/acpica/exoparg1.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/exoparg2.c b/kernel/acpi/acpica/exoparg2.c
index a63ab5d..4eda2e1 100644
--- a/kernel/acpi/acpica/exoparg2.c
+++ b/kernel/acpi/acpica/exoparg2.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include "acevents.h"
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/exoparg3.c b/kernel/acpi/acpica/exoparg3.c
index 69a3fd2..6405c24 100644
--- a/kernel/acpi/acpica/exoparg3.c
+++ b/kernel/acpi/acpica/exoparg3.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/exoparg6.c b/kernel/acpi/acpica/exoparg6.c
index 9b5e0da..74eb341 100644
--- a/kernel/acpi/acpica/exoparg6.c
+++ b/kernel/acpi/acpica/exoparg6.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/exprep.c b/kernel/acpi/acpica/exprep.c
index 59f8410..88f78c7 100644
--- a/kernel/acpi/acpica/exprep.c
+++ b/kernel/acpi/acpica/exprep.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/exregion.c b/kernel/acpi/acpica/exregion.c
index bfff7f7..76ec8ff 100644
--- a/kernel/acpi/acpica/exregion.c
+++ b/kernel/acpi/acpica/exregion.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exregion")
diff --git a/kernel/acpi/acpica/exresnte.c b/kernel/acpi/acpica/exresnte.c
index d66c21b..d6a0ccf 100644
--- a/kernel/acpi/acpica/exresnte.c
+++ b/kernel/acpi/acpica/exresnte.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exresolv.c b/kernel/acpi/acpica/exresolv.c
index f1da91a..f3f71a7 100644
--- a/kernel/acpi/acpica/exresolv.c
+++ b/kernel/acpi/acpica/exresolv.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exresop.c b/kernel/acpi/acpica/exresop.c
index 8fbd5c2..5748ff9 100644
--- a/kernel/acpi/acpica/exresop.c
+++ b/kernel/acpi/acpica/exresop.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acparser.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exstore.c b/kernel/acpi/acpica/exstore.c
index 742261c..0786ef1 100644
--- a/kernel/acpi/acpica/exstore.c
+++ b/kernel/acpi/acpica/exstore.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/exstoren.c b/kernel/acpi/acpica/exstoren.c
index ea2c108..1189dca 100644
--- a/kernel/acpi/acpica/exstoren.c
+++ b/kernel/acpi/acpica/exstoren.c
@@ -45,7 +45,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exstorob.c b/kernel/acpi/acpica/exstorob.c
index 7254ccf..67340cc 100644
--- a/kernel/acpi/acpica/exstorob.c
+++ b/kernel/acpi/acpica/exstorob.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exstorob")
diff --git a/kernel/acpi/acpica/exsystem.c b/kernel/acpi/acpica/exsystem.c
index 433f663..3d00b93 100644
--- a/kernel/acpi/acpica/exsystem.c
+++ b/kernel/acpi/acpica/exsystem.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exsystem")
diff --git a/kernel/acpi/acpica/exutils.c b/kernel/acpi/acpica/exutils.c
index 1876c0e..75f699e 100644
--- a/kernel/acpi/acpica/exutils.c
+++ b/kernel/acpi/acpica/exutils.c
@@ -60,7 +60,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/nseval.c b/kernel/acpi/acpica/nseval.c
index 543b0bb..1e438b8 100644
--- a/kernel/acpi/acpica/nseval.c
+++ b/kernel/acpi/acpica/nseval.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsinit.c b/kernel/acpi/acpica/nsinit.c
index f2200f1..6a1dfd7 100644
--- a/kernel/acpi/acpica/nsinit.c
+++ b/kernel/acpi/acpica/nsinit.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acnamesp.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <linux/nmi.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsxfeval.c b/kernel/acpi/acpica/nsxfeval.c
index 8117b9b..1ed9295 100644
--- a/kernel/acpi/acpica/nsxfeval.c
+++ b/kernel/acpi/acpica/nsxfeval.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsxfeval")
diff --git a/kernel/acpi/acpica/psparse.c b/kernel/acpi/acpica/psparse.c
index 113697f..f6cdcfe 100644
--- a/kernel/acpi/acpica/psparse.c
+++ b/kernel/acpi/acpica/psparse.c
@@ -56,7 +56,7 @@
 #include "acdispat.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("psparse")
diff --git a/kernel/acpi/acpica/psxface.c b/kernel/acpi/acpica/psxface.c
index efeb80e..ae30135 100644
--- a/kernel/acpi/acpica/psxface.c
+++ b/kernel/acpi/acpica/psxface.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include "acdispat.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/utdelete.c b/kernel/acpi/acpica/utdelete.c
index 5b57fea..cbb6813 100644
--- a/kernel/acpi/acpica/utdelete.c
+++ b/kernel/acpi/acpica/utdelete.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 #include <acpi/acnamesp.h>
 #include "acevents.h"
 
diff --git a/kernel/acpi/acpica/uteval.c b/kernel/acpi/acpica/uteval.c
index 41ff26a..f2a9fe0 100644
--- a/kernel/acpi/acpica/uteval.c
+++ b/kernel/acpi/acpica/uteval.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acinterp.h>
+#include "acinterp.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("uteval")
-- 
1.5.6.6

