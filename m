Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbZIWNFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbZIWNFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZIWNFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:05:16 -0400
Received: from ozlabs.org ([203.10.76.45]:54848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZIWNFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:05:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest & virtio
Date: Wed, 23 Sep 2009 22:35:14 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909232235.15076.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ebc79c4f8da0f92efa968e0328f32334a2ce80cf:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jaswinder/linux-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Christoph Hellwig (1):
      virtio_blk: add support for cache flush

Fernando Luis Vazquez Cao (2):
      virtio: get rid of redundant VIRTIO_ID_9P definition
      virtio: add virtio IDs file

Rusty Russell (6):
      virtio_pci: minor MSI-X cleanups
      virtio: make add_buf return capacity remaining
      lguest: move panic notifier registration to its expected place.
      lguest: use set_pte/set_pmd uniformly for real page table entries
      lguest: use PGDIR_SHIFT for PAE code to allow different PAGE_OFFSET
      lguest: don't force VIRTIO_F_NOTIFY_ON_EMPTY

Xiao Guangrong (1):
      lguest: cleanup for map_switcher()

 Documentation/lguest/lguest.c       |   26 ++++++-
 arch/x86/lguest/boot.c              |   10 +--
 drivers/block/virtio_blk.c          |   33 ++++++++--
 drivers/char/hw_random/virtio-rng.c |    3 +-
 drivers/char/virtio_console.c       |    5 +-
 drivers/lguest/core.c               |    5 +-
 drivers/lguest/page_tables.c        |   45 +++++-------
 drivers/net/virtio_net.c            |   15 ++--
 drivers/virtio/virtio_balloon.c     |    3 +-
 drivers/virtio/virtio_pci.c         |  125 +++++++++++++++++++---------------
 drivers/virtio/virtio_ring.c        |    6 ++-
 include/linux/virtio.h              |    2 +-
 include/linux/virtio_9p.h           |    2 -
 include/linux/virtio_balloon.h      |    3 -
 include/linux/virtio_blk.h          |   18 ++++-
 include/linux/virtio_console.h      |    3 -
 include/linux/virtio_ids.h          |   17 +++++
 include/linux/virtio_net.h          |    3 -
 include/linux/virtio_rng.h          |    3 -
 net/9p/trans_virtio.c               |    5 +-
 20 files changed, 199 insertions(+), 133 deletions(-)
 create mode 100644 include/linux/virtio_ids.h
