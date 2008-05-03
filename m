Return-Path: <linux-kernel-owner+w=401wt.eu-S1764932AbYECKej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764932AbYECKej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761511AbYECKdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:33:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:57321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857AbYECKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=YuhOnNltaoEWLWb+CsdJGN2BQshTIz13Gq4sLf8vIv87zcunsEU1YEJV/m9hGau7QDdsK2oM8dSAaVN1a5Dc8mjR7aKTLcvJD6mnRCXi0qSrzrg9boLS2EaYazsUluVtJR03F6KCtDkX2EI8y6HHTEjddhqdfoXdBsAQleYOZJ8=
References: <20080503101800.417039810@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 03 May 2008 14:18:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 4/4] MIPS: ELF handling - use SELFMAG instead of numeric constant
Content-Disposition: inline; filename=mips-elf
Message-ID: <481c3f59.0407560a.2d49.ffffbf04@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/mips/kernel/vpe.c
===================================================================
--- linux-2.6.git.orig/arch/mips/kernel/vpe.c	2008-04-15 23:01:26.000000000 +0400
+++ linux-2.6.git/arch/mips/kernel/vpe.c	2008-05-02 21:40:57.000000000 +0400
@@ -840,7 +840,7 @@ static int vpe_elfload(struct vpe * v)
 
 	/* Sanity checks against insmoding binaries or wrong arch,
 	   weird elf version */
-	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0
+	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
 	    || (hdr->e_type != ET_REL && hdr->e_type != ET_EXEC)
 	    || !elf_check_arch(hdr)
 	    || hdr->e_shentsize != sizeof(*sechdrs)) {

-- 
