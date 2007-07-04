Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXGDMaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXGDMaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762070AbXGDM3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:29:54 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59051 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761034AbXGDM3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:29:53 -0400
Date: Wed, 4 Jul 2007 15:29:48 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/11] drivers/acpi/pci_link.c: lower printk severity
Message-ID: <b8e1506a9792521af12bbe9c11120081c8d50c2b.1183551645.git.da-x@monatomic.org>
References: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dan Aloni <da-x@monatomic.org>
---
 drivers/acpi/pci_link.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index acc5947..3448edd 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -733,7 +733,7 @@ static int acpi_pci_link_add(struct acpi_device *device)
 	/* query and set link->irq.active */
 	acpi_pci_link_get_current(link);
 
-	printk(PREFIX "%s [%s] (IRQs", acpi_device_name(device),
+	printk(KERN_INFO PREFIX "%s [%s] (IRQs", acpi_device_name(device),
 	       acpi_device_bid(device));
 	for (i = 0; i < link->irq.possible_count; i++) {
 		if (link->irq.active == link->irq.possible[i]) {
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
