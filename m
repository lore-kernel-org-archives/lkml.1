Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbZDPKGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbZDPKGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZDPKEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:04:51 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:57956 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753745AbZDPKEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:04:48 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 08/11] microblaze: Add missing preadv and pwritev syscalls
Date: Thu, 16 Apr 2009 11:56:35 +0200
Message-Id: <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
 <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/unistd.h   |    4 +++-
 arch/microblaze/kernel/syscall_table.S |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index d9d3903..b5e2f5f 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -378,8 +378,10 @@
 #define __NR_sendmsg		360 /* new */
 #define __NR_recvmsg		361 /* new */
 #define __NR_accept04		362 /* new */
+#define __NR_preadv		363 /* new */
+#define __NR_pwritev		364 /* new */
 
-#define __NR_syscalls		363
+#define __NR_syscalls		365
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index 529b0db..3bb42ec 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -363,3 +363,5 @@ ENTRY(sys_call_table)
 	.long sys_sendmsg		/* 360 */
 	.long sys_recvmsg
 	.long sys_ni_syscall
+	.long sys_ni_syscall
+	.long sys_ni_syscall
-- 
1.5.5.1

