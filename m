Return-Path: <linux-kernel-owner+w=401wt.eu-S1763137AbYBVWMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763137AbYBVWMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935397AbYBVWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935382AbYBVWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=wGod+Nk3hOe0M6ZK7CHVxtlEj5eT2R+jKsLeqipo4XBK8DwdiyVnj9GhuH4eOsRmhxd18vms7KP7n9X4nqduwqKW6pbrUeTflffiGKVlJtCAdheu2EkdgMh5Up2jZcDh4ykQGtkgKJ/w6rpvXckO79jxJoqRNpyend/rDTZuiqY=
Date: Fri, 22 Feb 2008 23:09:56 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/20] x86: Coding Style fixes to arch/x86/lib/strstr_3
Message-ID: <20080222230956.01adc0a9@paolo-desktop>
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
 arch/x86/lib/strstr_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/strstr_32.c b/arch/x86/lib/strstr_32.c
index a3dafbf..42e8a50 100644
--- a/arch/x86/lib/strstr_32.c
+++ b/arch/x86/lib/strstr_32.c
@@ -1,9 +1,9 @@
 #include <linux/string.h>
 
-char * strstr(const char * cs,const char * ct)
+char *strstr(const char *cs, const char *ct)
 {
 int	d0, d1;
-register char * __res;
+register char *__res;
 __asm__ __volatile__(
 	"movl %6,%%edi\n\t"
 	"repne\n\t"
-- 
1.5.4.GIT

