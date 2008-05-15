Return-Path: <linux-kernel-owner+w=401wt.eu-S1764627AbYEOSAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764627AbYEOSAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760864AbYEOR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:59:55 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:44350 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbYEOR7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:59:54 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Re: 2.6.26-rc2-mm1 - fix parenthesis in include/asm-mips/gic.h
Date: Thu, 15 May 2008 19:59:51 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151959.51833.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parenthesis fix in include/asm-mips/gic.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

diff -upr linux-2.6.26-rc2-mm1-a/include/asm-mips/gic.h linux-2.6.26-rc2-mm1-b/include/asm-mips/gic.h
--- linux-2.6.26-rc2-mm1-a/include/asm-mips/gic.h	2008-05-15 19:44:48.000000000 +0200
+++ linux-2.6.26-rc2-mm1-b/include/asm-mips/gic.h	2008-05-15 19:52:20.000000000 +0200
@@ -330,7 +330,7 @@
 
 #define GIC_SH_RMASK_OFS		0x0300
 #define GIC_CLR_INTR_MASK(intr, val) \
-	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_RMASK_OFS + 4 + (((((intr) / 32) ^ 1) - 1) * 4)), ((val) << ((intr) % 32))
+	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_RMASK_OFS + 4 + (((((intr) / 32) ^ 1) - 1) * 4)), ((val) << ((intr) % 32)))
 
 /* Register Map for Local Section */
 #define GIC_VPE_CTL_OFS			0x0000
