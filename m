Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbXKZUsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbXKZUsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXKZUsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:48:40 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:16123 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbXKZUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:48:39 -0500
Date: Mon, 26 Nov 2007 12:47:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] x86 allnoconfig memory model
Message-Id: <20071126124730.34c43da1.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071126111320.69d0aead.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows allnoconfig to build cleanly.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Make allnoconfig on x86_64 build by allowing ARCH_SELECT_MEMORY_MODEL
to be enabled on X86 32/64, not just X86_32.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc3-mm1.orig/arch/x86/Kconfig
+++ linux-2.6.24-rc3-mm1/arch/x86/Kconfig
@@ -937,7 +937,7 @@ config ARCH_SPARSEMEM_ENABLE
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
-	depends on X86_32 && ARCH_SPARSEMEM_ENABLE
+	depends on ARCH_SPARSEMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
 	def_bool X86_64

