Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494Ab0ABEhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0ABEhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 23:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474Ab0ABEhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 23:37:01 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:63227 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab0ABEg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 23:36:59 -0500
Date: Fri, 1 Jan 2010 20:35:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
       Jens Axboe <jens.axboe@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 1/4] writeback: add missing kernel-doc notation
Message-Id: <20100101203523.11a69c58.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B3ECD5A.0165:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: writeback: add missing kernel-doc notation

Fix the following htmldocs warning:

  Warning(fs/fs-writeback.c:255): No description found for parameter 'sb'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.33-rc2-git4.orig/fs/fs-writeback.c
+++ linux-2.6.33-rc2-git4/fs/fs-writeback.c
@@ -242,6 +242,7 @@ static void bdi_sync_writeback(struct ba
 /**
  * bdi_start_writeback - start writeback
  * @bdi: the backing device to write from
+ * @sb: write inodes from this super_block
  * @nr_pages: the number of pages to write
  *
  * Description:
