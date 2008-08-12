Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYHLKXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYHLKXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 06:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYHLKXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 06:23:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39948 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYHLKXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 06:23:20 -0400
Date: Tue, 12 Aug 2008 12:24:34 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: acpi: trivial cleanups
Message-ID: <20080812102434.GA2676@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial cleanups for ACPI. Fix misspelling in printk(), fix mismerge,
add file header.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 2d81db56ce92e04b57b76c0ca6a9b57432bf8fce
tree e3c47f9a5448b5be5f64224229d6eac3320d12e4
parent 7f8e83c414b78ee89b8e59c1a1cb74937f519be4
author Pavel <pavel@amd.ucw.cz> Tue, 12 Aug 2008 12:20:29 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 12 Aug 2008 12:20:29 +0200

 drivers/acpi/processor_core.c |    2 +-
 drivers/acpi/processor_idle.c |    1 -
 drivers/acpi/reboot.c         |    6 +++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index e36422a..d3f0a62 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -123,7 +123,7 @@ struct acpi_processor_errata errata __re
 static int set_no_mwait(const struct dmi_system_id *id)
 {
 	printk(KERN_NOTICE PREFIX "%s detected - "
-		"disable mwait for CPU C-stetes\n", id->ident);
+		"disabling mwait for CPU C-states\n", id->ident);
 	idle_nomwait = 1;
 	return 0;
 }
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 283c08f..cf5b1b7 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -41,7 +41,6 @@ #include <linux/sched.h>	/* need_resched
 #include <linux/pm_qos_params.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
-#include <linux/cpuidle.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
index a6b662c..b4d9cb3 100644
--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -1,4 +1,8 @@
-
+/*
+ * Reset the machine using the RESET_REG
+ *
+ * Distribute under GPL.
+ */
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <acpi/reboot.h>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
