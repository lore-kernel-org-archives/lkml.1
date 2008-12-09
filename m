Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYLIJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYLIJW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 04:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYLIJWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 04:22:45 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:45076 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYLIJWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 04:22:45 -0500
Date: Tue, 9 Dec 2008 11:22:42 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, tytso@mit.edu
Subject: ext4 warnings from sparc64
Message-ID: <Pine.SOC.4.64.0812091120020.15776@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got these while compiling todays 2.6.28-7rc+git on sparc64. Debian 
unstable, gcc 4.3.2-1.

  CC [M]  fs/ext4/balloc.o
fs/ext4/balloc.c: In function 'ext4_has_free_blocks':
fs/ext4/balloc.c:617: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
  CC [M]  fs/ext4/bitmap.o
  CC [M]  fs/ext4/dir.o
  CC [M]  fs/ext4/file.o
  CC [M]  fs/ext4/fsync.o
  CC [M]  fs/ext4/ialloc.o
  CC [M]  fs/ext4/inode.o
fs/ext4/inode.c: In function 'ext4_print_free_blocks':
fs/ext4/inode.c:1833: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1835: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
  CC [M]  fs/ext4/ioctl.o
  CC [M]  fs/ext4/namei.o
  CC [M]  fs/ext4/super.o
  CC [M]  fs/ext4/symlink.o
  CC [M]  fs/ext4/hash.o
  CC [M]  fs/ext4/resize.o
  CC [M]  fs/ext4/extents.o
fs/ext4/extents.c: In function 'ext4_ext_search_right':
fs/ext4/extents.c:1120: warning: 'ix' may be used uninitialized in this function


-- 
Meelis Roos (mroos@linux.ee)
