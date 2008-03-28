Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYC1Lk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYC1Lk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYC1LkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:40:21 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44522 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753349AbYC1LkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:40:19 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com,
       yamahata@valinux.co.jp
Subject: [PATCH 02/12] xen: add missing VIRQ_ARCH_[0-7] definitions which ia64/xen needs.
Date: Fri, 28 Mar 2008 20:40:08 +0900
Message-Id: <12067044181738-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12067044183207-git-send-email-yamahata@valinux.co.jp>
References: <12067044183207-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add xen VIRQ numbers defined for arch specific use.
ia64/xen domU uses VIRQ_ARCH_0 for virtual itc timer.
Although all those constants aren't used yet by ia64
at this moment, add all arch specific VIRQ numbers.

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

