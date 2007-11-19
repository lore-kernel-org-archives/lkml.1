Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbXKSA0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbXKSA0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 19:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXKSA0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 19:26:14 -0500
Received: from ozlabs.org ([203.10.76.45]:57015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbXKSA0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 19:26:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio, lguest and module comment fixes
Date: Mon, 19 Nov 2007 11:22:42 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191122.42767.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2ffbb8377c7a0713baf6644e285adc27a5654582:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../x86/linux-2.6-x86

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus master

Matti Linnanvuori (1):
      module: fix and elaborate comments

Rusty Russell (3):
      lguest: Fix uninitialized members in example launcher
      virtio: fix module/device unloading
      virtio: fix net driver loop case where we fail to restart

 Documentation/lguest/lguest.c  |    9 ++++++---
 drivers/block/virtio_blk.c     |   10 +++++++---
 drivers/lguest/lguest_device.c |    2 ++
 drivers/net/virtio_net.c       |   12 ++++++++----
 drivers/virtio/virtio.c        |   13 +++++++++++++
 kernel/module.c                |    8 +++++---
 6 files changed, 41 insertions(+), 13 deletions(-)
