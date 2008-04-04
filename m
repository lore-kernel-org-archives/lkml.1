Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYDDMsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYDDMsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbYDDMra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:47:30 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49445 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782AbYDDMrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:47:25 -0400
Message-Id: <20080404122358.001192846@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:22:45 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 03/30] Constants for /proc/ccs/ interface.
Content-Disposition: inline; filename=tomoyo-proc-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file defines constants for /proc/ccs/ interface.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 include/linux/ccs_proc.h |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/include/linux/ccs_proc.h
@@ -0,0 +1,31 @@
+/*
+ * include/linux/ccs_proc.h
+ *
+ * /proc/ccs/ interface for SAKURA and TOMOYO.
+ *
+ * Copyright (C) 2005-2008  NTT DATA CORPORATION
+ *
+ * Version: 1.6.0   2008/04/01
+ *
+ */
+
+#ifndef _LINUX_CCS_PROC_H
+#define _LINUX_CCS_PROC_H
+
+/* Indexes for /proc/ccs/ interfaces. */
+#define CCS_DOMAINPOLICY          0
+#define CCS_EXCEPTIONPOLICY       1
+#define CCS_SYSTEMPOLICY          2
+#define CCS_DOMAIN_STATUS         3
+#define CCS_PROCESS_STATUS        4
+#define CCS_MEMINFO               5
+#define CCS_GRANTLOG              6
+#define CCS_REJECTLOG             7
+#define CCS_SELFDOMAIN            8
+#define CCS_VERSION               9
+#define CCS_PROFILE              10
+#define CCS_QUERY                11
+#define CCS_MANAGER              12
+#define CCS_UPDATESCOUNTER       13
+
+#endif

-- 
