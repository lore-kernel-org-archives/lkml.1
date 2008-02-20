Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbYBTMy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbYBTMy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYBTMx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:53:58 -0500
Received: from mail.southpole.se ([193.12.106.18]:42370 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbYBTMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:53:53 -0500
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: greg@kroah.com, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [net] use PCI_DEVICE_TABLE: makes struct pci_device_id array const and adds section attribute __devinitconst
Date: Wed, 20 Feb 2008 13:53:38 +0100
Message-Id: <1203512031-14318-3-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1203512031-14318-2-git-send-email-jonas@southpole.se>
References: <1203512031-14318-1-git-send-email-jonas@southpole.se>
 <1203512031-14318-2-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/net/hamachi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index b53f6b6..d8056e9 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -1987,7 +1987,7 @@ static void __devexit hamachi_remove_one (struct pci_dev *pdev)
 	}
 }
 
-static struct pci_device_id hamachi_pci_tbl[] = {
+static PCI_DEVICE_TABLE(hamachi_pci_tbl) = {
 	{ 0x1318, 0x0911, PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0, }
 };
-- 
1.5.3.8


