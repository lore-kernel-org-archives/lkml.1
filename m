Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbXIYX0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbXIYX0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXIYXZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:25:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27244 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbXIYXZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:25:58 -0400
Date: Tue, 25 Sep 2007 16:24:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH -mm] ecryptfs: fix printk format warning
Message-Id: <20070925162402.4a3cc9a3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:
fs/ecryptfs/crypto.c:1443: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ecryptfs/crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc8-mm1.orig/fs/ecryptfs/crypto.c
+++ linux-2.6.23-rc8-mm1/fs/ecryptfs/crypto.c
@@ -1439,7 +1439,7 @@ static int parse_header_metadata(struct 
 		 * crypt_stat->num_header_extents_at_front)
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
 		rc = -EINVAL;
-		printk(KERN_WARNING "Invalid number of header extents: [%d]\n",
+		printk(KERN_WARNING "Invalid number of header extents: [%zd]\n",
 		       crypt_stat->num_header_extents_at_front);
 	}
 	return rc;
