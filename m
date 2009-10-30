Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbZJ3WNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbZJ3WNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932968AbZJ3WNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:13:33 -0400
Received: from kroah.org ([198.145.64.141]:57522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933AbZJ3WNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:13:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] tty: Mark generic_serial users as BROKEN
Date: Fri, 30 Oct 2009 15:13:33 -0700
Message-Id: <1256940813-11610-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220949.GD11297@kroah.com>
References: <20091030220949.GD11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

There isn't much else I can do with these. I can find no hardware for any
of them and no users. The code is broken.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/m68k/Kconfig    |    6 +++---
 drivers/char/Kconfig |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 29dd848..ecdc19a 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -561,7 +561,7 @@ config HPAPCI
 
 config MVME147_SCC
 	bool "SCC support for MVME147 serial ports"
-	depends on MVME147
+	depends on MVME147 && BROKEN
 	help
 	  This is the driver for the serial ports on the Motorola MVME147
 	  boards.  Everyone using one of these boards should say Y here.
@@ -576,14 +576,14 @@ config SERIAL167
 
 config MVME162_SCC
 	bool "SCC support for MVME162 serial ports"
-	depends on MVME16x
+	depends on MVME16x && BROKEN
 	help
 	  This is the driver for the serial ports on the Motorola MVME162 and
 	  172 boards.  Everyone using one of these boards should say Y here.
 
 config BVME6000_SCC
 	bool "SCC support for BVME6000 serial ports"
-	depends on BVME6000
+	depends on BVME6000 && BROKEN
 	help
 	  This is the driver for the serial ports on the BVME4000 and BVME6000
 	  boards from BVM Ltd.  Everyone using one of these boards should say
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 08a6f50..6aad99e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -323,7 +323,7 @@ config SPECIALIX
 
 config SX
 	tristate "Specialix SX (and SI) card support"
-	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA) && BROKEN
 	help
 	  This is a driver for the SX and SI multiport serial cards.
 	  Please read the file <file:Documentation/serial/sx.txt> for details.
@@ -334,7 +334,7 @@ config SX
 
 config RIO
 	tristate "Specialix RIO system support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && BROKEN
 	help
 	  This is a driver for the Specialix RIO, a smart serial card which
 	  drives an outboard box that can support up to 128 ports.  Product
@@ -395,7 +395,7 @@ config NOZOMI
 
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
+	depends on EXPERIMENTAL && ZORRO && BROKEN
 	---help---
 	  This option supports the 2232 7-port serial card shipped with the
 	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
-- 
1.6.4.2

