Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbYCAQXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbYCAQXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761644AbYCAQU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:20:29 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57158 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbYCAQU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:20:28 -0500
Date: Sat, 1 Mar 2008 18:19:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: lenb@kernel.org, astarikovskiy@suse.de
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080301161902.GN25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following functions static instead of global inline:
- acpi_battery_present()
- acpi_battery_units()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/acpi/battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

9cfc2b0a3162d8e2f23537faefb6937c97513f38 foobar
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index f6215e8..d941c5a 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -116,7 +116,7 @@ struct acpi_battery {
 
 #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
 
-inline int acpi_battery_present(struct acpi_battery *battery)
+static int acpi_battery_present(struct acpi_battery *battery)
 {
 	return battery->device->status.battery_present;
 }
@@ -235,7 +235,7 @@ static enum power_supply_property energy_battery_props[] = {
 #endif
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
-inline char *acpi_battery_units(struct acpi_battery *battery)
+static char *acpi_battery_units(struct acpi_battery *battery)
 {
 	return (battery->power_unit)?"mA":"mW";
 }

