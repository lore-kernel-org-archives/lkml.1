Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbZIYVbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbZIYVbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZIYVa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:30:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45370
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbZIYVaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:30:52 -0400
Date: Fri, 25 Sep 2009 14:31:10 -0700 (PDT)
Message-Id: <20090925.143110.63978337.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Forgotten GIT 'add' in CAN driver commit, my bad.

2) AX25 control block refcounting is hosed, fix from Jarek Poplawski.

3) virtio_net driver updates from Rusty Russel

4) TI Davinci checks interrupt pending status wrongly.  From Sriram @ TI.

Please pull, thanks a lot!

The following changes since commit 53cddfcc0e760d2b364878b6dadbd0c6d087cfae:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../lethal/sh-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Amit Shah (1):
      virtio_net: Check for room in the vq before adding buffer

David S. Miller (2):
      Merge branch 'master' of ssh://master.kernel.org/.../rusty/linux-2.6-for-davem
      at91_can: Forgotten git 'add' of at91_can.c

Jarek Poplawski (1):
      ax25: Fix ax25_cb refcounting in ax25_ctl_ioctl

Rusty Russell (5):
      virtio_net: skb_orphan() and nf_reset() in xmit path.
      virtio_net: return NETDEV_TX_BUSY instead of queueing an extra skb.
      virtio_net: don't free buffers in xmit ring
      virtio_net: formalize skb_vnet_hdr
      virtio_net: avoid (most) NETDEV_TX_BUSY by stopping queue early.

Sriram (1):
      TI Davinci EMAC: Fix in vector definition for EMAC_VERSION_2

 drivers/net/can/at91_can.c | 1186 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/davinci_emac.c |    9 +-
 drivers/net/virtio_net.c   |  229 ++++------
 net/ax25/af_ax25.c         |   27 +-
 4 files changed, 1299 insertions(+), 152 deletions(-)
 create mode 100644 drivers/net/can/at91_can.c
