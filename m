Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZLID7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZLID7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 22:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbZLID7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 22:59:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45344 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbZLID7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 22:59:49 -0500
Date: Wed, 9 Dec 2009 14:59:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the omap tree
Message-Id: <20091209145951.2cdb4c8c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/io.c between commit
c88aa7d24b59035da46d02b9534d8036a6af0b44 ("omap: mux: Remove old mux code
for 34xx") from the omap tree and commit
24cb56c4f0c1f6485b601ad7aa665f829edae290 ("OMAP: Add VRAM manager") from
the omap_dss2 tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/io.c
index 7d344d0,6a4d8e4..0000000
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@@ -33,7 -33,7 +33,8 @@@
  #include <plat/sdrc.h>
  #include <plat/gpmc.h>
  #include <plat/serial.h>
 +#include <plat/mux.h>
+ #include <plat/vram.h>
  
  #ifndef CONFIG_ARCH_OMAP4	/* FIXME: Remove this once clkdev is ready */
  #include "clock.h"
