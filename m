Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbXJ2Eem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbXJ2Eem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXJ2Eee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:34:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58226 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXJ2Eee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:34:34 -0400
Date: Mon, 29 Oct 2007 04:34:31 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] more x86 merge fallout (uml, again)
Message-ID: <20071029043431.GX8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/i386/{Kconfig,Makefile}.cpu got moved

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index 9876d80..e0ac74e 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -1,6 +1,6 @@
 menu "Host processor type and features"
 
-source "arch/i386/Kconfig.cpu"
+source "arch/x86/Kconfig.cpu"
 
 endmenu
 
diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 08433f8..b01dfb0 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -28,7 +28,7 @@ CONFIG_X86_32		:= y
 export CONFIG_X86_32
 
 # First of all, tune CFLAGS for the specific CPU. This actually sets cflags-y.
-include $(srctree)/arch/i386/Makefile.cpu
+include $(srctree)/arch/x86/Makefile_32.cpu
 
 # prevent gcc from keeping the stack 16 byte aligned. Taken from i386.
 cflags-y += $(call cc-option,-mpreferred-stack-boundary=2)
