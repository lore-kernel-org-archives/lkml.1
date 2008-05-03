Return-Path: <linux-kernel-owner+w=401wt.eu-S1764414AbYECKdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764414AbYECKdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759722AbYECKdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:33:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054AbYECKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=XPazSygtrbk7hzLIgeTsmCFbyCwu7Pm1xVJQ+ptWv1LaZHmt9Oe+YF9PbHvWxttLfmKNVVNSzUVU3glN6ZzBhXy1l6YP4gSW0UxAkQkpSJ6P/tAsHq2wkh0ums/EMky2TsXbBsA+QE++TR4A7htY/sSM2oclMT7S5q6gHtQP0HA=
References: <20080503101800.417039810@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 03 May 2008 14:18:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 1/4] x86: vdso ELF handling - use SELFMAG instead of numeric constant
Content-Disposition: inline; filename=elf-x86
Message-ID: <481c3f58.0c58560a.0fd6.ffff9d33@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/vdso/vdso32-setup.c
===================================================================
--- linux-2.6.git.orig/arch/x86/vdso/vdso32-setup.c	2008-05-01 11:07:57.000000000 +0400
+++ linux-2.6.git/arch/x86/vdso/vdso32-setup.c	2008-05-02 21:25:10.000000000 +0400
@@ -162,7 +162,7 @@ static __init void relocate_vdso(Elf32_E
 	Elf32_Shdr *shdr;
 	int i;
 
-	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, 4) != 0 ||
+	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0 ||
 	       !elf_check_arch_ia32(ehdr) ||
 	       ehdr->e_type != ET_DYN);
 

-- 
