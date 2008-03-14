Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYCNNLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYCNNLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYCNNLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:11:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYCNNLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:11:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, akpm@linux-foundation.org, hch@lst.de
cc: dhowells@redhat.com, "Marc Dionne" <marc.c.dionne@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] struct export_operations: adjust comments to match current members
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 14 Mar 2008 13:11:29 +0000
Message-ID: <22062.1205500289@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Marc Dionne" <marc.c.dionne@gmail.com>

The comments in the definition of struct export_operations don't match the
current members.

Add a comment for the 2 new functions and remove 2 comments for unused ones.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 include/linux/exportfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 51d2141..adcbb05 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -49,11 +49,11 @@ struct fid {

 /**
  * struct export_operations - for nfsd to communicate with file systems
- * @decode_fh:      decode a file handle fragment and return a &struct dentry
  * @encode_fh:      encode a file handle fragment from a dentry
+ * @fh_to_dentry:   find the implied object and get a dentry for it
+ * @fh_to_parent:   find the implied object's parent and get a dentry for it
  * @get_name:       find the name for a given inode in a given directory
  * @get_parent:     find the parent of a given directory
- * @get_dentry:     find a dentry for the inode given a file handle
sub-fragment
  *
  * See Documentation/filesystems/Exporting for details on how to use
  * this interface correctly.
