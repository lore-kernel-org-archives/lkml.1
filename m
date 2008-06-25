Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYFYQ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYFYQ1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYFYQ1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:27:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42918 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843AbYFYQ1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:12 -0400
Date: Wed, 25 Jun 2008 19:25:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] remove the unused ALPHA_CORE_AGP option
Message-ID: <20080625162507.GD10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The real option is named AGP_ALPHA_CORE.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
29619116cb61e48b094e62055da34d85e854bc39 diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 729cdbd..e50a771 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -333,11 +333,6 @@ config PCI_SYSCALL
 config IOMMU_HELPER
 	def_bool PCI
 
-config ALPHA_CORE_AGP
-	bool
-	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL
-	default y
-
 config ALPHA_NONAME
 	bool
 	depends on ALPHA_BOOK1 || ALPHA_NONAME_CH

