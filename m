Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYLaKwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYLaKwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYLaKwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:12 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:40391 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYLaKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:09 -0500
Date: Wed, 31 Dec 2008 05:51:54 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 04/15] ACPICA: acdebug.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <0d18adf35af870e5a6bf64cb2fecb5277ac32330.1230719803.git.len.brown@intel.com>
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
 {include/acpi => kernel/acpi/acpica}/acdebug.h |    0 
 kernel/acpi/acpica/dsutils.c                   |    2 +-
 kernel/acpi/acpica/dswexec.c                   |    2 +-
 kernel/acpi/acpica/utalloc.c                   |    2 +-
 kernel/acpi/acpica/utxface.c                   |    2 +-
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acdebug.h (100%)

diff --git a/include/acpi/acdebug.h b/kernel/acpi/acpica/acdebug.h
similarity index 100%
rename from include/acpi/acdebug.h
rename to kernel/acpi/acpica/acdebug.h
diff --git a/kernel/acpi/acpica/dsutils.c b/kernel/acpi/acpica/dsutils.c
index 876f7ae..7f7f59e 100644
--- a/kernel/acpi/acpica/dsutils.c
+++ b/kernel/acpi/acpica/dsutils.c
@@ -48,7 +48,7 @@
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acdebug.h>
+#include "acdebug.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dsutils")
diff --git a/kernel/acpi/acpica/dswexec.c b/kernel/acpi/acpica/dswexec.c
index b3bd502..696f54b 100644
--- a/kernel/acpi/acpica/dswexec.c
+++ b/kernel/acpi/acpica/dswexec.c
@@ -49,7 +49,7 @@
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acdebug.h>
+#include "acdebug.h"
 
 #define _COMPONENT          ACPI_DISPATCHER
 ACPI_MODULE_NAME("dswexec")
diff --git a/kernel/acpi/acpica/utalloc.c b/kernel/acpi/acpica/utalloc.c
index b4736db..7580f6b 100644
--- a/kernel/acpi/acpica/utalloc.c
+++ b/kernel/acpi/acpica/utalloc.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <acpi/acdebug.h>
+#include "acdebug.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utalloc")
diff --git a/kernel/acpi/acpica/utxface.c b/kernel/acpi/acpica/utxface.c
index 1c776d3..8e2dfab 100644
--- a/kernel/acpi/acpica/utxface.c
+++ b/kernel/acpi/acpica/utxface.c
@@ -45,7 +45,7 @@
 #include "accommon.h"
 #include <acpi/acevents.h>
 #include <acpi/acnamesp.h>
-#include <acpi/acdebug.h>
+#include "acdebug.h"
 #include <acpi/actables.h>
 
 #define _COMPONENT          ACPI_UTILITIES
-- 
1.5.6.6

