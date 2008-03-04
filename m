Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbYCDTfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbYCDTfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbYCDTfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:35:05 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57710 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928AbYCDTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:35:04 -0500
Date: Tue, 4 Mar 2008 19:33:24 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: a P4 is a P6 not an i486
Message-ID: <Pine.LNX.4.64.0803041929230.14934@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P4 has been coming out as CPU_FAMILY=4 instead of 6: fix MPENTIUM4 typo.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.25-rc3-git/arch/x86/Kconfig.cpu	2008-02-27 07:57:20.000000000 +0000
+++ linux/arch/x86/Kconfig.cpu	2008-03-04 13:50:39.000000000 +0000
@@ -388,7 +388,7 @@ config X86_OOSTORE
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || PENTIUM4)
+	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4)
 
 config X86_TSC
 	def_bool y
