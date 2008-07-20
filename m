Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYGUADp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYGUADp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbYGUAC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:02:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYGUAC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:02:56 -0400
Subject: [PATCH 1/22] Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, matthew@wil.cx, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, chris@zankel.net
In-Reply-To: <1216592500.3679.14.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 03:56:38 +0530
Message-Id: <1216592798.3679.22.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward declartion of struct {old,}old_utsname in linux/syscalls.h
for system calls like sys_uname, sys_olduname

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 include/linux/syscalls.h         |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-alpha/syscalls.h
 create mode 100644 include/asm-arm/syscalls.h
 create mode 100644 include/asm-avr32/syscalls.h
 create mode 100644 include/asm-blackfin/syscalls.h
 create mode 100644 include/asm-cris/syscalls.h
 create mode 100644 include/asm-frv/syscalls.h
 create mode 100644 include/asm-h8300/syscalls.h
 create mode 100644 include/asm-ia64/syscalls.h
 create mode 100644 include/asm-m32r/syscalls.h
 create mode 100644 include/asm-m68k/syscalls.h
 create mode 100644 include/asm-m68knommu/syscalls.h
 create mode 100644 include/asm-mips/syscalls.h
 create mode 100644 include/asm-mn10300/syscalls.h
 create mode 100644 include/asm-parisc/syscalls.h
 create mode 100644 include/asm-s390/syscalls.h
 create mode 100644 include/asm-sh/syscalls.h
 create mode 100644 include/asm-sparc/syscalls.h
 create mode 100644 include/asm-um/syscalls.h
 create mode 100644 include/asm-v850/syscalls.h
 create mode 100644 include/asm-x86/syscalls.h
 create mode 100644 include/asm-xtensa/syscalls.h

diff --git a/include/asm-alpha/syscalls.h b/include/asm-alpha/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-arm/syscalls.h b/include/asm-arm/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-avr32/syscalls.h b/include/asm-avr32/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-blackfin/syscalls.h b/include/asm-blackfin/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-cris/syscalls.h b/include/asm-cris/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-frv/syscalls.h b/include/asm-frv/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-h8300/syscalls.h b/include/asm-h8300/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-ia64/syscalls.h b/include/asm-ia64/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-m32r/syscalls.h b/include/asm-m32r/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-m68k/syscalls.h b/include/asm-m68k/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-m68knommu/syscalls.h b/include/asm-m68knommu/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-mips/syscalls.h b/include/asm-mips/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-mn10300/syscalls.h b/include/asm-mn10300/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-parisc/syscalls.h b/include/asm-parisc/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-s390/syscalls.h b/include/asm-s390/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-sh/syscalls.h b/include/asm-sh/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-sparc/syscalls.h b/include/asm-sparc/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-um/syscalls.h b/include/asm-um/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-v850/syscalls.h b/include/asm-v850/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-x86/syscalls.h b/include/asm-x86/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-xtensa/syscalls.h b/include/asm-xtensa/syscalls.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..829556e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -54,6 +54,8 @@ struct compat_stat;
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct oldold_utsname;
+struct old_utsname;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -65,6 +67,8 @@ struct getcpu_cache;
 #include <linux/quota.h>
 #include <linux/key.h>
 
+#include <asm/syscalls.h>
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
-- 
1.5.5.1



