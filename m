Return-Path: <linux-kernel-owner+w=401wt.eu-S937356AbYBWIiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937356AbYBWIiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936570AbYBWIV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:21:56 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:36994 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937026AbYBWIVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FPipTusI5PjFYk2l1g5bfj+oSH2uk/vIBxhqvT362Nq1QTRxEKrEJDU/gCW7rTa3gQg/neuU4khBwRP7GWomZmcV9WyqHPY/eS4HI7SQF1hpr6KWFQoqBn3u173AdAi8KpfTGuMBDt7XylR9tV/NEA2LPLQV9OQVov973jKYHcY=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       David Howells <dhowells@redhat.com>, yasutake.koichi@jp.panasonic.com
Subject: [PATCH 15/16] mn10300: use get_personality()
Date: Sat, 23 Feb 2008 16:14:18 +0800
Message-Id: <12037546111887-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037546033003-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
 <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
 <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
 <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
 <12037545522455-git-send-email-xiyou.wangcong@gmail.com>
 <12037545611159-git-send-email-xiyou.wangcong@gmail.com>
 <1203754571655-git-send-email-xiyou.wangcong@gmail.com>
 <1203754579637-git-send-email-xiyou.wangcong@gmail.com>
 <1203754594597-git-send-email-xiyou.wangcong@gmail.com>
 <12037546033003-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for mn10300 code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: yasutake.koichi@jp.panasonic.com

---
 include/asm-mn10300/page.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-mn10300/page.h b/include/asm-mn10300/page.h
index 124971b..fc6e9fb 100644
--- a/include/asm-mn10300/page.h
+++ b/include/asm-mn10300/page.h
@@ -123,7 +123,7 @@ static inline int get_order(unsigned long size)
 
 #define VM_DATA_DEFAULT_FLAGS \
 	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
+	((get_personality() & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
 		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #endif /* __KERNEL__ */
-- 
1.5.3.8

