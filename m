Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbZGGOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbZGGOhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbZGGOfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:35:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:42739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137AbZGGOfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:35:37 -0400
Subject: [PATCH 14/22] trivial: fix typo "should should" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:50:33 +0530
Message-Id: <1246976433.3613.31.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "should should" with "should" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/ia64/include/asm/sn/pda.h |    2 +-
 drivers/char/amiserial.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/include/asm/sn/pda.h b/arch/ia64/include/asm/sn/pda.h
index 1c5108d..8ef9fb7 100644
--- a/arch/ia64/include/asm/sn/pda.h
+++ b/arch/ia64/include/asm/sn/pda.h
@@ -56,7 +56,7 @@ typedef struct pda_s {
  * in the same page as the cpu_data area. Note that there is a check in the setup
  * code to verify that we don't overflow the page.
  *
- * Seems like we should should cache-line align the pda so that any changes in the
+ * Seems like we should cache-line align the pda so that any changes in the
  * size of the cpu_data area don't change cache layout. Should we align to 32, 64, 128
  * or 512 boundary. Each has merits. For now, pick 128 but should be revisited later.
  */
diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 72429b6..7132577 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -13,7 +13,7 @@
  * (non hardware specific) changes to serial.c.
  *
  * The port is registered with the tty driver as minor device 64, and
- * therefore other ports should should only use 65 upwards.
+ * therefore other ports should only use 65 upwards.
  *
  * Richard Lucock 28/12/99
  *
-- 
1.6.0.6



