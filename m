Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZGJQsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZGJQsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZGJQsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:48:02 -0400
Received: from sh.osrg.net ([192.16.179.4]:36544 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZGJQsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:48:00 -0400
Date: Sat, 11 Jul 2009 01:47:23 +0900 (JST)
Message-Id: <20090711.014723.132733323.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.31-rc3
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 11 Jul 2009 01:47:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull bug-fixes of nilfs from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

The following changes since commit 8e4a718ff38d8539938ec3421935904c27e00c39
 Linus Torvalds (1):
      Linux 2.6.31-rc2

Jiro SEKIBA (1):
      nilfs2: fix disorder in cp count on error during deleting checkpoints

Ryusuke Konishi (4):
      nilfs2: remove unlikely directive causing mis-conversion of error code
      nilfs2: fix hang problem of log writer which occurs after write failures
      nilfs2: fix incorrect KERN_CRIT messages in case of write failures
      nilfs2: fix lockdep warning between regular file and inode file

 fs/nilfs2/bmap.c    |    5 +++++
 fs/nilfs2/cpfile.c  |    5 ++---
 fs/nilfs2/dat.c     |    9 ---------
 fs/nilfs2/segment.c |   30 ++++++++----------------------
 4 files changed, 15 insertions(+), 34 deletions(-)
--

The "nilfs2: fix disorder in cp count on error during deleting
checkpoints" fixes a bug on error path which throws off checkpoint
count on disk.

The "nilfs2: fix hang problem of log writer which occurs after write
failures" fixes a reported hang problem.

The "nilfs2: remove unlikely directive causing mis-conversion of error code",
and "nilfs2: fix incorrect KERN_CRIT messages in case of write failures"
fix the related bugs.

The "nilfs2: fix lockdep warning between regular file and inode file"
fixes a false positive of lockdep check.

Thanks,
Ryusuke Konishi
