Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbYFZM7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbYFZM7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbYFZMl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:41:27 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:22432 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758034AbYFZMlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:41:17 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 51/60] microblaze_v4: pool.h socket.h
Date: Thu, 26 Jun 2008 14:30:20 +0200
Message-Id: <1214483429-32360-52-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-51-git-send-email-monstr@seznam.cz>
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
 <1214483429-32360-51-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-generic/socket.h    |   66 +++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/poll.h   |    1 +
 include/asm-microblaze/socket.h |    1 +
 3 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/socket.h
 create mode 100644 include/asm-microblaze/poll.h
 create mode 100644 include/asm-microblaze/socket.h

diff --git a/include/asm-generic/socket.h b/include/asm-generic/socket.h
new file mode 100644
index 0000000..3f3430e
--- /dev/null
+++ b/include/asm-generic/socket.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_GENERIC_SOCKET_H
+#define _ASM_GENERIC_SOCKET_H
+
+#include <asm/sockios.h>
+
+/* For setsockoptions(2) */
+#define SOL_SOCKET	1
+
+#define SO_DEBUG	1
+#define SO_REUSEADDR	2
+#define SO_TYPE		3
+#define SO_ERROR	4
+#define SO_DONTROUTE	5
+#define SO_BROADCAST	6
+#define SO_SNDBUF	7
+#define SO_RCVBUF	8
+#define SO_SNDBUFFORCE	32
+#define SO_RCVBUFFORCE	33
+#define SO_KEEPALIVE	9
+#define SO_OOBINLINE	10
+#define SO_NO_CHECK	11
+#define SO_PRIORITY	12
+#define SO_LINGER	13
+#define SO_BSDCOMPAT	14
+/* To add :#define SO_REUSEPORT 15 */
+#define SO_PASSCRED	16
+#define SO_PEERCRED	17
+#define SO_RCVLOWAT	18
+#define SO_SNDLOWAT	19
+#define SO_RCVTIMEO	20
+#define SO_SNDTIMEO	21
+
+/* Security levels - as per NRL IPv6 - don't actually do anything */
+#define SO_SECURITY_AUTHENTICATION		22
+#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
+#define SO_SECURITY_ENCRYPTION_NETWORK		24
+
+#define SO_BINDTODEVICE	25
+
+/* Socket filtering */
+#define SO_ATTACH_FILTER	26
+#define SO_DETACH_FILTER	27
+
+#define SO_PEERNAME		28
+#define SO_TIMESTAMP		29
+#define SCM_TIMESTAMP		SO_TIMESTAMP
+
+#define SO_ACCEPTCONN		30
+
+#define SO_PEERSEC		31
+#define SO_PASSSEC		34
+
+#define SO_TIMESTAMPNS		35
+#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
+
+#define SO_MARK			36
+
+#endif /* _ASM_GENERIC_SOCKET_H */
diff --git a/include/asm-microblaze/poll.h b/include/asm-microblaze/poll.h
new file mode 100644
index 0000000..c98509d
--- /dev/null
+++ b/include/asm-microblaze/poll.h
@@ -0,0 +1 @@
+#include <asm-generic/poll.h>
diff --git a/include/asm-microblaze/socket.h b/include/asm-microblaze/socket.h
new file mode 100644
index 0000000..6b71384
--- /dev/null
+++ b/include/asm-microblaze/socket.h
@@ -0,0 +1 @@
+#include <asm-generic/socket.h>
-- 
1.5.4.GIT

