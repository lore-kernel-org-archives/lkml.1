Return-Path: <linux-kernel-owner+w=401wt.eu-S1764648AbXGSJ4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764648AbXGSJ4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXGSJyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbXGSJys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:48 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: khali@linux-fr.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/58] x86_64: asm/ptrace.h needs linux/compiler.h
Message-Id: <20070719095446.EB90C14E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jean Delvare <khali@linux-fr.org>
On x86_64, <asm/ptrace.h> uses __user but doesn't include
<linux/compiler.h>. This could lead to build failures.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/ptrace.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/include/asm-x86_64/ptrace.h
===================================================================
--- linux.orig/include/asm-x86_64/ptrace.h
+++ linux/include/asm-x86_64/ptrace.h
@@ -1,6 +1,7 @@
 #ifndef _X86_64_PTRACE_H
 #define _X86_64_PTRACE_H
 
+#include <linux/compiler.h>	/* For __user */
 #include <asm/ptrace-abi.h>
 
 #ifndef __ASSEMBLY__
