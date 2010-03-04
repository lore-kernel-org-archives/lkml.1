Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0CDSdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:33:13 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:47322 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab0CDSdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:33:12 -0500
Date: Thu, 4 Mar 2010 20:33:07 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: alsa-devel@alsa-project.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix jazz16 compile (udelay)
Message-ID: <alpine.SOC.1.00.1003042030460.4679@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to compile jazz16 isa sound driver on alpha (2.6.33+git), I 
found a compile failure in jazz16.c (udelay is unknown). Fix it by 
including delay.h.

Signed-foo-by: Meelis Roos <mroos@linux.ee>

diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
index 8d21a3f..8ccbcdd 100644
--- a/sound/isa/sb/jazz16.c
+++ b/sound/isa/sb/jazz16.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 #include <asm/dma.h>
 #include <linux/isa.h>
 #include <sound/core.h>


-- 
Meelis Roos (mroos@linux.ee)
