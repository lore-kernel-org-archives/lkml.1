Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbXGaJhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbXGaJhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbXGaJhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:37:46 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:43444 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbXGaJho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:37:44 -0400
X-Greylist: delayed 1413 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 05:37:44 EDT
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] documentation fixes
Date: Tue, 31 Jul 2007 11:14:09 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311114.09308.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

here are some small documentation fixes - mostly typing errors.

Please take a look at the last chunk - I think that klibc.bkbits.net 
is no longer the current version, but I'm not sure whether the 
other link is better.


Whom should I CC for other documentation updates? Is the maintainer 
the correct person, or are such small fixes "send and forget"?


Regards,

Phil



diff -ur linux-2.6.21.1-orig/Documentation/early-userspace/buffer-format.txt linux-2.6.21.1/Documentation/early-userspace/buffer-format.txt
--- linux-2.6.21.1-orig/Documentation/early-userspace/buffer-format.txt	2007-04-27 23:49:26.000000000 +0200
+++ linux-2.6.21.1/Documentation/early-userspace/buffer-format.txt	2007-07-30 07:22:24.000000000 +0200
@@ -6,8 +6,8 @@
 
 Starting with kernel 2.5.x, the old "initial ramdisk" protocol is
 getting {replaced/complemented} with the new "initial ramfs"
-(initramfs) protocol.  The initramfs contents is passed using the same
-memory buffer protocol used by the initrd protocol, but the contents
+(initramfs) protocol.  The initramfs is passed using the same
+memory buffer protocol used by the initrd protocol, but the content
 is different.  The initramfs buffer contains an archive which is
 expanded into a ramfs filesystem; this document details the format of
 the initramfs buffer format.
@@ -38,7 +38,7 @@
 
 In human terms, the initramfs buffer contains a collection of
 compressed and/or uncompressed cpio archives (in the "newc" or "crc"
-formats); arbitrary amounts zero bytes (for padding) can be added
+formats); arbitrary amounts of zero bytes (for padding) can be added
 between members.
 
 The cpio "TRAILER!!!" entry (cpio end-of-archive) is optional, but is
diff -ur linux-2.6.21.1-orig/Documentation/early-userspace/README linux-2.6.21.1/Documentation/early-userspace/README
--- linux-2.6.21.1-orig/Documentation/early-userspace/README	2007-04-27 23:49:26.000000000 +0200
+++ linux-2.6.21.1/Documentation/early-userspace/README	2007-07-30 07:18:48.000000000 +0200
@@ -44,7 +44,7 @@
 CONFIG_INITRAMFS_SOURCE.  Sources can be either directories or files -
 cpio archives are *not* allowed when building from sources.
 
-A source directory will have it and all of it's contents packaged.  The
+A source directory will have it and all of its contents packaged.  The
 specified directory name will be mapped to '/'.  When packaging a
 directory, limited user and group ID translation can be performed.
 INITRAMFS_ROOT_UID can be set to a user ID that needs to be mapped to
@@ -56,7 +56,7 @@
 file format).  The directives in the file will be passed directly to
 usr/gen_init_cpio.
 
-When a combination of directories and files are specified then the
+When a combination of directories and files are specified, the
 initramfs image will be an aggregate of all of them.  In this way a user
 can create a 'root-image' directory and install all files into it.
 Because device-special files cannot be created by a unprivileged user,
@@ -71,7 +71,7 @@
 gen_initramfs_list.sh.  If a directory is specified as an argument then
 the contents are scanned, uid/gid translation is performed, and
 usr/gen_init_cpio file directives are output.  If a directory is
-specified as an arugemnt to scripts/gen_initramfs_list.sh then the
+specified as an argument to scripts/gen_initramfs_list.sh the
 contents of the file are simply copied to the output.  All of the output
 directives from directory scanning and file contents copying are
 processed by usr/gen_init_cpio.
@@ -91,6 +91,6 @@
 
-For active users, you are better off using the klibc BitKeeper
-repositories, at http://klibc.bkbits.net/
+For active users, you are better off using the snapshots at
+ftp://ftp.kernel.org/pub/linux/libs/klibc/
 
 The standalone klibc distribution currently provides three components,
 in addition to the klibc library:


