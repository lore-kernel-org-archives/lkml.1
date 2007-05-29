Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbXE2RNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbXE2RNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbXE2RMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:12:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41804 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXE2RMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:12:54 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 29 May 2007 13:11:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] FILESYSTEMS:  Delete unused "int dummy[5]" from inodes_stat_t.
Message-ID: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete the apparently unused array "int dummy[5]" from struct
inodes_stat_t.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  no idea what that array is for, but no one seems to care about it.
removal compile-tested on x86 with "make allyesconfig" and nobody
misses it (unless it's used for padding of some kind).


diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7cf0c54..dec83dd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -44,7 +44,6 @@ extern int get_max_files(void);
 struct inodes_stat_t {
 	int nr_inodes;
 	int nr_unused;
-	int dummy[5];
 };
 extern struct inodes_stat_t inodes_stat;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
