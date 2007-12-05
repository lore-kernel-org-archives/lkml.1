Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXLEIg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXLEIg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXLEIgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 03:36:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49374 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXLEIgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 03:36:20 -0500
Date: Wed, 5 Dec 2007 08:36:15 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] no need to mess with KBUILD_CFLAGS on uml-i386 anymore
Message-ID: <20071205083615.GF8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Now that X86_32 is provided on Kconfig level for uml-i386, there's
no need to play with it explicitly on Makefile level anymore.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 6729011..561e373 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -22,11 +22,6 @@ export LDFLAGS HOSTCFLAGS HOSTLDFLAGS UML_OBJCOPYFLAGS
 endif
 endif
 
-KBUILD_CFLAGS		+= -DCONFIG_X86_32
-KBUILD_AFLAGS		+= -DCONFIG_X86_32
-CONFIG_X86_32		:= y
-export CONFIG_X86_32
-
 # First of all, tune CFLAGS for the specific CPU. This actually sets cflags-y.
 include $(srctree)/arch/x86/Makefile_32.cpu
 
