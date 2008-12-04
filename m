Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYLDLop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYLDLop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYLDLof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:44:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:46747 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751846AbYLDLof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:44:35 -0500
Date: Thu, 4 Dec 2008 12:44:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nick Andrew <nick@nick-andrew.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: printk: fix indentation of new_text_line
 declaration
Message-ID: <alpine.LNX.1.10.0812041242260.5809@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

I have just come across bogus indentation of new_text_line declaration. I 
have applied the patch below to trivial tree. If the indentation had some 
specific non-obvious purpose and was done intentionally this way, please 
let me know :)



From: Jiri Kosina <jkosina@suse.cz>
Subject: trivial: printk: fix indentation of new_text_line declaration

Remove bogus indentation of new_text_line declaration introduced in
commit ac60ad741.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index f492f15..fb17944 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -619,7 +619,7 @@ static int acquire_console_semaphore_for_printk(unsigned int cpu)
 static const char recursion_bug_msg [] =
 		KERN_CRIT "BUG: recent printk recursion!\n";
 static int recursion_bug;
-	static int new_text_line = 1;
+static int new_text_line = 1;
 static char printk_buf[1024];
 
 asmlinkage int vprintk(const char *fmt, va_list args)
-- 
1.5.6

