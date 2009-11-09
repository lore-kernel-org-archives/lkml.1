Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZKIIJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZKIIJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZKIIJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:09:10 -0500
Received: from sh.osrg.net ([192.16.179.4]:52076 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZKIIJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:09:08 -0500
Date: Mon, 09 Nov 2009 17:09:07 +0900 (JST)
Message-Id: <20091109.170907.90094833.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.32
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 09 Nov 2009 17:09:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive two nilfs fixes around the GC routines; one of which solves
a reported oops in the error handling code, and another corrects an
-rc1 regression inducing clean up leak.

Thanks,
Ryusuke Konishi
--
The following changes since commit b419148e567728f6af0c3b01965c1cc141e3e13a:
  Linus Torvalds (1):
        Linux 2.6.32-rc6

Ryusuke Konishi (2):
      nilfs2: fix kernel oops in error case of nilfs_ioctl_move_blocks
      nilfs2: fix missing cleanup of gc cache on error cases

 fs/nilfs2/ioctl.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)
