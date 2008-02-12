Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbYBLBcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbYBLBcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbYBLBbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:31:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62598 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYBLBbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:31:37 -0500
Date: Mon, 11 Feb 2008 17:27:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk
Subject: [PATCH 1/4] kernel-doc: fix fs/pipe.c notation
Message-Id: <20080211172753.3990e7bb.randy.dunlap@oracle.com>
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

Fix several kernel-doc notation errors in fs/pipe.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/pipe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.25-rc1.orig/fs/pipe.c
+++ linux-2.6.25-rc1/fs/pipe.c
@@ -171,7 +171,7 @@ static void anon_pipe_buf_release(struct
  *
  * Description:
  *	This function returns a kernel virtual address mapping for the
- *	passed in @pipe_buffer. If @atomic is set, an atomic map is provided
+ *	pipe_buffer passed in @buf. If @atomic is set, an atomic map is provided
  *	and the caller has to be careful not to fault before calling
  *	the unmap function.
  *
@@ -208,15 +208,15 @@ void generic_pipe_buf_unmap(struct pipe_
 }
 
 /**
- * generic_pipe_buf_steal - attempt to take ownership of a @pipe_buffer
+ * generic_pipe_buf_steal - attempt to take ownership of a &pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
  * @buf:	the buffer to attempt to steal
  *
  * Description:
- *	This function attempts to steal the @struct page attached to
+ *	This function attempts to steal the &struct page attached to
  *	@buf. If successful, this function returns 0 and returns with
  *	the page locked. The caller may then reuse the page for whatever
- *	he wishes, the typical use is insertion into a different file
+ *	he wishes; the typical use is insertion into a different file
  *	page cache.
  */
 int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
@@ -238,7 +238,7 @@ int generic_pipe_buf_steal(struct pipe_i
 }
 
 /**
- * generic_pipe_buf_get - get a reference to a @struct pipe_buffer
+ * generic_pipe_buf_get - get a reference to a &struct pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
  * @buf:	the buffer to get a reference to
  *
