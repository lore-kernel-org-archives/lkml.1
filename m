Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbZHDRDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbZHDRDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932916AbZHDRDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:03:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:49534 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbZHDRDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:03:35 -0400
Date: Wed, 05 Aug 2009 02:03:12 +0900 (JST)
Message-Id: <20090805.020312.37207873.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.31-rc6
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 05 Aug 2009 02:03:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull bug-fixes of nilfs from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

The following changes since commit ed680c4ad478d0fee9740f7d029087f181346564
 Linus Torvalds (1):
      Linux 2.6.31-rc5

Ryusuke Konishi (2):
      nilfs2: fix oops due to inconsistent state in page with discrete b-tree nodes
      nilfs2: fix missing unlock in error path of nilfs_mdt_write_page

 fs/nilfs2/mdt.c     |    4 +++-
 fs/nilfs2/segment.c |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)
--

The "nilfs2: fix oops due to inconsistent state in page with discrete
b-tree nodes" fixes a reported kernel oops which can happen if block
size is smaller than page size.

The "nilfs2: fix missing unlock in error path of nilfs_mdt_write_page"
adds a missing unlock operation.

Thanks,
Ryusuke Konishi
