Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZIVNpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZIVNpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZIVNpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:45:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:38800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbZIVNpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:45:06 -0400
Subject: [PATCH] POWERPC: includecheck fix: mm, tlb_low_64e.S
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 19:15:05 +0530
Message-Id: <1253627105.3784.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/powerpc/mm/tlb_low_64e.S: asm/reg.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/powerpc/mm/tlb_low_64e.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64e.S
index ef1cccf..f288279 100644
--- a/arch/powerpc/mm/tlb_low_64e.S
+++ b/arch/powerpc/mm/tlb_low_64e.S
@@ -18,7 +18,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/cputable.h>
 #include <asm/pgtable.h>
-#include <asm/reg.h>
 #include <asm/exception-64e.h>
 #include <asm/ppc-opcode.h>
 
-- 
1.6.0.6


