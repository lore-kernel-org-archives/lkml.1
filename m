Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbXBRQbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbXBRQbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXBRQbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:31:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:23159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXBRQbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:31:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MvYiNTewJ3P4YmXjnoKQnaeoWm/XX8GRkiz5t4hu8H07lD55th2QNAGV9nR+81LDlWPa91PSMCguLUZqYYs9fSQ5mf8pK1ql0raHS7Eb+v9YQYXjZ2BMq15PvlxuUB8LYP4i5aFd/Feus9JvE3YBtzbTWJEn0rTtd4H5SRF+5M8=
Message-ID: <a4e6962a0702180831t4ff0b9f4m11d545166ba1aa98@mail.gmail.com>
Date: Sun, 18 Feb 2007 10:31:29 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] 9p patches
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'for-linus' branch of:
    git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus

This tree contains the following:

Eric Van Hensbergen(1):
    Implement optional loose read cache

Eric W. Biederman(1):
    Use kthread_strop instead of sending a SIGKILL.

 Documentation/filesystems/00-INDEX |    4 ++--
 Documentation/filesystems/9p.txt   |    4 ++++
 fs/9p/fid.c                        |    3 ++-
 fs/9p/mux.c                        |    5 +----
 fs/9p/v9fs.c                       |    9 ++++++++-
 fs/9p/v9fs.h                       |    9 ++++++++-
 fs/9p/v9fs_vfs.h                   |    2 ++
 fs/9p/vfs_addr.c                   |    2 ++
 fs/9p/vfs_dentry.c                 |   26 ++++++++++++++++++++++++++
 fs/9p/vfs_file.c                   |   18 ++++++++++++++++++
 fs/9p/vfs_inode.c                  |   20 ++++++++++++++++----
 11 files changed, 89 insertions(+), 13 deletions(-)
