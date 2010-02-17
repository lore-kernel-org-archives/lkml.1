Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0BQUaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:30:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1031 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab0BQUa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:30:26 -0500
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: David Brownell <david-b@pacbell.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Tilman Schmidt <tilman@imap.cc>, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 net-next 0/2] usbnet: Use (netdev|netif)_<level> macros 
Date: Wed, 17 Feb 2010 12:30:22 -0800
Message-Id: <cover.1266438216.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <20100217.000422.246530855.davem@davemloft.net>
References: <20100217.000422.246530855.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry 'bout that.
I'll try to improve my insufficient grep and build testing.

Added drivers/net/wireless/rndis_wlan.c to conversions.

After this conversion, no uses of the old macros exist in-tree.

Joe Perches (2):
  usbnet: Convert dev(dbg|err|warn|info) macros to netdev_<level>
  drivers/net/usb: Use netif_<level> logging facilities

 drivers/net/usb/asix.c            |   97 ++++++-----
 drivers/net/usb/cdc_eem.c         |   10 +-
 drivers/net/usb/cdc_ether.c       |   22 ++--
 drivers/net/usb/dm9601.c          |   49 +++---
 drivers/net/usb/int51x1.c         |   15 +-
 drivers/net/usb/net1080.c         |  109 ++++++-------
 drivers/net/usb/pegasus.c         |  170 +++++++++-----------
 drivers/net/usb/rndis_host.c      |   24 ++--
 drivers/net/usb/smsc95xx.c        |  221 ++++++++++++-------------
 drivers/net/usb/usbnet.c          |  238 ++++++++++++---------------
 drivers/net/wireless/rndis_wlan.c |  325 ++++++++++++++++++++-----------------
 include/linux/usb/usbnet.h        |   21 ---
 12 files changed, 621 insertions(+), 680 deletions(-)

