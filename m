Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbYDRSSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbYDRSSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbYDRSRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:17:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbYDRSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:17:39 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] dlm: common max length definitions
Date: Fri, 18 Apr 2008 13:12:48 -0500
Message-Id: <1208542368-13417-7-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add central definitions for max lockspace name length and max resource
name length.  The lack of central definitions has resulted in scattered
private definitions which we can now clean up, including an unused one
in dlm_device.h.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h        |    2 --
 include/linux/dlm.h          |    4 ----
 include/linux/dlm_device.h   |    3 ---
 include/linux/dlmconstants.h |    4 ++++
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index caa1581..73c36f5 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -43,8 +43,6 @@
 #include <linux/dlm.h>
 #include "config.h"
 
-#define DLM_LOCKSPACE_LEN	64
-
 /* Size of the temp buffer midcomms allocates on the stack.
    We try to make this large enough so most messages fit.
    FIXME: should sctp make this unnecessary? */
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index c743fbc..188f6e6 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -22,10 +22,6 @@
 /* Lock levels and flags are here */
 #include <linux/dlmconstants.h>
 
-
-#define DLM_RESNAME_MAXLEN	64
-
-
 typedef void dlm_lockspace_t;
 
 /*
diff --git a/include/linux/dlm_device.h b/include/linux/dlm_device.h
index 9642277..dcfd249 100644
--- a/include/linux/dlm_device.h
+++ b/include/linux/dlm_device.h
@@ -94,9 +94,6 @@ struct dlm_lock_result {
 #define DLM_USER_PURGE        6
 #define DLM_USER_DEADLOCK     7
 
-/* Arbitrary length restriction */
-#define MAX_LS_NAME_LEN 64
-
 /* Lockspace flags */
 #define DLM_USER_LSFLG_AUTOFREE   1
 #define DLM_USER_LSFLG_FORCEFREE  2
diff --git a/include/linux/dlmconstants.h b/include/linux/dlmconstants.h
index fddb3d3..47bf08d 100644
--- a/include/linux/dlmconstants.h
+++ b/include/linux/dlmconstants.h
@@ -18,6 +18,10 @@
  * Constants used by DLM interface.
  */
 
+#define DLM_LOCKSPACE_LEN       64
+#define DLM_RESNAME_MAXLEN      64
+
+
 /*
  * Lock Modes
  */
-- 
1.5.3.3

