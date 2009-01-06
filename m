Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZAFT5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZAFT5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZAFT50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:57:26 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40140 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbZAFT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:57:25 -0500
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] fuse updates for 2.6.29
Message-Id: <E1LKI3D-0006mp-C2@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 Jan 2009 20:57:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull fuse updates for 2.6.29 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos

---
Harvey Harrison (1):
      fuse: clean up annotations of fc->lock

Miklos Szeredi (3):
      fuse: style fixes
      fuse: update interface version
      fuse: fix sparse warning in ioctl

Tejun Heo (9):
      fuse: move FUSE_MINOR to miscdevice.h
      fuse: don't let fuse_req->end() put the base reference
      fuse: implement ioctl support
      fuse: add file kernel handle
      fuse: implement unsolicited notification
      fuse: implement poll support
      fuse: add fuse_ prefix to several functions
      fuse: separate out fuse_conn_init() from new_conn()
      fuse: add fuse_conn->release()

---
 fs/fuse/control.c          |    6 +-
 fs/fuse/dev.c              |  113 ++++++++---
 fs/fuse/dir.c              |   48 +++---
 fs/fuse/file.c             |  457 ++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h           |   83 ++++++---
 fs/fuse/inode.c            |  157 ++++++++-------
 include/linux/fuse.h       |   79 +++++++-
 include/linux/miscdevice.h |   42 ++--
 8 files changed, 783 insertions(+), 202 deletions(-)

