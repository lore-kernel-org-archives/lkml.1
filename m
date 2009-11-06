Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbZKFWF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbZKFWF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759944AbZKFWFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:54 -0500
Received: from kroah.org ([198.145.64.141]:39761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927AbZKFWFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:51 2009
Message-Id: <20091106215951.841486806@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [14/30] tty: Mark generic_serial users as BROKEN
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=tty-mark-generic_serial-users-as-broken.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 412145947adfca60a4b5b4893fbae82dffa25edd upstream.

There isn't much else I can do with these. I can find no hardware for any
of them and no users. The code is broken.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/m68k/Kconfig    |    6 +++---
 drivers/char/Kconfig |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -572,7 +572,7 @@ config HPAPCI
 
 config MVME147_SCC
 	bool "SCC support for MVME147 serial ports"
-	depends on MVME147
+	depends on MVME147 && BROKEN
 	help
 	  This is the driver for the serial ports on the Motorola MVME147
 	  boards.  Everyone using one of these boards should say Y here.
@@ -587,14 +587,14 @@ config SERIAL167
 
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
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -310,7 +310,7 @@ config SPECIALIX
 
 config SX
 	tristate "Specialix SX (and SI) card support"
-	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA) && BROKEN
 	help
 	  This is a driver for the SX and SI multiport serial cards.
 	  Please read the file <file:Documentation/sx.txt> for details.
@@ -321,7 +321,7 @@ config SX
 
 config RIO
 	tristate "Specialix RIO system support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && BROKEN
 	help
 	  This is a driver for the Specialix RIO, a smart serial card which
 	  drives an outboard box that can support up to 128 ports.  Product
@@ -382,7 +382,7 @@ config NOZOMI
 
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
+	depends on EXPERIMENTAL && ZORRO && BROKEN
 	---help---
 	  This option supports the 2232 7-port serial card shipped with the
 	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At


