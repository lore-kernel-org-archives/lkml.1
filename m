Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbXCOWJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbXCOWJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXCOWJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:09:45 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3628 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbXCOWJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:09:44 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] blackfin: balance parenthesis in macros
Date: Thu, 15 Mar 2007 23:12:21 +0100
User-Agent: KMail/1.9.5
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152312.21981.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch (against 2.6.21-rc3-mm1) balances parenthesis in blackfin
header files.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/asm-blackfin/mach-bf535/bf535.h |    4 ++--
 include/asm-blackfin/scatterlist.h      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -u linux-2.6.21-rc3-mm1-a/include/asm-blackfin/mach-bf535/bf535.h linux-2.6.21-rc3-mm1-b/include/asm-blackfin/mach-bf535/bf535.h
--- linux-2.6.21-rc3-mm1-a/include/asm-blackfin/mach-bf535/bf535.h	2007-03-15 22:25:34.000000000 +0100
+++ linux-2.6.21-rc3-mm1-b/include/asm-blackfin/mach-bf535/bf535.h	2007-03-15 22:33:09.000000000 +0100
@@ -224,7 +224,7 @@
 #define UART0_LSR_TEMT			0x40	/* TSR and UARTx_thr both empty */
 
 #define UART0_MSR_ADDR		0xffc0180c	/* UART 0 Modem status register  16 bit */
-#define UART0_MSR			HALFWORD_REF(UART0_MSR_ADDR
+#define UART0_MSR			HALFWORD_REF(UART0_MSR_ADDR)
 #define UART0_SCR_ADDR		0xffc0180e	/* UART 0 Scratch register  16 bit */
 #define UART0_SCR			HALFWORD_REF(UART0_SCR_ADDR)
 #define UART0_IRCR_ADDR		0xffc01810	/* UART 0 IrDA Control register  16 bit */
@@ -331,7 +331,7 @@
 #define UART1_LSR_TEMT          0x40	/* TSR and UARTx_thr both empty */
 
 #define UART1_MSR_ADDR		0xffc01c0c	/* UART 1 Modem status register  16 bit */
-#define UART1_MSR			HALFWORD_REF(UART1_MSR_ADDR
+#define UART1_MSR			HALFWORD_REF(UART1_MSR_ADDR)
 #define UART1_SCR_ADDR		0xffc01c0e	/* UART 1 Scratch register  16 bit */
 #define UART1_SCR			HALFWORD_REF(UART1_SCR_ADDR)
 
diff -upr linux-2.6.21-rc3-mm1-a/include/asm-blackfin/scatterlist.h linux-2.6.21-rc3-mm1-b/include/asm-blackfin/scatterlist.h
--- linux-2.6.21-rc3-mm1-a/include/asm-blackfin/scatterlist.h	2007-03-15 22:25:34.000000000 +0100
+++ linux-2.6.21-rc3-mm1-b/include/asm-blackfin/scatterlist.h	2007-03-15 22:30:18.000000000 +0100
@@ -17,7 +17,7 @@ struct scatterlist {
  * returns, or alternatively stop on the first sg_dma_len(sg) which
  * is 0.
  */
-#define sg_address(sg) (page_address((sg)->page) + (sg)->offset
+#define sg_address(sg) (page_address((sg)->page) + (sg)->offset)
 #define sg_dma_address(sg)      ((sg)->dma_address)
 #define sg_dma_len(sg)          ((sg)->length)



Regards,

	Mariusz Kozlowski

