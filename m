Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbXEPJNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbXEPJNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXEPJNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:13:21 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:19039 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770AbXEPJNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:13:19 -0400
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 05:13:18 EDT
Message-ID: <464AC75D.1090701@linux-kernel.at>
Date: Wed, 16 May 2007 10:57:01 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070419 Fedora/2.0.0.0-1.fc7 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [patch] Missing defines in asm-alpha/unistd.h!?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.009, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	PLING_QUERY 1.39)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I believe this is missing... :-) I hope I understood NR_SYSCALLS
correctly and it's the number of defined syscals - as I added 20 of
them, I increased it by 20... Maybe someone can have a look if it's correct.

- --- linux-2.6.21/include/asm-alpha/unistd.h.missing_defines
2007-05-16 10:53:02.000000000 +0200
+++ linux-2.6.21/include/asm-alpha/unistd.h     2007-05-16
10:54:44.000000000 +0200
@@ -388,9 +388,30 @@
 #define __NR_inotify_add_watch         445
 #define __NR_inotify_rm_watch          446

+#define __NR_openat             447
+#define __NR_mkdirat            448
+#define __NR_mknodat            449
+#define __NR_fchownat           450
+#define __NR_futimesat          451
+#define __NR_unlinkat           452
+#define __NR_renameat           453
+#define __NR_linkat             454
+#define __NR_symlinkat          455
+#define __NR_readlinkat         456
+#define __NR_fchmodat           457
+#define __NR_faccessat          458
+#define __NR_pselect6           459
+#define __NR_ppoll              460
+#define __NR_unshare            461
+#define __NR_set_robust_list    462
+#define __NR_get_robust_list    463
+#define __NR_splice             464
+#define __NR_sync_file_range    465
+#define __NR_tee                466
+
 #ifdef __KERNEL__

- -#define NR_SYSCALLS                    447
+#define NR_SYSCALLS                    467

 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR

Best,
 Oliver
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGSsdcxWN5Ge8lKUMRAruUAJ9SElaGQfpU/6f5pAUhM/m+DHUuOACgx3Au
7GvsNTJnlvIKdnOPrSZBWtc=
=h2CN
-----END PGP SIGNATURE-----
