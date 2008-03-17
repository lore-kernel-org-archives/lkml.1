Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYCQMMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYCQMMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYCQMMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:12:13 -0400
Received: from ozlabs.org ([203.10.76.45]:52682 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYCQMMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:12:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] 2.6.25 virtio fixes
Date: Mon, 17 Mar 2008 23:10:22 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Jeremy Katz <katzj@redhat.com>, "Amit Shah" <amitshah@gmx.net>,
       virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803172310.22732.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a978b30af3bab0dd9af9350eeda25e76123fa28e:
  Linus Torvalds (1):
        Linux 2.6.25-rc6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Amit Shah (1):
      virtio: Enable netpoll interface for netconsole logging

Anthony Liguori (1):
      virtio: Use spin_lock_irqsave/restore for virtio-pci

Christian Borntraeger (1):
      virtio: fix race in enable_cb

Jeremy Katz (1):
      virtio: Fix sysfs bits to have proper block symlink

Rusty Russell (1):
      virtio: handle > 2 billion page balloon targets

 drivers/block/virtio_blk.c      |    1 +
 drivers/net/virtio_net.c        |   22 +++++++++++++++++++---
 drivers/virtio/virtio_balloon.c |    4 ++--
 drivers/virtio/virtio_pci.c     |   15 +++++++++------
 drivers/virtio/virtio_ring.c    |    1 -
 include/linux/virtio.h          |    5 +++--
 6 files changed, 34 insertions(+), 14 deletions(-)
