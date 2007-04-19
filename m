Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXDSLPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXDSLPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030949AbXDSLPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:15:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53826 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXDSLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=r+h5eurb54ejaIjHrB4yo6BNazuRyHx/yaVOc/zlFbItSbPQNpB7sYlmMVnFd3DPCUViTpP/eGukL9vVtdvq7lgyZiS4esarGBq34RX/sAAlEBFrN3fukKC6VgCMsXJmcPr0pYdGdae8g1vscVbiCKrOzXvD9WaQxA6zYaAaeWQ=
Date: Thu, 19 Apr 2007 16:47:41 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>,
       SERIAL <linux-serial@vger.kernel.org>
Cc: Andrw Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, galak@kernel.crashing.org,
       panto@intracom.gr, ben@simtec.co.uk
Subject: [KJ][PATCH]SPIN_LOCK_UNLOCKED cleanup in drivers/serial
Message-ID: <20070419111741.GA11493@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead 

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
---

 cpm_uart/cpm_uart_core.c |   12 ++++++------
 s3c2410.c                |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index 7a3b97f..f23972b 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -934,7 +934,7 @@ struct uart_cpm_port cpm_uart_ports[UART_NR] = {
 			.irq		= SMC1_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SMC1].port.lock),
 		},
 		.flags = FLAG_SMC,
 		.tx_nrfifos = TX_NUM_FIFO,
@@ -948,7 +948,7 @@ struct uart_cpm_port cpm_uart_ports[UART_NR] = {
 			.irq		= SMC2_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SMC2].port.lock),
 		},
 		.flags = FLAG_SMC,
 		.tx_nrfifos = TX_NUM_FIFO,
@@ -965,7 +965,7 @@ struct uart_cpm_port cpm_uart_ports[UART_NR] = {
 			.irq		= SCC1_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC1].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
@@ -979,7 +979,7 @@ struct uart_cpm_port cpm_uart_ports[UART_NR] = {
 			.irq		= SCC2_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC2].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
@@ -993,7 +993,7 @@ struct uart_cpm_port cpm_uart_ports[UART_NR] = {
 			.irq		= SCC3_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC3].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
@@ -1007,7 +1007,7 @@ struct uart_cpm_port cpm_uart_ports[UART_NR] = {
 			.irq		= SCC4_IRQ,
 			.ops		= &cpm_uart_pops,
 			.iotype		= UPIO_MEM,
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(cpm_uart_ports[UART_SCC4].port.lock),
 		},
 		.tx_nrfifos = TX_NUM_FIFO,
 		.tx_fifosize = TX_BUF_SIZE,
diff --git a/drivers/serial/s3c2410.c b/drivers/serial/s3c2410.c
index 3ba9208..10bc020 100644
--- a/drivers/serial/s3c2410.c
+++ b/drivers/serial/s3c2410.c
@@ -957,7 +957,7 @@ static struct uart_driver s3c24xx_uart_drv = {
 static struct s3c24xx_uart_port s3c24xx_serial_ports[NR_PORTS] = {
 	[0] = {
 		.port = {
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(s3c24xx_serial_ports[0].port.lock),
 			.iotype		= UPIO_MEM,
 			.irq		= IRQ_S3CUART_RX0,
 			.uartclk	= 0,
@@ -969,7 +969,7 @@ static struct s3c24xx_uart_port s3c24xx_serial_ports[NR_PORTS] = {
 	},
 	[1] = {
 		.port = {
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(s3c24xx_serial_ports[1].port.lock),
 			.iotype		= UPIO_MEM,
 			.irq		= IRQ_S3CUART_RX1,
 			.uartclk	= 0,
@@ -983,7 +983,7 @@ static struct s3c24xx_uart_port s3c24xx_serial_ports[NR_PORTS] = {
 
 	[2] = {
 		.port = {
-			.lock		= SPIN_LOCK_UNLOCKED,
+			.lock		= __SPIN_LOCK_UNLOCKED(s3c24xx_serial_ports[2].port.lock),
 			.iotype		= UPIO_MEM,
 			.irq		= IRQ_S3CUART_RX2,
 			.uartclk	= 0,
-- 
Milind Arun Choudhary
