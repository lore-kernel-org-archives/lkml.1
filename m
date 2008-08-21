Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYHUPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYHUPTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbYHUPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:19:05 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34360 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbYHUPTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:19:03 -0400
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>
Subject: UML build failure in 2.6.27-rc3
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1KWBwC-0002dN-KE@closure.thunk.org>
Date: Thu, 21 Aug 2008 11:19:00 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this a known problem?

  SYMLINK arch/um/include/kern_constants.h
  SYMLINK arch/um/include/sysdep
make[2]: `arch/um/sys-i386/user-offsets.s' is up to date.
  CHK     arch/um/include/user_constants.h
  Using /usr/projects/linux/ext4 as source for kernel
  GEN     /usr/projects/linux/uml/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    /usr/projects/linux/ext4/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      arch/um/kernel/ptrace.o
/usr/projects/linux/ext4/arch/um/kernel/ptrace.c:230: error: static declaration of ‘send_sigtrap’ follows non-static declaration
include2/asm/ptrace-generic.h:51: error: previous declaration of ‘send_sigtrap’ was here
make[2]: *** [arch/um/kernel/ptrace.o] Error 1
make[1]: *** [arch/um/kernel] Error 2
make: *** [sub-make] Error 2
