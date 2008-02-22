Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYBVWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYBVWTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761626AbYBVWLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:11:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528AbYBVWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=onHVnnuAb16i+mcuPSFueLfTAkBXaj2T1yhIyCS/UVQ/IPS4ei62iFeGHHGVGCbcbFKocg5NtDttOJTPOcQENDvuanf4c5N24VktPYi2JKRG4UPE9ZUvvh9aDmAxbc/YDmcB4jmOy2xRLNUQF4i5An3/LbcIo9pZyavUQlbdobU=
Date: Fri, 22 Feb 2008 23:11:12 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/20] x86: Coding Style fixes to arch/x86/boot/cpucheck.c
Message-ID: <20080222231112.0fff283b@paolo-desktop>
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
 arch/x86/boot/cpucheck.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 769065b..2462c88 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -56,27 +56,27 @@ static const u32 req_flags[NCAPINTS] =
 	REQUIRED_MASK7,
 };
 
-#define A32(a,b,c,d) (((d) << 24)+((c) << 16)+((b) << 8)+(a))
+#define A32(a, b, c, d) (((d) << 24)+((c) << 16)+((b) << 8)+(a))
 
 static int is_amd(void)
 {
-	return cpu_vendor[0] == A32('A','u','t','h') &&
-	       cpu_vendor[1] == A32('e','n','t','i') &&
-	       cpu_vendor[2] == A32('c','A','M','D');
+	return cpu_vendor[0] == A32('A', 'u', 't', 'h') &&
+	       cpu_vendor[1] == A32('e', 'n', 't', 'i') &&
+	       cpu_vendor[2] == A32('c', 'A', 'M', 'D');
 }
 
 static int is_centaur(void)
 {
-	return cpu_vendor[0] == A32('C','e','n','t') &&
-	       cpu_vendor[1] == A32('a','u','r','H') &&
-	       cpu_vendor[2] == A32('a','u','l','s');
+	return cpu_vendor[0] == A32('C', 'e', 'n', 't') &&
+	       cpu_vendor[1] == A32('a', 'u', 'r', 'H') &&
+	       cpu_vendor[2] == A32('a', 'u', 'l', 's');
 }
 
 static int is_transmeta(void)
 {
-	return cpu_vendor[0] == A32('G','e','n','u') &&
-	       cpu_vendor[1] == A32('i','n','e','T') &&
-	       cpu_vendor[2] == A32('M','x','8','6');
+	return cpu_vendor[0] == A32('G', 'e', 'n', 'u') &&
+	       cpu_vendor[1] == A32('i', 'n', 'e', 'T') &&
+	       cpu_vendor[2] == A32('M', 'x', '8', '6');
 }
 
 static int has_fpu(void)
-- 
1.5.4.GIT

