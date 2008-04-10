Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYDJDjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYDJDjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 23:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYDJDi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 23:38:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:42174 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYDJDi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 23:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cV/mIplEz2OWWmg7gq7wdjk2nPAtv275rSEQBZ7aJXVWnfMoaQQOCD4GhS1Xr23XzLVB5bNAZFnlL+LRhAVCNBDUglgguDqDrauWvauiQLf4/6J3mkHOa6NSpsdMmuj4Qa4wHHg3V4iEUlzRdbt9USA45nXBvyK/DeZJsAXljPU=
Message-ID: <af3ea28a0804092038q59a5b907ndb3d9fa33a6be834@mail.gmail.com>
Date: Thu, 10 Apr 2008 11:38:55 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH]kbuild: add arm, mips and i386 macros
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a80cc2fe14ce7e7a6de70b5927b9c0a6ee530805
Author: janboe <janboe.ye@gmail.com>
Date:   Thu Apr 10 11:18:03 2008 +0800

    the commits 56a974fa2d595fe6ebe433c525b8232ead539b76 and
ae4ac12323c0ff80528cac3269151d580e23f923
    involved additional macros but not available on cygwin.
Signed-off-by: Janboe Ye <janboe.ye@gmail.com>
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 09f58e3..f864ab8 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -42,6 +42,16 @@
 #define ELF_R_SYM   ELF64_R_SYM
 #define ELF_R_TYPE  ELF64_R_TYPE
 #endif
+#define R_386_32           1            /* Direct 32 bit  */
+#define R_386_PC32         2            /* PC relative 32 bit */
+
+#define R_ARM_PC24              1       /* PC relative 26 bit branch */
+#define R_ARM_ABS32             2       /* Direct 32 bit  */
+
+#define R_MIPS_32               2       /* Direct 32 bit */
+#define R_MIPS_26               4       /* Direct 26 bit shifted */
+#define R_MIPS_HI16             5       /* High 16 bit */
+#define R_MIPS_LO16             6       /* Low 16 bit */

 /* The 64-bit MIPS ELF ABI uses an unusual reloc format. */
 typedef struct
