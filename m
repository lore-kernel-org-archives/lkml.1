Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZCKVFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZCKVFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZCKVFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:05:05 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58838 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750770AbZCKVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:05:04 -0400
Date: Wed, 11 Mar 2009 16:04:55 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.29-rc8
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090311210455.236A514167101@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 559595a985e106d2fa9f0c79b7f5805453fed593:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: prevent kernel crash due to corrupted inode log format
      xfs: prevent lockdep false positive in xfs_iget_cache_miss
      xfs: only issues a cache flush on unmount if barriers are enabled

 fs/xfs/linux-2.6/xfs_buf.c   |   12 ++++++++++--
 fs/xfs/linux-2.6/xfs_buf.h   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   10 +++++-----
 fs/xfs/xfs_iget.c            |   15 ++++++++++-----
 fs/xfs/xfs_log_recover.c     |   17 +++++++++++++----
 5 files changed, 39 insertions(+), 17 deletions(-)
