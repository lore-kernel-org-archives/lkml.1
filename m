Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab0CEXVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:21:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49149 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336Ab0CEXVt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:21:49 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>
In-Reply-To: <1267831063.2819.361.camel@localhost>
References: <1267831063.2819.361.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 05 Mar 2010 23:21:45 +0000
Message-ID: <1267831305.2819.363.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCHv2 1/2] firmware: Remove Sierra Wireless CIS files
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contrary to the text in WHENCE, these files have nothing to do with
the pcmcia-cs project and are distributed by Sierra Wireless under
GPLv3.  Rather than confusing people by adding the text of the GPLv3,
remove them.  They will still be available from the linux-firmware
repository.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/Makefile                |    4 +---
 firmware/WHENCE                  |    3 ---
 firmware/cis/SW_555_SER.cis.ihex |   12 ------------
 firmware/cis/SW_7xx_SER.cis.ihex |   13 -------------
 firmware/cis/SW_8xx_SER.cis.ihex |   13 -------------
 5 files changed, 1 insertions(+), 44 deletions(-)
 delete mode 100644 firmware/cis/SW_555_SER.cis.ihex
 delete mode 100644 firmware/cis/SW_7xx_SER.cis.ihex
 delete mode 100644 firmware/cis/SW_8xx_SER.cis.ihex

diff --git a/firmware/Makefile b/firmware/Makefile
index 8af0fc7..87952aa 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -74,9 +74,7 @@ fw-shipped-$(CONFIG_PCMCIA_PCNET) += cis/LA-PCM.cis cis/PCMLM28.cis \
 fw-shipped-$(CONFIG_PCMCIA_3C589) += cis/3CXEM556.cis
 fw-shipped-$(CONFIG_PCMCIA_3C574) += cis/3CCFEM556.cis
 fw-shipped-$(CONFIG_SERIAL_8250_CS) += cis/MT5634ZLX.cis cis/RS-COM-2P.cis \
-				       cis/COMpad2.cis cis/COMpad4.cis \
-				       cis/SW_555_SER.cis cis/SW_7xx_SER.cis \
-				       cis/SW_8xx_SER.cis
+				       cis/COMpad2.cis cis/COMpad4.cis
 fw-shipped-$(CONFIG_PCMCIA_SMC91C92) += ositech/Xilinx7OD.bin
 fw-shipped-$(CONFIG_SCSI_ADVANSYS) += advansys/mcode.bin advansys/38C1600.bin \
 				      advansys/3550.bin advansys/38C0800.bin
diff --git a/firmware/WHENCE b/firmware/WHENCE
index e8e550f..fbee146 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -635,9 +635,6 @@ File: cis/MT5634ZLX.cis
       cis/RS-COM-2P.cis
       cis/COMpad2.cis
       cis/COMpad4.cis
-      cis/SW_555_SER.cis
-      cis/SW_7xx_SER.cis
-      cis/SW_8xx_SER.cis
 
 Licence: GPL
 
diff --git a/firmware/cis/SW_555_SER.cis.ihex b/firmware/cis/SW_555_SER.cis.ihex
deleted file mode 100644
index 9b9348a..0000000
--- a/firmware/cis/SW_555_SER.cis.ihex
+++ /dev/null
@@ -1,12 +0,0 @@
-:100000000101FF17034100FF20043F0110072102F7
-:100010000200152A070053696572726120576972E0
-:10002000656C657373004169724361726420353594
-:1000300035004135353500526576203100FF1A050F
-:1000400001030007731B0BE00118A360F8030730DE
-:10005000BC3F1B08A10108A360F802071B08A2010E
-:1000600008A360E803071B08A30108A360E80207D0
-:0A0070001B04A40108231400FF0084
-:00000001FF
-#
-# Replacement CIS for AC555 provided by Sierra Wireless
-#
diff --git a/firmware/cis/SW_7xx_SER.cis.ihex b/firmware/cis/SW_7xx_SER.cis.ihex
deleted file mode 100644
index 11e44ad..0000000
--- a/firmware/cis/SW_7xx_SER.cis.ihex
+++ /dev/null
@@ -1,13 +0,0 @@
-:100000000101FF17034100FF2004920110072102A4
-:1000100002001537070053696572726120576972D3
-:10002000656C6573730041433731302F4143373579
-:10003000300047505253204E6574776F726B2041E9
-:1000400064617074657200523100FF1A050103008B
-:1000500007731B10E00119784D555D25A360F80367
-:100060000730BC861B08A10108A360F802071B0823
-:10007000A20108A360E803071B08A30108A360E826
-:0C00800002071B04A40108231400FF0069
-:00000001FF
-#
-# Replacement CIS for AC7xx provided by Sierra Wireless
-#
diff --git a/firmware/cis/SW_8xx_SER.cis.ihex b/firmware/cis/SW_8xx_SER.cis.ihex
deleted file mode 100644
index bbcfe63..0000000
--- a/firmware/cis/SW_8xx_SER.cis.ihex
+++ /dev/null
@@ -1,13 +0,0 @@
-:100000000101FF17034100FF2004920110072102A4
-:100010000200152F070053696572726120576972DB
-:10002000656C657373004143383530003347204EAB
-:100030006574776F726B20416461707465720052F1
-:100040003100FF1A0501030007731B10E001197846
-:100050004D555D25A360F8480730BC861B08A101FB
-:1000600008A360F847071B08A20108A360E8480737
-:100070001B08A30108A360E847071B04A401082389
-:040080001400FF0069
-:00000001FF
-#
-# Replacement CIS for AC8xx provided by Sierra Wireless
-#
-- 
1.6.6.2


