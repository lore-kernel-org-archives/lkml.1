Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZGHOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZGHOqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbZGHOp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:45:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:60502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189AbZGHOp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:45:59 -0400
Subject: [PATCH 2/44] includecheck fix: arm, atomic.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:01:39 +0530
Message-Id: <1247063499.4382.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/include/asm/atomic.h: asm/system.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/include/asm/atomic.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 9e07fe5..9ed2377 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -159,8 +159,6 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 
 #else /* ARM_ARCH_6 */
 
-#include <asm/system.h>
-
 #ifdef CONFIG_SMP
 #error SMP not supported on pre-ARMv6 CPUs
 #endif
-- 
1.6.0.6



