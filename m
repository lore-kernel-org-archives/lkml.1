Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZDMI3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZDMI3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZDMI3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:29:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:46495 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZDMI3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:29:41 -0400
Date: Mon, 13 Apr 2009 17:29:31 +0900 (JST)
Message-Id: <20090413.172931.45933263.ryusuke@osrg.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp
Subject: Pull request for nilfs2 tree
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Apr 2009 17:29:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi dear Stephen,

Could you consider pulling the for-next branch of this tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git

into linux-next, please?

This branch now includes some bug-fixes of the nilfs2 file system
Linus merged in kenrel 2.6.30-rc1.

This series should be sent to Linus at an early stage, but I'd like to
have it tested on the -next tree before that.

Regards,
Ryusuke Konishi
---
The following changes since commit b0cbc861a3c05e634520b049b5cc27ad6febb51f:
 Linus Torvalds (1):
     Revert "ACPI battery: fix async boot oops"

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-next

Ryusuke Konishi (8):
      nilfs2: return f_fsid for statfs2
      nilfs2: fix lockdep recursive locking warning on bmap
      nilfs2: fix lockdep recursive locking warning on meta data files
      nilfs2: remove module version
      nilfs2: simplify handling of active state of segments fix
      nilfs2: fix wrong accounting and duplicate brelse in nilfs_sufile_set_error
      nilfs2: segment usage file cleanups
      nilfs2: fix possible mismatch of sufile counters on recovery


 fs/nilfs2/bmap.c      |    5 +
 fs/nilfs2/nilfs.h     |    5 -
 fs/nilfs2/recovery.c  |   20 +---
 fs/nilfs2/sufile.c    |  290 ++++++++++++++++++-------------------------------
 fs/nilfs2/sufile.h    |   79 +++++++++++++-
 fs/nilfs2/super.c     |    7 +-
 fs/nilfs2/the_nilfs.c |    4 +
 7 files changed, 197 insertions(+), 213 deletions(-)
