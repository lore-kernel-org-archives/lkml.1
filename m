Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbXE3Gn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbXE3Gn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 02:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXE3GnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 02:43:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52974 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXE3GnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 02:43:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 30 May 2007 08:41:56 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] FILESYSTEMS: Delete unused "int dummy[5]" from
 inodes_stat_t.
To: linux-kernel@vger.kernel.org
cc: Josh Boyer <jwboyer@gmail.com>, "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20070529123326.a8a1bd64.randy.dunlap@oracle.com>
Message-ID: <tkrat.2eccbb76ef1aee06@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
 <20070529110041.49bf57f1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain>
 <20070529111902.27055fd0.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain>
 <465C71EA.5040706@oracle.com>
 <625fc13d0705291144u1aef3b6dx4b00873f3d05b652@mail.gmail.com>
 <20070529123326.a8a1bd64.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: fs: clarify "dummy" member in struct inodes_stat_t

Found by Robert P. J. Day:  The role of inodes_stat_t.dummy wasn't clear
and one might be tempted to remove it.  Give it a better name and add a
comment.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Only quickly compile-tested.

Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -44,7 +44,7 @@ extern int get_max_files(void);
 struct inodes_stat_t {
 	int nr_inodes;
 	int nr_unused;
-	int dummy[5];
+	int reserved[5];	/* for sysctl and procfs ABI compatibility */
 };
 extern struct inodes_stat_t inodes_stat;
 

-- 
Stefan Richter
-=====-=-=== -=-= ====-
http://arcgraph.de/sr/

