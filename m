Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbXKBBxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbXKBBxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXKBBw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:52:57 -0400
Received: from [222.73.24.84] ([222.73.24.84]:62178 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbXKBBw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:52:56 -0400
Message-ID: <472A828F.9070003@cn.fujitsu.com>
Date: Fri, 02 Nov 2007 09:51:11 +0800
From: lizf <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: davem@davemloft.net
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: [PATCH] sparck64: remove duplicate includes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes duplicate includes in arch/sparc64

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 arch/sparc64/kernel/ds.c          |    1 -
 arch/sparc64/kernel/module.c      |    1 -
 arch/sparc64/kernel/sys_sparc32.c |    1 -
 arch/sparc64/kernel/sys_sunos32.c |    1 -
 arch/sparc64/kernel/time.c        |    2 --
 5 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/sparc64/kernel/ds.c b/arch/sparc64/kernel/ds.c
index 9f472a7..eeb5a2f 100644
--- a/arch/sparc64/kernel/ds.c
+++ b/arch/sparc64/kernel/ds.c
@@ -6,7 +6,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
diff --git a/arch/sparc64/kernel/module.c b/arch/sparc64/kernel/module.c
index 5798715..158484b 100644
--- a/arch/sparc64/kernel/module.c
+++ b/arch/sparc64/kernel/module.c
@@ -11,7 +11,6 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/mm.h>
 
 #include <asm/processor.h>
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index 78caff9..98c4688 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -51,7 +51,6 @@
 #include <linux/vfs.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/ptrace.h>
-#include <linux/highuid.h>
 
 #include <asm/types.h>
 #include <asm/uaccess.h>
diff --git a/arch/sparc64/kernel/sys_sunos32.c b/arch/sparc64/kernel/sys_sunos32.c
index 170d6ca..cfc22d3 100644
--- a/arch/sparc64/kernel/sys_sunos32.c
+++ b/arch/sparc64/kernel/sys_sunos32.c
@@ -57,7 +57,6 @@
 #include <linux/personality.h>
 
 /* For SOCKET_I */
-#include <linux/socket.h>
 #include <net/sock.h>
 #include <net/compat.h>
 
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index cd8c740..54bdb88 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -28,7 +28,6 @@
 #include <linux/jiffies.h>
 #include <linux/cpufreq.h>
 #include <linux/percpu.h>
-#include <linux/profile.h>
 #include <linux/miscdevice.h>
 #include <linux/rtc.h>
 #include <linux/kernel_stat.h>
@@ -47,7 +46,6 @@
 #include <asm/sections.h>
 #include <asm/cpudata.h>
 #include <asm/uaccess.h>
-#include <asm/prom.h>
 #include <asm/irq_regs.h>
 
 DEFINE_SPINLOCK(mostek_lock);
-- 
1.5.3.rc7

