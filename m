Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZD3Fc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZD3Fc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 01:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZD3FcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 01:32:20 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140AbZD3FcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 01:32:20 -0400
Date: Thu, 30 Apr 2009 00:32:16 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.30-rc5
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090430053216.2C65CA1FAB9F@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1:
  Linus Torvalds (1):
        Linux 2.6.30-rc4

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: a couple getbmap cleanups
      xfs: fix getbmap vs mmap deadlock

Lachlan McIlroy (1):
      xfs_file_last_byte() needs to acquire ilock

Olaf Weber (1):
      xfs: add more checks to superblock validation

 fs/xfs/xfs_bmap.c  |  192 ++++++++++++++++++++++++++++------------------------
 fs/xfs/xfs_inode.c |    2 +
 fs/xfs/xfs_mount.c |    3 +
 3 files changed, 108 insertions(+), 89 deletions(-)
