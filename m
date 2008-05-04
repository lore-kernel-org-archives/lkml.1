Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYEEMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYEEMsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbYEEMrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:47:52 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56206 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758631AbYEEMrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:47:51 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 05/56] microblaze_v2: Support for semaphores
Date: Sun,  4 May 2008 13:40:54 +0200
Message-Id: <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/semaphore.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/semaphore.h

diff --git a/include/asm-microblaze/semaphore.h b/include/asm-microblaze/semaphore.h
new file mode 100644
index 0000000..cdb1e05
--- /dev/null
+++ b/include/asm-microblaze/semaphore.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/semaphore.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ */
+
+#ifndef _ASM_MICROBLAZE_SEMAPHORE_H
+#define _ASM_MICROBLAZE_SEMAPHORE_H
+
+#include <linux/semaphore.h>
+
+#endif /* _ASM_MICROBLAZE_SEMAPHORE_H */
-- 
1.5.4.GIT

