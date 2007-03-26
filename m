Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbXCZKL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbXCZKL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXCZKL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:11:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2981 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbXCZKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:11:25 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="25489784:sNHT32974382"
Subject: [PATCH -mm] Blackfin arch: fix reboot kernel mounting spi flash
	print error bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:11:57 +0800
Message-Id: <1174903917.32691.66.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This patch fix a printing error bug when reboot kernel mounting on SPI
flash.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c        |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/blackfin/mach-bf533/boards/cm_bf533.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ linux-2.6/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -57,7 +57,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
Index: linux-2.6/arch/blackfin/mach-bf533/boards/ezkit.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf533/boards/ezkit.c
+++ linux-2.6/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -91,7 +91,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
Index: linux-2.6/arch/blackfin/mach-bf533/boards/stamp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf533/boards/stamp.c
+++ linux-2.6/arch/blackfin/mach-bf533/boards/stamp.c
@@ -114,7 +114,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
Index: linux-2.6/arch/blackfin/mach-bf537/boards/cm_bf537.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -59,7 +59,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
Index: linux-2.6/arch/blackfin/mach-bf537/boards/generic_board.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/generic_board.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -259,7 +259,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
Index: linux-2.6/arch/blackfin/mach-bf537/boards/pnav10.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/pnav10.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -244,7 +244,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
Index: linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/stamp.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c
@@ -293,7 +293,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
Index: linux-2.6/arch/blackfin/mach-bf561/boards/cm_bf561.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ linux-2.6/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -58,7 +58,7 @@
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
_

Thanks
-Bryan
