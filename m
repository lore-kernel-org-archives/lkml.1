Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZI3NDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZI3NDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZI3NDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:03:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:33780 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZI3NDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:03:52 -0400
Date: Wed, 30 Sep 2009 22:03:49 +0900 (JST)
Message-Id: <20090930.220349.126057646.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 30 Sep 2009 22:03:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nilfs tree has the following two corrections.

One of the two is an important fix which solves reported file system
corruption infrequently triggered by garbage collection.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive

the following changes since commit 17d857be649a21ca90008c6dc425d849fa83db5c:
  Linus Torvalds (1):
        Linux 2.6.32-rc1

Ryusuke Konishi (2):
      nilfs2: fix missing zero-fill initialization of btree node cache
      nilfs2: fix missing initialization of i_dir_start_lookup member

 fs/nilfs2/btnode.c |    1 +
 fs/nilfs2/inode.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

Thanks,
Ryusuke Konishi
