Return-Path: <linux-kernel-owner+w=401wt.eu-S933858AbZFLQd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbZFLQd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764839AbZFLQZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39104 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764639AbZFLQZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 27/27] Blackfin: hook up new rt_tgsigqueueinfo syscall
Date: Fri, 12 Jun 2009 12:24:45 -0400
Message-Id: <1244823885-22410-28-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/unistd.h |    1 +
 arch/blackfin/mach-common/entry.S  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index cf5066d..fac7505 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -380,6 +380,7 @@
 #define __NR_inotify_init1	365
 #define __NR_preadv		366
 #define __NR_pwritev		367
+#define __NR_rt_tgsigqueueinfo	368
 
 #define __NR_syscall		368
 #define NR_syscalls		__NR_syscall
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 25c6aa4..31fa313 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1608,6 +1608,7 @@ ENTRY(_sys_call_table)
 	.long _sys_inotify_init1	/* 365 */
 	.long _sys_preadv
 	.long _sys_pwritev
+	.long _sys_rt_tgsigqueueinfo
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
-- 
1.6.3.1

