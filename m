Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZENTTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZENTTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZENTT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:19:29 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:26600 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZENTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:19:28 -0400
Date: Thu, 14 May 2009 15:19:15 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 2.6.30-rc
Message-ID: <20090514191915.GB4268@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A0C6EB5.0147:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Here's a small btrfs update for the next rc.  The IO failure fixes help
btrfs carry on when metadata reads fail because all copies of a given
block are bad.  There is still a bunch of work to do in that area, but
this a small start that avoids hopeless looping.

Chris Mason (3) commits (+37/-6):
    Btrfs: remove some WARN_ONs in the IO failure path (+0/-3)
    Btrfs: Don't loop forever on metadata IO failures (+36/-3)
    Btrfs: init inode ordered_data_close flag properly (+1/-0)

Li Hong (1) commits (+0/-4):
    Btrfs: remove outdated comment in btrfs_ioctl_resize()

Sankar P (1) commits (+1/-1):
    Btrfs: Spelling fix in btrfs_lookup_first_block_group comments

Sage Weil (1) commits (+2/-2):
    Btrfs: make show_options result match actual option names

Total: (6) commits

 fs/btrfs/ctree.c       |   39 ++++++++++++++++++++++++++++++++++++---
 fs/btrfs/disk-io.c     |    2 --
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |    4 ----
 fs/btrfs/super.c       |    4 ++--
 6 files changed, 40 insertions(+), 13 deletions(-)
