Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZFQRCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZFQRCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbZFQRCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:02:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:40742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbZFQRCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:02:16 -0400
Date: Wed, 17 Jun 2009 17:01:45 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, hpa@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, hpa@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245228070.2662.1.camel@ht.satnam>
References: <1245228070.2662.1.camel@ht.satnam>
Subject: [tip:x86/urgent] x86: msr.h linux/types.h is only required for __KERNEL__
Message-ID: <tip-8fa62ad9d24e24707164ac7a97cbe59fe78a8591@git.kernel.org>
Git-Commit-ID: 8fa62ad9d24e24707164ac7a97cbe59fe78a8591
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 17:01:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fa62ad9d24e24707164ac7a97cbe59fe78a8591
Gitweb:     http://git.kernel.org/tip/8fa62ad9d24e24707164ac7a97cbe59fe78a8591
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 17 Jun 2009 14:11:10 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 18:56:01 +0200

x86: msr.h linux/types.h is only required for __KERNEL__

<linux/types.h> is only required for __KERNEL__ as whole file is covered with it

Also fixed some spacing issues for usr/include/asm-x86/msr.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>
LKML-Reference: <1245228070.2662.1.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/msr.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2260376..48ad9d2 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -3,13 +3,10 @@
 
 #include <asm/msr-index.h>
 
-#ifndef __ASSEMBLY__
-# include <linux/types.h>
-#endif
-
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
+#include <linux/types.h>
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/cpumask.h>
@@ -264,6 +261,4 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 #endif  /* CONFIG_SMP */
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
-
-
 #endif /* _ASM_X86_MSR_H */
