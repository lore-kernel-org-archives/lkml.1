Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbXKGNR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbXKGNR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXKGNRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:17:51 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51547 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752912AbXKGNRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:17:50 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: akpm@linux-foundation.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] AVR32: Remove KPROBES from Kconfig.debug
Date: Wed,  7 Nov 2007 14:17:34 +0100
Message-Id: <1194441454-350-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We already see it from init/Kconfig.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
This is assuming Mathieu Desnoyers' "Move Kconfig.instrumentation to
arch/Kconfig and init/Kconfig" patch is merged. If it's not, we need
to include kernel/Kconfig.instrumentation as well.

Therefore, Andrew, could you please keep this close to Mathieu's "Move
Kconfig.instrumentation to arch/Kconfig and init/Kconfig"?

 arch/avr32/Kconfig.debug |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/avr32/Kconfig.debug b/arch/avr32/Kconfig.debug
index 64ace00..2283933 100644
--- a/arch/avr32/Kconfig.debug
+++ b/arch/avr32/Kconfig.debug
@@ -6,14 +6,4 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config KPROBES
-	bool "Kprobes"
-	depends on DEBUG_KERNEL
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-          execute a callback function.  register_kprobe() establishes
-          a probepoint and specifies the callback.  Kprobes is useful
-          for kernel debugging, non-intrusive instrumentation and testing.
-          If in doubt, say "N".
-
 endmenu
-- 
1.5.3.4

