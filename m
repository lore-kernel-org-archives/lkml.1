Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbYEWGnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbYEWGnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYEWGnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:43:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55051 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbYEWGnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:43:10 -0400
Message-ID: <483667A4.9000606@jp.fujitsu.com>
Date: Fri, 23 May 2008 15:43:48 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on PRIMEQUEST
References: <4816F9B9.3090609@jp.fujitsu.com> <4836660B.3080406@jp.fujitsu.com>
In-Reply-To: <4836660B.3080406@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMI info to enable OSI(Linux) on PRIMEQUEST.
(PRIMEQUEST is ia64 machine.)

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>

---
  drivers/acpi/blacklist.c |   14 ++++++++++++++
  1 file changed, 14 insertions(+)

Index: linux-2.6.25.4/drivers/acpi/blacklist.c
===================================================================
--- linux-2.6.25.4.orig/drivers/acpi/blacklist.c
+++ linux-2.6.25.4/drivers/acpi/blacklist.c
@@ -626,6 +626,20 @@ static struct dmi_system_id acpi_osi_dmi
  		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
  		},
  	},
+	/*
+	 * Enable OSI(Linux) on Fujitsu PRIMEQUEST
+	 *
+	 * DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
+	 *
+	 */
+	{
+	.callback = dmi_enable_osi_linux,
+	.ident = "Fujitsu PRIMEQUEST",
+	.matches = {
+		     DMI_MATCH(DMI_BIOS_VENDOR, "FUJITSU LIMITED"),
+		     DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
+		},
+	},
  	{}
  };




