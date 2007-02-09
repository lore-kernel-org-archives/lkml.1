Return-Path: <linux-kernel-owner+w=401wt.eu-S1946669AbXBIQj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946669AbXBIQj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946661AbXBIQjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51709 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946649AbXBIQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:26 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] io_apic: trivial __iomem annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYmT-0006pj-NL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/i386/kernel/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 5592fa6..ba8d302 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -126,7 +126,7 @@ static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned i
  */
 static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
-	volatile struct io_apic *io_apic = io_apic_base(apic);
+	volatile struct io_apic __iomem *io_apic = io_apic_base(apic);
 	if (sis_apic_bug)
 		writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
-- 
1.5.0-rc2.GIT


