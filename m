Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYABBJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYABBJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbYABBIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:08:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59400 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbYABBIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:08:55 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [patch] asm-x86/msr.h: pull in linux/types.h
Date: Tue, 1 Jan 2008 20:08:52 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801012008.53275.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention this before, but since the msr.h header uses types like
__u32, it should pull in linux/types.h.

Signed-Off-By: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index ba4b314..beea1bf 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -2,6 +2,7 @@
 #define __ASM_X86_MSR_H_
 
 #include <asm/msr-index.h>
+#include <linux/types.h>
 
 #ifdef __i386__
 
