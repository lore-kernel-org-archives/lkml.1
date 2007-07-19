Return-Path: <linux-kernel-owner+w=401wt.eu-S1764731AbXGSLZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764731AbXGSLZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbXGSLZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:25:45 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46932 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXGSLZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:25:43 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 07:23:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, jirislaby@gmail.com
Subject: [PATCH] Warn userspace about including an empty linux/tty.h.
Message-ID: <Pine.LNX.4.64.0707190721520.25369@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  what subsystem would something like this belong to?


diff --git a/include/linux/tty.h b/include/linux/tty.h
index 691a174..fd67da8 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -5,6 +5,10 @@
  * 'tty.h' defines some structures used by tty_io.c and some defines.
  */

+#ifndef __KERNEL__
+#warning "Please don't include this file from userspace, it's empty."
+#endif
+
 #ifdef __KERNEL__
 #include <linux/fs.h>
 #include <linux/major.h>
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
