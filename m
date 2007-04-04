Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXDDUcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXDDUcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbXDDUcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:32:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47365 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXDDUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=NvUJeJzccRhQBEF6ZpYtAgstImx4GqXMNgFHaFDrz5EltPQ1Fenhel0Exm91qLptijdShxIsPotvzzXcsCyB8Yppu/+qlRDi6pKVYtTI+tRbIgE8RQu0zM2tLMnnELkG43unNksvzdg30AcpsHvpqG9I0ThB+ddw5z+J0nZwxVs=
Date: Thu, 5 Apr 2007 00:33:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] i386: sched.h inclusion from module.h is baack
Message-ID: <20070404203309.GA6316@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux/module.h
linux/elf.h
asm-i386/elf.h
linux/utsname.h
linux/sched.h

Noticeably cut the number of files which are rebuild upon touching
sched.h and cut down pulled junk from every module.h inclusion.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/i8k.c     |    1 +
 fs/binfmt_elf.c        |    1 +
 include/asm-i386/elf.h |    2 --
 3 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -22,6 +22,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/dmi.h>
+#include <linux/capability.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -39,6 +39,7 @@
 #include <linux/syscalls.h>
 #include <linux/random.h>
 #include <linux/elf.h>
+#include <linux/utsname.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -9,8 +9,6 @@
 #include <asm/user.h>
 #include <asm/auxvec.h>
 
-#include <linux/utsname.h>
-
 #define R_386_NONE	0
 #define R_386_32	1
 #define R_386_PC32	2

