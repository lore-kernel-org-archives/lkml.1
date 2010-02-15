Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0BOSgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:36:25 -0500
Received: from mail.perches.com ([173.55.12.10]:1067 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0BOSe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:34:29 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       Alex Duyck <alexander.h.duyck@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>, Don Fry <pcnet32@verizon.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Alexander Indenbaum <baum@tehutinetworks.net>,
       Andy Gospodarek <andy@greyhouse.net>, e1000-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] drivers/net: Use netif_<level> macros
Date: Mon, 15 Feb 2010 10:34:19 -0800
Message-Id: <cover.1266258417.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And a few checkpatch cleanups

Joe Perches (7):
  drivers/net/ixgb: Use netif_printk macros
  drivers/net/sky2: Convert to use netif_printk macros
  drivers/net/tehuti.c: Use (pr|netdev|netif)_<levels> macro helpers
  drivers/net/tehuti.c: Hoist assigns out of ifs
  drivers/net/tehuti.c: trivial checkpatch cleanups
  drivers/net/pcnet32.c: Use (pr|netdev|netif)_<levels> macro helpers
  drivers/net/pcnet32.c: Checkpatch cleaning

 drivers/net/ixgb/ixgb.h      |   11 +-
 drivers/net/ixgb/ixgb_main.c |   89 ++++----
 drivers/net/pcnet32.c        |  500 +++++++++++++++++-------------------------
 drivers/net/sky2.c           |   65 +++----
 drivers/net/tehuti.c         |  151 +++++++-------
 drivers/net/tehuti.h         |   30 ++-
 6 files changed, 374 insertions(+), 472 deletions(-)

