Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYG0Qhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYG0Qhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYG0Qhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:37:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37974 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbYG0Qhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:37:35 -0400
Date: Mon, 28 Jul 2008 02:37:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Karsten Keil <kkeil@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-Id: <20080728023732.090aff83.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc (allyesconfig build) we get this error:

drivers/isdn/hardware/mISDN/hfcpci.c:1991: error: implicit declaration of function 'virt_to_bus'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/isdn/hardware/mISDN/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index 1479348..9cd5f5f 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -7,6 +7,7 @@ config MISDN_HFCPCI
 	tristate "Support for HFC PCI cards"
 	depends on MISDN
 	depends on PCI
+	depends on VIRT_TO_BUS
 	help
 	  Enable support for cards with Cologne Chip AG's
           HFC PCI chip.
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
