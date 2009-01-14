Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbZANUnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbZANUnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbZANUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:42:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:54850 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbZANUmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=gif4Agc48EV8Jf1plyNRKxsTDn64jHWq1bBAFvHyQUKNrUqAVW7dcjTAXYXsODCj2p
         zDIKH/wMCIK6OohJjh/mvLbvEVvKTXktIWBc6nPHKRTS5Snsxsu3IKiazAT9aWHYgShp
         vZg+tR4m8f1/15xjiJOcwHM8ba2ZsbQN5ysKs=
References: <20090114203745.285473388@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 23:37:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, sam@ravnborg.org, jaswinderrajput@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/5] x86: headers cleanup - sigcontext32.h
Content-Disposition: inline; filename=x86-header-sigcontext32-h
Message-ID: <496e4e23.0407560a.4832.fffff96d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

'make headers_check' warn us about lack of linux/types.h
here. Lets add it.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

---
 arch/x86/include/asm/sigcontext32.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/sigcontext32.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/sigcontext32.h
+++ linux-2.6.git/arch/x86/include/asm/sigcontext32.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_SIGCONTEXT32_H
 #define _ASM_X86_SIGCONTEXT32_H
 
+#include <linux/types.h>
+
 /* signal context for 32bit programs. */
 
 #define X86_FXSR_MAGIC		0x0000

-- 
