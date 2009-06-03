Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbZFCJeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbZFCJeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZFCJeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:34:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:21206 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZFCJeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x4Gk64sPuiqURMNhHIQGa2JTiOLs/PPgGS992p0c/H9+n/jbcai1RVnGPMwAM0Xt8G
         R2R8fpkqt3o35X9E2otFYaPeTw5dBMBC0nwNtYJh8xfBuWU5TBNRSIJzM1OooaEmtG6p
         NMQ/1j8Qe6DaSkApMYMfV8Uh6gAvKVBMYctnc=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       davem@davemloft.net, Stephen Rothwell <sfr@canb.auug.org.au>,
       Sergey Lapin <slapin@ossfans.org>
Subject: [MERGE REQUEST] IEEE 802.15.4 stack: generic parts
Date: Wed,  3 Jun 2009 13:33:43 +0400
Message-Id: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As generic parts of our IEEE 802.15.4 stack are now more or less stable,
we'd like to merge them into mainline Linux kernel. I've prepared a branch
on the git.kernel.org that contains changes we'd like to get in at first
step. What should we do? Should this be included into linux-next? Should
this be submitted directly to Dave Miller?

The following changes since commit 59a3759d0fe8d969888c741bb33f4946e4d3750d:
  Linus Torvalds (1):
        Linux 2.6.30-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git for-next

Darren Salt (1):
      crc-itu-t: add bit-reversed calculation

Dmitry Eremin-Solenikov (5):
      Add constants for the ieee 802.15.4/ZigBee stack
      net: add IEEE 802.15.4 socket family implementation
      net: add NL802154 interface for configuration of 802.15.4 devices
      ieee802154: add documentation about our stack
      ieee802154: add simple HardMAC driver sample

 Documentation/networking/ieee802154.txt |   76 +++++
 MAINTAINERS                             |   12 +
 drivers/Makefile                        |    1 +
 drivers/ieee802154/Kconfig              |   21 ++
 drivers/ieee802154/Makefile             |    3 +
 drivers/ieee802154/fakehard.c           |  258 ++++++++++++++++
 drivers/net/Kconfig                     |    2 +
 include/linux/crc-itu-t.h               |   10 +
 include/linux/if.h                      |    2 +
 include/linux/if_arp.h                  |    2 +
 include/linux/if_ether.h                |    2 +
 include/linux/socket.h                  |    6 +-
 include/net/ieee802154/af_ieee802154.h  |   60 ++++
 include/net/ieee802154/mac_def.h        |  158 ++++++++++
 include/net/ieee802154/netdevice.h      |   84 ++++++
 include/net/ieee802154/nl802154.h       |  165 +++++++++++
 lib/crc-itu-t.c                         |   18 ++
 net/Kconfig                             |    1 +
 net/Makefile                            |    1 +
 net/core/dev.c                          |    6 +-
 net/core/sock.c                         |    3 +
 net/ieee802154/Kconfig                  |   12 +
 net/ieee802154/Makefile                 |    5 +
 net/ieee802154/af802154.h               |   35 +++
 net/ieee802154/af_ieee802154.c          |  356 +++++++++++++++++++++++
 net/ieee802154/dgram.c                  |  373 ++++++++++++++++++++++++
 net/ieee802154/netlink.c                |  485 +++++++++++++++++++++++++++++++
 net/ieee802154/raw.c                    |  250 ++++++++++++++++
 28 files changed, 2404 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/ieee802154.txt
 create mode 100644 drivers/ieee802154/Kconfig
 create mode 100644 drivers/ieee802154/Makefile
 create mode 100644 drivers/ieee802154/fakehard.c
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
 create mode 100644 net/ieee802154/raw.c

