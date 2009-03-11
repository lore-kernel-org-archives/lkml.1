Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZCKWC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZCKWC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZCKV6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:32 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:41120 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754448AbZCKV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:30 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: h0pvubkVM1mpDJATf1hoNymV9Bez9Mid.xwc2dfcOo4XzxyQ.nTlDFdF6RL8bZ89dmpXPuh0CKfsUPCFjyRhWIXGm5awQyJJThN8RKIpAIEfktW9s.FRoeLIpsQY798yL3SPHnDr9_ajQ8FZx.f0gOBiE4poY3w00Cm0.Zj_UhlmxXJqbxTTy2Q..7sP9x0K85XyuiY8YeGcUFePQTffBAUZTusimMTqSi5qbJIe6WsVVKU-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 14/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:56:17 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111456.17972.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooks for implementing pinmux...

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/pinmux.h b/arch/m68k/include/asm/pinmux.h
new file mode 100644
index 0000000..80e86aa
--- /dev/null
+++ b/arch/m68k/include/asm/pinmux.h
@@ -0,0 +1,30 @@
+/*
+ * Coldfire generic GPIO pinmux support.
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef pinmux_h
+#define pinmux_h
+
+#define MCFPINMUX_NONE		-1
+
+extern int mcf_pinmux_request(unsigned, unsigned);
+extern void mcf_pinmux_release(unsigned, unsigned);
+
+static inline int mcf_pinmux_is_valid(unsigned pinmux)
+{
+	return pinmux != MCFPINMUX_NONE;
+}
+
+#endif 
+
diff --git a/arch/m68knommu/platform/coldfire/pinmux.c 
b/arch/m68knommu/platform/coldfire/pinmux.c
new file mode 100644
index 0000000..8c62b82
--- /dev/null
+++ b/arch/m68knommu/platform/coldfire/pinmux.c
@@ -0,0 +1,28 @@
+/*
+ * Coldfire generic GPIO pinmux support.
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; version 2 of the License.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+
+#include <asm/pinmux.h>
+
+int mcf_pinmux_request(unsigned pinmux, unsigned func)
+{
+	return 0;
+}
+
+void mcf_pinmux_release(unsigned pinmux, unsigned func)
+{
+}
