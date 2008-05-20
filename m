Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbYETGxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbYETGxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbYETGwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:52:54 -0400
Received: from hosted.by.hostbasket.com ([85.255.197.33]:58259 "EHLO
	SMTPGate.qlayer.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757224AbYETGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:52:54 -0400
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Jesper Juhl <trivial@kernel.org>
Subject: [PATCH 2.6.26-rc3] Suppress files generated during x86_64 build process in Documentation/dontdiff
Date: Tue, 20 May 2008 08:52:51 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805200852.51831.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress the following additional files generated during an x86_64 kernel
build in Documentation/dontdiff: bounds.h, cpustr.h, mkcpustr, vdso-syms.lds,
vdso.so.dbg, vdso32-syms.lds, vdso32-syscall-syms.lds, vdso32-syscall.so.dbg,
vdso32-sysenter-syms.lds, vdso32-sysenter.so.dbg, vdso32.lds, wakeup.elf
and wakeup.lds

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>

diff -uprN -X Documentation/dontdiff ../orig/linux-2.6.26-rc3/Documentation/dontdiff ./Documentation/dontdiff
--- ../orig/linux-2.6.26-rc3/Documentation/dontdiff	2008-05-20 08:23:09.000000000 +0200
+++ ./Documentation/dontdiff	2008-05-20 08:48:39.000000000 +0200
@@ -72,6 +72,7 @@ bbootsect
 bin2c
 binkernel.spec
 bootsect
+bounds.h
 bsetup
 btfixupprep
 build
@@ -87,6 +88,7 @@ config_data.h*
 config_data.gz*
 conmakehash
 consolemap_deftbl.c*
+cpustr.h
 crc32table.h*
 cscope.*
 defkeymap.c*
@@ -136,6 +138,7 @@ miboot*
 mk_elfconfig
 mkboot
 mkbugboot
+mkcpustr
 mkdep
 mkprep
 mktables
@@ -177,7 +180,15 @@ times.h*
 tkparse
 trix_boot.h
 utsrelease.h*
+vdso-syms.lds
 vdso.lds
+vdso.so.dbg
+vdso32-syms.lds
+vdso32-syscall-syms.lds
+vdso32-syscall.so.dbg
+vdso32-sysenter-syms.lds
+vdso32-sysenter.so.dbg
+vdso32.lds
 version.h*
 vmlinux
 vmlinux-*
@@ -185,6 +196,8 @@ vmlinux.aout
 vmlinux*.lds*
 vmlinux*.scr
 vsyscall.lds
+wakeup.elf
+wakeup.lds
 wanxlfw.inc
 uImage
 unifdef
