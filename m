Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbXBEObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbXBEObR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbXBEObQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:31:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbXBEObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:31:15 -0500
Subject: [GFS2] Fix typo in glock.c [39/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:39:19 +0000
Message-Id: <1170686359.11001.349.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0eb01c633286ebb80f626846816284f241c15869 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 23 Jan 2007 16:56:36 -0500
Subject: [PATCH] [GFS2] Fix typo in glock.c

This is a one letter typo fix in glock.c, spotted by Rob Kenna.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f68582d..c070ede 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -482,7 +482,7 @@ static int rq_mutex(struct gfs2_holder *gh)
 	list_del_init(&gh->gh_list);
 	/*  gh->gh_error never examined.  */
 	set_bit(GLF_LOCK, &gl->gl_flags);
-	clear_bit(HIF_WAIT, &gh->gh_flags);
+	clear_bit(HIF_WAIT, &gh->gh_iflags);
 	smp_mb();
 	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
 
-- 
1.4.4.2



