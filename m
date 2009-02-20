Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZBTGFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZBTGFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 01:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZBTGFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 01:05:00 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:49443 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBTGE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 01:04:59 -0500
Message-ID: <499E4804.3030703@freemail.hu>
Date: Fri, 20 Feb 2009 07:04:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, ltp-list@lists.sourceforge.net
Subject: [PATCH] block: add documentation for register_blkdev()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32722; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Add documentation for register_blkdev() function and for the parameters.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
--- linux-2.6.29-rc5/block/genhd.c.orig	2009-02-14 18:36:39.000000000 +0100
+++ linux-2.6.29-rc5/block/genhd.c	2009-02-20 06:53:56.000000000 +0100
@@ -256,6 +256,22 @@ void blkdev_show(struct seq_file *seqf,
 }
 #endif /* CONFIG_PROC_FS */

+/**
+ * register_blkdev - register a new block device
+ *
+ * @major: the requested major device number [1..255]. If @major=0, try to
+ *         allocate any unused major number.
+ * @name: the name of the new block device as a zero terminated string
+ *
+ * The @name must be unique within the system.
+ *
+ * The return value depends on the @major input parameter.
+ *  - if a major device number was requested in range [1..255] then the
+ *    function returns zero on success, or a negative error code
+ *  - if any unused major number was requested with @major=0 parameter
+ *    then the return value is the allocated major number in range
+ *    [1..255] or a negative error code otherwise
+ */
 int register_blkdev(unsigned int major, const char *name)
 {
 	struct blk_major_name **n, *p;
