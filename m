Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYBJMtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYBJMtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbYBJMss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:48:48 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:23306 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbYBJMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=mk8IR4NWPpA6js1GhN2EoM88V3uk33vVKvTpNdNyar+w0t7HxHKUGy5eUby1QnNKRvgLqC6MJAAeVxVjUbW5rhM8Rd54tx4xb+ohixotr0kmzxOXBETqlhwMdoJDJdeVww5XK11WfXuLnfxHjqtH0sAYkpXJyBSsjWLUKoxNYzg=
Message-Id: <20080210124821.777700517@gmail.com>
References: <20080210124323.068409407@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 10 Feb 2008 15:43:24 +0300
From: gorcunov@gmail.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com
Subject: [patch 1/2] ELF: Use EI_NIDENT instead of numeric value
Content-Disposition: inline; filename=elf-EI_NIDENT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 elf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/include/linux/elf.h
===================================================================
--- linux-2.6.git.orig/include/linux/elf.h	2008-02-08 19:09:52.000000000 +0300
+++ linux-2.6.git/include/linux/elf.h	2008-02-10 10:49:54.000000000 +0300
@@ -208,7 +208,7 @@ typedef struct elf32_hdr{
 } Elf32_Ehdr;
 
 typedef struct elf64_hdr {
-  unsigned char	e_ident[16];		/* ELF "magic number" */
+  unsigned char	e_ident[EI_NIDENT];	/* ELF "magic number" */
   Elf64_Half e_type;
   Elf64_Half e_machine;
   Elf64_Word e_version;

-- 
