Return-Path: <linux-kernel-owner+w=401wt.eu-S965969AbXBOPG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965969AbXBOPG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965968AbXBOPG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:06:29 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54770 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965969AbXBOPG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:06:28 -0500
Date: Thu, 15 Feb 2007 16:06:23 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?Q?=5BPATCH=5D_do=5Fbasic=5Fsetup=3A_implicit_declaration_?=
 =?UTF-8?Q?of_function_=E2=80=98init=5Firq=5Fproc'?=
Message-ID: <Pine.LNX.4.62.0702151604230.13011@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1534635628-1171551983=:13011"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1534635628-1171551983=:13011
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Add missing #include <linux/irq.h>, which caused

| init/main.c: In function ‘do_basic_setup’:
| init/main.c:705: warning: implicit declaration of function ‘init_irq_proc’

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/init/main.c b/init/main.c
index 2421e15..8bba00e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -52,6 +52,7 @@
 #include <linux/lockdep.h>
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
+#include <linux/irq.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
---584337861-1534635628-1171551983=:13011--
