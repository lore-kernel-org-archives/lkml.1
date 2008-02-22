Return-Path: <linux-kernel-owner+w=401wt.eu-S935008AbYBVWVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbYBVWVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935415AbYBVWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:12:09 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:16303 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935131AbYBVWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=UccykE0D3z2Jdls7Hj9CXSwg6keUq/czBS/z2Waxii6ggmU91/MuKKPARh1xk/Jdo2Y7Ez8fCrgISDDz+MGJ78Zeojbt6sZlZitoPcAz9Qg4Askw/+HEObhX/MWjg67YVfUt18LXLLuYeI/TwwVCaYwUggtOUKmwA05VZ6ybNQM=
Date: Fri, 22 Feb 2008 23:11:59 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/20] x86: Coding Style fixes to arch/x86/xen/multicalls.c
Message-ID: <20080222231159.34dd5b5a@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/xen/multicalls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 5e6f36f..5791eb2 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -76,7 +76,7 @@ void xen_mc_flush(void)
 		if (ret) {
 			printk(KERN_ERR "%d multicall(s) failed: cpu %d\n",
 			       ret, smp_processor_id());
-			for(i = 0; i < b->mcidx; i++) {
+			for (i = 0; i < b->mcidx; i++) {
 				printk("  call %2d/%d: op=%lu arg=[%lx] result=%ld\n",
 				       i+1, b->mcidx,
 				       b->debug[i].op,
@@ -93,7 +93,7 @@ void xen_mc_flush(void)
 
 	local_irq_restore(flags);
 
-	for(i = 0; i < b->cbidx; i++) {
+	for (i = 0; i < b->cbidx; i++) {
 		struct callback *cb = &b->callbacks[i];
 
 		(*cb->fn)(cb->data);
-- 
1.5.4.GIT

