Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbXLTKKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbXLTKKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 05:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXLTKKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 05:10:03 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:43042 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbXLTKKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:10:01 -0500
Date: Thu, 20 Dec 2007 11:09:44 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Clemens Koller <clemens.koller@anagramm.de>, jesper.nilsson@axis.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unused __dummy, CONST_ADDR and ADDR from CRIS bitops.h
Message-ID: <20071220100944.GG10888@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is very old code, it hasn't changed since 2001 and
it is not used anywhere. Noticed by Clemens Koller.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/bitops.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/asm-cris/bitops.h b/include/asm-cris/bitops.h
index e2f49c2..75ea6e0 100644
--- a/include/asm-cris/bitops.h
+++ b/include/asm-cris/bitops.h
@@ -24,13 +24,6 @@
 #include <linux/compiler.h>
 
 /*
- * Some hacks to defeat gcc over-optimizations..
- */
-struct __dummy { unsigned long a[100]; };
-#define ADDR (*(struct __dummy *) addr)
-#define CONST_ADDR (*(const struct __dummy *) addr)
-
-/*
  * set_bit - Atomically set a bit in memory
  * @nr: the bit to set
  * @addr: the address to start counting from
-- 
1.5.3.6.970.gd25430

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
