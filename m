Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZCKV7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZCKV7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZCKV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:11 -0400
Received: from smtp106.biz.mail.mud.yahoo.com ([68.142.200.254]:33236 "HELO
	smtp106.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751968AbZCKV6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:09 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: dqm8ae0VM1kR_j.VxzA9Y0oQj13vaZWvxLCH5xtPfB.2mghqfLJmI450XKdL7dGVB3qOkWbV0iCrvj.YcBJK6luTdiLCV2LamRD9vk0THVkXvpwgy5z.Kj7J4Odflc220ykiaysu6PqRKowkrCfuHuA90oTvZQCPDZ0yd7owrXOxkg6ovp_xm8KGvqKZfWkduCu3Yy05lVdR3Tf7HhjdUgwTouP2VDt8q048VUS8JQ5p51M-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 05/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:55:56 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111455.56840.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m523xsim.h b/arch/m68k/include/asm/m523xsim.h
index bf39731..d06dd22 100644
--- a/arch/m68k/include/asm/m523xsim.h
+++ b/arch/m68k/include/asm/m523xsim.h
@@ -41,5 +41,82 @@
 #define	MCFSIM_DACR1		0x50		/* SDRAM base address 1 */
 #define	MCFSIM_DMR1		0x54		/* SDRAM address mask 1 */
 
+#define MCFGPIO_PODR_ADDR	(MCF_IPSBAR + 0x100000)
+#define MCFGPIO_PODR_DATAH	(MCF_IPSBAR + 0x100001)
+#define MCFGPIO_PODR_DATAL	(MCF_IPSBAR + 0x100002)
+#define MCFGPIO_PODR_BUSCTL	(MCF_IPSBAR + 0x100003)
+#define MCFGPIO_PODR_BS		(MCF_IPSBAR + 0x100004)
+#define MCFGPIO_PODR_CS		(MCF_IPSBAR + 0x100005)
+#define MCFGPIO_PODR_SDRAM	(MCF_IPSBAR + 0x100006)
+#define MCFGPIO_PODR_FECI2C	(MCF_IPSBAR + 0x100007)
+#define MCFGPIO_PODR_UARTH	(MCF_IPSBAR + 0x100008)
+#define MCFGPIO_PODR_UARTL	(MCF_IPSBAR + 0x100009)
+#define MCFGPIO_PODR_QSPI	(MCF_IPSBAR + 0x10000A)
+#define MCFGPIO_PODR_TIMER	(MCF_IPSBAR + 0x10000B)
+#define MCFGPIO_PODR_ETPU	(MCF_IPSBAR + 0x10000C)
+
+#define MCFGPIO_PDDR_ADDR	(MCF_IPSBAR + 0x100010)
+#define MCFGPIO_PDDR_DATAH	(MCF_IPSBAR + 0x100011)
+#define MCFGPIO_PDDR_DATAL	(MCF_IPSBAR + 0x100012)
+#define MCFGPIO_PDDR_BUSCTL	(MCF_IPSBAR + 0x100013)
+#define MCFGPIO_PDDR_BS		(MCF_IPSBAR + 0x100014)
+#define MCFGPIO_PDDR_CS		(MCF_IPSBAR + 0x100015)
+#define MCFGPIO_PDDR_SDRAM	(MCF_IPSBAR + 0x100016)
+#define MCFGPIO_PDDR_FECI2C	(MCF_IPSBAR + 0x100017)
+#define MCFGPIO_PDDR_UARTH	(MCF_IPSBAR + 0x100018)
+#define MCFGPIO_PDDR_UARTL	(MCF_IPSBAR + 0x100019)
+#define MCFGPIO_PDDR_QSPI	(MCF_IPSBAR + 0x10001A)
+#define MCFGPIO_PDDR_TIMER	(MCF_IPSBAR + 0x10001B)
+#define MCFGPIO_PDDR_ETPU	(MCF_IPSBAR + 0x10001C)
+
+#define MCFGPIO_PPDSDR_ADDR	(MCF_IPSBAR + 0x100020)
+#define MCFGPIO_PPDSDR_DATAH	(MCF_IPSBAR + 0x100021)
+#define MCFGPIO_PPDSDR_DATAL	(MCF_IPSBAR + 0x100022)
+#define MCFGPIO_PPDSDR_BUSCTL	(MCF_IPSBAR + 0x100023)
+#define MCFGPIO_PPDSDR_BS	(MCF_IPSBAR + 0x100024)
+#define MCFGPIO_PPDSDR_CS	(MCF_IPSBAR + 0x100025)
+#define MCFGPIO_PPDSDR_SDRAM	(MCF_IPSBAR + 0x100026)
+#define MCFGPIO_PPDSDR_FECI2C	(MCF_IPSBAR + 0x100027)
+#define MCFGPIO_PPDSDR_UARTH	(MCF_IPSBAR + 0x100028)
+#define MCFGPIO_PPDSDR_UARTL	(MCF_IPSBAR + 0x100029)
+#define MCFGPIO_PPDSDR_QSPI	(MCF_IPSBAR + 0x10002A)
+#define MCFGPIO_PPDSDR_TIMER	(MCF_IPSBAR + 0x10002B)
+#define MCFGPIO_PPDSDR_ETPU	(MCF_IPSBAR + 0x10002C)
+
+#define MCFGPIO_PCLRR_ADDR	(MCF_IPSBAR + 0x100030)
+#define MCFGPIO_PCLRR_DATAH	(MCF_IPSBAR + 0x100031)
+#define MCFGPIO_PCLRR_DATAL	(MCF_IPSBAR + 0x100032)
+#define MCFGPIO_PCLRR_BUSCTL	(MCF_IPSBAR + 0x100033)
+#define MCFGPIO_PCLRR_BS	(MCF_IPSBAR + 0x100034)
+#define MCFGPIO_PCLRR_CS	(MCF_IPSBAR + 0x100035)
+#define MCFGPIO_PCLRR_SDRAM	(MCF_IPSBAR + 0x100036)
+#define MCFGPIO_PCLRR_FECI2C	(MCF_IPSBAR + 0x100037)
+#define MCFGPIO_PCLRR_UARTH	(MCF_IPSBAR + 0x100038)
+#define MCFGPIO_PCLRR_UARTL	(MCF_IPSBAR + 0x100039)
+#define MCFGPIO_PCLRR_QSPI	(MCF_IPSBAR + 0x10003A)
+#define MCFGPIO_PCLRR_TIMER	(MCF_IPSBAR + 0x10003B)
+#define MCFGPIO_PCLRR_ETPU	(MCF_IPSBAR + 0x10003C)
+
+/*
+ * EPort
+ */
+
+#define MCFEPORT_EPDDR		(MCF_IPSBAR + 0x130002)
+#define MCFEPORT_EPDR		(MCF_IPSBAR + 0x130004)
+#define MCFEPORT_EPPDR		(MCF_IPSBAR + 0x130005)
+
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PODR			MCFGPIO_PODR_ADDR
+#define MCFGPIO_PDDR			MCFGPIO_PDDR_ADDR
+#define MCFGPIO_PPDR			MCFGPIO_PPDSDR_ADDR
+#define MCFGPIO_SETR			MCFGPIO_PPDSDR_ADDR
+#define MCFGPIO_CLRR			MCFGPIO_PCLRR_ADDR
+
+#define MCFGPIO_PIN_MAX			107
+#define MCFGPIO_IRQ_MAX			8
+#define MCFGPIO_IRQ_VECBASE		MCFINT_VECBASE
+
 /****************************************************************************/
 #endif	/* m523xsim_h */
