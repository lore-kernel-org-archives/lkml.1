Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZD0Ju5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZD0Ju5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZD0Js1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:27 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754576AbZD0Js0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:26 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 30/30] microblaze_mmu_v1: fcntl.h MMU update
Date: Mon, 27 Apr 2009 10:32:19 +0200
Message-Id: <1240821139-7247-31-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-30-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
 <1240821139-7247-12-git-send-email-monstr@monstr.eu>
 <1240821139-7247-13-git-send-email-monstr@monstr.eu>
 <1240821139-7247-14-git-send-email-monstr@monstr.eu>
 <1240821139-7247-15-git-send-email-monstr@monstr.eu>
 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
 <1240821139-7247-25-git-send-email-monstr@monstr.eu>
 <1240821139-7247-26-git-send-email-monstr@monstr.eu>
 <1240821139-7247-27-git-send-email-monstr@monstr.eu>
 <1240821139-7247-28-git-send-email-monstr@monstr.eu>
 <1240821139-7247-29-git-send-email-monstr@monstr.eu>
 <1240821139-7247-30-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/fcntl.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/fcntl.h b/arch/microblaze/include/asm/fcntl.h
index 46ab12d..b4d27f6 100644
--- a/arch/microblaze/include/asm/fcntl.h
+++ b/arch/microblaze/include/asm/fcntl.h
@@ -1 +1,15 @@
+#ifndef _ASM_MICROBLAZE_FCNTL_H
+#define _ASM_MICROBLAZE_FCNTL_H
+
+#ifndef __uClinux__
+
+#define O_DIRECTORY	040000 /* must be a directory */
+#define O_NOFOLLOW	0100000 /* don't follow links */
+#define O_LARGEFILE	0200000
+#define O_DIRECT	0400000 /* direct disk access hint */
+
+#endif /* __uClinux__ */
+
 #include <asm-generic/fcntl.h>
+
+#endif /* _ASM_MICROBLAZE_FCNTL_H */
-- 
1.5.5.1

