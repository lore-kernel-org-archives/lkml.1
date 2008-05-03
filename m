Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbYECKeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbYECKeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761226AbYECKdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:33:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57288 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbYECKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=Ap+Uz6kmiFVKVZvR5uZj04GL4VuTW9hZ6JsPxV/TEhzBhR5T6FQXNB3nMLyP42MebKgcuOnZuijWqPFxQ666MdbWwenUpuEAbG3dKE17oyr6X9JevXglW7GCHoVIjI+NvrCnaHE3VddesNNtDFkwUny/ktLU6y/jU/Erb8a506g=
References: <20080503101800.417039810@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 03 May 2008 14:18:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 3/4] x86: relocs ELF handling - use SELFMAG instead of numeric constant
Content-Disposition: inline; filename=x86-elf-compressed
Message-ID: <481c3f59.0407560a.2cbe.ffffd575@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/boot/compressed/relocs.c
===================================================================
--- linux-2.6.git.orig/arch/x86/boot/compressed/relocs.c	2008-04-29 21:20:57.000000000 +0400
+++ linux-2.6.git/arch/x86/boot/compressed/relocs.c	2008-05-02 21:38:41.000000000 +0400
@@ -191,7 +191,7 @@ static void read_ehdr(FILE *fp)
 		die("Cannot read ELF header: %s\n",
 			strerror(errno));
 	}
-	if (memcmp(ehdr.e_ident, ELFMAG, 4) != 0) {
+	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
 		die("No ELF magic\n");
 	}
 	if (ehdr.e_ident[EI_CLASS] != ELFCLASS32) {

-- 
