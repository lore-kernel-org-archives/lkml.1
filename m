Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbZAFW0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbZAFW0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZAFWNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:55 -0500
Received: from kroah.org ([198.145.64.141]:51275 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756008AbZAFWNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/60] mwave: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:54 -0800
Message-Id: <1231279939-32728-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/mwave/mwavedd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 4f8d67f..94ad2c3 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -663,7 +663,7 @@ static int __init mwave_init(void)
 #if 0
 	/* sysfs */
 	memset(&mwave_device, 0, sizeof (struct device));
-	snprintf(mwave_device.bus_id, BUS_ID_SIZE, "mwave");
+	dev_set_name(&mwave_device, "mwave");
 
 	if (device_register(&mwave_device))
 		goto cleanup_error;
-- 
1.6.0.4

