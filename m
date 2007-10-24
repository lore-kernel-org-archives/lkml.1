Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXJXCHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXJXCHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXJXCEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:38 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34310 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755641AbXJXCEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:37 -0400
Date: Wed, 24 Oct 2007 12:03:52 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23qJp016676@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH]: add port definition for mcf UART driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a port type definition for the Freescale UART driver ports (mcf.c).

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-git19/include/linux/serial_core.h linux-2.6.23-git19.hacked/include/linux/serial_core.h
--- linux-2.6.23-git19/include/linux/serial_core.h	2007-10-24 11:21:19.000000000 +1000
+++ linux-2.6.23-git19.hacked/include/linux/serial_core.h	2007-10-24 11:47:48.000000000 +1000
@@ -146,6 +146,9 @@
 /* Broadcom SB1250, etc. SOC */
 #define PORT_SB1250_DUART	77
 
+/* Freescale ColdFire */
+#define PORT_MCF	78
+
 
 #ifdef __KERNEL__
 
