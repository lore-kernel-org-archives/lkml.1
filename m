Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYBVFJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYBVFJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYBVFHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:07:54 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35776 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbYBVFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:07:50 -0500
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, yamahata@valinux.co.jp
Subject: [PATCH 02/11] xen: add missing VIRQ_ARCH_[0-7] definitions which ia64/xen needs.
Date: Fri, 22 Feb 2008 14:07:39 +0900
Message-Id: <12036568683220-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12036568683779-git-send-email-yamahata@valinux.co.jp>
References: <12036568683779-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 include/xen/interface/xen.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 87ad143..9b018da 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -78,8 +78,18 @@
 #define VIRQ_CONSOLE    2  /* (DOM0) Bytes received on emergency console. */
 #define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   */
 #define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   */
-#define NR_VIRQS        8
 
+/* Architecture-specific VIRQ definitions. */
+#define VIRQ_ARCH_0    16
+#define VIRQ_ARCH_1    17
+#define VIRQ_ARCH_2    18
+#define VIRQ_ARCH_3    19
+#define VIRQ_ARCH_4    20
+#define VIRQ_ARCH_5    21
+#define VIRQ_ARCH_6    22
+#define VIRQ_ARCH_7    23
+
+#define NR_VIRQS       24
 /*
  * MMU-UPDATE REQUESTS
  *
-- 
1.5.3

