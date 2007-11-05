Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbXKELYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbXKELYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXKELX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:23:57 -0500
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:4005 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014AbXKELX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:23:56 -0500
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2007 06:23:56 EST
Message-ID: <472EFACA.1090308@lougher.demon.co.uk>
Date: Mon, 05 Nov 2007 11:13:14 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [ANN] Squashfs 3.3 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm pleased to announce another release of Squashfs.  This is the 22nd
release in just over five years.  Squashfs 3.3 has lots of nice improvements,
both to the filesystem itself (bigger blocks and sparse files), but
also to the Squashfs-tools Mksquashfs and Unsquashfs.

The next stage after this release is to fix the one remaining blocking issue
(filesystem endianness), and then try to get Squashfs mainlined into the
Linux kernel again.

The list of changes from the change-log are as follows:

1. Filesystem improvements:

    1.1. Maximum block size has been increased to 1Mbyte, and the
         default block size has been increased to 128 Kbytes.
         This improves compression.

    1.2. Sparse files are now supported.  Sparse files are files
         which have large areas of unallocated data commonly called
         holes.  These files are now detected by Squashfs and stored
         more efficiently.  This improves compression and read
         performance for sparse files.

2. Mksquashfs improvements:

    2.1.  Exclude files have been extended to use wildcard pattern
          matching and regular expressions.  Support has also been
          added for non-anchored excludes, which means it is
          now possible to specify excludes which match anywhere
          in the filesystem (i.e. leaf files), rather than always
          having to specify exclude files starting from the root
          directory (anchored excludes).

    2.2.  Recovery files are now created when appending to existing
          Squashfs filesystems.  This allows the original filesystem
          to be recovered if Mksquashfs aborts unexpectedly
          (i.e. power failure).

3. Unsquashfs improvements:

     3.1. Multiple extract files can now be specified on the
          command line, and the files/directories to be extracted can
          now also be given in a file.

     3.2. Extract files have been extended to use wildcard pattern
          matching and regular expressions.

     3.3. Filename printing has been enhanced and Unquashfs can
          now display filenames with file attributes
          ('ls -l' style output).

     3.4. A -stat option has been added which displays the filesystem
          superblock information.

     3.5. Unsquashfs now supports 1.x filesystems.

4. Miscellaneous improvements/bug fixes:

    4.1. Squashfs kernel code improved to use SetPageError in
         squashfs_readpage() if I/O error occurs.

    4.2. Fixed Squashfs kernel code bug preventing file
         seeking beyond 2GB.

    4.3. Mksquashfs now detects file size changes between
         first phase directory scan and second phase filesystem create.

Regards

Phillip Lougher
