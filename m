Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbXE3TDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbXE3TDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbXE3TDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:03:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39119 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbXE3TDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:03:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 30 May 2007 21:01:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [trivial PATCH, updated] fs: clarify "dummy" member in struct
 inodes_stat_t
To: trivial@kernel.org
cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Josh Boyer <jwboyer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
In-Reply-To: <Pine.LNX.4.64.0705300733200.12382@localhost.localdomain>
Message-ID: <tkrat.691ed5f2041a2996@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
 <20070529110041.49bf57f1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain>
 <20070529111902.27055fd0.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain>
 <465C71EA.5040706@oracle.com>
 <625fc13d0705291144u1aef3b6dx4b00873f3d05b652@mail.gmail.com>
 <20070529123326.a8a1bd64.randy.dunlap@oracle.com>
 <tkrat.2eccbb76ef1aee06@s5r6.in-berlin.de> <20070530112946.GT3899@stusta.de>
 <Pine.LNX.4.64.0705300733200.12382@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May, Robert P. J. Day wrote:
> On Wed, 30 May 2007, Adrian Bunk wrote:
>> Considering that we export this struct to usespace, I don't think
>> renaming a member without a good reason is a good idea (but adding a
>> comment makes sense).
[...]
> i thought i was submitting a fairly innocuous patch.  live and learn.

I've could have seen that it is defined outside #ifdef __KERNEL__.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: fs: clarify "dummy" member in struct inodes_stat_t

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -44,7 +44,7 @@ extern int get_max_files(void);
 struct inodes_stat_t {
 	int nr_inodes;
 	int nr_unused;
-	int dummy[5];
+	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 extern struct inodes_stat_t inodes_stat;
 

-- 
Stefan Richter
-=====-=-=== -=-= ====-
http://arcgraph.de/sr/

