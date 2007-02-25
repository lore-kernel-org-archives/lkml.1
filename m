Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXBYUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXBYUPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932976AbXBYUPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:15:37 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:55852 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbXBYUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:15:36 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 25 Feb 2007 15:11:57 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Remove redundant #ifdef __KERNEL__ checks.
Message-ID: <Pine.LNX.4.64.0702251509440.27758@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove the redundant intermediate checks for __KERNEL__ since, as
soon as one ends, the next one starts.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/include/linux/stat.h b/include/linux/stat.h
index 4f8539c..a3d6342 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -5,10 +5,6 @@

 #include <asm/stat.h>

-#endif
-
-#ifdef __KERNEL__
-
 #define S_IFMT  00170000
 #define S_IFSOCK 0140000
 #define S_IFLNK	 0120000
@@ -44,9 +40,6 @@
 #define S_IWOTH 00002
 #define S_IXOTH 00001

-#endif
-
-#ifdef __KERNEL__
 #define S_IRWXUGO	(S_IRWXU|S_IRWXG|S_IRWXO)
 #define S_IALLUGO	(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
 #define S_IRUGO		(S_IRUSR|S_IRGRP|S_IROTH)

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
