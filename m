Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXKLDdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXKLDdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 22:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXKLDc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 22:32:56 -0500
Received: from ozlabs.org ([203.10.76.45]:54420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbXKLDc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 22:32:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest and virtio fixes
Date: Mon, 12 Nov 2007 14:32:50 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       lguest <lguest@ozlabs.org>, Anthony Liguori <anthony@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121432.50976.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6e800af233e0bdf108efb7bd23c11ea6fa34cdeb:
  Jerome Pinot (1):
        ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-virtio.git for-linus

Anthony Liguori (3):
      virtio: fix vring_init for 64 bits
      virtio: Fix used_idx wrap-around
      lguest: Fix lguest virtio-blk backend size computation

Rusty Russell (2):
      virtio: more fallout from scatterlist changes.
      virtio: Force use of power-of-two for descriptor ring sizes

 Documentation/lguest/lguest.c  |   17 +++++++++--------
 drivers/lguest/lguest_device.c |    3 ++-
 drivers/net/virtio_net.c       |    3 +++
 drivers/virtio/virtio_ring.c   |   10 ++++++++--
 include/linux/virtio_ring.h    |   21 ++++++++++++---------
 5 files changed, 34 insertions(+), 20 deletions(-)
