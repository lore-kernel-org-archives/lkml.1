Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbZAFWd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbZAFWd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbZAFWOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:19 -0500
Received: from kroah.org ([198.145.64.141]:48764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755715AbZAFWON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jeff Garzik <jgarzik@redhat.com>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 54/60] libata: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:13 -0800
Message-Id: <1231279939-32728-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4040d8b..9e92107 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3369,7 +3369,7 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 
 	if (sdev) {
 		ata_dev_printk(dev, KERN_INFO, "detaching (SCSI %s)\n",
-			       sdev->sdev_gendev.bus_id);
+			       dev_name(&sdev->sdev_gendev));
 
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
-- 
1.6.0.4

