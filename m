Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYCAGDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYCAGDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYCAGC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:02:59 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58524 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbYCAGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:02:58 -0500
Date: Fri, 29 Feb 2008 22:02:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>,
       mporter@kernel.crashing.org
Subject: [PATCH 2/6] docbook: fix rapidio source files
Message-Id: <20080229220240.3663e22c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in rapidio source files.
These cause the generated docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/rapidio/rio-driver.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- lin2625-rc3g2-kdoc.orig/drivers/rapidio/rio-driver.c
+++ lin2625-rc3g2-kdoc/drivers/rapidio/rio-driver.c
@@ -78,8 +78,7 @@ void rio_dev_put(struct rio_dev *rdev)
 }
 
 /**
- *  rio_device_probe - Tell if a RIO device structure has a matching RIO
- *                     device id structure
+ *  rio_device_probe - Tell if a RIO device structure has a matching RIO device id structure
  *  @id: the RIO device id structure to match against
  *  @dev: the RIO device structure to match against
  *
@@ -137,7 +136,7 @@ static int rio_device_remove(struct devi
  *  rio_register_driver - register a new RIO driver
  *  @rdrv: the RIO driver structure to register
  *
- *  Adds a &struct rio_driver to the list of registered drivers
+ *  Adds a &struct rio_driver to the list of registered drivers.
  *  Returns a negative value on error, otherwise 0. If no error
  *  occurred, the driver remains registered even if no device
  *  was claimed during registration.
@@ -167,8 +166,7 @@ void rio_unregister_driver(struct rio_dr
 }
 
 /**
- *  rio_match_bus - Tell if a RIO device structure has a matching RIO
- *                  driver device id structure
+ *  rio_match_bus - Tell if a RIO device structure has a matching RIO driver device id structure
  *  @dev: the standard device structure to match against
  *  @drv: the standard driver structure containing the ids to match against
  *
