Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0CBX75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:59:57 -0500
Received: from kroah.org ([198.145.64.141]:38491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab0CBX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/62] driver core: make platform_device_id table const
Date: Tue,  2 Mar 2010 15:28:03 -0800
Message-Id: <1267572541-410-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.y.miao@gmail.com>

The platform ID table is normally const, force that by adding the attribute.

Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/platform_device.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 25e64b4..2c2d035 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -21,7 +21,7 @@ struct platform_device {
 	u32		num_resources;
 	struct resource	* resource;
 
-	struct platform_device_id	*id_entry;
+	const struct platform_device_id	*id_entry;
 
 	/* arch specific additions */
 	struct pdev_archdata	archdata;
-- 
1.7.0.1

