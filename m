Return-Path: <linux-kernel-owner+w=401wt.eu-S2992855AbXBQR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992855AbXBQR3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992857AbXBQR3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:29:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:55421 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992855AbXBQR3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:29:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=S99RuCyBqPrhyyeoWqg0wg30dz2ITP+1oahqnA5FX7roVPpGJ7fN3zS+j22Mpi8pVRWBNkqYla6tvrx3jvl8C8DNOL6ZT3t9gqsrsARDuaB7Q/gR2pHgYVnat6/HrGfc8UeZS/6ChwDWDXg7T6RgYfa7spUgqrk+llPngxg6ue8=
Message-ID: <45D73B6B.1030406@gmail.com>
Date: Sat, 17 Feb 2007 17:29:15 +0000
From: Richard Fearn <richardfearn@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: swhiteho@redhat.com
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 2.6.20] gfs2: add newline to printk message
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch for the 2.6.20 stable tree that adds a missing newline to one of
the printk messages in fs/gfs2/ops_fstype.c.

Signed-off-by: Richard Fearn <richardfearn@gmail.com>

diff -uprN 2.6.20/fs/gfs2/ops_fstype.c new/fs/gfs2/ops_fstype.c
--- 2.6.20/fs/gfs2/ops_fstype.c	2007-02-04 18:44:54.000000000 +0000
+++ new/fs/gfs2/ops_fstype.c	2007-02-17 15:36:45.000000000 +0000
@@ -840,7 +840,7 @@ static struct super_block* get_gfs2_sb(c
 	}

 	printk(KERN_WARNING "GFS2: Unrecognized block device or "
-	       "mount point %s", dev_name);
+	       "mount point %s\n", dev_name);

 free_nd:
 	path_release(&nd);


