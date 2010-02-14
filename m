Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0BNXBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:01:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1027 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab0BNXBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:01:50 -0500
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: David Brownell <david-b@pacbell.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [net-next PATCH 0/2] usbnet: convert dev(dbg|err|warn|info) macros to netdev_<>
Date: Sun, 14 Feb 2010 15:01:45 -0800
Message-Id: <cover.1266187669.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.rc1.33.g07cf0f
In-Reply-To: <20100212.123837.56526847.davem@davemloft.net>
References: <20100212.123837.56526847.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some consistency to log messages
Use the net netif_<> macros

Joe Perches (2):
  usbnet: Convert dev(dbg|err|warn|info) macros to netdev_<level>
  drivers/net/usb: Use netif_<level> logging facilities

 drivers/net/usb/asix.c       |   97 +++++++++--------
 drivers/net/usb/cdc_eem.c    |   10 +-
 drivers/net/usb/cdc_ether.c  |   22 ++--
 drivers/net/usb/dm9601.c     |   49 +++++----
 drivers/net/usb/int51x1.c    |   15 ++--
 drivers/net/usb/net1080.c    |  109 +++++++++-----------
 drivers/net/usb/pegasus.c    |  170 +++++++++++++-----------------
 drivers/net/usb/rndis_host.c |   24 ++---
 drivers/net/usb/smsc95xx.c   |  221 ++++++++++++++++++---------------------
 drivers/net/usb/usbnet.c     |  238 +++++++++++++++++++-----------------------
 include/linux/usb/usbnet.h   |   21 ----
 11 files changed, 448 insertions(+), 528 deletions(-)

