Return-Path: <linux-kernel-owner+w=401wt.eu-S1764440AbYBTM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764440AbYBTM7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYBTMyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:54:39 -0500
Received: from mail.southpole.se ([193.12.106.18]:42429 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbYBTMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:53:56 -0500
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: greg@kroah.com, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [net] use PCI_DEVICE_TABLE: makes struct pci_device_id array const and adds section attribute __devinitconst
Date: Wed, 20 Feb 2008 13:53:49 +0100
Message-Id: <1203512031-14318-14-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1203512031-14318-13-git-send-email-jonas@southpole.se>
References: <1203512031-14318-1-git-send-email-jonas@southpole.se>
 <1203512031-14318-2-git-send-email-jonas@southpole.se>
 <1203512031-14318-3-git-send-email-jonas@southpole.se>
 <1203512031-14318-4-git-send-email-jonas@southpole.se>
 <1203512031-14318-5-git-send-email-jonas@southpole.se>
 <1203512031-14318-6-git-send-email-jonas@southpole.se>
 <1203512031-14318-7-git-send-email-jonas@southpole.se>
 <1203512031-14318-8-git-send-email-jonas@southpole.se>
 <1203512031-14318-9-git-send-email-jonas@southpole.se>
 <1203512031-14318-10-git-send-email-jonas@southpole.se>
 <1203512031-14318-11-git-send-email-jonas@southpole.se>
 <1203512031-14318-12-git-send-email-jonas@southpole.se>
 <1203512031-14318-13-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/net/sunhme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index b4e7f30..beb0d27 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -3247,7 +3247,7 @@ static void __devexit happy_meal_pci_remove(struct pci_dev *pdev)
 	dev_set_drvdata(&pdev->dev, NULL);
 }
 
-static struct pci_device_id happymeal_pci_ids[] = {
+static PCI_DEVICE_TABLE(happymeal_pci_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SUN, PCI_DEVICE_ID_SUN_HAPPYMEAL) },
 	{ }			/* Terminating entry */
 };
-- 
1.5.3.8


