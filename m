Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZKEI6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZKEI6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZKEI6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:58:40 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39117 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZKEI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:58:40 -0500
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] fuse bug fixes
Message-Id: <E1N5yAz-0002Pg-Lp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Nov 2009 09:58:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following bugfixes for fuse

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos
----

Anand V. Avati (1):
      fuse: prevent fuse_put_request on invalid pointer

Jens Axboe (1):
      fuse: fix kunmap in fuse_ioctl_copy_user

Miklos Szeredi (1):
      fuse: invalidate target of rename

---
 fs/fuse/dir.c  |    4 +++-
 fs/fuse/file.c |    5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)
