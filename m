Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZKCHtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZKCHtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZKCHtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:49:09 -0500
Received: from sh.osrg.net ([192.16.179.4]:44067 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbZKCHtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:49:08 -0500
Date: Tue, 03 Nov 2009 16:49:07 +0900 (JST)
Message-Id: <20091103.164907.79138608.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.32-rc6
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 03 Nov 2009 16:49:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull bug fixes of nilfs from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Containing a nontrivial fix to solve reported hang issue on ARM-based
targets.  The other two fix an issue on checkpoint creation in small
footprint systems and missing buffer initialization, respectively.

--
The following changes since commit 1836d95928a0f41ada0cbb2a6c4e46b027db9491:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ericvh/v9fs

Ryusuke Konishi (3):
      nilfs2: fix dirty page accounting leak causing hang at write
      nilfs2: fix irregular checkpoint creation due to data flush
      nilfs2: add zero-fill for new btree node buffers

 fs/nilfs2/btnode.c  |    4 ++--
 fs/nilfs2/segment.c |   19 ++++++++++++-------
 2 files changed, 14 insertions(+), 9 deletions(-)


Thanks,
Ryusuke Konishi
