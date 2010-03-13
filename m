Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab0CMGvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:51:07 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:64010 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068Ab0CMGu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YOnW0ZgX6l6Y9s7cLVQSsOjuDQ+LsH7PJxytn41Gx2e5vd29f/BkhbcJvvDEg54MAg
         W+/UlIb+VYM5VvphcS5T2R2y2fMFLaZ1RVo8H8ZD8F/fH+qU9FDl7jyO2mWn/O5EP4at
         X0dju0dVjmjdhzQ9op+PmTyqcmTW3tDvgyGUk=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 10/10] ARM: ftrace: enable dynamic ftrace
Date: Sat, 13 Mar 2010 12:19:47 +0530
Message-Id: <1268462987-8271-11-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268462987-8271-1-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic ftrace for ARM has been disabled since 07c4cc1cdaa08f ("ftrace:
disable dynamic ftrace for all archs that use daemon").  Now that the
code has been updated, re-enable it.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cadfe2e..a264837 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -18,6 +18,8 @@ config ARM
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
+	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
-- 
1.7.0

