Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZAOCPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZAOCPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZAOCPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:15:44 -0500
Received: from relay3.sgi.com ([192.48.171.31]:57414 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752770AbZAOCPn (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:15:43 -0500
Date: Thu, 15 Jan 2009 13:15:36 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.29-rc2
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090115021536.BE17759391EC@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a6525042bfdfcab128bd91fad264de10fd24a55e:
  Linus Torvalds (1):
        Merge branch 'x86-pat-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (4):
      [XFS] pass XFS_IGET_BULKSTAT to xfs_iget for handle operations
      [XFS] fix compile of xfs_btree_readahead_lblock on m68k
      [XFS] truncate readdir offsets to signed 32 bit values
      [XFS] make xfs_ino_t an unsigned long long

Eric Sandeen (3):
      [XFS] Remove several unused typedefs.
      [XFS] Remove macro-to-function indirections in attr code
      [XFS] Remove macro-to-function indirections in the mask code

Lachlan McIlroy (2):
      [XFS] Update maintainers
      Merge git://git.kernel.org/.../torvalds/linux-2.6 into for-linus

Nick Piggin (2):
      [XFS] remove old vmap cache
      [XFS] use scalable vmap API

 MAINTAINERS                   |    4 +-
 fs/xfs/linux-2.6/xfs_aops.h   |    2 -
 fs/xfs/linux-2.6/xfs_buf.c    |   79 +-------------------------------------
 fs/xfs/linux-2.6/xfs_export.c |   23 +++++++++--
 fs/xfs/xfs_acl.h              |    1 -
 fs/xfs/xfs_ag.h               |    2 +-
 fs/xfs/xfs_attr_leaf.c        |   72 +++++++++++++++++-----------------
 fs/xfs/xfs_attr_leaf.h        |   12 ------
 fs/xfs/xfs_bit.h              |   10 +----
 fs/xfs/xfs_bmap_btree.c       |   84 ++++++++++++++++++++--------------------
 fs/xfs/xfs_btree.c            |    4 +-
 fs/xfs/xfs_dir2_block.c       |    7 ++-
 fs/xfs/xfs_dir2_leaf.c        |    6 +-
 fs/xfs/xfs_dir2_sf.c          |   15 ++++---
 fs/xfs/xfs_types.h            |    4 +-
 15 files changed, 122 insertions(+), 203 deletions(-)
