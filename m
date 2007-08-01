Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbXHAD2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbXHAD2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbXHAD2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:28:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:39522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbXHAD2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:28:10 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ACPI: delete CONFIG_ACPI_PROCFS_SLEEP (again)
Date: Tue, 31 Jul 2007 23:27:10 -0400
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707292323.29601.rjw@sisk.pl> <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312327.10755.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

CONFIG_ACPI_PROCFS_SLEEP is a NO-OP -- delete it (again).

Apparently 296699de6bdc717189a331ab6bbe90e05c94db06 creating CONFIG_SUSPEND
and CONFIG_PM_SLEEP was based on an out-dated version of drivers/acpi/Kconfig,
as it erroneously restored this recently deleted config option.

Signed-off-by: Len Brown <len.brown@intel.com>
---
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 934d639..f1372de 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -68,14 +68,6 @@ config ACPI_PROCFS
 
 	  Say N to delete /proc/acpi/ files that have moved to /sys/
 
-config ACPI_PROCFS_SLEEP
-	bool "/proc/acpi/sleep (deprecated)"
-	depends on PM_SLEEP && ACPI_PROCFS
-	default n
-	---help---
-	  Create /proc/acpi/sleep
-	  Deprecated by /sys/power/state
-
 config ACPI_AC
 	tristate "AC Adapter"
 	depends on X86
