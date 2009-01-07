Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZAGTuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZAGTuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZAGTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:49:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33649 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbZAGTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:49:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jan 2009 20:49:11 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.28
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.de534aeb39976b7a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.

Frans Pop (1):
      ieee1394: ohci1394: don't leave interrupts enabled during suspend/resume

Harvey Harrison (7):
      ieee1394: consolidate uses of IEEE1934_BUSID_MAGIC
      ieee1394: pcilynx: trivial endian annotation
      ieee1394: replace CSR_SET_BUS_INFO_GENERATION macro
      ieee1394: mark bus_info_data as a __be32 array
      ieee1394: eth1394: trivial sparse annotations
      ieee1394: dv1394: annotate frame input/output structs as little endian
      ieee1934: dv1394: interrupt enabling/disabling broken on big-endian

Jay Fenlason (2):
      firewire: typo in comment
      firewire: improve refcounting of fw_card

Stefan Richter (9):
      ieee1394: replace a GFP_ATOMIC by GFP_KERNEL allocation
      ieee1394: mark all hpsb_address_ops instances as const
      ieee1394: ohci1394: pass error codes from request_irq through
      ieee1394: ohci1394: flush MMIO writes before delay in initialization
      ieee1394: ignore nonzero Bus_Info_Block.max_rom, fetch config ROM in quadlets
      firewire: fw-sbp2: remove unnecessary locking
      firewire: fix small memory leak at module removal
      firewire: fix resetting of bus manager retry counter
      firewire: reorder struct fw_card for better cache efficiency

 drivers/firewire/fw-card.c        |   20 +++++++++++++---
 drivers/firewire/fw-device.c      |    8 +++---
 drivers/firewire/fw-device.h      |    2 +
 drivers/firewire/fw-sbp2.c        |   21 +++++------------
 drivers/firewire/fw-topology.c    |   16 +++++-------
 drivers/firewire/fw-transaction.c |    2 +
 drivers/firewire/fw-transaction.h |   13 ++++------
 drivers/ieee1394/csr.c            |   12 +++++-----
 drivers/ieee1394/csr.h            |   10 ++++----
 drivers/ieee1394/csr1212.c        |   45 +++++++++++-------------------------
 drivers/ieee1394/csr1212.h        |    9 +-----
 drivers/ieee1394/dv1394-private.h |   44 ++++++++++++++++++------------------
 drivers/ieee1394/dv1394.c         |   12 +++++-----
 drivers/ieee1394/eth1394.c        |   28 +++++++++++-----------
 drivers/ieee1394/eth1394.h        |   16 ++++++------
 drivers/ieee1394/highlevel.c      |    9 ++++---
 drivers/ieee1394/highlevel.h      |    7 +++--
 drivers/ieee1394/hosts.c          |    6 ++--
 drivers/ieee1394/hosts.h          |    2 +-
 drivers/ieee1394/ieee1394.h       |    3 ++
 drivers/ieee1394/nodemgr.c        |   20 +++-------------
 drivers/ieee1394/nodemgr.h        |    3 --
 drivers/ieee1394/ohci1394.c       |   26 +++++++++++++++-----
 drivers/ieee1394/pcilynx.c        |    2 +-
 drivers/ieee1394/pcilynx.h        |    2 +-
 drivers/ieee1394/raw1394.c        |    2 +-
 drivers/ieee1394/sbp2.c           |    4 +-
 27 files changed, 163 insertions(+), 181 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--= ---= --===
http://arcgraph.de/sr/

