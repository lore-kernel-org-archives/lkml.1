Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYLaKxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYLaKxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYLaKwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:15 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:41129 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYLaKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:10 -0500
Date: Wed, 31 Dec 2008 05:51:56 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 06/15] ACPICA: acdispat.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <5f7c2950812472cc21a1df8d5be322b916c29cda.1230719803.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/acdispat.h |    0 
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
 kernel/acpi/acpica/exconfig.c                   |    2 +-
 kernel/acpi/acpica/exfield.c                    |    2 +-
 kernel/acpi/acpica/exfldio.c                    |    2 +-
 kernel/acpi/acpica/exoparg1.c                   |    2 +-
 kernel/acpi/acpica/exresnte.c                   |    2 +-
 kernel/acpi/acpica/exresolv.c                   |    2 +-
 kernel/acpi/acpica/exstore.c                    |    2 +-
 kernel/acpi/acpica/nsaccess.c                   |    2 +-
 kernel/acpi/acpica/nsinit.c                     |    2 +-
 kernel/acpi/acpica/nsload.c                     |    2 +-
 kernel/acpi/acpica/nsparse.c                    |    2 +-
 kernel/acpi/acpica/psargs.c                     |    2 +-
 kernel/acpi/acpica/psloop.c                     |    2 +-
 kernel/acpi/acpica/psparse.c                    |    2 +-
 kernel/acpi/acpica/psxface.c                    |    2 +-
 27 files changed, 26 insertions(+), 26 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acdispat.h (100%)

diff --git a/include/acpi/acdispat.h b/kernel/acpi/acpica/acdispat.h
similarity index 100%
rename from include/acpi/acdispat.h
rename to kernel/acpi/acpica/acdispat.h
diff --git a/kernel/acpi/acpica/dsfield.c b/kernel/acpi/acpica/dsfield.c
index 4c2288c..7da22b0 100644
--- a/kernel/acpi/acpica/dsfield.c
+++ b/kernel/acpi/acpica/dsfield.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acparser.h>
diff --git a/kernel/acpi/acpica/dsinit.c b/kernel/acpi/acpica/dsinit.c
index d55d3eb..cc8f5c5 100644
--- a/kernel/acpi/acpica/dsinit.c
+++ b/kernel/acpi/acpica/dsinit.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/dsmethod.c b/kernel/acpi/acpica/dsmethod.c
index ae734d0..3dc6def 100644
--- a/kernel/acpi/acpica/dsmethod.c
+++ b/kernel/acpi/acpica/dsmethod.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #ifdef ACPI_DISASSEMBLER
diff --git a/kernel/acpi/acpica/dsmthdat.c b/kernel/acpi/acpica/dsmthdat.c
index 0d4135a..e485f63 100644
--- a/kernel/acpi/acpica/dsmthdat.c
+++ b/kernel/acpi/acpica/dsmthdat.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
 
diff --git a/kernel/acpi/acpica/dsobject.c b/kernel/acpi/acpica/dsobject.c
index e9efea0..e0194d9 100644
--- a/kernel/acpi/acpica/dsobject.c
+++ b/kernel/acpi/acpica/dsobject.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
 
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index a0850bb..ed85e8c 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acevents.h>
diff --git a/kernel/acpi/acpica/dsutils.c b/kernel/acpi/acpica/dsutils.c
index 7f7f59e..07419d2 100644
--- a/kernel/acpi/acpica/dsutils.c
+++ b/kernel/acpi/acpica/dsutils.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include "acdebug.h"
diff --git a/kernel/acpi/acpica/dswexec.c b/kernel/acpi/acpica/dswexec.c
index 696f54b..9be469b 100644
--- a/kernel/acpi/acpica/dswexec.c
+++ b/kernel/acpi/acpica/dswexec.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include "acdebug.h"
diff --git a/kernel/acpi/acpica/dswload.c b/kernel/acpi/acpica/dswload.c
index 35f901e..c885c89 100644
--- a/kernel/acpi/acpica/dswload.c
+++ b/kernel/acpi/acpica/dswload.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acevents.h>
diff --git a/kernel/acpi/acpica/dswscope.c b/kernel/acpi/acpica/dswscope.c
index 7ddf845..908645e 100644
--- a/kernel/acpi/acpica/dswscope.c
+++ b/kernel/acpi/acpica/dswscope.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dswscope")
diff --git a/kernel/acpi/acpica/dswstate.c b/kernel/acpi/acpica/dswstate.c
index 0464cfd..c65aae5 100644
--- a/kernel/acpi/acpica/dswstate.c
+++ b/kernel/acpi/acpica/dswstate.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acnamesp.h>
 
 #define _COMPONENT          ACPI_DISPATCHER
diff --git a/kernel/acpi/acpica/exconfig.c b/kernel/acpi/acpica/exconfig.c
index 533a8be..9970930 100644
--- a/kernel/acpi/acpica/exconfig.c
+++ b/kernel/acpi/acpica/exconfig.c
@@ -46,7 +46,7 @@
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 #include <acpi/actables.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exconfig")
diff --git a/kernel/acpi/acpica/exfield.c b/kernel/acpi/acpica/exfield.c
index 81a6883..9ed3bd7 100644
--- a/kernel/acpi/acpica/exfield.c
+++ b/kernel/acpi/acpica/exfield.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exfldio.c b/kernel/acpi/acpica/exfldio.c
index ecb8b83..6a1ba49 100644
--- a/kernel/acpi/acpica/exfldio.c
+++ b/kernel/acpi/acpica/exfldio.c
@@ -46,7 +46,7 @@
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/acevents.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exfldio")
diff --git a/kernel/acpi/acpica/exoparg1.c b/kernel/acpi/acpica/exoparg1.c
index f1daf0c..872f7dd 100644
--- a/kernel/acpi/acpica/exoparg1.c
+++ b/kernel/acpi/acpica/exoparg1.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/exresnte.c b/kernel/acpi/acpica/exresnte.c
index fb1f692..d66c21b 100644
--- a/kernel/acpi/acpica/exresnte.c
+++ b/kernel/acpi/acpica/exresnte.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/exresolv.c b/kernel/acpi/acpica/exresolv.c
index e8382f7..f1da91a 100644
--- a/kernel/acpi/acpica/exresolv.c
+++ b/kernel/acpi/acpica/exresolv.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/amlcode.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
 
diff --git a/kernel/acpi/acpica/exstore.c b/kernel/acpi/acpica/exstore.c
index c09ae29..742261c 100644
--- a/kernel/acpi/acpica/exstore.c
+++ b/kernel/acpi/acpica/exstore.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
diff --git a/kernel/acpi/acpica/nsaccess.c b/kernel/acpi/acpica/nsaccess.c
index 5ecc45b..d811edc 100644
--- a/kernel/acpi/acpica/nsaccess.c
+++ b/kernel/acpi/acpica/nsaccess.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsaccess")
diff --git a/kernel/acpi/acpica/nsinit.c b/kernel/acpi/acpica/nsinit.c
index 40b3ed1..f2200f1 100644
--- a/kernel/acpi/acpica/nsinit.c
+++ b/kernel/acpi/acpica/nsinit.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <linux/nmi.h>
 
diff --git a/kernel/acpi/acpica/nsload.c b/kernel/acpi/acpica/nsload.c
index f00a3ed..cbc673c 100644
--- a/kernel/acpi/acpica/nsload.c
+++ b/kernel/acpi/acpica/nsload.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acnamesp.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsparse.c b/kernel/acpi/acpica/nsparse.c
index 5385a27..f509df8 100644
--- a/kernel/acpi/acpica/nsparse.c
+++ b/kernel/acpi/acpica/nsparse.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acnamesp.h>
 #include <acpi/acparser.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/psargs.c b/kernel/acpi/acpica/psargs.c
index 3594073..ec7941b 100644
--- a/kernel/acpi/acpica/psargs.c
+++ b/kernel/acpi/acpica/psargs.c
@@ -46,7 +46,7 @@
 #include <acpi/acparser.h>
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("psargs")
diff --git a/kernel/acpi/acpica/psloop.c b/kernel/acpi/acpica/psloop.c
index 427161c..d4f0f65 100644
--- a/kernel/acpi/acpica/psloop.c
+++ b/kernel/acpi/acpica/psloop.c
@@ -52,7 +52,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/psparse.c b/kernel/acpi/acpica/psparse.c
index 258df64..113697f 100644
--- a/kernel/acpi/acpica/psparse.c
+++ b/kernel/acpi/acpica/psparse.c
@@ -53,7 +53,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/amlcode.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
diff --git a/kernel/acpi/acpica/psxface.c b/kernel/acpi/acpica/psxface.c
index f5a3a28..efeb80e 100644
--- a/kernel/acpi/acpica/psxface.c
+++ b/kernel/acpi/acpica/psxface.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acdispat.h>
+#include "acdispat.h"
 #include <acpi/acinterp.h>
 #include <acpi/amlcode.h>
 
-- 
1.5.6.6

