Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbXKERHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbXKERHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbXKERGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:06:37 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59470 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757203AbXKERGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:06:35 -0500
Date: Mon, 5 Nov 2007 18:06:12 +0100
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32: remove UID16 option
Message-ID: <20071105170612.GW12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

avr32 already sees the option from init/Kconfig.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
044f492c0600b6b5936d966b6c9447c7d704ce75 
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index bbecbd8..4f402c9 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -19,9 +19,6 @@ config AVR32
 	  There is an AVR32 Linux project with a web page at
 	  http://avr32linux.org/.
 
-config UID16
-	bool
-
 config GENERIC_GPIO
 	bool
 	default y

