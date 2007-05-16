Return-Path: <linux-kernel-owner+w=401wt.eu-S934406AbXEPWwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406AbXEPWwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762598AbXEPWuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:50:12 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:45791 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762507AbXEPWuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:50:10 -0400
Date: Thu, 17 May 2007 00:49:38 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jdike@karaya.com
Subject: UML doesn't compile in 2.6.21
Message-ID: <20070516224938.GN12319@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

Any idea how this could happen? I'm trying to build 2.6.21 for ARCH=um, and the
linker stage explodes here:

  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
lib/lib.a(bug.o): In function `find_bug':
bug.c:(.text+0x171): undefined reference to `__start___bug_table'
bug.c:(.text+0x177): undefined reference to `__stop___bug_table'
bug.c:(.text+0x180): undefined reference to `__start___bug_table'
bug.c:(.text+0x193): undefined reference to `__stop___bug_table'
collect2: ld returned 1 exit status
  KSYM    .tmp_kallsyms1.S
nm: '.tmp_vmlinux1': No such file
No valid symbol.
make[1]: *** [.tmp_kallsyms1.S] Error 1

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

