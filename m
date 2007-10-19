Return-Path: <linux-kernel-owner+w=401wt.eu-S936510AbXJSWyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936510AbXJSWyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXJSWxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:53:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24184 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbXJSWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:53:52 -0400
Date: Fri, 19 Oct 2007 14:55:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: zippel@linux-m68k.org, sam@ravnborg.org
Subject: [PATCH] xconfig: set title bar
Message-Id: <20071019145528.1cdeb007.randy.dunlap@oracle.com>
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

menuconfig and gconfig already place a title (or caption) on the top
bar of their window (or whatever that is properly called).  However,
qconf (xconfig) just says "qconf".  I tried to find a Qt API to set
the title but did not find one, so set the program title (caption)
by using the "-title <caption>" command line option instead.

This can be useful when someone has multiple qconf instances running,
to help differentiate which one is which.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kconfig/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-git13.orig/scripts/kconfig/Makefile
+++ linux-2.6.23-git13/scripts/kconfig/Makefile
@@ -5,7 +5,7 @@
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
 xconfig: $(obj)/qconf
-	$< arch/$(ARCH)/Kconfig
+	$< arch/$(ARCH)/Kconfig -title "Linux v${KERNELVERSION} qconf"
 
 gconfig: $(obj)/gconf
 	$< arch/$(ARCH)/Kconfig
