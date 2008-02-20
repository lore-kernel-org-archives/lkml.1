Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYBTM5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYBTM5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759069AbYBTMyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:54:18 -0500
Received: from mail.southpole.se ([193.12.106.18]:42403 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbYBTMxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:53:55 -0500
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: greg@kroah.com, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [net] use PCI_DEVICE_TABLE: makes struct pci_device_id array const and adds section attribute __devinitconst
Date: Wed, 20 Feb 2008 13:53:40 +0100
Message-Id: <1203512031-14318-5-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1203512031-14318-4-git-send-email-jonas@southpole.se>
References: <1203512031-14318-1-git-send-email-jonas@southpole.se>
 <1203512031-14318-2-git-send-email-jonas@southpole.se>
 <1203512031-14318-3-git-send-email-jonas@southpole.se>
 <1203512031-14318-4-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/net/niu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index e98ce1e..ab8148a 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -62,7 +62,7 @@ static void writeq(u64 val, void __iomem *reg)
 }
 #endif
 
-static struct pci_device_id niu_pci_tbl[] = {
+static PCI_DEVICE_TABLE(niu_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_SUN, 0xabcd)},
 	{}
 };
-- 
1.5.3.8


