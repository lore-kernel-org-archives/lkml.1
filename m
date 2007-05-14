Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbXENWxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbXENWxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbXENWxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:53:23 -0400
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:49133 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbXENWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:53:22 -0400
From: Frank Seidel <frank@kernalert.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Trivial string form cleanups
Date: Tue, 15 May 2007 00:53:11 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705150053.11606.frank@kernalert.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change of string form like Jeff Garzik suggested
it at http://janitor.kernelnewbies.org/TODO
to get better assembly output as this format only
declares a single variable.

Signed-off-by: Frank Seidel <frank@kernalert.de>

---
 arch/ppc/platforms/4xx/xilinx_ml300.c |    2 +-
 arch/ppc/platforms/4xx/xilinx_ml403.c |    2 +-
 drivers/atm/fore200e_mkfirm.c         |    6 +++---
 drivers/net/cris/eth_v10.c            |    2 +-
 drivers/net/fs_enet/mii-fec.c         |    2 +-
 drivers/net/isa-skeleton.c            |    4 ++--
 drivers/net/wan/c101.c                |    4 ++--
 drivers/net/wan/hdlc.c                |    2 +-
 drivers/net/wan/n2.c                  |    4 ++--
 drivers/net/wan/pc300too.c            |    4 ++--
 drivers/net/wan/pci200syn.c           |    4 ++--
 drivers/net/wan/sdla.c                |    2 +-
 drivers/net/wan/wanxl.c               |    2 +-
 drivers/sbus/char/bpp.c               |    2 +-
 14 files changed, 21 insertions(+), 21 deletions(-)

Index: b/drivers/net/wan/n2.c
===================================================================
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -33,8 +33,8 @@
 #include "hd64570.h"
 
 
-static const char* version = "SDL RISCom/N2 driver version: 1.15";
-static const char* devname = "RISCom/N2";
+static const char version[] = "SDL RISCom/N2 driver version: 1.15";
+static const char devname[] = "RISCom/N2";
 
 #undef DEBUG_PKT
 #define DEBUG_RINGS
Index: b/arch/ppc/platforms/4xx/xilinx_ml300.c
===================================================================
--- a/arch/ppc/platforms/4xx/xilinx_ml300.c
+++ b/arch/ppc/platforms/4xx/xilinx_ml300.c
@@ -53,7 +53,7 @@
  *          ppc4xx_pic_init			arch/ppc/syslib/xilinx_pic.c
  */
 
-const char* virtex_machine_name = "ML300 Reference Design";
+const char virtex_machine_name[] = "ML300 Reference Design";
 
 #if defined(XPAR_POWER_0_POWERDOWN_BASEADDR)
 static volatile unsigned *powerdown_base =
Index: b/arch/ppc/platforms/4xx/xilinx_ml403.c
===================================================================
--- a/arch/ppc/platforms/4xx/xilinx_ml403.c
+++ b/arch/ppc/platforms/4xx/xilinx_ml403.c
@@ -55,7 +55,7 @@
  *          ppc4xx_pic_init			arch/ppc/syslib/xilinx_pic.c
  */
 
-const char* virtex_machine_name = "ML403 Reference Design";
+const char virtex_machine_name[] = "ML403 Reference Design";
 
 #if defined(XPAR_POWER_0_POWERDOWN_BASEADDR)
 static volatile unsigned *powerdown_base =
Index: b/drivers/net/wan/sdla.c
===================================================================
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -57,7 +57,7 @@
 #include <asm/dma.h>
 #include <asm/uaccess.h>
 
-static const char* version = "SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org";
+static const char version[] = "SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org";
 
 static unsigned int valid_port[] = { 0x250, 0x270, 0x280, 0x300, 0x350, 0x360, 0x380, 0x390};
 
Index: b/drivers/net/wan/wanxl.c
===================================================================
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -32,7 +32,7 @@
 
 #include "wanxl.h"
 
-static const char* version = "wanXL serial card driver version: 0.48";
+static const char version[] = "wanXL serial card driver version: 0.48";
 
 #define PLX_CTL_RESET   0x40000000 /* adapter reset */
 
Index: b/drivers/net/wan/c101.c
===================================================================
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -30,8 +30,8 @@
 #include "hd64570.h"
 
 
-static const char* version = "Moxa C101 driver version: 1.15";
-static const char* devname = "C101";
+static const char version[] = "Moxa C101 driver version: 1.15";
+static const char devname[] = "C101";
 
 #undef DEBUG_PKT
 #define DEBUG_RINGS
Index: b/drivers/net/wan/hdlc.c
===================================================================
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -38,7 +38,7 @@
 #include <linux/hdlc.h>
 
 
-static const char* version = "HDLC support module revision 1.21";
+static const char version[] = "HDLC support module revision 1.21";
 
 #undef DEBUG_LINK
 
Index: b/drivers/net/wan/pci200syn.c
===================================================================
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -33,8 +33,8 @@
 
 #include "hd64572.h"
 
-static const char* version = "Goramo PCI200SYN driver version: 1.16";
-static const char* devname = "PCI200SYN";
+static const char version[] = "Goramo PCI200SYN driver version: 1.16";
+static const char devname[] = "PCI200SYN";
 
 #undef DEBUG_PKT
 #define DEBUG_RINGS
Index: b/drivers/net/wan/pc300too.c
===================================================================
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -37,8 +37,8 @@
 
 #include "hd64572.h"
 
-static const char* version = "Cyclades PC300 driver version: 1.17";
-static const char* devname = "PC300";
+static const char version[] = "Cyclades PC300 driver version: 1.17";
+static const char devname[] = "PC300";
 
 #undef DEBUG_PKT
 #define DEBUG_RINGS
Index: b/drivers/net/isa-skeleton.c
===================================================================
--- a/drivers/net/isa-skeleton.c
+++ b/drivers/net/isa-skeleton.c
@@ -22,7 +22,7 @@
  *
  */
 
-static const char *version =
+static const char version[] =
 	"isa-skeleton.c:v1.51 9/24/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\n";
 
 /*
@@ -65,7 +65,7 @@ static const char *version =
  * The name of the card. Is used for messages and in the requests for
  * io regions, irqs and dma channels
  */
-static const char* cardname = "netcard";
+static const char cardname[] = "netcard";
 
 /* First, a few definitions that the brave might change. */
 
Index: b/drivers/net/fs_enet/mii-fec.c
===================================================================
--- a/drivers/net/fs_enet/mii-fec.c
+++ b/drivers/net/fs_enet/mii-fec.c
@@ -66,7 +66,7 @@ static int fs_mii_fec_init(struct fec_in
 {
 	struct resource *r;
 	fec_t *fecp;
-	char* name = "fsl-cpm-fec";
+	char name[] = "fsl-cpm-fec";
 
 	/* we need fec in order to be useful */
 	struct platform_device *fec_pdev =
Index: b/drivers/net/cris/eth_v10.c
===================================================================
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -259,7 +259,7 @@
  * io regions, irqs and dma channels
  */
 
-static const char* cardname = "ETRAX 100LX built-in ethernet controller";
+static const char cardname[] = "ETRAX 100LX built-in ethernet controller";
 
 /* A default ethernet address. Highlevel SW will set the real one later */
 
Index: b/drivers/sbus/char/bpp.c
===================================================================
--- a/drivers/sbus/char/bpp.c
+++ b/drivers/sbus/char/bpp.c
@@ -41,7 +41,7 @@
 #define BPP_DELAY 100
 
 static const unsigned  BPP_MAJOR = LP_MAJOR;
-static const char* dev_name = "bpp";
+static const char dev_name[] = "bpp";
 
 /* When switching from compatibility to a mode where I can read, try
    the following mode first. */
Index: b/drivers/atm/fore200e_mkfirm.c
===================================================================
--- a/drivers/atm/fore200e_mkfirm.c
+++ b/drivers/atm/fore200e_mkfirm.c
@@ -14,9 +14,9 @@
 #include <sys/types.h>
 #include <time.h>
 
-char* default_basename = "pca200e"; /* was initially written for the PCA-200E firmware */
-char* default_infname  = "<stdin>";
-char* default_outfname = "<stdout>";
+char default_basename[] = "pca200e"; /* was initially written for the PCA-200E firmware */
+char default_infname[]  = "<stdin>";
+char default_outfname[] = "<stdout>";
 
 char* progname;
 int   verbose  = 0;
