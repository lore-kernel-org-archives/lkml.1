Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbYBGVSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbYBGVSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762485AbYBGVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:03:15 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56093 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381AbYBGVDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:03:12 -0500
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20080207210254.245A94C9B7A@norville.austin.ibm.com>
Date: Thu,  7 Feb 2008 15:02:54 -0600 (CST)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/file.c       |    5 ++++-
 fs/jfs/ioctl.c      |   31 ++++++++++++++++++++++++++++---
 fs/jfs/jfs_dinode.h |    2 ++
 fs/jfs/jfs_inode.h  |    4 ++--
 fs/jfs/namei.c      |    5 ++++-
 5 files changed, 40 insertions(+), 7 deletions(-)

through these ChangeSets:

Commit: ef1fc2f01e02951a0d8520ec3aa0b38606d74b55 
Author: Andi Kleen <ak@suse.de> Sun, 27 Jan 2008 17:02:02 -0600 

    BKL-removal: Implement a compat_ioctl handler for JFS
    
    The ioctls were already compatible except for the actual values so this
    was fairly easy to do.
    
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: baab81fa518ecfac597402b462631f5593926623 
Author: Andi Kleen <ak@suse.de> Sun, 27 Jan 2008 16:58:51 -0600 

    BKL-removal: Use unlocked_ioctl for jfs
    
    Convert jfs_ioctl over to not use the BKL. The only potential race
    I could see was with two ioctls in parallel changing the flags
    and losing the updates. Use the i_mutex to protect against this.
    
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

