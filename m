Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbXCOWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbXCOWSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933924AbXCOWSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:18:10 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2180 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933899AbXCOWSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:18:07 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: paulus@samba.org
Subject: [PATCH] powerpc: 8xx parenthesis balance
Date: Thu, 15 Mar 2007 23:20:44 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152320.45181.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch (against 2.6.21-rc3-mm1) balances parenthesis in
powerpc 8xx header files.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 arch/powerpc/platforms/8xx/mpc86xads.h |    2 +-
 arch/powerpc/platforms/8xx/mpc885ads.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -upr linux-2.6.21-rc3-mm1-a/arch/powerpc/platforms/8xx/mpc86xads.h linux-2.6.21-rc3-mm1-b/arch/powerpc/platforms/8xx/mpc86xads.h
--- linux-2.6.21-rc3-mm1-a/arch/powerpc/platforms/8xx/mpc86xads.h	2007-03-15 22:25:05.000000000 +0100
+++ linux-2.6.21-rc3-mm1-b/arch/powerpc/platforms/8xx/mpc86xads.h	2007-03-15 22:30:59.000000000 +0100
@@ -37,7 +37,7 @@
 #define CPM_MAP_ADDR		(get_immrbase() + MPC8xx_CPM_OFFSET)
 #define CPM_IRQ_OFFSET		16     // for compability with cpm_uart driver
 
-#define PCMCIA_MEM_ADDR		(uint)0xff020000)
+#define PCMCIA_MEM_ADDR		((uint)0xff020000)
 #define PCMCIA_MEM_SIZE		((uint)(64 * 1024))
 
 /* Bits of interest in the BCSRs.
diff -upr linux-2.6.21-rc3-mm1-a/arch/powerpc/platforms/8xx/mpc885ads.h linux-2.6.21-rc3-mm1-b/arch/powerpc/platforms/8xx/mpc885ads.h
--- linux-2.6.21-rc3-mm1-a/arch/powerpc/platforms/8xx/mpc885ads.h	2007-03-15 22:25:05.000000000 +0100
+++ linux-2.6.21-rc3-mm1-b/arch/powerpc/platforms/8xx/mpc885ads.h	2007-03-15 22:31:15.000000000 +0100
@@ -37,7 +37,7 @@
 #define CPM_MAP_ADDR		(get_immrbase() + MPC8xx_CPM_OFFSET)
 #define CPM_IRQ_OFFSET		16     // for compability with cpm_uart driver
 
-#define PCMCIA_MEM_ADDR		(uint)0xff020000)
+#define PCMCIA_MEM_ADDR		((uint)0xff020000)
 #define PCMCIA_MEM_SIZE		((uint)(64 * 1024))
 
 /* Bits of interest in the BCSRs.

Regards,

	Mariusz Kozlowski
