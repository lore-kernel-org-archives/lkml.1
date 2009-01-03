Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbZACEcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZACEcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbZACEbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:31:55 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:57163 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055AbZACEbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:31:53 -0500
Date: Fri, 2 Jan 2009 20:31:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] fs: fix function param name in kernel-doc
Message-Id: <20090102203120.8c22b681.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.495EEA22.008E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function parameter name in kernel-doc:

Warning(linux-2.6.28-git5//fs/block_dev.c:1272): No description found for parameter 'pathname'
Warning(linux-2.6.28-git5//fs/block_dev.c:1272): Excess function parameter 'path' description in 'lookup_bdev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28-git5.orig/fs/block_dev.c
+++ linux-2.6.28-git5/fs/block_dev.c
@@ -1262,7 +1262,7 @@ EXPORT_SYMBOL(ioctl_by_bdev);
 
 /**
  * lookup_bdev  - lookup a struct block_device by name
- * @path:	special file representing the block device
+ * @pathname:	special file representing the block device
  *
  * Get a reference to the blockdevice at @pathname in the current
  * namespace if possible and return it.  Return ERR_PTR(error)
