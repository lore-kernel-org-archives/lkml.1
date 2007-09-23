Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbXIWWtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbXIWWtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXIWWtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:49:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44348 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbXIWWtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:49:13 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Sep 2007 15:49:09 -0700
Subject: [patch 3/3] new timerfd API - un-break CONFIG_TIMERFD
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.19354.1190587751.3>
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
--- linux-2.6.mod.orig/init/Kconfig	2007-09-23 15:18:06.000000000 -0700
+++ linux-2.6.mod/init/Kconfig	2007-09-23 15:28:54.000000000 -0700
@@ -488,7 +488,6 @@
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
 	select ANON_INODES
-	depends on BROKEN
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer

