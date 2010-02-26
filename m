Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058Ab0BZPVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:21:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965022Ab0BZPVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:21:50 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
       Anisse Astier <anisse@astier.eu>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Harald Welte <laforge@gnumonks.org>,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Len Brown <lenb@kernel.org>, Lennart Poettering <mzxreary@0pointer.de>,
       Mattia Dongili <malattia@linux.it>, Peter Feuerer <peter@piie.net>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86 information
Date: Fri, 26 Feb 2010 10:18:34 -0500
Message-Id: <1267197527-18062-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the drivers/platform/x86 drivers have nothing to do with ACPI, so
it's kind of inappropriate for them to be stuck under the ACPI mailing
list. Add a new mailing list (platform-driver-x86@vger.kernel.org) and,
with Len's blessing, add myself as subsystem maintainer.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Mattia Dongili <malattia@linux.it>
Cc: Peter Feuerer <peter@piie.net>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 MAINTAINERS |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2533fc4..f355d11 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -221,6 +221,7 @@ F:	drivers/net/acenic*
 
 ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
 M:	Peter Feuerer <peter@piie.net>
+L:	platform-driver-x86@vger.kernel.org
 W:	http://piie.net/?section=acerhdf
 S:	Maintained
 F:	drivers/platform/x86/acerhdf.c
@@ -228,6 +229,7 @@ F:	drivers/platform/x86/acerhdf.c
 ACER WMI LAPTOP EXTRAS
 M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
 L:	aceracpi@googlegroups.com (subscribers-only)
+L:	platform-driver-x86@vger.kernel.org
 W:	http://code.google.com/p/aceracpi
 S:	Maintained
 F:	drivers/platform/x86/acer-wmi.c
@@ -288,7 +290,7 @@ F:	drivers/acpi/video.c
 
 ACPI WMI DRIVER
 M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
-L:	linux-acpi@vger.kernel.org
+L:	platform-driver-x86@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Maintained
 F:	drivers/platform/x86/wmi.c
@@ -968,6 +970,7 @@ ASUS ACPI EXTRAS DRIVER
 M:	Corentin Chary <corentincj@iksaif.net>
 M:	Karol Kozimor <sziwan@users.sourceforge.net>
 L:	acpi4asus-user@lists.sourceforge.net
+L:	platform-driver-x86@vger.kernel.org
 W:	http://acpi4asus.sf.net
 S:	Maintained
 F:	drivers/platform/x86/asus_acpi.c
@@ -981,6 +984,7 @@ F:	drivers/hwmon/asb100.c
 ASUS LAPTOP EXTRAS DRIVER
 M:	Corentin Chary <corentincj@iksaif.net>
 L:	acpi4asus-user@lists.sourceforge.net
+L:	platform-driver-x86@vger.kernel.org
 W:	http://acpi4asus.sf.net
 S:	Maintained
 F:	drivers/platform/x86/asus-laptop.c
@@ -1473,6 +1477,7 @@ F:	drivers/scsi/fnic/
 CMPC ACPI DRIVER
 M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
 M:	Daniel Oliveira Nascimento <don@syst.com.br>
+L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/classmate-laptop.c
 
@@ -1516,6 +1521,7 @@ F:	drivers/pci/hotplug/cpcihp_generic.c
 
 COMPAL LAPTOP SUPPORT
 M:	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
+L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/compal-laptop.c
 
@@ -1746,6 +1752,7 @@ F:	drivers/net/defxx.*
 
 DELL LAPTOP DRIVER
 M:	Matthew Garrett <mjg59@srcf.ucam.org>
+L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/dell-laptop.c
 
@@ -2028,6 +2035,7 @@ F:	drivers/edac/r82600_edac.c
 EEEPC LAPTOP EXTRAS DRIVER
 M:	Corentin Chary <corentincj@iksaif.net>
 L:	acpi4asus-user@lists.sourceforge.net
+L:	platform-driver-x86@vger.kernel.org
 W:	http://acpi4asus.sf.net
 S:	Maintained
 F:	drivers/platform/x86/eeepc-laptop.c
@@ -2295,7 +2303,7 @@ F:	arch/frv/
 
 FUJITSU LAPTOP EXTRAS
 M:	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
-L:	linux-acpi@vger.kernel.org
+L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/fujitsu-laptop.c
 
@@ -2561,6 +2569,7 @@ F:	drivers/net/wireless/hostap/
 
 HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
 M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
+L:	platform-driver-x86@vger.kernel.org
 S:	Odd Fixes
 F:	drivers/platform/x86/tc1100-wmi.c
 
@@ -2771,7 +2780,7 @@ F:	drivers/video/i810/
 
 INTEL MENLOW THERMAL DRIVER
 M:	Sujith Thomas <sujith.thomas@intel.com>
-L:	linux-acpi@vger.kernel.org
+L:	platform-driver-x86@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/platform/x86/intel_menlow.c
@@ -3637,6 +3646,7 @@ F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
 M:	Lennart Poettering <mzxreary@0pointer.de>
+L:	platform-driver-x86@vger.kernel.org
 W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
@@ -3644,6 +3654,7 @@ F:	drivers/platform/x86/msi-laptop.c
 
 MSI WMI SUPPORT
 M:	Anisse Astier <anisse@astier.eu>
+L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/msi-wmi.c
 
@@ -4096,6 +4107,7 @@ F:	drivers/i2c/busses/i2c-pasemi.c
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
+L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/panasonic-laptop.c
 
@@ -5034,7 +5046,7 @@ F:	include/linux/ssb/
 
 SONY VAIO CONTROL DEVICE DRIVER
 M:	Mattia Dongili <malattia@linux.it>
-L:	linux-acpi@vger.kernel.org
+L:	platform-driver-x86@vger.kernel.org
 W:	http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
 S:	Maintained
 F:	Documentation/laptops/sony-laptop.txt
@@ -5240,6 +5252,7 @@ F:	arch/xtensa/
 THINKPAD ACPI EXTRAS DRIVER
 M:	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
 L:	ibm-acpi-devel@lists.sourceforge.net
+L:	platform-driver-x86@vger.kernel.org
 W:	http://ibm-acpi.sourceforge.net
 W:	http://thinkwiki.org/wiki/Ibm-acpi
 T:	git git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
@@ -5293,10 +5306,12 @@ F:	security/tomoyo/
 
 TOPSTAR LAPTOP EXTRAS DRIVER
 M:	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
+L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/topstar-laptop.c
 
 TOSHIBA ACPI EXTRAS DRIVER
+L:	platform-driver-x86@vger.kernel.org
 S:	Orphan
 F:	drivers/platform/x86/toshiba_acpi.c
 
@@ -6024,6 +6039,12 @@ S:	Maintained
 F:	Documentation/x86/
 F:	arch/x86/
 
+X86 PLATFORM DRIVERS
+M:	Matthew Garrett <mjg@redhat.com>
+L:	platform-driver-x86@vger.kernel.org
+S:	Maintained
+F:	drivers/platform/x86
+
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy@xensource.com>
 M:	Chris Wright <chrisw@sous-sol.org>
-- 
1.6.6.1

