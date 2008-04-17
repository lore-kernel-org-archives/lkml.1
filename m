Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbYDQKBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbYDQKBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934147AbYDQJek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:34:40 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49178 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934361AbYDQJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:34:39 -0400
Date: Thu, 17 Apr 2008 12:34:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kristen.c.accardi@intel.com, gregkh@suse.de
Cc: pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make pciehp_acpi_get_hp_hw_control_from_firmware()
	static
Message-ID: <20080417093349.GA1677@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_patch_makes_the_needlessly_global_pciehp_acpi_get_hp_hw_control_from_firmware_static

;)

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
1ad3d7f12e34fb3af50c549683479faf9719ccd5 diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 698975a..e76b667 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1052,7 +1052,7 @@ static struct hpc_ops pciehp_hpc_ops = {
 };
 
 #ifdef CONFIG_ACPI
-int pciehp_acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev)
+static int pciehp_acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev)
 {
 	acpi_status status;
 	acpi_handle chandle, handle = DEVICE_ACPI_HANDLE(&(dev->dev));

