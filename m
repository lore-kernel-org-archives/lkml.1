Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYA3TxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYA3TxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYA3Tw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:52:57 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:19315 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYA3Tw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:52:56 -0500
Date: Wed, 30 Jan 2008 11:51:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: axboe@kernek.dk, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: fix block api fatal error
Message-Id: <20080130115100.91c43f97.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook fatal error:
docproc: linux-2.6.24-git8/block/ll_rw_blk.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.24-git8.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.24-git8/Documentation/DocBook/kernel-api.tmpl
@@ -419,7 +419,13 @@ X!Edrivers/pnp/system.c
 
   <chapter id="blkdev">
      <title>Block Devices</title>
-!Eblock/ll_rw_blk.c
+!Eblock/blk-core.c
+!Eblock/blk-map.c
+!Iblock/blk-sysfs.c
+!Eblock/blk-settings.c
+!Eblock/blk-exec.c
+!Eblock/blk-barrier.c
+!Eblock/blk-tag.c
   </chapter>
 
   <chapter id="chrdev">
