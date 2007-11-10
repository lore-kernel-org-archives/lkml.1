Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbXKJSBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbXKJSBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 13:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXKJSBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 13:01:13 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:57094 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbXKJSBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 13:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MJ3TrTLZXWDp7jMaXNAuyJOZ6Oy9hZWy/k1BCX4PvzJ+Ws3qS6LyNgBNH+DYKtI8y4MeoMRL6OQbhYN8mIB5Jbln8jjOuB82aizgiapMxrzk+5sWy525SMBmK6N0ky3kjMOVAr37PWEgBpmcBO8F6k9u4JBfNBpE8tOUMeIxni8=
Message-ID: <88ee31b70711101001g21727d01qb967804162800c47@mail.gmail.com>
Date: Sun, 11 Nov 2007 03:01:10 +0900
From: "Jerome Pinot" <ngc891@gmail.com>
To: "Linus Torvalds" <torvalds@osdl.org>
Subject: [PATCH] ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Trivial Patch" <trivial@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Pinot <ngc891@gmail.com>

Add documentation in Kconfig help about the move of /proc/acpi/battery
to /sys/class/power_supply
when selecting ACPI_PROCFS. This will impact a lot of users and should
be documented.

Signed-off-by: Jerome Pinot <ngc891@gmail.com>
---

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index da3a08f..ce9dead 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -60,6 +60,7 @@ config ACPI_PROCFS
 	  /proc/acpi/info (/sys/modules/acpi/parameters/acpica_version)
 	  /proc/acpi/dsdt (/sys/firmware/acpi/tables/DSDT)
 	  /proc/acpi/fadt (/sys/firmware/acpi/tables/FACP)
+	  /proc/acpi/battery (/sys/class/power_supply)
 	  /proc/acpi/debug_layer (/sys/module/acpi/parameters/debug_layer)
 	  /proc/acpi/debug_level (/sys/module/acpi/parameters/debug_level)
