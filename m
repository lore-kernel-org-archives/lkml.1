Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZDDP2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZDDP2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 11:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZDDP2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 11:28:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:62802 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZDDP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 11:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JmgjUyqOVjeJWIaRIBjdH3igcpEnAah3xkRPEJT8LvkXlEj19HEoTX+8WR5j0xX/rR
         AsbJ7Dtdg6XR0BdK7PkeawRl6wwZgUOgo0CD3r8232Rba5gVRuOYSKhGmaO5dhevPJBa
         KEWy3U8+RHBwovinyrE8UorwaJavfiPYWcCRo=
MIME-Version: 1.0
Date: Sat, 4 Apr 2009 23:28:05 +0800
Message-ID: <d82e647a0904040828n27af9173t7239b1822e6dc9ca@mail.gmail.com>
Subject: [BUG 2.6.29] make install failed
From: Ming Lei <tom.leiming@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6bb597507f9839b1349878

[lm@linux-lm linux-2.6]$ sudo make install
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  SKIPPED include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  CC      kernel/trace/trace.o
  LD      kernel/trace/built-in.o
  CC      kernel/module.o
  LD      kernel/built-in.o

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  SKIPPED include/linux/compile.h
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
sh /home/lm/git/linux-2.6/linux-2.6/arch/x86/boot/install.sh 2.6.29
arch/x86/boot/bzImage \
		System.map "/boot"
WARNING: Couldn't open directory /lib/modules/2.6.29: No such file or directory
FATAL: Could not open /lib/modules/2.6.29/modules.dep.temp for
writing: No such file or directory
No modules available for kernel "2.6.29".
mkinitrd failed


-- 
Lei Ming
