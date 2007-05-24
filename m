Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbXEXRwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbXEXRwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXEXRwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:52:02 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1923 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXEXRwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:52:00 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Subject: [PATCH] m68k: parenthesis balance
Date: Thu, 24 May 2007 19:51:57 +0200
User-Agent: KMail/1.9.5
Cc: linux-m68k@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241951.58142.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Balance parenthesis in m68k mac debug code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 arch/m68k/mac/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr linux-2.6.22-rc2-mm1-a/arch/m68k/mac/debug.c linux-2.6.22-rc2-mm1-b/arch/m68k/mac/debug.c
--- linux-2.6.22-rc2-mm1-a/arch/m68k/mac/debug.c    2007-05-19 06:06:17.000000000 +0200
+++ linux-2.6.22-rc2-mm1-b/arch/m68k/mac/debug.c    2007-05-23 12:15:59.000000000 +0200
@@ -71,7 +71,7 @@ void mac_debugging_short(int pos, short 
 
    /* calculate current offset */
    pengoffset = (unsigned char *)mac_videobase +
-       (150+line*2) * mac_rowbytes) + 80 * peng;
+       (150+line*2) * mac_rowbytes + 80 * peng;
 
    pptr = pengoffset;
 
