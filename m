Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYJ3Fgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYJ3Fgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYJ3FgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:36:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47167 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbYJ3FgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:36:03 -0400
Date: Wed, 29 Oct 2008 22:35:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 4/7] rapidio: remove excess kernel-doc notation
Message-Id: <20081029223503.61b6e5af.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

Remove excess kernel-doc notation from rio header and driver:

Warning(include/linux/rio_drv.h:399): Excess function parameter or struct member 'buffer' description in 'rio_get_inb_message'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Matt Porter <mporter@kernel.crashing.org>
---
 drivers/rapidio/rio-driver.c |    1 -
 include/linux/rio_drv.h      |    1 -
 2 files changed, 2 deletions(-)

--- lin2628-rc2.orig/include/linux/rio_drv.h
+++ lin2628-rc2/include/linux/rio_drv.h
@@ -391,7 +391,6 @@ static inline int rio_add_inb_buffer(str
  * rio_get_inb_message - Get A RIO message from an inbound mailbox queue
  * @mport: Master port containing the inbound mailbox
  * @mbox: The inbound mailbox number
- * @buffer: Pointer to the message buffer
  *
  * Get a RIO message from an inbound mailbox queue. Returns 0 on success.
  */
--- lin2628-rc2.orig/drivers/rapidio/rio-driver.c
+++ lin2628-rc2/drivers/rapidio/rio-driver.c
@@ -79,7 +79,6 @@ void rio_dev_put(struct rio_dev *rdev)
 
 /**
  *  rio_device_probe - Tell if a RIO device structure has a matching RIO device id structure
- *  @id: the RIO device id structure to match against
  *  @dev: the RIO device structure to match against
  *
  * return 0 and set rio_dev->driver when drv claims rio_dev, else error
