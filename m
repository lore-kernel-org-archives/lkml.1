Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYEDNib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYEDNib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYEDNiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:38:20 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:58946 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752635AbYEDNiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:38:19 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 12/56] microblaze_v2: lmb support
Date: Sun,  4 May 2008 13:41:01 +0200
Message-Id: <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/lmb.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/lmb.h

diff --git a/include/asm-microblaze/lmb.h b/include/asm-microblaze/lmb.h
new file mode 100644
index 0000000..40d5f65
--- /dev/null
+++ b/include/asm-microblaze/lmb.h
@@ -0,0 +1,21 @@
+/*
+ * include/asm-microblaze/lmb.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ */
+
+#ifndef _ASM_MICROBLAZE_LMB_H
+#define _ASM_MICROBLAZE_LMB_H
+
+/*#define LMB_DBG(fmt...) pr_debug(fmt) */
+
+/* LMB limit is OFF */
+#define LMB_REAL_LIMIT	0xFFFFFFFF
+
+#endif /* _ASM_MICROBLAZE_LMB_H */
+
+
-- 
1.5.4.GIT

