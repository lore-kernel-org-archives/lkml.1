Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXHBTm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXHBTm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXHBTmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:42:49 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53796 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbXHBTms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:42:48 -0400
Date: Thu, 2 Aug 2007 21:44:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: blackfin toolchain and build issues
Message-ID: <20070802194405.GB3646@uranus.ravnborg.org>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org> <1185770527.22473.2.camel@roc-desktop> <20070730194335.GE5776@martell.zuzino.mipt.ru> <1185850297.20043.6.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185850297.20043.6.camel@roc-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> Oh, do you need use blackfin toolchain? Actually, it is very simple to
> setup it on your machine.
> please get the latest binary toolchain here:
> http://blackfin.uclinux.org/gf/download/frsrelease/344/3180/blackfin-toolchain-uclinux-SVN.tar.bz2
> http://blackfin.uclinux.org/gf/download/frsrelease/344/3181/blackfin-toolchain-linux-uclibc-SVN.tar.bz2

Thanks - installed.

While building latest git tree I see several 'funny' errors.
  LD      kernel/built-in.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_futex' changed from 4 in kernel/sys_ni.o to 262 in kernel/futex.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_set_robust_list' changed from 4 in kernel/sys_ni.o to 30 in kernel/futex.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_get_robust_list' changed from 4 in kernel/sys_ni.o to 170 in kernel/futex.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setfsgid16' changed from 4 in kernel/sys_ni.o to 16 in kernel/uid16.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setfsuid16' changed from 4 in kernel/sys_ni.o to 16 in kernel/uid16.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setresgid16' changed from 4 in kernel/sys_ni.o to 36 in kernel/uid16.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setresuid16' changed from 4 in kernel/sys_ni.o to 36 in kernel/uid16.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setuid16' changed from 4 in kernel/sys_ni.o to 16 in kernel/uid16.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_setreuid16' changed from 4 in kernel/sys_ni.o to 26 in kernel/uid16.o
...

and later:

  LD      .tmp_vmlinux1
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_mremap' changed from 4 in kernel/built-in.o to 82 in mm/built-in.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_ioprio_set' changed from 4 in kernel/built-in.o to 362 in fs/built-in.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_epoll_wait' changed from 4 in kernel/built-in.o to 1002 in fs/built-in.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_timerfd' changed from 4 in kernel/built-in.o to 346 in fs/built-in.o
bfin-linux-uclibc-ld: Warning: size of symbol `_sys_ioprio_get' changed from 4 in kernel/built-in.o to 344 in fs/built-in.o



I did not look into these. I assume it is a toolchain issue??

PS. I had to fix a few things to get so far but as I did not do
it the right way I have no patch.

	Sam
