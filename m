Return-Path: <linux-kernel-owner+w=401wt.eu-S964811AbZGQOGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811AbZGQOGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934682AbZGQOGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:06:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57296 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934668AbZGQOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:06:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] Driver core: Add accessor for device platform data
Date: Fri, 17 Jul 2009 15:06:08 +0100
Message-Id: <1247839568-23225-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency with driver data provide a dev_get_platdata() accessor
for reading the platform data from a device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/device.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index aebb810..c42d426 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -446,6 +446,11 @@ static inline void set_dev_node(struct device *dev, int node)
 }
 #endif
 
+static inline void *dev_get_platdata(const struct device *dev)
+{
+	return dev->platform_data;
+}
+
 static inline void *dev_get_drvdata(const struct device *dev)
 {
 	return dev->driver_data;
-- 
1.6.3.3

