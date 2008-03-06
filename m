Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbYCFLDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbYCFLDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbYCFK4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:56:45 -0500
Received: from mail.southpole.se ([193.12.106.18]:44124 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983AbYCFKzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:55:51 -0500
From: Jonas Bonn <jonas@southpole.se>
To: jonas@southpole.se, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com
Subject: [PATCH] net: use DECLARE_PCI_DEVICE_TABLE
Date: Thu,  6 Mar 2008 11:55:44 +0100
Message-Id: <1204800947-21569-7-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1204800947-21569-6-git-send-email-jonas@southpole.se>
References: <>
 <1204800947-21569-1-git-send-email-jonas@southpole.se>
 <1204800947-21569-2-git-send-email-jonas@southpole.se>
 <1204800947-21569-3-git-send-email-jonas@southpole.se>
 <1204800947-21569-4-git-send-email-jonas@southpole.se>
 <1204800947-21569-5-git-send-email-jonas@southpole.se>
 <1204800947-21569-6-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes struct pci_device_id array const and moves it to __devinitconst

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/net/wan/pci200syn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index b595b64..5e2eccd 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -445,7 +445,7 @@ static int __devinit pci200_pci_init_one(struct pci_dev *pdev,
 
 
 
-static struct pci_device_id pci200_pci_tbl[] __devinitdata = {
+static DECLARE_PCI_DEVICE_TABLE(pci200_pci_tbl) = {
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_PLX,
 	  PCI_DEVICE_ID_PLX_9050, 0, 0, 0 },
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_PLX,
-- 
1.5.4.3


