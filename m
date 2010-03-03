Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0CCFIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:08:11 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54198 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab0CCFIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:08:07 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 01/11] ST SPEAr: Added ARM PrimeXsys System Controller SP810 header file
Date: Wed,  3 Mar 2010 10:37:31 +0530
Message-Id: <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 include/linux/sysctl_sp810.h |   59 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/sysctl_sp810.h

diff --git a/include/linux/sysctl_sp810.h b/include/linux/sysctl_sp810.h
new file mode 100644
index 0000000..9b841b9
--- /dev/null
+++ b/include/linux/sysctl_sp810.h
@@ -0,0 +1,59 @@
+/*
+ * linux/sysctl_sp810.h
+ *
+ * ARM PrimeXsys System Controller SP810 header file
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef SYSCTL_SP810_H
+#define SYSCTL_SP810_H
+
+#include <linux/io.h>
+
+/* sysctl registers offset */
+#define SCCTRL			0x000
+#define SCSYSSTAT		0x004
+#define SCIMCTRL		0x008
+#define SCIMSTAT		0x00C
+#define SCXTALCTRL		0x010
+#define SCPLLCTRL		0x014
+#define SCPLLFCTRL		0x018
+#define SCPERCTRL0		0x01C
+#define SCPERCTRL1		0x020
+#define SCPEREN			0x024
+#define SCPERDIS		0x028
+#define SCPERCLKEN		0x02C
+#define SCPERSTAT		0x030
+#define SCSYSID0		0xEE0
+#define SCSYSID1		0xEE4
+#define SCSYSID2		0xEE8
+#define SCSYSID3		0xEEC
+#define SCITCR			0xF00
+#define SCITIR0			0xF04
+#define SCITIR1			0xF08
+#define SCITOR			0xF0C
+#define SCCNTCTRL		0xF10
+#define SCCNTDATA		0xF14
+#define SCCNTSTEP		0xF18
+#define SCPERIPHID0		0xFE0
+#define SCPERIPHID1		0xFE4
+#define SCPERIPHID2		0xFE8
+#define SCPERIPHID3		0xFEC
+#define SCPCELLID0		0xFF0
+#define SCPCELLID1		0xFF4
+#define SCPCELLID2		0xFF8
+#define SCPCELLID3		0xFFC
+
+static inline void sysctl_soft_reset(void __iomem *base)
+{
+	/* writing any value to SCSYSSTAT reg will reset system */
+	writel(0, base + SCSYSSTAT);
+}
+
+#endif	/* SYSCTL_SP810_H */
-- 
1.6.0.2

