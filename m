Return-Path: <linux-kernel-owner+w=401wt.eu-S1161167AbXBAEqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161167AbXBAEqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161189AbXBAEqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:46:46 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:36180 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161167AbXBAEqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:46:45 -0500
Date: Wed, 31 Jan 2007 20:41:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, dwmw2@infradead.org
Subject: [PATCH] MTD: add missing kernel-doc item
Message-Id: <20070131204113.1dcdab8b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning in mtd/nand.h.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/mtd/nand.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2620-rc7.orig/include/linux/mtd/nand.h
+++ linux-2620-rc7/include/linux/mtd/nand.h
@@ -343,6 +343,7 @@ struct nand_buffers {
  * @options:		[BOARDSPECIFIC] various chip options. They can partly be set to inform nand_scan about
  *			special functionality. See the defines for further explanation
  * @badblockpos:	[INTERN] position of the bad block marker in the oob area
+ * @cellinfo:		MLC/multichip data (newer devices have more ID bytes)
  * @numchips:		[INTERN] number of physical chips
  * @chipsize:		[INTERN] the size of one chip for multichip arrays
  * @pagemask:		[INTERN] page number mask = number of (pages / chip) - 1
