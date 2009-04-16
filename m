Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZDPQjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZDPQjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbZDPQjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:39:03 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36680 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758100AbZDPQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:39:00 -0400
Subject: driver-core: remove BUS_ID_SIZE
From: Kay Sievers <kay.sievers@suse.de>
To: gregkh <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 18:38:55 +0200
Message-Id: <1239899935.17211.17.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: driver-core: remove BUS_ID_SIZE

The name size limit is gone from the driver-core, this is
the removal of the last left-over.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 include/linux/device.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,8 +25,6 @@
 #include <asm/atomic.h>
 #include <asm/device.h>
 
-#define BUS_ID_SIZE		20
-
 struct device;
 struct device_private;
 struct device_driver;


