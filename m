Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZHKOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZHKOyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZHKOyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:54:18 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:49800 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755020AbZHKOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:54:14 -0400
Date: Tue, 11 Aug 2009 08:54:14 -0600
From: dougthompson@xmission.com
To: tombowfly@gmail.com, juhlenko@akamai.com,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: fix offset of reg in i3200_edac module
Message-ID: <4a818616.pTakD6L47mEGolBL%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Uhlenkott <juhlenko@akamai.com>

Fix an obviously wrong hardware register offset, which was inheirited
from x38_edac (which was previously fixed).

Thanks to Lu Zhihe for spotting this.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 i3200_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31-rc5/drivers/edac/i3200_edac.c
===================================================================
--- linux-2.6.31-rc5.orig/drivers/edac/i3200_edac.c	2009-08-10 09:56:10.000000000 -0600
+++ linux-2.6.31-rc5/drivers/edac/i3200_edac.c	2009-08-11 08:47:22.000000000 -0600
@@ -29,7 +29,7 @@
 /* Intel 3200 register addresses - device 0 function 0 - DRAM Controller */
 
 #define I3200_MCHBAR_LOW	0x48	/* MCH Memory Mapped Register BAR */
-#define I3200_MCHBAR_HIGH	0x4b
+#define I3200_MCHBAR_HIGH	0x4c
 #define I3200_MCHBAR_MASK	0xfffffc000ULL	/* bits 35:14 */
 #define I3200_MMR_WINDOW_SIZE	16384
 
