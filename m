Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969AbZAZOOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbZAZOOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZAZON6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:13:58 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56943 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZAZON5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:13:57 -0500
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] fuse fixes for 2.6.28-rc2
Message-Id: <E1LRSDq-0001LI-Im@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Jan 2009 15:13:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull these fuse fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos


---
Dan Carpenter (1):
      fuse: fix NULL deref in fuse_file_alloc()

Miklos Szeredi (4):
      fuse: fix missing fput on error
      fuse: fuse_fill_super error handling cleanup
      fuse: destroy bdi on umount
      fuse: fix poll notify

---
 fs/fuse/dev.c   |   16 +++++++++++-----
 fs/fuse/file.c  |    2 +-
 fs/fuse/inode.c |   30 ++++++++++++++++++------------
 3 files changed, 30 insertions(+), 18 deletions(-)
