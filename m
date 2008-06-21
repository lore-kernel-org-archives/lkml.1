Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYFUPtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYFUPtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYFUPsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:48:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48612 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYFUPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:47:34 -0400
Message-Id: <20080621154722.879182964@szeredi.hu>
References: <20080621154607.154640724@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jun 2008 17:46:08 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
Subject: [rfc patch 1/4] splice: fix comment
Content-Disposition: inline; filename=splice_fix_comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clearing SPLICE_F_NONBLOCK means: block.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2008-06-19 14:58:10.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-06-20 13:12:37.000000000 +0200
@@ -978,7 +978,7 @@ ssize_t splice_direct_to_actor(struct fi
 	flags = sd->flags;
 
 	/*
-	 * Don't block on output, we have to drain the direct pipe.
+	 * Block on output, we have to drain the direct pipe.
 	 */
 	sd->flags &= ~SPLICE_F_NONBLOCK;
 

--
