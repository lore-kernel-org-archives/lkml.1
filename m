Return-Path: <linux-kernel-owner+w=401wt.eu-S1751126AbZHSFEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbZHSFEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 01:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZHSFEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 01:04:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33240 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZHSFEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 01:04:38 -0400
Date: Wed, 19 Aug 2009 15:04:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Syed Rafiuddin <rafiuddin.syed@ti.com>,
       Russell King <rmk@arm.linux.org.uk>, Kalle Valo <kalle.valo@iki.fi>
Subject: linux-next: manual merge of the omap tree with the arm tree
Message-Id: <20090819150433.4c12c612.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the omap tree got a conflict in
arch/arm/mach-omap2/board-4430sdp.c between commit
085b54d99b8ee999e7905b8f16e201e0da8ba369 ("ARM: OMAP4: Add UART4
support") from the arm tree and commit
4c29fa3e47342666e12e46f35f40dd90b12cd1a4 ("OMAP: remove OMAP_TAG_UART")
from the omap tree.

Just context changes (I think).  I fixed it up (see below) and can carry
the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-4430sdp.c
index 1b22307,646079f..0000000
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@@ -38,8 -38,8 +38,8 @@@ static struct platform_device *sdp4430_
  	&sdp4430_lcd_device,
  };
  
- static struct omap_uart_config sdp4430_uart_config __initdata = {
+ static struct omap_uart_platform_data sdp4430_uart_config __initdata = {
 -	.enabled_uarts	= (1 << 0) | (1 << 1) | (1 << 2),
 +	.enabled_uarts	= (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3),
  };
  
  static struct omap_lcd_config sdp4430_lcd_config __initdata = {
