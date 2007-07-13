Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbXGMK0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbXGMK0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 06:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbXGMK0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 06:26:15 -0400
Received: from mail.macqel.be ([194.78.208.39]:17051 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXGMK0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 06:26:14 -0400
Date: Fri, 13 Jul 2007 12:26:10 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fs : mark nibblemap const
Message-ID: <20070713102610.GA16087@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Mark nibblemap const

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 6c0a10cc415a fs/affs/bitmap.c
--- a/fs/affs/bitmap.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/fs/affs/bitmap.c	Fri Jul 13 12:21:14 2007 +0200
@@ -11,7 +11,7 @@
 
 /* This is, of course, shamelessly stolen from fs/minix */
 
-static int nibblemap[] = { 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4 };
+static const int nibblemap[] = { 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4 };
 
 static u32
 affs_count_free_bits(u32 blocksize, const void *data)
diff -r 6c0a10cc415a fs/ext2/balloc.c
--- a/fs/ext2/balloc.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/fs/ext2/balloc.c	Fri Jul 13 12:21:14 2007 +0200
@@ -522,7 +522,7 @@ io_error:
 
 #ifdef EXT2FS_DEBUG
 
-static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
+static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
 unsigned long ext2_count_free (struct buffer_head * map, unsigned int numchars)
 {
diff -r 6c0a10cc415a fs/ext3/bitmap.c
--- a/fs/ext3/bitmap.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/fs/ext3/bitmap.c	Fri Jul 13 12:21:14 2007 +0200
@@ -13,7 +13,7 @@
 
 #ifdef EXT3FS_DEBUG
 
-static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
+static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
 unsigned long ext3_count_free (struct buffer_head * map, unsigned int numchars)
 {
diff -r 6c0a10cc415a fs/ext4/bitmap.c
--- a/fs/ext4/bitmap.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/fs/ext4/bitmap.c	Fri Jul 13 12:21:14 2007 +0200
@@ -13,7 +13,7 @@
 
 #ifdef EXT4FS_DEBUG
 
-static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
+static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
 unsigned long ext4_count_free (struct buffer_head * map, unsigned int numchars)
 {
diff -r 6c0a10cc415a fs/minix/bitmap.c
--- a/fs/minix/bitmap.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/fs/minix/bitmap.c	Fri Jul 13 12:21:14 2007 +0200
@@ -17,7 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/sched.h>
 
-static int nibblemap[] = { 4,3,3,2,3,2,2,1,3,2,2,1,2,1,1,0 };
+static const int nibblemap[] = { 4,3,3,2,3,2,2,1,3,2,2,1,2,1,1,0 };
 
 static unsigned long count_free(struct buffer_head *map[], unsigned numblocks, __u32 numbits)
 {
