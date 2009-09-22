Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZIVOBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZIVOBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbZIVOBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:01:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:60874 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbZIVOBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:01:24 -0400
Subject: [PATCH] XTENSA: includecheck fix: vectors.S
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Chris Zankel <chris@zankel.net>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 19:30:50 +0530
Message-Id: <1253628050.3784.26.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warnings:

  arch/xtensa/kernel/vectors.S: asm/processor.h is included more than once.
  arch/xtensa/kernel/vectors.S: asm/ptrace.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/xtensa/kernel/vectors.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/kernel/vectors.S b/arch/xtensa/kernel/vectors.S
index 74a7518..70066e3 100644
--- a/arch/xtensa/kernel/vectors.S
+++ b/arch/xtensa/kernel/vectors.S
@@ -44,14 +44,12 @@
 
 #include <linux/linkage.h>
 #include <asm/ptrace.h>
-#include <asm/ptrace.h>
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/thread_info.h>
-#include <asm/processor.h>
 
 #define WINDOW_VECTORS_SIZE   0x180
 
-- 
1.6.0.6


