Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZIAQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZIAQUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZIAQUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:20:32 -0400
Received: from sh.osrg.net ([192.16.179.4]:58344 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZIAQUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:20:31 -0400
Date: Wed, 02 Sep 2009 01:20:01 +0900 (JST)
Message-Id: <20090902.012001.82211181.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 bugfix for 2.6.31
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 02 Sep 2009 01:20:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

nilfs tree has an additional fix which clears up reported preemption
count underflows.

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive

the following change since commit 326ba5010a5429a5a528b268b36a5900d4ab0eba
 Linus Torvalds (1):
      Linux 2.6.31-rc8

Ryusuke Konishi (1):
      nilfs2: fix preempt count underflow in nilfs_btnode_prepare_change_key

 fs/nilfs2/btnode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
--

Thanks,
Ryusuke Konishi
