Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbYCNBsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbYCNBsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYCNBrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:47:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39287 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbYCNBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:47:36 -0400
Date: Thu, 13 Mar 2008 21:47:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH] X86: Explicitly include required header files.
Message-ID: <alpine.LFD.1.00.0803132143200.11821@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After an experimental cleanup of <linux/percpu.h>, these files were
exposed as invoking kmalloc() without including <linux/slab.h>.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 arch/x86/kernel/nmi_32.c  |    1 +
 arch/x86/kernel/test_nx.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 6a0aa70..800b07d 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -22,6 +22,7 @@
 #include <linux/cpumask.h>
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
+#include <linux/slab.h>

 #include <asm/smp.h>
 #include <asm/nmi.h>
diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
index 10b8a6f..787a5e4 100644
--- a/arch/x86/kernel/test_nx.c
+++ b/arch/x86/kernel/test_nx.c
@@ -11,6 +11,8 @@
  */
 #include <linux/module.h>
 #include <linux/sort.h>
+#include <linux/slab.h>
+
 #include <asm/uaccess.h>
 #include <asm/asm.h>


========================================================================
Robert P. J. Day Linux Consulting, Training and Annoying Kernel
Pedantry:
Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
