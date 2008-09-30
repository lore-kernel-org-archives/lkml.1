Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYI3Xan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYI3Xan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYI3XaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:30:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:39997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYI3XaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vvRYo5163indzGF8QjfyDKZ+vahCaZb8CATlTIFMnj+4BwNprQOqPVoU4NqylC+17E
         fj99C8r0xBdwk+wwRH4W8oeqDDy5wvz0JF0ovqDIDYalAlGXwXMwwvaiVSQXVNpWsKp6
         PhQPw92BUMr90ck8CalMR3gQ+/ft+rIZEhYHY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/3] x86: doc mtrr-cleanup-debug
Date: Tue, 30 Sep 2008 16:29:39 -0700
Message-Id: <1222817380-29481-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doc mtrr-cleanup-debug.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 Documentation/kernel-parameters.txt |    3 +++
 arch/x86/kernel/cpu/mtrr/main.c     |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -620,6 +620,9 @@ and is between 256 and 4096 characters.
 			to discrete, to make X server driver able to add WB
 			entry later. This parameter enables/disables that.
 
+	mtrr-cleanup-debug [X86]
+			print out more debug info for mtrr cleanup.
+
 	mtrr_chunk_size=nn[KMG] [X86]
 			used for mtrr cleanup. It is largest continous chunk
 			that could hold holes aka. UC entries.
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -841,7 +841,7 @@ static int __init mtrr_cleanup_debug_set
 	debug_print = 1;
 	return 0;
 }
-early_param("mtrr_cleanup_debug", mtrr_cleanup_debug_setup);
+early_param("mtrr-cleanup-debug", mtrr_cleanup_debug_setup);
 
 struct var_mtrr_state {
 	unsigned long	range_startk;
