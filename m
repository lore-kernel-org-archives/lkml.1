Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXBVA2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXBVA2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965073AbXBVA2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:28:08 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:51796 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045AbXBVA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:28:07 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 21 Feb 2007 19:25:56 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: reiserfs-dev@namesys.com
Subject: [PATCH] ReiserFS:  Correct misspelled "REISERFS_PROC_INFO" to
 "CONFIG_REISERFS_PROC_INFO".
Message-ID: <Pine.LNX.4.64.0702211922570.6954@CPE00045a9c397f-CM001225dbafb6>
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


  Correct the misspelling of the preprocessor check of a Kconfig
option to refer to CONFIG_REISERFS_PROC_INFO and not just the
incorrect REISERFS_PROC_INFO.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index ecc9943..83b9135 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -20,7 +20,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>

-#if defined( REISERFS_PROC_INFO )
+#ifdef CONFIG_REISERFS_PROC_INFO

 /*
  * LOCKING:

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
