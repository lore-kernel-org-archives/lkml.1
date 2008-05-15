Return-Path: <linux-kernel-owner+w=401wt.eu-S1763587AbYEOSBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763587AbYEOSBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYEOSBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:01:25 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:44382 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYEOSBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:01:24 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Re: 2.6.26-rc2-mm1 - fix parenthesis in include/asm-mips/mach-au1x00/au1000.h
Date: Thu, 15 May 2008 20:01:23 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152001.23207.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parenthesis fix in include/asm-mips/mach-au1x00/au1000.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

diff -upr linux-2.6.26-rc2-mm1-a/include/asm-mips/mach-au1x00/au1000.h linux-2.6.26-rc2-mm1-b/include/asm-mips/mach-au1x00/au1000.h
--- linux-2.6.26-rc2-mm1-a/include/asm-mips/mach-au1x00/au1000.h	2008-05-15 19:44:48.000000000 +0200
+++ linux-2.6.26-rc2-mm1-b/include/asm-mips/mach-au1x00/au1000.h	2008-05-15 19:52:38.000000000 +0200
@@ -1036,7 +1036,7 @@ enum soc_au1200_ints {
 #define USBD_INTSTAT		0xB020001C
 #  define USBDEV_INT_SOF	(1 << 12)
 #  define USBDEV_INT_HF_BIT	6
-#  define USBDEV_INT_HF_MASK	0x3f << USBDEV_INT_HF_BIT)
+#  define USBDEV_INT_HF_MASK	(0x3f << USBDEV_INT_HF_BIT)
 #  define USBDEV_INT_CMPLT_BIT	0
 #  define USBDEV_INT_CMPLT_MASK (0x3f << USBDEV_INT_CMPLT_BIT)
 #define USBD_CONFIG		0xB0200020
