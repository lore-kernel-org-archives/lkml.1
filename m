Return-Path: <linux-kernel-owner+w=401wt.eu-S1030632AbXC2ScB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030632AbXC2ScB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXC2ScB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:32:01 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:40268 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030632AbXC2ScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:32:00 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 14:32:00 EDT
Date: Thu, 29 Mar 2007 20:20:20 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
Message-ID: <20070329182020.GA9223@aitel.hist.no>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326211627.c681af3b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tried compiling this on x86-64, and got this compile error:
  CC      init/version.o
  CC      init/missing_syscalls.o
In file included from init/missing_syscalls.c:97:
init/missing_syscalls.h:279:2: warning: #warning syscall ssetmask not
implemented
init/missing_syscalls.h:1263:2: warning: #warning syscall getcpu not
implemented
init/missing_syscalls.h:1267:2: warning: #warning syscall epoll_pwait not
implemented
init/missing_syscalls.h:1271:2: warning: #warning syscall lutimesat not
implemented
init/missing_syscalls.h:1275:2: warning: #warning syscall revokeat not
implemented
init/missing_syscalls.h:1279:2: warning: #warning syscall frevoke not
implemented
  LD      init/built-in.o
  LD      .tmp_vmlinux1
fs/built-in.o: In function `proc_root_init':
/usr/src/linux/fs/proc/root.c:83: undefined reference to `proc_sys_init'
make: *** [.tmp_vmlinux1] Error 1

Helge Hafting

