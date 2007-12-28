Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbXL1TSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbXL1TSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXL1TSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:18:16 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40138 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbXL1TSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:18:16 -0500
Date: Fri, 28 Dec 2007 20:56:43 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.24 patch] restore blackfin HARDWARE_PM support
Message-ID: <20071228185643.GB4738@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the blackfin Hardware Performance Monitor Profiling 
support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---

 kernel/Kconfig.instrumentation |    9 +++++++++
 1 file changed, 9 insertions(+)

942996f33f81726c5edb012d61ecdad70c55884d 
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
index 97c76ca..e023671 100644
--- a/kernel/Kconfig.instrumentation
+++ b/kernel/Kconfig.instrumentation
@@ -44,2 +44,11 @@ config OPROFILE_MPCORE
 
+config HARDWARE_PM
+	tristate "Hardware Performance Monitor Profiling"
+	depends on BLACKFIN && PROFILING
+	help
+	  take use of hardware performance monitor to profiling the kernel
+	  and application.
+
+	  If unsure, say N.
+
 config KPROBES

