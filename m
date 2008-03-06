Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbYCFLBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbYCFLBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764054AbYCFK4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:56:31 -0500
Received: from mail.southpole.se ([193.12.106.18]:44131 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763689AbYCFKzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:55:53 -0500
From: Jonas Bonn <jonas@southpole.se>
To: jonas@southpole.se, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com
Subject: [PATCH] net: use DECLARE_PCI_DEVICE_TABLE
Date: Thu,  6 Mar 2008 11:55:43 +0100
Message-Id: <1204800947-21569-6-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1204800947-21569-5-git-send-email-jonas@southpole.se>
References: <>
 <1204800947-21569-1-git-send-email-jonas@southpole.se>
 <1204800947-21569-2-git-send-email-jonas@southpole.se>
 <1204800947-21569-3-git-send-email-jonas@southpole.se>
 <1204800947-21569-4-git-send-email-jonas@southpole.se>
 <1204800947-21569-5-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes struct pci_device_id array const and moves it to __devinitconst

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/net/wan/wanxl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index d4aab8a..9e2f084 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -811,7 +811,7 @@ static int __devinit wanxl_pci_init_one(struct pci_dev *pdev,
 	return 0;
 }
 
-static struct pci_device_id wanxl_pci_tbl[] __devinitdata = {
+static DECLARE_PCI_DEVICE_TABLE(wanxl_pci_tbl) = {
 	{ PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_SBE_WANXL100, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_SBE_WANXL200, PCI_ANY_ID,
-- 
1.5.4.3


