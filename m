Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYGHMr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYGHMr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbYGHMpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:45:51 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27555 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759343AbYGHMpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:45:46 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 46/58] microblaze_v5: headers simple files - empty or redirect to asm-generic
Date: Tue,  8 Jul 2008 13:59:46 +0200
Message-Id: <a98df8525bf9287d7a8b6077ff20dd61a055a98e.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <c4f477d71dd4cd2ae884b9c47756c9334f8dac18.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
 <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
 <7a16429cfc461420883dbaa80c16047e5a1a91c1.1215517976.git.monstr@monstr.eu>
 <b6a0f3bceb0867c55613463fc43be5328fcedecd.1215517976.git.monstr@monstr.eu>
 <fc26823d77c7180b62022e2d4bcca3c4fe6de574.1215517976.git.monstr@monstr.eu>
 <64089967061955b7a29eb6d4e6269ff75b5442f2.1215517976.git.monstr@monstr.eu>
 <92e3ab88c2174acf4e25c474c1f68ffd4db72ca6.1215517976.git.monstr@monstr.eu>
 <5174afd0eaa5c6cb9344ea3217199e48899be313.1215517976.git.monstr@monstr.eu>
 <bcb94400dca62fb349d0ab1e0a6209291fdcdfc5.1215517976.git.monstr@monstr.eu>
 <5b2ed516b2e51d5117386c1b6eb814acc6e5a157.1215517976.git.monstr@monstr.eu>
 <421f4b613d4dbd983df1545a9a163347e5bd1c56.1215517976.git.monstr@monstr.eu>
 <0d39e8f03c487c004efa226c5ee81a81a8856768.1215517976.git.monstr@monstr.eu>
 <c4f477d71dd4cd2ae884b9c47756c9334f8dac18.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/cputime.h           |    1 +
 include/asm-microblaze/div64.h             |    1 +
 include/asm-microblaze/emergency-restart.h |    1 +
 include/asm-microblaze/errno.h             |    1 +
 include/asm-microblaze/fcntl.h             |    1 +
 include/asm-microblaze/futex.h             |    1 +
 include/asm-microblaze/kdebug.h            |    1 +
 include/asm-microblaze/local.h             |    1 +
 include/asm-microblaze/mutex.h             |    1 +
 include/asm-microblaze/namei.h             |   14 ++++++++++++++
 include/asm-microblaze/percpu.h            |    1 +
 include/asm-microblaze/resource.h          |    1 +
 include/asm-microblaze/sockios.h           |   23 +++++++++++++++++++++++
 include/asm-microblaze/ucontext.h          |    1 +
 14 files changed, 49 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/auxvec.h
 create mode 100644 include/asm-microblaze/cputime.h
 create mode 100644 include/asm-microblaze/div64.h
 create mode 100644 include/asm-microblaze/emergency-restart.h
 create mode 100644 include/asm-microblaze/errno.h
 create mode 100644 include/asm-microblaze/fcntl.h
 create mode 100644 include/asm-microblaze/futex.h
 create mode 100644 include/asm-microblaze/kdebug.h
 create mode 100644 include/asm-microblaze/local.h
 create mode 100644 include/asm-microblaze/mutex.h
 create mode 100644 include/asm-microblaze/namei.h
 create mode 100644 include/asm-microblaze/percpu.h
 create mode 100644 include/asm-microblaze/resource.h
 create mode 100644 include/asm-microblaze/sockios.h
 create mode 100644 include/asm-microblaze/ucontext.h
 create mode 100644 include/asm-microblaze/user.h

diff --git a/include/asm-microblaze/auxvec.h b/include/asm-microblaze/auxvec.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/asm-microblaze/cputime.h b/include/asm-microblaze/cputime.h
new file mode 100644
index 0000000..6d68ad7
--- /dev/null
+++ b/include/asm-microblaze/cputime.h
@@ -0,0 +1 @@
+#include <asm-generic/cputime.h>
diff --git a/include/asm-microblaze/div64.h b/include/asm-microblaze/div64.h
new file mode 100644
index 0000000..6cd978c
--- /dev/null
+++ b/include/asm-microblaze/div64.h
@@ -0,0 +1 @@
+#include <asm-generic/div64.h>
diff --git a/include/asm-microblaze/emergency-restart.h b/include/asm-microblaze/emergency-restart.h
new file mode 100644
index 0000000..3711bd9
--- /dev/null
+++ b/include/asm-microblaze/emergency-restart.h
@@ -0,0 +1 @@
+#include <asm-generic/emergency-restart.h>
diff --git a/include/asm-microblaze/errno.h b/include/asm-microblaze/errno.h
new file mode 100644
index 0000000..4c82b50
--- /dev/null
+++ b/include/asm-microblaze/errno.h
@@ -0,0 +1 @@
+#include <asm-generic/errno.h>
diff --git a/include/asm-microblaze/fcntl.h b/include/asm-microblaze/fcntl.h
new file mode 100644
index 0000000..46ab12d
--- /dev/null
+++ b/include/asm-microblaze/fcntl.h
@@ -0,0 +1 @@
+#include <asm-generic/fcntl.h>
diff --git a/include/asm-microblaze/futex.h b/include/asm-microblaze/futex.h
new file mode 100644
index 0000000..0b74582
--- /dev/null
+++ b/include/asm-microblaze/futex.h
@@ -0,0 +1 @@
+#include <asm-generic/futex.h>
diff --git a/include/asm-microblaze/kdebug.h b/include/asm-microblaze/kdebug.h
new file mode 100644
index 0000000..6ece1b0
--- /dev/null
+++ b/include/asm-microblaze/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff --git a/include/asm-microblaze/local.h b/include/asm-microblaze/local.h
new file mode 100644
index 0000000..c11c530
--- /dev/null
+++ b/include/asm-microblaze/local.h
@@ -0,0 +1 @@
+#include <asm-generic/local.h>
diff --git a/include/asm-microblaze/mutex.h b/include/asm-microblaze/mutex.h
new file mode 100644
index 0000000..ff6101a
--- /dev/null
+++ b/include/asm-microblaze/mutex.h
@@ -0,0 +1 @@
+#include <asm-generic/mutex-dec.h>
diff --git a/include/asm-microblaze/namei.h b/include/asm-microblaze/namei.h
new file mode 100644
index 0000000..743f0f3
--- /dev/null
+++ b/include/asm-microblaze/namei.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_MICROBLAZE_NAMEI_H
+#define _ASM_MICROBLAZE_NAMEI_H
+
+#ifdef __KERNEL__
+
+/* This dummy routine maybe changed to something useful
+ * for /usr/gnemul/ emulation stuff.
+ * Look at asm-sparc/namei.h for details.
+ */
+#define __emul_prefix() NULL
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_MICROBLAZE_NAMEI_H */
diff --git a/include/asm-microblaze/percpu.h b/include/asm-microblaze/percpu.h
new file mode 100644
index 0000000..06a959d
--- /dev/null
+++ b/include/asm-microblaze/percpu.h
@@ -0,0 +1 @@
+#include <asm-generic/percpu.h>
diff --git a/include/asm-microblaze/resource.h b/include/asm-microblaze/resource.h
new file mode 100644
index 0000000..04bc4db
--- /dev/null
+++ b/include/asm-microblaze/resource.h
@@ -0,0 +1 @@
+#include <asm-generic/resource.h>
diff --git a/include/asm-microblaze/sockios.h b/include/asm-microblaze/sockios.h
new file mode 100644
index 0000000..41d1a0c
--- /dev/null
+++ b/include/asm-microblaze/sockios.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SOCKIOS_H
+#define _ASM_MICROBLAZE_SOCKIOS_H
+
+#include <asm/ioctl.h>
+
+/* Socket-level I/O control calls. */
+#define FIOSETOWN	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
+
+#endif /* _ASM_MICROBLAZE_SOCKIOS_H */
diff --git a/include/asm-microblaze/ucontext.h b/include/asm-microblaze/ucontext.h
new file mode 100644
index 0000000..9bc07b9
--- /dev/null
+++ b/include/asm-microblaze/ucontext.h
@@ -0,0 +1 @@
+#include <asm-generic/ucontext.h>
diff --git a/include/asm-microblaze/user.h b/include/asm-microblaze/user.h
new file mode 100644
index 0000000..e69de29
-- 
1.5.4.GIT

