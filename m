Return-Path: <linux-kernel-owner+w=401wt.eu-S966017AbXFFXoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966017AbXFFXoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965225AbXFFXls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:41:48 -0400
Received: from 8.sub-75-209-226.myvzw.com ([75.209.226.8]:59412 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965914AbXFFXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:41:46 -0400
Message-Id: <20070606230922.353532407@goop.org>
References: <20070606225837.654272428@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 15:58:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 4/7] define ELF notes for adding to a boot image
Content-Disposition: inline; filename=elf-bootnotes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>

---
 include/linux/elf_boot.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

===================================================================
--- /dev/null
+++ b/include/linux/elf_boot.h
@@ -0,0 +1,15 @@
+#ifndef ELF_BOOT_H
+#define ELF_BOOT_H
+
+/* Elf notes to help bootloaders identify what program they are booting.
+ */
+
+/* Standardized Elf image notes for booting... The name for all of these is ELFBoot */
+#define ELF_NOTE_BOOT		ELFBoot
+
+#define EIN_PROGRAM_NAME	1 /* The program in this ELF file */
+#define EIN_PROGRAM_VERSION	2 /* The version of the program in this ELF file */
+#define EIN_PROGRAM_CHECKSUM	3 /* ip style checksum of the memory image. */
+#define EIN_ARGUMENT_STYLE	4 /* String identifying argument passing style */
+
+#endif /* ELF_BOOT_H */

-- 

