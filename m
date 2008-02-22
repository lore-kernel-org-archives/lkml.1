Return-Path: <linux-kernel-owner+w=401wt.eu-S935298AbYBVWJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298AbYBVWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbYBVWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:09:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934147AbYBVWJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:09:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=VIky/Zsan+Z1otPnKwW4FJB0TFBFAYeRzFxW0G/ZmjsKnuum9xTyf8UJ07luwdbDpcI/avPJNyGPtSolshlJ3/mDPy2YvOKOg2N606OamQO+AhOBnFRZPhMd9Irb7fZqFxW8y7t+La1zymUxYgiCQjxa2p1/+bTW03lmZHv9P0c=
Date: Fri, 22 Feb 2008 23:09:26 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/20] x86: Coding Style fix to arch/x86/boot/pm.c
Message-ID: <20080222230926.573d4e15@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/boot/pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/pm.c b/arch/x86/boot/pm.c
index 1a0f936..a93cb8b 100644
--- a/arch/x86/boot/pm.c
+++ b/arch/x86/boot/pm.c
@@ -100,7 +100,7 @@ static void reset_coprocessor(void)
 /*
  * Set up the GDT
  */
-#define GDT_ENTRY(flags,base,limit)		\
+#define GDT_ENTRY(flags, base, limit)		\
 	(((u64)(base & 0xff000000) << 32) |	\
 	 ((u64)flags << 40) |			\
 	 ((u64)(limit & 0x00ff0000) << 32) |	\
-- 
1.5.4.GIT

