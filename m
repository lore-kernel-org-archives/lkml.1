Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYLaKzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYLaKzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYLaKwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:33 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:36608 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYLaKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:13 -0500
Date: Wed, 31 Dec 2008 05:51:53 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 03/15] ACPICA: move common private headers under
 kernel/acpi/acpica/
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <c6b6f68232ab6da57e764c64b23b4649c4e7c463.1230719801.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/accommon.h |    0 
 {include/acpi => kernel/acpi/acpica}/acconfig.h |    0 
 {include/acpi => kernel/acpi/acpica}/acglobal.h |    0 
 {include/acpi => kernel/acpi/acpica}/achware.h  |    0 
 {include/acpi => kernel/acpi/acpica}/aclocal.h  |    0 
 {include/acpi => kernel/acpi/acpica}/acmacros.h |    0 
 {include/acpi => kernel/acpi/acpica}/acobject.h |    0 
 {include/acpi => kernel/acpi/acpica}/acstruct.h |    0 
 {include/acpi => kernel/acpi/acpica}/acutils.h  |    0 
 kernel/acpi/acpica/dsfield.c                    |    2 +-
 kernel/acpi/acpica/dsinit.c                     |    2 +-
 kernel/acpi/acpica/dsmethod.c                   |    2 +-
 kernel/acpi/acpica/dsmthdat.c                   |    2 +-
 kernel/acpi/acpica/dsobject.c                   |    2 +-
 kernel/acpi/acpica/dsopcode.c                   |    2 +-
 kernel/acpi/acpica/dsutils.c                    |    2 +-
 kernel/acpi/acpica/dswexec.c                    |    2 +-
 kernel/acpi/acpica/dswload.c                    |    2 +-
 kernel/acpi/acpica/dswscope.c                   |    2 +-
 kernel/acpi/acpica/dswstate.c                   |    2 +-
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
 kernel/acpi/acpica/hwacpi.c                     |    2 +-
 kernel/acpi/acpica/hwgpe.c                      |    2 +-
 kernel/acpi/acpica/hwregs.c                     |    2 +-
 kernel/acpi/acpica/hwsleep.c                    |    2 +-
 kernel/acpi/acpica/hwtimer.c                    |    2 +-
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
 kernel/acpi/acpica/psloop.c                     |    2 +-
 kernel/acpi/acpica/psopcode.c                   |    2 +-
 kernel/acpi/acpica/psparse.c                    |    2 +-
 kernel/acpi/acpica/psscope.c                    |    2 +-
 kernel/acpi/acpica/pstree.c                     |    2 +-
 kernel/acpi/acpica/psutils.c                    |    2 +-
 kernel/acpi/acpica/pswalk.c                     |    2 +-
 kernel/acpi/acpica/psxface.c                    |    2 +-
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
 kernel/acpi/acpica/tbfadt.c                     |    2 +-
 kernel/acpi/acpica/tbfind.c                     |    2 +-
 kernel/acpi/acpica/tbinstal.c                   |    2 +-
 kernel/acpi/acpica/tbutils.c                    |    2 +-
 kernel/acpi/acpica/tbxface.c                    |    2 +-
 kernel/acpi/acpica/tbxfroot.c                   |    2 +-
 kernel/acpi/acpica/utalloc.c                    |    2 +-
 kernel/acpi/acpica/utcache.c                    |    2 +-
 kernel/acpi/acpica/utcopy.c                     |    2 +-
 kernel/acpi/acpica/utdebug.c                    |    2 +-
 kernel/acpi/acpica/utdelete.c                   |    2 +-
 kernel/acpi/acpica/uteval.c                     |    2 +-
 kernel/acpi/acpica/utglobal.c                   |    2 +-
 kernel/acpi/acpica/utinit.c                     |    2 +-
 kernel/acpi/acpica/utmath.c                     |    2 +-
 kernel/acpi/acpica/utmisc.c                     |    2 +-
 kernel/acpi/acpica/utmutex.c                    |    2 +-
 kernel/acpi/acpica/utobject.c                   |    2 +-
 kernel/acpi/acpica/utresrc.c                    |    2 +-
 kernel/acpi/acpica/utstate.c                    |    2 +-
 kernel/acpi/acpica/utxface.c                    |    2 +-
 118 files changed, 109 insertions(+), 109 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/accommon.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/acconfig.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/acglobal.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/achware.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/aclocal.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/acmacros.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/acobject.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/acstruct.h (100%)
 rename {include/acpi => kernel/acpi/acpica}/acutils.h (100%)

diff --git a/include/acpi/accommon.h b/kernel/acpi/acpica/accommon.h
similarity index 100%
rename from include/acpi/accommon.h
rename to kernel/acpi/acpica/accommon.h
diff --git a/include/acpi/acconfig.h b/kernel/acpi/acpica/acconfig.h
similarity index 100%
rename from include/acpi/acconfig.h
rename to kernel/acpi/acpica/acconfig.h
diff --git a/include/acpi/acglobal.h b/kernel/acpi/acpica/acglobal.h
similarity index 100%
rename from include/acpi/acglobal.h
rename to kernel/acpi/acpica/acglobal.h
diff --git a/include/acpi/achware.h b/kernel/acpi/acpica/achware.h
similarity index 100%
rename from include/acpi/achware.h
rename to kernel/acpi/acpica/achware.h
diff --git a/include/acpi/aclocal.h b/kernel/acpi/acpica/aclocal.h
similarity index 100%
rename from include/acpi/aclocal.h
rename to kernel/acpi/acpica/aclocal.h
diff --git a/include/acpi/acmacros.h b/kernel/acpi/acpica/acmacros.h
similarity index 100%
rename from include/acpi/acmacros.h
rename to kernel/acpi/acpica/acmacros.h
diff --git a/include/acpi/acobject.h b/kernel/acpi/acpica/acobject.h
similarity index 100%
rename from include/acpi/acobject.h
rename to kernel/acpi/acpica/acobject.h
diff --git a/include/acpi/acstruct.h b/kernel/acpi/acpica/acstruct.h
similarity index 100%
rename from include/acpi/acstruct.h
rename to kernel/acpi/acpica/acstruct.h
diff --git a/include/acpi/acutils.h b/kernel/acpi/acpica/acutils.h
similarity index 100%
rename from include/acpi/acutils.h
rename to kernel/acpi/acpica/acutils.h
diff --git a/kernel/acpi/acpica/dsfield.c b/kernel/acpi/acpica/dsfield.c
index 5fbc240..4c2288c 100644
--- a/kernel/acpi/acpica/dsfield.c
+++ b/kernel/acpi/acpica/dsfield.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/dsinit.c b/kernel/acpi/acpica/dsinit.c
index 4f1cdd8..d55d3eb 100644
--- a/kernel/acpi/acpica/dsinit.c
+++ b/kernel/acpi/acpica/dsinit.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acdispat.h>
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/dsmethod.c b/kernel/acpi/acpica/dsmethod.c
index 64ebccb..c468936 100644
--- a/kernel/acpi/acpica/dsmethod.c
+++ b/kernel/acpi/acpica/dsmethod.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/dsmthdat.c b/kernel/acpi/acpica/dsmthdat.c
index a1a1199..0d4135a 100644
--- a/kernel/acpi/acpica/dsmthdat.c
+++ b/kernel/acpi/acpica/dsmthdat.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acdispat.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/dsobject.c b/kernel/acpi/acpica/dsobject.c
index 6e6c73c..e9efea0 100644
--- a/kernel/acpi/acpica/dsobject.c
+++ b/kernel/acpi/acpica/dsobject.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index cb8a0d3..a0850bb 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
diff --git a/kernel/acpi/acpica/dsutils.c b/kernel/acpi/acpica/dsutils.c
index 9c88846..876f7ae 100644
--- a/kernel/acpi/acpica/dsutils.c
+++ b/kernel/acpi/acpica/dsutils.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
diff --git a/kernel/acpi/acpica/dswexec.c b/kernel/acpi/acpica/dswexec.c
index 2482cbd..b3bd502 100644
--- a/kernel/acpi/acpica/dswexec.c
+++ b/kernel/acpi/acpica/dswexec.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
diff --git a/kernel/acpi/acpica/dswload.c b/kernel/acpi/acpica/dswload.c
index 2d71ced..35f901e 100644
--- a/kernel/acpi/acpica/dswload.c
+++ b/kernel/acpi/acpica/dswload.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
diff --git a/kernel/acpi/acpica/dswscope.c b/kernel/acpi/acpica/dswscope.c
index 8030541..7ddf845 100644
--- a/kernel/acpi/acpica/dswscope.c
+++ b/kernel/acpi/acpica/dswscope.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acdispat.h>
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/dswstate.c b/kernel/acpi/acpica/dswstate.c
index a7543c4..0464cfd 100644
--- a/kernel/acpi/acpica/dswstate.c
+++ b/kernel/acpi/acpica/dswstate.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acdispat.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/evevent.c b/kernel/acpi/acpica/evevent.c
index 86bf083..d42d26c 100644
--- a/kernel/acpi/acpica/evevent.c
+++ b/kernel/acpi/acpica/evevent.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evgpe.c b/kernel/acpi/acpica/evgpe.c
index d977960..c1b2e71 100644
--- a/kernel/acpi/acpica/evgpe.c
+++ b/kernel/acpi/acpica/evgpe.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/evgpeblk.c b/kernel/acpi/acpica/evgpeblk.c
index 2a8d185..bdc53d4 100644
--- a/kernel/acpi/acpica/evgpeblk.c
+++ b/kernel/acpi/acpica/evgpeblk.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/evmisc.c b/kernel/acpi/acpica/evmisc.c
index 16f2c1a..da0e220 100644
--- a/kernel/acpi/acpica/evmisc.c
+++ b/kernel/acpi/acpica/evmisc.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/evregion.c b/kernel/acpi/acpica/evregion.c
index 7346093..10859f0 100644
--- a/kernel/acpi/acpica/evregion.c
+++ b/kernel/acpi/acpica/evregion.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/evrgnini.c b/kernel/acpi/acpica/evrgnini.c
index 1b7f9fd..5348a9e 100644
--- a/kernel/acpi/acpica/evrgnini.c
+++ b/kernel/acpi/acpica/evrgnini.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/evsci.c b/kernel/acpi/acpica/evsci.c
index 18dce10..a0e5800 100644
--- a/kernel/acpi/acpica/evsci.c
+++ b/kernel/acpi/acpica/evsci.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 
 #define _COMPONENT          ACPI_EVENTS
diff --git a/kernel/acpi/acpica/evxface.c b/kernel/acpi/acpica/evxface.c
index 3b6a069..5577671 100644
--- a/kernel/acpi/acpica/evxface.c
+++ b/kernel/acpi/acpica/evxface.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acevents.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/evxfevnt.c b/kernel/acpi/acpica/evxfevnt.c
index f33cc30..11b79a3 100644
--- a/kernel/acpi/acpica/evxfevnt.c
+++ b/kernel/acpi/acpica/evxfevnt.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/evxfregn.c b/kernel/acpi/acpica/evxfregn.c
index b863394..6e5e277 100644
--- a/kernel/acpi/acpica/evxfregn.c
+++ b/kernel/acpi/acpica/evxfregn.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acevents.h>
 
diff --git a/kernel/acpi/acpica/exconfig.c b/kernel/acpi/acpica/exconfig.c
index be32d01..533a8be 100644
--- a/kernel/acpi/acpica/exconfig.c
+++ b/kernel/acpi/acpica/exconfig.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/exconvrt.c b/kernel/acpi/acpica/exconvrt.c
index caeead4..0f1dffd 100644
--- a/kernel/acpi/acpica/exconvrt.c
+++ b/kernel/acpi/acpica/exconvrt.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/excreate.c b/kernel/acpi/acpica/excreate.c
index 5aa65a2..4f26a8a 100644
--- a/kernel/acpi/acpica/excreate.c
+++ b/kernel/acpi/acpica/excreate.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/exdump.c b/kernel/acpi/acpica/exdump.c
index 8241b9e..b2b8fd2 100644
--- a/kernel/acpi/acpica/exdump.c
+++ b/kernel/acpi/acpica/exdump.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/exfield.c b/kernel/acpi/acpica/exfield.c
index 7b6df03..81a6883 100644
--- a/kernel/acpi/acpica/exfield.c
+++ b/kernel/acpi/acpica/exfield.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
 
diff --git a/kernel/acpi/acpica/exfldio.c b/kernel/acpi/acpica/exfldio.c
index 33cd17a..ecb8b83 100644
--- a/kernel/acpi/acpica/exfldio.c
+++ b/kernel/acpi/acpica/exfldio.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/acevents.h>
diff --git a/kernel/acpi/acpica/exmisc.c b/kernel/acpi/acpica/exmisc.c
index e445463..28d09e6 100644
--- a/kernel/acpi/acpica/exmisc.c
+++ b/kernel/acpi/acpica/exmisc.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/amlresrc.h>
diff --git a/kernel/acpi/acpica/exmutex.c b/kernel/acpi/acpica/exmutex.c
index f86bcee..eac86c0 100644
--- a/kernel/acpi/acpica/exmutex.c
+++ b/kernel/acpi/acpica/exmutex.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/acevents.h>
 
diff --git a/kernel/acpi/acpica/exnames.c b/kernel/acpi/acpica/exnames.c
index 12d3513..c1dee3b 100644
--- a/kernel/acpi/acpica/exnames.c
+++ b/kernel/acpi/acpica/exnames.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/exoparg1.c b/kernel/acpi/acpica/exoparg1.c
index 52d78b8..f1daf0c 100644
--- a/kernel/acpi/acpica/exoparg1.c
+++ b/kernel/acpi/acpica/exoparg1.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/exoparg2.c b/kernel/acpi/acpica/exoparg2.c
index b01980d..83b2e59 100644
--- a/kernel/acpi/acpica/exoparg2.c
+++ b/kernel/acpi/acpica/exoparg2.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acinterp.h>
 #include <acpi/acevents.h>
diff --git a/kernel/acpi/acpica/exoparg3.c b/kernel/acpi/acpica/exoparg3.c
index 26dbd5c..69a3fd2 100644
--- a/kernel/acpi/acpica/exoparg3.c
+++ b/kernel/acpi/acpica/exoparg3.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/exoparg6.c b/kernel/acpi/acpica/exoparg6.c
index bbbba50..9b5e0da 100644
--- a/kernel/acpi/acpica/exoparg6.c
+++ b/kernel/acpi/acpica/exoparg6.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/exprep.c b/kernel/acpi/acpica/exprep.c
index 8f2baa9..59f8410 100644
--- a/kernel/acpi/acpica/exprep.c
+++ b/kernel/acpi/acpica/exprep.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/exregion.c b/kernel/acpi/acpica/exregion.c
index ceb269e..bfff7f7 100644
--- a/kernel/acpi/acpica/exregion.c
+++ b/kernel/acpi/acpica/exregion.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exresnte.c b/kernel/acpi/acpica/exresnte.c
index 77df6e4..fb1f692 100644
--- a/kernel/acpi/acpica/exresnte.c
+++ b/kernel/acpi/acpica/exresnte.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/exresolv.c b/kernel/acpi/acpica/exresolv.c
index 42adde0..e8382f7 100644
--- a/kernel/acpi/acpica/exresolv.c
+++ b/kernel/acpi/acpica/exresolv.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/exresop.c b/kernel/acpi/acpica/exresop.c
index 7602eaf..8fbd5c2 100644
--- a/kernel/acpi/acpica/exresop.c
+++ b/kernel/acpi/acpica/exresop.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acparser.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/exstore.c b/kernel/acpi/acpica/exstore.c
index 6f5647f..c09ae29 100644
--- a/kernel/acpi/acpica/exstore.c
+++ b/kernel/acpi/acpica/exstore.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/exstoren.c b/kernel/acpi/acpica/exstoren.c
index ad2047a..ea2c108 100644
--- a/kernel/acpi/acpica/exstoren.c
+++ b/kernel/acpi/acpica/exstoren.c
@@ -44,7 +44,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/exstorob.c b/kernel/acpi/acpica/exstorob.c
index a48d580..7254ccf 100644
--- a/kernel/acpi/acpica/exstorob.c
+++ b/kernel/acpi/acpica/exstorob.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exsystem.c b/kernel/acpi/acpica/exsystem.c
index a25b2c5..433f663 100644
--- a/kernel/acpi/acpica/exsystem.c
+++ b/kernel/acpi/acpica/exsystem.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exutils.c b/kernel/acpi/acpica/exutils.c
index 0ecdb70..1876c0e 100644
--- a/kernel/acpi/acpica/exutils.c
+++ b/kernel/acpi/acpica/exutils.c
@@ -59,7 +59,7 @@
 #define DEFINE_AML_GLOBALS
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/hwacpi.c b/kernel/acpi/acpica/hwacpi.c
index c76e3cd..a9d4fea 100644
--- a/kernel/acpi/acpica/hwacpi.c
+++ b/kernel/acpi/acpica/hwacpi.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwacpi")
diff --git a/kernel/acpi/acpica/hwgpe.c b/kernel/acpi/acpica/hwgpe.c
index 2b4a85a..04feb50 100644
--- a/kernel/acpi/acpica/hwgpe.c
+++ b/kernel/acpi/acpica/hwgpe.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 
 #define _COMPONENT          ACPI_HARDWARE
diff --git a/kernel/acpi/acpica/hwregs.c b/kernel/acpi/acpica/hwregs.c
index 4bc3bbb..27fd268 100644
--- a/kernel/acpi/acpica/hwregs.c
+++ b/kernel/acpi/acpica/hwregs.c
@@ -44,7 +44,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acevents.h>
 
diff --git a/kernel/acpi/acpica/hwsleep.c b/kernel/acpi/acpica/hwsleep.c
index 54dd3ee..f290376 100644
--- a/kernel/acpi/acpica/hwsleep.c
+++ b/kernel/acpi/acpica/hwsleep.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_HARDWARE
diff --git a/kernel/acpi/acpica/hwtimer.c b/kernel/acpi/acpica/hwtimer.c
index d1eac2a..b7f522c 100644
--- a/kernel/acpi/acpica/hwtimer.c
+++ b/kernel/acpi/acpica/hwtimer.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwtimer")
diff --git a/kernel/acpi/acpica/hwxface.c b/kernel/acpi/acpica/hwxface.c
index a4456fc..1b1e3a4 100644
--- a/kernel/acpi/acpica/hwxface.c
+++ b/kernel/acpi/acpica/hwxface.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_HARDWARE
diff --git a/kernel/acpi/acpica/nsaccess.c b/kernel/acpi/acpica/nsaccess.c
index 7954640..5ecc45b 100644
--- a/kernel/acpi/acpica/nsaccess.c
+++ b/kernel/acpi/acpica/nsaccess.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acdispat.h>
diff --git a/kernel/acpi/acpica/nsalloc.c b/kernel/acpi/acpica/nsalloc.c
index cb2afbf..5bc78a6 100644
--- a/kernel/acpi/acpica/nsalloc.c
+++ b/kernel/acpi/acpica/nsalloc.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsdump.c b/kernel/acpi/acpica/nsdump.c
index 48f02e6..c15eb13 100644
--- a/kernel/acpi/acpica/nsdump.c
+++ b/kernel/acpi/acpica/nsdump.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsdumpdv.c b/kernel/acpi/acpica/nsdumpdv.c
index cc3df78..447948d 100644
--- a/kernel/acpi/acpica/nsdumpdv.c
+++ b/kernel/acpi/acpica/nsdumpdv.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 /* TBD: This entire module is apparently obsolete and should be removed */
 
diff --git a/kernel/acpi/acpica/nseval.c b/kernel/acpi/acpica/nseval.c
index a8d7764..543b0bb 100644
--- a/kernel/acpi/acpica/nseval.c
+++ b/kernel/acpi/acpica/nseval.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/nsinit.c b/kernel/acpi/acpica/nsinit.c
index fe470c4..40b3ed1 100644
--- a/kernel/acpi/acpica/nsinit.c
+++ b/kernel/acpi/acpica/nsinit.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/nsload.c b/kernel/acpi/acpica/nsload.c
index a6e92b3..f00a3ed 100644
--- a/kernel/acpi/acpica/nsload.c
+++ b/kernel/acpi/acpica/nsload.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acdispat.h>
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/nsnames.c b/kernel/acpi/acpica/nsnames.c
index b7e3018..36d79bd 100644
--- a/kernel/acpi/acpica/nsnames.c
+++ b/kernel/acpi/acpica/nsnames.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/nsobject.c b/kernel/acpi/acpica/nsobject.c
index ca9edee..3063da2 100644
--- a/kernel/acpi/acpica/nsobject.c
+++ b/kernel/acpi/acpica/nsobject.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsparse.c b/kernel/acpi/acpica/nsparse.c
index bcfcf42..5385a27 100644
--- a/kernel/acpi/acpica/nsparse.c
+++ b/kernel/acpi/acpica/nsparse.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acparser.h>
 #include <acpi/acdispat.h>
diff --git a/kernel/acpi/acpica/nspredef.c b/kernel/acpi/acpica/nspredef.c
index 1e682d0..842fadd 100644
--- a/kernel/acpi/acpica/nspredef.c
+++ b/kernel/acpi/acpica/nspredef.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acpredef.h>
 
diff --git a/kernel/acpi/acpica/nssearch.c b/kernel/acpi/acpica/nssearch.c
index a76c731..6414fc2 100644
--- a/kernel/acpi/acpica/nssearch.c
+++ b/kernel/acpi/acpica/nssearch.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsutils.c b/kernel/acpi/acpica/nsutils.c
index a443d28..0f01952 100644
--- a/kernel/acpi/acpica/nsutils.c
+++ b/kernel/acpi/acpica/nsutils.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/amlcode.h>
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/nswalk.c b/kernel/acpi/acpica/nswalk.c
index 71b83e9..9691644 100644
--- a/kernel/acpi/acpica/nswalk.c
+++ b/kernel/acpi/acpica/nswalk.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsxfeval.c b/kernel/acpi/acpica/nsxfeval.c
index 598393a..8117b9b 100644
--- a/kernel/acpi/acpica/nsxfeval.c
+++ b/kernel/acpi/acpica/nsxfeval.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
 
diff --git a/kernel/acpi/acpica/nsxfname.c b/kernel/acpi/acpica/nsxfname.c
index 7d5bfa9..648c947 100644
--- a/kernel/acpi/acpica/nsxfname.c
+++ b/kernel/acpi/acpica/nsxfname.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsxfobj.c b/kernel/acpi/acpica/nsxfobj.c
index 80e6322..5252001 100644
--- a/kernel/acpi/acpica/nsxfobj.c
+++ b/kernel/acpi/acpica/nsxfobj.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/psargs.c b/kernel/acpi/acpica/psargs.c
index 852f3a8..3594073 100644
--- a/kernel/acpi/acpica/psargs.c
+++ b/kernel/acpi/acpica/psargs.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/psloop.c b/kernel/acpi/acpica/psloop.c
index fd6648f..427161c 100644
--- a/kernel/acpi/acpica/psloop.c
+++ b/kernel/acpi/acpica/psloop.c
@@ -50,7 +50,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acdispat.h>
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/psopcode.c b/kernel/acpi/acpica/psopcode.c
index 3693a12..b52e198 100644
--- a/kernel/acpi/acpica/psopcode.c
+++ b/kernel/acpi/acpica/psopcode.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acopcode.h>
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/psparse.c b/kernel/acpi/acpica/psparse.c
index 9da48fd..258df64 100644
--- a/kernel/acpi/acpica/psparse.c
+++ b/kernel/acpi/acpica/psparse.c
@@ -51,7 +51,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acdispat.h>
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/psscope.c b/kernel/acpi/acpica/psscope.c
index 22929ca..dc26c4a 100644
--- a/kernel/acpi/acpica/psscope.c
+++ b/kernel/acpi/acpica/psscope.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/pstree.c b/kernel/acpi/acpica/pstree.c
index 8e73fbf..d355ba1 100644
--- a/kernel/acpi/acpica/pstree.c
+++ b/kernel/acpi/acpica/pstree.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/psutils.c b/kernel/acpi/acpica/psutils.c
index eec7d62..d71e180 100644
--- a/kernel/acpi/acpica/psutils.c
+++ b/kernel/acpi/acpica/psutils.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/pswalk.c b/kernel/acpi/acpica/pswalk.c
index dacc422..a0cf80c 100644
--- a/kernel/acpi/acpica/pswalk.c
+++ b/kernel/acpi/acpica/pswalk.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/psxface.c b/kernel/acpi/acpica/psxface.c
index 98c31a8..f5a3a28 100644
--- a/kernel/acpi/acpica/psxface.c
+++ b/kernel/acpi/acpica/psxface.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/rsaddr.c b/kernel/acpi/acpica/rsaddr.c
index b4aba3a..c8b9350 100644
--- a/kernel/acpi/acpica/rsaddr.c
+++ b/kernel/acpi/acpica/rsaddr.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rscalc.c b/kernel/acpi/acpica/rscalc.c
index 4f2b186..1300f94 100644
--- a/kernel/acpi/acpica/rscalc.c
+++ b/kernel/acpi/acpica/rscalc.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/rscreate.c b/kernel/acpi/acpica/rscreate.c
index 3ca6069..499985d 100644
--- a/kernel/acpi/acpica/rscreate.c
+++ b/kernel/acpi/acpica/rscreate.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/rsdump.c b/kernel/acpi/acpica/rsdump.c
index 936a59b..5dee59d 100644
--- a/kernel/acpi/acpica/rsdump.c
+++ b/kernel/acpi/acpica/rsdump.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsinfo.c b/kernel/acpi/acpica/rsinfo.c
index aac41cc..8cb1ef6 100644
--- a/kernel/acpi/acpica/rsinfo.c
+++ b/kernel/acpi/acpica/rsinfo.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsio.c b/kernel/acpi/acpica/rsio.c
index d31129a..7f8c205 100644
--- a/kernel/acpi/acpica/rsio.c
+++ b/kernel/acpi/acpica/rsio.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsirq.c b/kernel/acpi/acpica/rsirq.c
index 9a5a08d..b73b1ee 100644
--- a/kernel/acpi/acpica/rsirq.c
+++ b/kernel/acpi/acpica/rsirq.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rslist.c b/kernel/acpi/acpica/rslist.c
index 4833898..e253f37 100644
--- a/kernel/acpi/acpica/rslist.c
+++ b/kernel/acpi/acpica/rslist.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsmemory.c b/kernel/acpi/acpica/rsmemory.c
index 5fd3746..ac48921 100644
--- a/kernel/acpi/acpica/rsmemory.c
+++ b/kernel/acpi/acpica/rsmemory.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsmisc.c b/kernel/acpi/acpica/rsmisc.c
index 2cd6e8c..375c275 100644
--- a/kernel/acpi/acpica/rsmisc.c
+++ b/kernel/acpi/acpica/rsmisc.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 
 #define _COMPONENT          ACPI_RESOURCES
diff --git a/kernel/acpi/acpica/rsutils.c b/kernel/acpi/acpica/rsutils.c
index 7450105..da89892 100644
--- a/kernel/acpi/acpica/rsutils.c
+++ b/kernel/acpi/acpica/rsutils.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acresrc.h>
 
diff --git a/kernel/acpi/acpica/rsxface.c b/kernel/acpi/acpica/rsxface.c
index 0a27435..b95f65a 100644
--- a/kernel/acpi/acpica/rsxface.c
+++ b/kernel/acpi/acpica/rsxface.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acresrc.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/tbfadt.c b/kernel/acpi/acpica/tbfadt.c
index 87f22e6..9c6769e 100644
--- a/kernel/acpi/acpica/tbfadt.c
+++ b/kernel/acpi/acpica/tbfadt.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_TABLES
diff --git a/kernel/acpi/acpica/tbfind.c b/kernel/acpi/acpica/tbfind.c
index 9d20cb6..941e38c 100644
--- a/kernel/acpi/acpica/tbfind.c
+++ b/kernel/acpi/acpica/tbfind.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_TABLES
diff --git a/kernel/acpi/acpica/tbinstal.c b/kernel/acpi/acpica/tbinstal.c
index 019b0d8..6cb77be 100644
--- a/kernel/acpi/acpica/tbinstal.c
+++ b/kernel/acpi/acpica/tbinstal.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/tbutils.c b/kernel/acpi/acpica/tbutils.c
index 4eb7189..55627ee 100644
--- a/kernel/acpi/acpica/tbutils.c
+++ b/kernel/acpi/acpica/tbutils.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_TABLES
diff --git a/kernel/acpi/acpica/tbxface.c b/kernel/acpi/acpica/tbxface.c
index 1157966..b3edad1 100644
--- a/kernel/acpi/acpica/tbxface.c
+++ b/kernel/acpi/acpica/tbxface.c
@@ -43,7 +43,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/tbxfroot.c b/kernel/acpi/acpica/tbxfroot.c
index 3495dca..8954e01 100644
--- a/kernel/acpi/acpica/tbxfroot.c
+++ b/kernel/acpi/acpica/tbxfroot.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_TABLES
diff --git a/kernel/acpi/acpica/utalloc.c b/kernel/acpi/acpica/utalloc.c
index 2a017b2..b4736db 100644
--- a/kernel/acpi/acpica/utalloc.c
+++ b/kernel/acpi/acpica/utalloc.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acdebug.h>
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utcache.c b/kernel/acpi/acpica/utcache.c
index 1e549fd..b0e672f 100644
--- a/kernel/acpi/acpica/utcache.c
+++ b/kernel/acpi/acpica/utcache.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utcache")
diff --git a/kernel/acpi/acpica/utcopy.c b/kernel/acpi/acpica/utcopy.c
index e6f3002..9150073 100644
--- a/kernel/acpi/acpica/utcopy.c
+++ b/kernel/acpi/acpica/utcopy.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 
diff --git a/kernel/acpi/acpica/utdebug.c b/kernel/acpi/acpica/utdebug.c
index 9a3538c..38821f5 100644
--- a/kernel/acpi/acpica/utdebug.c
+++ b/kernel/acpi/acpica/utdebug.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utdebug")
diff --git a/kernel/acpi/acpica/utdelete.c b/kernel/acpi/acpica/utdelete.c
index 5b4e3b1..c26e1bd 100644
--- a/kernel/acpi/acpica/utdelete.c
+++ b/kernel/acpi/acpica/utdelete.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acevents.h>
diff --git a/kernel/acpi/acpica/uteval.c b/kernel/acpi/acpica/uteval.c
index e1e438c..41ff26a 100644
--- a/kernel/acpi/acpica/uteval.c
+++ b/kernel/acpi/acpica/uteval.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
 
diff --git a/kernel/acpi/acpica/utglobal.c b/kernel/acpi/acpica/utglobal.c
index 3e28d8c..1bc2fa0 100644
--- a/kernel/acpi/acpica/utglobal.c
+++ b/kernel/acpi/acpica/utglobal.c
@@ -44,7 +44,7 @@
 #define DEFINE_ACPI_GLOBALS
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utinit.c b/kernel/acpi/acpica/utinit.c
index 9316ec3..4d07002 100644
--- a/kernel/acpi/acpica/utinit.c
+++ b/kernel/acpi/acpica/utinit.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acevents.h>
 #include <acpi/actables.h>
diff --git a/kernel/acpi/acpica/utmath.c b/kernel/acpi/acpica/utmath.c
index 616d7b2..c9f682d 100644
--- a/kernel/acpi/acpica/utmath.c
+++ b/kernel/acpi/acpica/utmath.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utmath")
diff --git a/kernel/acpi/acpica/utmisc.c b/kernel/acpi/acpica/utmisc.c
index 8f8b407..95c991d 100644
--- a/kernel/acpi/acpica/utmisc.c
+++ b/kernel/acpi/acpica/utmisc.c
@@ -44,7 +44,7 @@
 #include <linux/module.h>
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utmutex.c b/kernel/acpi/acpica/utmutex.c
index 7b48ba3..14eb52c 100644
--- a/kernel/acpi/acpica/utmutex.c
+++ b/kernel/acpi/acpica/utmutex.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utmutex")
diff --git a/kernel/acpi/acpica/utobject.c b/kernel/acpi/acpica/utobject.c
index 964b23c..9dd272a 100644
--- a/kernel/acpi/acpica/utobject.c
+++ b/kernel/acpi/acpica/utobject.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utresrc.c b/kernel/acpi/acpica/utresrc.c
index 0755c5c..118ae85 100644
--- a/kernel/acpi/acpica/utresrc.c
+++ b/kernel/acpi/acpica/utresrc.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/amlresrc.h>
 
 #define _COMPONENT          ACPI_UTILITIES
diff --git a/kernel/acpi/acpica/utstate.c b/kernel/acpi/acpica/utstate.c
index 54c3461..0440c95 100644
--- a/kernel/acpi/acpica/utstate.c
+++ b/kernel/acpi/acpica/utstate.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utstate")
diff --git a/kernel/acpi/acpica/utxface.c b/kernel/acpi/acpica/utxface.c
index 5b27724..1c776d3 100644
--- a/kernel/acpi/acpica/utxface.c
+++ b/kernel/acpi/acpica/utxface.c
@@ -42,7 +42,7 @@
  */
 
 #include <acpi/acpi.h>
-#include <acpi/accommon.h>
+#include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acdebug.h>
-- 
1.5.6.6

