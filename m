Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbXHAJSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbXHAJSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXHAJR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:17:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbXHAJRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:17:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Connect up fallocate
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 01 Aug 2007 10:17:49 +0100
Message-ID: <20070801091749.11600.7319.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Connect up the fallocate() system call.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/entry.S  |    1 +
 include/asm-frv/unistd.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 275673c..1e74f3c 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1496,6 +1496,7 @@ sys_call_table:
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_fallocate
 
 
 syscall_table_size = (. - sys_call_table)
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
index 7306c71..cd84f17 100644
--- a/include/asm-frv/unistd.h
+++ b/include/asm-frv/unistd.h
@@ -330,10 +330,11 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_fallocate		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 324
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */

