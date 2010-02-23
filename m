Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0BWC5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:57:15 -0500
Received: from mail.perches.com ([173.55.12.10]:1143 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0BWC5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:57:13 -0500
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       Alex Duyck <alexander.h.duyck@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Andrew Gallatin <gallatin@myri.com>, Brice Goglin <brice@myri.com>,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: [PATCH net-next 0/7] drivers/net conversions to netdev_<level>, etc
Date: Mon, 22 Feb 2010 18:56:56 -0800
Message-Id: <cover.1266893507.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more conversions of drivers to:

    netif_<level>
    netdev_<level>
    pr_<level>

with some other minor updates/corrections
noticed during conversions.

Joe Perches (7):
  drivers/net/chelsio: Use pr_<level>, netif_msg_<type>
  drivers/net/myri10ge: Use pr_<level> and netdev_<level>
  drivers/net/ixgbe: Use pr_<level> and netif_<level>
  drivers/net/ixgb: Use pr_<level> and netdev_<level>
  drivers/net/e1000: Use pr_<level> and netif_<level>
  drivers/net/e1000e: Use pr_<level> and netdev_<level>
  drivers/net/igb: Use netdev_<level>

 drivers/net/chelsio/common.h      |   24 +--
 drivers/net/chelsio/cxgb2.c       |   18 +-
 drivers/net/chelsio/espi.c        |    4 +-
 drivers/net/chelsio/pm3393.c      |   16 +-
 drivers/net/chelsio/sge.c         |   10 +-
 drivers/net/chelsio/subr.c        |   32 ++--
 drivers/net/chelsio/vsc7326.c     |   24 ++--
 drivers/net/e1000/e1000.h         |   17 --
 drivers/net/e1000/e1000_ethtool.c |   38 ++--
 drivers/net/e1000/e1000_hw.c      |  383 ++++++++++++++++++-------------------
 drivers/net/e1000/e1000_main.c    |  272 +++++++++++++-------------
 drivers/net/e1000/e1000_osdep.h   |   14 +--
 drivers/net/e1000/e1000_param.c   |  121 +++++++------
 drivers/net/e1000e/82571.c        |   57 ++++--
 drivers/net/e1000e/e1000.h        |   21 --
 drivers/net/e1000e/es2lan.c       |   27 ++--
 drivers/net/e1000e/ethtool.c      |   37 ++--
 drivers/net/e1000e/ich8lan.c      |   90 +++++----
 drivers/net/e1000e/lib.c          |  131 +++++++-------
 drivers/net/e1000e/netdev.c       |   95 +++++-----
 drivers/net/e1000e/param.c        |   20 +-
 drivers/net/e1000e/phy.c          |  114 ++++++------
 drivers/net/igb/e1000_82575.c     |   58 +++---
 drivers/net/igb/e1000_hw.h        |   12 +-
 drivers/net/igb/e1000_mac.c       |   84 ++++----
 drivers/net/igb/e1000_nvm.c       |   22 +-
 drivers/net/igb/e1000_phy.c       |  104 +++++-----
 drivers/net/igb/igb.h             |    1 -
 drivers/net/igb/igb_ethtool.c     |    6 +-
 drivers/net/igb/igb_main.c        |   43 ++---
 drivers/net/ixgb/ixgb.h           |    8 +-
 drivers/net/ixgb/ixgb_ee.c        |   14 +-
 drivers/net/ixgb/ixgb_hw.c        |  147 ++++++---------
 drivers/net/ixgb/ixgb_hw.h        |   12 --
 drivers/net/ixgb/ixgb_main.c      |   33 ++--
 drivers/net/ixgb/ixgb_osdep.h     |   16 +--
 drivers/net/ixgb/ixgb_param.c     |   31 ++--
 drivers/net/ixgbe/ixgbe.h         |    6 -
 drivers/net/ixgbe/ixgbe_common.h  |   15 +-
 drivers/net/ixgbe/ixgbe_dcb_nl.c  |    5 +-
 drivers/net/ixgbe/ixgbe_ethtool.c |   40 +++--
 drivers/net/ixgbe/ixgbe_fcoe.c    |   25 ++--
 drivers/net/ixgbe/ixgbe_main.c    |  110 +++++------
 drivers/net/ixgbe/ixgbe_phy.c     |    2 +
 drivers/net/ixgbe/ixgbe_sriov.c   |   11 +-
 drivers/net/myri10ge/myri10ge.c   |  183 +++++++-----------
 46 files changed, 1202 insertions(+), 1351 deletions(-)

