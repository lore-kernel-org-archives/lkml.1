Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXKLFIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXKLFIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 00:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXKLFHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 00:07:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:32182 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXKLFHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 00:07:48 -0500
Date: Sun, 11 Nov 2007 21:06:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: James.Bottomley@HansenPartnership.com, tglx@linutronix.de
Subject: [PATCH 1/3] voyager: use correct header file name
Message-Id: <20071111210602.dd6702e5.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix header file name for Voyager build.

In file included from arch/x86/kernel/setup_32.c:61:
include/asm-x86/mach-voyager/setup_arch.h:2:26: error: asm/setup_32.h: No such file or directory
make[1]: *** [arch/x86/kernel/setup_32.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-x86/mach-voyager/setup_arch.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc2-git2.orig/include/asm-x86/mach-voyager/setup_arch.h
+++ linux-2.6.24-rc2-git2/include/asm-x86/mach-voyager/setup_arch.h
@@ -1,5 +1,5 @@
 #include <asm/voyager.h>
-#include <asm/setup_32.h>
+#include <asm/setup.h>
 #define VOYAGER_BIOS_INFO ((struct voyager_bios_info *) \
 			(&boot_params.apm_bios_info))
 
