Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbYDSPJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbYDSPJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762540AbYDSPHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:07:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762533AbYDSPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=V3/ZoAMiK8ZFMxD2q4aw5efSVvVt6wFLs626e7+Q1GifZ+m7ayozs6al1e6swOGAcidYpQeQeFKOlDTbS/CnmMM0DIQizfRv+Bi+XgT3WlnDO7jBcMkRWDk/lmnq52hteIyjXLjD6tbGhIMLyq+rWRe1sDs0i7HL89oTRLjFzyw=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:18 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 08/10] x86: get_bios_ebda() requires asm/io.h
Content-Disposition: inline; filename=x86-use-get-bios-ebda-1.patch
Message-ID: <480a0a9f.0f98600a.6f10.3cf5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include <asm/io.h> for phys_to_virt()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/asm-x86/bios_ebda.h |    2 ++
 1 file changed, 2 insertions(+)

Index: 2.6-git/include/asm-x86/bios_ebda.h
===================================================================
--- 2.6-git.orig/include/asm-x86/bios_ebda.h
+++ 2.6-git/include/asm-x86/bios_ebda.h
@@ -1,6 +1,8 @@
 #ifndef _MACH_BIOS_EBDA_H
 #define _MACH_BIOS_EBDA_H
 
+#include <asm/io.h>
+
 /*
  * there is a real-mode segmented pointer pointing to the
  * 4K EBDA area at 0x40E.

-- 
