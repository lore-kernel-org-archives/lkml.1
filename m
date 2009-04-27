Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZD0Js6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZD0Js6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZD0JsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:18 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754118AbZD0JsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:17 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 17/30] microblaze_mmu_v1: Add CURRENT_TASK for entry.S
Date: Mon, 27 Apr 2009 10:32:06 +0200
Message-Id: <1240821139-7247-18-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-17-git-send-email-monstr@monstr.eu>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

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

