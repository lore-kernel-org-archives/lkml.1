Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZHQGo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZHQGo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZHQGo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:44:57 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43133 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756890AbZHQGox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:44:53 -0400
Date: Mon, 17 Aug 2009 01:44:47 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.31-rc7
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090817064448.0CF1DA4A9DC6@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 894ef820b10d77e2d6d717342fc408bdd9825139:
  Randy Dunlap (1):
        dm-log-userspace: fix printk format warning

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: fix locking in xfs_iget_cache_hit

 fs/xfs/linux-2.6/xfs_sync.c |   13 ++++-
 fs/xfs/linux-2.6/xfs_sync.h |    1 +
 fs/xfs/xfs_iget.c           |  113 ++++++++++++++++++++++---------------------
 3 files changed, 70 insertions(+), 57 deletions(-)
