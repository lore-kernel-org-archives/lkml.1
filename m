Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242Ab0ARRUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0ARRUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0ARRUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:20:43 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0ARRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=spmSUX+dalmmTrgGTeB2p4Xv9A6xzi2s/BKsP9S5FJWoN0vv8P0O8ZD0f/tmpUxpQo
         J5hprJAIG6jtuRsBzKpvgJp/+7RMOD16kVkWv5v8BT3z0GAI5D0b/QqN2/3WMTAZm/iM
         Pupeo+G4EdmPn8+YGIf/X5KU07i2bZWGv95C8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:19:30 +0100
Message-Id: <20100118171930.14623.11967.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 38/64] serverworks: add missing pci_dev_put() call
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] serverworks: add missing pci_dev_put() call

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/serverworks.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -178,6 +178,7 @@ static int init_chipset_svwks(struct pci
 					"enabled.\n", pci_name(dev));
 			reg |=  0x00004000; /* enable UDMA/33 support */
 			pci_write_config_dword(isa_dev, 0x64, reg);
+			pci_dev_put(isa_dev);
 		}
 	}
 
