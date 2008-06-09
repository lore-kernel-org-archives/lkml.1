Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYFITUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYFITUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYFITUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:20:06 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:42867 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYFITUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:20:05 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Re: 2.6.26-rc5-mm1 - fix parenthesis in drivers/net/smc911x.h
Date: Mon, 9 Jun 2008 21:20:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080609053908.8021a635.akpm@linux-foundation.org>
In-Reply-To: <20080609053908.8021a635.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806092120.02943.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parenthesis fix in drivers/net/smc911x.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- linux-2.6.26-rc5-mm1-a/drivers/net/smc911x.h	2008-06-09 19:22:02.000000000 +0200
+++ linux-2.6.26-rc5-mm1-b/drivers/net/smc911x.h	2008-06-09 19:24:57.000000000 +0200
@@ -177,7 +177,7 @@ static inline void SMC_outsl(struct smc9
 }
 #else
 #if	SMC_USE_16BIT
-#define SMC_inl(lp, r)		 (readw((lp)->base + (r)) & 0xFFFF) + (readw((lp)->base + (r) + 2) << 16))
+#define SMC_inl(lp, r)		 ((readw((lp)->base + (r)) & 0xFFFF) + (readw((lp)->base + (r) + 2) << 16))
 #define SMC_outl(v, lp, r) 			 \
 	do{					 \
 		 writew(v & 0xFFFF, (lp)->base + (r));	 \

