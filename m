Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbZKQQBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbZKQQBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZKQQBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:01:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41267 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755393AbZKQQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:01:04 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] wm831x-backup: Remove unused variables
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Date: Tue, 17 Nov 2009 15:44:54 +0000
Message-ID: <20091117154449.3801.43579.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/power/wm831x_backup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index f181076..bf4f387 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -164,7 +164,7 @@ static __devinit int wm831x_backup_probe(struct platform_device *pdev)
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_backup *devdata;
 	struct power_supply *backup;
-	int ret, irq, i;
+	int ret;
 
 	devdata = kzalloc(sizeof(struct wm831x_backup), GFP_KERNEL);
 	if (devdata == NULL)

