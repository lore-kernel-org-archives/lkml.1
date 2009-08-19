Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZHSPNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZHSPNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZHSPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:12:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:57619 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZHSPM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:12:59 -0400
Date: Thu, 20 Aug 2009 00:12:23 +0900 (JST)
Message-Id: <20090820.001223.91943640.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 bug-fixes for 2.6.31-rc7
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 20 Aug 2009 00:12:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

nilfs tree has two small fixes.  One will fix an -rc1 regression
causing kernel oopses and memory leak, and the other adds missing lock
operations.

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive

the following changes since commit 64f1607ffbbc772685733ea63e6f7f4183df1b16
 Linus Torvalds (1):
      Linux 2.6.31-rc6

Ryusuke Konishi (1):
      nilfs2: fix oopses with doubly mounted snapshots

Zhang Qiang (1):
      nilfs2: missing a read lock for segment writer in nilfs_attach_checkpoint()

 fs/nilfs2/super.c     |    2 ++
 fs/nilfs2/the_nilfs.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)
--

Thanks,
Ryusuke Konishi
