Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbYG3NJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbYG3NJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbYG3NJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:09:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57674 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbYG3NJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:09:17 -0400
Message-Id: <20080730130912.754906666@szeredi.hu>
References: <20080730130845.905327725@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 30 Jul 2008 15:08:46 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 1/4] splice: fix comment
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
--- linux-2.6.orig/fs/splice.c	2008-07-30 13:52:35.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-07-30 13:52:40.000000000 +0200
@@ -987,7 +987,7 @@ ssize_t splice_direct_to_actor(struct fi
 	flags = sd->flags;
 
 	/*
-	 * Don't block on output, we have to drain the direct pipe.
+	 * Block on output, we have to drain the direct pipe.
 	 */
 	sd->flags &= ~SPLICE_F_NONBLOCK;
 

--
