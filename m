Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbZCYRVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbZCYRVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZCYRVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:21:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:40086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbZCYRVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:21:14 -0400
Subject: Re: [PATCH -tip] x86: cpu_debug.c remove some not required header
 files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1238000052.2500.43.camel@ht.satnam>
References: <1238000052.2500.43.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 22:50:42 +0530
Message-Id: <1238001642.2500.50.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 22:24 +0530, Jaswinder Singh Rajput wrote:
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Wed, 25 Mar 2009 22:09:52 +0530
> Subject: [PATCH] x86: cpu_debug.c remove some not required header files
> 
> Impact: cleanup
> 
> Also fixed mode of cpu_debug files

Here is updated patch:

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Wed, 25 Mar 2009 22:09:52 +0530
Subject: [PATCH] x86: cpu_debug.c remove some not required header files

Impact: cleanup

Also fixed mode of cpu_debug files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/cpu_debug.c  |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)
 mode change 100755 => 100644 arch/x86/include/asm/cpu_debug.h
 mode change 100755 => 100644 arch/x86/kernel/cpu/cpu_debug.c

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
old mode 100755
new mode 100644
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
old mode 100755
new mode 100644
index 46e29ab..871a4dc
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -6,16 +6,12 @@
  * For licencing details see kernel-base/COPYING
  */
 
-#include <linux/interrupt.h>
-#include <linux/compiler.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
-#include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -26,7 +22,6 @@
 #include <asm/cpu_debug.h>
 #include <asm/paravirt.h>
 #include <asm/system.h>
-#include <asm/traps.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
 
-- 
1.6.0.6



