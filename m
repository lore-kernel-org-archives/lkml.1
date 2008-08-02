Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYHBTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYHBTZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbYHBTYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:24:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:22126 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbYHBTYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Nkq5nk1JWJ1WCblV/1ngti130RHIbjVy9pgspJUGRC1WSPiks4zJqW9dKeU8avtgWA
         p8vZQ02XmrjhWzqBrgooMLORVuw5kwu6B1RSjKUgYi34At2DkRarnwMSEjvBIPKIfSeH
         +ME/Lr3/bYvQqIUht+YHQxCXs6Ol4b6aWN40I=
Date: Sat, 2 Aug 2008 21:24:45 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] x86: Coding style fixes to arch/x86/lib/strstr_32.c
Message-ID: <20080802212445.72fb1d77@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 3 errors, 0 warnings, 31 lines checked

After:
total: 0 errors, 0 warnings, 31 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/strstr_32.o.*
c96006ec3387862e5bacb139207a3098  /tmp/strstr_32.o.after
c96006ec3387862e5bacb139207a3098  /tmp/strstr_32.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/lib/strstr_32.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/strstr_32.c b/arch/x86/lib/strstr_32.c
index 42e8a50..8e2d55f 100644
--- a/arch/x86/lib/strstr_32.c
+++ b/arch/x86/lib/strstr_32.c
@@ -23,9 +23,9 @@ __asm__ __volatile__(
 	"jne 1b\n\t"
 	"xorl %%eax,%%eax\n\t"
 	"2:"
-	:"=a" (__res), "=&c" (d0), "=&S" (d1)
-	:"0" (0), "1" (0xffffffff), "2" (cs), "g" (ct)
-	:"dx", "di");
+	: "=a" (__res), "=&c" (d0), "=&S" (d1)
+	: "0" (0), "1" (0xffffffff), "2" (cs), "g" (ct)
+	: "dx", "di");
 return __res;
 }
 
-- 
1.5.6.rc1.21.g03300

