Return-Path: <linux-kernel-owner+w=401wt.eu-S1946560AbXBIPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946560AbXBIPgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946562AbXBIPfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946560AbXBIPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kmYAmSRYJrt7t1pAndCYITNCf1vxwC+1jPkb8FSxCu4nU7PfmE6nZVZVJ8f3kLMEx16OzllWjZnIinfi11e76/4mQV8J8bph4SY0ab9UQz9bV0dr5cNSumJ1zKCEqmbWX4TzinNKQHnKOoLJ+ogXCioRlBAoYjWdYdsl1umrwKA=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, viro@zeniv.linux.org.uk
Subject: [PATCH 22/34] __initdata cleanup - fs
Date: Fri, 9 Feb 2007 17:26:53 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091726.53262.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/fs/dcache.c linux-2.6.20-rc6-mm3/fs/dcache.c
--- linux-2.6.20-rc6-mm3.org/fs/dcache.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/fs/dcache.c	2007-01-31 22:19:30.000000000 +0200
@@ -2009,7 +2009,7 @@ ino_t find_inode_number(struct dentry *d
 	return ino;
 }
 
-static __initdata unsigned long dhash_entries;
+static __initdata unsigned long dhash_entries = 0l;
 static int __init set_dhash_entries(char *str)
 {
 	if (!str)
diff -urNp linux-2.6.20-rc6-mm3.org/fs/inode.c linux-2.6.20-rc6-mm3/fs/inode.c
--- linux-2.6.20-rc6-mm3.org/fs/inode.c	2007-01-31 22:15:41.000000000 +0200
+++ linux-2.6.20-rc6-mm3/fs/inode.c	2007-01-31 22:19:30.000000000 +0200
@@ -1355,7 +1355,7 @@ void inode_double_unlock(struct inode *i
 }
 EXPORT_SYMBOL(inode_double_unlock);
 
-static __initdata unsigned long ihash_entries;
+static __initdata unsigned long ihash_entries = 0l;
 static int __init set_ihash_entries(char *str)
 {
 	if (!str)
diff -urNp linux-2.6.20-rc6-mm3.org/fs/nfs/nfsroot.c linux-2.6.20-rc6-mm3/fs/nfs/nfsroot.c
--- linux-2.6.20-rc6-mm3.org/fs/nfs/nfsroot.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/fs/nfs/nfsroot.c	2007-01-31 22:19:30.000000000 +0200
@@ -289,7 +289,7 @@ static int __init root_nfs_parse(char *n
  */
 static int __init root_nfs_name(char *name)
 {
-	static char buf[NFS_MAXPATHLEN] __initdata;
+	static char buf[NFS_MAXPATHLEN] __initdata = { 0, };
 	char *cp;
 
 	/* Set some default values */
