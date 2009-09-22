Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbZIVN1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbZIVN1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZIVN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:27:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:35392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbZIVN13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:27:29 -0400
Subject: [PATCH] MIPS: includecheck fix: bcm63xx, board_bcm963xx.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>, Florian Fainelli <florian@openwrt.org>,
       Maxime Bizon <mbizon@freebox.fr>,
       linux-mips <linux-mips@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:57:17 +0530
Message-Id: <1253626037.3784.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/mips/bcm63xx/boards/board_bcm963xx.c: bcm63xx_board.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/mips/bcm63xx/boards/board_bcm963xx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index fd77f54..12add0c 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -20,7 +20,6 @@
 #include <bcm63xx_cpu.h>
 #include <bcm63xx_regs.h>
 #include <bcm63xx_io.h>
-#include <bcm63xx_board.h>
 #include <bcm63xx_dev_pci.h>
 #include <bcm63xx_dev_enet.h>
 #include <bcm63xx_dev_dsp.h>
-- 
1.6.0.6


