Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZFYUW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZFYUW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFYUWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:22:50 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34009 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZFYUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:22:49 -0400
Date: Thu, 25 Jun 2009 16:20:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] X86:  Typo fix:  "CONFIG_x86_64" -> "CONFIG_X86_64"
Message-ID: <alpine.LFD.2.00.0906251618430.14400@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  i'm assuming this is sufficient.

diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 418e632..6f02b9a 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -16,7 +16,7 @@
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))

 /* Minimum kernel alignment, as a power of two */
-#ifdef CONFIG_x86_64
+#ifdef CONFIG_X86_64
 #define MIN_KERNEL_ALIGN_LG2	PMD_SHIFT
 #else
 #define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT+1)

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
