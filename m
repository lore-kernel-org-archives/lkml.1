Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZEVPc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZEVPc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbZEVPct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:32:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:46030 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbZEVPct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:32:49 -0400
Date: Sat, 23 May 2009 00:32:44 +0900 (JST)
Message-Id: <20090523.003244.126117563.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] nilfs2 bugfix for 2.6.30-rc7
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 23 May 2009 00:32:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following bugfix.  It fixes a reported memory leak
problem of nilfs2 filesystem in 2.6.30-rc6.  The memory leak arises
every time the garbage collection of nilfs runs.

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

The following change since commit 1406de8e11eb043681297adf86d6892ff8efc27a
 Linus Torvalds (1):
      Linux 2.6.30-rc6

Ryusuke Konishi (1):
      nilfs2: fix memory leak in nilfs_ioctl_clean_segments

 fs/nilfs2/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


Thanks,
Ryusuke Konishi
