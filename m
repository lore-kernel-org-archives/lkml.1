Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZGAPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZGAPpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZGAPpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:45:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34345 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZGAPpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:45:04 -0400
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, csaba@gluster.com, muirj@nortel.com,
       akpm@linux-foundation.org
Subject: [GIT PULL] fuse fixes and improvements
Message-Id: <E1MM1zZ-0000HU-5f@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Jul 2009 17:45:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to get the following fuse updates.

Two of the patches are bugfixes, the other two are relatively simple
features.  These have been ready and reviewed for some time but missed
-rc1 because I was waiting for feedback on them.

Thanks,
Miklos

---
Csaba Henk (1):
      fuse: fix return value of fuse_dev_write()

John Muir (1):
      fuse: invalidation reverse calls

Miklos Szeredi (2):
      fuse: fix bad return value in fuse_file_poll()
      fuse: allow umask processing in userspace

---
 fs/fuse/dev.c        |   83 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/dir.c        |   57 ++++++++++++++++++++++++++++++++--
 fs/fuse/file.c       |    2 +-
 fs/fuse/fuse_i.h     |   27 ++++++++++++++++
 fs/fuse/inode.c      |   68 ++++++++++++++++++++++++++++++++++++++--
 include/linux/fuse.h |   36 ++++++++++++++++++++-
 6 files changed, 262 insertions(+), 11 deletions(-)
