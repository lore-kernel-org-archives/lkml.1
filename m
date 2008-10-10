Return-Path: <linux-kernel-owner+w=401wt.eu-S1762821AbYJJT0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbYJJT0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbYJJTZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:25:58 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:58001 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758490AbYJJTZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:25:57 -0400
Date: Fri, 10 Oct 2008 21:25:53 +0200
From: FD Cami <francois.cami@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Alex Howells <alex@bytemark.co.uk>,
       Nick Warne <nick@ukfsn.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Li Yang <leoli@freescale.com>
Subject: [PATCH] Remove Andrew Morton's old email accounts
Message-ID: <20081010212553.4c80d595@moria>
In-Reply-To: <20081010111031.9518a142.akpm@linux-foundation.org>
References: <20081010151539.6a2ff040@sauron.linicks.net>
	<48EF6B47.1080800@bytemark.co.uk>
	<20081010093427.31ddb955.randy.dunlap@oracle.com>
	<20081010192600.547eedcc@moria>
	<20081010111031.9518a142.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 11:10:31 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 10 Oct 2008 19:26:00 +0200 FD Cami <francois.cami@free.fr> wrote:
> 
> > Also, should we change all instances of your old email addresses to the current one ?
> 
> If they're there, please just delete any email address.  People can use
> the real name an an index into MAINTAINERS to find the current email
> address.

Remove Andrew Morton's email addresses.
There is still one akpm@osdl.org living in linux-2.6.27/Documentation/zh_CN/SubmittingDrivers
but I am not sure how not to break this file. Li Yang CC'ed for this reason.

Should we think about systematically removing maintainers' email addresses from the code and documentation ?

Signed-off-by: Francois Cami <francois.cami@free.fr>


diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/networking/cs89x0.txt linux-2.6.27-mine/Documentation/networking/cs89x0.txt
--- linux-2.6.27/Documentation/networking/cs89x0.txt	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/networking/cs89x0.txt	2008-10-10 21:08:03.000000000 +0200
@@ -690,7 +690,7 @@ latest drivers and technical publication
 6.4 Current maintainer
 
 In February 2000 the maintenance of this driver was assumed by Andrew
-Morton <akpm@zip.com.au>
+Morton.
 
 6.5 Kernel module parameters
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/networking/vortex.txt linux-2.6.27-mine/Documentation/networking/vortex.txt
--- linux-2.6.27/Documentation/networking/vortex.txt	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/networking/vortex.txt	2008-10-10 21:07:39.000000000 +0200
@@ -11,7 +11,7 @@ The driver was written by Donald Becker 
 Don is no longer the prime maintainer of this version of the driver. 
 Please report problems to one or more of:
 
-  Andrew Morton <akpm@osdl.org>
+  Andrew Morton
   Netdev mailing list <netdev@vger.kernel.org>
   Linux kernel mailing list <linux-kernel@vger.kernel.org>
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/SAK.txt linux-2.6.27-mine/Documentation/SAK.txt
--- linux-2.6.27/Documentation/SAK.txt	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/SAK.txt	2008-10-10 21:06:31.000000000 +0200
@@ -1,5 +1,5 @@
 Linux 2.4.2 Secure Attention Key (SAK) handling
-18 March 2001, Andrew Morton <akpm@osdl.org>
+18 March 2001, Andrew Morton
 
 An operating system's Secure Attention Key is a security tool which is
 provided as protection against trojan password capturing programs.  It
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/scsi/ChangeLog.megaraid linux-2.6.27-mine/Documentation/scsi/ChangeLog.megaraid
--- linux-2.6.27/Documentation/scsi/ChangeLog.megaraid	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/scsi/ChangeLog.megaraid	2008-10-10 21:06:58.000000000 +0200
@@ -409,7 +409,7 @@ i.	Function reordering so that inline fu
 	megaraid_mbox_prepare_pthru, megaraid_mbox_prepare_epthru,
 	megaraid_busywait_mbox
 
-		- Andrew Morton <akpm@osdl.org>, 08.19.2004
+		- Andrew Morton, 08.19.2004
 		linux-scsi mailing list
 
 	"Something else to clean up after inclusion: every instance of an
@@ -471,13 +471,13 @@ vi.	Add support for 64-bit applications.
 vii.	Move the function declarations for the management module from
 	megaraid_mm.h to megaraid_mm.c
 
-		- Andrew Morton <akpm@osdl.org>, 08.19.2004
+		- Andrew Morton, 08.19.2004
 		linux-scsi mailing list
 
 viii.	Change default values for MEGARAID_NEWGEN, MEGARAID_MM, and
 	MEGARAID_MAILBOX to 'n' in Kconfig.megaraid
 
-		- Andrew Morton <akpm@osdl.org>, 08.19.2004
+		- Andrew Morton, 08.19.2004
 		linux-scsi mailing list
 
 ix.	replace udelay with msleep
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/Documentation/SubmittingDrivers linux-2.6.27-mine/Documentation/SubmittingDrivers
--- linux-2.6.27/Documentation/SubmittingDrivers	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/Documentation/SubmittingDrivers	2008-10-10 21:06:17.000000000 +0200
@@ -41,7 +41,7 @@ Linux 2.4:
 Linux 2.6:
 	The same rules apply as 2.4 except that you should follow linux-kernel
 	to track changes in API's. The final contact point for Linux 2.6
-	submissions is Andrew Morton <akpm@osdl.org>.
+	submissions is Andrew Morton.
 
 What Criteria Determine Acceptance
 ----------------------------------
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/fs/direct-io.c linux-2.6.27-mine/fs/direct-io.c
--- linux-2.6.27/fs/direct-io.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/fs/direct-io.c	2008-10-10 21:11:30.000000000 +0200
@@ -5,11 +5,11 @@
  *
  * O_DIRECT
  *
- * 04Jul2002	akpm@zip.com.au
+ * 04Jul2002	Andrew Morton
  *		Initial version
  * 11Sep2002	janetinc@us.ibm.com
  * 		added readv/writev support.
- * 29Oct2002	akpm@zip.com.au
+ * 29Oct2002	Andrew Morton
  *		rewrote bio_add_page() support.
  * 30Oct2002	pbadari@us.ibm.com
  *		added support for non-aligned IO.
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/fs/fs-writeback.c linux-2.6.27-mine/fs/fs-writeback.c
--- linux-2.6.27/fs/fs-writeback.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/fs/fs-writeback.c	2008-10-10 21:10:51.000000000 +0200
@@ -8,7 +8,7 @@
  * pages against inodes.  ie: data writeback.  Writeout of the
  * inode itself is not handled here.
  *
- * 10Apr2002	akpm@zip.com.au
+ * 10Apr2002	Andrew Morton
  *		Split out of fs/inode.c
  *		Additions for address_space-based writeback
  */
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/fs/mpage.c linux-2.6.27-mine/fs/mpage.c
--- linux-2.6.27/fs/mpage.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/fs/mpage.c	2008-10-10 21:11:45.000000000 +0200
@@ -6,7 +6,7 @@
  * Contains functions related to preparing and submitting BIOs which contain
  * multiple pagecache pages.
  *
- * 15May2002	akpm@zip.com.au
+ * 15May2002	Andrew Morton
  *		Initial version
  * 27Jun2002	axboe@suse.de
  *		use bio_add_page() to build bio's just the right size
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/include/linux/journal-head.h linux-2.6.27-mine/include/linux/journal-head.h
--- linux-2.6.27/include/linux/journal-head.h	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/include/linux/journal-head.h	2008-10-10 21:05:26.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * buffer_head fields for JBD
  *
- * 27 May 2001 Andrew Morton <akpm@digeo.com>
+ * 27 May 2001 Andrew Morton
  *	Created - pulled out of fs.h
  */
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/include/linux/task_io_accounting.h linux-2.6.27-mine/include/linux/task_io_accounting.h
--- linux-2.6.27/include/linux/task_io_accounting.h	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/include/linux/task_io_accounting.h	2008-10-10 21:05:47.000000000 +0200
@@ -5,7 +5,7 @@
  * Don't include this header file directly - it is designed to be dragged in via
  * sched.h.
  *
- * Blame akpm@osdl.org for all this.
+ * Blame Andrew Morton for all this.
  */
 
 struct task_io_accounting {
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/mm/fadvise.c linux-2.6.27-mine/mm/fadvise.c
--- linux-2.6.27/mm/fadvise.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/mm/fadvise.c	2008-10-10 21:09:34.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds
  *
- * 11Jan2003	akpm@digeo.com
+ * 11Jan2003	Andrew Morton
  *		Initial version.
  */
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/mm/page-writeback.c linux-2.6.27-mine/mm/page-writeback.c
--- linux-2.6.27/mm/page-writeback.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/mm/page-writeback.c	2008-10-10 21:10:06.000000000 +0200
@@ -7,7 +7,7 @@
  * Contains functions related to writing back dirty pages at the
  * address_space level.
  *
- * 10Apr2002	akpm@zip.com.au
+ * 10Apr2002	Andrew Morton
  *		Initial version
  */
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/mm/pdflush.c linux-2.6.27-mine/mm/pdflush.c
--- linux-2.6.27/mm/pdflush.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/mm/pdflush.c	2008-10-10 21:09:50.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds.
  *
- * 09Apr2002	akpm@zip.com.au
+ * 09Apr2002	Andrew Morton
  *		Initial version
  * 29Feb2004	kaos@sgi.com
  *		Move worker thread creation to kthread to avoid chewing
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/mm/readahead.c linux-2.6.27-mine/mm/readahead.c
--- linux-2.6.27/mm/readahead.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/mm/readahead.c	2008-10-10 21:10:24.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds
  *
- * 09Apr2002	akpm@zip.com.au
+ * 09Apr2002	Andrew Morton
  *		Initial version.
  */
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27/mm/truncate.c linux-2.6.27-mine/mm/truncate.c
--- linux-2.6.27/mm/truncate.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-mine/mm/truncate.c	2008-10-10 21:10:36.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds
  *
- * 10Sep2002	akpm@zip.com.au
+ * 10Sep2002	Andrew Morton
  *		Initial version.
  */
 
