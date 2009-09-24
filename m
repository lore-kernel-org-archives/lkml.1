Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbZIXKuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbZIXKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZIXKuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:50:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:56208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZIXKuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:50:16 -0400
Subject: [PATCH] m68knommu: includecheck fix: 5206e, config.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Ungerer <gerg@uclinux.org>, Steven King <sfking@fdwdc.com>,
       uclinux-dev@uclinux.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:20:00 +0530
Message-Id: <1253789400.5860.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/m68knommu/platform/5206e/config.c: asm/mcfuart.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Steven King <sfking@fdwdc.com>
---
 arch/m68knommu/platform/5206e/config.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m68knommu/platform/5206e/config.c b/arch/m68knommu/platform/5206e/config.c
index 0f41ba8..9423979 100644
--- a/arch/m68knommu/platform/5206e/config.c
+++ b/arch/m68knommu/platform/5206e/config.c
@@ -17,7 +17,6 @@
 #include <asm/mcfsim.h>
 #include <asm/mcfuart.h>
 #include <asm/mcfdma.h>
-#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
-- 
1.6.0.6


