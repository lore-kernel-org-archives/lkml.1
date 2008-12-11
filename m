Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbYLKSSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbYLKSSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYLKSR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:17:58 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:17235 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbYLKSR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:17:57 -0500
Date: Thu, 11 Dec 2008 11:17:55 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, justin.chen@hp.com,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] PCI Hotplug: acpiphp whitespace cleanup
Message-ID: <20081211181755.GF18309@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, justin.chen@hp.com,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20081211181242.GD18309@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211181242.GD18309@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up whitespace.

Setting 'let c_space_errors=1' in .vimrc shows all sorts of
ugliness. ;)

Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index f9e244d..1cc5eee 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -44,7 +44,7 @@
 	do {							\
 		if (acpiphp_debug)				\
 			printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg); 		\
+				MY_NAME , ## arg);		\
 	} while (0)
 #define err(format, arg...) printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
 #define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 955aae4..03ce8dc 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -160,9 +160,9 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
 
 	if (((buses >> 8) & 0xff) != bus->secondary) {
 		buses = (buses & 0xff000000)
-	     		| ((unsigned int)(bus->primary)     <<  0)
-	     		| ((unsigned int)(bus->secondary)   <<  8)
-	     		| ((unsigned int)(bus->subordinate) << 16);
+			| ((unsigned int)(bus->primary)     <<  0)
+			| ((unsigned int)(bus->secondary)   <<  8)
+			| ((unsigned int)(bus->subordinate) << 16);
 		pci_write_config_dword(bus->self, PCI_PRIMARY_BUS, buses);
 	}
 	return NOTIFY_OK;
