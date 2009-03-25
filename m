Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZCYAci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZCYAci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZCYA3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:41 -0400
Received: from kroah.org ([198.145.64.141]:54052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755995AbZCYA3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, mporter@kernel.crashing.org
Subject: [PATCH 08/61] rapidio: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:12 -0700
Message-Id: <1237940825-22904-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: mporter@kernel.crashing.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/rapidio/rio-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index addb87c..3222fa3 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -193,7 +193,7 @@ static int rio_match_bus(struct device *dev, struct device_driver *drv)
 }
 
 static struct device rio_bus = {
-	.bus_id = "rapidio",
+	.init_name = "rapidio",
 };
 
 struct bus_type rio_bus_type = {
-- 
1.6.2

