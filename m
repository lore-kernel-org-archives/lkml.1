Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYCUENU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYCUENU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYCUENK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:13:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38920 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYCUENG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:13:06 -0400
Message-ID: <47E3353F.3090500@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:10:39 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH  2/16] ACPI pci_slot: Fix dmi table for Fujitsu PRIMEQUEST
 (Not for mainline!) 
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix DMI table entry for Fujitsu PRIMEQUEST.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/acpi/pci_slot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.25-rc6/drivers/acpi/pci_slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/acpi/pci_slot.c
+++ linux-2.6.25-rc6/drivers/acpi/pci_slot.c
@@ -332,10 +332,10 @@ static struct dmi_system_id acpi_pci_slo
 	 */
 	{
 	 .callback = do_sta_before_sun,
-	 .ident = "Fujitsu Limited Primequest",
+	 .ident = "Fujitsu PRIMEQUEST",
 	 .matches = {
-		DMI_MATCH(DMI_BIOS_VENDOR, "Fujitsu"),
-		DMI_MATCH(DMI_BIOS_VERSION, "2.35"),
+		DMI_MATCH(DMI_BIOS_VENDOR, "FUJITSU LIMITED"),
+		DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
 		},
 	},
 	{}


