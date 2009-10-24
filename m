Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZJXBFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZJXBFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZJXBFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:05:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:49439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZJXBFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:05:08 -0400
Date: Sat, 24 Oct 2009 01:04:06 GMT
From: tip-bot for Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mikey@neuling.org, mingo@elte.hu
In-Reply-To: <18191.1256182768@neuling.org>
References: <18191.1256182768@neuling.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] irq: trivial: Fix typo in comment for #endif
Message-ID: <tip-40b1f4e5113eafc5e84f2ba86822df66087fcb25@git.kernel.org>
Git-Commit-ID: 40b1f4e5113eafc5e84f2ba86822df66087fcb25
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40b1f4e5113eafc5e84f2ba86822df66087fcb25
Gitweb:     http://git.kernel.org/tip/40b1f4e5113eafc5e84f2ba86822df66087fcb25
Author:     Michael Neuling <mikey@neuling.org>
AuthorDate: Thu, 22 Oct 2009 14:39:28 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 08:28:10 +0200

irq: trivial: Fix typo in comment for #endif

The comment suggests this #endif is CONFIG_X86 but it's really
CONFIG_TRACE_IRQFLAGS_SUPPORT

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: michael@ellerman.id.au
LKML-Reference: <18191.1256182768@neuling.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irqflags.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index b02a3f1..006bf45 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -124,6 +124,6 @@
 	typecheck(unsigned long, flags);	\
 	raw_irqs_disabled_flags(flags);		\
 })
-#endif		/* CONFIG_X86 */
+#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #endif
