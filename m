Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZJVDj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZJVDj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZJVDj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:39:26 -0400
Received: from ozlabs.org ([203.10.76.45]:36584 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbZJVDjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:39:25 -0400
From: Michael Neuling <mikey@neuling.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, michael@ellerman.id.au
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] trivial: Fix typo in comment for #endif
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.2.1
Date: Thu, 22 Oct 2009 14:39:28 +1100
Message-ID: <18191.1256182768@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment suggests this #endif is CONFIG_X86 but it's really
CONFIG_TRACE_IRQFLAGS_SUPPORT

Signed-off-by: Michael Neuling <mikey@neuling.org>

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
