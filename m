Return-Path: <linux-kernel-owner+w=401wt.eu-S1422920AbXBAST6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422920AbXBAST6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422923AbXBAST6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:19:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53642 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422920AbXBAST5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:19:57 -0500
Date: Thu, 1 Feb 2007 10:19:55 -0800
From: Judith Lebzelter <judith@osdl.org>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, fastboot@osdl.org
Subject: [ PATCH ] fix to documentation for kexec
Message-ID: <20070201181955.GE5825@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've noticed that the boot options are not correct for in 
the documentation for kdump. The "init" keyword is not 
necessary, and causes a kernel panic when booting with an 
initrd on Fedora 5.

Thanks;
Judith Lebzelter

---
Signed-off-by: Judith Lebzelter <judith@osdl.org>
---


Index: linux/Documentation/kdump/kdump.txt
===================================================================
--- linux.orig/Documentation/kdump/kdump.txt
+++ linux/Documentation/kdump/kdump.txt
@@ -207,7 +207,7 @@ the following command:
 
    kexec -p <dump-capture-kernel> \
    --initrd=<initrd-for-dump-capture-kernel> --args-linux \
-   --append="root=<root-dev> init 1 irqpoll"
+   --append="root=<root-dev> 1 irqpoll"
 
 
 Notes on loading the dump-capture kernel:
@@ -228,8 +228,8 @@ Notes on loading the dump-capture kernel
 * You must specify <root-dev> in the format corresponding to the root
   device name in the output of mount command.
 
-* "init 1" boots the dump-capture kernel into single-user mode without
-  networking. If you want networking, use "init 3."
+* Boot parameter "1" boots the dump-capture kernel into single-user mode 
+  without networking. If you want networking, use "3".
 
 
 Kernel Panic
