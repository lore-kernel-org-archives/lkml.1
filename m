Return-Path: <linux-kernel-owner+w=401wt.eu-S966247AbXDDBiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966247AbXDDBiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966253AbXDDBfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:51 -0400
Received: from 250.sub-75-209-50.myvzw.com ([75.209.50.250]:34561 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966254AbXDDBff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:35 -0400
Message-Id: <20070404011453.193215073@goop.org>
References: <20070404010655.400913479@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 18:06:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 1/6] Re-enable VDSO by default with PARAVIRT
Content-Disposition: inline; filename=paravirt-enable-vdso.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone wants VDSO to be enabled by default.  COMPAT_VDSO still needs
a fix, but with luck that will turn up soon.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/sysenter.c |    4 ----
 1 file changed, 4 deletions(-)

===================================================================
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -27,11 +27,7 @@
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-#ifdef CONFIG_PARAVIRT
-unsigned int __read_mostly vdso_enabled = 0;
-#else
 unsigned int __read_mostly vdso_enabled = 1;
-#endif
 
 EXPORT_SYMBOL_GPL(vdso_enabled);
 

-- 

