Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYF0VpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYF0VpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764107AbYF0Vh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764275AbYF0Vh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:57 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 21/39] don't use word-size specifiers in putuser files
Date: Fri, 27 Jun 2008 18:34:28 -0300
Message-Id: <1214602486-17080-22-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-21-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
 <1214602486-17080-20-git-send-email-gcosta@redhat.com>
 <1214602486-17080-21-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove them where unambiguous.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/putuser_32.S |   28 ++++++++++++++--------------
 arch/x86/lib/putuser_64.S |   14 +++++++-------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/lib/putuser_32.S b/arch/x86/lib/putuser_32.S
index 5b2a926..b67a37c 100644
--- a/arch/x86/lib/putuser_32.S
+++ b/arch/x86/lib/putuser_32.S
@@ -33,44 +33,44 @@
 .text
 ENTRY(__put_user_1)
 	ENTER
-	cmpl TI_addr_limit(%ebx),%ecx
+	cmp TI_addr_limit(%ebx),%ecx
 	jae bad_put_user
 1:	movb %al,(%ecx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	ENTER
-	movl TI_addr_limit(%ebx),%ebx
-	subl $1,%ebx
-	cmpl %ebx,%ecx
+	mov TI_addr_limit(%ebx),%ebx
+	sub $1,%ebx
+	cmp %ebx,%ecx
 	jae bad_put_user
 2:	movw %ax,(%ecx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	ENTER
-	movl TI_addr_limit(%ebx),%ebx
-	subl $3,%ebx
-	cmpl %ebx,%ecx
+	mov TI_addr_limit(%ebx),%ebx
+	sub $3,%ebx
+	cmp %ebx,%ecx
 	jae bad_put_user
 3:	movl %eax,(%ecx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	ENTER
-	movl TI_addr_limit(%ebx),%ebx
-	subl $7,%ebx
-	cmpl %ebx,%ecx
+	mov TI_addr_limit(%ebx),%ebx
+	sub $7,%ebx
+	cmp %ebx,%ecx
 	jae bad_put_user
 4:	movl %eax,(%ecx)
 5:	movl %edx,4(%ecx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_8)
 
diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
index 6d7513b..c18fc0f 100644
--- a/arch/x86/lib/putuser_64.S
+++ b/arch/x86/lib/putuser_64.S
@@ -39,10 +39,10 @@
 	.text
 ENTRY(__put_user_1)
 	ENTER
-	cmpq TI_addr_limit(%rbx),%rcx
+	cmp TI_addr_limit(%rbx),%rcx
 	jae bad_put_user
 1:	movb %al,(%rcx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_1)
 
@@ -50,10 +50,10 @@ ENTRY(__put_user_2)
 	ENTER
 	mov TI_addr_limit(%rbx),%rbx
 	sub  $1, %rbx
-	cmpq %rbx ,%rcx
+	cmp %rbx ,%rcx
 	jae  bad_put_user
 2:	movw %ax,(%rcx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_2)
 
@@ -64,7 +64,7 @@ ENTRY(__put_user_4)
 	cmp  %rbx, %rcx
 	jae bad_put_user
 3:	movl %eax,(%rcx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_4)
 
@@ -75,13 +75,13 @@ ENTRY(__put_user_8)
 	cmp  %rbx, %rcx
 	jae bad_put_user
 4:	movq %rax,(%rcx)
-	xorl %eax,%eax
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_8)
 
 bad_put_user:
 	CFI_STARTPROC
-	movq $(-EFAULT),%rax
+	mov $(-EFAULT),%rax
 	EXIT
 END(bad_put_user)
 
-- 
1.5.5.1

