Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYLaK5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYLaK5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYLaKwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:45 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:46751 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbYLaKw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:27 -0500
Date: Wed, 31 Dec 2008 05:52:01 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 11/15] ACPICA: acparser.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <5b4a25099b7bd7546f53c8039f84c3aed8b75196.1230719805.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/acparser.h |    0 
 kernel/acpi/acpica/dsfield.c                    |    2 +-
 kernel/acpi/acpica/dsobject.c                   |    2 +-
 kernel/acpi/acpica/dsopcode.c                   |    2 +-
 kernel/acpi/acpica/dsutils.c                    |    2 +-
 kernel/acpi/acpica/dswexec.c                    |    2 +-
 kernel/acpi/acpica/dswload.c                    |    2 +-
 kernel/acpi/acpica/dswstate.c                   |    2 +-
 kernel/acpi/acpica/exoparg1.c                   |    2 +-
 kernel/acpi/acpica/exoparg2.c                   |    2 +-
 kernel/acpi/acpica/exoparg3.c                   |    2 +-
 kernel/acpi/acpica/exoparg6.c                   |    2 +-
 kernel/acpi/acpica/exresop.c                    |    2 +-
 kernel/acpi/acpica/nseval.c                     |    2 +-
 kernel/acpi/acpica/nsparse.c                    |    2 +-
 kernel/acpi/acpica/psargs.c                     |    2 +-
 kernel/acpi/acpica/psloop.c                     |    2 +-
 kernel/acpi/acpica/psopcode.c                   |    2 +-
 kernel/acpi/acpica/psparse.c                    |    2 +-
 kernel/acpi/acpica/psscope.c                    |    2 +-
 kernel/acpi/acpica/pstree.c                     |    2 +-
 kernel/acpi/acpica/psutils.c                    |    2 +-
 kernel/acpi/acpica/pswalk.c                     |    2 +-
 kernel/acpi/acpica/psxface.c                    |    2 +-
 24 files changed, 23 insertions(+), 23 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acparser.h (100%)

diff --git a/include/acpi/acparser.h b/kernel/acpi/acpica/acparser.h
similarity index 100%
rename from include/acpi/acparser.h
rename to kernel/acpi/acpica/acparser.h
diff --git a/kernel/acpi/acpica/dsfield.c b/kernel/acpi/acpica/dsfield.c
index 73a85c8..65e27b5 100644
--- a/kernel/acpi/acpica/dsfield.c
+++ b/kernel/acpi/acpica/dsfield.c
@@ -47,7 +47,7 @@
 #include "acdispat.h"
 #include "acinterp.h"
 #include "acnamesp.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dsfield")
diff --git a/kernel/acpi/acpica/dsobject.c b/kernel/acpi/acpica/dsobject.c
index 8ed96dc..ae0140f 100644
--- a/kernel/acpi/acpica/dsobject.c
+++ b/kernel/acpi/acpica/dsobject.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
index e2732fe..4c99739 100644
--- a/kernel/acpi/acpica/dsopcode.c
+++ b/kernel/acpi/acpica/dsopcode.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
diff --git a/kernel/acpi/acpica/dsutils.c b/kernel/acpi/acpica/dsutils.c
index bb302ca..ebc3a79 100644
--- a/kernel/acpi/acpica/dsutils.c
+++ b/kernel/acpi/acpica/dsutils.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
diff --git a/kernel/acpi/acpica/dswexec.c b/kernel/acpi/acpica/dswexec.c
index dc7d87c..a2d1932 100644
--- a/kernel/acpi/acpica/dswexec.c
+++ b/kernel/acpi/acpica/dswexec.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
diff --git a/kernel/acpi/acpica/dswload.c b/kernel/acpi/acpica/dswload.c
index 35b56e7..259d289 100644
--- a/kernel/acpi/acpica/dswload.c
+++ b/kernel/acpi/acpica/dswload.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 #include "acdispat.h"
 #include "acinterp.h"
diff --git a/kernel/acpi/acpica/dswstate.c b/kernel/acpi/acpica/dswstate.c
index f04912f..40f92bf 100644
--- a/kernel/acpi/acpica/dswstate.c
+++ b/kernel/acpi/acpica/dswstate.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acdispat.h"
 #include "acnamesp.h"
 
diff --git a/kernel/acpi/acpica/exoparg1.c b/kernel/acpi/acpica/exoparg1.c
index 7a2d7e2..3bd08bb 100644
--- a/kernel/acpi/acpica/exoparg1.c
+++ b/kernel/acpi/acpica/exoparg1.c
@@ -44,7 +44,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/exoparg2.c b/kernel/acpi/acpica/exoparg2.c
index 4eda2e1..8f321f7 100644
--- a/kernel/acpi/acpica/exoparg2.c
+++ b/kernel/acpi/acpica/exoparg2.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acinterp.h"
 #include "acevents.h"
 #include <acpi/amlcode.h>
diff --git a/kernel/acpi/acpica/exoparg3.c b/kernel/acpi/acpica/exoparg3.c
index 6405c24..dbe7612 100644
--- a/kernel/acpi/acpica/exoparg3.c
+++ b/kernel/acpi/acpica/exoparg3.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exoparg6.c b/kernel/acpi/acpica/exoparg6.c
index 74eb341..17dfb08 100644
--- a/kernel/acpi/acpica/exoparg6.c
+++ b/kernel/acpi/acpica/exoparg6.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_EXECUTER
diff --git a/kernel/acpi/acpica/exresop.c b/kernel/acpi/acpica/exresop.c
index 68b9577..912148c 100644
--- a/kernel/acpi/acpica/exresop.c
+++ b/kernel/acpi/acpica/exresop.c
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/amlcode.h>
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acinterp.h"
 #include "acnamesp.h"
 
diff --git a/kernel/acpi/acpica/nseval.c b/kernel/acpi/acpica/nseval.c
index 07560e7..0f3d5f9 100644
--- a/kernel/acpi/acpica/nseval.c
+++ b/kernel/acpi/acpica/nseval.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acinterp.h"
 #include "acnamesp.h"
 
diff --git a/kernel/acpi/acpica/nsparse.c b/kernel/acpi/acpica/nsparse.c
index eae2c46..b7dd8cd 100644
--- a/kernel/acpi/acpica/nsparse.c
+++ b/kernel/acpi/acpica/nsparse.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acnamesp.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acdispat.h"
 #include <acpi/actables.h>
 
diff --git a/kernel/acpi/acpica/psargs.c b/kernel/acpi/acpica/psargs.c
index 0765087..a851c73 100644
--- a/kernel/acpi/acpica/psargs.c
+++ b/kernel/acpi/acpica/psargs.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 #include "acnamesp.h"
 #include "acdispat.h"
diff --git a/kernel/acpi/acpica/psloop.c b/kernel/acpi/acpica/psloop.c
index d4f0f65..e993e43 100644
--- a/kernel/acpi/acpica/psloop.c
+++ b/kernel/acpi/acpica/psloop.c
@@ -51,7 +51,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acdispat.h"
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/psopcode.c b/kernel/acpi/acpica/psopcode.c
index ccb9652..9aede84 100644
--- a/kernel/acpi/acpica/psopcode.c
+++ b/kernel/acpi/acpica/psopcode.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acopcode.h"
 #include <acpi/amlcode.h>
 
diff --git a/kernel/acpi/acpica/psparse.c b/kernel/acpi/acpica/psparse.c
index c065b31..8d45a31 100644
--- a/kernel/acpi/acpica/psparse.c
+++ b/kernel/acpi/acpica/psparse.c
@@ -52,7 +52,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acdispat.h"
 #include <acpi/amlcode.h>
 #include "acnamesp.h"
diff --git a/kernel/acpi/acpica/psscope.c b/kernel/acpi/acpica/psscope.c
index dc26c4a..2feca5c 100644
--- a/kernel/acpi/acpica/psscope.c
+++ b/kernel/acpi/acpica/psscope.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("psscope")
diff --git a/kernel/acpi/acpica/pstree.c b/kernel/acpi/acpica/pstree.c
index d355ba1..f317046 100644
--- a/kernel/acpi/acpica/pstree.c
+++ b/kernel/acpi/acpica/pstree.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/psutils.c b/kernel/acpi/acpica/psutils.c
index d71e180..5336631 100644
--- a/kernel/acpi/acpica/psutils.c
+++ b/kernel/acpi/acpica/psutils.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_PARSER
diff --git a/kernel/acpi/acpica/pswalk.c b/kernel/acpi/acpica/pswalk.c
index a0cf80c..78b8b79 100644
--- a/kernel/acpi/acpica/pswalk.c
+++ b/kernel/acpi/acpica/pswalk.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 
 #define _COMPONENT          ACPI_PARSER
 ACPI_MODULE_NAME("pswalk")
diff --git a/kernel/acpi/acpica/psxface.c b/kernel/acpi/acpica/psxface.c
index ae30135..e905037 100644
--- a/kernel/acpi/acpica/psxface.c
+++ b/kernel/acpi/acpica/psxface.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acparser.h>
+#include "acparser.h"
 #include "acdispat.h"
 #include "acinterp.h"
 #include <acpi/amlcode.h>
-- 
1.5.6.6

