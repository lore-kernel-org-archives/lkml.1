Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXAYP0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXAYP0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965480AbXAYP0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:26:05 -0500
Received: from www.osadl.org ([213.239.205.134]:56014 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965472AbXAYP0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:26:04 -0500
Subject: [PATCH 2.6.20-rc6][MIPS]Malta: trivial compile error fix
From: Jan Altenberg <jan@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 25 Jan 2007 16:25:56 +0100
Message-Id: <1169738756.18700.12.camel@jan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

the following patch should fix a compile error for MIPS_MALTA, when
CONFIG_MTD is disabled.

regards,
JAN

---

- Fix a compile error for MIPS_MALTA, when CONFIG_MTD is disabled.

Signed-off-by: Jan Altenberg <jan@linutronix.de>

---
 arch/mips/mips-boards/malta/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/mips/mips-boards/malta/Makefile
===================================================================
--- linux-2.6.orig/arch/mips/mips-boards/malta/Makefile
+++ linux-2.6/arch/mips/mips-boards/malta/Makefile
@@ -19,5 +19,6 @@
 # under Linux.
 #
 
-obj-y := malta_int.o malta_mtd.o malta_setup.o
+obj-y := malta_int.o malta_setup.o
+obj-$(CONFIG_MTD) += malta_mtd.o
 obj-$(CONFIG_SMP) += malta_smp.o


