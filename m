Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZFKQ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZFKQ6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZFKQ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:58:39 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43552 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZFKQ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:58:39 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20090611165837.37CC84C9BAD@norville.austin.ibm.com>
Date: Thu, 11 Jun 2009 11:58:37 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_imap.c |    1 +
 fs/jfs/super.c    |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

through these ChangeSets:

commit 79f52b77b89e8b7aa9fbe62135eea198a2ecbd5b
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Sat May 23 20:28:41 2009 -0500

    jfs: Add missing mutex_unlock call to error path
    
    Jan Kucera found an missing call to mutex_unlock() with his static code
    checker.  It's an unlikely error path to hit in the real world, but it
    should be fixed.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Reported-by: Jan Kucera <kucera.jan.cz@gmail.com>

commit 9c83633ad38138855181af6936e8ac570ef7e2cb
Author: Dan Carpenter <error27@gmail.com>
Date:   Tue Apr 7 14:48:16 2009 +0300

    missing unlock in jfs_quota_write()
    
    We should unlock &inode->i_mutex on the error path.  This bug was
    in ext2_quota_write().  I sent a patch to them today as well.
    
    Found by smatch (http://repo.or.cz/w/smatch.git).  Compile tested.
    
    regards,
    dan carpenter
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
