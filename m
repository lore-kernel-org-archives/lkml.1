Return-Path: <linux-kernel-owner+w=401wt.eu-S1763760AbXE1XLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763760AbXE1XLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 19:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761230AbXE1XLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 19:11:16 -0400
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:54554 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760876AbXE1XLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 19:11:14 -0400
From: Junio C Hamano <junkio@cox.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 2/3] mips au1xxx_ide.h: use NULL as firmware-revision wildcard.
References: <20070521145042.GA6957@redhat.com>
	<7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
	<7vps4ta1iy.fsf_-_@assigned-by-dhcp.cox.net>
	<200705282141.42507.bzolnier@gmail.com>
Date: Mon, 28 May 2007 16:10:58 -0700
Message-ID: <7vy7j87ddp.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the DMA whitelist in MIPS specific au1xxx ide
driver to use NULL instead of "ALL" as the wildcard.

Signed-off-by: Junio C Hamano <junkio@cox.net>
---

 * This is a respin of earlier "3/3 Make ide dma blacklist handling a bit saner."

 include/asm-mips/mach-au1x00/au1xxx_ide.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/asm-mips/mach-au1x00/au1xxx_ide.h b/include/asm-mips/mach-au1x00/au1xxx_ide.h
index 8fcae21..4663e8b 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -88,26 +88,26 @@ static const struct drive_list_entry dma_white_list [] = {
 /*
  * Hitachi
  */
-        { "HITACHI_DK14FA-20"    ,       "ALL"           },
-        { "HTS726060M9AT00"      ,       "ALL"           },
+        { "HITACHI_DK14FA-20"    ,       NULL            },
+        { "HTS726060M9AT00"      ,       NULL            },
 /*
  * Maxtor
  */
-        { "Maxtor 6E040L0"      ,       "ALL"           },
-        { "Maxtor 6Y080P0"      ,       "ALL"           },
-        { "Maxtor 6Y160P0"      ,       "ALL"           },
+        { "Maxtor 6E040L0"      ,       NULL            },
+        { "Maxtor 6Y080P0"      ,       NULL            },
+        { "Maxtor 6Y160P0"      ,       NULL            },
 /*
  * Seagate
  */
-        { "ST3120026A"          ,       "ALL"           },
-        { "ST320014A"           ,       "ALL"           },
-        { "ST94011A"            ,       "ALL"           },
-        { "ST340016A"           ,       "ALL"           },
+        { "ST3120026A"          ,       NULL            },
+        { "ST320014A"           ,       NULL            },
+        { "ST94011A"            ,       NULL            },
+        { "ST340016A"           ,       NULL            },
 /*
  * Western Digital
  */
-        { "WDC WD400UE-00HCT0"  ,       "ALL"           },
-        { "WDC WD400JB-00JJC0"  ,       "ALL"           },
+        { "WDC WD400UE-00HCT0"  ,       NULL            },
+        { "WDC WD400JB-00JJC0"  ,       NULL            },
         { NULL                  ,       NULL            }
 };
 
@@ -116,9 +116,9 @@ static const struct drive_list_entry dma_black_list [] = {
 /*
  * Western Digital
  */
-        { "WDC WD100EB-00CGH0"  ,       "ALL"           },
-        { "WDC WD200BB-00AUA1"  ,       "ALL"           },
-        { "WDC AC24300L"        ,       "ALL"           },
+        { "WDC WD100EB-00CGH0"  ,       NULL            },
+        { "WDC WD200BB-00AUA1"  ,       NULL            },
+        { "WDC AC24300L"        ,       NULL            },
         { NULL                  ,       NULL            }
 };
 #endif
-- 
1.5.2.86.g99b5-dirty


