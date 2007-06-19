Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbXFSWww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbXFSWww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbXFSWwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:52:25 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:54615 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760760AbXFSWwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:52:23 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 00:50:11 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 6/12] acpi: fix compile warnings
Message-ID: <20070619225011.GH5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:49:14.0840 (UTC)
 FILETIME=[0F997D80:01C7B2C4]
X-WSS-ID: 6A6682E71S4852301-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile warnings:

 drivers/acpi/bus.c: In function 'acpi_bus_get_power':
 drivers/acpi/bus.c:162: warning: implicit declaration of function 'acpi_power_get_inferred_state'
 drivers/acpi/bus.c: In function 'acpi_bus_set_power':
 drivers/acpi/bus.c:232: warning: implicit declaration of function 'acpi_power_transition'

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index b4a9ea5..e01dca1 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -43,6 +43,8 @@ ACPI_MODULE_NAME("bus");
 #ifdef	CONFIG_X86
 extern void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger);
 #endif
+extern int acpi_power_get_inferred_state(struct acpi_device *);
+extern int acpi_power_transition(struct acpi_device *, int);
 
 struct acpi_device *acpi_root;
 struct proc_dir_entry *acpi_root_dir;



