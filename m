Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbXBBJuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbXBBJuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 04:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852AbXBBJuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 04:50:08 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:59275 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbXBBJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 04:50:06 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 2 Feb 2007 04:49:06 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, reiserfs-dev@namesys.com
Subject: [PATCH] REISERFS: Rename incorrect macro name "REISERFS_PROC_INFO".
Message-ID: <Pine.LNX.4.64.0702020447001.12400@CPE00045a9c397f-CM001225dbafb6>
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


  Rename the incorrect macro name "REISERFS_PROC_INFO" to
"CONFIG_REISERFS_PROC_INFO".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  what the heck ... might as well patch the ones i found.

diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index ecc9943..fc7aeb4 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -20,7 +20,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>

-#if defined( REISERFS_PROC_INFO )
+#if defined( CONFIG_REISERFS_PROC_INFO )

 /*
  * LOCKING:

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
