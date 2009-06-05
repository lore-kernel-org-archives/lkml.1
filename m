Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZFECb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZFECb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZFECbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:31:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:34254 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZFECbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HN0NwsW0T380P+3a2TVy3qZF4+jgVJe8q9jO2UHi3gjw/qbKVkCIvz5Rps1t2TE3bK
         PlUiBju3iMtBKuFY3x6RU5k2NQoh1VoHMN4Am/EPRPN87+pyHXcqWvDk+TxdzLiDw6d+
         t9+ZxURsJI+rniikQT4z79YitDSQMMQYd99j4=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org, slapin@ossfans.org,
       davem@davemloft.net, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PULL REQUEST] IEEE 802.15.4 stack: generic parts v2
Date: Fri,  5 Jun 2009 06:29:45 +0400
Message-Id: <1244168990-28355-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a second version of pull/merge request for our IEEE 802.15.4 stack.
Major changes from previous post:
 * Several macroses replaced with inline functions to ensure type correctness.
 * Reformat source to (mostly) fit into 80 columns
 * Drop constants 'reservation' declarations from headers
 * Split policy from nl802154.h to separate source file.
 * Add documentation for our netlink protocol.

The following changes since commit 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3:
  Linus Torvalds (1):
        Linux 2.6.30-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git for-next

Dmitry Eremin-Solenikov (5):
      Add constants for the ieee 802.15.4 stack
      net: add IEEE 802.15.4 socket family implementation
      net: add NL802154 interface for configuration of 802.15.4 devices
      ieee802154: add documentation about our stack
      ieee802154: add simple HardMAC driver sample

 Documentation/networking/ieee802154.txt |   76 +++++
 MAINTAINERS                             |   12 +
 drivers/Makefile                        |    1 +
 drivers/ieee802154/Kconfig              |   22 ++
 drivers/ieee802154/Makefile             |    3 +
 drivers/ieee802154/fakehard.c           |  270 ++++++++++++++++
 drivers/net/Kconfig                     |    2 +
 include/linux/if_arp.h                  |    2 +
 include/linux/if_ether.h                |    1 +
 include/linux/nl802154.h                |  119 +++++++
 include/linux/socket.h                  |    4 +-
 include/net/ieee802154/af_ieee802154.h  |   60 ++++
 include/net/ieee802154/mac_def.h        |  160 ++++++++++
 include/net/ieee802154/netdevice.h      |  115 +++++++
 include/net/ieee802154/nl802154.h       |   41 +++
 net/Kconfig                             |    1 +
 net/Makefile                            |    1 +
 net/core/dev.c                          |    6 +-
 net/core/sock.c                         |    3 +
 net/ieee802154/Kconfig                  |   12 +
 net/ieee802154/Makefile                 |    5 +
 net/ieee802154/af802154.h               |   36 +++
 net/ieee802154/af_ieee802154.c          |  372 ++++++++++++++++++++++
 net/ieee802154/dgram.c                  |  394 +++++++++++++++++++++++
 net/ieee802154/netlink.c                |  523 +++++++++++++++++++++++++++++++
 net/ieee802154/nl_policy.c              |   65 ++++
 net/ieee802154/raw.c                    |  254 +++++++++++++++
 27 files changed, 2557 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/ieee802154.txt
 create mode 100644 drivers/ieee802154/Kconfig
 create mode 100644 drivers/ieee802154/Makefile
 create mode 100644 drivers/ieee802154/fakehard.c
 create mode 100644 include/linux/nl802154.h
 create mode 100644 include/net/ieee802154/af_ieee802154.h
 create mode 100644 include/net/ieee802154/mac_def.h
 create mode 100644 include/net/ieee802154/netdevice.h
 create mode 100644 include/net/ieee802154/nl802154.h
 create mode 100644 net/ieee802154/Kconfig
 create mode 100644 net/ieee802154/Makefile
 create mode 100644 net/ieee802154/af802154.h
 create mode 100644 net/ieee802154/af_ieee802154.c
 create mode 100644 net/ieee802154/dgram.c
 create mode 100644 net/ieee802154/netlink.c
 create mode 100644 net/ieee802154/nl_policy.c
 create mode 100644 net/ieee802154/raw.c

-- 
With best wishes
Dmitry

