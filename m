Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZFGIrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZFGIrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFGIq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:46:59 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:57783 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZFGIq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:46:59 -0400
To: avi@redhat.com
Cc: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200906050539.n555dwAQ077095@www262.sakura.ne.jp>
	<4A2B5D0E.20002@redhat.com>
	<200906071638.CIC52145.OFOQHLFSMOJVFt@I-love.SAKURA.ne.jp>
	<4A2B7A79.4060600@redhat.com>
In-Reply-To: <4A2B7A79.4060600@redhat.com>
Message-Id: <200906071747.FFJ57396.MSOOQFVHtFOJLF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 7 Jun 2009 17:47:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Does the attached patch help?
Unfortunately, no.

# gcc -v
Reading specs from /usr/lib/gcc-lib/i486-linux/3.3.5/specs
Configured with: ../src/configure -v --enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-gxx-include-dir=/usr/include/c++/3.3 --enable-shared --enable-__cxa_atexit --with-system-zlib --enable-nls --without-included-gettext --enable-clocale=gnu --enable-debug --enable-java-gc=boehm --enable-java-awt=xlib --enable-objc-gc i486-linux
Thread model: posix
gcc version 3.3.5 (Debian 1:3.3.5-13)
# make arch/x86/kvm/x86_emulate.o
/usr/src/linux-2.6.30-rc8/arch/x86/Makefile:82: stack protector enabled but no compiler support
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC [M]  arch/x86/kvm/x86_emulate.o
gcc: Internal error: Segmentation fault (program cc1)
Please submit a full bug report.
See <URL:http://gcc.gnu.org/bugs.html> for instructions.
For Debian GNU/Linux specific bug reporting instructions,
see <URL:file:///usr/share/doc/gcc-3.3/README.Bugs>.

{standard input}: Assembler messages:
{standard input}:4331: Warning: end of file not at end of a line; newline inserted
make[1]: *** [arch/x86/kvm/x86_emulate.o] Error 1
make: *** [arch/x86/kvm/x86_emulate.o] Error 2
