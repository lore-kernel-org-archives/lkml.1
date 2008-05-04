Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYEEITx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYEEITx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYEEITo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:19:44 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:48963 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbYEEITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:19:42 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 45/56] microblaze_v2: headers simple files - empty or redirect to asm-generic
Date: Sun,  4 May 2008 13:41:34 +0200
Message-Id: <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
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
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/auxvec.h            |   14 ++++++++++++++
 include/asm-microblaze/cputime.h           |   16 ++++++++++++++++
 include/asm-microblaze/div64.h             |   16 ++++++++++++++++
 include/asm-microblaze/emergency-restart.h |   16 ++++++++++++++++
 include/asm-microblaze/errno.h             |   16 ++++++++++++++++
 include/asm-microblaze/futex.h             |   16 ++++++++++++++++
 include/asm-microblaze/kdebug.h            |   19 +++++++++++++++++++
 include/asm-microblaze/local.h             |   16 ++++++++++++++++
 include/asm-microblaze/mutex.h             |   16 ++++++++++++++++
 include/asm-microblaze/namei.h             |   24 ++++++++++++++++++++++++
 include/asm-microblaze/percpu.h            |   16 ++++++++++++++++
 include/asm-microblaze/resource.h          |   16 ++++++++++++++++
 include/asm-microblaze/user.h              |   18 ++++++++++++++++++
 13 files changed, 219 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/auxvec.h
 create mode 100644 include/asm-microblaze/cputime.h
 create mode 100644 include/asm-microblaze/div64.h
 create mode 100644 include/asm-microblaze/emergency-restart.h
 create mode 100644 include/asm-microblaze/errno.h
 create mode 100644 include/asm-microblaze/futex.h
 create mode 100644 include/asm-microblaze/kdebug.h
 create mode 100644 include/asm-microblaze/local.h
 create mode 100644 include/asm-microblaze/mutex.h
 create mode 100644 include/asm-microblaze/namei.h
 create mode 100644 include/asm-microblaze/percpu.h
 create mode 100644 include/asm-microblaze/resource.h
 create mode 100644 include/asm-microblaze/user.h

diff --git a/include/asm-microblaze/auxvec.h b/include/asm-microblaze/auxvec.h
new file mode 100644
index 0000000..73c0fb0
--- /dev/null
+++ b/include/asm-microblaze/auxvec.h
@@ -0,0 +1,14 @@
+/*
+ * include/asm-microblaze/auxvec.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_AUXVEC_H
+#define _ASM_MICROBLAZE_AUXVEC_H
+
+#endif /* _ASM_MICROBLAZE_AUXVEC_H */
diff --git a/include/asm-microblaze/cputime.h b/include/asm-microblaze/cputime.h
new file mode 100644
index 0000000..e0e4d65
--- /dev/null
+++ b/include/asm-microblaze/cputime.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/cputime.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_CPUTIME_H
+#define _ASM_MICROBLAZE_CPUTIME_H
+
+#include <asm-generic/cputime.h>
+
+#endif /* _ASM_MICROBLAZE_CPUTIME_H */
diff --git a/include/asm-microblaze/div64.h b/include/asm-microblaze/div64.h
new file mode 100644
index 0000000..5c8a45c
--- /dev/null
+++ b/include/asm-microblaze/div64.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/div64.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_DIV64_H
+#define _ASM_MICROBLAZE_DIV64_H
+
+#include <asm-generic/div64.h>
+
+#endif /* _ASM_MICROBLAZE_DIV64_H */
diff --git a/include/asm-microblaze/emergency-restart.h b/include/asm-microblaze/emergency-restart.h
new file mode 100644
index 0000000..831eee4
--- /dev/null
+++ b/include/asm-microblaze/emergency-restart.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/emergency-restart.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_EMERGENCY_RESTART_H
+#define _ASM_MICROBLAZE_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* _ASM_MICROBLAZE_EMERGENCY_RESTART_H */
diff --git a/include/asm-microblaze/errno.h b/include/asm-microblaze/errno.h
new file mode 100644
index 0000000..cc88e20
--- /dev/null
+++ b/include/asm-microblaze/errno.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/errno.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_ERRNO_H
+#define _ASM_MICROBLAZE_ERRNO_H
+
+#include <asm-generic/errno.h>
+
+#endif /* _ASM_MICROBLAZE_ERRNO_H */
diff --git a/include/asm-microblaze/futex.h b/include/asm-microblaze/futex.h
new file mode 100644
index 0000000..8aa1f4d
--- /dev/null
+++ b/include/asm-microblaze/futex.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/futex.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_FUTEX_H
+#define _ASM_MICROBLAZE_FUTEX_H
+
+#include <asm-generic/futex.h>
+
+#endif /* _ASM_MICROBLAZE_FUTEX_H */
diff --git a/include/asm-microblaze/kdebug.h b/include/asm-microblaze/kdebug.h
new file mode 100644
index 0000000..ac0cf63
--- /dev/null
+++ b/include/asm-microblaze/kdebug.h
@@ -0,0 +1,19 @@
+/*
+ * include/asm-microblaze/kdebug.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ */
+
+#ifndef _ASM_MICROBLAZE_KDEBUG_H
+#define _ASM_MICROBLAZE_KDEBUG_H
+
+#include <asm-generic/kdebug.h>
+
+#endif /* _ASM_MICROBLAZE_KDEBUG_H */
+
+
+
diff --git a/include/asm-microblaze/local.h b/include/asm-microblaze/local.h
new file mode 100644
index 0000000..9909302
--- /dev/null
+++ b/include/asm-microblaze/local.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/local.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_LOCAL_H
+#define _ASM_MICROBLAZE_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* _ASM_MICROBLAZE_LOCAL_H */
diff --git a/include/asm-microblaze/mutex.h b/include/asm-microblaze/mutex.h
new file mode 100644
index 0000000..21d8731
--- /dev/null
+++ b/include/asm-microblaze/mutex.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/mutex.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_MUTEX_H
+#define _ASM_MICROBLAZE_MUTEX_H
+
+#include <asm-generic/mutex-dec.h>
+
+#endif /* _ASM_MICROBLAZE_MUTEX_H */
diff --git a/include/asm-microblaze/namei.h b/include/asm-microblaze/namei.h
new file mode 100644
index 0000000..25cafbd
--- /dev/null
+++ b/include/asm-microblaze/namei.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/namei.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_NAMEI_H
+#define _ASM_MICROBLAZE_NAMEI_H
+
+#ifdef __KERNEL__
+
+/* This dummy routine maybe changed to something useful
+ * for /usr/gnemul/ emulation stuff.
+ * Look at asm-sparc/namei.h for details.
+ */
+#define __emul_prefix() NULL
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_MICROBLAZE_NAMEI_H */
diff --git a/include/asm-microblaze/percpu.h b/include/asm-microblaze/percpu.h
new file mode 100644
index 0000000..5c9c24c
--- /dev/null
+++ b/include/asm-microblaze/percpu.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/percpu.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_PERCPU_H
+#define _ASM_MICROBLAZE_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* _ASM_MICROBLAZE_PERCPU_H */
diff --git a/include/asm-microblaze/resource.h b/include/asm-microblaze/resource.h
new file mode 100644
index 0000000..f8aac61
--- /dev/null
+++ b/include/asm-microblaze/resource.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/resource.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_RESOURCE_H
+#define _ASM_MICROBLAZE_RESOURCE_H
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_MICROBLAZE_RESOURCE_H */
diff --git a/include/asm-microblaze/user.h b/include/asm-microblaze/user.h
new file mode 100644
index 0000000..db2e303
--- /dev/null
+++ b/include/asm-microblaze/user.h
@@ -0,0 +1,18 @@
+/*
+ * include/asm-microblaze/user.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * Authors:
+ * Yasushi SHOJI <yashi@atmark-techno.com>
+ * Tetsuya OHKAWA <tetsuya@atmark-techno.com>
+ */
+
+#ifndef _ASM_MICROBLAZE_USER_H
+#define _ASM_MICROBLAZE_USER_H
+
+#endif /* _ASM_MICROBLAZE_USER_H */
-- 
1.5.4.GIT

