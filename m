Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbXKYWPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbXKYWPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbXKYWOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:14:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38733 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbXKYWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:14:24 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Nov 2007 14:14:19 -0800
Subject: [patch 4/4] Timerfd v3 - un-break CONFIG_TIMERFD
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.18989.1196028862.4>
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
--- linux-2.6.mod.orig/init/Kconfig	2007-11-23 13:55:15.000000000 -0800
+++ linux-2.6.mod/init/Kconfig	2007-11-24 12:49:30.000000000 -0800
@@ -566,7 +566,6 @@
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
 	select ANON_INODES
-	depends on BROKEN
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer

