Return-Path: <linux-kernel-owner+w=401wt.eu-S1761751AbZE0H2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761751AbZE0H2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762182AbZE0HZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:25:48 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46899 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762167AbZE0HZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:25:47 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 15/29] microblaze_mmu_v2: Add CURRENT_TASK for entry.S
Date: Wed, 27 May 2009 08:47:40 +0200
Message-Id: <1243406874-3917-16-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-15-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/current.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/current.h b/arch/microblaze/include/asm/current.h
index 8375ea9..29303ed 100644
--- a/arch/microblaze/include/asm/current.h
+++ b/arch/microblaze/include/asm/current.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,6 +11,12 @@
 #ifndef _ASM_MICROBLAZE_CURRENT_H
 #define _ASM_MICROBLAZE_CURRENT_H
 
+/*
+ * Register used to hold the current task pointer while in the kernel.
+ * Any `call clobbered' register without a special meaning should be OK,
+ * but check asm/microblaze/kernel/entry.S to be sure.
+ */
+#define CURRENT_TASK	r31
 # ifndef __ASSEMBLY__
 /*
  * Dedicate r31 to keeping the current task pointer
-- 
1.5.5.1

