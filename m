Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZKUSHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZKUSHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZKUSHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:07:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:36106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543AbZKUSHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:07:34 -0500
Subject: [PATCH] xtensa: includecheck fix vector.S
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Chris Zankel <chris@zankel.net>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Nov 2009 23:36:10 +0530
Message-Id: <1258826770.5364.18.camel@ht.satnam>
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
Cc: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
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


