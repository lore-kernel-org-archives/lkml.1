Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXBBJyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXBBJyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 04:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXBBJyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 04:54:54 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:59536 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXBBJyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 04:54:53 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 2 Feb 2007 04:53:34 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, swhiteho@redhat.com
Subject: [PATCH] GFS2: Fix incorrect macro name "NR_CPUS" in glock.c.
Message-ID: <Pine.LNX.4.64.0702020451250.12632@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Rename the incorrect macro name "NR_CPUS" to "CONFIG_NR_CPUS".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 4381469..e6bf4b9 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -70,13 +70,13 @@ static struct gfs2_gl_hash_bucket gl_hash_table[GFS2_GL_HASH_SIZE];
 #ifdef CONFIG_LOCKDEP
 # define GL_HASH_LOCK_SZ        256
 #else
-# if NR_CPUS >= 32
+# if CONFIG_NR_CPUS >= 32
 #  define GL_HASH_LOCK_SZ       4096
-# elif NR_CPUS >= 16
+# elif CONFIG_NR_CPUS >= 16
 #  define GL_HASH_LOCK_SZ       2048
-# elif NR_CPUS >= 8
+# elif CONFIG_NR_CPUS >= 8
 #  define GL_HASH_LOCK_SZ       1024
-# elif NR_CPUS >= 4
+# elif CONFIG_NR_CPUS >= 4
 #  define GL_HASH_LOCK_SZ       512
 # else
 #  define GL_HASH_LOCK_SZ       256

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
