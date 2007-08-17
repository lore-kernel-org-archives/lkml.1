Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbXHRAom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbXHRAom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760230AbXHRAm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:42:56 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:57752 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759650AbXHRAmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:42:55 -0400
Date: Fri, 17 Aug 2007 15:43:42 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Joe Perches <joe@perches.com>, Satyam Sharma <satyam@infradead.org>
Subject: [PATCH 5/6] UML - Remove unneeded if from hostfs
Message-ID: <20070817194342.GA8744@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of an empty if statement which might look like a bug to a
casual reader.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 fs/hostfs/hostfs_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/fs/hostfs/hostfs_user.c
===================================================================
--- linux-2.6.22.orig/fs/hostfs/hostfs_user.c	2007-08-17 13:36:34.000000000 -0400
+++ linux-2.6.22/fs/hostfs/hostfs_user.c	2007-08-17 13:37:45.000000000 -0400
@@ -283,7 +283,7 @@ int set_attr(const char *file, struct ho
 		}
 	}
 
-	if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
+	/* Note: ctime is not handled */
 	if(attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)){
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
 				&attrs->ia_atime, &attrs->ia_mtime, NULL,
