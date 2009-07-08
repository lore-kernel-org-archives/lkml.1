Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbZGHQFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbZGHQFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbZGHQE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:04:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:53186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704AbZGHQE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:26 -0400
Subject: [PATCH 30/44] includecheck fix: drivers/staging, usbdrv.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg KH <greg@kroah.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:04:27 +0530
Message-Id: <1247067267.4382.82.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/otus/usbdrv.c: net/iw_handler.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/otus/usbdrv.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 540cbbb..ec98518 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -113,9 +113,6 @@ extern u8_t zfLnxCreateThread(zdev_t *dev);
 
 /* Definition of Wireless Extension */
 
-#if WIRELESS_EXT > 12
-#include <net/iw_handler.h>
-#endif
 //wireless extension helper functions
 extern int usbdrv_ioctl_setessid(struct net_device *dev, struct iw_point *erq);
 extern int usbdrv_ioctl_setrts(struct net_device *dev, struct iw_param *rrq);
-- 
1.6.0.6



