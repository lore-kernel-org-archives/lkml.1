Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYLaKyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYLaKyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYLaKw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:27 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:53027 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYLaKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:12 -0500
Date: Wed, 31 Dec 2008 05:52:05 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 15/15] ACPICA: amlcode.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <fa0b86d98b653d38523d062ffafd0b006c0aa0ee.1230719806.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/amlcode.h |    0 
 kernel/acpi/acpica/dsfield.c                   |    2 +-
 kernel/acpi/acpica/dsmethod.c                  |    2 +-
 kernel/acpi/acpica/dsobject.c                  |    2 +-
 kernel/acpi/acpica/dsopcode.c                  |    2 +-
 kernel/acpi/acpica/dsutils.c                   |    2 +-
 kernel/acpi/acpica/dswexec.c                   |    2 +-
 kernel/acpi/acpica/dswload.c                   |    2 +-
 kernel/acpi/acpica/exconvrt.c                  |    2 +-
 kernel/acpi/acpica/excreate.c                  |    2 +-
 kernel/acpi/acpica/exdump.c                    |    2 +-
 kernel/acpi/acpica/exfldio.c                   |    2 +-
 kernel/acpi/acpica/exmisc.c                    |    2 +-
 kernel/acpi/acpica/exnames.c                   |    2 +-
 kernel/acpi/acpica/exoparg1.c                  |    2 +-
 kernel/acpi/acpica/exoparg2.c                  |    2 +-
 kernel/acpi/acpica/exoparg3.c                  |    2 +-
 kernel/acpi/acpica/exoparg6.c                  |    2 +-
 kernel/acpi/acpica/exprep.c                    |    2 +-
 kernel/acpi/acpica/exresolv.c                  |    2 +-
 kernel/acpi/acpica/exresop.c                   |    2 +-
 kernel/acpi/acpica/exstore.c                   |    2 +-
 kernel/acpi/acpica/exstoren.c                  |    2 +-
 kernel/acpi/acpica/exutils.c                   |    2 +-
 kernel/acpi/acpica/nsaccess.c                  |    2 +-
 kernel/acpi/acpica/nsnames.c                   |    2 +-
 kernel/acpi/acpica/nsutils.c                   |    2 +-
 kernel/acpi/acpica/psargs.c                    |    2 +-
 kernel/acpi/acpica/psloop.c                    |    2 +-
 kernel/acpi/acpica/psopcode.c                  |    2 +-
 kernel/acpi/acpica/psparse.c                   |    2 +-
 kernel/acpi/acpica/pstree.c                    |    2 +-
 kernel/acpi/acpica/psutils.c                   |    2 +-
 kernel/acpi/acpica/psxface.c                   |    2 +-
 34 files changed, 33 insertions(+), 33 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/amlcode.h (100%)

diff --git a/include/acpi/amlcode.h b/kernel/acpi/acpica/amlcode.h
similarity index 100%
rename from include/acpi/amlcode.h
rename to kernel/acpi/acpica/amlcode.h
diff --git a/kernel/acpi/acpica/dsfield.c b/kernel/acpi/acpica/dsfield.c
index 65e27b5..53e27bc 100644
--- a/kernel/acpi/acpica/dsfield.c
+++ b/kernel/acpi/acpica/dsfield.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/dsmethod.c b/kernel/acpi/acpica/dsmethod.c
index cae673e..f537b77 100644
--- a/kernel/acpi/acpica/dsmethod.c
+++ b/kernel/acpi/acpica/dsmethod.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/dsobject.c b/kernel/acpi/acpica/dsobject.c
index ae0140f..15c628e 100644
--- a/kernel/acpi/acpica/dsobject.c
+++ b/kernel/acpi/acpica/dsobject.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acnamesp.h"
 #include "acinterp.h"
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index 20b8005..0c3b4dd 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/dsutils.c b/kernel/acpi/acpica/dsutils.c
index ebc3a79..dabc23a 100644
--- a/kernel/acpi/acpica/dsutils.c
+++ b/kernel/acpi/acpica/dsutils.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/dswexec.c b/kernel/acpi/acpica/dswexec.c
index a2d1932..350e665 100644
--- a/kernel/acpi/acpica/dswexec.c
+++ b/kernel/acpi/acpica/dswexec.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/dswload.c b/kernel/acpi/acpica/dswload.c
index 259d289..3023cea 100644
--- a/kernel/acpi/acpica/dswload.c
+++ b/kernel/acpi/acpica/dswload.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/exconvrt.c b/kernel/acpi/acpica/exconvrt.c
index 49dd801..0be1018 100644
--- a/kernel/acpi/acpica/exconvrt.c
+++ b/kernel/acpi/acpica/exconvrt.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exconvrt")
diff --git a/kernel/acpi/acpica/excreate.c b/kernel/acpi/acpica/excreate.c
index a3f62fc..a57ad25 100644
--- a/kernel/acpi/acpica/excreate.c
+++ b/kernel/acpi/acpica/excreate.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exdump.c b/kernel/acpi/acpica/exdump.c
index 26cf1df..aa31357 100644
--- a/kernel/acpi/acpica/exdump.c
+++ b/kernel/acpi/acpica/exdump.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exfldio.c b/kernel/acpi/acpica/exfldio.c
index d66cd4c..ef58ac4 100644
--- a/kernel/acpi/acpica/exfldio.c
+++ b/kernel/acpi/acpica/exfldio.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acevents.h"
 #include "acdispat.h"
 
diff --git a/kernel/acpi/acpica/exmisc.c b/kernel/acpi/acpica/exmisc.c
index 7498f36..6b0747a 100644
--- a/kernel/acpi/acpica/exmisc.c
+++ b/kernel/acpi/acpica/exmisc.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "amlresrc.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exnames.c b/kernel/acpi/acpica/exnames.c
index 918fbac..ffdae12 100644
--- a/kernel/acpi/acpica/exnames.c
+++ b/kernel/acpi/acpica/exnames.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exnames")
diff --git a/kernel/acpi/acpica/exoparg1.c b/kernel/acpi/acpica/exoparg1.c
index 3bd08bb..b530480 100644
--- a/kernel/acpi/acpica/exoparg1.c
+++ b/kernel/acpi/acpica/exoparg1.c
@@ -47,7 +47,7 @@
 #include "acparser.h"
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exoparg2.c b/kernel/acpi/acpica/exoparg2.c
index 8f321f7..0b4f513 100644
--- a/kernel/acpi/acpica/exoparg2.c
+++ b/kernel/acpi/acpica/exoparg2.c
@@ -46,7 +46,7 @@
 #include "acparser.h"
 #include "acinterp.h"
 #include "acevents.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exoparg2")
diff --git a/kernel/acpi/acpica/exoparg3.c b/kernel/acpi/acpica/exoparg3.c
index dbe7612..c6520bb 100644
--- a/kernel/acpi/acpica/exoparg3.c
+++ b/kernel/acpi/acpica/exoparg3.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include "acinterp.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exoparg3")
diff --git a/kernel/acpi/acpica/exoparg6.c b/kernel/acpi/acpica/exoparg6.c
index 17dfb08..ae43f76 100644
--- a/kernel/acpi/acpica/exoparg6.c
+++ b/kernel/acpi/acpica/exoparg6.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include "acinterp.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exoparg6")
diff --git a/kernel/acpi/acpica/exprep.c b/kernel/acpi/acpica/exprep.c
index 4f17019..33c66eb 100644
--- a/kernel/acpi/acpica/exprep.c
+++ b/kernel/acpi/acpica/exprep.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exresolv.c b/kernel/acpi/acpica/exresolv.c
index 0cb0e9d..3673d2b 100644
--- a/kernel/acpi/acpica/exresolv.c
+++ b/kernel/acpi/acpica/exresolv.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/exresop.c b/kernel/acpi/acpica/exresop.c
index 912148c..3c38027 100644
--- a/kernel/acpi/acpica/exresop.c
+++ b/kernel/acpi/acpica/exresop.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acparser.h"
 #include "acinterp.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/exstore.c b/kernel/acpi/acpica/exstore.c
index 7bb405b..7c6d7e5 100644
--- a/kernel/acpi/acpica/exstore.c
+++ b/kernel/acpi/acpica/exstore.c
@@ -46,7 +46,7 @@
 #include "accommon.h"
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exstoren.c b/kernel/acpi/acpica/exstoren.c
index 1189dca..145d153 100644
--- a/kernel/acpi/acpica/exstoren.c
+++ b/kernel/acpi/acpica/exstoren.c
@@ -46,7 +46,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exstoren")
diff --git a/kernel/acpi/acpica/exutils.c b/kernel/acpi/acpica/exutils.c
index 75f699e..32b85d6 100644
--- a/kernel/acpi/acpica/exutils.c
+++ b/kernel/acpi/acpica/exutils.c
@@ -61,7 +61,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exutils")
diff --git a/kernel/acpi/acpica/nsaccess.c b/kernel/acpi/acpica/nsaccess.c
index c7addfe..88303eb 100644
--- a/kernel/acpi/acpica/nsaccess.c
+++ b/kernel/acpi/acpica/nsaccess.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 #include "acdispat.h"
 
diff --git a/kernel/acpi/acpica/nsnames.c b/kernel/acpi/acpica/nsnames.c
index 558fba3..ae3dc10 100644
--- a/kernel/acpi/acpica/nsnames.c
+++ b/kernel/acpi/acpica/nsnames.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/nsutils.c b/kernel/acpi/acpica/nsutils.c
index b285ed7..3e1149b 100644
--- a/kernel/acpi/acpica/nsutils.c
+++ b/kernel/acpi/acpica/nsutils.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acnamesp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "actables.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
diff --git a/kernel/acpi/acpica/psargs.c b/kernel/acpi/acpica/psargs.c
index a851c73..b161f35 100644
--- a/kernel/acpi/acpica/psargs.c
+++ b/kernel/acpi/acpica/psargs.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 #include "acdispat.h"
 
diff --git a/kernel/acpi/acpica/psloop.c b/kernel/acpi/acpica/psloop.c
index e993e43..c5f6ce1 100644
--- a/kernel/acpi/acpica/psloop.c
+++ b/kernel/acpi/acpica/psloop.c
@@ -53,7 +53,7 @@
 #include "accommon.h"
 #include "acparser.h"
 #include "acdispat.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("psloop")
diff --git a/kernel/acpi/acpica/psopcode.c b/kernel/acpi/acpica/psopcode.c
index 9aede84..3bc3a60 100644
--- a/kernel/acpi/acpica/psopcode.c
+++ b/kernel/acpi/acpica/psopcode.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include "acparser.h"
 #include "acopcode.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("psopcode")
diff --git a/kernel/acpi/acpica/psparse.c b/kernel/acpi/acpica/psparse.c
index 8d45a31..70838e9 100644
--- a/kernel/acpi/acpica/psparse.c
+++ b/kernel/acpi/acpica/psparse.c
@@ -54,7 +54,7 @@
 #include "accommon.h"
 #include "acparser.h"
 #include "acdispat.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 #include "acnamesp.h"
 #include "acinterp.h"
 
diff --git a/kernel/acpi/acpica/pstree.c b/kernel/acpi/acpica/pstree.c
index f317046..4d33891 100644
--- a/kernel/acpi/acpica/pstree.c
+++ b/kernel/acpi/acpica/pstree.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("pstree")
diff --git a/kernel/acpi/acpica/psutils.c b/kernel/acpi/acpica/psutils.c
index 5336631..e636e07 100644
--- a/kernel/acpi/acpica/psutils.c
+++ b/kernel/acpi/acpica/psutils.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acparser.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("psutils")
diff --git a/kernel/acpi/acpica/psxface.c b/kernel/acpi/acpica/psxface.c
index e905037..ff06032 100644
--- a/kernel/acpi/acpica/psxface.c
+++ b/kernel/acpi/acpica/psxface.c
@@ -46,7 +46,7 @@
 #include "acparser.h"
 #include "acdispat.h"
 #include "acinterp.h"
-#include <acpi/amlcode.h>
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("psxface")
-- 
1.5.6.6

