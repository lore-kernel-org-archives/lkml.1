Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbYBTM5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbYBTM5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbYBTMyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:54:22 -0500
Received: from mail.southpole.se ([193.12.106.18]:42394 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbYBTMxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:53:54 -0500
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: greg@kroah.com, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [net] use PCI_DEVICE_TABLE: makes struct pci_device_id array const and adds section attribute __devinitconst
Date: Wed, 20 Feb 2008 13:53:39 +0100
Message-Id: <1203512031-14318-4-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1203512031-14318-3-git-send-email-jonas@southpole.se>
References: <1203512031-14318-1-git-send-email-jonas@southpole.se>
 <1203512031-14318-2-git-send-email-jonas@southpole.se>
 <1203512031-14318-3-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/net/amd8111e.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 85f7276..a4ad2fb 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -113,7 +113,7 @@ MODULE_PARM_DESC(coalesce, "Enable or Disable interrupt coalescing, 1: Enable, 0
 module_param_array(dynamic_ipg, bool, NULL, 0);
 MODULE_PARM_DESC(dynamic_ipg, "Enable or Disable dynamic IPG, 1: Enable, 0: Disable");
 
-static struct pci_device_id amd8111e_pci_tbl[] = {
+static PCI_DEVICE_TABLE(amd8111e_pci_tbl) = {
 
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD8111E_7462,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-- 
1.5.3.8


