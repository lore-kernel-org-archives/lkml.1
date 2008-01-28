Return-Path: <linux-kernel-owner+w=401wt.eu-S1764039AbYA1XJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764039AbYA1XJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763665AbYA1XHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:07:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763641AbYA1XHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=t6jbnRWQi6FcB+Dw62MUblQF8Pdze7QV8lQwvyW554XyUK8ICKRGh5esIWzzgrLKpSzQaJaIy8KGKU7+u8qYeb51oD2myFHcXD2RAE5HKrS66gvCyyovhmodX/oJqeUkm3bX3uPWPMD9dolzWybv9JG/w0J9pgEsOE+G83OcDTk=
Date: Tue, 29 Jan 2008 00:07:44 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] X86: Fix trailing statements should be on next line
Message-ID: <20080129000744.698639d3@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trailing statements should be on next line

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/errors.c |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index 7f96db4..4419339 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -93,19 +93,32 @@ void FPU_printall(void)
   partial_status = status_word();
 
 #ifdef DEBUGGING
-if ( partial_status & SW_Backward )    printk("SW: backward compatibility\n");
-if ( partial_status & SW_C3 )          printk("SW: condition bit 3\n");
-if ( partial_status & SW_C2 )          printk("SW: condition bit 2\n");
-if ( partial_status & SW_C1 )          printk("SW: condition bit 1\n");
-if ( partial_status & SW_C0 )          printk("SW: condition bit 0\n");
-if ( partial_status & SW_Summary )     printk("SW: exception summary\n");
-if ( partial_status & SW_Stack_Fault ) printk("SW: stack fault\n");
-if ( partial_status & SW_Precision )   printk("SW: loss of precision\n");
-if ( partial_status & SW_Underflow )   printk("SW: underflow\n");
-if ( partial_status & SW_Overflow )    printk("SW: overflow\n");
-if ( partial_status & SW_Zero_Div )    printk("SW: divide by zero\n");
-if ( partial_status & SW_Denorm_Op )   printk("SW: denormalized operand\n");
-if ( partial_status & SW_Invalid )     printk("SW: invalid operation\n");
+if ( partial_status & SW_Backward )
+printk("SW: backward compatibility\n");
+if ( partial_status & SW_C3 )
+printk("SW: condition bit 3\n");
+if ( partial_status & SW_C2 )
+printk("SW: condition bit 2\n");
+if ( partial_status & SW_C1 )
+printk("SW: condition bit 1\n");
+if ( partial_status & SW_C0 )
+printk("SW: condition bit 0\n");
+if ( partial_status & SW_Summary )
+printk("SW: exception summary\n");
+if ( partial_status & SW_Stack_Fault )
+printk("SW: stack fault\n");
+if ( partial_status & SW_Precision )
+printk("SW: loss of precision\n");
+if ( partial_status & SW_Underflow )
+printk("SW: underflow\n");
+if ( partial_status & SW_Overflow )
+printk("SW: overflow\n");
+if ( partial_status & SW_Zero_Div )
+printk("SW: divide by zero\n");
+if ( partial_status & SW_Denorm_Op )
+printk("SW: denormalized operand\n");
+if ( partial_status & SW_Invalid )
+printk("SW: invalid operation\n");
 #endif /* DEBUGGING */
 
   printk(" SW: b=%d st=%ld es=%d sf=%d cc=%d%d%d%d ef=%d%d%d%d%d%d\n",
-- 
1.5.4.rc3

