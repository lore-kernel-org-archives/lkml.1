Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYH2Lqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYH2Lqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbYH2Lqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:46:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13710 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbYH2Lqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:46:37 -0400
Message-Id: <48B7FE08.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:47:52 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust init section definitions
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rodata equivalents for assembly use, and fix the section attributes
used by __REFCONST.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/linux/init.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.27-rc5/include/linux/init.h	2008-08-21 14:37:35.000000000 +0200
+++ 2.6.27-rc5-init-rodata/include/linux/init.h	2008-08-22 15:24:33.000000000 +0200
@@ -112,21 +112,25 @@
 #define __FINIT		.previous
 
 #define __INITDATA	.section	".init.data","aw"
+#define __INITRODATA	.section	".init.rodata","a"
 #define __FINITDATA	.previous
 
 #define __DEVINIT        .section	".devinit.text", "ax"
 #define __DEVINITDATA    .section	".devinit.data", "aw"
+#define __DEVINITRODATA  .section	".devinit.rodata", "a"
 
 #define __CPUINIT        .section	".cpuinit.text", "ax"
 #define __CPUINITDATA    .section	".cpuinit.data", "aw"
+#define __CPUINITRODATA  .section	".cpuinit.rodata", "a"
 
 #define __MEMINIT        .section	".meminit.text", "ax"
 #define __MEMINITDATA    .section	".meminit.data", "aw"
+#define __MEMINITRODATA  .section	".meminit.rodata", "a"
 
 /* silence warnings when references are OK */
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
-#define __REFCONST       .section       ".ref.rodata", "aw"
+#define __REFCONST       .section       ".ref.rodata", "a"
 
 #ifndef __ASSEMBLY__
 /*



