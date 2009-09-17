Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZIQLBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZIQLBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZIQLBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:01:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39783 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZIQLBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:01:09 -0400
To: torvalds@linux-foundation.org
CC: csaba@gluster.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fuse updates for 2.6.32
Message-Id: <E1MoEjX-0002B8-QX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 17 Sep 2009 13:01:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this round of fuse updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos
----

Csaba Henk (4):
      fuse: make the number of max background requests and congestion threshold tunable
      fuse: use drop_nlink() instead of direct nlink manipulation
      fuse: limit user-specified values of max background requests
      fuse: add fusectl interface to max_background

Miklos Szeredi (1):
      fuse: document protocol version negotiation

---
 fs/fuse/control.c    |  138 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/dev.c        |   10 ++--
 fs/fuse/fuse_i.h     |   18 ++++---
 fs/fuse/inode.c      |   80 +++++++++++++++++++++++++++++
 include/linux/fuse.h |   29 ++++++++++-
 5 files changed, 258 insertions(+), 17 deletions(-)
