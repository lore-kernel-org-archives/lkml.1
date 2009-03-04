Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZCDSdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZCDSdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZCDSdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:33:31 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:47081 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbZCDSda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:33:30 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/3] xfs: fix sparse warnings
To: Felix Blyakher <felixb@sgi.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Date: Wed, 04 Mar 2009 19:33:23 +0100
Message-ID: <20090304183136.525.13769.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a fair amount of the remaining sparse
warnings in fs/xfs with !CONFIG_XFS_DEBUG.

With CONFIG_XFS_DEBUG we still got alot of "Should it be static?"
warnings, but that's a different issue.

---
Hannes Eder (3):
      xfs: include header files for prototypes
      xfs: make symbols static
      xfs: move declaration to header file

 fs/xfs/linux-2.6/xfs_ioctl.c |    1 +
 fs/xfs/linux-2.6/xfs_super.c |    6 +++---
 fs/xfs/support/debug.c       |    1 +
 fs/xfs/xfs_bmap.c            |    2 +-
 fs/xfs/xfs_da_btree.h        |    1 +
 fs/xfs/xfs_dir2.c            |    2 --
 fs/xfs/xfs_dir2_leaf.c       |    2 +-
 7 files changed, 8 insertions(+), 7 deletions(-)
