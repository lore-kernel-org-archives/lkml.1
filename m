Return-Path: <linux-kernel-owner+w=401wt.eu-S1946561AbXBIPkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946561AbXBIPkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946559AbXBIPe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946563AbXBIPex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YFdhgVkBSaBxB3dS6JJpsXpZgXP8u34mvwpBTeEjVNJ+KBF53yy0OdLHoRuoU1K2p+JLxRE7B6VcnhPmvzybHjwpPejs8ss6f4a/k+mK5lEjs2F84xbPrRh1otXi3wh6Wxe5GQzjxc5KGW2te6jh47jqgOP0H2WGXEV1EuW6lS4=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, len.brown@intel.com, lenb@kernel.org
Subject: [PATCH 20/34] __initdata cleanup - acpi
Date: Fri, 9 Feb 2007 17:25:21 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091725.21721.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/acpi/ec.c linux-2.6.20-rc6-mm3/drivers/acpi/ec.c
--- linux-2.6.20-rc6-mm3.org/drivers/acpi/ec.c	2007-01-31 22:15:32.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/acpi/ec.c	2007-01-31 22:19:30.000000000 +0200
@@ -911,7 +911,7 @@ static int __init acpi_ec_get_real_ecdt(
 	return -ENODEV;
 }
 
-static int __initdata acpi_fake_ecdt_enabled;
+static int __initdata acpi_fake_ecdt_enabled = 0;
 int __init acpi_ec_ecdt_probe(void)
 {
 	acpi_status status;
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/acpi/tables.c linux-2.6.20-rc6-mm3/drivers/acpi/tables.c
--- linux-2.6.20-rc6-mm3.org/drivers/acpi/tables.c	2007-01-31 22:15:32.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/acpi/tables.c	2007-01-31 22:21:09.000000000 +0200
@@ -40,7 +40,7 @@
 static char *mps_inti_flags_polarity[] = { "dfl", "high", "res", "low" };
 static char *mps_inti_flags_trigger[] = { "dfl", "edge", "res", "level" };
 
-static struct acpi_table_desc initial_tables[ACPI_MAX_TABLES] __initdata;
+static struct acpi_table_desc initial_tables[ACPI_MAX_TABLES] __initdata = {{0}};
 
 void acpi_table_print_madt_entry(struct acpi_subtable_header * header)
 {
