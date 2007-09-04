Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXIDWWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXIDWWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 18:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXIDWV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 18:21:57 -0400
Received: from li6-103.members.linode.com ([66.160.141.103]:2234 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbXIDWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 18:21:56 -0400
Date: Tue, 4 Sep 2007 15:21:54 -0700
From: Jason Lunz <lunz@falooley.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [mtd] allow modular mtdsuper
Message-ID: <20070904222154.GA12804@falooley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Declare mtdsuper to be gpl-licensed so it can access get_mtd_device and
put_mtd_device when loaded as a module.

Signed-off-by: Jason Lunz <lunz@falooley.org>

---
 drivers/mtd/mtdsuper.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22.6-uml/drivers/mtd/mtdsuper.c
===================================================================
--- linux-2.6.22.6-uml.orig/drivers/mtd/mtdsuper.c
+++ linux-2.6.22.6-uml/drivers/mtd/mtdsuper.c
@@ -14,6 +14,8 @@
 #include <linux/namei.h>
 #include <linux/ctype.h>

+MODULE_LICENSE("GPL");
+
 /*
  * compare superblocks to see if they're equivalent
  * - they are if the underlying MTD device is the same
