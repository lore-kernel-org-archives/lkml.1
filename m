Return-Path: <linux-kernel-owner+w=401wt.eu-S1762567AbYA1WL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567AbYA1WL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbYA1WJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:09:59 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52208 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbYA1WJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:09:58 -0500
Date: Tue, 29 Jan 2008 00:10:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make suspend_device() static
Message-ID: <20080128221024.GO8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

suspend_device() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
344fcfcea0df8cbaa83e10d7e66b826ead67290b 
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 200ed5f..cfcc54f 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -414,7 +414,7 @@ EXPORT_SYMBOL_GPL(device_power_down);
  *	@dev:	Device.
  *	@state:	Power state device is entering.
  */
-int suspend_device(struct device *dev, pm_message_t state)
+static int suspend_device(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 

