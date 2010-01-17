Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818Ab0AQXfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0AQXfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518Ab0AQXfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:35:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46495 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab0AQXfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:35:43 -0500
Date: Mon, 18 Jan 2010 10:35:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
Subject: linux-next: manual merge of the arm tree with the arm-current tree
Message-Id: <20100118103534.a5dc3c66.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/Makefile between commit 95b8f20fd6a2694a16b8addb190b942bfb670c88
(ARM: fix badly placed mach/plat entries in Kconfig & Makefile"") from
the arm-current tree and commit c4ffccddd54b669cc9683f2c69e31035e916a1a0
("ARM: S5P6440: Add new Kconfig and Makefiles") from the arm tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

(Sorry, cut and paste diff)
diff --cc arch/arm/Makefile
index 9e75825,bbcd512..0000000
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@@ -184,7 -184,9 +185,8 @@@ plat-$(CONFIG_PLAT_ORION)  := orio
  plat-$(CONFIG_PLAT_PXA)               := pxa
  plat-$(CONFIG_PLAT_S3C24XX)   := s3c24xx s3c samsung
  plat-$(CONFIG_PLAT_S3C64XX)   := s3c64xx s3c samsung
 -plat-$(CONFIG_PLAT_S5PC1XX)   := s5pc1xx s3c samsung
+ plat-$(CONFIG_PLAT_S5P)               := s5p samsung s3c
 -plat-$(CONFIG_ARCH_STMP3XXX)  := stmp3xxx
 +plat-$(CONFIG_PLAT_S5PC1XX)   := s5pc1xx s3c samsung
  
  ifeq ($(CONFIG_ARCH_EBSA110),y)
  # This is what happens if you forget the IOCS16 line.
