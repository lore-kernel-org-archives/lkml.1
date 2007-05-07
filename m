Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbXEGKg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbXEGKg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbXEGKg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:36:27 -0400
Received: from DENETHOR.UNI-MUENSTER.DE ([128.176.180.180]:57043 "EHLO
	denethor.uni-muenster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbXEGKg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:36:26 -0400
Date: Mon, 7 May 2007 12:35:19 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jengelh@gmx.de
Subject: [PATCH] drivers/macintosh: remove default y from Kconfig (was: Re: 2.6.21-mm1)
Message-ID: <20070507103519.GA4725@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think I need macintosh drivers for my x86 arch selected in by default,
  do I?

-----
From: Borislav Petkov <bbpetkov@yahoo.de>

Do not select macintosh drivers by default.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
Index: trees/linux-mm/drivers/macintosh/Kconfig
===================================================================
--- linux-mm.orig/drivers/macintosh/Kconfig
+++ linux-mm/drivers/macintosh/Kconfig
@@ -2,7 +2,6 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y

 if MACINTOSH_DRIVERS

-- 
Regards/Gruﬂ,
    Boris.
