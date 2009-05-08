Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbZEHPZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbZEHPZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762533AbZEHPYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:24:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760630AbZEHPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:24:32 -0400
Subject: [PATCH -tip] x86: msr-index.h remove duplicate MSR C001_0015
 declaration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 20:53:58 +0530
Message-Id: <1241796238.6548.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSRC001_0015 Hardware Configuration Register (HWCR) is already defined
as MSR_K7_HWCR.

And HWCR is available for >= K7.

So MSR_K8_HWCR is not required and no-one is using it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/msr-index.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ec41fc1..4d58d04 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -121,7 +121,6 @@
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
 #define MSR_K8_SYSCFG			0xc0010010
-#define MSR_K8_HWCR			0xc0010015
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
-- 
1.6.0.6



