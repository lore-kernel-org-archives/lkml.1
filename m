Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZKCPZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZKCPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZKCPZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:25:28 -0500
Received: from mail.atmel.fr ([81.80.104.162]:60177 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750751AbZKCPZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:25:26 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH 1/3] at91: remove not needed depends on
Date: Tue,  3 Nov 2009 17:30:54 +0100
Message-Id: <08f444c605fb38ee8b82821f28746b21ed06d9f7.1257263893.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com>
References: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Those "depends on" are a double check as all machine entries are
surrounded by "if <ARCH_xxx>" conditions.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
This patch series goes on top of previously posted patch named:
"[PATCH] at91: at91sam9g20ek modify dual slot evaluation kit"
http://lkml.org/lkml/2009/10/20/137
It is relative to discussion led during the patch posting and also
this one:
"[RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line"
http://lkml.org/lkml/2009/6/23/292

 arch/arm/mach-at91/Kconfig |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2fd8843..4301c6b 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -76,89 +76,76 @@ comment "AT91RM9200 Board Type"
 
 config MACH_ONEARM
 	bool "Ajeco 1ARM Single Board Computer"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Ajeco's 1ARM Single Board Computer.
 	  <http://www.ajeco.fi/products.htm>
 
 config ARCH_AT91RM9200DK
 	bool "Atmel AT91RM9200-DK Development board"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Atmel's AT91RM9200-DK Development board.
 	  (Discontinued)
 
 config MACH_AT91RM9200EK
 	bool "Atmel AT91RM9200-EK Evaluation Kit"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Atmel's AT91RM9200-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3507>
 
 config MACH_CSB337
 	bool "Cogent CSB337"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Cogent's CSB337 board.
 	  <http://www.cogcomp.com/csb_csb337.htm>
 
 config MACH_CSB637
 	bool "Cogent CSB637"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Cogent's CSB637 board.
 	  <http://www.cogcomp.com/csb_csb637.htm>
 
 config MACH_CARMEVA
 	bool "Conitec ARM&EVA"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Conitec's AT91RM9200-MCU-Module.
 	  <http://www.conitec.net/english/linuxboard.htm>
 
 config MACH_ATEB9200
 	bool "Embest ATEB9200"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Embest's ATEB9200 board.
 	  <http://www.embedinfo.com/english/product/ATEB9200.asp>
 
 config MACH_KB9200
 	bool "KwikByte KB920x"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using KwikByte's KB920x board.
 	  <http://kwikbyte.com/KB9202_description_new.htm>
 
 config MACH_PICOTUX2XX
 	bool "picotux 200"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using a picotux 200.
 	  <http://www.picotux.com/>
 
 config MACH_KAFA
 	bool "Sperry-Sun KAFA board"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using Sperry-Sun's KAFA board.
 
 config MACH_ECBAT91
 	bool "emQbit ECB_AT91 SBC"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using emQbit's ECB_AT91 board.
 	  <http://wiki.emqbit.com/free-ecb-at91>
 
 config MACH_YL9200
 	bool "ucDragon YL-9200"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using the ucDragon YL-9200 board.
 
 config MACH_CPUAT91
 	bool "Eukrea CPUAT91"
-	depends on ARCH_AT91RM9200
 	help
 	  Select this if you are using the Eukrea Electromatique's
 	  CPUAT91 board <http://www.eukrea.com/>.
@@ -173,7 +160,6 @@ comment "AT91SAM9260 Variants"
 
 config ARCH_AT91SAM9260_SAM9XE
 	bool "AT91SAM9XE"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using Atmel's AT91SAM9XE System-on-Chip.
 	  They are basically AT91SAM9260s with various sizes of embedded Flash.
@@ -182,28 +168,24 @@ comment "AT91SAM9260 / AT91SAM9XE Board Type"
 
 config MACH_AT91SAM9260EK
 	bool "Atmel AT91SAM9260-EK / AT91SAM9XE Evaluation Kit"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using Atmel's AT91SAM9260-EK or AT91SAM9XE Evaluation Kit
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3933>
 
 config MACH_CAM60
 	bool "KwikByte KB9260 (CAM60) board"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using KwikByte's KB9260 (CAM60) board based on the Atmel AT91SAM9260.
 	  <http://www.kwikbyte.com/KB9260.html>
 
 config MACH_SAM9_L9260
 	bool "Olimex SAM9-L9260 board"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using Olimex's SAM9-L9260 board based on the Atmel AT91SAM9260.
 	  <http://www.olimex.com/dev/sam9-L9260.html>
 
 config MACH_AFEB9260
 	bool "Custom afeb9260 board v1"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using custom afeb9260 board based on
 	  open hardware design. Select this for revision 1 of the board.
@@ -212,21 +194,18 @@ config MACH_AFEB9260
 
 config MACH_USB_A9260
 	bool "CALAO USB-A9260"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using a Calao Systems USB-A9260.
 	  <http://www.calao-systems.com>
 
 config MACH_QIL_A9260
 	bool "CALAO QIL-A9260 board"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using a Calao Systems QIL-A9260 Board.
 	  <http://www.calao-systems.com>
 
 config MACH_CPU9260
 	bool "Eukrea CPU9260 board"
-	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using a Eukrea Electromatique's
 	  CPU9260 Board <http://www.eukrea.com/>
@@ -241,7 +220,6 @@ comment "AT91SAM9261 Board Type"
 
 config MACH_AT91SAM9261EK
 	bool "Atmel AT91SAM9261-EK Evaluation Kit"
-	depends on ARCH_AT91SAM9261
 	help
 	  Select this if you are using Atmel's AT91SAM9261-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3820>
@@ -256,7 +234,6 @@ comment "AT91SAM9G10 Board Type"
 
 config MACH_AT91SAM9G10EK
 	bool "Atmel AT91SAM9G10-EK Evaluation Kit"
-	depends on ARCH_AT91SAM9G10
 	help
 	  Select this if you are using Atmel's AT91SAM9G10-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4588>
@@ -271,21 +248,18 @@ comment "AT91SAM9263 Board Type"
 
 config MACH_AT91SAM9263EK
 	bool "Atmel AT91SAM9263-EK Evaluation Kit"
-	depends on ARCH_AT91SAM9263
 	help
 	  Select this if you are using Atmel's AT91SAM9263-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4057>
 
 config MACH_USB_A9263
 	bool "CALAO USB-A9263"
-	depends on ARCH_AT91SAM9263
 	help
 	  Select this if you are using a Calao Systems USB-A9263.
 	  <http://www.calao-systems.com>
 
 config MACH_NEOCORE926
 	bool "Adeneo NEOCORE926"
-	depends on ARCH_AT91SAM9263
 	help
 	  Select this if you are using the Adeneo Neocore 926 board.
 
@@ -299,7 +273,6 @@ comment "AT91SAM9RL Board Type"
 
 config MACH_AT91SAM9RLEK
 	bool "Atmel AT91SAM9RL-EK Evaluation Kit"
-	depends on ARCH_AT91SAM9RL
 	help
 	  Select this if you are using Atmel's AT91SAM9RL-EK Evaluation Kit.
 
@@ -313,14 +286,12 @@ comment "AT91SAM9G20 Board Type"
 
 config MACH_AT91SAM9G20EK
 	bool "Atmel AT91SAM9G20-EK Evaluation Kit"
-	depends on ARCH_AT91SAM9G20
 	help
 	  Select this if you are using Atmel's AT91SAM9G20-EK Evaluation Kit
 	  that embeds only one SD/MMC slot.
 
 config MACH_AT91SAM9G20EK_2MMC
 	bool "Atmel AT91SAM9G20-EK Evaluation Kit with 2 SD/MMC Slots"
-	depends on ARCH_AT91SAM9G20
 	help
 	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
 	  with 2 SD/MMC Slots. This is the case for AT91SAM9G20-EK rev. C and
@@ -328,7 +299,6 @@ config MACH_AT91SAM9G20EK_2MMC
 
 config MACH_CPU9G20
 	bool "Eukrea CPU9G20 board"
-	depends on ARCH_AT91SAM9G20
 	help
 	  Select this if you are using a Eukrea Electromatique's
 	  CPU9G20 Board <http://www.eukrea.com/>
@@ -343,7 +313,6 @@ comment "AT91SAM9G45 Board Type"
 
 config MACH_AT91SAM9G45EKES
 	bool "Atmel AT91SAM9G45-EKES Evaluation Kit"
-	depends on ARCH_AT91SAM9G45
 	help
 	  Select this if you are using Atmel's AT91SAM9G45-EKES Evaluation Kit.
 	  "ES" at the end of the name means that this board is an
@@ -359,7 +328,6 @@ comment "AT91CAP9 Board Type"
 
 config MACH_AT91CAP9ADK
 	bool "Atmel AT91CAP9A-DK Evaluation Kit"
-	depends on ARCH_AT91CAP9
 	help
 	  Select this if you are using Atmel's AT91CAP9A-DK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4138>
-- 
1.5.6.5

