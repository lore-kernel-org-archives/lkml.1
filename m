Return-Path: <linux-kernel-owner+w=401wt.eu-S1765092AbYCFK6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765092AbYCFK6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763856AbYCFK4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:56:04 -0500
Received: from mail.southpole.se ([193.12.106.18]:44124 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648AbYCFKzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:55:54 -0500
From: Jonas Bonn <jonas@southpole.se>
To: jonas@southpole.se, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com
Subject: [PATCH] net: use DECLARE_PCI_DEVICE_TABLE
Date: Thu,  6 Mar 2008 11:55:47 +0100
Message-Id: <1204800947-21569-10-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1204800947-21569-9-git-send-email-jonas@southpole.se>
References: <>
 <1204800947-21569-1-git-send-email-jonas@southpole.se>
 <1204800947-21569-2-git-send-email-jonas@southpole.se>
 <1204800947-21569-3-git-send-email-jonas@southpole.se>
 <1204800947-21569-4-git-send-email-jonas@southpole.se>
 <1204800947-21569-5-git-send-email-jonas@southpole.se>
 <1204800947-21569-6-git-send-email-jonas@southpole.se>
 <1204800947-21569-7-git-send-email-jonas@southpole.se>
 <1204800947-21569-8-git-send-email-jonas@southpole.se>
 <1204800947-21569-9-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes struct pci_device_id array const and adds section attribute __devinitconst

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/net/e1000e/netdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index fc5c63f..acfc157 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4059,7 +4059,7 @@ static struct pci_error_handlers e1000_err_handler = {
 	.resume = e1000_io_resume,
 };
 
-static struct pci_device_id e1000_pci_tbl[] = {
+static DECLARE_PCI_DEVICE_TABLE(e1000_pci_tbl) = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82571EB_COPPER), board_82571 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82571EB_FIBER), board_82571 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82571EB_QUAD_COPPER), board_82571 },
-- 
1.5.4.3


