Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZFLMsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZFLMsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZFLMse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:48:34 -0400
Received: from ozlabs.org ([203.10.76.45]:36449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZFLMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:48:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio
Date: Fri, 12 Jun 2009 22:18:34 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Mark McLoughlin <markmc@redhat.com>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Mike Frysinger <vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122218.34829.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-virtio.git master

Christian Borntraeger (2):
      virtio: fix id_matching for virtio drivers
      virtio: enhance id_matching for virtio drivers

Mark McLoughlin (2):
      virtio: teach virtio_has_feature() about transport features
      virtio: indirect ring entries (VIRTIO_RING_F_INDIRECT_DESC)

Michael S. Tsirkin (3):
      virtio: find_vqs/del_vqs virtio operations
      virtio_pci: split up vp_interrupt
      virtio_pci: optional MSI-X support

Mike Frysinger (1):
      virtio_blk: add missing __dev{init,exit} markings

Rusty Russell (5):
      virtio: fix obsolete documentation on probe function
      virtio: meet virtio spec by finalizing features before using device
      virtio: add names to virtqueue struct, mapping from devices to queues.
      virtio: expose features in sysfs
      virtio: handle short buffers in virtio_rng.

 drivers/block/virtio_blk.c          |   10 +-
 drivers/char/hw_random/virtio-rng.c |   30 +++--
 drivers/char/virtio_console.c       |   26 ++--
 drivers/lguest/lguest_device.c      |   41 +++++-
 drivers/net/virtio_net.c            |   45 ++---
 drivers/s390/kvm/kvm_virtio.c       |   43 +++++-
 drivers/virtio/virtio.c             |   29 +++-
 drivers/virtio/virtio_balloon.c     |   27 ++--
 drivers/virtio/virtio_pci.c         |  307 ++++++++++++++++++++++++++++++-----
 drivers/virtio/virtio_ring.c        |  102 +++++++++++-
 include/linux/virtio.h              |   15 +-
 include/linux/virtio_config.h       |   49 +++++--
 include/linux/virtio_pci.h          |   10 +-
 include/linux/virtio_ring.h         |    8 +-
 net/9p/trans_virtio.c               |    6 +-
 scripts/mod/file2alias.c            |    2 +-
 16 files changed, 592 insertions(+), 158 deletions(-)

