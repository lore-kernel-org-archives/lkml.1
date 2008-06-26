Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbYFZM5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbYFZM5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbYFZMlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:41:16 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:22462 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756722AbYFZMlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:41:12 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 45/60] microblaze_v4: stats headers
Date: Thu, 26 Jun 2008 14:30:14 +0200
Message-Id: <1214483429-32360-46-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-45-git-send-email-monstr@seznam.cz>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/stat.h   |   73 +++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/statfs.h |    1 +
 2 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/stat.h
 create mode 100644 include/asm-microblaze/statfs.h

diff --git a/include/asm-microblaze/stat.h b/include/asm-microblaze/stat.h
new file mode 100644
index 0000000..9767b11
--- /dev/null
+++ b/include/asm-microblaze/stat.h
@@ -0,0 +1,73 @@
+/*
+ * Microblaze stat structure
+ *
+ * Copyright (C) 2001,02,03 NEC Electronics Corporation
+ * Copyright (C) 2001,02,03 Miles Bader <miles@gnu.org>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ * Written by Miles Bader <miles@gnu.org>
+ */
+
+#ifndef _ASM_MICROBLAZE_STAT_H
+#define _ASM_MICROBLAZE_STAT_H
+
+#include <asm/posix_types.h>
+
+struct stat {
+	unsigned int	st_dev;
+	unsigned long	st_ino;
+	unsigned int	st_mode;
+	unsigned int	st_nlink;
+	unsigned int	st_uid;
+	unsigned int	st_gid;
+	unsigned int	st_rdev;
+	long		st_size;
+	unsigned long	st_blksize;
+	unsigned long	st_blocks;
+	unsigned long	st_atime;
+	unsigned long	__unused1;
+	unsigned long	st_mtime;
+	unsigned long	__unused2;
+	unsigned long	st_ctime;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+	unsigned long	__unused5;
+};
+
+struct stat64 {
+	unsigned long long	st_dev;
+	unsigned long	__unused1;
+
+	unsigned long long	st_ino;
+
+	unsigned int	st_mode;
+	unsigned int	st_nlink;
+
+	unsigned int	st_uid;
+	unsigned int	st_gid;
+
+	unsigned long long	st_rdev;
+	unsigned long	__unused3;
+
+	long long	st_size;
+	unsigned long	st_blksize;
+
+	unsigned long	st_blocks; /* No. of 512-byte blocks allocated */
+	unsigned long	__unused4; /* future possible st_blocks high bits */
+
+	unsigned long	st_atime;
+	unsigned long	st_atime_nsec;
+
+	unsigned long	st_mtime;
+	unsigned long	st_mtime_nsec;
+
+	unsigned long	st_ctime;
+	unsigned long	st_ctime_nsec;
+
+	unsigned long	__unused8;
+};
+
+#endif /* _ASM_MICROBLAZE_STAT_H */
diff --git a/include/asm-microblaze/statfs.h b/include/asm-microblaze/statfs.h
new file mode 100644
index 0000000..0b91fe1
--- /dev/null
+++ b/include/asm-microblaze/statfs.h
@@ -0,0 +1 @@
+#include <asm-generic/statfs.h>
-- 
1.5.4.GIT

