Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXIAGPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXIAGPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXIAGPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:15:00 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1574 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbXIAGO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:14:59 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arm: unbalanced parenthesis fix
Date: Sat, 1 Sep 2007 08:14:56 +0200
User-Agent: KMail/1.9.7
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709010814.56902.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch fixes unbalanced parenthesis.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/asm-arm/arch-sa1100/SA-1101.h.c |  ->  ( bytes)
 include/asm-arm/arch-sa1100/SA-1101.h.o |  ->  ( bytes)

 include/asm-arm/arch-sa1100/SA-1101.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc4-mm1-a/include/asm-arm/arch-sa1100/SA-1101.h	2007-09-01 07:23:27.000000000 +0200
+++ linux-2.6.23-rc4-mm1-b/include/asm-arm/arch-sa1100/SA-1101.h	2007-09-01 07:37:25.000000000 +0200
@@ -106,7 +106,7 @@
 #define SMCR_ColAdrBits( x )		  /* col. addr bits 8..11 */ \
 	(( (x) - 8 ) << FShft (SMCR_DCAC))
 #define SMCR_RowAdrBits( x )		  /* row addr bits 9..12 */\
-	(( (x) - 9 ) << FShft (SMCR_DRAC)
+	(( (x) - 9 ) << FShft (SMCR_DRAC))

 #define SNPR_VFBstart	  Fld(12,0)	/* Video frame buffer addr */
 #define SNPR_VFBsize	  Fld(11,12)	/* Video frame buffer size */
@@ -394,7 +394,7 @@
 #define VgaStatus      (*((volatile Word *) SA1101_p2v (_VgaStatus)))
 #define VgaInterruptMask (*((volatile Word *) SA1101_p2v (_VgaInterruptMask)))
 #define VgaPalette     (*((volatile Word *) SA1101_p2v (_VgaPalette)))
-#define DacControl     (*((volatile Word *) SA1101_p2v (_DacControl))
+#define DacControl     (*((volatile Word *) SA1101_p2v (_DacControl)))
 #define VgaTest        (*((volatile Word *) SA1101_p2v (_VgaTest)))

 #define VideoControl_VgaEn    0x00000000
