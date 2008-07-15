Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbYGOTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbYGOTWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbYGOTWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:22:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41372 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbYGOTV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:21:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 15 Jul 2008 21:21:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull 1/2] FireWire updates post 2.6.26
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.ca57fe6c5cf3640c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.
We FireWire guys are all slacking off at the beach, so the list is
short.

A second pull request will follow in a minute because it treads on
SCSI territory.

Alan Cox (1):
      ieee1394: raw1394: Push the BKL down into the driver ioctls

Philippe De Muyter (1):
      ieee1394: dump mmapped iso buffers in core files

Stefan Richter (7):
      ieee1394: reduce log noise about config ROM CRC errors
      ieee1394: video1394: reorder module init, prepare BKL removal
      firewire: implement broadcast_channel CSR for 1394a compliance
      firewire: remove unused struct members
      firewire: clean up some includes
      firewire: clean up fw_card reference counting
      firewire: don't respond to broadcast write requests

 drivers/firewire/fw-card.c        |   32 +++++++++++++++++---------
 drivers/firewire/fw-device.c      |    5 +--
 drivers/firewire/fw-device.h      |    1 -
 drivers/firewire/fw-ohci.c        |    1 -
 drivers/firewire/fw-transaction.c |   32 +++++++++++++++++++-------
 drivers/firewire/fw-transaction.h |   34 ++++++++++++++++++++++------
 drivers/ieee1394/csr1212.c        |   32 ++++++++++++++++++--------
 drivers/ieee1394/dma.c            |    2 +-
 drivers/ieee1394/highlevel.c      |    4 +--
 drivers/ieee1394/highlevel.h      |   13 ++++++++++-
 drivers/ieee1394/raw1394.c        |   20 ++++++++++++----
 drivers/ieee1394/video1394.c      |    2 +
 12 files changed, 125 insertions(+), 53 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--- -=== -====
http://arcgraph.de/sr/

