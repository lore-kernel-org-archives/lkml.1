Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbXEKGdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbXEKGdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbXEKGdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:33:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38549 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbXEKGdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:33:17 -0400
Date: Fri, 11 May 2007 16:33:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: tpmdd_devel@lists.sourceforge.net
Cc: Kylene Hall <kjhall@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Missing include file in tpm_atmel.h
Message-Id: <20070511163311.366ac5b4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC64, we need to include asm/prom.h for function definitions.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/char/tpm/tpm_atmel.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
index c912d86..9363bcf 100644
--- a/drivers/char/tpm/tpm_atmel.h
+++ b/drivers/char/tpm/tpm_atmel.h
@@ -23,6 +23,9 @@
  */
 
 #ifdef CONFIG_PPC64
+
+#include <asm/prom.h>
+
 #define atmel_getb(chip, offset) readb(chip->vendor->iobase + offset);
 #define atmel_putb(val, chip, offset) writeb(val, chip->vendor->iobase + offset)
 #define atmel_request_region request_mem_region
-- 
1.5.1.4

