Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZCEHS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZCEHS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZCEHST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:18:19 -0500
Received: from smtp104.biz.mail.mud.yahoo.com ([68.142.200.252]:27234 "HELO
	smtp104.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750711AbZCEHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:18:19 -0500
X-YMail-OSG: tez7SMMVM1l3EpKzbNDxnuoio3_L1QBNozY43LNydCQ6QM0SE7jSXGxP7y6FjgLg1XQ758Dlf.exUiQEhopq7phwO.Cu_2U7V1F.eryLEjzA2bFUvGWgdBU0TRbOHgsQ9nvOAI1xucRorZFVSHQIKD7jj2hz6lZ4UYAiOhHH4iechii3R5lUJZ2AOe3EYUX8.SOaVYBBuhHoxYZ4gj8nIYxeszx5QLXW2GQ_gYwW3W04vdY-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: uclinux-dev@uclinux.org
Subject: [PATCH] m68knommu: m532x build fix.
Date: Wed, 4 Mar 2009 23:10:10 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903042310.11063.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m532xsim.h 
b/arch/m68k/include/asm/m532xsim.h
index 1835fd2..e13903a 100644
--- a/arch/m68k/include/asm/m532xsim.h
+++ b/arch/m68k/include/asm/m532xsim.h
@@ -16,6 +16,7 @@
 #define MCFINT_VECBASE      64
 #define MCFINT_UART0        26          /* Interrupt number for UART0 */
 #define MCFINT_UART1        27          /* Interrupt number for UART1 */
+#define MCFINT_UART2        28          /* Interrupt number for UART2 */
 
 #define MCF_WTM_WCR	MCF_REG16(0xFC098000)
 
