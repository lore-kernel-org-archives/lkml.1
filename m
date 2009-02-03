Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZBCRHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZBCRHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZBCRHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:07:46 -0500
Received: from relay3.sgi.com ([192.48.171.31]:38788 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752207AbZBCRHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:07:46 -0500
Date: Tue, 03 Feb 2009 11:07:40 -0600
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.29-rc4
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090203170740.538E91418C93B@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b1792e367053968f2ddb48bc911d314143ce6242:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: Check buffer lengths in log recovery

Eric Sandeen (1):
      don't reallocate sxp variable passed into xfs_swapext

Felix Blyakher (2):
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into for-linus
      [XFS] Warn on transaction in flight on read-only remount

 fs/xfs/linux-2.6/xfs_sync.c |    6 +++++-
 fs/xfs/xfs_dfrag.c          |   10 +---------
 fs/xfs/xfs_log_recover.c    |   31 +++++++++++++++++++++++++------
 3 files changed, 31 insertions(+), 16 deletions(-)
