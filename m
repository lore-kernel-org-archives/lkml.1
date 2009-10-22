Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbZJVWNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbZJVWNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932196AbZJVWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:13:14 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56742 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbZJVWNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:13:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX188IjG50V38bi9Zbk4/Sfut
Subject: [PATCH 10/10] omap4: Fix UART4 platform data on omap4
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2009 15:13:14 -0700
Message-ID: <20091022221314.27408.99866.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

This patch removes the unnecessary UART4 platform which is under
data is wrong because of this

There is a separate platform structure for UART4

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-By: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/serial.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index ae21868..54dfeb5 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -109,16 +109,6 @@ static struct plat_serial8250_port serial_platform_data2[] = {
 		.regshift	= 2,
 		.uartclk	= OMAP24XX_BASE_BAUD * 16,
 	}, {
-#ifdef CONFIG_ARCH_OMAP4
-		.membase	= OMAP2_IO_ADDRESS(OMAP_UART4_BASE),
-		.mapbase	= OMAP_UART4_BASE,
-		.irq		= 70,
-		.flags		= UPF_BOOT_AUTOCONF,
-		.iotype		= UPIO_MEM,
-		.regshift	= 2,
-		.uartclk	= OMAP24XX_BASE_BAUD * 16,
-	}, {
-#endif
 		.flags		= 0
 	}
 };

