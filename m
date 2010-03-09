Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0CIRWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:30 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54673 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0CIRW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:27 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 03/13] serial: bfin_sport_uart: remove unused peripheral pin lists
Date: Tue,  9 Mar 2010 12:25:30 -0500
Message-Id: <1268155540-8241-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

All the resources are in the boards files now.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index c34f02c..8b0df19 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -38,27 +38,6 @@
 
 #include "bfin_sport_uart.h"
 
-#ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
-unsigned short bfin_uart_pin_req_sport0[] =
-	{P_SPORT0_TFS, P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS, \
-	 P_SPORT0_DRPRI, P_SPORT0_RSCLK, P_SPORT0_DRSEC, P_SPORT0_DTSEC, 0};
-#endif
-#ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
-unsigned short bfin_uart_pin_req_sport1[] =
-	{P_SPORT1_TFS, P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, \
-	P_SPORT1_DRPRI, P_SPORT1_RSCLK, P_SPORT1_DRSEC, P_SPORT1_DTSEC, 0};
-#endif
-#ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
-unsigned short bfin_uart_pin_req_sport2[] =
-	{P_SPORT2_TFS, P_SPORT2_DTPRI, P_SPORT2_TSCLK, P_SPORT2_RFS, \
-	P_SPORT2_DRPRI, P_SPORT2_RSCLK, P_SPORT2_DRSEC, P_SPORT2_DTSEC, 0};
-#endif
-#ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
-unsigned short bfin_uart_pin_req_sport3[] =
-	{P_SPORT3_TFS, P_SPORT3_DTPRI, P_SPORT3_TSCLK, P_SPORT3_RFS, \
-	P_SPORT3_DRPRI, P_SPORT3_RSCLK, P_SPORT3_DRSEC, P_SPORT3_DTSEC, 0};
-#endif
-
 struct sport_uart_port {
 	struct uart_port	port;
 	int			err_irq;
-- 
1.7.0.2

