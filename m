Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0BQHK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 02:10:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39908
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104Ab0BQHK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 02:10:57 -0500
Date: Tue, 16 Feb 2010 23:11:09 -0800 (PST)
Message-Id: <20100216.231109.183048308.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, jengelh@medozas.de
Subject: Re: linux-next: build failure after final merge (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100217174015.d1a8a478.sfr@canb.auug.org.au>
References: <20100217174015.d1a8a478.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1H7BumE023531

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Feb 2010 17:40:15 +1100

> After merging, today's linux-next build (sparc64 defconfig) failed like
> this:

Fixed for at least 6 hours:

>From 177867ce08f2756fa361e37086fc1792d7b4cf29 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@davemloft.net>
Date: Tue, 16 Feb 2010 15:23:23 -0800
Subject: [PATCH 641/698] sparc64: Kill bogus ip_tables.h include.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fixes the following build failure:

  CC      arch/sparc/kernel/sys_sparc32.o
In file included from include/linux/netfilter_ipv4/ip_tables.h:28,
                 from arch/sparc/kernel/sys_sparc32.c:46:
include/linux/netfilter/x_tables.h:525: error: expected declaration specifiers or ¡...¢ before ¡nf_hookfn¢

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/sys_sparc32.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index dc0ac19..daded3b 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -43,7 +43,6 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/vfs.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/ptrace.h>
 
 #include <asm/types.h>
-- 
1.6.6.1

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
