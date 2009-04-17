Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZDQClp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZDQClp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759568AbZDQCl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:41:27 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:21543 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbZDQClZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:41:25 -0400
Date: Thu, 16 Apr 2009 19:09:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: jens.axboe@oracle.com, torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] splice: fix new kernel-doc warnings
Message-Id: <20090416190955.fb1e07d3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49E7EC03.01F8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

splice: fix kernel-doc warnings

Warning(fs/splice.c:617): bad line: 
Warning(fs/splice.c:722): No description found for parameter 'sd'
Warning(fs/splice.c:722): Excess function parameter 'pipe' description in 'splice_from_pipe_begin'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/splice.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.30-rc2-git1.orig/fs/splice.c
+++ linux-2.6.30-rc2-git1/fs/splice.c
@@ -614,7 +614,6 @@ static void wakeup_pipe_writers(struct p
  * @actor:	handler that splices the data
  *
  * Description:
-
  *    This function loops over the pipe and calls @actor to do the
  *    actual moving of a single struct pipe_buffer to the desired
  *    destination.  It returns when there's no more buffers left in
@@ -711,7 +710,7 @@ EXPORT_SYMBOL(splice_from_pipe_next);
 
 /**
  * splice_from_pipe_begin - start splicing from pipe
- * @pipe:	pipe to splice from
+ * @sd:		information about the splice operation
  *
  * Description:
  *    This function should be called before a loop containing
