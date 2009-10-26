Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZJZMto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZJZMto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 08:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZJZMtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 08:49:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbZJZMtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 08:49:43 -0400
Message-ID: <4AE59AE9.6030803@redhat.com>
Date: Mon, 26 Oct 2009 13:49:45 +0100
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Don Dutile <ddutile@redhat.com>
Subject: [PATCH] PCI hotplug: use correct term for PCI Express
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change PCI-E to PCIe which is the correct term according to
http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf.

Signed-off-by: Stefan Assmann <sassmann@redhat.com>

---
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 0325d98..1286c3a 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -86,8 +86,8 @@ static char *pci_bus_speed_strings[] = {
 	"66 MHz PCIX 533",	/* 0x11 */
 	"100 MHz PCIX 533",	/* 0x12 */
 	"133 MHz PCIX 533",	/* 0x13 */
-	"2.5 GT/s PCI-E",	/* 0x14 */
-	"5.0 GT/s PCI-E",	/* 0x15 */
+	"2.5 GT/s PCIe",	/* 0x14 */
+	"5.0 GT/s PCIe",	/* 0x15 */
 };

 #ifdef CONFIG_HOTPLUG_PCI_CPCI
