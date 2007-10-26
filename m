Return-Path: <linux-kernel-owner+w=401wt.eu-S1761176AbXJZRbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176AbXJZRbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764181AbXJZRaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:30:35 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:56800 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764104AbXJZRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:30:34 -0400
Subject: [PATCH] voyager: fix breakage caused by boot_params problem
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 12:30:28 -0500
Message-Id: <1193419828.3293.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There was a missed conversion in the voyager architecture setup file
which this corrects.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

---

James

diff --git a/include/asm-x86/mach-voyager/setup_arch.h b/include/asm-x86/mach-voyager/setup_arch.h
index 84d01ad..10debd2 100644
--- a/include/asm-x86/mach-voyager/setup_arch.h
+++ b/include/asm-x86/mach-voyager/setup_arch.h
@@ -1,5 +1,5 @@
 #include <asm/voyager.h>
-#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(PARAM+0x40))
+#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(&boot_params.apm_bios_info))
 
 /* Hook to call BIOS initialisation function */
 


