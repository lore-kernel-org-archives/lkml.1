Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZIVNHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZIVNHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZIVNHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:07:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:47291 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbZIVNHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:07:17 -0400
Subject: [PATCH] ARM: includecheck fix: mach-davinci, board-dm365-evm.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Sandeep Paulraj <s-paulraj@ti.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:37:01 +0530
Message-Id: <1253624821.3784.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-davinci/board-dm365-evm.c: mach/common.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-davinci/board-dm365-evm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index a1d5e7d..52dd804 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -35,7 +35,6 @@
 #include <mach/common.h>
 #include <mach/i2c.h>
 #include <mach/serial.h>
-#include <mach/common.h>
 #include <mach/mmc.h>
 #include <mach/nand.h>
 
-- 
1.6.0.6


