Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbXF0Rly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbXF0Rly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXF0Rlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:41:44 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37913 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbXF0Rlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:41:44 -0400
Date: Wed, 27 Jun 2007 10:43:23 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: Geode HW Random Number Generator depend on X86_3
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706271043.23373.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: Geode HW Random Number Generator depend on X86_32

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 7cda04b..2d7cd48 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -41,7 +41,7 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
-	depends on HW_RANDOM && X86 && PCI
+	depends on HW_RANDOM && X86_32 && PCI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
