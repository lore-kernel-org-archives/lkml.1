Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZBZR6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZBZR6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZBZR6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:58:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37535 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZBZR57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:57:59 -0500
Date: Thu, 26 Feb 2009 12:57:56 -0500
From: Kyle McMartin <kyle@infradead.org>
To: x86@kernel.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: enable DMAR by default
Message-ID: <20090226175756.GP6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Now that the obvious bugs have been worked out, specifically
the iwlagn issue, and the write buffer errata, DMAR should be safe
to turn back on by default. (We've had it on since those patches were
first written a few weeks ago, without any noticeable bug reports
(most have been due to the dma-api debug patchset.))

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
Probably 2.6.29 material, but should definitely go in for 2.6.30.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9c39095..bc2fbad 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1803,7 +1803,7 @@ config DMAR
 	  remapping devices.
 
 config DMAR_DEFAULT_ON
-	def_bool n
+	def_bool y
 	prompt "Enable DMA Remapping Devices by default"
 	depends on DMAR
 	help
