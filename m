Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZFBE1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZFBE1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZFBE04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:26:56 -0400
Received: from relay3.sgi.com ([192.48.156.57]:41890 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751225AbZFBE04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:26:56 -0400
Date: Mon, 01 Jun 2009 23:26:53 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.30-rc8
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090602042653.66DB5A1FAB93@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d9244b5d2fbfe9fa540024b410047af13ceec90f:
  Linus Torvalds (1):
        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Eric Sandeen (1):
      xfs: fix overflow in xfs_growfs_data_private

Felix Blyakher (2):
      xfs: fix double unlock in xfs_swap_extents()
      xfs: prevent deadlock in xfs_qm_shake()

 fs/xfs/linux-2.6/kmem.h |    2 +-
 fs/xfs/xfs_dfrag.c      |    8 +++++---
 fs/xfs/xfs_fsops.c      |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)
