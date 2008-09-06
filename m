Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYIFVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYIFVf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYIFVfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:35:10 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:53310 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYIFVfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:35:09 -0400
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2008 17:35:08 EDT
Date: Sat, 6 Sep 2008 23:22:34 +0200
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200809062122.m86LMYJg026138@hitchhiker.org.lu>
Subject: [PATCH] documentation: clean up extras and omissions in dontdiff
To: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <alain@knaff.lu>
X-Mailer: mail (GNU Mailutils 1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alain Knaff <alain@knaff.lu>

While making the bzip/lzma compression patch, I noticed that
vmlinux.scr was mistakenly listed in Documentation/dontdiff although
it is a source file, and not a generated file (it's present in the .tar
archive)

However, a couple of files that were really generated were missing.

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -purN -X linux-2.6.26.3udpcast/Documentation/dontdiff linux-2.6.26.3/Documentation/dontdiff linux-2.6.26.3udpcast/Documentation/dontdiff
--- linux-2.6.26.3/Documentation/dontdiff	2008-08-20 20:11:37.000000000 +0200
+++ linux-2.6.26.3udpcast/Documentation/dontdiff	2008-09-06 22:04:53.000000000 +0200
@@ -183,10 +183,18 @@ vmlinux
 vmlinux-*
 vmlinux.aout
 vmlinux*.lds*
-vmlinux*.scr
 vsyscall.lds
 wanxlfw.inc
 uImage
 unifdef
 zImage*
 zconf.hash.c
+bounds.h
+cpustr.h
+vdso-syms.lds
+vdso.so.dbg
+mkcpustr
+vmlinux.bin.all
+vmlinux.bin.lzma
+vmlinux.bin.bz2
+vmlinux.bin.gz
