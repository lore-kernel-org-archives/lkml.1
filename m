Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZBWUDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZBWUDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZBWUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:18 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:47676 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbZBWUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=E5arifb99X5fwKCXvOaZ+prqeNJz6B3i9t696O8enc6YX/zGYwoj+Sf9CwcV+6a/bn
         3ZE0karBw0B5HbHu4tZnC5N1bFq5MP0Nim6HpUOpHsNxNCzTCsR92uiCgKEZIyPPL/Uz
         UQEZVCjUD+X0Jo+EVu5bfGE4fBzhnmueeYNzM=
Message-Id: <20090223200227.003422554@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 23 Feb 2009 22:56:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: heukelum@fastmail.fm, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/6] x86: invalid_vm86_irq -- use predefined macros
References: <20090223195656.512422509@openvz.org>
Content-Disposition: inline; filename=x86-invalid_vm86_irq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

 arch/x86/include/asm/irq_vectors.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6.git/arch/x86/include/asm/irq_vectors.h
@@ -128,7 +128,7 @@
 #ifndef __ASSEMBLY__
 static inline int invalid_vm86_irq(int irq)
 {
-	return irq < 3 || irq > 15;
+	return irq < FIRST_VM86_IRQ || irq > LAST_VM86_IRQ;
 }
 #endif
 

