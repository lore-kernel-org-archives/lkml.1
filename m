Return-Path: <linux-kernel-owner+w=401wt.eu-S1946014AbXBBS1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946014AbXBBS1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 13:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946020AbXBBS1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 13:27:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946014AbXBBS1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 13:27:15 -0500
Date: Fri, 2 Feb 2007 13:27:14 -0500
From: Andy Gospodarek <andy@greyhouse.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Add systems for automatic breadth-first device sorting
Message-ID: <20070202182714.GA11549@gospo.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is an additional list of systems that exhibit the PCI device
ordering issue that prompted the following patch:

commit 6b4b78fed47e7380dfe9280b154e8b9bfcd4c86c
Author: Matt Domsch <Matt_Domsch@dell.com>
Date:   Fri Sep 29 15:23:23 2006 -0500

    PCI: optionally sort device lists breadth-first

Adding these systems to the list prevents the need for the additional
kernel command line argument.
    

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
---

 common.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+)

diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -191,6 +191,94 @@ static struct dmi_system_id __devinitdat
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2950"),
 		},
 	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G3"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G4",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G4"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL30p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL30p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL25p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL25p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL35p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL35p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL460c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL460c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL465c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL465c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL480c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL480c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL685c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
+		},
+	},
 	{}
 };
 
