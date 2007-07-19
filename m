Return-Path: <linux-kernel-owner+w=401wt.eu-S1763186AbXGSLLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763186AbXGSLLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXGSLLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:11:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46459 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbXGSLLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:11:02 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 07:09:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, vandrove@vc.cvut.cz
Subject: [PATCH] NCP:  Delete test of long-deceased CONFIG_NCPFS_DEBUGDENTRY.
Message-ID: <Pine.LNX.4.64.0707190706300.24493@localhost.localdomain>
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

  steve walks warily down the street with the brim pulled way down low
...


diff --git a/fs/ncpfs/ncplib_kernel.c b/fs/ncpfs/ncplib_kernel.c
index 551e0ba..df6d60b 100644
--- a/fs/ncpfs/ncplib_kernel.c
+++ b/fs/ncpfs/ncplib_kernel.c
@@ -726,9 +726,6 @@ ncp_del_file_or_subdir2(struct ncp_server *server,
 	__le32 dirent;

 	if (!inode) {
-#ifdef CONFIG_NCPFS_DEBUGDENTRY
-		PRINTK("ncpfs: ncpdel2: dentry->d_inode == NULL\n");
-#endif
 		return 0xFF;	/* Any error */
 	}
 	volnum = NCP_FINFO(inode)->volNumber;
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
