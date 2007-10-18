Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbXJRP1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbXJRP1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764914AbXJRP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:26:43 -0400
Received: from ltw.loris.tv ([85.14.220.160]:39075 "EHLO ltw.loris.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765917AbXJRP0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:26:41 -0400
X-Greylist: delayed 1650 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 11:26:41 EDT
Date: Thu, 18 Oct 2007 16:58:58 +0200
To: zippel@linux-m68.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Kconfig: Missing line breaks in arch/x86_64/Kconfig
Message-ID: <20071018145857.GI2154@ltw.loris.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
From: adi@drcomp.erfurt.thur.de (Adrian Knoth)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Knoth <adi@drcomp.erfurt.thur.de>

The helptext for IA32_EMULATION in arch/x86_64/Kconfig is wider than 80
chars, thus failing to be displayed in 80x24 screens.

This patch re-breaks lines.


Signed-off-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
---


--- linux-2.6.23.1/arch/x86_64/Kconfig	2007-10-15 22:36:02.000000000 +0200
+++ /home/adi/Kconfig-new	2007-10-18 12:17:42.000000000 +0200
@@ -742,9 +742,9 @@
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	help
-	  Include code to run 32-bit programs under a 64-bit kernel. You should likely
-	  turn this on, unless you're 100% sure that you don't have any 32-bit programs
-	  left.
+	  Include code to run 32-bit programs under a 64-bit kernel. You should
+	  likely turn this on, unless you're 100% sure that you don't have any
+	  32-bit programs left.
 
 config IA32_AOUT
        tristate "IA32 a.out support"



-- 
mail: adi@thur.de  	http://adi.thur.de	PGP/GPG: key via keyserver

Nur wer die Arbeit kennt, weiﬂ was ich meide
