Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab0BYQPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:15:47 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:60700 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932705Ab0BYQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:15:46 -0500
Date: Thu, 25 Feb 2010 16:16:50 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: phillip.lougher@gmail.com
Subject: [PATCH 3/3] Squashfs: update Kconfig help to include lzma support
Message-ID: <4b86a272.w0VvRKh/v4WG+UlQ%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also cleanup some whitespace.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/Kconfig |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 7ec5d7e..d7070ed 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -5,13 +5,13 @@ config SQUASHFS
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
 	  Read-Only File System).  Squashfs is a highly compressed read-only
-	  filesystem for Linux.  It uses zlib compression to compress both
-	  files, inodes and directories.  Inodes in the system are very small
-	  and all blocks are packed to minimise data overhead. Block sizes
-	  greater than 4K are supported up to a maximum of 1 Mbytes (default
-	  block size 128K).  SquashFS 4.0 supports 64 bit filesystems and files
-	  (larger than 4GB), full uid/gid information, hard links and
-	  timestamps.  
+	  filesystem for Linux.  It uses zlib or lzma compression to compress
+	  both files, inodes and directories.  Inodes in the system are very
+	  small and all blocks are packed to minimise data overhead. Block
+	  sizes greater than 4K are supported up to a maximum of 1 Mbytes
+	  (default block size 128K).  SquashFS 4.0 supports 64 bit filesystems
+	  and files (larger than 4GB), full uid/gid information, hard links and
+	  timestamps.
 
 	  Squashfs is intended for general read-only filesystem use, for
 	  archival use (i.e. in cases where a .tar.gz file may be used), and in
@@ -33,8 +33,7 @@ config SQUASHFS_LZMA
 	select DECOMPRESS_LZMA_NEEDED
 
 config SQUASHFS_EMBEDDED
-
-	bool "Additional option for memory-constrained systems" 
+	bool "Additional option for memory-constrained systems"
 	depends on SQUASHFS
 	default n
 	help
-- 
1.6.3.3

