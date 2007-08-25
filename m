Return-Path: <linux-kernel-owner+w=401wt.eu-S934609AbXHYTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbXHYTu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933880AbXHYTuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:50:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60741 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780AbXHYTuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:50:18 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 25 Aug 2007 15:40:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] FS: Make RAMFS both selectable and tristate.
Message-ID: <Pine.LNX.4.64.0708251538320.29214@localhost.localdomain>
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


Allow RAMFS to be user-selectable, and to be built as a module.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that the help content for that option suggests it can be built
as a module, it just makes sense to make it selectable and tristate,
unless someone has a compelling argument against it.

diff --git a/fs/Kconfig b/fs/Kconfig
index 58a0650..e79ac86 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1003,7 +1003,7 @@ config HUGETLB_PAGE
 	def_bool HUGETLBFS

 config RAMFS
-	bool
+	tristate "Ramfs support"
 	default y
 	---help---
 	  Ramfs is a file system which keeps all files in RAM. It allows
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
