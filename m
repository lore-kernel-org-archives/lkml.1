Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYLaKxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYLaKxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbYLaKwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:22 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:36237 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbYLaKwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:11 -0500
Date: Wed, 31 Dec 2008 05:51:59 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 09/15] ACPICA: acnamesp.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <0e74ffbf59c7192d685de4cbef27d57f43c69e7e.1230719804.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/acnamesp.h |    0 
 kernel/acpi/acpica/dsfield.c                    |    2 +-
 kernel/acpi/acpica/dsinit.c                     |    2 +-
 kernel/acpi/acpica/dsmethod.c                   |    2 +-
 kernel/acpi/acpica/dsmthdat.c                   |    2 +-
 kernel/acpi/acpica/dsobject.c                   |    2 +-
 kernel/acpi/acpica/dsopcode.c                   |    2 +-
 kernel/acpi/acpica/dsutils.c                    |    2 +-
 kernel/acpi/acpica/dswexec.c                    |    2 +-
 kernel/acpi/acpica/dswload.c                    |    2 +-
 kernel/acpi/acpica/dswstate.c                   |    2 +-
 kernel/acpi/acpica/evgpe.c                      |    2 +-
 kernel/acpi/acpica/evgpeblk.c                   |    2 +-
 kernel/acpi/acpica/evmisc.c                     |    2 +-
 kernel/acpi/acpica/evregion.c                   |    2 +-
 kernel/acpi/acpica/evrgnini.c                   |    2 +-
 kernel/acpi/acpica/evxface.c                    |    2 +-
 kernel/acpi/acpica/evxfevnt.c                   |    2 +-
 kernel/acpi/acpica/evxfregn.c                   |    2 +-
 kernel/acpi/acpica/exconfig.c                   |    2 +-
 kernel/acpi/acpica/excreate.c                   |    2 +-
 kernel/acpi/acpica/exdump.c                     |    2 +-
 kernel/acpi/acpica/exoparg1.c                   |    2 +-
 kernel/acpi/acpica/exprep.c                     |    2 +-
 kernel/acpi/acpica/exresnte.c                   |    2 +-
 kernel/acpi/acpica/exresolv.c                   |    2 +-
 kernel/acpi/acpica/exresop.c                    |    2 +-
 kernel/acpi/acpica/exstore.c                    |    2 +-
 kernel/acpi/acpica/hwregs.c                     |    2 +-
 kernel/acpi/acpica/hwxface.c                    |    2 +-
 kernel/acpi/acpica/nsaccess.c                   |    2 +-
 kernel/acpi/acpica/nsalloc.c                    |    2 +-
 kernel/acpi/acpica/nsdump.c                     |    2 +-
 kernel/acpi/acpica/nsdumpdv.c                   |    2 +-
 kernel/acpi/acpica/nseval.c                     |    2 +-
 kernel/acpi/acpica/nsinit.c                     |    2 +-
 kernel/acpi/acpica/nsload.c                     |    2 +-
 kernel/acpi/acpica/nsnames.c                    |    2 +-
 kernel/acpi/acpica/nsobject.c                   |    2 +-
 kernel/acpi/acpica/nsparse.c                    |    2 +-
 kernel/acpi/acpica/nspredef.c                   |    2 +-
 kernel/acpi/acpica/nssearch.c                   |    2 +-
 kernel/acpi/acpica/nsutils.c                    |    2 +-
 kernel/acpi/acpica/nswalk.c                     |    2 +-
 kernel/acpi/acpica/nsxfeval.c                   |    2 +-
 kernel/acpi/acpica/nsxfname.c                   |    2 +-
 kernel/acpi/acpica/nsxfobj.c                    |    2 +-
 kernel/acpi/acpica/psargs.c                     |    2 +-
 kernel/acpi/acpica/psparse.c                    |    2 +-
 kernel/acpi/acpica/rscalc.c                     |    2 +-
 kernel/acpi/acpica/rscreate.c                   |    2 +-
 kernel/acpi/acpica/rsutils.c                    |    2 +-
 kernel/acpi/acpica/rsxface.c                    |    2 +-
 kernel/acpi/acpica/tbinstal.c                   |    2 +-
 kernel/acpi/acpica/tbxface.c                    |    2 +-
 kernel/acpi/acpica/utcopy.c                     |    2 +-
 kernel/acpi/acpica/utdelete.c                   |    2 +-
 kernel/acpi/acpica/uteval.c                     |    2 +-
 kernel/acpi/acpica/utglobal.c                   |    2 +-
 kernel/acpi/acpica/utinit.c                     |    2 +-
 kernel/acpi/acpica/utmisc.c                     |    2 +-
 kernel/acpi/acpica/utobject.c                   |    2 +-
 kernel/acpi/acpica/utxface.c                    |    2 +-
 63 files changed, 62 insertions(+), 62 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acnamesp.h (100%)

diff --git a/include/acpi/acnamesp.h b/kernel/acpi/acpica/acnamesp.h
similarity index 100%
rename from include/acpi/acnamesp.h
rename to kernel/acpi/acpica/acnamesp.h
diff --git a/kernel/acpi/acpica/dsfield.c b/kernel/acpi/acpica/dsfield.c
index 02e90dd..73a85c8 100644
--- a/kernel/acpi/acpica/dsfield.c
+++ b/kernel/acpi/acpica/dsfield.c
@@ -46,7 +46,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/acparser.h>
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dsinit.c b/kernel/acpi/acpica/dsinit.c
index cc8f5c5..c063e81 100644
--- a/kernel/acpi/acpica/dsinit.c
+++ b/kernel/acpi/acpica/dsinit.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acdispat.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dsmethod.c b/kernel/acpi/acpica/dsmethod.c
index 7172036..cae673e 100644
--- a/kernel/acpi/acpica/dsmethod.c
+++ b/kernel/acpi/acpica/dsmethod.c
@@ -46,7 +46,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #ifdef ACPI_DISASSEMBLER
 #include <acpi/acdisasm.h>
 #endif
diff --git a/kernel/acpi/acpica/dsmthdat.c b/kernel/acpi/acpica/dsmthdat.c
index ce677b7..da0f546 100644
--- a/kernel/acpi/acpica/dsmthdat.c
+++ b/kernel/acpi/acpica/dsmthdat.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acdispat.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acinterp.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dsobject.c b/kernel/acpi/acpica/dsobject.c
index 77faceb..8ed96dc 100644
--- a/kernel/acpi/acpica/dsobject.c
+++ b/kernel/acpi/acpica/dsobject.c
@@ -46,7 +46,7 @@
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include "acdispat.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acinterp.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index 30f02d5..e2732fe 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -48,7 +48,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acevents.h"
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/dsutils.c b/kernel/acpi/acpica/dsutils.c
index f763142..bb302ca 100644
--- a/kernel/acpi/acpica/dsutils.c
+++ b/kernel/acpi/acpica/dsutils.c
@@ -47,7 +47,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acdebug.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dswexec.c b/kernel/acpi/acpica/dswexec.c
index 94dfc1d..dc7d87c 100644
--- a/kernel/acpi/acpica/dswexec.c
+++ b/kernel/acpi/acpica/dswexec.c
@@ -48,7 +48,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acdebug.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dswload.c b/kernel/acpi/acpica/dswload.c
index 0a1c260..35b56e7 100644
--- a/kernel/acpi/acpica/dswload.c
+++ b/kernel/acpi/acpica/dswload.c
@@ -47,7 +47,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acevents.h"
 
 #ifdef ACPI_ASL_COMPILER
diff --git a/kernel/acpi/acpica/dswstate.c b/kernel/acpi/acpica/dswstate.c
index c65aae5..f04912f 100644
--- a/kernel/acpi/acpica/dswstate.c
+++ b/kernel/acpi/acpica/dswstate.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include "acdispat.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dswstate")
diff --git a/kernel/acpi/acpica/evgpe.c b/kernel/acpi/acpica/evgpe.c
index 83079e9..f345ced 100644
--- a/kernel/acpi/acpica/evgpe.c
+++ b/kernel/acpi/acpica/evgpe.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acevents.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evgpe")
diff --git a/kernel/acpi/acpica/evgpeblk.c b/kernel/acpi/acpica/evgpeblk.c
index 638b3a8..484cc05 100644
--- a/kernel/acpi/acpica/evgpeblk.c
+++ b/kernel/acpi/acpica/evgpeblk.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acevents.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evgpeblk")
diff --git a/kernel/acpi/acpica/evmisc.c b/kernel/acpi/acpica/evmisc.c
index b864c73..5f89305 100644
--- a/kernel/acpi/acpica/evmisc.c
+++ b/kernel/acpi/acpica/evmisc.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acevents.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acinterp.h"
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evregion.c b/kernel/acpi/acpica/evregion.c
index ee9ee30..665c088 100644
--- a/kernel/acpi/acpica/evregion.c
+++ b/kernel/acpi/acpica/evregion.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acevents.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acinterp.h"
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evrgnini.c b/kernel/acpi/acpica/evrgnini.c
index 7dae903..f3f1fb4 100644
--- a/kernel/acpi/acpica/evrgnini.c
+++ b/kernel/acpi/acpica/evrgnini.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acevents.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evrgnini")
diff --git a/kernel/acpi/acpica/evxface.c b/kernel/acpi/acpica/evxface.c
index 5b1d72d..3aca901 100644
--- a/kernel/acpi/acpica/evxface.c
+++ b/kernel/acpi/acpica/evxface.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acevents.h"
 #include "acinterp.h"
 
diff --git a/kernel/acpi/acpica/evxfevnt.c b/kernel/acpi/acpica/evxfevnt.c
index feb7eb9..b3f8caa 100644
--- a/kernel/acpi/acpica/evxfevnt.c
+++ b/kernel/acpi/acpica/evxfevnt.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acevents.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evxfregn.c b/kernel/acpi/acpica/evxfregn.c
index 7a9348a..479e7a3 100644
--- a/kernel/acpi/acpica/evxfregn.c
+++ b/kernel/acpi/acpica/evxfregn.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acevents.h"
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/exconfig.c b/kernel/acpi/acpica/exconfig.c
index 05727e6..fb8e36d 100644
--- a/kernel/acpi/acpica/exconfig.c
+++ b/kernel/acpi/acpica/exconfig.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/actables.h>
 #include "acdispat.h"
 
diff --git a/kernel/acpi/acpica/excreate.c b/kernel/acpi/acpica/excreate.c
index fc50a93..a3f62fc 100644
--- a/kernel/acpi/acpica/excreate.c
+++ b/kernel/acpi/acpica/excreate.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("excreate")
diff --git a/kernel/acpi/acpica/exdump.c b/kernel/acpi/acpica/exdump.c
index 34b105c..26cf1df 100644
--- a/kernel/acpi/acpica/exdump.c
+++ b/kernel/acpi/acpica/exdump.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exdump")
diff --git a/kernel/acpi/acpica/exoparg1.c b/kernel/acpi/acpica/exoparg1.c
index cfeafa7..7a2d7e2 100644
--- a/kernel/acpi/acpica/exoparg1.c
+++ b/kernel/acpi/acpica/exoparg1.c
@@ -48,7 +48,7 @@
 #include "acdispat.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exoparg1")
diff --git a/kernel/acpi/acpica/exprep.c b/kernel/acpi/acpica/exprep.c
index 88f78c7..4f17019 100644
--- a/kernel/acpi/acpica/exprep.c
+++ b/kernel/acpi/acpica/exprep.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exprep")
diff --git a/kernel/acpi/acpica/exresnte.c b/kernel/acpi/acpica/exresnte.c
index d6a0ccf..a063a74 100644
--- a/kernel/acpi/acpica/exresnte.c
+++ b/kernel/acpi/acpica/exresnte.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exresnte")
diff --git a/kernel/acpi/acpica/exresolv.c b/kernel/acpi/acpica/exresolv.c
index f3f71a7..0cb0e9d 100644
--- a/kernel/acpi/acpica/exresolv.c
+++ b/kernel/acpi/acpica/exresolv.c
@@ -47,7 +47,7 @@
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exresolv")
diff --git a/kernel/acpi/acpica/exresop.c b/kernel/acpi/acpica/exresop.c
index 5748ff9..68b9577 100644
--- a/kernel/acpi/acpica/exresop.c
+++ b/kernel/acpi/acpica/exresop.c
@@ -47,7 +47,7 @@
 #include <acpi/amlcode.h>
 #include <acpi/acparser.h>
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exresop")
diff --git a/kernel/acpi/acpica/exstore.c b/kernel/acpi/acpica/exstore.c
index 0786ef1..7bb405b 100644
--- a/kernel/acpi/acpica/exstore.c
+++ b/kernel/acpi/acpica/exstore.c
@@ -47,7 +47,7 @@
 #include "acdispat.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exstore")
diff --git a/kernel/acpi/acpica/hwregs.c b/kernel/acpi/acpica/hwregs.c
index 73fefc1..4dc43b0 100644
--- a/kernel/acpi/acpica/hwregs.c
+++ b/kernel/acpi/acpica/hwregs.c
@@ -45,7 +45,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acevents.h"
 
 #define _COMPONENT          ACPI_HARDWARE
diff --git a/kernel/acpi/acpica/hwxface.c b/kernel/acpi/acpica/hwxface.c
index 1b1e3a4..ae597c0 100644
--- a/kernel/acpi/acpica/hwxface.c
+++ b/kernel/acpi/acpica/hwxface.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwxface")
diff --git a/kernel/acpi/acpica/nsaccess.c b/kernel/acpi/acpica/nsaccess.c
index d811edc..c7addfe 100644
--- a/kernel/acpi/acpica/nsaccess.c
+++ b/kernel/acpi/acpica/nsaccess.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acdispat.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsalloc.c b/kernel/acpi/acpica/nsalloc.c
index 5bc78a6..f976d84 100644
--- a/kernel/acpi/acpica/nsalloc.c
+++ b/kernel/acpi/acpica/nsalloc.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsalloc")
diff --git a/kernel/acpi/acpica/nsdump.c b/kernel/acpi/acpica/nsdump.c
index c15eb13..0da33c8 100644
--- a/kernel/acpi/acpica/nsdump.c
+++ b/kernel/acpi/acpica/nsdump.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsdump")
diff --git a/kernel/acpi/acpica/nsdumpdv.c b/kernel/acpi/acpica/nsdumpdv.c
index 447948d..41994fe 100644
--- a/kernel/acpi/acpica/nsdumpdv.c
+++ b/kernel/acpi/acpica/nsdumpdv.c
@@ -50,7 +50,7 @@
 ACPI_MODULE_NAME("nsdumpdv")
 #ifdef ACPI_OBSOLETE_FUNCTIONS
 #if defined(ACPI_DEBUG_OUTPUT) || defined(ACPI_DEBUGGER)
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ns_dump_one_device
diff --git a/kernel/acpi/acpica/nseval.c b/kernel/acpi/acpica/nseval.c
index 1e438b8..07560e7 100644
--- a/kernel/acpi/acpica/nseval.c
+++ b/kernel/acpi/acpica/nseval.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nseval")
diff --git a/kernel/acpi/acpica/nsinit.c b/kernel/acpi/acpica/nsinit.c
index 6a1dfd7..13501cb 100644
--- a/kernel/acpi/acpica/nsinit.c
+++ b/kernel/acpi/acpica/nsinit.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include <linux/nmi.h>
diff --git a/kernel/acpi/acpica/nsload.c b/kernel/acpi/acpica/nsload.c
index cbc673c..32e530d 100644
--- a/kernel/acpi/acpica/nsload.c
+++ b/kernel/acpi/acpica/nsload.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acdispat.h"
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/nsnames.c b/kernel/acpi/acpica/nsnames.c
index 36d79bd..558fba3 100644
--- a/kernel/acpi/acpica/nsnames.c
+++ b/kernel/acpi/acpica/nsnames.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsnames")
diff --git a/kernel/acpi/acpica/nsobject.c b/kernel/acpi/acpica/nsobject.c
index 3063da2..08a97a5 100644
--- a/kernel/acpi/acpica/nsobject.c
+++ b/kernel/acpi/acpica/nsobject.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsobject")
diff --git a/kernel/acpi/acpica/nsparse.c b/kernel/acpi/acpica/nsparse.c
index f509df8..eae2c46 100644
--- a/kernel/acpi/acpica/nsparse.c
+++ b/kernel/acpi/acpica/nsparse.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/acparser.h>
 #include "acdispat.h"
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/nspredef.c b/kernel/acpi/acpica/nspredef.c
index 842fadd..b03a27b 100644
--- a/kernel/acpi/acpica/nspredef.c
+++ b/kernel/acpi/acpica/nspredef.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/acpredef.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nssearch.c b/kernel/acpi/acpica/nssearch.c
index 6414fc2..6fea13f 100644
--- a/kernel/acpi/acpica/nssearch.c
+++ b/kernel/acpi/acpica/nssearch.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nssearch")
diff --git a/kernel/acpi/acpica/nsutils.c b/kernel/acpi/acpica/nsutils.c
index 0f01952..ac83061 100644
--- a/kernel/acpi/acpica/nsutils.c
+++ b/kernel/acpi/acpica/nsutils.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/amlcode.h>
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/nswalk.c b/kernel/acpi/acpica/nswalk.c
index 9691644..200895f 100644
--- a/kernel/acpi/acpica/nswalk.c
+++ b/kernel/acpi/acpica/nswalk.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nswalk")
diff --git a/kernel/acpi/acpica/nsxfeval.c b/kernel/acpi/acpica/nsxfeval.c
index 1ed9295..22a7171 100644
--- a/kernel/acpi/acpica/nsxfeval.c
+++ b/kernel/acpi/acpica/nsxfeval.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acinterp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsxfname.c b/kernel/acpi/acpica/nsxfname.c
index 648c947..9589fea 100644
--- a/kernel/acpi/acpica/nsxfname.c
+++ b/kernel/acpi/acpica/nsxfname.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsxfname")
diff --git a/kernel/acpi/acpica/nsxfobj.c b/kernel/acpi/acpica/nsxfobj.c
index 5252001..1c7efc1 100644
--- a/kernel/acpi/acpica/nsxfobj.c
+++ b/kernel/acpi/acpica/nsxfobj.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsxfobj")
diff --git a/kernel/acpi/acpica/psargs.c b/kernel/acpi/acpica/psargs.c
index ec7941b..0765087 100644
--- a/kernel/acpi/acpica/psargs.c
+++ b/kernel/acpi/acpica/psargs.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acdispat.h"
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/psparse.c b/kernel/acpi/acpica/psparse.c
index f6cdcfe..c065b31 100644
--- a/kernel/acpi/acpica/psparse.c
+++ b/kernel/acpi/acpica/psparse.c
@@ -55,7 +55,7 @@
 #include <acpi/acparser.h>
 #include "acdispat.h"
 #include <acpi/amlcode.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acinterp.h"
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/rscalc.c b/kernel/acpi/acpica/rscalc.c
index 1300f94..4d44f58 100644
--- a/kernel/acpi/acpica/rscalc.c
+++ b/kernel/acpi/acpica/rscalc.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acresrc.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rscalc")
diff --git a/kernel/acpi/acpica/rscreate.c b/kernel/acpi/acpica/rscreate.c
index 499985d..0998933 100644
--- a/kernel/acpi/acpica/rscreate.c
+++ b/kernel/acpi/acpica/rscreate.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acresrc.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rscreate")
diff --git a/kernel/acpi/acpica/rsutils.c b/kernel/acpi/acpica/rsutils.c
index da89892..6c30ea3 100644
--- a/kernel/acpi/acpica/rsutils.c
+++ b/kernel/acpi/acpica/rsutils.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsxface.c b/kernel/acpi/acpica/rsxface.c
index b95f65a..f9f94a0 100644
--- a/kernel/acpi/acpica/rsxface.c
+++ b/kernel/acpi/acpica/rsxface.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acresrc.h>
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_RESOURCES
 ACPI_MODULE_NAME("rsxface")
diff --git a/kernel/acpi/acpica/tbinstal.c b/kernel/acpi/acpica/tbinstal.c
index 6cb77be..94fe615 100644
--- a/kernel/acpi/acpica/tbinstal.c
+++ b/kernel/acpi/acpica/tbinstal.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_TABLES
diff --git a/kernel/acpi/acpica/tbxface.c b/kernel/acpi/acpica/tbxface.c
index b3edad1..ef5954f 100644
--- a/kernel/acpi/acpica/tbxface.c
+++ b/kernel/acpi/acpica/tbxface.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_TABLES
diff --git a/kernel/acpi/acpica/utcopy.c b/kernel/acpi/acpica/utcopy.c
index 9150073..b0dcfd3 100644
--- a/kernel/acpi/acpica/utcopy.c
+++ b/kernel/acpi/acpica/utcopy.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utdelete.c b/kernel/acpi/acpica/utdelete.c
index cbb6813..a0be9e3 100644
--- a/kernel/acpi/acpica/utdelete.c
+++ b/kernel/acpi/acpica/utdelete.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acevents.h"
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/uteval.c b/kernel/acpi/acpica/uteval.c
index f2a9fe0..da9450b 100644
--- a/kernel/acpi/acpica/uteval.c
+++ b/kernel/acpi/acpica/uteval.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acinterp.h"
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utglobal.c b/kernel/acpi/acpica/utglobal.c
index 1bc2fa0..a3ab9d9 100644
--- a/kernel/acpi/acpica/utglobal.c
+++ b/kernel/acpi/acpica/utglobal.c
@@ -45,7 +45,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utglobal")
diff --git a/kernel/acpi/acpica/utinit.c b/kernel/acpi/acpica/utinit.c
index 97d9305..10fb977 100644
--- a/kernel/acpi/acpica/utinit.c
+++ b/kernel/acpi/acpica/utinit.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acevents.h"
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/utmisc.c b/kernel/acpi/acpica/utmisc.c
index 95c991d..c1f7f4e 100644
--- a/kernel/acpi/acpica/utmisc.c
+++ b/kernel/acpi/acpica/utmisc.c
@@ -45,7 +45,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utmisc")
diff --git a/kernel/acpi/acpica/utobject.c b/kernel/acpi/acpica/utobject.c
index 9dd272a..4279ed3 100644
--- a/kernel/acpi/acpica/utobject.c
+++ b/kernel/acpi/acpica/utobject.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utobject")
diff --git a/kernel/acpi/acpica/utxface.c b/kernel/acpi/acpica/utxface.c
index 57b0c02..0edc8fb 100644
--- a/kernel/acpi/acpica/utxface.c
+++ b/kernel/acpi/acpica/utxface.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acevents.h"
-#include <acpi/acnamesp.h>
+#include "acnamesp.h"
 #include "acdebug.h"
 #include <acpi/actables.h>
 
-- 
1.5.6.6

