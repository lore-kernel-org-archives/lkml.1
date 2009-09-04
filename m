Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZIDSN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZIDSN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZIDSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:13:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151AbZIDSN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:13:27 -0400
Subject: [PATCH] x86: includecheck fix cpu/common.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 23:39:43 +0530
Message-Id: <1252087783.6385.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/x86/kernel/cpu/common.c: linux/smp.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/common.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2055fc2..2fea97e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -34,7 +34,6 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/pat.h>
-#include <linux/smp.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
-- 
1.6.0.6


