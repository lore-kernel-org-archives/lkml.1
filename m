Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYBGJNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYBGJNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYBGJN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:13:26 -0500
Received: from ns.store20.com ([212.7.7.16]:45089 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbYBGJNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:13:25 -0500
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 04:13:24 EST
Subject: Build failure on arch/x86/vdso/built-in.o: In function
	`init_vdso_vars'
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Feb 2008 11:01:55 +0200
Message-Id: <1202374915.27171.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

This is with latest Linus's tree. It started IIRC just after the big x86
merge. Machine is amd64, no 32-bit emulation set.
.config here: http://plaes.org/files/2008-Q1/dot_config_VDSO64_error

[snip]
  LD      vmlinux.o
  MODPOST vmlinux.o
modpost: Found 29 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/x86/vdso/built-in.o: In function `init_vdso_vars':
vma.c:(.init.text+0x170): undefined reference to `VDSO64_vgetcpu_mode'
vma.c:(.init.text+0x1a3): undefined reference to `VDSO64_vsyscall_gtod_data'
vma.c:(.init.text+0x1aa): undefined reference to `VDSO64_vgetcpu_mode'
vma.c:(.init.text+0x1d8): undefined reference to `VDSO64_vsyscall_gtod_data'
make: *** [.tmp_vmlinux1] Error 1

[/snip]

Cheers,
Priit :)
