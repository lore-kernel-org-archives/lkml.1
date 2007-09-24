Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbXIXUXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbXIXUXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbXIXUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:22:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:32801 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbXIXUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:22:42 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2007 13:22:37 -0700
Subject: [patch 4/4] new timerfd API v2 - un-break CONFIG_TIMERFD
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.3854.1190665360.4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the broken status to CONFIG_TIMERFD.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.mod/init/Kconfig
===================================================================
--- linux-2.6.mod.orig/init/Kconfig	2007-09-24 12:13:25.000000000 -0700
+++ linux-2.6.mod/init/Kconfig	2007-09-24 12:31:40.000000000 -0700
@@ -488,7 +488,6 @@
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
 	select ANON_INODES
-	depends on BROKEN
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer

