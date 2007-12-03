Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbXLCNrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbXLCNrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXLCNrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:47:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59924 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753014AbXLCNrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:47:17 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 1/2] [AVR32] Include instrumentation menu
Date: Mon,  3 Dec 2007 14:46:57 +0100
Message-Id: <1196689618-17503-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove KPROBES option from Kconfig.debug and include
kernel/Kconfig.instrumentation.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/Kconfig       |    2 ++
 arch/avr32/Kconfig.debug |   10 ----------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index b77abce..bc08c7f 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -219,6 +219,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/avr32/Kconfig.debug"
 
 source "security/Kconfig"
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

