Return-Path: <linux-kernel-owner+w=401wt.eu-S1763789AbZFKXFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763789AbZFKXFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFKXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:05:29 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:59222 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZFKXF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:05:28 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH] trivial: remove references to non-existent include/linux/config.h
Date: Fri, 12 Jun 2009 01:02:35 +0200
Message-Id: <1244761355-1099-2-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.2.236.ge505d
X-Provags-ID: V01U2FsdGVkX18+3HpbQGBt0wBjJLD1GhPOVOpTnQ9KtGo6bEiG
	CdtXwSRNolHOgB47RbH5pYzf+gIxnVI7WM08ZRv5gSVQ9rH7wD
	jXTLwGzGZrUPX8EKN+ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore drivers/staging/ since it is very likely that new drivers
introduce it again.

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 arch/h8300/kernel/timer/tpu.c |    1 -
 scripts/basic/fixdep.c        |    3 +--
 scripts/mod/sumversion.c      |    2 --
 3 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
index e7c6e61..2193a2e 100644
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -7,7 +7,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 8912c0f..1f5e628 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -16,8 +16,7 @@
  * tells make when to remake a file.
  *
  * To use this list as-is however has the drawback that virtually
- * every file in the kernel includes <linux/config.h> which then again
- * includes <linux/autoconf.h>
+ * every file in the kernel includes <linux/autoconf.h>.
  *
  * If the user re-runs make *config, linux/autoconf.h will be
  * regenerated.  make notices that and will rebuild every file which
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index aadc522..ecf9c7d 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -334,8 +334,6 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
 		deps_drivers/net/dummy.o := \
 		  drivers/net/dummy.c \
 		    $(wildcard include/config/net/fastroute.h) \
-		  include/linux/config.h \
-		    $(wildcard include/config/h.h) \
 		  include/linux/module.h \
 
 	   Sum all files in the same dir or subdirs.
-- 
1.6.3.2.236.ge505d

