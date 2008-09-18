Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYIRH7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYIRH7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYIRH7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:59:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35039 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752860AbYIRH7F (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:59:05 -0400
Date: Thu, 18 Sep 2008 17:58:59 +1000
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.27
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080918075859.BDE0D58C52AE@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 45e9c0de2e86485f8b6633fd64ab19cfbff167f6:
  Arjan van de Ven (1):
        warn: Turn the netdev timeout WARN_ON() into a WARN()

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/linux-2.6 master

Christoph Hellwig (1):
      [XFS] Fix regression introduced by remount fixup

David Chinner (2):
      [XFS] Fix barrier status change detection.
      [XFS] Prevent lockdep false positives when locking two inodes.

Lachlan McIlroy (4):
      [XFS] Move memory allocations for log tracing out of the critical path
      [XFS] Prevent direct I/O from mapping extents beyond eof
      [XFS] Fix use-after-free with buffers
      [XFS] Don't do I/O beyond eof when unreserving space

 fs/xfs/linux-2.6/xfs_aops.c  |    4 +++
 fs/xfs/linux-2.6/xfs_super.c |   20 +++++++++++++
 fs/xfs/xfs_buf_item.c        |   44 +++++++++++++----------------
 fs/xfs/xfs_dfrag.c           |    9 +++++-
 fs/xfs/xfs_log.c             |   62 +++++++++++++++++++++++++++--------------
 fs/xfs/xfs_log_priv.h        |    1 -
 fs/xfs/xfs_vnodeops.c        |   26 +++++++++++++++++
 7 files changed, 119 insertions(+), 47 deletions(-)
