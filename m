Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbZIOTQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbZIOTQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZIOTPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:34 -0400
Received: from kroah.org ([198.145.64.141]:33036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758512AbZIOTOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/20] Driver core: Add accessor for device platform data
Date: Tue, 15 Sep 2009 12:12:39 -0700
Message-Id: <1253041976-1111-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

For consistency with driver data provide a dev_get_platdata() accessor
for reading the platform data from a device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index c0bd230..3f33f17 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -494,6 +494,11 @@ static inline struct device *root_device_register(const char *name)
 }
 extern void root_device_unregister(struct device *root);
 
+static inline void *dev_get_platdata(const struct device *dev)
+{
+	return dev->platform_data;
+}
+
 /*
  * Manual binding of a device to driver. See drivers/base/bus.c
  * for information on use.
-- 
1.6.4.2

