Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbZDHHFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbZDHHFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbZDHHFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:05:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62082 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760485AbZDHHFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:05:03 -0400
Message-ID: <49DC4CC0.9050805@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:05:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] fs: use memdup_user()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user() in fs/.

   text    data     bss     dec     hex filename
7684360  520520 5629456 13834336         d31860 vmlinux.o.orig
   text    data     bss     dec     hex filename
7683392  520520 5629456 13833368         d31498 vmlinux.o

 fs/btrfs/ioctl.c               |   49 +++++++++------------------------------
 fs/btrfs/super.c               |   13 +++-------
 fs/ecryptfs/miscdev.c          |   15 ++++--------
 fs/ncpfs/ioctl.c               |   21 +++++-----------
 fs/sysfs/bin.c                 |   13 ++--------
 fs/xattr.c                     |   10 ++-----
 fs/xfs/linux-2.6/xfs_ioctl.c   |   23 +++++-------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |   12 +++------
 8 files changed, 45 insertions(+), 111 deletions(-)
---

