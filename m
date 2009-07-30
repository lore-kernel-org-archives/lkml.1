Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZG3R4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZG3R4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZG3R4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:56:52 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:17484 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZG3R4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:56:51 -0400
Date: Thu, 30 Jul 2009 13:56:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 2.6.31-rc
Message-ID: <20090730175639.GF5021@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A71DED9.00E0:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

We've added two small incrementals for the btrfs async block group
caching.  One fixes a race between the caching thread and transaction
commit.  We haven't seen this one triggered in testing, but it still is
a valid fix.

The second patch makes sure the caching threads don't stall
transaction commits.

Linus, both of these are in the master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Chris Mason (1) commits (+14/-2):
    Btrfs: be more polite in the async caching threads

Yan Zheng (1) commits (+14/-10):
    Btrfs: preserve commit_root for async caching

Total: (2) commits

 fs/btrfs/ctree.h       |    4 +---
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |   11 ++++++-----
 fs/btrfs/transaction.c |   22 +++++++++++++++++++---
 fs/btrfs/transaction.h |    1 +
 5 files changed, 28 insertions(+), 12 deletions(-)

