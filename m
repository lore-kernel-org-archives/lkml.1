Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbXFLTQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbXFLTQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXFLTQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:16:06 -0400
Received: from gretel.pobox.com ([208.58.1.197]:41121 "EHLO gretel.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXFLTQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:16:04 -0400
From: Nathan Lynch <ntl@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Nathan Lynch <ntl@pobox.com>
Subject: [PATCH] remove unused lock_cpu_hotplug_interruptible definition
Date: Tue, 12 Jun 2007 14:04:14 -0500
Message-Id: <11816750543359-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

aa95387774039096c11803c04011f1aa42d85758 removed the implementation of
lock_cpu_hotplug_interruptible and all users of it.  This stub
definition for !CONFIG_HOTPLUG_CPU was left over -- kill it now.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 include/linux/cpu.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 3b2df25..c2236bb 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -120,7 +120,6 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
-#define lock_cpu_hotplug_interruptible() 0
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 #define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
 #define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
-- 
1.5.2

