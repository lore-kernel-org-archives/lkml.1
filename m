Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXE1QKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXE1QKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXE1QKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:10:33 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:40387 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbXE1QKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=Q5XvateXDgIekHC8PSgg8agUrTuNBG+Uvv5xjT6yGl5RpqPTuwjjJal5h8KlEN/Am+/eQi1l2c3nZ4LOG9pxaZWJIo6wOZFju2esuHtKsC6b5bx3vA8O6BCT5TgCt1F19X8Figm4vCHHxHVxU3DIT+owg9n3ZzELXniX2I759/M=
Subject: [PATCHSET 2.6.22-rc2-mm1] sysfs: assorted fixes
In-Reply-To: 
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:10:25 +0900
Message-Id: <1180368625600-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset contains two cleanups and three fixes.

#01: make-sysfs_alloc_ino-static, cleanup
#02: fix-parent-refcounting, fix
#03: reorganize-sysfs_new_inode-and-sysfs_create, cleanup and prep for #04
#04: use-iget_locked-instead-of-new_inode, fix
#05: fix-root-sysfs_dirent-root-dentry-association, fix

 fs/sysfs/dir.c   |  143 +++++++++++++++++++++++--------------------------------
 fs/sysfs/inode.c |  114 ++++++++++++++++++++++++-------------------
 fs/sysfs/mount.c |   19 ++++---
 fs/sysfs/sysfs.h |    6 +-
 4 files changed, 137 insertions(+), 145 deletions(-)

Please apply.  Thanks.

--
tejun


