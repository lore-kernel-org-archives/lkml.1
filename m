Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYBVWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYBVWVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935719AbYBVWL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:11:58 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:16303 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682AbYBVWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:11:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=FY20GRIu/AdQ1i5vcqIy9JtRnXtGbdfNgSpFFm+QdEhxPq1H6D1qlpFqS+8YV8UNvJwHzdXhpvEUpwU+y974w4sdzhaBP5opzc0e9eTJYf7MQ4eunF2BX/C91jqs8ygQx64ra6zN32p8Zan47ZSQPnaB4ACwkaW409w1zHA5c+4=
Date: Fri, 22 Feb 2008 23:11:52 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/20] x86: Coding Style fixes to arch/x86/kernel/msr.c
Message-ID: <20080222231152.7bb2090b@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error and warning free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/msr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index af51ea8..4dfb405 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -65,8 +65,8 @@ static loff_t msr_seek(struct file *file, loff_t offset, int orig)
 	return ret;
 }
 
-static ssize_t msr_read(struct file *file, char __user * buf,
-			size_t count, loff_t * ppos)
+static ssize_t msr_read(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
 {
 	u32 __user *tmp = (u32 __user *) buf;
 	u32 data[2];
-- 
1.5.4.GIT

