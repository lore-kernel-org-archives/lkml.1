Return-Path: <linux-kernel-owner+w=401wt.eu-S1763737AbYFZNCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763737AbYFZNCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbYFZMnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:43:03 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23243 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759969AbYFZMm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:42:59 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 50/60] microblaze_v4: device.h param.h topology.h
Date: Thu, 26 Jun 2008 14:30:19 +0200
Message-Id: <1214483429-32360-51-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-50-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
 <1214483429-32360-39-git-send-email-monstr@seznam.cz>
 <1214483429-32360-40-git-send-email-monstr@seznam.cz>
 <1214483429-32360-41-git-send-email-monstr@seznam.cz>
 <1214483429-32360-42-git-send-email-monstr@seznam.cz>
 <1214483429-32360-43-git-send-email-monstr@seznam.cz>
 <1214483429-32360-44-git-send-email-monstr@seznam.cz>
 <1214483429-32360-45-git-send-email-monstr@seznam.cz>
 <1214483429-32360-46-git-send-email-monstr@seznam.cz>
 <1214483429-32360-47-git-send-email-monstr@seznam.cz>
 <1214483429-32360-48-git-send-email-monstr@seznam.cz>
 <1214483429-32360-49-git-send-email-monstr@seznam.cz>
 <1214483429-32360-50-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-generic/param.h       |   32 ++++++++++++++++++++++++++++++++
 include/asm-microblaze/device.h   |   21 +++++++++++++++++++++
 include/asm-microblaze/param.h    |    1 +
 include/asm-microblaze/topology.h |    1 +
 4 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/param.h
 create mode 100644 include/asm-microblaze/device.h
 create mode 100644 include/asm-microblaze/param.h
 create mode 100644 include/asm-microblaze/topology.h

diff --git a/include/asm-generic/param.h b/include/asm-generic/param.h
new file mode 100644
index 0000000..b2ed486
--- /dev/null
+++ b/include/asm-generic/param.h
@@ -0,0 +1,32 @@
+/*
+ * include/asm-generic/param.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_GENERIC_PARAM_H
+#define _ASM_GENERIC_PARAM_H
+
+#ifdef __KERNEL__
+#define HZ		CONFIG_HZ	/* internal kernel timer frequency */
+#define USER_HZ		100		/* for user interfaces in "ticks" */
+#define CLOCKS_PER_SEC	(USER_HZ)	/* frequency at which times() counts */
+#endif /* __KERNEL__ */
+
+#ifndef HZ
+#define HZ 100
+#endif
+
+#define EXEC_PAGESIZE	4096
+
+#ifndef NOGROUP
+#define NOGROUP		(-1)
+#endif
+
+#define MAXHOSTNAMELEN	64	/* max length of hostname */
+
+#endif /* _ASM_GENERIC_PARAM_H */
diff --git a/include/asm-microblaze/device.h b/include/asm-microblaze/device.h
new file mode 100644
index 0000000..c042830
--- /dev/null
+++ b/include/asm-microblaze/device.h
@@ -0,0 +1,21 @@
+/*
+ * Arch specific extensions to struct device
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License v2. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_DEVICE_H
+#define _ASM_MICROBLAZE_DEVICE_H
+
+struct device_node;
+
+struct dev_archdata {
+	/* Optional pointer to an OF device node */
+	struct device_node	*of_node;
+};
+
+#endif /* _ASM_MICROBLAZE_DEVICE_H */
+
+
diff --git a/include/asm-microblaze/param.h b/include/asm-microblaze/param.h
new file mode 100644
index 0000000..965d454
--- /dev/null
+++ b/include/asm-microblaze/param.h
@@ -0,0 +1 @@
+#include <asm-generic/param.h>
diff --git a/include/asm-microblaze/topology.h b/include/asm-microblaze/topology.h
new file mode 100644
index 0000000..5428f33
--- /dev/null
+++ b/include/asm-microblaze/topology.h
@@ -0,0 +1 @@
+#include <asm-generic/topology.h>
-- 
1.5.4.GIT

