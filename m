Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZHXVoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZHXVoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZHXVoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:44:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbZHXVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:44:00 -0400
Date: Mon, 24 Aug 2009 17:40:14 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: lethal@linux-sh.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Message-Id: <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com>
In-Reply-To: <cover.1251146512.git.jbaron@redhat.com>
References: <cover.1251146512.git.jbaron@redhat.com>
Subject: [PATCH 1/4] add NR_syscalls define for x86 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a NR_syscalls #define for x86. This is used in the syscall events tracing
code. Todo: make it dynamic like x86_64

Signed-off-by: Jason Baron <jbaron@redhat.com>


---
 arch/x86/include/asm/unistd_32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 732a307..8deaada 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -345,6 +345,8 @@
 
 #ifdef __KERNEL__
 
+#define NR_syscalls 337
+
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
-- 
1.6.2.5

