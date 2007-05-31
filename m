Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbXEaQoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbXEaQoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXEaQoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:44:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59177 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbXEaQoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:44:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] buffer:  Kill old incorrect? comment.
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
	<465A6078.6010804@yahoo.com.au> <465A6197.5010402@yahoo.com.au>
	<m1veed82mz.fsf@ebiederm.dsl.xmission.com>
	<465BB6C2.7050704@yahoo.com.au>
	<m164695hqm.fsf@ebiederm.dsl.xmission.com>
	<20070531085556.11649c70.akpm@linux-foundation.org>
Date: Thu, 31 May 2007 10:43:06 -0600
In-Reply-To: <20070531085556.11649c70.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 31 May 2007 08:55:56 -0700")
Message-ID: <m1wsyp2bc5.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/buffer.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c6b58e8..ad9270b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1029,11 +1029,6 @@ failed:
 /*
  * Create buffers for the specified block device block's page.  If
  * that page was dirty, the buffers are set dirty also.
- *
- * Except that's a bug.  Attaching dirty buffers to a dirty
- * blockdev's page can result in filesystem corruption, because
- * some of those buffers may be aliases of filesystem data.
- * grow_dev_page() will go BUG() if this happens.
  */
 static int
 grow_buffers(struct block_device *bdev, sector_t block, int size)
-- 
1.5.1.1.181.g2de0

