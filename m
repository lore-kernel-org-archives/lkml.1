Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXL1TSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXL1TSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXL1TSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:18:17 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40148 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXL1TSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:18:16 -0500
Date: Fri, 28 Dec 2007 20:56:49 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6.24 patch] restore Cell OProfile support
Message-ID: <20071228185649.GC4738@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the Cell OProfile support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---

 kernel/Kconfig.instrumentation |    8 ++++++++
 1 file changed, 8 insertions(+)

6d1446d35d367fdbdd2a0a29e0d156646ff40630 
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
index a76635d..9d143e6 100644
--- a/kernel/Kconfig.instrumentation
+++ b/kernel/Kconfig.instrumentation
@@ -53,2 +53,10 @@ config HARDWARE_PM
 
+config OPROFILE_CELL
+	bool "OProfile for Cell Broadband Engine"
+	depends on PPC && (SPU_FS = y && OPROFILE = m) || (SPU_FS = y && OPROFILE = y) 
+	default y
+	help
+	  Profiling of Cell BE SPUs requires special support enabled
+	  by this option.
+
 config KPROBES

