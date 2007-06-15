Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXFOOtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXFOOtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXFOOtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:49:00 -0400
Received: from gw.goop.org ([64.81.55.164]:34342 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXFOOtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:49:00 -0400
Message-Id: <20070615005012.882738673@goop.org>
References: <20070615004818.424726597@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 17:48:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: [PATCH 03/10] define ELF notes for adding to a boot image
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

