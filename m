Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZIIUgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZIIUgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZIIUgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:36:23 -0400
Received: from kroah.org ([198.145.64.141]:36239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbZIIUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:36:15 -0400
Date: Wed, 9 Sep 2009 13:34:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.33
Message-ID: <20090909203410.GA31685@kroah.com>
References: <20090909203337.GA31676@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909203337.GA31676@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 00dc0ee..1b2c0fb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .32
+EXTRAVERSION = .33
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 0f04b70..4039637 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1234,6 +1234,7 @@ out:
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
 			       u32 phys, unsigned int unwritten,
+			       unsigned int should_zero,
 			       struct ocfs2_alloc_context *data_ac,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct ocfs2_write_ctxt *wc, u32 cpos,
