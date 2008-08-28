Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYH1EFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYH1EFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 00:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYH1EEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 00:04:52 -0400
Received: from gw.goop.org ([64.81.55.164]:45201 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYH1EEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 00:04:52 -0400
Message-ID: <48B623E1.3010508@goop.org>
Date: Wed, 27 Aug 2008 21:04:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: thinkpad-acpi: wan radio control is not experimental
References: <48B5D11E.5090209@goop.org> <20080827231223.GB18081@khazad-dum.debian.net> <48B5E2C4.7060803@goop.org> <20080828014647.GA24365@khazad-dum.debian.net>
In-Reply-To: <20080828014647.GA24365@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WWAN radio control has been working well for over three years,
and is no longer experimental.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 Documentation/laptops/thinkpad-acpi.txt |   11 +++--------
 drivers/misc/thinkpad_acpi.c            |    1 -
 2 files changed, 3 insertions(+), 9 deletions(-)

===================================================================
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -44,7 +44,7 @@
 	- LCD brightness control
 	- Volume control
 	- Fan control and monitoring: fan speed, fan enable/disable
-	- Experimental: WAN enable and disable
+	- WAN enable and disable
 
 A compatibility table by model and feature is maintained on the web
 site, http://ibm-acpi.sf.net/. I appreciate any success or failure
@@ -1375,17 +1375,12 @@
 would be the safest choice, though).
 
 
-EXPERIMENTAL: WAN
------------------
+WAN
+---
 
 procfs: /proc/acpi/ibm/wan
 sysfs device attribute: wwan_enable (deprecated)
 sysfs rfkill class: switch "tpacpi_wwan_sw"
-
-This feature is marked EXPERIMENTAL because the implementation
-directly accesses hardware registers and may not work as expected. USE
-WITH CAUTION! To use this feature, you need to supply the
-experimental=1 parameter when loading the module.
 
 This feature shows the presence and current state of a W-WAN (Sierra
 Wireless EV-DO) device.
===================================================================
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -3086,7 +3086,6 @@
 	.read = wan_read,
 	.write = wan_write,
 	.exit = wan_exit,
-	.flags.experimental = 1,
 };
 
 /*************************************************************************


