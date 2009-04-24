Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZDXJP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZDXJP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZDXJPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:15:11 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:60393 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZDXJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:15:10 -0400
Date: Fri, 24 Apr 2009 06:14:12 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Subject: [2.6.30-rc3][Regression] Compilation failure
Message-ID: <20090424091412.GA15074@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, people.

I'm trying to compile a new kernel for a x86_64 computer using Debian's
sid userland and I'm getting the following error:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(...)
  CC      lib/sha1.o
  CC      lib/show_mem.o
  CC      lib/string.o
  CC      lib/vsprintf.o
  AR      lib/lib.a
  CC      arch/x86/lib/msr-on-cpu.o
  CC      arch/x86/lib/io_64.o
  AS      arch/x86/lib/iomap_copy_64.o
  LD      arch/x86/lib/built-in.o
  AS      arch/x86/lib/clear_page_64.o
  AS      arch/x86/lib/copy_page_64.o
  AS      arch/x86/lib/copy_user_64.o
  AS      arch/x86/lib/copy_user_nocache_64.o
  AS      arch/x86/lib/csum-copy_64.o
  CC      arch/x86/lib/csum-partial_64.o
  CC      arch/x86/lib/csum-wrappers_64.o
  CC      arch/x86/lib/delay.o
  AS      arch/x86/lib/getuser.o
  AS      arch/x86/lib/memcpy_64.o
  CC      arch/x86/lib/memmove_64.o
  AS      arch/x86/lib/memset_64.o
  AS      arch/x86/lib/putuser.o
  AS      arch/x86/lib/rwlock_64.o
  AS      arch/x86/lib/thunk_64.o
  CC      arch/x86/lib/usercopy_64.o
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `intel_opregion_init':
(.text+0x87d2e): undefined reference to `acpi_video_register'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Leaving directory `/usr/local/media/progs/linux/linux'
make: *** [debian/stamp/build/kernel] Error 2
rbrito@chagas:/usr/local/media/progs/linux$
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

In fact, I have not been able to compile a 2.6.30-rc* kernel yet, due to
errors like these. The full .config that I'm using is available at
<http://rb.doesntexist.org/linux/>.

Any help with this regression is more than welcome.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
